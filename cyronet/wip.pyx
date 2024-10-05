# cython: language_level=3
# cython: cdivision=True
from distutils.command.upload import upload

from libc.stdint cimport uint8_t
from libc.stdio cimport  stderr, fprintf

from cpython.unicode cimport PyUnicode_FromString, PyUnicode_AsUTF8
from cpython.object cimport PyObject
from cpython.bytes cimport PyBytes_AS_STRING, PyBytes_FromStringAndSize, PyBytes_GET_SIZE
from cpython.mem cimport PyMem_Malloc, PyMem_Free
from cpython.pycapsule cimport PyCapsule_GetPointer, PyCapsule_New

cimport cython
from .cronet cimport *

cdef inline bytes ensure_bytes(object s):
    if isinstance(s, str):
        return s.encode()
    elif isinstance(s, (bytearray, memoryview)):
        return bytes(s)
    else:
        return s

cdef struct RequestContext:
    Cronet_UrlRequestCallback * callback
    PyObject * pycallback
    bint allow_redirects

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class Buffer:
    cdef:
        Cronet_Buffer * _ptr
        Py_ssize_t[1] shape
        Py_ssize_t[1] strides

    def __cinit__(self):
        self._ptr = Cronet_Buffer_Create()
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_Buffer_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline set_client_context(self, object client_context):
        Cronet_Buffer_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_Buffer_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline init_with_data_and_callback(self, object data, uint64_t size, BufferCallback callback):
        Cronet_Buffer_InitWithDataAndCallback(self._ptr, PyCapsule_GetPointer(data, NULL), size, callback._ptr)

    cpdef inline init_with_alloc(self, uint64_t size):
        Cronet_Buffer_InitWithAlloc(self._ptr, size)

    def __len__(self):
        return Cronet_Buffer_GetSize(self._ptr)

    def get_data(self):
        return PyCapsule_New(Cronet_Buffer_GetData(self._ptr), NULL, NULL)

    def __getbuffer__(self, Py_buffer *buffer, int flags):
        cdef Py_ssize_t itemsize = sizeof(uint8_t)

        self.shape[0] = <Py_ssize_t> Cronet_Buffer_GetSize(self._ptr)

        # Stride 1 is the distance, in bytes, between two items in a row;
        # this is the distance between two adjacent items in the vector.
        # Stride 0 is the distance between the first elements of adjacent rows.
        self.strides[0] = itemsize

        buffer.buf = <char *> Cronet_Buffer_GetData(self._ptr)
        buffer.format = 'B'  # uchar
        buffer.internal = NULL  # see References
        buffer.itemsize = itemsize
        buffer.len = self.shape[0]  # product(shape) * itemsize
        buffer.ndim = 1
        buffer.obj = self
        buffer.readonly = 0
        buffer.shape = self.shape
        buffer.strides = self.strides
        buffer.suboffsets = NULL  # for pointer arrays only

    def __releasebuffer__(self, Py_buffer *buffer):
        pass

cdef void buffer_dealloc(Cronet_BufferCallback * self,
                         Cronet_Buffer * buffer) noexcept nogil:
    fprintf(stderr, "buffer_dealloc %p \n", buffer)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class BufferCallback:
    cdef Cronet_BufferCallback * _ptr

    def __cinit__(self):  # fixme
        self._ptr = Cronet_BufferCallback_CreateWith(buffer_dealloc)
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_BufferCallback_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_BufferCallback_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, object client_context):
        Cronet_BufferCallback_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    cpdef inline on_destroy(self, Buffer buffer):
        Cronet_BufferCallback_OnDestroy(self._ptr, buffer._ptr)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class Runnable:
    cdef Cronet_Runnable * _ptr

    def __cinit__(self, Cronet_Runnable_RunFunc run_func):
        self._ptr = Cronet_Runnable_CreateWith(run_func)
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_Runnable_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_Runnable_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, object client_context):
        Cronet_Runnable_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    def run(self):
        Cronet_Runnable_Run(self._ptr)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class Executor:
    cdef Cronet_Executor * _ptr

    # def __cinit__(self, Cronet_Executor_ExecuteFunc execute_func):
    #     self._ptr = Cronet_Executor_CreateWith(execute_func)
    #     if self._ptr == NULL:
    #         raise MemoryError

    @staticmethod
    cdef inline Executor from_ptr(Cronet_Executor * _ptr):
        cdef Executor self = Executor.__new__(Executor)
        self._ptr = _ptr
        return self

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_Executor_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_Executor_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, object client_context):
        Cronet_Executor_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    def execute(self, Cronet_Runnable * command):
        Cronet_Executor_Execute(self._ptr, command)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class Engine:
    cdef Cronet_Engine * _ptr

    def __cinit__(self):
        self._ptr = Cronet_Engine_Create()
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_Engine_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_Engine_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, object client_context):  # fixme def的c结构
        Cronet_Engine_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    def start_with_params(self, EngineParams params):  # fixme def的c结构
        return Cronet_Engine_StartWithParams(self._ptr, params._ptr)

    def start_net_log_to_file(self, str file_name, bint log_all):
        cdef bytes file_name_b = ensure_bytes(file_name)
        return Cronet_Engine_StartNetLogToFile(self._ptr, PyBytes_AS_STRING(file_name_b), log_all)

    def stop_net_log(self):
        Cronet_Engine_StopNetLog(self._ptr)

    def shutdown(self):
        return Cronet_Engine_Shutdown(self._ptr)

    @property
    def version_string(self):
        return Cronet_Engine_GetVersionString(self._ptr)

    @property
    def default_user_agent(self):
        return Cronet_Engine_GetDefaultUserAgent(self._ptr)


    cpdef UrlRequest request(self, object pycallback):
        cdef UrlRequest r = UrlRequest()
        cdef UrlRequestParams params = UrlRequestParams()
        cdef object pyrequest = pycallback.request
        params.http_method = pyrequest.method
        cdef const char * key
        cdef const char * val
        cdef HttpHeader request_header
        for k, v in pyrequest.headers.items:
            request_header = HttpHeader()
            request_header.name = k
            request_header.value = v
            params.add_request_headers(request_header)
        cdef UrlRequestCallback callback = UrlRequestCallback()
        cdef RequestContext *ctx = <RequestContext*>PyMem_Malloc(sizeof(RequestContext))
        if ctx == NULL:
            raise MemoryError
        ctx.callback = NULL
        ctx.allow_redirects = <bint>pyrequest.allow_redirects
        ctx.pycallback = <PyObject*>pycallback
        if hasattr(pyrequest, "content"):
            upload_ctx = UploadProviderContext()
            upload_ctx.content = <const char*>pyrequest.content
            upload_ctx.upload_size = PyBytes_GET_SIZE(pyrequest.content)
            upload_ctx.upload_bytes_read = 0

            data_provider = UploadDataProvider()
            data_provider.set_client_context(upload_ctx)
            params.upload_data_provider = data_provider
            pass # todo 未完待续 https://github.com/lagenar/python-cronet/blob/main/src/cronet/_cronet.c#477




    # def add_request_finished_listener(self, Cronet_RequestFinishedInfoListener* listener,
    #                                   Cronet_Executor* executor):
    #     Cronet_Engine_AddRequestFinishedListener(self._ptr, listener, executor)
    #
    # def remove_request_finished_listener(self, Cronet_RequestFinishedInfoListener* listener):
    #     Cronet_Engine_RemoveRequestFinishedListener(self._ptr, listener)

