/**
* {Purpose} - Test class for ConciergeLiveAppSettingsController
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
@isTest
public class ConciergeLiveAppSettingsControllerTest {

	@isTest (OnInstall=false)
	public static void testMain() {

		//ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Test.startTest();

		PageReference pageRef = Page.ConciergeLiveAppSettings;

        Test.setCurrentPage(pageRef);

		ConciergeLiveAppSettingsController oController = new ConciergeLiveAppSettingsController();

		Concierge_Live_Settings__c oSettings = oController.doDefaults();

		System.assertEquals(ConciergeLiveConstants.APP_KEY, oSettings.Name);

		oController.loadSettings();

		Concierge_Live_Settings__c oSettings2 = oController.oAppSettings;

		System.assertEquals(ConciergeLiveConstants.APP_KEY, oSettings2.Name);

		oController.editPage();

		System.assertEquals(true, oController.bEditMode);

		oController.cancelPage();

		System.assertEquals(false, oController.bEditMode);

		oController.savePage();

		System.assertEquals(false, oController.bEditMode);

		Test.stopTest();

	}

}