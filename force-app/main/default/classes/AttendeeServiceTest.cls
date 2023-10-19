@isTest
private class AttendeeServiceTest {
	@isTest
	private static void assignAttendeeContact_Insert() {
		Contact contact = (Contact) new SObjectBuilder(Contact.sObjectType).create().getRecord();

		ConciergeLive__Attendee__c attendee = (ConciergeLive__Attendee__c) new SObjectBuilder(
				ConciergeLive__Attendee__c.sObjectType
			)
			.put(ConciergeLive__Attendee__c.ConciergeLive__Object_ID__c, contact.Id)
			.build()
			.getRecord();

		Test.startTest();
		insert attendee;
		Test.stopTest();

		List<ConciergeLive__Attendee__c> attendees = [
			SELECT Id, ConciergeLive__Object_ID__c, ConciergeLive__Contact__c
			FROM ConciergeLive__Attendee__c
		];

		Assert.areEqual(1, attendees.size(), 'Did not insert exactly 1 attendee');
		Assert.areEqual(contact.Id, attendees[0].ConciergeLive__Object_ID__c, 'Did not assign the correct object Id');
		Assert.areEqual(
			attendees[0].ConciergeLive__Object_ID__c,
			attendees[0].ConciergeLive__Contact__c,
			'Did not assign the correct contact'
		);
	}

	@isTest
	private static void assignAttendeeContact_Update() {
		ConciergeLive__Attendee__c attendee = (ConciergeLive__Attendee__c) new SObjectBuilder(
				ConciergeLive__Attendee__c.sObjectType
			)
			.create()
			.getRecord();

		Contact contact = (Contact) new SObjectBuilder(Contact.sObjectType).create().getRecord();

		attendee.ConciergeLive__Object_ID__c = contact.Id;

		Test.startTest();
		update attendee;
		Test.stopTest();

		List<ConciergeLive__Attendee__c> attendees = [
			SELECT Id, ConciergeLive__Object_ID__c, ConciergeLive__Contact__c
			FROM ConciergeLive__Attendee__c
		];

		Assert.areEqual(1, attendees.size(), 'Did not insert exactly 1 attendee');
		Assert.areEqual(contact.Id, attendees[0].ConciergeLive__Object_ID__c, 'Did not assign the correct object Id');
		Assert.areEqual(
			attendees[0].ConciergeLive__Object_ID__c,
			attendees[0].ConciergeLive__Contact__c,
			'Did not assign the correct contact'
		);
	}
}
