/**
* {Purpose} - Test class for ConciergeLiveContactSearch
*
* @author   Unabridged Software
* @version
*/

@isTest (OnInstall=false)
public class ConciergeLiveContactSearchTest {
	@isTest
	public static void testContactSearchForNoContacts() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

        List<Id> searchIds = new List<Id>();
        searchIds.add(a.Id); // Not a Contact ID

		Test.startTest();

		System.assertEquals(0, ConciergeLiveContactSearch.getContacts(searchIds).size());

		Test.stopTest();
	}

	@isTest
	public static void testContactSearchWithContacts() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);
        List<Id> searchIds = new List<Id>();
        searchIds.add(c.Id);

		Test.startTest();

        System.assertEquals(c.Id, ConciergeLiveContactSearch.getContacts(searchIds)[0].Id);

		Test.stopTest();
	}
}