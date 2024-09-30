# cython: language_level=3
# cython: cdivision=True
from libc.stdint cimport uint64_t, int32_t, uint32_t, int64_t

cdef extern from "cronet_c.h" nogil:
    ctypedef const char* Cronet_String
    ctypedef void* Cronet_RawDataPtr
    ctypedef void* Cronet_ClientContext

    # Forward declare interfaces.
    ctypedef struct Cronet_Buffer
    ctypedef struct Cronet_BufferPtr
    ctypedef struct Cronet_BufferCallback
    ctypedef struct Cronet_BufferCallbackPtr
    ctypedef struct Cronet_Runnable
    ctypedef struct Cronet_RunnablePtr
    ctypedef struct Cronet_Executor
    ctypedef struct Cronet_ExecutorPtr
    ctypedef struct Cronet_Engine
    ctypedef struct Cronet_EnginePtr
    ctypedef struct Cronet_UrlRequestStatusListener
    ctypedef struct Cronet_UrlRequestStatusListenerPtr
    ctypedef struct Cronet_UrlRequestCallback
    ctypedef struct Cronet_UrlRequestCallbackPtr
    ctypedef struct Cronet_UploadDataSink
    ctypedef struct Cronet_UploadDataSinkPtr
    ctypedef struct Cronet_UploadDataProvider
    ctypedef struct Cronet_UploadDataProviderPtr
    ctypedef struct Cronet_UrlRequest
    ctypedef struct Cronet_UrlRequestPtr
    ctypedef struct Cronet_RequestFinishedInfoListener
    ctypedef struct Cronet_RequestFinishedInfoListenerPtr

    # Forward declare structs.
    ctypedef struct Cronet_Error
    ctypedef struct Cronet_ErrorPtr
    ctypedef struct Cronet_QuicHint
    ctypedef struct Cronet_QuicHintPtr
    ctypedef struct Cronet_PublicKeyPins
    ctypedef struct Cronet_PublicKeyPinsPtr
    ctypedef struct Cronet_EngineParams
    ctypedef struct Cronet_EngineParamsPtr
    ctypedef struct Cronet_HttpHeader
    ctypedef struct Cronet_HttpHeaderPtr
    ctypedef struct Cronet_UrlResponseInfo
    ctypedef struct Cronet_UrlResponseInfoPtr
    ctypedef struct Cronet_UrlRequestParams
    ctypedef struct Cronet_UrlRequestParamsPtr
    ctypedef struct Cronet_DateTime
    ctypedef struct Cronet_DateTimePtr
    ctypedef struct Cronet_Metrics
    ctypedef struct Cronet_MetricsPtr
    ctypedef struct Cronet_RequestFinishedInfo
    ctypedef struct Cronet_RequestFinishedInfoPtr

    # Declare
    ctypedef struct stream_engine

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
    Cronet_BufferPtr Cronet_Buffer_Create()
    #Destroy an instance of Cronet_Buffer.
    void Cronet_Buffer_Destroy(Cronet_BufferPtr self)
    #Set and get app-specific Cronet_ClientContext.
    void Cronet_Buffer_SetClientContext(
        Cronet_BufferPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_Buffer_GetClientContext(Cronet_BufferPtr self)
    #Concrete methods of Cronet_Buffer implemented by Cronet.
    #The app calls them to manipulate Cronet_Buffer.
    void Cronet_Buffer_InitWithDataAndCallback(Cronet_BufferPtr self,
                                               Cronet_RawDataPtr data,
                                               uint64_t size,
                                               Cronet_BufferCallbackPtr callback)
    void Cronet_Buffer_InitWithAlloc(Cronet_BufferPtr self, uint64_t size)
    uint64_t Cronet_Buffer_GetSize(Cronet_BufferPtr self)
    Cronet_RawDataPtr Cronet_Buffer_GetData(Cronet_BufferPtr self)
    # Concrete interface Cronet_Buffer is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef void (*Cronet_Buffer_InitWithDataAndCallbackFunc)(
        Cronet_BufferPtr self,
        Cronet_RawDataPtr data,
        uint64_t size,
        Cronet_BufferCallbackPtr callback)
    ctypedef void (*Cronet_Buffer_InitWithAllocFunc)(Cronet_BufferPtr self,
                                                    uint64_t size)
    ctypedef uint64_t (*Cronet_Buffer_GetSizeFunc)(Cronet_BufferPtr self)
    ctypedef Cronet_RawDataPtr (*Cronet_Buffer_GetDataFunc)(Cronet_BufferPtr self)
    # Concrete interface Cronet_Buffer is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_BufferPtr Cronet_Buffer_CreateWith(
        Cronet_Buffer_InitWithDataAndCallbackFunc InitWithDataAndCallbackFunc,
        Cronet_Buffer_InitWithAllocFunc InitWithAllocFunc,
        Cronet_Buffer_GetSizeFunc GetSizeFunc,
        Cronet_Buffer_GetDataFunc GetDataFunc)
    ###########/
    # Abstract interface Cronet_BufferCallback is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_BufferCallback.
    void Cronet_BufferCallback_Destroy(Cronet_BufferCallbackPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_BufferCallback_SetClientContext(
        Cronet_BufferCallbackPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_BufferCallback_GetClientContext(Cronet_BufferCallbackPtr self)
    # Abstract interface Cronet_BufferCallback is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_BufferCallback_OnDestroy(Cronet_BufferCallbackPtr self,
                                         Cronet_BufferPtr buffer)
    # The app implements abstract interface Cronet_BufferCallback by defining
    # custom functions for each method.
    ctypedef void (*Cronet_BufferCallback_OnDestroyFunc)(
        Cronet_BufferCallbackPtr self,
        Cronet_BufferPtr buffer)
    # The app creates an instance of Cronet_BufferCallback by providing custom
    # functions for each method.
    Cronet_BufferCallbackPtr Cronet_BufferCallback_CreateWith(Cronet_BufferCallback_OnDestroyFunc OnDestroyFunc)

    ###########/
    # Abstract interface Cronet_Runnable is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_Runnable.
    void Cronet_Runnable_Destroy(Cronet_RunnablePtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_Runnable_SetClientContext(
        Cronet_RunnablePtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_Runnable_GetClientContext(Cronet_RunnablePtr self)
    # Abstract interface Cronet_Runnable is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_Runnable_Run(Cronet_RunnablePtr self)
    # The app implements abstract interface Cronet_Runnable by defining custom
    # functions for each method.
    ctypedef void (*Cronet_Runnable_RunFunc)(Cronet_RunnablePtr self)
    # The app creates an instance of Cronet_Runnable by providing custom functions
    # for each method.
    Cronet_RunnablePtr Cronet_Runnable_CreateWith(Cronet_Runnable_RunFunc RunFunc)

    ###########/
    # Abstract interface Cronet_Executor is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_Executor.
    void Cronet_Executor_Destroy(Cronet_ExecutorPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_Executor_SetClientContext(
        Cronet_ExecutorPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_Executor_GetClientContext(Cronet_ExecutorPtr self)
    # Abstract interface Cronet_Executor is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_Executor_Execute(Cronet_ExecutorPtr self,
                                 Cronet_RunnablePtr command)
    # The app implements abstract interface Cronet_Executor by defining custom
    # functions for each method.
    ctypedef void (*Cronet_Executor_ExecuteFunc)(Cronet_ExecutorPtr self,
                                                Cronet_RunnablePtr command)
    # The app creates an instance of Cronet_Executor by providing custom functions
    # for each method.
    Cronet_ExecutorPtr
    Cronet_Executor_CreateWith(Cronet_Executor_ExecuteFunc ExecuteFunc)

    ###########/
    # Concrete interface Cronet_Engine.

    # Create an instance of Cronet_Engine.
    Cronet_EnginePtr Cronet_Engine_Create()
    # Destroy an instance of Cronet_Engine.
    void Cronet_Engine_Destroy(Cronet_EnginePtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_Engine_SetClientContext(
        Cronet_EnginePtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_Engine_GetClientContext(Cronet_EnginePtr self)
    # Concrete methods of Cronet_Engine implemented by Cronet.
    # The app calls them to manipulate Cronet_Engine.

    Cronet_RESULT Cronet_Engine_StartWithParams(Cronet_EnginePtr self,
                                                Cronet_EngineParamsPtr params)

    bool Cronet_Engine_StartNetLogToFile(Cronet_EnginePtr self,
                                         Cronet_String file_name,
                                         bool log_all)

    void Cronet_Engine_StopNetLog(Cronet_EnginePtr self)

    Cronet_RESULT Cronet_Engine_Shutdown(Cronet_EnginePtr self)

    Cronet_String Cronet_Engine_GetVersionString(Cronet_EnginePtr self)

    Cronet_String Cronet_Engine_GetDefaultUserAgent(Cronet_EnginePtr self)

    void Cronet_Engine_AddRequestFinishedListener(
        Cronet_EnginePtr self,
        Cronet_RequestFinishedInfoListenerPtr listener,
        Cronet_ExecutorPtr executor)

    void Cronet_Engine_RemoveRequestFinishedListener(
        Cronet_EnginePtr self,
        Cronet_RequestFinishedInfoListenerPtr listener)
    # Concrete interface Cronet_Engine is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef Cronet_RESULT (*Cronet_Engine_StartWithParamsFunc)(
        Cronet_EnginePtr self,
        Cronet_EngineParamsPtr params)
    ctypedef bool (*Cronet_Engine_StartNetLogToFileFunc)(Cronet_EnginePtr self,
                                                        Cronet_String file_name,
                                                        bool log_all)
    ctypedef void (*Cronet_Engine_StopNetLogFunc)(Cronet_EnginePtr self)
    ctypedef Cronet_RESULT (*Cronet_Engine_ShutdownFunc)(Cronet_EnginePtr self)
    ctypedef Cronet_String (*Cronet_Engine_GetVersionStringFunc)(
        Cronet_EnginePtr self)
    ctypedef Cronet_String (*Cronet_Engine_GetDefaultUserAgentFunc)(
        Cronet_EnginePtr self)
    ctypedef void (*Cronet_Engine_AddRequestFinishedListenerFunc)(
        Cronet_EnginePtr self,
        Cronet_RequestFinishedInfoListenerPtr listener,
        Cronet_ExecutorPtr executor)
    ctypedef void (*Cronet_Engine_RemoveRequestFinishedListenerFunc)(
        Cronet_EnginePtr self,
        Cronet_RequestFinishedInfoListenerPtr listener)
    # Concrete interface Cronet_Engine is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_EnginePtr Cronet_Engine_CreateWith(
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
        Cronet_UrlRequestStatusListenerPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UrlRequestStatusListener_SetClientContext(
        Cronet_UrlRequestStatusListenerPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_UrlRequestStatusListener_GetClientContext(
        Cronet_UrlRequestStatusListenerPtr self)
    # Abstract interface Cronet_UrlRequestStatusListener is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_UrlRequestStatusListener_OnStatus(
        Cronet_UrlRequestStatusListenerPtr self,
        Cronet_UrlRequestStatusListener_Status status)
    # The app implements abstract interface Cronet_UrlRequestStatusListener by
    # defining custom functions for each method.
    ctypedef void (*Cronet_UrlRequestStatusListener_OnStatusFunc)(
        Cronet_UrlRequestStatusListenerPtr self,
        Cronet_UrlRequestStatusListener_Status status)
    # The app creates an instance of Cronet_UrlRequestStatusListener by providing
    # custom functions for each method.
    Cronet_UrlRequestStatusListenerPtr Cronet_UrlRequestStatusListener_CreateWith( Cronet_UrlRequestStatusListener_OnStatusFunc OnStatusFunc)


    ###########/
    # Abstract interface Cronet_UrlRequestCallback is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_UrlRequestCallback.
    void Cronet_UrlRequestCallback_Destroy(
        Cronet_UrlRequestCallbackPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UrlRequestCallback_SetClientContext(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_UrlRequestCallback_GetClientContext(Cronet_UrlRequestCallbackPtr self)
    # Abstract interface Cronet_UrlRequestCallback is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    void Cronet_UrlRequestCallback_OnRedirectReceived(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info,
        Cronet_String new_location_url)

    void Cronet_UrlRequestCallback_OnResponseStarted(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info)

    void Cronet_UrlRequestCallback_OnReadCompleted(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info,
        Cronet_BufferPtr buffer,
        uint64_t bytes_read)

    void Cronet_UrlRequestCallback_OnSucceeded(Cronet_UrlRequestCallbackPtr self,
                                               Cronet_UrlRequestPtr request,
                                               Cronet_UrlResponseInfoPtr info)

    void Cronet_UrlRequestCallback_OnFailed(Cronet_UrlRequestCallbackPtr self,
                                            Cronet_UrlRequestPtr request,
                                            Cronet_UrlResponseInfoPtr info,
                                            Cronet_ErrorPtr error)

    void Cronet_UrlRequestCallback_OnCanceled(Cronet_UrlRequestCallbackPtr self,
                                              Cronet_UrlRequestPtr request,
                                              Cronet_UrlResponseInfoPtr info)
    # The app implements abstract interface Cronet_UrlRequestCallback by defining
    # custom functions for each method.
    ctypedef void (*Cronet_UrlRequestCallback_OnRedirectReceivedFunc)(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info,
        Cronet_String new_location_url)
    ctypedef void (*Cronet_UrlRequestCallback_OnResponseStartedFunc)(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info)
    ctypedef void (*Cronet_UrlRequestCallback_OnReadCompletedFunc)(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info,
        Cronet_BufferPtr buffer,
        uint64_t bytes_read)
    ctypedef void (*Cronet_UrlRequestCallback_OnSucceededFunc)(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info)
    ctypedef void (*Cronet_UrlRequestCallback_OnFailedFunc)(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info,
        Cronet_ErrorPtr error)
    ctypedef void (*Cronet_UrlRequestCallback_OnCanceledFunc)(
        Cronet_UrlRequestCallbackPtr self,
        Cronet_UrlRequestPtr request,
        Cronet_UrlResponseInfoPtr info)
    # The app creates an instance of Cronet_UrlRequestCallback by providing custom
    # functions for each method.
    Cronet_UrlRequestCallbackPtr Cronet_UrlRequestCallback_CreateWith(
        Cronet_UrlRequestCallback_OnRedirectReceivedFunc OnRedirectReceivedFunc,
        Cronet_UrlRequestCallback_OnResponseStartedFunc OnResponseStartedFunc,
        Cronet_UrlRequestCallback_OnReadCompletedFunc OnReadCompletedFunc,
        Cronet_UrlRequestCallback_OnSucceededFunc OnSucceededFunc,
        Cronet_UrlRequestCallback_OnFailedFunc OnFailedFunc,
        Cronet_UrlRequestCallback_OnCanceledFunc OnCanceledFunc)


    ###########/
    # Concrete interface Cronet_UploadDataSink.

    # Create an instance of Cronet_UploadDataSink.
    Cronet_UploadDataSinkPtr Cronet_UploadDataSink_Create()
    # Destroy an instance of Cronet_UploadDataSink.
    void Cronet_UploadDataSink_Destroy(Cronet_UploadDataSinkPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UploadDataSink_SetClientContext(
        Cronet_UploadDataSinkPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_UploadDataSink_GetClientContext(Cronet_UploadDataSinkPtr self)
    # Concrete methods of Cronet_UploadDataSink implemented by Cronet.
    # The app calls them to manipulate Cronet_UploadDataSink.

    void Cronet_UploadDataSink_OnReadSucceeded(Cronet_UploadDataSinkPtr self,
                                               uint64_t bytes_read,
                                               bool final_chunk)

    void Cronet_UploadDataSink_OnReadError(Cronet_UploadDataSinkPtr self,
                                           Cronet_String error_message)

    void Cronet_UploadDataSink_OnRewindSucceeded(Cronet_UploadDataSinkPtr self)

    void Cronet_UploadDataSink_OnRewindError(Cronet_UploadDataSinkPtr self,
                                             Cronet_String error_message)
    # Concrete interface Cronet_UploadDataSink is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef void (*Cronet_UploadDataSink_OnReadSucceededFunc)(
        Cronet_UploadDataSinkPtr self,
        uint64_t bytes_read,
        bool final_chunk)
    ctypedef void (*Cronet_UploadDataSink_OnReadErrorFunc)(
        Cronet_UploadDataSinkPtr self,
        Cronet_String error_message)
    ctypedef void (*Cronet_UploadDataSink_OnRewindSucceededFunc)(
        Cronet_UploadDataSinkPtr self)
    ctypedef void (*Cronet_UploadDataSink_OnRewindErrorFunc)(
        Cronet_UploadDataSinkPtr self,
        Cronet_String error_message)
    # Concrete interface Cronet_UploadDataSink is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_UploadDataSinkPtr Cronet_UploadDataSink_CreateWith(
        Cronet_UploadDataSink_OnReadSucceededFunc OnReadSucceededFunc,
        Cronet_UploadDataSink_OnReadErrorFunc OnReadErrorFunc,
        Cronet_UploadDataSink_OnRewindSucceededFunc OnRewindSucceededFunc,
        Cronet_UploadDataSink_OnRewindErrorFunc OnRewindErrorFunc)


    ###########/
    # Abstract interface Cronet_UploadDataProvider is implemented by the app.

    # There is no method to create a concrete implementation.

    # Destroy an instance of Cronet_UploadDataProvider.
    void Cronet_UploadDataProvider_Destroy(
        Cronet_UploadDataProviderPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UploadDataProvider_SetClientContext(
        Cronet_UploadDataProviderPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_UploadDataProvider_GetClientContext(Cronet_UploadDataProviderPtr self)
    # Abstract interface Cronet_UploadDataProvider is implemented by the app.
    # The following concrete methods forward call to app implementation.
    # The app doesn't normally call them.

    int64_t Cronet_UploadDataProvider_GetLength(Cronet_UploadDataProviderPtr self)

    void Cronet_UploadDataProvider_Read(Cronet_UploadDataProviderPtr self,
                                        Cronet_UploadDataSinkPtr upload_data_sink,
                                        Cronet_BufferPtr buffer)

    void Cronet_UploadDataProvider_Rewind(
        Cronet_UploadDataProviderPtr self,
        Cronet_UploadDataSinkPtr upload_data_sink)

    void Cronet_UploadDataProvider_Close(Cronet_UploadDataProviderPtr self)
    # The app implements abstract interface Cronet_UploadDataProvider by defining
    # custom functions for each method.
    ctypedef int64_t (*Cronet_UploadDataProvider_GetLengthFunc)(
        Cronet_UploadDataProviderPtr self)
    ctypedef void (*Cronet_UploadDataProvider_ReadFunc)(
        Cronet_UploadDataProviderPtr self,
        Cronet_UploadDataSinkPtr upload_data_sink,
        Cronet_BufferPtr buffer)
    ctypedef void (*Cronet_UploadDataProvider_RewindFunc)(
        Cronet_UploadDataProviderPtr self,
        Cronet_UploadDataSinkPtr upload_data_sink)
    ctypedef void (*Cronet_UploadDataProvider_CloseFunc)(
        Cronet_UploadDataProviderPtr self)
    # The app creates an instance of Cronet_UploadDataProvider by providing custom
    # functions for each method.
    Cronet_UploadDataProviderPtr Cronet_UploadDataProvider_CreateWith(
        Cronet_UploadDataProvider_GetLengthFunc GetLengthFunc,
        Cronet_UploadDataProvider_ReadFunc ReadFunc,
        Cronet_UploadDataProvider_RewindFunc RewindFunc,
        Cronet_UploadDataProvider_CloseFunc CloseFunc)

    ###########/
    # Concrete interface Cronet_UrlRequest.

    # Create an instance of Cronet_UrlRequest.
    Cronet_UrlRequestPtr Cronet_UrlRequest_Create()
    # Destroy an instance of Cronet_UrlRequest.
    void Cronet_UrlRequest_Destroy(Cronet_UrlRequestPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_UrlRequest_SetClientContext(
        Cronet_UrlRequestPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext
    Cronet_UrlRequest_GetClientContext(Cronet_UrlRequestPtr self)
    # Concrete methods of Cronet_UrlRequest implemented by Cronet.
    # The app calls them to manipulate Cronet_UrlRequest.

    Cronet_RESULT Cronet_UrlRequest_InitWithParams(
        Cronet_UrlRequestPtr self,
        Cronet_EnginePtr engine,
        Cronet_String url,
        Cronet_UrlRequestParamsPtr params,
        Cronet_UrlRequestCallbackPtr callback,
        Cronet_ExecutorPtr executor)

    Cronet_RESULT Cronet_UrlRequest_Start(Cronet_UrlRequestPtr self)

    Cronet_RESULT Cronet_UrlRequest_FollowRedirect(Cronet_UrlRequestPtr self)

    Cronet_RESULT Cronet_UrlRequest_Read(Cronet_UrlRequestPtr self,
                                         Cronet_BufferPtr buffer)

    void Cronet_UrlRequest_Cancel(Cronet_UrlRequestPtr self)

    bool Cronet_UrlRequest_IsDone(Cronet_UrlRequestPtr self)

    void Cronet_UrlRequest_GetStatus(Cronet_UrlRequestPtr self,
                                     Cronet_UrlRequestStatusListenerPtr listener)
    # Concrete interface Cronet_UrlRequest is implemented by Cronet.
    # The app can implement these for testing / mocking.
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_InitWithParamsFunc)(
        Cronet_UrlRequestPtr self,
        Cronet_EnginePtr engine,
        Cronet_String url,
        Cronet_UrlRequestParamsPtr params,
        Cronet_UrlRequestCallbackPtr callback,
        Cronet_ExecutorPtr executor)
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_StartFunc)(Cronet_UrlRequestPtr self)
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_FollowRedirectFunc)(
        Cronet_UrlRequestPtr self)
    ctypedef Cronet_RESULT (*Cronet_UrlRequest_ReadFunc)(Cronet_UrlRequestPtr self,
                                                        Cronet_BufferPtr buffer)
    ctypedef void (*Cronet_UrlRequest_CancelFunc)(Cronet_UrlRequestPtr self)
    ctypedef bool (*Cronet_UrlRequest_IsDoneFunc)(Cronet_UrlRequestPtr self)
    ctypedef void (*Cronet_UrlRequest_GetStatusFunc)(
        Cronet_UrlRequestPtr self,
        Cronet_UrlRequestStatusListenerPtr listener)
    # Concrete interface Cronet_UrlRequest is implemented by Cronet.
    # The app can use this for testing / mocking.
    Cronet_UrlRequestPtr Cronet_UrlRequest_CreateWith(
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
        Cronet_RequestFinishedInfoListenerPtr self)
    # Set and get app-specific Cronet_ClientContext.
    void Cronet_RequestFinishedInfoListener_SetClientContext(
        Cronet_RequestFinishedInfoListenerPtr self,
        Cronet_ClientContext client_context)
    Cronet_ClientContext Cronet_RequestFinishedInfoListener_GetClientContext(
        Cronet_RequestFinishedInfoListenerPtr self)
    # Abstract interface Cronet_RequestFinishedInfoListener is implemented by the
    # app. The following concrete methods forward call to app implementation. The
    # app doesn't normally call them.

    void Cronet_RequestFinishedInfoListener_OnRequestFinished(
        Cronet_RequestFinishedInfoListenerPtr self,
        Cronet_RequestFinishedInfoPtr request_info,
        Cronet_UrlResponseInfoPtr response_info,
        Cronet_ErrorPtr error)
    # The app implements abstract interface Cronet_RequestFinishedInfoListener by
    # defining custom functions for each method.
    ctypedef void (*Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc)(
        Cronet_RequestFinishedInfoListenerPtr self,
        Cronet_RequestFinishedInfoPtr request_info,
        Cronet_UrlResponseInfoPtr response_info,
        Cronet_ErrorPtr error)
    # The app creates an instance of Cronet_RequestFinishedInfoListener by
    # providing custom functions for each method.
    Cronet_RequestFinishedInfoListenerPtr
    Cronet_RequestFinishedInfoListener_CreateWith(
        Cronet_RequestFinishedInfoListener_OnRequestFinishedFunc
            OnRequestFinishedFunc)

    ###########/
    # Struct Cronet_Error.
    Cronet_ErrorPtr Cronet_Error_Create()
    void Cronet_Error_Destroy(Cronet_ErrorPtr self)
    # Cronet_Error setters.

    void Cronet_Error_error_code_set(Cronet_ErrorPtr self,
                                     const Cronet_Error_ERROR_CODE error_code)

    void Cronet_Error_message_set(Cronet_ErrorPtr self,
                                  const Cronet_String message)

    void Cronet_Error_internal_error_code_set(Cronet_ErrorPtr self,
                                              const int32_t internal_error_code)

    void Cronet_Error_immediately_retryable_set(Cronet_ErrorPtr self,
                                                const bool immediately_retryable)

    void Cronet_Error_quic_detailed_error_code_set(
        Cronet_ErrorPtr self,
        const int32_t quic_detailed_error_code)
    # Cronet_Error getters.

    Cronet_Error_ERROR_CODE Cronet_Error_error_code_get(const Cronet_ErrorPtr self)

    Cronet_String Cronet_Error_message_get(const Cronet_ErrorPtr self)

    int32_t Cronet_Error_internal_error_code_get(const Cronet_ErrorPtr self)

    bool Cronet_Error_immediately_retryable_get(const Cronet_ErrorPtr self)

    int32_t Cronet_Error_quic_detailed_error_code_get(const Cronet_ErrorPtr self)

    ###########/
    # Struct Cronet_QuicHint.
    Cronet_QuicHintPtr Cronet_QuicHint_Create()
    void Cronet_QuicHint_Destroy(Cronet_QuicHintPtr self)
    # Cronet_QuicHint setters.

    void Cronet_QuicHint_host_set(Cronet_QuicHintPtr self,
                                  const Cronet_String host)

    void Cronet_QuicHint_port_set(Cronet_QuicHintPtr self, const int32_t port)

    void Cronet_QuicHint_alternate_port_set(Cronet_QuicHintPtr self,
                                            const int32_t alternate_port)
    # Cronet_QuicHint getters.

    Cronet_String Cronet_QuicHint_host_get(const Cronet_QuicHintPtr self)

    int32_t Cronet_QuicHint_port_get(const Cronet_QuicHintPtr self)

    int32_t Cronet_QuicHint_alternate_port_get(const Cronet_QuicHintPtr self)

    ###########/
    # Struct Cronet_PublicKeyPins.
    Cronet_PublicKeyPinsPtr Cronet_PublicKeyPins_Create()
    void Cronet_PublicKeyPins_Destroy(Cronet_PublicKeyPinsPtr self)
    # Cronet_PublicKeyPins setters.

    void Cronet_PublicKeyPins_host_set(Cronet_PublicKeyPinsPtr self,
                                       const Cronet_String host)

    void Cronet_PublicKeyPins_pins_sha256_add(Cronet_PublicKeyPinsPtr self,
                                              const Cronet_String element)

    void Cronet_PublicKeyPins_include_subdomains_set(Cronet_PublicKeyPinsPtr self,
                                                     const bool include_subdomains)

    void Cronet_PublicKeyPins_expiration_date_set(Cronet_PublicKeyPinsPtr self,
                                                  const int64_t expiration_date)
    # Cronet_PublicKeyPins getters.

    Cronet_String Cronet_PublicKeyPins_host_get(const Cronet_PublicKeyPinsPtr self)

    uint32_t Cronet_PublicKeyPins_pins_sha256_size(
        const Cronet_PublicKeyPinsPtr self)

    Cronet_String Cronet_PublicKeyPins_pins_sha256_at(
        const Cronet_PublicKeyPinsPtr self,
        uint32_t index)

    void Cronet_PublicKeyPins_pins_sha256_clear(Cronet_PublicKeyPinsPtr self)

    bool Cronet_PublicKeyPins_include_subdomains_get(
        const Cronet_PublicKeyPinsPtr self)

    int64_t Cronet_PublicKeyPins_expiration_date_get(
        const Cronet_PublicKeyPinsPtr self)

    ###########/
    # Struct Cronet_EngineParams.
    Cronet_EngineParamsPtr Cronet_EngineParams_Create()
    void Cronet_EngineParams_Destroy(Cronet_EngineParamsPtr self)
    # Cronet_EngineParams setters.

    void Cronet_EngineParams_enable_check_result_set(
        Cronet_EngineParamsPtr self,
        const bool enable_check_result)

    void Cronet_EngineParams_user_agent_set(Cronet_EngineParamsPtr self,
                                            const Cronet_String user_agent)

    void Cronet_EngineParams_accept_language_set(
        Cronet_EngineParamsPtr self,
        const Cronet_String accept_language)

    void Cronet_EngineParams_storage_path_set(Cronet_EngineParamsPtr self,
                                              const Cronet_String storage_path)

    void Cronet_EngineParams_enable_quic_set(Cronet_EngineParamsPtr self,
                                             const bool enable_quic)

    void Cronet_EngineParams_enable_http2_set(Cronet_EngineParamsPtr self,
                                              const bool enable_http2)

    void Cronet_EngineParams_enable_brotli_set(Cronet_EngineParamsPtr self,
                                               const bool enable_brotli)

    void Cronet_EngineParams_http_cache_mode_set(
        Cronet_EngineParamsPtr self,
        const Cronet_EngineParams_HTTP_CACHE_MODE http_cache_mode)

    void Cronet_EngineParams_http_cache_max_size_set(
        Cronet_EngineParamsPtr self,
        const int64_t http_cache_max_size)

    void Cronet_EngineParams_quic_hints_add(Cronet_EngineParamsPtr self,
                                            const Cronet_QuicHintPtr element)

    void Cronet_EngineParams_public_key_pins_add(
        Cronet_EngineParamsPtr self,
        const Cronet_PublicKeyPinsPtr element)

    void Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_set(
        Cronet_EngineParamsPtr self,
        const bool enable_public_key_pinning_bypass_for_local_trust_anchors)

    void Cronet_EngineParams_network_thread_priority_set(
        Cronet_EngineParamsPtr self,
        const double network_thread_priority)

    void Cronet_EngineParams_experimental_options_set(
        Cronet_EngineParamsPtr self,
        const Cronet_String experimental_options)
    # Cronet_EngineParams getters.

    bool Cronet_EngineParams_enable_check_result_get(
        const Cronet_EngineParamsPtr self)

    Cronet_String Cronet_EngineParams_user_agent_get(
        const Cronet_EngineParamsPtr self)

    Cronet_String Cronet_EngineParams_accept_language_get(
        const Cronet_EngineParamsPtr self)

    Cronet_String Cronet_EngineParams_storage_path_get(
        const Cronet_EngineParamsPtr self)

    bool Cronet_EngineParams_enable_quic_get(const Cronet_EngineParamsPtr self)

    bool Cronet_EngineParams_enable_http2_get(const Cronet_EngineParamsPtr self)

    bool Cronet_EngineParams_enable_brotli_get(const Cronet_EngineParamsPtr self)

    Cronet_EngineParams_HTTP_CACHE_MODE Cronet_EngineParams_http_cache_mode_get(
        const Cronet_EngineParamsPtr self)

    int64_t Cronet_EngineParams_http_cache_max_size_get(
        const Cronet_EngineParamsPtr self)

    uint32_t Cronet_EngineParams_quic_hints_size(const Cronet_EngineParamsPtr self)

    Cronet_QuicHintPtr Cronet_EngineParams_quic_hints_at(
        const Cronet_EngineParamsPtr self,
        uint32_t index)

    void Cronet_EngineParams_quic_hints_clear(Cronet_EngineParamsPtr self)

    uint32_t Cronet_EngineParams_public_key_pins_size(
        const Cronet_EngineParamsPtr self)

    Cronet_PublicKeyPinsPtr Cronet_EngineParams_public_key_pins_at(
        const Cronet_EngineParamsPtr self,
        uint32_t index)

    void Cronet_EngineParams_public_key_pins_clear(Cronet_EngineParamsPtr self)

    bool Cronet_EngineParams_enable_public_key_pinning_bypass_for_local_trust_anchors_get(
        const Cronet_EngineParamsPtr self)

    double Cronet_EngineParams_network_thread_priority_get(
        const Cronet_EngineParamsPtr self)

    Cronet_String Cronet_EngineParams_experimental_options_get(
        const Cronet_EngineParamsPtr self)

    ###########/
    # Struct Cronet_HttpHeader.
    Cronet_HttpHeaderPtr Cronet_HttpHeader_Create()
    void Cronet_HttpHeader_Destroy(Cronet_HttpHeaderPtr self)
    # Cronet_HttpHeader setters.

    void Cronet_HttpHeader_name_set(Cronet_HttpHeaderPtr self,
                                    const Cronet_String name)

    void Cronet_HttpHeader_value_set(Cronet_HttpHeaderPtr self,
                                     const Cronet_String value)
    # Cronet_HttpHeader getters.

    Cronet_String Cronet_HttpHeader_name_get(const Cronet_HttpHeaderPtr self)

    Cronet_String Cronet_HttpHeader_value_get(const Cronet_HttpHeaderPtr self)

    ###########/
    # Struct Cronet_UrlResponseInfo.
    Cronet_UrlResponseInfoPtr Cronet_UrlResponseInfo_Create()
    void Cronet_UrlResponseInfo_Destroy(
        Cronet_UrlResponseInfoPtr self)
    # Cronet_UrlResponseInfo setters.

    void Cronet_UrlResponseInfo_url_set(Cronet_UrlResponseInfoPtr self,
                                        const Cronet_String url)

    void Cronet_UrlResponseInfo_url_chain_add(Cronet_UrlResponseInfoPtr self,
                                              const Cronet_String element)

    void Cronet_UrlResponseInfo_http_status_code_set(
        Cronet_UrlResponseInfoPtr self,
        const int32_t http_status_code)

    void Cronet_UrlResponseInfo_http_status_text_set(
        Cronet_UrlResponseInfoPtr self,
        const Cronet_String http_status_text)

    void Cronet_UrlResponseInfo_all_headers_list_add(
        Cronet_UrlResponseInfoPtr self,
        const Cronet_HttpHeaderPtr element)

    void Cronet_UrlResponseInfo_was_cached_set(Cronet_UrlResponseInfoPtr self,
                                               const bool was_cached)

    void Cronet_UrlResponseInfo_negotiated_protocol_set(
        Cronet_UrlResponseInfoPtr self,
        const Cronet_String negotiated_protocol)

    void Cronet_UrlResponseInfo_proxy_server_set(Cronet_UrlResponseInfoPtr self,
                                                 const Cronet_String proxy_server)

    void Cronet_UrlResponseInfo_received_byte_count_set(
        Cronet_UrlResponseInfoPtr self,
        const int64_t received_byte_count)
    # Cronet_UrlResponseInfo getters.

    Cronet_String Cronet_UrlResponseInfo_url_get(
        const Cronet_UrlResponseInfoPtr self)

    uint32_t Cronet_UrlResponseInfo_url_chain_size(
        const Cronet_UrlResponseInfoPtr self)

    Cronet_String Cronet_UrlResponseInfo_url_chain_at(
        const Cronet_UrlResponseInfoPtr self,
        uint32_t index)

    void Cronet_UrlResponseInfo_url_chain_clear(Cronet_UrlResponseInfoPtr self)

    int32_t Cronet_UrlResponseInfo_http_status_code_get(
        const Cronet_UrlResponseInfoPtr self)

    Cronet_String Cronet_UrlResponseInfo_http_status_text_get(
        const Cronet_UrlResponseInfoPtr self)

    uint32_t Cronet_UrlResponseInfo_all_headers_list_size(
        const Cronet_UrlResponseInfoPtr self)

    Cronet_HttpHeaderPtr Cronet_UrlResponseInfo_all_headers_list_at(
        const Cronet_UrlResponseInfoPtr self,
        uint32_t index)

    void Cronet_UrlResponseInfo_all_headers_list_clear(
        Cronet_UrlResponseInfoPtr self)

    bool Cronet_UrlResponseInfo_was_cached_get(
        const Cronet_UrlResponseInfoPtr self)

    Cronet_String Cronet_UrlResponseInfo_negotiated_protocol_get(
        const Cronet_UrlResponseInfoPtr self)

    Cronet_String Cronet_UrlResponseInfo_proxy_server_get(
        const Cronet_UrlResponseInfoPtr self)

    int64_t Cronet_UrlResponseInfo_received_byte_count_get(
        const Cronet_UrlResponseInfoPtr self)


    ###########/
    # Struct Cronet_UrlRequestParams.
    Cronet_UrlRequestParamsPtr Cronet_UrlRequestParams_Create()
    void Cronet_UrlRequestParams_Destroy(
        Cronet_UrlRequestParamsPtr self)
    # Cronet_UrlRequestParams setters.

    void Cronet_UrlRequestParams_http_method_set(Cronet_UrlRequestParamsPtr self,
                                                 const Cronet_String http_method)

    void Cronet_UrlRequestParams_request_headers_add(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_HttpHeaderPtr element)

    void Cronet_UrlRequestParams_disable_cache_set(Cronet_UrlRequestParamsPtr self,
                                                   const bool disable_cache)

    void Cronet_UrlRequestParams_priority_set(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_UrlRequestParams_REQUEST_PRIORITY priority)

    void Cronet_UrlRequestParams_upload_data_provider_set(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_UploadDataProviderPtr upload_data_provider)

    void Cronet_UrlRequestParams_upload_data_provider_executor_set(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_ExecutorPtr upload_data_provider_executor)

    void Cronet_UrlRequestParams_allow_direct_executor_set(
        Cronet_UrlRequestParamsPtr self,
        const bool allow_direct_executor)

    void Cronet_UrlRequestParams_annotations_add(Cronet_UrlRequestParamsPtr self,
                                                 const Cronet_RawDataPtr element)

    void Cronet_UrlRequestParams_request_finished_listener_set(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_RequestFinishedInfoListenerPtr request_finished_listener)

    void Cronet_UrlRequestParams_request_finished_executor_set(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_ExecutorPtr request_finished_executor)

    void Cronet_UrlRequestParams_idempotency_set(
        Cronet_UrlRequestParamsPtr self,
        const Cronet_UrlRequestParams_IDEMPOTENCY idempotency)
    # Cronet_UrlRequestParams getters.

    Cronet_String Cronet_UrlRequestParams_http_method_get(
        const Cronet_UrlRequestParamsPtr self)

    uint32_t Cronet_UrlRequestParams_request_headers_size(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_HttpHeaderPtr Cronet_UrlRequestParams_request_headers_at(
        const Cronet_UrlRequestParamsPtr self,
        uint32_t index)

    void Cronet_UrlRequestParams_request_headers_clear(
        Cronet_UrlRequestParamsPtr self)

    bool Cronet_UrlRequestParams_disable_cache_get(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_UrlRequestParams_REQUEST_PRIORITY Cronet_UrlRequestParams_priority_get(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_UploadDataProviderPtr Cronet_UrlRequestParams_upload_data_provider_get(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_ExecutorPtr Cronet_UrlRequestParams_upload_data_provider_executor_get(
        const Cronet_UrlRequestParamsPtr self)

    bool Cronet_UrlRequestParams_allow_direct_executor_get(
        const Cronet_UrlRequestParamsPtr self)

    uint32_t Cronet_UrlRequestParams_annotations_size(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_RawDataPtr Cronet_UrlRequestParams_annotations_at(
        const Cronet_UrlRequestParamsPtr self,
        uint32_t index)

    void Cronet_UrlRequestParams_annotations_clear(Cronet_UrlRequestParamsPtr self)

    Cronet_RequestFinishedInfoListenerPtr
    Cronet_UrlRequestParams_request_finished_listener_get(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_ExecutorPtr Cronet_UrlRequestParams_request_finished_executor_get(
        const Cronet_UrlRequestParamsPtr self)

    Cronet_UrlRequestParams_IDEMPOTENCY Cronet_UrlRequestParams_idempotency_get(
        const Cronet_UrlRequestParamsPtr self)

    ###########/
    # Struct Cronet_DateTime.
    Cronet_DateTimePtr Cronet_DateTime_Create()
    void Cronet_DateTime_Destroy(Cronet_DateTimePtr self)
    # Cronet_DateTime setters.

    void Cronet_DateTime_value_set(Cronet_DateTimePtr self, const int64_t value)
    # Cronet_DateTime getters.

    int64_t Cronet_DateTime_value_get(const Cronet_DateTimePtr self)

    ###########/
    # Struct Cronet_Metrics.
    Cronet_MetricsPtr Cronet_Metrics_Create()
    void Cronet_Metrics_Destroy(Cronet_MetricsPtr self)
    # Cronet_Metrics setters.

    void Cronet_Metrics_request_start_set(Cronet_MetricsPtr self,
                                          const Cronet_DateTimePtr request_start)
    # Move data from |request_start|. The caller retains ownership of
    # |request_start| and must destroy it.
    void Cronet_Metrics_request_start_move(Cronet_MetricsPtr self,
                                           Cronet_DateTimePtr request_start)

    void Cronet_Metrics_dns_start_set(Cronet_MetricsPtr self,
                                      const Cronet_DateTimePtr dns_start)
    # Move data from |dns_start|. The caller retains ownership of |dns_start| and
    # must destroy it.
    void Cronet_Metrics_dns_start_move(Cronet_MetricsPtr self,
                                       Cronet_DateTimePtr dns_start)

    void Cronet_Metrics_dns_end_set(Cronet_MetricsPtr self,
                                    const Cronet_DateTimePtr dns_end)
    # Move data from |dns_end|. The caller retains ownership of |dns_end| and must
    # destroy it.
    void Cronet_Metrics_dns_end_move(Cronet_MetricsPtr self,
                                     Cronet_DateTimePtr dns_end)

    void Cronet_Metrics_connect_start_set(Cronet_MetricsPtr self,
                                          const Cronet_DateTimePtr connect_start)
    # Move data from |connect_start|. The caller retains ownership of
    # |connect_start| and must destroy it.
    void Cronet_Metrics_connect_start_move(Cronet_MetricsPtr self,
                                           Cronet_DateTimePtr connect_start)

    void Cronet_Metrics_connect_end_set(Cronet_MetricsPtr self,
                                        const Cronet_DateTimePtr connect_end)
    # Move data from |connect_end|. The caller retains ownership of |connect_end|
    # and must destroy it.
    void Cronet_Metrics_connect_end_move(Cronet_MetricsPtr self,
                                         Cronet_DateTimePtr connect_end)

    void Cronet_Metrics_ssl_start_set(Cronet_MetricsPtr self,
                                      const Cronet_DateTimePtr ssl_start)
    # Move data from |ssl_start|. The caller retains ownership of |ssl_start| and
    # must destroy it.
    void Cronet_Metrics_ssl_start_move(Cronet_MetricsPtr self,
                                       Cronet_DateTimePtr ssl_start)

    void Cronet_Metrics_ssl_end_set(Cronet_MetricsPtr self,
                                    const Cronet_DateTimePtr ssl_end)
    # Move data from |ssl_end|. The caller retains ownership of |ssl_end| and must
    # destroy it.
    void Cronet_Metrics_ssl_end_move(Cronet_MetricsPtr self,
                                     Cronet_DateTimePtr ssl_end)

    void Cronet_Metrics_sending_start_set(Cronet_MetricsPtr self,
                                          const Cronet_DateTimePtr sending_start)
    # Move data from |sending_start|. The caller retains ownership of
    # |sending_start| and must destroy it.
    void Cronet_Metrics_sending_start_move(Cronet_MetricsPtr self,
                                           Cronet_DateTimePtr sending_start)

    void Cronet_Metrics_sending_end_set(Cronet_MetricsPtr self,
                                        const Cronet_DateTimePtr sending_end)
    # Move data from |sending_end|. The caller retains ownership of |sending_end|
    # and must destroy it.
    void Cronet_Metrics_sending_end_move(Cronet_MetricsPtr self,
                                         Cronet_DateTimePtr sending_end)

    void Cronet_Metrics_push_start_set(Cronet_MetricsPtr self,
                                       const Cronet_DateTimePtr push_start)
    # Move data from |push_start|. The caller retains ownership of |push_start| and
    # must destroy it.
    void Cronet_Metrics_push_start_move(Cronet_MetricsPtr self,
                                        Cronet_DateTimePtr push_start)

    void Cronet_Metrics_push_end_set(Cronet_MetricsPtr self,
                                     const Cronet_DateTimePtr push_end)
    # Move data from |push_end|. The caller retains ownership of |push_end| and
    # must destroy it.
    void Cronet_Metrics_push_end_move(Cronet_MetricsPtr self,
                                      Cronet_DateTimePtr push_end)

    void Cronet_Metrics_response_start_set(Cronet_MetricsPtr self,
                                           const Cronet_DateTimePtr response_start)
    # Move data from |response_start|. The caller retains ownership of
    # |response_start| and must destroy it.
    void Cronet_Metrics_response_start_move(Cronet_MetricsPtr self,
                                            Cronet_DateTimePtr response_start)

    void Cronet_Metrics_request_end_set(Cronet_MetricsPtr self,
                                        const Cronet_DateTimePtr request_end)
    # Move data from |request_end|. The caller retains ownership of |request_end|
    # and must destroy it.
    void Cronet_Metrics_request_end_move(Cronet_MetricsPtr self,
                                         Cronet_DateTimePtr request_end)

    void Cronet_Metrics_socket_reused_set(Cronet_MetricsPtr self,
                                          const bool socket_reused)

    void Cronet_Metrics_sent_byte_count_set(Cronet_MetricsPtr self,
                                            const int64_t sent_byte_count)

    void Cronet_Metrics_received_byte_count_set(Cronet_MetricsPtr self,
                                                const int64_t received_byte_count)
    # Cronet_Metrics getters.

    Cronet_DateTimePtr Cronet_Metrics_request_start_get(
        const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_dns_start_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_dns_end_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_connect_start_get(
        const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_connect_end_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_ssl_start_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_ssl_end_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_sending_start_get(
        const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_sending_end_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_push_start_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_push_end_get(const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_response_start_get(
        const Cronet_MetricsPtr self)

    Cronet_DateTimePtr Cronet_Metrics_request_end_get(const Cronet_MetricsPtr self)

    bool Cronet_Metrics_socket_reused_get(const Cronet_MetricsPtr self)

    int64_t Cronet_Metrics_sent_byte_count_get(const Cronet_MetricsPtr self)

    int64_t Cronet_Metrics_received_byte_count_get(const Cronet_MetricsPtr self)

    ###########/
    # Struct Cronet_RequestFinishedInfo.
    Cronet_RequestFinishedInfoPtr
    Cronet_RequestFinishedInfo_Create()
    void Cronet_RequestFinishedInfo_Destroy(
        Cronet_RequestFinishedInfoPtr self)
    # Cronet_RequestFinishedInfo setters.

    void Cronet_RequestFinishedInfo_metrics_set(Cronet_RequestFinishedInfoPtr self,
                                                const Cronet_MetricsPtr metrics)
    # Move data from |metrics|. The caller retains ownership of |metrics| and must
    # destroy it.
    void Cronet_RequestFinishedInfo_metrics_move(Cronet_RequestFinishedInfoPtr self,
                                                 Cronet_MetricsPtr metrics)

    void Cronet_RequestFinishedInfo_annotations_add(
        Cronet_RequestFinishedInfoPtr self,
        const Cronet_RawDataPtr element)

    void Cronet_RequestFinishedInfo_finished_reason_set(
        Cronet_RequestFinishedInfoPtr self,
        const Cronet_RequestFinishedInfo_FINISHED_REASON finished_reason)
    # Cronet_RequestFinishedInfo getters.

    Cronet_MetricsPtr Cronet_RequestFinishedInfo_metrics_get(
        const Cronet_RequestFinishedInfoPtr self)

    uint32_t Cronet_RequestFinishedInfo_annotations_size(
        const Cronet_RequestFinishedInfoPtr self)

    Cronet_RawDataPtr Cronet_RequestFinishedInfo_annotations_at(
        const Cronet_RequestFinishedInfoPtr self,
        uint32_t index)

    void Cronet_RequestFinishedInfo_annotations_clear(
        Cronet_RequestFinishedInfoPtr self)

    Cronet_RequestFinishedInfo_FINISHED_REASON
    Cronet_RequestFinishedInfo_finished_reason_get(
        const Cronet_RequestFinishedInfoPtr self)

    ## declared from cronet_c.h
    # Sets net::CertVerifier* raw_mock_cert_verifier for testing of Cronet_Engine.
    # Must be called before Cronet_Engine_InitWithParams().
    void Cronet_Engine_SetMockCertVerifierForTesting(
            Cronet_EnginePtr engine,
            void * raw_mock_cert_verifier)

    # Returns "stream_engine" interface for bidirectional stream support for GRPC.
    # Returned stream engine is owned by Cronet Engine and is only valid until
    # Cronet_Engine_Shutdown().
    stream_engine * Cronet_Engine_GetStreamEngine(
            Cronet_EnginePtr engine)

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
    void bidirectional_stream_disable_auto_flush(bidirectional_stream * stream, bool disable_auto_flush)
    void bidirectional_stream_delay_request_headers_until_flush(bidirectional_stream * stream,
                                                                bool delay_headers_until_flush)
    int bidirectional_stream_start(bidirectional_stream * stream, const char * url, int priority, const char * method,
                                   const bidirectional_stream_header_array * headers, bool end_of_stream)
    int bidirectional_stream_read(bidirectional_stream * stream, char * buffer, int capacity)
    int bidirectional_stream_write(bidirectional_stream * stream, const char * buffer, int buffer_length,
                                   bool end_of_stream)
    void bidirectional_stream_flush(bidirectional_stream * stream)
    void bidirectional_stream_cancel(bidirectional_stream * stream)
    bool bidirectional_stream_is_done(bidirectional_stream * stream)

