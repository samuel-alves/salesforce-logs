/**
 * @description       : A class for automatically attaching metadata to log messages
 * like Quiddity and RequestID
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 **/
public inherited sharing class LogMessage {
    private static final String EXCEPTION_STRING_FORMAT = 'Exception: [{0}] {1} \n StackTrace: {2}';

    public String requestId {
        get {
            if (requestId == null) {
                requestId = Request.getCurrent().getRequestId();
            }
            return requestId;
        }
        private set;
    }

    public Quiddity quiddity {
        get {
            if (quiddity == null) {
                quiddity = Request.getCurrent().getQuiddity();
            }
            return quiddity;
        }
        private set;
    }

    public String tag { get; set; }
    public String message { get; set; }

    public LogSeverity severity { get; set; }

    public SObject toEvent() {
        return new Log__e(
            Tag__c = this.tag,
            Log_Message__c = this.message,
            Request_Id__c = this.requestId,
            Quiddity__c = this.quiddity?.name(),
            Severity__c = this.severity?.name()
        );
    }

    public LogMessage(String message) {
        this.message = message;
        this.severity = LogSeverity.INFO;
    }

    public LogMessage(Exception ex) {
        this.message = String.format(
            EXCEPTION_STRING_FORMAT,
            new List<String>{
                ex.getTypeName(),
                ex.getMessage(),
                ex.getStackTraceString()
            }
        );
        this.severity = LogSeverity.ERROR;
    }
}
