/**
* {Purpose} - Test class for ConciergeLiveHistoryController
*
* @author   Cirrius Solutions
* @version
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2016-06-24    Sarbello                Created
* =============================================================================
*/
@isTest (OnInstall=false)
public class ConciergeLiveHistoryControllerTest {
	@isTest
	public static void testMainInvalidToken() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new ConciergeLiveMockServiceResponse(500, '{"error":"AccessDenied","message":"Api token is not valid"}'));

		PageReference pageRef = Page.ConciergeLiveHistory;

        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(c);

		ApexPages.currentPage().getParameters().put('mode', 'loaded');
		ApexPages.currentPage().getParameters().put('id', c.id);

		ConciergeLiveHistoryController oController = new ConciergeLiveHistoryController(sc);

		oController.PostLoad();

		System.assertNotEquals(null, oController.GeneralMessage);

		Test.stopTest();

	}
	@isTest
	public static void testMainContactNotFound() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new ConciergeLiveMockServiceResponse(500, '{"error":"ApiError","message":"Salesforce contact not found"}'));

		PageReference pageRef = Page.ConciergeLiveHistory;

        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(c);

		ApexPages.currentPage().getParameters().put('mode', 'loaded');
		ApexPages.currentPage().getParameters().put('id', c.id);

		ConciergeLiveHistoryController oController = new ConciergeLiveHistoryController(sc);

		oController.PostLoad();

		System.assertEquals(ConciergeLiveConstants.MESSAGE_NOHISTORY, oController.GeneralMessage);

		Test.stopTest();

	}
	@isTest
	public static void testMainContactFound() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new ConciergeLiveMockServiceResponse(200, 'Event,Venue,Date,Number of Tickets,Requester\nUFC: 200,Las Vegas Arena,2016-07-09,2,John Bryan'));

		PageReference pageRef = Page.ConciergeLiveHistory;

        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(c);

		ApexPages.currentPage().getParameters().put('mode', 'loaded');
		ApexPages.currentPage().getParameters().put('id', c.id);

		ConciergeLiveHistoryController oController = new ConciergeLiveHistoryController(sc);

		oController.PostLoad();

		System.assertNotEquals(0, oController.oHistoryList.size());

		Test.stopTest();

	}
}