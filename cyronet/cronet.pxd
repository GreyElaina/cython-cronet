# cython: language_level=3
# cython: cdivision=True
from libc.stdint cimport uint64_t, int32_t, uint32_t, int64_t

cdef extern from "cronet_c.h" nogil:
    ctypedef const char * Cronet_String
    ctypedef void * Cronet_RawDataPtr
    ctypedef void * Cronet_ClientContext

    # Forward declare interfaces.
    ctypedef struct Cronet_Buffer:
        pass
    ctypedef struct Cronet_BufferCallback:
        pass

    ctypedef struct Cronet_Runnable:
        pass

    ctypedef struct Cronet_Executor:
        pass

    ctypedef struct Cronet_Engine:
        pass

    ctypedef struct Cronet_UrlRequestStatusListener:
        pass

    ctypedef struct Cronet_UrlRequestCallback:
        pass

    ctypedef struct Cronet_UploadDataSink:
        pass

    ctypedef struct Cronet_UploadDataProvider:
        pass

    ctypedef struct Cronet_UrlRequest:
        pass

    ctypedef struct Cronet_RequestFinishedInfoListener:
        pass

    # Forward declare structs.
    ctypedef struct Cronet_Error:
        pass

    ctypedef struct Cronet_QuicHint:
        pass

    ctypedef struct Cronet_PublicKeyPins:
        pass

    ctypedef struct Cronet_EngineParams:
        pass

    ctypedef struct Cronet_HttpHeader:
        pass

    ctypedef struct Cronet_UrlResponseInfo:
        pass

    ctypedef struct Cronet_UrlRequestParams:
        pass

    ctypedef struct Cronet_DateTime:
        pass

    ctypedef struct Cronet_Metrics:
        pass

    ctypedef struct Cronet_RequestFinishedInfo:
        pass

    # Declare
    ctypedef struct stream_engine:
        pass

    # Declare enums
    ctypedef enum Cronet_RESULT:
        Cronet_RESULT_SUCCESS
        Cronet_RESULT_ILLEGAL_ARGUMENT
        Cronet_RESULT_ILLEGAL_ARGUMENT_STORAGE_PATH_MUST_EXIST
        Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_PIN
        Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_HOSTNAME
        Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_HTTP_METHOD
        Cronet_RESULT_ILLEGAL_ARGUMENT_INVALID_HTTP_HEADER
        Cronet_RESULT_ILLEGAL_STATE
        Cronet_RESULT_ILLEGAL_STATE_STORAGE_PATH_IN_USE
        Cronet_RESULT_ILLEGAL_STATE_CANNOT_SHUTDOWN_ENGINE_FROM_NETWORK_THREAD
        Cronet_RESULT_ILLEGAL_STATE_ENGINE_ALREADY_STARTED
        Cronet_RESULT_ILLEGAL_STATE_REQUEST_ALREADY_STARTED
        Cronet_RESULT_ILLEGAL_STATE_REQUEST_NOT_INITIALIZED
        Cronet_RESULT_ILLEGAL_STATE_REQUEST_ALREADY_INITIALIZED
        Cronet_RESULT_ILLEGAL_STATE_REQUEST_NOT_STARTED
        Cronet_RESULT_ILLEGAL_STATE_UNEXPECTED_REDIRECT
        Cronet_RESULT_ILLEGAL_STATE_UNEXPECTED_READ
        Cronet_RESULT_ILLEGAL_STATE_READ_FAILED
        Cronet_RESULT_NULL_POINTER
        Cronet_RESULT_NULL_POINTER_HOSTNAME
        Cronet_RESULT_NULL_POINTER_SHA256_PINS
        Cronet_RESULT_NULL_POINTER_EXPIRATION_DATE
        Cronet_RESULT_NULL_POINTER_ENGINE
        Cronet_RESULT_NULL_POINTER_URL
        Cronet_RESULT_NULL_POINTER_CALLBACK
        Cronet_RESULT_NULL_POINTER_EXECUTOR
        Cronet_RESULT_NULL_POINTER_METHOD
        Cronet_RESULT_NULL_POINTER_HEADER_NAME
        Cronet_RESULT_NULL_POINTER_HEADER_VALUE
        Cronet_RESULT_NULL_POINTER_PARAMS
        Cronet_RESULT_NULL_POINTER_REQUEST_FINISHED_INFO_LISTENER_EXECUTOR

    ctypedef enum Cronet_Error_ERROR_CODE:
        Cronet_Error_ERROR_CODE_ERROR_CALLBACK
        Cronet_Error_ERROR_CODE_ERROR_HOSTNAME_NOT_RESOLVED
        Cronet_Error_ERROR_CODE_ERROR_INTERNET_DISCONNECTED
        Cronet_Error_ERROR_CODE_ERROR_NETWORK_CHANGED
        Cronet_Error_ERROR_CODE_ERROR_TIMED_OUT
        Cronet_Error_ERROR_CODE_ERROR_CONNECTION_CLOSED
        Cronet_Error_ERROR_CODE_ERROR_CONNECTION_TIMED_OUT
        Cronet_Error_ERROR_CODE_ERROR_CONNECTION_REFUSED
        Cronet_Error_ERROR_CODE_ERROR_CONNECTION_RESET
        Cronet_Error_ERROR_CODE_ERROR_ADDRESS_UNREACHABLE
        Cronet_Error_ERROR_CODE_ERROR_QUIC_PROTOCOL_FAILED
        Cronet_Error_ERROR_CODE_ERROR_OTHER

    ctypedef enum Cronet_EngineParams_HTTP_CACHE_MODE:
        Cronet_EngineParams_HTTP_CACHE_MODE_DISABLED
        Cronet_EngineParams_HTTP_CACHE_MODE_IN_MEMORY
        Cronet_EngineParams_HTTP_CACHE_MODE_DISK_NO_HTTP
        Cronet_EngineParams_HTTP_CACHE_MODE_DISK

    ctypedef enum Cronet_UrlRequestParams_REQUEST_PRIORITY:
        Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_IDLE
        Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_LOWEST
        Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_LOW
        Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_MEDIUM
        Cronet_UrlRequestParams_REQUEST_PRIORITY_REQUEST_PRIORITY_HIGHEST

    ctypedef enum Cronet_UrlRequestParams_IDEMPOTENCY:
        Cronet_UrlRequestParams_IDEMPOTENCY_DEFAULT_IDEMPOTENCY
        Cronet_UrlRequestParams_IDEMPOTENCY_IDEMPOTENT
        Cronet_UrlRequestParams_IDEMPOTENCY_NOT_IDEMPOTENT

    ctypedef enum Cronet_RequestFinishedInfo_FINISHED_REASON:
        Cronet_RequestFinishedInfo_FINISHED_REASON_SUCCEEDED
        Cronet_RequestFinishedInfo_FINISHED_REASON_FAILED
        Cronet_RequestFinishedInfo_FINISHED_REASON_CANCELED

    ctypedef enum Cronet_UrlRequestStatusListener_Status:
        Cronet_UrlRequestStatusListener_Status_INVALID
        Cronet_UrlRequestStatusListener_Status_IDLE
        Cronet_UrlRequestStatusListener_Status_WAITING_FOR_STALLED_SOCKET_POOL
        Cronet_UrlRequestStatusListener_Status_WAITING_FOR_AVAILABLE_SOCKET
        Cronet_UrlRequestStatusListener_Status_WAITING_FOR_DELEGATE
        Cronet_UrlRequestStatusListener_Status_WAITING_FOR_CACHE
        Cronet_UrlRequestStatusListener_Status_DOWNLOADING_PAC_FILE
        Cronet_UrlRequestStatusListener_Status_RESOLVING_PROXY_FOR_URL
        Cronet_UrlRequestStatusListener_Status_RESOLVING_HOST_IN_PAC_FILE
        Cronet_UrlRequestStatusListener_Status_ESTABLISHING_PROXY_TUNNEL
        Cronet_UrlRequestStatusListener_Status_RESOLVING_HOST
        Cronet_UrlRequestStatusListener_Status_CONNECTING
        Cronet_UrlRequestStatusListener_Status_SSL_HANDSHAKE
        Cronet_UrlRequestStatusListener_Status_SENDING_REQUEST
        Cronet_UrlRequestStatusListener_Status_WAITING_FOR_RESPONSE
        Cronet_UrlRequestStatusListener_Status_READING_RESPONSE

    # Declare constants
    ###########/
    #Concrete interface Cronet_Buffer.

    #Create an instance of Cronet_Buffer.
    Cronet_Buffer * Cronet_Buffer_Create()
    #Destroy an instance of Cronet_Buffer.
    void Cronet_Buffer_Destroy(Cronet_Buffer * self)
    #Set and get app-specific Cronet_ClientContext.
    void Cronet_Buffer_SetClientContext(
            Cronet_Buffer * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_Buffer_GetClientContext(Cronet_Buffer * self)
    #Concrete methods of Cronet_Buffer implemented by Cronet.
    #The app calls them to manipulate Cronet_Buffer.
    void Cronet_Buffer_InitWithDataAndCallback(Cronet_Buffer * self,
                                               Cronet_RawDataPtr data,
                                               uint64_t size,
                                               Cronet_BufferCallback * callback)
    void Cronet_Buffer_InitWithAlloc(Cronet_Buffer * self, uint64_t size)
    uint64_t Cronet_Buffer_GetSize(Cronet_Buffer * self)
    Cronet_RawDataPtr Cronet_Buffer_GetData(Cronet_Buffer * self)
    # Concrete interface Cronet_Buffer is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef void (*Cronet_Buffer_InitWithDataAndCallbackFunc)(
            Cronet_Buffer * self,
            Cronet_RawDataPtr data,
            uint64_t size,
            Cronet_BufferCallback * callback)
    ctypedef void (*Cronet_Buffer_InitWithAllocFunc)(Cronet_Buffer * self,
                                                     uint64_t size)
    ctypedef uint64_t (*Cronet_Buffer_GetSizeFunc)(Cronet_Buffer * self)
    ctypedef Cronet_RawDataPtr (*Cronet_Buffer_GetDataFunc)(Cronet_Buffer * self)
    # Concrete interface Cronet_Buffer is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_Buffer * Cronet_Buffer_CreateWith(
            Cronet_Buffer_InitWithDataAndCallbackFunc InitWithDataAndCallbackFunc,
            Cronet_Buffer_InitWithAllocFunc InitWithAllocFunc,
            Cronet_Buffer_GetSizeFunc GetSizeFunc,
            Cronet_Buffer_GetDataFunc GetDataFunc)
    ###########/
    # Abstract interface Cronet_BufferCallback is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_BufferCallback.
    void Cronet_BufferCallback_Destroy(Cronet_BufferCallback * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_BufferCallback_SetClientContext(
            Cronet_BufferCallback * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_BufferCallback_GetClientContext(Cronet_BufferCallback * self)
    # Abstract interface Cronet_BufferCallback is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_BufferCallback_OnDestroy(Cronet_BufferCallback * self,
                                         Cronet_Buffer * buffer)
    # The app implements abstract interface Cronet_BufferCallback by defining
    # custom functions for each method.
    ctypedef void (*Cronet_BufferCallback_OnDestroyFunc)(
            Cronet_BufferCallback * self,
            Cronet_Buffer * buffer)
    # The app creates an instance of Cronet_BufferCallback by providing custom
    # functions for each method.
    Cronet_BufferCallback * Cronet_BufferCallback_CreateWith(Cronet_BufferCallback_OnDestroyFunc OnDestroyFunc)

    ###########/
    # Abstract interface Cronet_Runnable is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_Runnable.
    void Cronet_Runnable_Destroy(Cronet_Runnable * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_Runnable_SetClientContext(
            Cronet_Runnable * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_Runnable_GetClientContext(Cronet_Runnable * self)
    # Abstract interface Cronet_Runnable is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_Runnable_Run(Cronet_Runnable * self)
    # The app implements abstract interface Cronet_Runnable by defining custom
    # functions for each method.
    ctypedef void (*Cronet_Runnable_RunFunc)(Cronet_Runnable * self)
    # The app creates an instance of Cronet_Runnable by providing custom functions
    # for each method.
    Cronet_Runnable * Cronet_Runnable_CreateWith(Cronet_Runnable_RunFunc RunFunc)

    ###########/
    # Abstract interface Cronet_Executor is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_Executor.
    void Cronet_Executor_Destroy(Cronet_Executor * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_Executor_SetClientContext(
            Cronet_Executor * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_Executor_GetClientContext(Cronet_Executor * self)
    # Abstract interface Cronet_Executor is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_Executor_Execute(Cronet_Executor * self,
                                 Cronet_Runnable * command)
    # The app implements abstract interface Cronet_Executor by defining custom
    # functions for each method.
    ctypedef void (*Cronet_Executor_ExecuteFunc)(Cronet_Executor * self,
                                                 Cronet_Runnable * command)
    # The app creates an instance of Cronet_Executor by providing custom functions
    # for each method.
    Cronet_Executor * Cronet_Executor_CreateWith(Cronet_Executor_ExecuteFunc ExecuteFunc)

    ###########/
    # Concrete interface Cronet_Engine.

    # Create an instance of Cronet_Engine.
    Cronet_Engine * Cronet_Engine_Create()
    # Destroy an instance of Cronet_Engine.
    void Cronet_Engine_Destroy(Cronet_Engine * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_Engine_SetClientContext(
            Cronet_Engine * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_Engine_GetClientContext(Cronet_Engine * self)
    # Concrete methods of Cronet_Engine implemented by Cronet.
    # The app calls them to manipulate Cronet_Engine.

    Cronet_RESULT Cronet_Engine_StartWithParams(Cronet_Engine * self,
                                                Cronet_EngineParams * params)

    bint Cronet_Engine_StartNetLogToFile(Cronet_Engine * self,
                                         Cronet_String file_name,
                                         bint log_all)

    void Cronet_Engine_StopNetLog(Cronet_Engine * self)

    Cronet_RESULT Cronet_Engine_Shutdown(Cronet_Engine * self)

    Cronet_String Cronet_Engine_GetVersionString(Cronet_Engine * self)

    Cronet_String Cronet_Engine_GetDefaultUserAgent(Cronet_Engine * self)

    void Cronet_Engine_AddRequestFinishedListener(
            Cronet_Engine * self,
            Cronet_RequestFinishedInfoListener * listener,
            Cronet_Executor * executor)

    void Cronet_Engine_RemoveRequestFinishedListener(
            Cronet_Engine * self,
            Cronet_RequestFinishedInfoListener * listener)
    # Concrete interface Cronet_Engine is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef Cronet_RESULT (*Cronet_Engine_StartWithParamsFunc)(
            Cronet_Engine * self,
            Cronet_EngineParams * params)
    ctypedef bint (*Cronet_Engine_StartNetLogToFileFunc)(Cronet_Engine * self,
                                                         Cronet_String file_name,
                                                         bint log_all)
    ctypedef void (*Cronet_Engine_StopNetLogFunc)(Cronet_Engine * self)
    ctypedef Cronet_RESULT (*Cronet_Engine_ShutdownFunc)(Cronet_Engine * self)
    ctypedef Cronet_String (*Cronet_Engine_GetVersionStringFunc)(
            Cronet_Engine * self)
    ctypedef Cronet_String (*Cronet_Engine_GetDefaultUserAgentFunc)(
            Cronet_Engine * self)
    ctypedef void (*Cronet_Engine_AddRequestFinishedListenerFunc)(
            Cronet_Engine * self,
            Cronet_RequestFinishedInfoListener * listener,
            Cronet_Executor * executor)
    ctypedef void (*Cronet_Engine_RemoveRequestFinishedListenerFunc)(
            Cronet_Engine * self,
            Cronet_RequestFinishedInfoListener * listener)
    # Concrete interface Cronet_Engine is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_Engine * Cronet_Engine_CreateWith(
            Cronet_Engine_StartWithParamsFunc StartWithParamsFunc,
            Cronet_Engine_StartNetLogToFileFunc StartNetLogToFileFunc,
            Cronet_Engine_StopNetLogFunc StopNetLogFunc,
            Cronet_Engine_ShutdownFunc ShutdownFunc,
            Cronet_Engine_GetVersionStringFunc GetVersionStringFunc,
            Cronet_Engine_GetDefaultUserAgentFunc GetDefaultUserAgentFunc,
            Cronet_Engine_AddRequestFinishedListenerFunc AddRequestFinishedListenerFunc,
            Cronet_Engine_RemoveRequestFinishedListenerFunc
            RemoveRequestFinishedListenerFunc)

    ###########/
    # Abstract interface Cronet_UrlRequestStatusListener is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_UrlRequestStatusListener.
    void Cronet_UrlRequestStatusListener_Destroy(
            Cronet_UrlRequestStatusListener * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UrlRequestStatusListener_SetClientContext(
            Cronet_UrlRequestStatusListener * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_UrlRequestStatusListener_GetClientContext(
            Cronet_UrlRequestStatusListener * self)
    # Abstract interface Cronet_UrlRequestStatusListener is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_UrlRequestStatusListener_OnStatus(
            Cronet_UrlRequestStatusListener * self,
            Cronet_UrlRequestStatusListener_Status status)
    # The app implements abstract interface Cronet_UrlRequestStatusListener by
    # defining custom functions for each method.
    ctypedef void (*Cronet_UrlRequestStatusListener_OnStatusFunc)(
            Cronet_UrlRequestStatusListener * self,
            Cronet_UrlRequestStatusListener_Status status)
    # The app creates an instance of Cronet_UrlRequestStatusListener by providing
    # custom functions for each method.
    Cronet_UrlRequestStatusListener * Cronet_UrlRequestStatusListener_CreateWith(
            Cronet_UrlRequestStatusListener_OnStatusFunc OnStatusFunc)

    ###########/
    # Abstract interface Cronet_UrlRequestCallback is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_UrlRequestCallback.
    void Cronet_UrlRequestCallback_Destroy(
            Cronet_UrlRequestCallback * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UrlRequestCallback_SetClientContext(
            Cronet_UrlRequestCallback * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_UrlRequestCallback_GetClientContext(Cronet_UrlRequestCallback * self)
    # Abstract interface Cronet_UrlRequestCallback is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_UrlRequestCallback_OnRedirectReceived(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info,
            Cronet_String new_location_url)

    void Cronet_UrlRequestCallback_OnResponseStarted(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info)

    void Cronet_UrlRequestCallback_OnReadCompleted(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info,
            Cronet_Buffer * buffer,
            uint64_t bytes_read)

    void Cronet_UrlRequestCallback_OnSucceeded(Cronet_UrlRequestCallback * self,
                                               Cronet_UrlRequest * request,
                                               Cronet_UrlResponseInfo * info)

    void Cronet_UrlRequestCallback_OnFailed(Cronet_UrlRequestCallback * self,
                                            Cronet_UrlRequest * request,
                                            Cronet_UrlResponseInfo * info,
                                            Cronet_Error * error)

    void Cronet_UrlRequestCallback_OnCanceled(Cronet_UrlRequestCallback * self,
                                              Cronet_UrlRequest * request,
                                              Cronet_UrlResponseInfo * info)
    # The app implements abstract interface Cronet_UrlRequestCallback by defining
    # custom functions for each method.
    ctypedef void (*Cronet_UrlRequestCallback_OnRedirectReceivedFunc)(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info,
            Cronet_String new_location_url) with gil
    ctypedef void (*Cronet_UrlRequestCallback_OnResponseStartedFunc)(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info)
    ctypedef void (*Cronet_UrlRequestCallback_OnReadCompletedFunc)(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info,
            Cronet_Buffer * buffer,
            uint64_t bytes_read)
    ctypedef void (*Cronet_UrlRequestCallback_OnSucceededFunc)(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info)
    ctypedef void (*Cronet_UrlRequestCallback_OnFailedFunc)(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info,
            Cronet_Error * error)
    ctypedef void (*Cronet_UrlRequestCallback_OnCanceledFunc)(
            Cronet_UrlRequestCallback * self,
            Cronet_UrlRequest * request,
            Cronet_UrlResponseInfo * info)
    # The app creates an instance of Cronet_UrlRequestCallback by providing custom
    # functions for each method.
    Cronet_UrlRequestCallback * Cronet_UrlRequestCallback_CreateWith(
            Cronet_UrlRequestCallback_OnRedirectReceivedFunc OnRedirectReceivedFunc,
            Cronet_UrlRequestCallback_OnResponseStartedFunc OnResponseStartedFunc,
            Cronet_UrlRequestCallback_OnReadCompletedFunc OnReadCompletedFunc,
            Cronet_UrlRequestCallback_OnSucceededFunc OnSucceededFunc,
            Cronet_UrlRequestCallback_OnFailedFunc OnFailedFunc,
            Cronet_UrlRequestCallback_OnCanceledFunc OnCanceledFunc)

    ###########/
    # Concrete interface Cronet_UploadDataSink.

    # Create an instance of Cronet_UploadDataSink.
    Cronet_UploadDataSink * Cronet_UploadDataSink_Create()
    # Destroy an instance of Cronet_UploadDataSink.
    void Cronet_UploadDataSink_Destroy(Cronet_UploadDataSink * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UploadDataSink_SetClientContext(
            Cronet_UploadDataSink * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_UploadDataSink_GetClientContext(Cronet_UploadDataSink * self)
    # Concrete methods of Cronet_UploadDataSink implemented by Cronet.
    # The app calls them to manipulate Cronet_UploadDataSink.

    void Cronet_UploadDataSink_OnReadSucceeded(Cronet_UploadDataSink * self,
                                               uint64_t bytes_read,
                                               bint final_chunk)

    void Cronet_UploadDataSink_OnReadError(Cronet_UploadDataSink * self,
                                           Cronet_String error_message)

    void Cronet_UploadDataSink_OnRewindSucceeded(Cronet_UploadDataSink * self)

    void Cronet_UploadDataSink_OnRewindError(Cronet_UploadDataSink * self,
                                             Cronet_String error_message)
    # Concrete interface Cronet_UploadDataSink is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef void (*Cronet_UploadDataSink_OnReadSucceededFunc)(
            Cronet_UploadDataSink * self,
            uint64_t bytes_read,
            bint final_chunk)
    ctypedef void (*Cronet_UploadDataSink_OnReadErrorFunc)(
            Cronet_UploadDataSink * self,
            Cronet_String error_message)
    ctypedef void (*Cronet_UploadDataSink_OnRewindSucceededFunc)(
            Cronet_UploadDataSink * self)
    ctypedef void (*Cronet_UploadDataSink_OnRewindErrorFunc)(
            Cronet_UploadDataSink * self,
            Cronet_String error_message)
    # Concrete interface Cronet_UploadDataSink is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_UploadDataSink * Cronet_UploadDataSink_CreateWith(
            Cronet_UploadDataSink_OnReadSucceededFunc OnReadSucceededFunc,
            Cronet_UploadDataSink_OnReadErrorFunc OnReadErrorFunc,
            Cronet_UploadDataSink_OnRewindSucceededFunc OnRewindSucceededFunc,
            Cronet_UploadDataSink_OnRewindErrorFunc OnRewindErrorFunc)

    ###########/
    # Abstract interface Cronet_UploadDataProvider is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_UploadDataProvider.
    void Cronet_UploadDataProvider_Destroy(
            Cronet_UploadDataProvider * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UploadDataProvider_SetClientContext(
            Cronet_UploadDataProvider * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_UploadDataProvider_GetClientContext(Cronet_UploadDataProvider * self)
    # Abstract interface Cronet_UploadDataProvider is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    int64_t Cronet_UploadDataProvider_GetLength(Cronet_UploadDataProvider * self)

    void Cronet_UploadDataProvider_Read(Cronet_UploadDataProvider * self,
                                        Cronet_UploadDataSink * upload_data_sink,
                                        Cronet_Buffer * buffer)

    void Cronet_UploadDataProvider_Rewind(
            Cronet_UploadDataProvider * self,
            Cronet_UploadDataSink * upload_data_sink)

    void Cronet_UploadDataProvider_Close(Cronet_UploadDataProvider * self)
    # The app implements abstract interface Cronet_UploadDataProvider by defining
    # custom functions for each method.
    ctypedef int64_t (*Cronet_UploadDataProvider_GetLengthFunc)(
            Cronet_UploadDataProvider * self)
    ctypedef void (*Cronet_UploadDataProvider_ReadFunc)(
            Cronet_UploadDataProvider * self,
            Cronet_UploadDataSink * upload_data_sink,
            Cronet_Buffer * buffer)
    ctypedef void (*Cronet_UploadDataProvider_RewindFunc)(
            Cronet_UploadDataProvider * self,
            Cronet_UploadDataSink * upload_data_sink)
    ctypedef void (*Cronet_UploadDataProvider_CloseFunc)(
            Cronet_UploadDataProvider * self)
    # The app creates an instance of Cronet_UploadDataProvider by providing custom
    # functions for each method.
    Cronet_UploadDataProvider * Cronet_UploadDataProvider_CreateWith(
            Cronet_UploadDataProvider_GetLengthFunc GetLengthFunc,
            Cronet_UploadDataProvider_ReadFunc ReadFunc,
            Cronet_UploadDataProvider_RewindFunc RewindFunc,
            Cronet_UploadDataProvider_CloseFunc CloseFunc)

    ###########/
    # Concrete interface Cronet_UrlRequest.

    # Create an instance of Cronet_UrlRequest.
    Cronet_UrlRequest * Cronet_UrlRequest_Create()
    # Destroy an instance of Cronet_UrlRequest.
    void Cronet_UrlRequest_Destroy(Cronet_UrlRequest * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UrlRequest_SetClientContext(
            Cronet_UrlRequest * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_UrlRequest_GetClientContext(Cronet_UrlRequest * self)
    # Concrete methods of Cronet_UrlRequest implemented by Cronet.
    # The app calls them to manipulate Cronet_UrlRequest.

    Cronet_RESULT Cronet_UrlRequest_InitWithParams(
            Cronet_UrlRequest * self,
            Cronet_Engine * engine,
            Cronet_String url,
            Cronet_UrlRequestParams * params,
            Cronet_UrlRequestCallback * callback,
            Cronet_Executor * executor)

    Cronet_RESULT Cronet_UrlRequest_Start(Cronet_UrlRequest * self)

    Cronet_RESULT Cronet_UrlRequest_FollowRedirect(Cronet_UrlRequest * self)

    Cronet_RESULT Cronet_UrlRequest_Read(Cronet_UrlRequest * self,
                                         Cronet_Buffer * buffer)

    void Cronet_UrlRequest_Cancel(Cronet_UrlRequest * self)

    bint Cronet_UrlRequest_IsDone(Cronet_UrlRequest * self)

    void Cronet_UrlRequest_GetStatus(Cronet_UrlRequest * self,
                                     Cronet_UrlRequestStatusListener * listener)
    # Concrete interface Cronet_UrlRequest is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_InitWithParamsFunc)(
            Cronet_UrlRequest * self,
            Cronet_Engine * engine,
            Cronet_String url,
            Cronet_UrlRequestParams * params,
            Cronet_UrlRequestCallback * callback,
            Cronet_Executor * executor)
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_StartFunc)(Cronet_UrlRequest * self)
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_FollowRedirectFunc)(
            Cronet_UrlRequest * self)
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_ReadFunc)(Cronet_UrlRequest * self,
                                                         Cronet_Buffer * buffer)
    ctypedef void (*Cronet_UrlRequest_CancelFunc)(Cronet_UrlRequest * self)
    ctypedef bint (*Cronet_UrlRequest_IsDoneFunc)(Cronet_UrlRequest * self)
    ctypedef void (*Cronet_UrlRequest_GetStatusFunc)(
            Cronet_UrlRequest * self,
            Cronet_UrlRequestStatusListener * listener)
    # Concrete interface Cronet_UrlRequest is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_UrlRequest * Cronet_UrlRequest_CreateWith(
            Cronet_UrlRequest_InitWithParamsFunc InitWithParamsFunc,
            Cronet_UrlRequest_StartFunc StartFunc,
            Cronet_UrlRequest_FollowRedirectFunc FollowRedirectFunc,
            Cronet_UrlRequest_ReadFunc ReadFunc,
            Cronet_UrlRequest_CancelFunc CancelFunc,
            Cronet_UrlRequest_IsDoneFunc IsDoneFunc,
            Cronet_UrlRequest_GetStatusFunc GetStatusFunc)

    ###########/
    # Abstract interface Cronet_RequestFinishedInfoListener is implemented by the
    # app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_RequestFinishedInfoListener.
    void Cronet_RequestFinishedInfoListener_Destroy(
            Cronet_RequestFinishedInfoListener * self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_RequestFinishedInfoListener_SetClientContext(
            Cronet_RequestFinishedInfoListener * self,
            Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_RequestFinishedInfoListener_GetClientContext(
            Cronet_RequestFinishedInfoListener * self)
    # Abstract interface Cronet_RequestFinishedInfoListener is implemented by the
    # app. The following concrete methods forward call to app implementation. The
    # app doesn't normally call them.

    void Cronet_RequestFinishedInfoListener_OnRequestFinished(
            Cronet_RequestFinishedInfoListener * self,
            Cronet_RequestFinishedInfo * request_info,
            Cronet_UrlResponseInfo * response_info,
            Cronet_Error * error)
    # The app implements abstract interface Cronet_RequestFinishedInfoListener by
    # defining custom functions for each method.
    ctypedef void (*Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc)(
            Cronet_RequestFinishedInfoListener * self,
            Cronet_RequestFinishedInfo * request_info,
            Cronet_UrlResponseInfo * response_info,
            Cronet_Error * error)
    # The app creates an instance of Cronet_RequestFinishedInfoListener by
    # providing custom functions for each method.
    Cronet_RequestFinishedInfoListener * Cronet_RequestFinishedInfoListener_CreateWith(
            Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc
            OnRequestFinishedFunc)

    ###########/
    # Struct Cronet_Error.
    Cronet_Error * Cronet_Error_Create()
    void Cronet_Error_Destroy(Cronet_Error * self)
    # Cronet_Error setters.

    void Cronet_Error_error_code_set(Cronet_Error * self,
                                     const Cronet_Error_ERROR_CODE error_code)

    void Cronet_Error_message_set(Cronet_Error * self,
                                  const Cronet_String message)

    void Cronet_Error_internal_error_code_set(Cronet_Error * self,
                                              const int32_t internal_error_code)

    void Cronet_Error_immediately_retryable_set(Cronet_Error * self,
                                                const bint immediately_retryable)

    void Cronet_Error_quic_detailed_error_code_set(
            Cronet_Error * self,
            const int32_t quic_detailed_error_code)
    # Cronet_Error getters.

    Cronet_Error_ERROR_CODE Cronet_Error_error_code_get(const Cronet_Error * self)

    Cronet_String Cronet_Error_message_get(const Cronet_Error * self)

    int32_t Cronet_Error_internal_error_code_get(const Cronet_Error * self)

    bint Cronet_Error_immediately_retryable_get(const Cronet_Error * self)

    int32_t Cronet_Error_quic_detailed_error_code_get(const Cronet_Error * self)

    ###########/
    # Struct Cronet_QuicHint.
    Cronet_QuicHint * Cronet_QuicHint_Create()
    void Cronet_QuicHint_Destroy(Cronet_QuicHint * self)
    # Cronet_QuicHint setters.

    void Cronet_QuicHint_host_set(Cronet_QuicHint * self,
                                  const Cronet_String host)

    void Cronet_QuicHint_port_set(Cronet_QuicHint * self, const int32_t port)

    void Cronet_QuicHint_alternate_port_set(Cronet_QuicHint * self,
                                            const int32_t alternate_port)
    # Cronet_QuicHint getters.

    Cronet_String Cronet_QuicHint_host_get(const Cronet_QuicHint * self)

    int32_t Cronet_QuicHint_port_get(const Cronet_QuicHint * self)

    int32_t Cronet_QuicHint_alternate_port_get(const Cronet_QuicHint * self)

    ###########/
    # Struct Cronet_PublicKeyPins.
    Cronet_PublicKeyPins * Cronet_PublicKeyPins_Create()
    void Cronet_PublicKeyPins_Destroy(Cronet_PublicKeyPins * self)
    # Cronet_PublicKeyPins setters.

    void Cronet_PublicKeyPins_host_set(Cronet_PublicKeyPins * self,
                                       const Cronet_String host)

    void Cronet_PublicKeyPins_pins_sha256_add(Cronet_PublicKeyPins * self,
                                              const Cronet_String element)

    void Cronet_PublicKeyPins_include_subdomains_set(Cronet_PublicKeyPins * self,
                                                     const bint include_subdomains)

    void Cronet_PublicKeyPins_expiration_date_set(Cronet_PublicKeyPins * self,
                                                  const int64_t expiration_date)
    # Cronet_PublicKeyPins getters.

    Cronet_String Cronet_PublicKeyPins_host_get(const Cronet_PublicKeyPins * self)

    uint32_t Cronet_PublicKeyPins_pins_sha256_size(
            const Cronet_PublicKeyPins * self)

    Cronet_String Cronet_PublicKeyPins_pins_sha256_at(
            const Cronet_PublicKeyPins * self,
            uint32_t index)

    void Cronet_PublicKeyPins_pins_sha256_clear(Cronet_PublicKeyPins * self)

    bint Cronet_PublicKeyPins_include_subdomains_get(
            const Cronet_PublicKeyPins * self)

    int64_t Cronet_PublicKeyPins_expiration_date_get(
            const Cronet_PublicKeyPins * self)

    ###########/
    # Struct Cronet_EngineParams.
    Cronet_EngineParams * Cronet_EngineParams_Create()
    void Cronet_EngineParams_Destroy(Cronet_EngineParams * self)
    # Cronet_EngineParams setters.

    void Cronet_EngineParams_enable_check_result_set(
            Cronet_EngineParams * self,
            const bint enable_check_result)

    void Cronet_EngineParams_user_agent_set(Cronet_EngineParams * self,
                                            const Cronet_String user_agent)

    void Cronet_EngineParams_accept_language_set(
            Cronet_EngineParams * self,
            const Cronet_String accept_language)

    void Cronet_EngineParams_storage_path_set(Cronet_EngineParams * self,
                                              const Cronet_String storage_path)

    void Cronet_EngineParams_enable_quic_set(Cronet_EngineParams * self,
                                             const bint enable_quic)

    void Cronet_EngineParams_enable_http2_set(Cronet_EngineParams * self,
                                              const bint enable_http2)

    void Cronet_EngineParams_enable_brotli_set(Cronet_EngineParams * self,
                                               const bint enable_brotli)

    void Cronet_EngineParams_http_cache_mode_set(
            Cronet_EngineParams * self,
            const Cronet_EngineParams_HTTP_CACHE_MODE http_cache_mode)

    void Cronet_EngineParams_http_cache_max_size_set(
            Cronet_EngineParams * self,
            const int64_t http_cache_max_size)

    void Cronet_EngineParams_quic_hints_add(Cronet_EngineParams * self,
                                            const Cronet_QuicHint * element)

    void Cronet_EngineParams_public_key_pins_add(
            Cronet_EngineParams * self,
            const Cronet_PublicKeyPins * element)

    void Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_set(
            Cronet_EngineParams * self,
            const bint enable_public_key_pinning_bypass_for_local_trust_anchors)

    void Cronet_EngineParams_network_thread_priority_set(
            Cronet_EngineParams * self,
            const double network_thread_priority)

    void Cronet_EngineParams_experimental_options_set(
            Cronet_EngineParams * self,
            const Cronet_String experimental_options)
    # Cronet_EngineParams getters.

    bint Cronet_EngineParams_enable_check_result_get(
            const Cronet_EngineParams * self)

    Cronet_String Cronet_EngineParams_user_agent_get(
            const Cronet_EngineParams * self)

    Cronet_String Cronet_EngineParams_accept_language_get(
            const Cronet_EngineParams * self)

    Cronet_String Cronet_EngineParams_storage_path_get(
            const Cronet_EngineParams * self)

    bint Cronet_EngineParams_enable_quic_get(const Cronet_EngineParams * self)

    bint Cronet_EngineParams_enable_http2_get(const Cronet_EngineParams * self)

    bint Cronet_EngineParams_enable_brotli_get(const Cronet_EngineParams * self)

    Cronet_EngineParams_HTTP_CACHE_MODE Cronet_EngineParams_http_cache_mode_get(
            const Cronet_EngineParams * self)

    int64_t Cronet_EngineParams_http_cache_max_size_get(
            const Cronet_EngineParams * self)

    uint32_t Cronet_EngineParams_quic_hints_size(const Cronet_EngineParams * self)

    Cronet_QuicHint * Cronet_EngineParams_quic_hints_at(
            const Cronet_EngineParams * self,
            uint32_t index)

    void Cronet_EngineParams_quic_hints_clear(Cronet_EngineParams * self)

    uint32_t Cronet_EngineParams_public_key_pins_size(
            const Cronet_EngineParams * self)

    Cronet_PublicKeyPins * Cronet_EngineParams_public_key_pins_at(
            const Cronet_EngineParams * self,
            uint32_t index)

    void Cronet_EngineParams_public_key_pins_clear(Cronet_EngineParams * self)

    bint Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_get(
            const Cronet_EngineParams * self)

    double Cronet_EngineParams_network_thread_priority_get(
            const Cronet_EngineParams * self)

    Cronet_String Cronet_EngineParams_experimental_options_get(
            const Cronet_EngineParams * self)

    ###########/
    # Struct Cronet_HttpHeader.
    Cronet_HttpHeader * Cronet_HttpHeader_Create()
    void Cronet_HttpHeader_Destroy(Cronet_HttpHeader * self)
    # Cronet_HttpHeader setters.

    void Cronet_HttpHeader_name_set(Cronet_HttpHeader * self,
                                    const Cronet_String name)

    void Cronet_HttpHeader_value_set(Cronet_HttpHeader * self,
                                     const Cronet_String value)
    # Cronet_HttpHeader getters.

    Cronet_String Cronet_HttpHeader_name_get(const Cronet_HttpHeader * self)

    Cronet_String Cronet_HttpHeader_value_get(const Cronet_HttpHeader * self)

    ###########/
    # Struct Cronet_UrlResponseInfo.
    Cronet_UrlResponseInfo * Cronet_UrlResponseInfo_Create()
    void Cronet_UrlResponseInfo_Destroy(
            Cronet_UrlResponseInfo * self)
    # Cronet_UrlResponseInfo setters.

    void Cronet_UrlResponseInfo_url_set(Cronet_UrlResponseInfo * self,
                                        const Cronet_String url)

    void Cronet_UrlResponseInfo_url_chain_add(Cronet_UrlResponseInfo * self,
                                              const Cronet_String element)

    void Cronet_UrlResponseInfo_http_status_code_set(
            Cronet_UrlResponseInfo * self,
            const int32_t http_status_code)

    void Cronet_UrlResponseInfo_http_status_text_set(
            Cronet_UrlResponseInfo * self,
            const Cronet_String http_status_text)

    void Cronet_UrlResponseInfo_all_headers_list_add(
            Cronet_UrlResponseInfo * self,
            const Cronet_HttpHeader * element)

    void Cronet_UrlResponseInfo_was_cached_set(Cronet_UrlResponseInfo * self,
                                               const bint was_cached)

    void Cronet_UrlResponseInfo_negotiated_protocol_set(
            Cronet_UrlResponseInfo * self,
            const Cronet_String negotiated_protocol)

    void Cronet_UrlResponseInfo_proxy_server_set(Cronet_UrlResponseInfo * self,
                                                 const Cronet_String proxy_server)

    void Cronet_UrlResponseInfo_received_byte_count_set(
            Cronet_UrlResponseInfo * self,
            const int64_t received_byte_count)
    # Cronet_UrlResponseInfo getters.

    Cronet_String Cronet_UrlResponseInfo_url_get(
            const Cronet_UrlResponseInfo * self)

    uint32_t Cronet_UrlResponseInfo_url_chain_size(
            const Cronet_UrlResponseInfo * self)

    Cronet_String Cronet_UrlResponseInfo_url_chain_at(
            const Cronet_UrlResponseInfo * self,
            uint32_t index)

    void Cronet_UrlResponseInfo_url_chain_clear(Cronet_UrlResponseInfo * self)

    int32_t Cronet_UrlResponseInfo_http_status_code_get(
            const Cronet_UrlResponseInfo * self)

    Cronet_String Cronet_UrlResponseInfo_http_status_text_get(
            const Cronet_UrlResponseInfo * self)

    uint32_t Cronet_UrlResponseInfo_all_headers_list_size(
            const Cronet_UrlResponseInfo * self)

    Cronet_HttpHeader * Cronet_UrlResponseInfo_all_headers_list_at(
            const Cronet_UrlResponseInfo * self,
            uint32_t index)

    void Cronet_UrlResponseInfo_all_headers_list_clear(
            Cronet_UrlResponseInfo * self)

    bint Cronet_UrlResponseInfo_was_cached_get(
            const Cronet_UrlResponseInfo * self)

    Cronet_String Cronet_UrlResponseInfo_negotiated_protocol_get(
            const Cronet_UrlResponseInfo * self)

    Cronet_String Cronet_UrlResponseInfo_proxy_server_get(
            const Cronet_UrlResponseInfo * self)

    int64_t Cronet_UrlResponseInfo_received_byte_count_get(
            const Cronet_UrlResponseInfo * self)

    ###########/
    # Struct Cronet_UrlRequestParams.
    Cronet_UrlRequestParams * Cronet_UrlRequestParams_Create()
    void Cronet_UrlRequestParams_Destroy(
            Cronet_UrlRequestParams * self)
    # Cronet_UrlRequestParams setters.

    void Cronet_UrlRequestParams_http_method_set(Cronet_UrlRequestParams * self,
                                                 const Cronet_String http_method)

    void Cronet_UrlRequestParams_request_headers_add(
            Cronet_UrlRequestParams * self,
            const Cronet_HttpHeader * element)

    void Cronet_UrlRequestParams_disable_cache_set(Cronet_UrlRequestParams * self,
                                                   const bint disable_cache)

    void Cronet_UrlRequestParams_priority_set(
            Cronet_UrlRequestParams * self,
            const Cronet_UrlRequestParams_REQUEST_PRIORITY priority)

    void Cronet_UrlRequestParams_upload_data_provider_set(
            Cronet_UrlRequestParams * self,
            const Cronet_UploadDataProvider * upload_data_provider)

    void Cronet_UrlRequestParams_upload_data_provider_executor_set(
            Cronet_UrlRequestParams * self,
            const Cronet_Executor * upload_data_provider_executor)

    void Cronet_UrlRequestParams_allow_direct_executor_set(
            Cronet_UrlRequestParams * self,
            const bint allow_direct_executor)

    void Cronet_UrlRequestParams_annotations_add(Cronet_UrlRequestParams * self,
                                                 const Cronet_RawDataPtr element)

    void Cronet_UrlRequestParams_request_finished_listener_set(
            Cronet_UrlRequestParams * self,
            const Cronet_RequestFinishedInfoListener * request_finished_listener)

    void Cronet_UrlRequestParams_request_finished_executor_set(
            Cronet_UrlRequestParams * self,
            const Cronet_Executor * request_finished_executor)

    void Cronet_UrlRequestParams_idempotency_set(
            Cronet_UrlRequestParams * self,
            const Cronet_UrlRequestParams_IDEMPOTENCY idempotency)
    # Cronet_UrlRequestParams getters.

    Cronet_String Cronet_UrlRequestParams_http_method_get(
            const Cronet_UrlRequestParams * self)

    uint32_t Cronet_UrlRequestParams_request_headers_size(
            const Cronet_UrlRequestParams * self)

    Cronet_HttpHeader * Cronet_UrlRequestParams_request_headers_at(
            const Cronet_UrlRequestParams * self,
            uint32_t index)

    void Cronet_UrlRequestParams_request_headers_clear(
            Cronet_UrlRequestParams * self)

    bint Cronet_UrlRequestParams_disable_cache_get(
            const Cronet_UrlRequestParams * self)

    Cronet_UrlRequestParams_REQUEST_PRIORITY Cronet_UrlRequestParams_priority_get(
            const Cronet_UrlRequestParams * self)

    Cronet_UploadDataProvider * Cronet_UrlRequestParams_upload_data_provider_get(
            const Cronet_UrlRequestParams * self)

    Cronet_Executor * Cronet_UrlRequestParams_upload_data_provider_executor_get(
            const Cronet_UrlRequestParams * self)

    bint Cronet_UrlRequestParams_allow_direct_executor_get(
            const Cronet_UrlRequestParams * self)

    uint32_t Cronet_UrlRequestParams_annotations_size(
            const Cronet_UrlRequestParams * self)

    Cronet_RawDataPtr Cronet_UrlRequestParams_annotations_at(
            const Cronet_UrlRequestParams * self,
            uint32_t index)

    void Cronet_UrlRequestParams_annotations_clear(Cronet_UrlRequestParams * self)

    Cronet_RequestFinishedInfoListener * Cronet_UrlRequestParams_request_finished_listener_get(
            const Cronet_UrlRequestParams * self)

    Cronet_Executor * Cronet_UrlRequestParams_request_finished_executor_get(
            const Cronet_UrlRequestParams * self)

    Cronet_UrlRequestParams_IDEMPOTENCY Cronet_UrlRequestParams_idempotency_get(
            const Cronet_UrlRequestParams * self)

    ###########/
    # Struct Cronet_DateTime.
    Cronet_DateTime * Cronet_DateTime_Create()
    void Cronet_DateTime_Destroy(Cronet_DateTime * self)
    # Cronet_DateTime setters.

    void Cronet_DateTime_value_set(Cronet_DateTime * self, const int64_t value)
    # Cronet_DateTime getters.

    int64_t Cronet_DateTime_value_get(const Cronet_DateTime * self)

    ###########/
    # Struct Cronet_Metrics.
    Cronet_Metrics * Cronet_Metrics_Create()
    void Cronet_Metrics_Destroy(Cronet_Metrics * self)
    # Cronet_Metrics setters.

    void Cronet_Metrics_request_start_set(Cronet_Metrics * self,
                                          const Cronet_DateTime * request_start)
    # Move data from |request_start|. The caller retains ownership of
    # |request_start| and must destroy it.
    void Cronet_Metrics_request_start_move(Cronet_Metrics * self,
                                           Cronet_DateTime * request_start)

    void Cronet_Metrics_dns_start_set(Cronet_Metrics * self,
                                      const Cronet_DateTime * dns_start)
    # Move data from |dns_start|. The caller retains ownership of |dns_start| and
    # must destroy it.
    void Cronet_Metrics_dns_start_move(Cronet_Metrics * self,
                                       Cronet_DateTime * dns_start)

    void Cronet_Metrics_dns_end_set(Cronet_Metrics * self,
                                    const Cronet_DateTime * dns_end)
    # Move data from |dns_end|. The caller retains ownership of |dns_end| and must
    # destroy it.
    void Cronet_Metrics_dns_end_move(Cronet_Metrics * self,
                                     Cronet_DateTime * dns_end)

    void Cronet_Metrics_connect_start_set(Cronet_Metrics * self,
                                          const Cronet_DateTime * connect_start)
    # Move data from |connect_start|. The caller retains ownership of
    # |connect_start| and must destroy it.
    void Cronet_Metrics_connect_start_move(Cronet_Metrics * self,
                                           Cronet_DateTime * connect_start)

    void Cronet_Metrics_connect_end_set(Cronet_Metrics * self,
                                        const Cronet_DateTime * connect_end)
    # Move data from |connect_end|. The caller retains ownership of |connect_end|
    # and must destroy it.
    void Cronet_Metrics_connect_end_move(Cronet_Metrics * self,
                                         Cronet_DateTime * connect_end)

    void Cronet_Metrics_ssl_start_set(Cronet_Metrics * self,
                                      const Cronet_DateTime * ssl_start)
    # Move data from |ssl_start|. The caller retains ownership of |ssl_start| and
    # must destroy it.
    void Cronet_Metrics_ssl_start_move(Cronet_Metrics * self,
                                       Cronet_DateTime * ssl_start)

    void Cronet_Metrics_ssl_end_set(Cronet_Metrics * self,
                                    const Cronet_DateTime * ssl_end)
    # Move data from |ssl_end|. The caller retains ownership of |ssl_end| and must
    # destroy it.
    void Cronet_Metrics_ssl_end_move(Cronet_Metrics * self,
                                     Cronet_DateTime * ssl_end)

    void Cronet_Metrics_sending_start_set(Cronet_Metrics * self,
                                          const Cronet_DateTime * sending_start)
    # Move data from |sending_start|. The caller retains ownership of
    # |sending_start| and must destroy it.
    void Cronet_Metrics_sending_start_move(Cronet_Metrics * self,
                                           Cronet_DateTime * sending_start)

    void Cronet_Metrics_sending_end_set(Cronet_Metrics * self,
                                        const Cronet_DateTime * sending_end)
    # Move data from |sending_end|. The caller retains ownership of |sending_end|
    # and must destroy it.
    void Cronet_Metrics_sending_end_move(Cronet_Metrics * self,
                                         Cronet_DateTime * sending_end)

    void Cronet_Metrics_push_start_set(Cronet_Metrics * self,
                                       const Cronet_DateTime * push_start)
    # Move data from |push_start|. The caller retains ownership of |push_start| and
    # must destroy it.
    void Cronet_Metrics_push_start_move(Cronet_Metrics * self,
                                        Cronet_DateTime * push_start)

    void Cronet_Metrics_push_end_set(Cronet_Metrics * self,
                                     const Cronet_DateTime * push_end)
    # Move data from |push_end|. The caller retains ownership of |push_end| and
    # must destroy it.
    void Cronet_Metrics_push_end_move(Cronet_Metrics * self,
                                      Cronet_DateTime * push_end)

    void Cronet_Metrics_response_start_set(Cronet_Metrics * self,
                                           const Cronet_DateTime * response_start)
    # Move data from |response_start|. The caller retains ownership of
    # |response_start| and must destroy it.
    void Cronet_Metrics_response_start_move(Cronet_Metrics * self,
                                            Cronet_DateTime * response_start)

    void Cronet_Metrics_request_end_set(Cronet_Metrics * self,
                                        const Cronet_DateTime * request_end)
    # Move data from |request_end|. The caller retains ownership of |request_end|
    # and must destroy it.
    void Cronet_Metrics_request_end_move(Cronet_Metrics * self,
                                         Cronet_DateTime * request_end)

    void Cronet_Metrics_socket_reused_set(Cronet_Metrics * self,
                                          const bint socket_reused)

    void Cronet_Metrics_sent_byte_count_set(Cronet_Metrics * self,
                                            const int64_t sent_byte_count)

    void Cronet_Metrics_received_byte_count_set(Cronet_Metrics * self,
                                                const int64_t received_byte_count)
    # Cronet_Metrics getters.

    Cronet_DateTime * Cronet_Metrics_request_start_get(
            const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_dns_start_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_dns_end_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_connect_start_get(
            const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_connect_end_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_ssl_start_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_ssl_end_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_sending_start_get(
            const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_sending_end_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_push_start_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_push_end_get(const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_response_start_get(
            const Cronet_Metrics * self)

    Cronet_DateTime * Cronet_Metrics_request_end_get(const Cronet_Metrics * self)

    bint Cronet_Metrics_socket_reused_get(const Cronet_Metrics * self)

    int64_t Cronet_Metrics_sent_byte_count_get(const Cronet_Metrics * self)

    int64_t Cronet_Metrics_received_byte_count_get(const Cronet_Metrics * self)

    ###########/
    # Struct Cronet_RequestFinishedInfo.
    Cronet_RequestFinishedInfo * Cronet_RequestFinishedInfo_Create()
    void Cronet_RequestFinishedInfo_Destroy(
            Cronet_RequestFinishedInfo * self)
    # Cronet_RequestFinishedInfo setters.

    void Cronet_RequestFinishedInfo_metrics_set(Cronet_RequestFinishedInfo * self,
                                                const Cronet_Metrics * metrics)
    # Move data from |metrics|. The caller retains ownership of |metrics| and must
    # destroy it.
    void Cronet_RequestFinishedInfo_metrics_move(Cronet_RequestFinishedInfo * self,
                                                 Cronet_Metrics * metrics)

    void Cronet_RequestFinishedInfo_annotations_add(
            Cronet_RequestFinishedInfo * self,
            const Cronet_RawDataPtr element)

    void Cronet_RequestFinishedInfo_finished_reason_set(
            Cronet_RequestFinishedInfo * self,
            const Cronet_RequestFinishedInfo_FINISHED_REASON finished_reason)
    # Cronet_RequestFinishedInfo getters.

    Cronet_Metrics * Cronet_RequestFinishedInfo_metrics_get(
            const Cronet_RequestFinishedInfo * self)

    uint32_t Cronet_RequestFinishedInfo_annotations_size(
            const Cronet_RequestFinishedInfo * self)

    Cronet_RawDataPtr Cronet_RequestFinishedInfo_annotations_at(
            const Cronet_RequestFinishedInfo * self,
            uint32_t index)

    void Cronet_RequestFinishedInfo_annotations_clear(
            Cronet_RequestFinishedInfo * self)

    Cronet_RequestFinishedInfo_FINISHED_REASON Cronet_RequestFinishedInfo_finished_reason_get(
            const Cronet_RequestFinishedInfo * self)

    ## declared from cronet_c.h
    # Sets net::CertVerifier* raw_mock_cert_verifier for testing of Cronet_Engine.
    # Must be called before Cronet_Engine_InitWithParams().
    void Cronet_Engine_SetMockCertVerifierForTesting(
            Cronet_Engine * engine,
            void * raw_mock_cert_verifier)

    # Returns "stream_engine" interface for bidirectional stream support for GRPC.
    # Returned stream engine is owned by Cronet Engine and is only valid until
    # Cronet_Engine_Shutdown().
    stream_engine * Cronet_Engine_GetStreamEngine(
            Cronet_Engine * engine)

cdef extern from "bidirectional_stream_c.h" nogil:
    # bidirectional stream
    ctypedef struct stream_engine:
        void * obj
        void * annotation

    ctypedef struct bidirectional_stream:
        void * obj
        void * annotation

    ctypedef struct bidirectional_stream_header:
        const char * key
        const char * value

    ctypedef struct bidirectional_stream_header_array:
        size_t count
        size_t capacity
        bidirectional_stream_header * headers

    ctypedef struct bidirectional_stream_callback:
        void (*on_stream_ready)(bidirectional_stream * stream)
        void (*on_response_headers_received)(bidirectional_stream * stream,
                                             const bidirectional_stream_header_array * headers,
                                             const char * negotiated_protocol)
        void (*on_read_completed)(bidirectional_stream * stream, char * data, int bytes_read)
        void (*on_write_completed)(bidirectional_stream * stream, const char * data)
        void (*on_response_trailers_received)(bidirectional_stream * stream,
                                              const bidirectional_stream_header_array * trailers)
        void (*on_succeded)(bidirectional_stream * stream)
        void (*on_failed)(bidirectional_stream * stream, int net_error)
        void (*on_canceled)(bidirectional_stream * stream)

    bidirectional_stream * bidirectional_stream_create(stream_engine * engine, void * annotation,
                                                       bidirectional_stream_callback * callback)
    int bidirectional_stream_destroy(bidirectional_stream * stream)
    void bidirectional_stream_disable_auto_flush(bidirectional_stream * stream, bint disable_auto_flush)
    void bidirectional_stream_delay_request_headers_until_flush(bidirectional_stream * stream,
                                                                bint delay_headers_until_flush)
    int bidirectional_stream_start(bidirectional_stream * stream, const char * url, int priority, const char * method,
                                   const bidirectional_stream_header_array * headers, bint end_of_stream)
    int bidirectional_stream_read(bidirectional_stream * stream, char * buffer, int capacity)
    int bidirectional_stream_write(bidirectional_stream * stream, const char * buffer, int buffer_length,
                                   bint end_of_stream)
    void bidirectional_stream_flush(bidirectional_stream * stream)
    void bidirectional_stream_cancel(bidirectional_stream * stream)
    bint bidirectional_stream_is_done(bidirectional_stream * stream)
