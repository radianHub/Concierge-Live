/**
* {Purpose} - Test class for ConciergeLiveSearchV2
*
* @author   Unabridged Software
* @version
*/

@isTest (OnInstall=false)
public class ConciergeLiveSearchV2Test {
	@isTest
	public static void testContactIdsReturnsNothingForAccountsWithoutContacts() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Test.startTest();

		System.assertEquals(0, ConciergeLiveSearchV2.getContactIdsForAccount(a.Id).size());

		Test.stopTest();
	}

	@isTest
	public static void testContactIdsReturnsContactForAccountsWithContacts() {

		ConciergeLiveDataFactory.getApplicationCustomSetting(true, false);

		Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(Name='TestAccount'), true);

		Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(FirstName='John', LastName='Smith', AccountID = a.Id), true);

		Test.startTest();

        System.assertEquals(c.Id, ConciergeLiveSearchV2.getContactIdsForAccount(a.Id)[0]);

		Test.stopTest();
	}
}