# cython: language_level=3
# cython: cdivision=True
from libc.stdint cimport uint64_t

cdef extern from ".h" nogil:
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
    Cronet_EnginePtr Cronet_Engine_Create(void)
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
    Cronet_UploadDataSinkPtr Cronet_UploadDataSink_Create(void)
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
