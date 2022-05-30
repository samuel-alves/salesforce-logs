/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 **/
public with sharing class LogEventDeleteBatch implements Schedulable, Database.Batchable<SObject>, Database.stateful {
    private String query;
    private static final String CLASSNAME = 'LogEventDeleteBatch';
    private static Log logger = Log.get();

    public LogEventDeleteBatch() {
        this.query = getBatchQuery();
    }

    private String getBatchQuery() {
        return 'SELECT Id,Name,CreatedDate FROM LogEvent__c WHERE CreatedDate = LAST_N_MONTHS:2';
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<LogEvent__c> lstLogsToDelete = (List<LogEvent__c>) scope;

        try {
            delete lstLogsToDelete;
        } catch (Exception e) {
            logger.publish(
                'Exception Caught deleting logs: ' +
                e.getMessage() +
                ' Line: ' +
                e.getLineNumber(),
                LogSeverity.ERROR,
                CLASSNAME
            );
        }
    }

    public void execute(SchedulableContext sc) {
        LogEventDeleteBatch lb = new LogEventDeleteBatch();
        Database.executeBatch(lb, 200);
    }

    public void finish(Database.BatchableContext bc) {
    }
}
