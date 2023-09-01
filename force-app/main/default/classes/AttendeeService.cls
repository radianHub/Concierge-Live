public with sharing class AttendeeService {
	public static void assignAttendeeContact(
		List<ConciergeLive__Attendee__c> newAttendees,
		Map<Id, ConciergeLive__Attendee__c> oldAttendeesMap
	) {
		for (ConciergeLive__Attendee__c attendee : newAttendees) {
			if (
				oldAttendeesMap == null ||
				attendee.ConciergeLive__Object_ID__c != oldAttendeesMap.get(attendee.Id)?.ConciergeLive__Object_ID__c
			) {
				attendee.ConciergeLive__Contact__c = attendee.ConciergeLive__Object_ID__c;
			}
		}
	}
}
