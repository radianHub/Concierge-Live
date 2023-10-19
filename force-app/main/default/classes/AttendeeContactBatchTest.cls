@isTest
private class AttendeeContactBatchTest {
	@isTest
	private static void batch() {
		TriggerHandler.bypass('AttendeeTriggerHandler');
		List<ConciergeLive__Attendee__c> attendees = new SObjectBuilder(ConciergeLive__Attendee__c.sObjectType)
			.count(200)
			.create()
			.getRecords();

		Test.startTest();
		Database.executeBatch(new AttendeeContactBatch());
		Test.stopTest();

		List<ConciergeLive__Attendee__c> updateAttendees = [
			SELECT Id, ConciergeLive__Object_ID__c, ConciergeLive__Contact__c
			FROM ConciergeLive__Attendee__c
		];

		Assert.areEqual(200, updateAttendees.size(), 'Did not create 200 attendees');

		for (ConciergeLive__Attendee__c attendee : updateAttendees) {
			Assert.areEqual(
				attendee.ConciergeLive__Object_ID__c,
				attendee.ConciergeLive__Contact__c,
				'Did not assign the correct contact'
			);
		}
	}
}