# @cython.final
# @cython.freelist(8)
# @cython.no_gc
# cdef class UrlRequestStatusListener:
#     cdef Cronet_UrlRequestStatusListener * _ptr
#
#     def __cinit__(self, Cronet_UrlRequestStatusListener_OnStatusFunc on_status_func):  # fixme def的c结构
#         self._ptr = Cronet_UrlRequestStatusListener_CreateWith(on_status_func)
#         if self._ptr == NULL:
#             raise MemoryError
#
#     def __dealloc__(self):
#         if self._ptr != NULL:
#             Cronet_UrlRequestStatusListener_Destroy(self._ptr)
#             self._ptr = NULL
#
#     cpdef inline object get_client_context(self):
#         return PyCapsule_New(Cronet_UrlRequestStatusListener_GetClientContext(self._ptr), NULL, NULL)
#
#     cpdef inline set_client_context(self, RequestContext client_context):  # fixme def的c结构
#         Cronet_UrlRequestStatusListener_SetClientContext(self._ptr, client_context)
#
#     cpdef inline on_status(self, Cronet_UrlRequestStatusListener_Status status):
#         Cronet_UrlRequestStatusListener_OnStatus(self._ptr, status)

# TODO: noexcept nogil
cdef void UrlRequestCallback_OnRedirectReceivedFunc(
        Cronet_UrlRequestCallback * self,
        Cronet_UrlRequest * request,
        Cronet_UrlResponseInfo * info,
        Cronet_String new_location_url) noexcept with gil:
    cdef:
        RequestContext * ctx = <RequestContext *> Cronet_UrlRequest_GetClientContext(request)
        const char * url = Cronet_UrlResponseInfo_url_get(info)
        int32_t statuscode = Cronet_UrlResponseInfo_http_status_code_get(info)
        uint32_t headersize = Cronet_UrlResponseInfo_all_headers_list_size(info)
        Cronet_HttpHeader * tmpheader
        object pycallback = <object> ctx.pycallback
        uint32_t i

    headers = []
    for i in range(headersize):
        tmpheader = Cronet_UrlResponseInfo_all_headers_list_at(info, i)
        headers.append((PyUnicode_FromString(Cronet_HttpHeader_name_get(tmpheader)),
                        PyUnicode_FromString(Cronet_HttpHeader_value_get(tmpheader))))  # TODO: use multimap?
    try:
        pycallback.on_redirect_received(PyUnicode_FromString(url), PyUnicode_FromString(new_location_url), statuscode,
                                        headers)
    except:
        pass

    if ctx.allow_redirects:
        Cronet_UrlRequest_FollowRedirect(request)
    else:
        Cronet_UrlRequest_Cancel(request)


# TODO: noexpect nogil
# Cronet_UrlRequestCallback_OnResponseStartedFunc
cdef void UrlRequestCallback_OnResponseStartedFunc(
        Cronet_UrlRequestCallback * self,
        Cronet_UrlRequest * request,
        Cronet_UrlResponseInfo * info) noexcept with gil:
    cdef:
        RequestContext * ctx = <RequestContext *> Cronet_UrlRequest_GetClientContext(request)
        const char * url = Cronet_UrlResponseInfo_url_get(info)
        int32_t statuscode = Cronet_UrlResponseInfo_http_status_code_get(info)
        uint32_t headersize = Cronet_UrlResponseInfo_all_headers_list_size(info)
        Cronet_HttpHeader * tmpheader
        object pycallback = <object> ctx.pycallback
        uint32_t i
    headers = []
    for i in range(headersize):
        tmpheader = Cronet_UrlResponseInfo_all_headers_list_at(info, i)
        headers.append((PyUnicode_FromString(Cronet_HttpHeader_name_get(tmpheader)),
                        PyUnicode_FromString(Cronet_HttpHeader_value_get(tmpheader))))
    try:
        pycallback.on_response_started(
            PyUnicode_FromString(url), statuscode, headers
        )
    except Exception as e:
        fprintf(stderr, "%s\n", PyBytes_AS_STRING(ensure_bytes(str(e)))) # traceback.format_exc?

# Cronet_UrlRequestCallback_OnReadCompletedFunc

cdef void UrlRequestCallback_OnReadCompletedFunc(
        Cronet_UrlRequestCallback * self,
        Cronet_UrlRequest * request,
        Cronet_UrlResponseInfo * info,
        Cronet_Buffer * buffer,
        uint64_t bytes_read) noexcept with gil:
    cdef:
        RequestContext * ctx = <RequestContext *> Cronet_UrlRequest_GetClientContext(request)
        const char * data = <const char *> Cronet_Buffer_GetData(buffer)
        object pycallback = <object> ctx.pycallback
        bytes py_data = PyBytes_FromStringAndSize(data, bytes_read) # 这里不是借用，不用PyObjet*

    try:
        pycallback.on_read_completed(py_data)
    except Exception as e:
        fprintf(stderr, "%s\n", PyBytes_AS_STRING(ensure_bytes(str(e))))

