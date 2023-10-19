global class AttendeeContactBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = 'SELECT ConciergeLive__Object_ID__c, ConciergeLive__Contact__c FROM ConciergeLive__Attendee__c WHERE ConciergeLive__Contact__c = null';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<ConciergeLive__Attendee__c> attendees) {
		Map<Id, Contact> contactsMap = new Map<Id, Contact>([
			SELECT Id
			FROM Contact
			WHERE Id IN :Pluck.ids('ConciergeLive__Object_ID__c', attendees)
		]);

		for (ConciergeLive__Attendee__c attendee : attendees) {
			Id objectId = attendee.ConciergeLive__Object_ID__c;
			if (objectId.getSobjectType() == Contact.sObjectType && contactsMap.get(attendee.ConciergeLive__Object_ID__c) != null) {
				attendee.ConciergeLive__Contact__c = attendee.ConciergeLive__Object_ID__c;
			} else {
				attendee.ConciergeLive__Contact__c = null;
			}
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
