# cython: language_level=3
# cython: cdivision=True
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

