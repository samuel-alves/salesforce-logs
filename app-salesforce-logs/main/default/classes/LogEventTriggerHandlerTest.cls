/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-09-08
 * @last modified by  : samuelalves@loba.pt
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   04-05-2021   samuel.f.alves   Initial Version
 **/
@isTest
public with sharing class LogEventTriggerHandlerTest {
    @IsTest
    static void methodTestTrigger() {
        List<LogEvent__c> lstLogEvent = new List<LogEvent__c>();

        Test.startTest();
        LogEvent__c log = new LogEvent__c();
        log.RequestId__c = '1234';
        log.Quiddity__c = 'REST';
        log.Severity__c = 'Debug';
        log.Tag__c = 'Test Log';
        log.LogData__c =
            '{' +
            +'"statusDescription" : "Update failed. First exception on row 0; first error: MISSING_ARGUMENT, Id not specified in an update call: []",' +
            +'"status" : "ERROR"' +
            +'}';
        lstLogEvent.add(log);

        LogEvent__c logParent = new LogEvent__c();
        logParent.RequestId__c = '1234';
        logParent.Quiddity__c = 'REST';
        logParent.Severity__c = 'Debug';
        logParent.Tag__c = 'Test Log Parent';
        logParent.LogData__c =
            '{' +
            +'"statusDescription" : "Update failed. First exception on row 0; first error: MISSING_ARGUMENT, Id not specified in an update call: []",' +
            +'"status" : "ERROR"' +
            +'}';
        lstLogEvent.add(logParent);

        insert lstLogEvent;

        Test.stopTest();

        List<LogEvent__c> lstLogsInserted = [
            SELECT Id, RequestId__c
            FROM LogEvent__c
            WHERE Quiddity__c = 'REST'
        ];
        System.assertEquals(2, lstLogsInserted.size());
    }
}