# Cronet_UrlRequestCallback_OnSucceededFunc
cdef void UrlRequestCallback_OnSucceededFunc(
        Cronet_UrlRequestCallback * self,
        Cronet_UrlRequest * request,
        Cronet_UrlResponseInfo * info) noexcept with gil:
    cdef:
        RequestContext * ctx = <RequestContext *> Cronet_UrlRequest_GetClientContext(request)
        object pycallback = <object> ctx.pycallback # 这里就是incref， RequestContext不是Py对象，要自己处理

    try:
        pycallback.on_succeeded()
    except Exception as e:
        fprintf(stderr, "%s\n", PyBytes_AS_STRING(ensure_bytes(str(e))))
    finally:
        if ctx.callback != NULL:
            Cronet_UrlRequestCallback_Destroy(ctx.callback)

        PyMem_Free(ctx)
        Cronet_UrlRequest_Destroy(request)


# Cronet_UrlRequestCallback_OnFailedFunc
cdef void UrlRequestCallback_OnFailedFunc(
        Cronet_UrlRequestCallback * self,
        Cronet_UrlRequest * request,
        Cronet_UrlResponseInfo * info,
        Cronet_Error * error) noexcept with gil:
    cdef:
        RequestContext * ctx = <RequestContext *> Cronet_UrlRequest_GetClientContext(request)
        object pycallback = <object> ctx.pycallback
        Error err = Error.from_ptr(error)

    try:
        pycallback.on_failed(err)
    except Exception as e:
        fprintf(stderr, "%s\n", PyBytes_AS_STRING(ensure_bytes(str(e))))
    finally:
        if ctx.callback != NULL:
            Cronet_UrlRequestCallback_Destroy(ctx.callback)

        PyMem_Free(ctx)
        Cronet_UrlRequest_Destroy(request)


# Cronet_UrlRequestCallback_OnCanceledFunc
cdef void UrlRequestCallback_OnCanceledFunc(
        Cronet_UrlRequestCallback * self,
        Cronet_UrlRequest * request,
        Cronet_UrlResponseInfo * info) noexcept with gil:
    cdef:
        RequestContext * ctx = <RequestContext *> Cronet_UrlRequest_GetClientContext(request)
        object pycallback = <object> ctx.pycallback
        UrlResponseInfo response_info = UrlResponseInfo.from_ptr(info)

    try:
        pycallback.on_canceled(response_info)
    except Exception as e:
        fprintf(stderr, "%s\n", PyBytes_AS_STRING(ensure_bytes(str(e))))
    finally:
        if ctx.callback != NULL:
            Cronet_UrlRequestCallback_Destroy(ctx.callback)

        PyMem_Free(ctx)
        Cronet_UrlRequest_Destroy(request)

