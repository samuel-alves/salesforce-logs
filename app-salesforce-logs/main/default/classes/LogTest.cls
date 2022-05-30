/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   04-05-2021   samuel.f.alves   Initial Version
 **/
@isTest
public with sharing class LogTest {
    private static Log logger = Log.get();
    private static final String CLASSNAME = 'LogTest';

    @IsTest
    static void methodTestPublish() {
        Test.startTest();
        logger.publish('LogTest has started!', LogSeverity.INFO, CLASSNAME);
        Test.stopTest();
    }

    @IsTest
    static void methodTestPublishMessage() {
        Test.startTest();
        logger.publish('messageToLog');
        Test.stopTest();
    }

    @IsTest
    static void methodTestAddMessage() {
        Test.startTest();
        logger.add('exceptionToLog');
        Test.stopTest();
    }

    @IsTest
    static void methodTestAddMessageWithSeverity() {
        Test.startTest();
        logger.add('exceptionToLog', LogSeverity.INFO);
        Test.stopTest();
    }

    @IsTest
    static void methodTestPublishException() {
        Test.startTest();
        try {
            Account newAcc = null;
            insert newAcc;
        } catch (Exception e) {
            logger.publish(e);
        }
        Test.stopTest();
    }

    @IsTest
    static void methodTestAddException() {
        Test.startTest();
        try {
            Account newAcc = null;
            insert newAcc;
        } catch (Exception e) {
            logger.add(e);
        }
        Test.stopTest();
    }

    @IsTest
    static void methodTestAddExceptionWithSeverity() {
        Test.startTest();
        try {
            Account newAcc = null;
            insert newAcc;
        } catch (Exception e) {
            logger.add(e, LogSeverity.INFO);
        }
        Test.stopTest();
    }
}
