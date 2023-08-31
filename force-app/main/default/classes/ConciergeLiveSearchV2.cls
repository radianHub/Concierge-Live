public with sharing class ConciergeLiveSearchV2 {
    @AuraEnabled(cacheable=true)
    public static List<Id> getContactIdsForAccount(Id accountId) {
        List<Contact> contacts = findContacts(accountId);

        List<Id> contactIds = new List<Id>();
        for (Contact c:contacts) {
            contactIds.add(c.Id);
        }
        return contactIds;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(Id accountId) {
        String contactFilter = ConciergeLiveConstants.contactFilterSql();
        List<Contact> contacts;
        if (contactFilter.length() > 0) {
            String query = 'SELECT Id FROM Contact WHERE AccountId = :accountId AND (' + contactFilter + ')';
            contacts = Database.query(query);
        } else {
            contacts = [SELECT Id from Contact where AccountId = :accountId];
        }
        return contacts;
    }
}