cdef class UploadProviderContext:
    cdef public:
        size_t upload_size
        size_t upload_bytes_read
    cdef const char *content

    @property
    def _content(self):
        return PyBytes_FromStringAndSize(self.content, self.upload_size)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class UrlRequestCallback:
    cdef Cronet_UrlRequestCallback * _ptr

    def __cinit__(self):
        self._ptr = Cronet_UrlRequestCallback_CreateWith(UrlRequestCallback_OnRedirectReceivedFunc,
                                                         UrlRequestCallback_OnResponseStartedFunc,
                                                         UrlRequestCallback_OnReadCompletedFunc,
                                                         UrlRequestCallback_OnSucceededFunc,
                                                         UrlRequestCallback_OnFailedFunc,
                                                         UrlRequestCallback_OnCanceledFunc)
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_UrlRequestCallback_Destroy(self._ptr) # fixme 这里在callback中释放了
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_UrlRequestCallback_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, object client_context):  # fixme def的c结构
        Cronet_UrlRequestCallback_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    # TODO: WTF 下面这堆是干什么的？
    # 为什么 pycharm 会把上面构造的 pycallback 解析到这里？

    def on_redirect_received(self, UrlRequest request, UrlResponseInfo info,
                             str new_location_url):  # fixme def的c结构
        cdef bytes new_location_url_b = ensure_bytes(new_location_url)
        Cronet_UrlRequestCallback_OnRedirectReceived(self._ptr, request._ptr, info._ptr,
                                                     PyBytes_AS_STRING(new_location_url_b))

    def on_response_started(self, Cronet_UrlRequest * request, Cronet_UrlResponseInfo * info):
        Cronet_UrlRequestCallback_OnResponseStarted(self._ptr, request, info)

    def on_read_completed(self, Cronet_UrlRequest * request, Cronet_UrlResponseInfo * info, Cronet_Buffer * buffer,
                          uint64_t bytes_read):
        Cronet_UrlRequestCallback_OnReadCompleted(self._ptr, request, info, buffer, bytes_read)

    def on_succeeded(self, Cronet_UrlRequest * request, Cronet_UrlResponseInfo * info):
        Cronet_UrlRequestCallback_OnSucceeded(self._ptr, request, info)

    def on_failed(self, Cronet_UrlRequest * request, Cronet_UrlResponseInfo * info, Cronet_Error * error):
        Cronet_UrlRequestCallback_OnFailed(self._ptr, request, info, error)

    def on_canceled(self, Cronet_UrlRequest * request, Cronet_UrlResponseInfo * info):
        Cronet_UrlRequestCallback_OnCanceled(self._ptr, request, info)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class UploadDataSink:
    cdef Cronet_UploadDataSink * _ptr

    # def __cinit__(self):
    #     self._ptr = Cronet_UploadDataSink_Create()
    #     if self._ptr == NULL:
    #         raise MemoryError

    @staticmethod
    cdef inline UploadDataSink from_ptr(Cronet_UploadDataSink * _ptr):
        cdef UploadDataSink self = UploadDataSink.__new__(UploadDataSink)
        self._ptr = _ptr
        return self

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_UploadDataSink_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_UploadDataSink_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, object client_context):  # fixme def的c结构
        Cronet_UploadDataSink_SetClientContext(self._ptr, <RequestContext *> PyCapsule_GetPointer(client_context, NULL))

    def on_read_succeeded(self, uint64_t bytes_read, bint final_chunk):
        Cronet_UploadDataSink_OnReadSucceeded(self._ptr, bytes_read, final_chunk)

    def on_read_error(self, str error_message):
        cdef bytes error_message_b = ensure_bytes(error_message)
        Cronet_UploadDataSink_OnReadError(self._ptr,
                                          PyBytes_AS_STRING(error_message_b))

    def on_rewind_succeeded(self):
        Cronet_UploadDataSink_OnRewindSucceeded(self._ptr)

    def on_rewind_error(self, str error_message):
        cdef bytes error_message_b = ensure_bytes(error_message)
        Cronet_UploadDataSink_OnRewindError(self._ptr, PyBytes_AS_STRING(error_message_b))

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class UploadDataProvider:
    cdef Cronet_UploadDataProvider * _ptr
    cdef UploadProviderContext ctx

    def __cinit__(self, Cronet_UploadDataProvider_GetLengthFunc GetLengthFunc,
                  Cronet_UploadDataProvider_ReadFunc ReadFunc,
                  Cronet_UploadDataProvider_RewindFunc RewindFunc,
                  Cronet_UploadDataProvider_CloseFunc CloseFunc):
        self._ptr = Cronet_UploadDataProvider_CreateWith(GetLengthFunc, ReadFunc, RewindFunc, CloseFunc)
        if self._ptr == NULL:
            raise MemoryError

    @staticmethod
    cdef inline UploadDataProvider from_ptr(Cronet_UploadDataProvider * _ptr):
        cdef UploadDataProvider self = UploadDataProvider.__new__(UploadDataProvider)
        self._ptr = _ptr
        return self

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_UploadDataProvider_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_UploadDataProvider_GetClientContext(self._ptr), NULL, NULL)

    cpdef inline set_client_context(self, UploadProviderContext ctx):  # FIXME
        self.ctx = ctx # 绑定生命周期 incref
        Cronet_UploadDataProvider_SetClientContext(self._ptr, <void*>ctx)

    @property
    def length(self):
        return Cronet_UploadDataProvider_GetLength(self._ptr)

    def read(self, UploadDataSink upload_data_sink, Buffer buffer):
        Cronet_UploadDataProvider_Read(self._ptr, upload_data_sink._ptr, buffer._ptr)

    def rewind(self, UploadDataSink upload_data_sink):
        Cronet_UploadDataProvider_Rewind(self._ptr, upload_data_sink._ptr)

    def close(self):
        Cronet_UploadDataProvider_Close(self._ptr)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class UrlRequest:
    cdef Cronet_UrlRequest * _ptr

    def __cinit__(self):
        self._ptr = Cronet_UrlRequest_Create()
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_UrlRequest_Destroy(self._ptr)
            self._ptr = NULL

    cpdef inline object get_client_context(self):
        return PyCapsule_New(Cronet_UrlRequest_GetClientContext(self._ptr), NULL, NULL)

    cdef inline set_client_context(self, RequestContext * client_context): # 只对C可见
        Cronet_UrlRequest_SetClientContext(self._ptr, client_context)

    def init_with_params(self, Cronet_Engine * engine, str url, Cronet_UrlRequestParams * params,
                         Cronet_UrlRequestCallback * callback, Cronet_Executor * executor):
        cdef bytes url_b = ensure_bytes(url)
        return Cronet_UrlRequest_InitWithParams(self._ptr, engine, PyBytes_AS_STRING(url_b), params, callback, executor)

    def start(self):
        return Cronet_UrlRequest_Start(self._ptr)

    def follow_redirect(self):
        return Cronet_UrlRequest_FollowRedirect(self._ptr)

    def read(self, Buffer buffer):
        return Cronet_UrlRequest_Read(self._ptr, buffer._ptr)

    def cancel(self):
        Cronet_UrlRequest_Cancel(self._ptr)

    def is_done(self):
        return Cronet_UrlRequest_IsDone(self._ptr)

    def get_status(self, Cronet_UrlRequestStatusListener * listener):  # fixme
        Cronet_UrlRequest_GetStatus(self._ptr, listener)

