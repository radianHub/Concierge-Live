public with sharing class AttendeeTriggerHandler extends TriggerHandler {
	List<ConciergeLive__Attendee__c> newAttendees;
	Map<Id, ConciergeLive__Attendee__c> newAttendeesMap;
	List<ConciergeLive__Attendee__c> oldAttendees;
	Map<Id, ConciergeLive__Attendee__c> oldAttendeesMap;

	public AttendeeTriggerHandler() {
		newAttendees = (List<ConciergeLive__Attendee__c>) Trigger.new;
		newAttendeesMap = (Map<Id, ConciergeLive__Attendee__c>) Trigger.newMap;
		oldAttendees = (List<ConciergeLive__Attendee__c>) Trigger.old;
		oldAttendeesMap = (Map<Id, ConciergeLive__Attendee__c>) Trigger.oldMap;
	}

	public override void beforeInsert() {
		AttendeeService.assignAttendeeContact(newAttendees, oldAttendeesMap);
	}

	public override void beforeUpdate() {
		AttendeeService.assignAttendeeContact(newAttendees, oldAttendeesMap);
	}
}
