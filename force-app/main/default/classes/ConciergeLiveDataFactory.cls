/**
* {Purpose} - This class is the Data Factory for Test Data
*
* @author
* @version
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
*                                       Created
* =============================================================================
*/
@isTest
public class ConciergeLiveDataFactory {

    /*------------------------------------------------------------------------*/
    /*HOW TO USE*/
    /*------------------------------------------------------------------------*/

    // OPTION 1
    // Account a = (Account)ConciergeLiveDataFactory.createSObject(new Account());
    // insert a;

    // OPTION 2: Include any fields and it Will override the defaults
    // Opportunity o = (Opportunity)ConciergeLiveDataFactory.createSObject(new Opportunity(AccountId = a.Id));

    // OPTION3:  a specific set of overrides for different scenarios
    // Account a = (Account)ConciergeLiveDataFactory.createSObject(new Account(), 'ConciergeLiveDataFactory.AccountDefaults');

    // OPTION 4: Bulk
    // Account[] aList = (Account[])ConciergeLiveDataFactory.createSObjectList(new Account(), 200);

    // OPTION 4: Explictly ask for the records to be inserted
    // Account a = (Account) ConciergeLiveDataFactory.createSObject(new Account(), true);
    // Contact c = (Contact) ConciergeLiveDataFactory.createSObject(new Contact(AccountID = a.Id), true);



    /*-------------------------------------------------------------------------------------*/
    /* This class was heavily (mostly) based on some awesomeness at                        */
    /* https://github.com/dhoechst/Salesforce-Test-Factory                                 */
    /*-------------------------------------------------------------------------------------*/



