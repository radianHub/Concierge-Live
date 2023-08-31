public with sharing class ConciergeLiveAttendeeSearch {
    @AuraEnabled(cacheable=true)
    public static List<ConciergeLive__Attendee__c> findAll(String id) {
        return [
            SELECT Id, ConciergeLive__Event_Date__c,
            ConciergeLive__Event_Name__c, ConciergeLive__Object_ID__c,
            ConciergeLive__Requester_Name__c, ConciergeLive__Ticket_Count__c,
            ConciergeLive__Ticket_Request_ID__c, ConciergeLive__Ticket_Value__c,
            ConciergeLive__Venue_Name__c
            FROM ConciergeLive__Attendee__c
            WHERE ConciergeLive__Object_ID__c = :id
            AND ConciergeLive__Using_Tickets__c = true
            AND ConciergeLive__State__c = 'assigned'
            ORDER BY ConciergeLive__Event_Date__c DESC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<ConciergeLive__Attendee__c> findByAccount(String accountId) {
        List<Contact> contacts = ConciergeLiveContactSearch.getAccountContacts(accountId);
        List<Id> contactIds = new List<Id>();
        for (Contact ctact : contacts) {
            contactIds.add(ctact.Id);
        }

        return [
            SELECT Id, ConciergeLive__Event_Date__c,
            ConciergeLive__Event_Name__c, ConciergeLive__Object_ID__c,
            ConciergeLive__Requester_Name__c, ConciergeLive__Ticket_Count__c,
            ConciergeLive__Ticket_Request_ID__c, ConciergeLive__Ticket_Value__c,
            ConciergeLive__Venue_Name__c
            FROM ConciergeLive__Attendee__c
            WHERE ConciergeLive__Object_ID__c IN :contactIds
            AND ConciergeLive__Using_Tickets__c = true
            AND ConciergeLive__State__c = 'assigned'
            ORDER BY ConciergeLive__Event_Date__c DESC
        ];
    }
}