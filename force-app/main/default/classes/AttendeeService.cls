public with sharing class AttendeeService {
	public static void assignAttendeeContact(
		List<ConciergeLive__Attendee__c> newAttendees,
		Map<Id, ConciergeLive__Attendee__c> oldAttendeesMap
	) {
		Map<Id, Contact> contactsMap = new Map<Id, Contact>(
			[
				SELECT Id
				FROM Contact
				WHERE Id IN :Pluck.ids('ConciergeLive__Object_ID__c', newAttendees)
			]
		);

		for (ConciergeLive__Attendee__c attendee : newAttendees) {
			if (
				oldAttendeesMap == null ||
				attendee.ConciergeLive__Object_ID__c != oldAttendeesMap.get(attendee.Id)?.ConciergeLive__Object_ID__c
			) {
				Id objectId = attendee.ConciergeLive__Object_ID__c;
				if (
					objectId.getSobjectType() == Contact.sObjectType &&
					contactsMap.get(attendee.ConciergeLive__Object_ID__c) != null
				) {
					attendee.ConciergeLive__Contact__c = attendee.ConciergeLive__Object_ID__c;
				} else {
					attendee.ConciergeLive__Contact__c = null;
				}
			}
		}
	}
}