    /*------------------------------------------------------------------------*/
    /*SINGLE CREATION METHODS*/
    /*------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------*/
    public static SObject createSObject(SObject sObj) {
        // Check what type of object we are creating and add any defaults that are needed.
        String objectName = String.valueOf(sObj.getSObjectType());

        // Construct the default values class. Salesforce doesn't allow '__' in class names
        String defaultClassName = 'ConciergeLiveDataFactory.' + objectName.replace('__c', '') + 'Defaults';

        // If there is a class that exists for the default values, then use them
        if (Type.forName(defaultClassName) != null) {
            sObj = createSObject(sObj, defaultClassName);
        }
        return sObj;
    }
    /*------------------------------------------------------------------------*/
    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }
    /*------------------------------------------------------------------------*/
    //METHOD: Used to ask for a specifc set of field defaults for specific test cases
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        // Create an instance of the defaults class so we can get the Map of field defaults
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            Throw new CirriusException('Invalid defaults class.');
        }
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }
    /*------------------------------------------------------------------------*/
    public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
        SObject retObject = createSObject(sObj, defaultClassName);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }
    /*------------------------------------------------------------------------*/



    /*------------------------------------------------------------------------*/
    /*LIST CREATION METHODS*/
    /*------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------*/
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, (String)null);
    }
    /*------------------------------------------------------------------------*/
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, (String)null);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }
    /*------------------------------------------------------------------------*/
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }
    /*------------------------------------------------------------------------*/
    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new SObject[] {};
        SObject newObj;

        // Get one copy of the object
        if (defaultClassName == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClassName);
        }

        // Get the name field for the object
        String nameField = nameFieldMap.get(String.valueOf(sObj.getSObjectType()));
        if (nameField == null) {
            nameField = 'Name';
        }

        // Clone the object the number of times requested. Increment the name field so each record is unique
        for (Integer i = 0; i < numberOfObjects; i++) {
            SObject clonedSObj = newObj.clone(false, true);
            clonedSObj.put(nameField, (String)clonedSObj.get(nameField) + ' ' + i);
            sObjs.add(clonedSObj);
        }
        return sObjs;
    }

    /*------------------------------------------------------------------------*/
    private static void addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
        // Loop through the map of fields and if they are null on the object, fill them.
        for (String field : defaults.keySet()) {
            if (sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
    }
    /*------------------------------------------------------------------------*/


    /*IDENTIFY THE NAME FIELD PER OBJECT, IF OMITTED THEN DEFAULT WILL BE 'NAME'*/
    /*------------------------------------------------------------------------*/
    // When we create a list of SObjects, we need to specify the NAME field
    private static Map<String, String> nameFieldMap = new Map<String, String> {
        'Contact' => 'LastName',
        'Case' => 'Subject'
    };
    /*------------------------------------------------------------------------*/


    /*CUSTOM EXCEPTION*/
    /*------------------------------------------------------------------------*/
    public class CirriusException extends Exception {}
    /*------------------------------------------------------------------------*/



    /*INTERFACE*/
    /*------------------------------------------------------------------------*/
    // Use the FieldDefaults interface to set up values you want to default in for all objects.
    public interface FieldDefaults {
        Map<String, Object> getFieldDefaults();
    }
    /*------------------------------------------------------------------------*/



    /*DEFAULTS FOR OBJECTS*/
    /*------------------------------------------------------------------------*/
    // To specify defaults for objects, use the naming convention [ObjectName]Defaults.
    // For custom objects, omit the __c from the Object Name

    public class AccountDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Account'
            };
        }
    }

    public class ContactDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'FirstName' => 'First',
                'LastName' => 'Last'
            };
        }
    }

    public class OpportunityDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Opportunity',
                'StageName' => 'Closed Won',
                'CloseDate' => System.today()
            };
        }
    }

    public class CaseDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Subject' => 'Test Case'
            };
        }
    }

    public class LeadDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'LastName' => 'Test Lead',
                'Phone' => '8005551212',
                'Company' => 'Test Company'
            };
        }
    }

    /*------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------*/
    /*ADDITIONAL NON FACTORY METHODS*/

    public static Attachment createAttachment(String oParentId, Boolean doInsert) {

        Attachment oAttachment  = new Attachment();
        oAttachment.Name            = 'Unit Test Attachment';
        Blob oBody                  = Blob.valueOf('Unit Test Attachment Body');
        oAttachment.body            = oBody;
        oAttachment.parentId        = oParentId;

        if (doInsert) {
            insert oAttachment;
        }

        return oAttachment;

    }

    public static Task createActivityHistory(String oParentId, Boolean doInsert) {

        Task oTask          = new Task();
        oTask.whatId        = oParentId;
        oTask.Subject       = 'Call';
        oTask.Status        = 'Completed';
        oTask.Priority      = 'Normal';
        oTask.Description   = 'Test';

        if (doInsert) {
            insert oTask;
        }

        return oTask;

    }

    public static Concierge_Live_Settings__c getApplicationCustomSetting(Boolean bInsert, Boolean bRandomName) {
        return getApplicationCustomSetting(bInsert, bRandomName, false, '');
    }

    public static Concierge_Live_Settings__c getApplicationCustomSetting(Boolean bInsert, Boolean bRandomName, Boolean bUseSandbox) {
        return getApplicationCustomSetting(bInsert, bRandomName, bUseSandbox, '');
    }

    public static Concierge_Live_Settings__c getApplicationCustomSetting(Boolean bInsert, Boolean bRandomName, Boolean bUseSandbox, String bContactFilter) {

        // HOW TO USE IN TEST METHOD:
        //  Just call it with appropriate flags to determine if its inserted for the duration of the test and how it's named
        //  CoreTestData.getApplicationCustomSetting(true, false);

        DateTime dt = System.now();
        long lTicks = dt.getTime();

        Concierge_Live_Settings__c oSetting =
            new Concierge_Live_Settings__c (
                Name = (bRandomName ? String.ValueOf(lTicks) : ConciergeLiveConstants.APP_KEY),
                Sub_Domain_Name__c = 'test',
                Authorization_Key__c = 'testtesttesttesttesttest',
                UseSandbox__c = bUseSandbox,
                Contact_Filter__c = bContactFilter
            );

        if (bInsert) insert oSetting;

        return oSetting;
    }
}