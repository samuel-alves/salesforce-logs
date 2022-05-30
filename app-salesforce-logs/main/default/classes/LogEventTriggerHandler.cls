/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   02-22-2021   samuel.f.alves   Initial Version
 **/
public inherited sharing class LogEventTriggerHandler extends TriggerHandler {
    List<LogEvent__c> incomingRecords = new List<LogEvent__c>();

    public LogEventTriggerHandler() {
        this.incomingRecords = (List<LogEvent__c>) Trigger.new;
    }

    override public void afterInsert() {
        setParentIds(Trigger.newMap.keyset());
    }

    @future
    private static void setParentIds(Set<Id> logIds) {
        Map<String, LogEvent__c> parentLogs = new Map<String, LogEvent__c>();

        // LOGs
        // ---------------------------------------------
        List<LogEvent__c> logs = [
            SELECT Id, Request_Id__c, Parent__c, CreatedDate
            FROM LogEvent__c
            WHERE Id IN :logIds AND Parent__c = NULL
        ];

        for (LogEvent__c log : logs) {
            parentLogs.put(log.Request_Id__c, null);
        }

        // Parent LOGs
        // ---------------------------------------------
        for (LogEvent__c log : [
            SELECT Id, Request_Id__c, Parent__c, CreatedDate
            FROM LogEvent__c
            WHERE Request_Id__c IN :parentLogs.keyset() AND Parent__c = NULL
        ]) {
            LogEvent__c parentLog = parentLogs.get(log.Request_Id__c);
            if (parentLog == null) {
                parentLogs.put(log.Request_Id__c, log);
            } else if (parentLog.Id > log.Id) {
                parentLogs.put(log.Request_Id__c, log);
            }
        }

        // LOGs
        // ---------------------------------------------
        for (LogEvent__c log : logs) {
            LogEvent__c parentLog = parentLogs.get(log.Request_Id__c);
            if (log.Parent__c != null || parentLog == null)
                continue;
            log.Parent__c = parentLog.Id;
        }

        if (!logs.isEmpty())
            Database.update(logs, false);
    }
}
