/**
* {Purpose} - Test class for ConciergeLiveUtils
*
* @author   Cirrius Solutions
* @version
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2016-05-23    Sarbello                Created
* =============================================================================
*/
@isTest (OnInstall=false)
public class ConciergeLiveUtilsTest {

	/*----------------------------------------------------------------------------------------------*/
    public static testMethod void testBuildUrl() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

		    string s = ConciergeLiveUtils.BuildUrl('a','b');

        system.assertEquals(s, 'a/b');

		    s = ConciergeLiveUtils.BuildUrl(null,'b');

        system.assertEquals(s, 'b');

		    s = ConciergeLiveUtils.BuildUrl('a',null);

        system.assertEquals(s, 'a');

        Test.stopTest();
    }
    /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testLogDebug() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

    		try {

    			Account a = (Account)ConciergeLiveDataFactory.createSObject(new Account(), true);

    			Insert a; //Causes the exception

    		} Catch (Exception e) {

    			ConciergeLiveUtils.LogDebug('Test', 'Test', e);
    			ConciergeLiveUtils.LogDebug(ConciergeLiveUtils.LOGTYPE.EMAIL, 'Test', 'Test', e);

    		}

    		//ConciergeLiveUtils.CoreAppException('Test Exception Message');

    		ConciergeLiveUtils.LogDebug('Test', 'Test', 'Had an exception');

    		//ConciergeLiveUtils.LogDebug(ConciergeLiveUtils.LOGTYPE.STORE, 'Test', 'Test', 'Had an exception');

        //List<Concierge_Live_Log__c> oLogs = [Select Id From Concierge_Live_Log__c];

        //System.assertEquals(1, oLogs.Size());

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testSendEmail() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

        //Integer iAllowedStart = System.Limits.getLimitEmailInvocations();

        Boolean bResult = ConciergeLiveUtils.SendEmail('noreply@Salesforce.com', 'Test', 'Test');

        //Integer iAllowedEnd = System.Limits.getLimitEmailInvocations();

        //System.assertNotEquals(iAllowedStart,iAllowedEnd);
        System.assertEquals(true, bResult);

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetApplicationCustomSetting() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

        Concierge_Live_Settings__c oSettings = ConciergeLiveUtils.getApplicationCustomSetting();

        system.assertNotEquals(oSettings, null);

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testDelimitedStringToList() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        String s = 'abc,xyz';

        Test.startTest();

        List<String> sList = ConciergeLiveUtils.DelimitedStringToList(s, ',');

        system.assertEquals(sList.size(), 2);

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetRecordType() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

        RecordType rt = ConciergeLiveUtils.GetRecordType('Account','test');

        system.assertEquals(rt, null);

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetRecordTypeId() {

        ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

        Id rtId = ConciergeLiveUtils.GetRecordTypeId('Account','test');

        system.assertEquals(rtId, null);

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testMisc() {

        Test.startTest();

        Date oDate = ConciergeLiveUtils.getCurrentDate();

        system.assertNotEquals(oDate, null);

        DateTime oDateTime = ConciergeLiveUtils.getCurrentDatetime();

        system.assertNotEquals(oDateTime, null);

        Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetObjectNameFrom() {

	    ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

        Test.startTest();

        Account a = (Account)ConciergeLiveDataFactory.createSObject(new Account(), true);

    		sObject oObject;

    		oObject = a;

        String s = ConciergeLiveUtils.getObjectNameFromSObject(oObject);

        system.assertEquals(s, 'account');

        s = ConciergeLiveUtils.getObjectNameFromId(a.id);

        system.assertEquals(s, 'account');

        Test.stopTest();
    }
    /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetFieldsForObject() {

      ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

      Test.startTest();

      List<SelectOption> oList = ConciergeLiveUtils.GetFieldsForObject('Account');

      system.assertNotEquals(oList.Size(), 0);

      Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetPickListValues() {

      ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

      Test.startTest();

      List<String> oList = ConciergeLiveUtils.GetPickListValues('Lead', 'Status');

      system.assertNotEquals(oList.Size(), 0);

      Test.stopTest();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static testMethod void testGetUserInformation() {

      ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

      Test.startTest();

      User u = ConciergeLiveUtils.getUserInformation(userinfo.getUserId());

      system.assertNotEquals(null, u);

      Test.stopTest();
    }

}