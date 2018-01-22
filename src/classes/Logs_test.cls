@isTest
private class Logs_test {
	private static String TAG = 'Logs_test';
	private static String DEBUG = Logs.DEBUG;
	private static String MESSAGE = 'Mensagem de teste';

	@isTest static void test_method_one() {
		Logs.add(TAG, DEBUG, MESSAGE);
		Logs.add(TAG, DEBUG, MESSAGE, false);
		Logs.addInfo(TAG, MESSAGE);
		Logs.addInfo(TAG, MESSAGE, false);
		Logs.addWarn(TAG, MESSAGE);
		Logs.addWarn(TAG, MESSAGE, false);
		Logs.addError(TAG, MESSAGE);
		Logs.addError(TAG, MESSAGE, false);
		Logs.prepareErrorMessage('message', 'stackString', 1);
	}
}