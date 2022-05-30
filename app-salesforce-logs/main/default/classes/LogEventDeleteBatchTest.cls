/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 **/
@isTest
public with sharing class LogEventDeleteBatchTest {
    @TestSetup
    static void makeData() {
        createLogs(200);
    }

    @IsTest
    static void methodTestBatch() {
        for (LogEvent__c log : [
            SELECT Id, CreatedDate
            FROM LogEvent__c
            LIMIT 200
        ]) {
            Test.setCreatedDate(log.Id, System.now().addMonths(-1));
        }

        Test.startTest();
        LogEventDeleteBatch batch = new LogEventDeleteBatch();
        Database.executeBatch(batch, 200);

        System.assertEquals(
            200,
            Database.countQuery(
                'SELECT COUNT() FROM LogEvent__c WHERE CreatedDate = LAST_N_MONTHS:2'
            )
        );
        Test.stopTest();
    }

    @IsTest
    static void methodTestScheduleBatch() {
        Test.startTest();
        String cron = '0 0 * * * ?';
        LogEventDeleteBatch batch = new LogEventDeleteBatch();
        String jobID = System.schedule(
            'LogEventDeleteBatch - ' +
            System.now() +
            ': ' +
            cron,
            cron,
            batch
        );
        Test.stopTest();

        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        System.assertEquals(cron, ct.CronExpression, 'Method should schedule');
    }

    private static List<LogEvent__c> createLogs(Integer numRecords) {
        List<LogEvent__c> lstLogs = new List<LogEvent__c>();

        for (Integer i = 0; i < numRecords; i++) {
            LogEvent__c newLog = new LogEvent__c();
            newLog.Quiddity__c = 'FUTURE';
            newLog.Tag__c = 'UNIT TEST LOG ' + i;
            newLog.Severity__c = 'ERROR';
            newLog.Request_Id__c = '4gjswdJuHCzm08G-mMQpw-' + i;
            newLog.Log_Data__c = 'Teste ' + i;
            lstLogs.add(newLog);
        }
        insert lstLogs;

        return lstLogs;
    }
}
