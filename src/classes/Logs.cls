public class Logs {

    public static final String INFO = 'Info';
    public static final String DEBUG = 'Debug'; // not default in pickliy (should be)
    public static final String WARN = 'Warning';
    public static final String ERROR = 'Error';

    public static void add(string tag, string debugLevel, string message) {
        addNewLog(tag, debugLevel, message, false);
    }

    public static void add(string tag, string debugLevel, string message, boolean emailNotify) {
        addNewLog(tag, debugLevel, message, emailNotify);
    }

    public static void addInfo(string tag, string message) {
        addNewLog(tag, 'Info', message, false);
    }

    public static void addInfo(string tag, string message, boolean emailNotify) {
        addNewLog(tag, 'Info', message, emailNotify);
    }

    public static void addWarn(string tag, string message) {
        addNewLog(tag, 'Warning', message, false);
    }

    public static void addWarn(string tag, string message, boolean emailNotify) {
        addNewLog(tag, 'Warning', message, emailNotify);
    }

    public static void addError(string tag, string message) {
        addNewLog(tag, 'Error', message, false);
    }

    public static void addError(string tag, string message, boolean emailNotify) {
        addNewLog(tag, 'Error', message, emailNotify);
    }


    private static void addNewLog(string tag, string debugLevel, string message, boolean emailNotify) {
        Log__c newLog = new Log__c(Tag__c = tag, DebugLevel__c = debugLevel, Log_Message__c = message , Email_Notify__c = emailNotify);
        insert newLog;
    }


    public static String prepareErrorMessage(String message, String stackString, Integer line) {
        // Create a JSON generator object
        JSONGenerator gen = JSON.createGenerator(true);

        // open the JSON generator
        //gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('message', message);
        gen.writeStringField('stack', stackString);
        gen.writeStringField('line', String.valueOf(line));
        gen.writeEndObject();
        //gen.writeEndArray();
        // close the JSON generator

        // create a string from the JSON generator
        String jsonOrders = gen.getAsString();
        //System.debug('jsonOrders: ' + jsonOrders);

        return jsonOrders;
    }
}