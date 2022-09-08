/**
 * @description       : A class for automatically attaching metadata to log messages
 * like Quiddity and RequestID
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-09-08
 * @last modified by  : samuelalves@loba.pt
 **/
public inherited sharing class LogMessage {
    private static Schema.DescribeSObjectResult sObjLogSchema = Log__e.sObjectType.getDescribe();
    private static Map<String, Schema.SObjectField> sObjLogFields = sObjLogSchema.fields.getMap();

    public static final Integer STRING_MAX_SIZE_MESSAGE = sObjLogFields.get(
            'LogMessage__c'
        )
        .getDescribe()
        .getLength();
    public static final Integer STRING_MAX_SIZE_TAG = sObjLogFields.get(
            'Tag__c'
        )
        .getDescribe()
        .getLength();
    public static final Integer STRING_MAX_SIZE_QUIDDITY = sObjLogFields.get(
            'Quiddity__c'
        )
        .getDescribe()
        .getLength();
    public static final Integer STRING_MAX_SIZE_REQUEST_ID = sObjLogFields.get(
            'RequestId__c'
        )
        .getDescribe()
        .getLength();

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

    public List<SObject> toEvent() {
        List<SObject> output = new List<SObject>();
        if (String.isNotBlank(this.message)) {
            for (
                Integer i = 0;
                i < this.message.length();
                i += STRING_MAX_SIZE_MESSAGE
            ) {
                Integer startIndex = i;
                Integer endIndex = i + STRING_MAX_SIZE_MESSAGE >=
                    this.message.length()
                    ? this.message.length()
                    : i + STRING_MAX_SIZE_MESSAGE;

                output.add(
                    new Log__e(
                        Tag__c = this.tag?.left(STRING_MAX_SIZE_TAG),
                        LogMessage__c = this.message.substring(
                            startIndex,
                            endIndex
                        ),
                        RequestId__c = this.requestId
                            ?.left(STRING_MAX_SIZE_REQUEST_ID),
                        Quiddity__c = this.quiddity
                            ?.name()
                            ?.left(STRING_MAX_SIZE_QUIDDITY),
                        Severity__c = this.severity?.name()
                    )
                );
            }
        }
        return output;
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