# @cython.final
# @cython.freelist(8)
# @cython.no_gc
# cdef class RequestFinishedInfoListener:
#     cdef Cronet_RequestFinishedInfoListener* _ptr
#
#     def __cinit__(self, Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc OnRequestFinishedFunc):
#         self._ptr = Cronet_RequestFinishedInfoListener_CreateWith(OnRequestFinishedFunc)
#         if self._ptr == NULL:
#             raise MemoryError
#
#     def __dealloc__(self):
#         if self._ptr != NULL:
#             Cronet_RequestFinishedInfoListener_Destroy(self._ptr)
#             self._ptr = NULL
#
#     def set_client_context(self, RequestContext client_context):
#         Cronet_RequestFinishedInfoListener_SetClientContext(self._ptr, client_context)
#
#     def get_client_context(self):
#         return Cronet_RequestFinishedInfoListener_GetClientContext(self._ptr)
#
#     def on_request_finished(self, Cronet_RequestFinishedInfo* request_info, Cronet_UrlResponseInfo* response_info,
#                             Cronet_Error* error):
#         Cronet_RequestFinishedInfoListener_OnRequestFinished(self._ptr, request_info, response_info, error)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class Error:
    cdef Cronet_Error * _ptr

    # def __cinit__(self):
    #     self._ptr = Cronet_Error_Create()
    #     if self._ptr == NULL:
    #         raise MemoryError

    @staticmethod
    cdef inline Error from_ptr(Cronet_Error * _ptr):
        cdef Error self = Error.__new__(Error)
        self._ptr = _ptr
        return self

    def __dealloc__(self):
        # using CronetError = base::RefCountedData<Cronet_Error>;
        if self._ptr != NULL: # FIXME: 可以释放别人的ptr吗
            Cronet_Error_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def error_code(self):
        return Cronet_Error_error_code_get(self._ptr)

    @property
    def message(self):
        return Cronet_Error_message_get(self._ptr)

    @property
    def internal_error_code(self):
        return Cronet_Error_internal_error_code_get(self._ptr)

    @property
    def immediately_retryable(self):
        return Cronet_Error_immediately_retryable_get(self._ptr)

    @property
    def quic_detailed_error_code(self):
        return Cronet_Error_quic_detailed_error_code_get(self._ptr)

    @error_code.setter
    def error_code(self, Cronet_Error_ERROR_CODE error_code):
        Cronet_Error_error_code_set(self._ptr, error_code)

    @message.setter
    def message(self, str message):
        cdef bytes message_b = ensure_bytes(message)
        Cronet_Error_message_set(self._ptr, PyBytes_AS_STRING(message_b))

    @internal_error_code.setter
    def internal_error_code(self, int32_t internal_error_code):
        Cronet_Error_internal_error_code_set(self._ptr, internal_error_code)

    @immediately_retryable.setter
    def immediately_retryable(self, bint immediately_retryable):
        Cronet_Error_immediately_retryable_set(self._ptr, immediately_retryable)

    @quic_detailed_error_code.setter
    def quic_detailed_error_code(self, int32_t quic_detailed_error_code):
        Cronet_Error_quic_detailed_error_code_set(self._ptr, quic_detailed_error_code)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class QuicHint:
    cdef Cronet_QuicHint * _ptr

    @staticmethod
    cdef inline QuicHint from_ptr(Cronet_QuicHint * _ptr):
        cdef QuicHint self = QuicHint.__new__(QuicHint)
        self._ptr = _ptr
        return self
    # def __cinit__(self, Cronet_QuicHint* ptr = NULL):
    #     if ptr != NULL:
    #         self._ptr = ptr
    #     else:
    #         self._ptr = Cronet_QuicHint_Create()
    #
    #     if self._ptr == NULL:
    #         raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_QuicHint_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def host(self):
        return Cronet_QuicHint_host_get(self._ptr)

    @property
    def port(self):
        return Cronet_QuicHint_port_get(self._ptr)

    @property
    def alternate_port(self):
        return Cronet_QuicHint_alternate_port_get(self._ptr)

    @host.setter
    def host(self, str host):
        cdef bytes host_b = ensure_bytes(host)
        Cronet_QuicHint_host_set(self._ptr, PyBytes_AS_STRING(host_b))

    @port.setter
    def port(self, int32_t port):
        Cronet_QuicHint_port_set(self._ptr, port)

    @alternate_port.setter
    def alternate_port(self, int32_t alternate_port):
        Cronet_QuicHint_alternate_port_set(self._ptr, alternate_port)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class PublicKeyPins:
    cdef Cronet_PublicKeyPins * _ptr

    @staticmethod
    cdef inline PublicKeyPins from_ptr(Cronet_PublicKeyPins * _ptr):
        cdef PublicKeyPins self = PublicKeyPins.__new__(PublicKeyPins)
        self._ptr = _ptr
        return self

    # def __cinit__(self):
    #     self._ptr = Cronet_PublicKeyPins_Create()
    #     if self._ptr == NULL:
    #         raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_PublicKeyPins_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def host(self):
        return Cronet_PublicKeyPins_host_get(self._ptr)

    @property
    def pins_sha256_size(self):
        return Cronet_PublicKeyPins_pins_sha256_size(self._ptr)

    def pins_sha256_at(self, uint32_t index):
        return Cronet_PublicKeyPins_pins_sha256_at(self._ptr, index)

    def add_pins_sha256(self, str element):
        cdef bytes element_b = ensure_bytes(element)
        Cronet_PublicKeyPins_pins_sha256_add(self._ptr, PyBytes_AS_STRING(element_b))

    def clear_pins_sha256(self):
        Cronet_PublicKeyPins_pins_sha256_clear(self._ptr)

    @property
    def include_subdomains(self):
        return Cronet_PublicKeyPins_include_subdomains_get(self._ptr)

    @property
    def expiration_date(self):
        return Cronet_PublicKeyPins_expiration_date_get(self._ptr)

    @host.setter
    def host(self, str host):
        cdef bytes host_b = ensure_bytes(host)
        Cronet_PublicKeyPins_host_set(self._ptr, PyBytes_AS_STRING(host_b))

    @include_subdomains.setter
    def include_subdomains(self, bint include_subdomains):
        Cronet_PublicKeyPins_include_subdomains_set(self._ptr, include_subdomains)

    @expiration_date.setter
    def expiration_date(self, int64_t expiration_date):
        Cronet_PublicKeyPins_expiration_date_set(self._ptr, expiration_date)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class EngineParams:
    cdef Cronet_EngineParams * _ptr

    # def __cinit__(self):
    #     self._ptr = Cronet_EngineParams_Create()
    #     if self._ptr == NULL:
    #         raise MemoryError

    @staticmethod
    cdef inline EngineParams from_ptr(Cronet_EngineParams * _ptr):
        cdef EngineParams self = EngineParams.__new__(EngineParams)
        self._ptr = _ptr
        return self

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_EngineParams_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def enable_check_result(self):
        return Cronet_EngineParams_enable_check_result_get(self._ptr)

    @enable_check_result.setter
    def enable_check_result(self, bint enable_check_result):
        Cronet_EngineParams_enable_check_result_set(self._ptr, enable_check_result)

    @property
    def user_agent(self):
        return Cronet_EngineParams_user_agent_get(self._ptr)

    @user_agent.setter
    def user_agent(self, str user_agent):
        cdef bytes user_agent_b = ensure_bytes(user_agent)
        Cronet_EngineParams_user_agent_set(self._ptr, PyBytes_AS_STRING(user_agent_b))

    @property
    def accept_language(self):
        return Cronet_EngineParams_accept_language_get(self._ptr)

    @accept_language.setter
    def accept_language(self, str accept_language):
        cdef bytes accept_language_b = ensure_bytes(accept_language)
        Cronet_EngineParams_accept_language_set(self._ptr, PyBytes_AS_STRING(accept_language_b))

    @property
    def storage_path(self):
        return Cronet_EngineParams_storage_path_get(self._ptr)

    @storage_path.setter
    def storage_path(self, str storage_path):
        cdef bytes storage_path_b = ensure_bytes(storage_path)
        Cronet_EngineParams_storage_path_set(self._ptr, PyBytes_AS_STRING(storage_path_b))

    @property
    def enable_quic(self):
        return Cronet_EngineParams_enable_quic_get(self._ptr)

    @enable_quic.setter
    def enable_quic(self, bint enable_quic):
        Cronet_EngineParams_enable_quic_set(self._ptr, enable_quic)

    @property
    def enable_http2(self):
        return Cronet_EngineParams_enable_http2_get(self._ptr)

    @enable_http2.setter
    def enable_http2(self, bint enable_http2):
        Cronet_EngineParams_enable_http2_set(self._ptr, enable_http2)

    @property
    def enable_brotli(self):
        return Cronet_EngineParams_enable_brotli_get(self._ptr)

    @enable_brotli.setter
    def enable_brotli(self, bint enable_brotli):
        Cronet_EngineParams_enable_brotli_set(self._ptr, enable_brotli)

    @property
    def http_cache_mode(self):
        return Cronet_EngineParams_http_cache_mode_get(self._ptr)

    @http_cache_mode.setter
    def http_cache_mode(self, Cronet_EngineParams_HTTP_CACHE_MODE http_cache_mode):
        Cronet_EngineParams_http_cache_mode_set(self._ptr, http_cache_mode)

    @property
    def http_cache_max_size(self):
        return Cronet_EngineParams_http_cache_max_size_get(self._ptr)

    @http_cache_max_size.setter
    def http_cache_max_size(self, int64_t http_cache_max_size):
        Cronet_EngineParams_http_cache_max_size_set(self._ptr, http_cache_max_size)

    @property
    def quic_hints_size(self):
        return Cronet_EngineParams_quic_hints_size(self._ptr)

    def get_quic_hints_at(self, uint32_t index):
        return QuicHint.from_ptr(Cronet_EngineParams_quic_hints_at(self._ptr, index))

    def add_quic_hints(self, Cronet_QuicHint * element):
        Cronet_EngineParams_quic_hints_add(self._ptr, element)

    def clear_quic_hints(self):
        Cronet_EngineParams_quic_hints_clear(self._ptr)

    @property
    def public_key_pins_size(self):
        return Cronet_EngineParams_public_key_pins_size(self._ptr)

    def get_public_key_pins_at(self, uint32_t index):
        return PublicKeyPins.from_ptr(Cronet_EngineParams_public_key_pins_at(self._ptr, index))

    def add_public_key_pins(self, Cronet_PublicKeyPins * element):
        Cronet_EngineParams_public_key_pins_add(self._ptr, element)

    def clear_public_key_pins(self):
        Cronet_EngineParams_public_key_pins_clear(self._ptr)

    @property
    def enable_public_key_pinning_bypass_for_local_trust_anchors(self):
        return Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_get(self._ptr)

    @enable_public_key_pinning_bypass_for_local_trust_anchors.setter
    def enable_public_key_pinning_bypass_for_local_trust_anchors(self, bint enable):
        Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_set(self._ptr, enable)

    @property
    def network_thread_priority(self):
        return Cronet_EngineParams_network_thread_priority_get(self._ptr)

    @network_thread_priority.setter
    def network_thread_priority(self, double network_thread_priority):
        Cronet_EngineParams_network_thread_priority_set(self._ptr, network_thread_priority)

    @property
    def experimental_options(self):
        return Cronet_EngineParams_experimental_options_get(self._ptr)

    @experimental_options.setter
    def experimental_options(self, str experimental_options):
        cdef bytes experimental_options_b = ensure_bytes(experimental_options)
        Cronet_EngineParams_experimental_options_set(self._ptr, PyBytes_AS_STRING(experimental_options_b))

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class HttpHeader:
    cdef Cronet_HttpHeader * _ptr

    def __cinit__(self):
        self._ptr = Cronet_HttpHeader_Create()
        if self._ptr == NULL:
            raise MemoryError

    @staticmethod
    cdef inline HttpHeader from_ptr(Cronet_HttpHeader * _ptr):
        cdef HttpHeader self = HttpHeader.__new__(HttpHeader)
        self._ptr = _ptr
        return self

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_HttpHeader_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def name(self):
        return Cronet_HttpHeader_name_get(self._ptr)

    @name.setter
    def name(self, str name):
        cdef bytes name_b = ensure_bytes(name)
        Cronet_HttpHeader_name_set(self._ptr, PyBytes_AS_STRING(name_b))

    @property
    def value(self):
        return Cronet_HttpHeader_value_get(self._ptr)

    @value.setter
    def value(self, str value):
        cdef bytes value_b = ensure_bytes(value)
        Cronet_HttpHeader_value_set(self._ptr, PyBytes_AS_STRING(value_b))

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class UrlResponseInfo:
    cdef Cronet_UrlResponseInfo * _ptr

    @staticmethod
    cdef inline UrlResponseInfo from_ptr(Cronet_UrlResponseInfo * _ptr):
        cdef UrlResponseInfo self = UrlResponseInfo.__new__(UrlResponseInfo)
        self._ptr = _ptr
        return self

    # def __cinit__(self):
    #     self._ptr = Cronet_UrlResponseInfo_Create()
    #     if self._ptr == NULL:
    #         raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_UrlResponseInfo_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def url(self):
        return Cronet_UrlResponseInfo_url_get(self._ptr)

    @property
    def url_chain_size(self):
        return Cronet_UrlResponseInfo_url_chain_size(self._ptr)

    def get_url_chain_at(self, uint32_t index):
        return Cronet_UrlResponseInfo_url_chain_at(self._ptr, index)

    def clear_url_chain(self):
        Cronet_UrlResponseInfo_url_chain_clear(self._ptr)

    @property
    def http_status_code(self):
        return Cronet_UrlResponseInfo_http_status_code_get(self._ptr)

    @property
    def http_status_text(self):
        return Cronet_UrlResponseInfo_http_status_text_get(self._ptr)

    @property
    def all_headers_list_size(self):
        return Cronet_UrlResponseInfo_all_headers_list_size(self._ptr)

    def get_all_headers_list_at(self, uint32_t index):
        return HttpHeader.from_ptr(Cronet_UrlResponseInfo_all_headers_list_at(self._ptr, index))

    def clear_all_headers_list(self):
        Cronet_UrlResponseInfo_all_headers_list_clear(self._ptr)

    @property
    def was_cached(self):
        return Cronet_UrlResponseInfo_was_cached_get(self._ptr)

    @property
    def negotiated_protocol(self):
        return Cronet_UrlResponseInfo_negotiated_protocol_get(self._ptr)  # fixme

    @property
    def proxy_server(self):
        return Cronet_UrlResponseInfo_proxy_server_get(self._ptr)  # fixme

    @property
    def received_byte_count(self):
        return Cronet_UrlResponseInfo_received_byte_count_get(self._ptr)

    @url.setter
    def url(self, str url):
        cdef bytes url_b = ensure_bytes(url)
        Cronet_UrlResponseInfo_url_set(self._ptr, PyBytes_AS_STRING(url_b))

    def add_url_chain(self, str element):
        cdef bytes element_b = ensure_bytes(element)
        Cronet_UrlResponseInfo_url_chain_add(self._ptr, PyBytes_AS_STRING(element_b))

    @http_status_code.setter
    def http_status_code(self, int32_t http_status_code):
        Cronet_UrlResponseInfo_http_status_code_set(self._ptr, http_status_code)

    @http_status_text.setter
    def http_status_text(self, str http_status_text):
        cdef bytes http_status_text_b = ensure_bytes(http_status_text)
        Cronet_UrlResponseInfo_http_status_text_set(self._ptr, PyBytes_AS_STRING(http_status_text_b))

    def add_all_headers_list(self, Cronet_HttpHeader * element):
        Cronet_UrlResponseInfo_all_headers_list_add(self._ptr, element)

    @was_cached.setter
    def was_cached(self, bint was_cached):
        Cronet_UrlResponseInfo_was_cached_set(self._ptr, was_cached)

    @negotiated_protocol.setter
    def negotiated_protocol(self, str negotiated_protocol):
        cdef bytes negotiated_protocol_b = ensure_bytes(negotiated_protocol)
        Cronet_UrlResponseInfo_negotiated_protocol_set(self._ptr, PyBytes_AS_STRING(negotiated_protocol_b))

    @proxy_server.setter
    def proxy_server(self, str proxy_server):
        cdef bytes proxy_server_b = ensure_bytes(proxy_server)
        Cronet_UrlResponseInfo_proxy_server_set(self._ptr, PyBytes_AS_STRING(proxy_server_b))

    @received_byte_count.setter
    def received_byte_count(self, int64_t received_byte_count):
        Cronet_UrlResponseInfo_received_byte_count_set(self._ptr, received_byte_count)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class UrlRequestParams:
    cdef:
        Cronet_UrlRequestParams * _ptr
        UploadDataProvider upload_data_provider

    @staticmethod
    cdef inline UrlRequestParams from_ptr(Cronet_UrlRequestParams * _ptr):
        cdef UrlRequestParams self = UrlRequestParams.__new__(UrlRequestParams)
        self._ptr = _ptr
        return self

    # def __cinit__(self):
    #     self._ptr = Cronet_UrlRequestParams_Create()
    #     if self._ptr == NULL:
    #         raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            Cronet_UrlRequestParams_Destroy(self._ptr)
            self._ptr = NULL

    @property
    def http_method(self):
        return Cronet_UrlRequestParams_http_method_get(self._ptr)

    @property
    def request_headers_size(self):
        return Cronet_UrlRequestParams_request_headers_size(self._ptr)

    def get_request_headers_at(self, uint32_t index):
        return HttpHeader.from_ptr(Cronet_UrlRequestParams_request_headers_at(self._ptr, index))

    def clear_request_headers(self):
        Cronet_UrlRequestParams_request_headers_clear(self._ptr)

    @property
    def disable_cache(self):
        return Cronet_UrlRequestParams_disable_cache_get(self._ptr)

    @property
    def priority(self):
        return Cronet_UrlRequestParams_priority_get(self._ptr)

    @property
    def upload_data_provider(self):
        return UploadDataProvider.from_ptr(Cronet_UrlRequestParams_upload_data_provider_get(self._ptr))

    @property
    def upload_data_provider_executor(self):
        return Executor.from_ptr(Cronet_UrlRequestParams_upload_data_provider_executor_get(self._ptr))

    @property
    def allow_direct_executor(self):
        return Cronet_UrlRequestParams_allow_direct_executor_get(self._ptr)

    @property
    def annotations_size(self):
        return Cronet_UrlRequestParams_annotations_size(self._ptr)

    def get_annotations_at(self, uint32_t index):
        return PyCapsule_New(Cronet_UrlRequestParams_annotations_at(self._ptr, index), NULL, NULL)

    def clear_annotations(self):
        Cronet_UrlRequestParams_annotations_clear(self._ptr)

    # @property
    # def request_finished_listener(self):
    #     return Cronet_UrlRequestParams_request_finished_listener_get(self._ptr)

    # @property
    # def request_finished_executor(self):
    #     return Cronet_UrlRequestParams_request_finished_executor_get(self._ptr)

    @property
    def idempotency(self):
        return Cronet_UrlRequestParams_idempotency_get(self._ptr)

    @http_method.setter
    def http_method(self, str http_method):
        cdef bytes http_method_b = ensure_bytes(http_method)
        Cronet_UrlRequestParams_http_method_set(self._ptr, PyBytes_AS_STRING(http_method_b))

    cpdef add_request_headers(self, HttpHeader element):
        Cronet_UrlRequestParams_request_headers_add(self._ptr, element._ptr)

    @disable_cache.setter
    def disable_cache(self, bint disable_cache):
        Cronet_UrlRequestParams_disable_cache_set(self._ptr, disable_cache)

    @priority.setter
    def priority(self, Cronet_UrlRequestParams_REQUEST_PRIORITY priority):
        Cronet_UrlRequestParams_priority_set(self._ptr, priority)

    @upload_data_provider.setter
    def upload_data_provider(self, UploadDataProvider upload_data_provider):
        self.upload_data_provider = upload_data_provider # incref
        Cronet_UrlRequestParams_upload_data_provider_set(self._ptr, upload_data_provider._ptr)

    @upload_data_provider_executor.setter
    def upload_data_provider_executor(self, Cronet_Executor * upload_data_provider_executor):  # fixme
        Cronet_UrlRequestParams_upload_data_provider_executor_set(self._ptr, upload_data_provider_executor)

    @allow_direct_executor.setter
    def allow_direct_executor(self, bint allow_direct_executor):
        Cronet_UrlRequestParams_allow_direct_executor_set(self._ptr, allow_direct_executor)

    def add_annotations(self, Cronet_RawDataPtr element):  # fixme
        Cronet_UrlRequestParams_annotations_add(self._ptr, element)

    # @request_finished_listener.setter
    # def request_finished_listener(self, Cronet_RequestFinishedInfoListener* request_finished_listener):
    #     Cronet_UrlRequestParams_request_finished_listener_set(self._ptr, request_finished_listener)
    #
    # @request_finished_executor.setter
    # def request_finished_executor(self, Cronet_Executor * request_finished_executor):
    #     Cronet_UrlRequestParams_request_finished_executor_set(self._ptr, request_finished_executor)

    @idempotency.setter
    def idempotency(self, Cronet_UrlRequestParams_IDEMPOTENCY idempotency):  # fixme
        Cronet_UrlRequestParams_idempotency_set(self._ptr, idempotency)

