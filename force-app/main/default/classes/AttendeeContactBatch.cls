global class AttendeeContactBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = 'SELECT ConciergeLive__Object_ID__c, ConciergeLive__Contact__c FROM ConciergeLive__Attendee__c WHERE ConciergeLive__Contact__c = null';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<ConciergeLive__Attendee__c> attendees) {
		for (ConciergeLive__Attendee__c attendee : attendees) {
			attendee.ConciergeLive__Contact__c = attendee.ConciergeLive__Object_ID__c;
		}

		try {
			update attendees;
		} catch (Exception e) {
			System.debug(e);
		}
	}

	global void finish(Database.BatchableContext bc) {
	}
}
