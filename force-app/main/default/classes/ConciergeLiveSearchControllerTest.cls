/**
* {Purpose} - Test class for ConciergeLiveSearchControllerController
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
public class ConciergeLiveSearchControllerTest {

	@isTest
	public static void testMain() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);

		Test.startTest();

		PageReference pageRef = Page.ConciergeLiveSearch;

        Test.setCurrentPage(pageRef);

		ConciergeLiveSearchController oController = new ConciergeLiveSearchController();

		oController.SearchFirstName 	= 'John';

		oController.SearchLastName		= 'Smith';

		oController.SearchAccount.ParentId 		= a.Id;

		oController.PostLoad();

		oController.doSearch();
		System.assertEquals(1, oController.listFoundContacts.size());

		oCOntroller.currentId = oController.listFoundContacts[0].Id;
		oController.doAdd();
		System.assertEquals(1, oController.listSubmissionContacts.size());

		//oController.doSubmit();

		oCOntroller.currentId = oController.listFoundContacts[0].Id;
		oController.doRemove();
		System.assertEquals(0, oController.listSubmissionContacts.size());

		//oController.doClear();
		//System.assertEquals(null, oController.SearchFirstName);

		Test.stopTest();

	}

	//@isTest
	//public static void testMainSpecific() {

	//	Concierge_Live_Settings__c oSettings = ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

	//	oSettings.Sub_Domain_Name__c = null;

	//	update oSettings;

	//	Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

	//	Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);

	//	Test.startTest();

	//	PageReference pageRef = Page.ConciergeLiveSearch;

 //       Test.setCurrentPage(pageRef);

	//	ConciergeLiveSearchController oController = new ConciergeLiveSearchController();

	//	oController.BuildSubmissionUrl();

	//	ApexPages.Message[] pageMessages = ApexPages.getMessages();

	//	System.assertNotEquals(0, pageMessages.size());

	//	Boolean b = oController.IsSearchCriteriaValid();

	//	System.assertEquals(false, b);

	//	Test.stopTest();

	//}

}