# @cython.final
# @cython.freelist(8)
# @cython.no_gc
# cdef class RequestFinishedInfo:
#     cdef Cronet_RequestFinishedInfo* _ptr
#
#     def __cinit__(self):
#         self._ptr = Cronet_RequestFinishedInfo_Create()
#         if self._ptr == NULL:
#             raise MemoryError
#
#     def __dealloc__(self):
#         if self._ptr != NULL:
#             Cronet_RequestFinishedInfo_Destroy(self._ptr)
#             self._ptr = NULL
#
#     def set_metrics(self, Cronet_Metrics* metrics):
#         Cronet_RequestFinishedInfo_metrics_set(self._ptr, metrics)
#
#     def move_metrics(self, Cronet_Metrics* metrics):
#         Cronet_RequestFinishedInfo_metrics_move(self._ptr, metrics)
#
#     def add_annotations(self, Cronet_RawData* element):
#         Cronet_RequestFinishedInfo_annotations_add(self._ptr, element)
#
#     def set_finished_reason(self, Cronet_RequestFinishedInfo_FINISHED_REASON finished_reason):
#         Cronet_RequestFinishedInfo_finished_reason_set(self._ptr, finished_reason)
#
#     def get_metrics(self):
#         return Cronet_RequestFinishedInfo_metrics_get(self._ptr)
#
#     def get_annotations_size(self):
#         return Cronet_RequestFinishedInfo_annotations_size(self._ptr)
#
#     def get_annotations_at(self, uint32_t index):
#         return Cronet_RequestFinishedInfo_annotations_at(self._ptr, index)
#
#     def clear_annotations(self):
#         Cronet_RequestFinishedInfo_annotations_clear(self._ptr)
#
#     def get_finished_reason(self):
#         return Cronet_RequestFinishedInfo_finished_reason_get(self._ptr)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class StreamEngine:
    cdef stream_engine * _ptr

    def __cinit__(self):
        self._ptr = <stream_engine *> PyMem_Malloc(sizeof(stream_engine))
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            PyMem_Free(self._ptr)
            self._ptr = NULL

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class BidirectionalStream:
    cdef bidirectional_stream * _ptr

    def __cinit__(self, StreamEngine engine, void * annotation, BidirectionalStreamCallback callback):  # fixme
        self._ptr = bidirectional_stream_create(engine._ptr, annotation, callback._ptr)
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            bidirectional_stream_destroy(self._ptr)
            self._ptr = NULL

    def disable_auto_flush(self, bint disable_auto_flush):
        bidirectional_stream_disable_auto_flush(self._ptr, disable_auto_flush)

    def delay_request_headers_until_flush(self, bint delay_headers_until_flush):
        bidirectional_stream_delay_request_headers_until_flush(self._ptr, delay_headers_until_flush)

    def start(self, const char * url, int priority, const char * method, BidirectionalStreamHeaderArray headers,
              bint end_of_stream):
        return bidirectional_stream_start(self._ptr, url, priority, method, headers._ptr, end_of_stream)

    def read(self, char * buffer, int capacity):
        return bidirectional_stream_read(self._ptr, buffer, capacity)

    def write(self, const char * buffer, int buffer_length, bint end_of_stream):
        return bidirectional_stream_write(self._ptr, buffer, buffer_length, end_of_stream)

    def flush(self):
        bidirectional_stream_flush(self._ptr)

    def cancel(self):
        bidirectional_stream_cancel(self._ptr)

    def is_done(self):
        return bidirectional_stream_is_done(self._ptr)

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class BidirectionalStreamHeader:
    cdef bidirectional_stream_header * _ptr

    def __cinit__(self):
        self._ptr = <bidirectional_stream_header *> PyMem_Malloc(sizeof(bidirectional_stream_header))
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            PyMem_Free(self._ptr)
            self._ptr = NULL

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class BidirectionalStreamHeaderArray:
    cdef bidirectional_stream_header_array * _ptr

    def __cinit__(self):
        self._ptr = <bidirectional_stream_header_array *> PyMem_Malloc(sizeof(bidirectional_stream_header_array))
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            PyMem_Free(self._ptr)
            self._ptr = NULL

@cython.final
@cython.freelist(8)
@cython.no_gc
cdef class BidirectionalStreamCallback:
    cdef bidirectional_stream_callback * _ptr

    def __cinit__(self):
        self._ptr = <bidirectional_stream_callback *> PyMem_Malloc(sizeof(bidirectional_stream_callback))
        if self._ptr == NULL:
            raise MemoryError

    def __dealloc__(self):
        if self._ptr != NULL:
            PyMem_Free(self._ptr)
            self._ptr = NULL
