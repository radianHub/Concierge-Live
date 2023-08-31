public with sharing class ConciergeLiveContactSearch {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(List<Id> contactIds) {
        String contactFilter = ConciergeLiveConstants.contactFilterSql();
        if (contactFilter.length() > 0) {
            String query = 'SELECT Id, FirstName, LastName, Email, Phone, Account.Name, Owner.Name, Account.AccountNumber FROM Contact WHERE Id IN :contactIds AND (' + contactFilter + ')';
            List<Contact> result = Database.query(query);
            return result;
        } else {
            return [
                SELECT Id, FirstName, LastName, Email, Phone, Account.Name, Owner.Name, Account.AccountNumber
                FROM Contact
                WHERE Id IN :contactIds
            ];
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccountContacts(Id accountId) {
        String contactFilter = ConciergeLiveConstants.contactFilterSql();
        if (contactFilter.length() > 0) {
            String query = 'SELECT Id, FirstName, LastName, Email, Phone, Account.Name, Owner.Name, Account.AccountNumber FROM Contact WHERE AccountId = :accountId AND (' + contactFilter + ')';
            List<Contact> result = Database.query(query);
            return result;
        } else {
            return [
                SELECT Id, FirstName, LastName, Email, Phone, Account.Name, Owner.Name, Account.AccountNumber
                FROM Contact
                WHERE AccountId = :accountId
            ];
        }
    }
}