/**
* {Purpose} - Test class for ConciergeLiveContactSearch
*
* @author   Unabridged Software
* @version
*/

@isTest (OnInstall=false)
public class ConciergeLiveConstantsTest {
	@isTest static void testEventHistoryUrl() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, false);

        Test.startTest();
		System.assertEquals(ConciergeLiveConstants.HISTORY_URL, ConciergeLiveConstants.eventHistoryUrl());
		Test.stopTest();
    }
    
    @isTest static void testSandboxEventHistoryUrl() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, true);

        Test.startTest();
		System.assertEquals(ConciergeLiveConstants.HISTORY_URL_SANDBOX, ConciergeLiveConstants.eventHistoryUrl());
		Test.stopTest();
    }

    @isTest static void testBulkEventHistoryUrl() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, false);

        Test.startTest();
		System.assertEquals(ConciergeLiveConstants.BULK_HISTORY_URL, ConciergeLiveConstants.bulkEventHistoryUrl());
		Test.stopTest();
    }

    @isTest static void testSandboxBulkEventHistoryUrl() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, true);

        Test.startTest();
		System.assertEquals(ConciergeLiveConstants.BULK_HISTORY_URL_SANDBOX, ConciergeLiveConstants.bulkEventHistoryUrl());
		Test.stopTest();
    }

    @isTest static void testSubmissionUrl() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, false);

		Test.startTest();
		System.assertEquals(ConciergeLiveConstants.SUBMISSION_URL, ConciergeLiveConstants.submissionUrl());
		Test.stopTest();
    }

    @isTest static void testSandboxSubmissionUrl() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, true);

		Test.startTest();
		System.assertEquals(ConciergeLiveConstants.SUBMISSION_URL_SANDBOX, ConciergeLiveConstants.submissionUrl());
		Test.stopTest();
    }

    @isTest static void testContactFilterSql() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, true, '1 = 1');

		Test.startTest();
		System.assertEquals('1 = 1', ConciergeLiveConstants.contactFilterSql());
		Test.stopTest();
    }

    @isTest static void testContactFilterSqlSanitizing() {
		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false, true, '1 = 1; SELECT * FROM users');

		Test.startTest();
		System.assertEquals('', ConciergeLiveConstants.contactFilterSql());
		Test.stopTest();
	}

     @isTest static void testDisallowedMessage() {
		Test.startTest();
		System.assertEquals(null, ConciergeLiveConstants.disallowedMessage());
		Test.stopTest();
    }

    @isTest static void testManualSelectAccountContacts() {
		Test.startTest();
		System.assertEquals(false, ConciergeLiveConstants.manualSelectAccountContacts());
		Test.stopTest();
    }
}