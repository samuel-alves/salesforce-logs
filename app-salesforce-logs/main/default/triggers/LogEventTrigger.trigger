/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 **/
trigger LogEventTrigger on LogEvent__c(before insert, after insert) {
    new LogEventTriggerHandler().run();
}
