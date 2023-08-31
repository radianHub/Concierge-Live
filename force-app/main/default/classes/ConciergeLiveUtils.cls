/**
* {Purpose} - Concierge Live utility Class
*
* @author   Cirrius Solutions
* @version
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2016-05-23    Sarbello                Created
* =============================================================================
*/
public with sharing class ConciergeLiveUtils {

    public static final string sClassName           = 'ConciergeLiveUtils';
    //public static string sClassName;

    public enum LOGTYPE {DEBUG, EMAIL, STORE}

    // Used by logDebugMessage methods
    public static String DEBUG_MSG_PERIOD = '.';
    public static String DEBUG_MSG_PARENS = '()';
    public static String DEBUG_MSG_AMP_5 = '@@@@@';
    public static String DEBUG_MSG_SPACE = ' ';
    public static String DEBUG_MSG_SPACE_DASH_SPACE = ' - ';
    public static String DEBUG_MSG_COLON_SPACE = ': ';


    public ConciergeLiveUtils() {
       //Automatically get the name of this class
       //sClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }

    /*----------------------------------------------------------------------------------------------*/
    /***** Define Custom Exception *****/
    public class CoreAppException extends Exception {}
    //USAGE: throw new ConciergeLiveUtils.CoreAppException('An unexpected error has occurred in ' + sClassName + oMethodName + ' Message: ' + ex.getMessage());
    /*----------------------------------------------------------------------------------------------*/

    /*----------------------------------------------------------------------------------------------*/

    private static String FormatClassName(String oClassName) {
        // Format source Class Name with "ClassName."
        oClassName = DEBUG_MSG_SPACE + oClassName.trim();
        oClassName = oClassName.removeEnd(DEBUG_MSG_PERIOD);
        oClassName = oClassName + DEBUG_MSG_PERIOD;
        return oClassName;
    }
    private static String FormatMethodName(String oMethodName) {
        // Format source Method Name with ".methodName()
        oMethodName = oMethodName.trim();
        oMethodName = oMethodName.removeStart(DEBUG_MSG_PERIOD);
        oMethodName = oMethodName.removeEnd(DEBUG_MSG_PARENS);
        oMethodName = oMethodName + DEBUG_MSG_PARENS;
        return oMethodName;
    }

    /*----------------------------------------------------------------------------------------------*/
    public static void LogDebug(String oClassName, String oMethodName, Exception oException) {
        LogDebug(LOGTYPE.DEBUG, oClassName, oMethodName, oException.getMessage() + ';' +  oException.getStackTraceString());
    }
    public static void LogDebug(String oClassName, String oMethodName, Exception oException, String oAdditionalInfo) {
        LogDebug(LOGTYPE.DEBUG, oClassName, oMethodName, oAdditionalInfo + '; ' + oException.getMessage() + ';' +  oException.getStackTraceString());
    }
    public static void LogDebug(String oClassName, String oMethodName, String oMessage) {
        LogDebug(LOGTYPE.DEBUG, oClassName, oMethodName, oMessage);
    }

    /*----------------------------------------------------------------------------------------------*/
    public static void LogDebug(LOGTYPE oCategory, String oClassName, String oMethodName, Exception oException) {
        LogDebug(oCategory, oClassName, oMethodName, oException.getMessage() + ';' +  oException.getStackTraceString());
    }
    public static void LogDebug(LOGTYPE oCategory, String oClassName, String oMethodName, Exception oException, String oAdditionalInfo) {
        LogDebug(oCategory, oClassName, oMethodName, oAdditionalInfo + '; ' +oException.getMessage() + '; ' +  oException.getStackTraceString());
    }
    public static void LogDebug(LOGTYPE oCategory, String oClassName, String oMethodName, String oMessage) {

        try {

            oClassName = FormatClassName(oClassName);
            oMethodName = FormatMethodName(oMethodName);
            oMessage = DEBUG_MSG_AMP_5 + oClassName + oMethodName + DEBUG_MSG_COLON_SPACE + oMessage;

            system.debug(oMessage);

            if (oCategory == LOGTYPE.DEBUG) return;

            if (oCategory == LOGTYPE.EMAIL || oCategory == LOGTYPE.STORE) {

                    if (String.IsNotBlank(ConciergeLiveConstants.EMAIL_SUPPORT_FOR_DEBUG)) {
                        SendEmail(ConciergeLiveConstants.EMAIL_SUPPORT_FOR_DEBUG, ConciergeLiveConstants.EMAIL_SUPPORT_FOR_DEBUG_SUBJECT, oMessage);
                    }

            }

            if (oCategory == LOGTYPE.STORE) {
                //if (System.isFuture()) {
                //  StoreLogSync(oClassName, oMethodName, oMessage);
                //} else {
                //  StoreLogAsync(oClassName, oMethodName, oMessage);
                //}
            }

        } catch(Exception e) {
           system.debug(DEBUG_MSG_AMP_5 +  sClassName + '.LogDebug' + DEBUG_MSG_COLON_SPACE + 'Having issues with basic Log handling. '+ e.getMessage() + ';' +  e.getStackTraceString());
        }
    }

    /*----------------------------------------------------------------------------------------------*/
    //@future //NOT USED BECAUSE SOME ASYNC CAN CALL THIS
    //public static void StoreLogAsync(string oClassName, string oMethodName, string oMessage) {
    //  StoreLogSync(oClassName, oMethodName, oMessage);
    //}

    //public static void StoreLogSync(string oClassName, string oMethodName, string oMessage) {




    //  //Concierge_Live_Log__c                                         "Logging object to maintain most recent stored exceptions."
    //  //                                                          "Core Log Name" DataType: Text

    //  //"Class"                   Text(255)                   "Name of the Class, if available"

    //  //"Delete Required"     Formula Boolean  IF ( (TODAY() - DATEVALUE(CreatedDate)) > 7, true, false )
    //  //                                                          "If checked, indicates record is available for cleanup (removal) due to age."

    //  //"Message"             Text Long(32,768)   "Message or exception details"

    //  //"Method"              Text(255)                   "Name of the Method, if available"




    //  String sMethodName = 'StoreLog';

    //  //if (Limits.getFutureCalls() > 10)

    //  try
    //  {
    //      if (Limits.getCallouts() == 0 ) {
    //            Concierge_Live_Log__c oLog = new Concierge_Live_Log__c();
    //            oLog.Class__c         = oClassName;
    //          oLog.Method__c      = oMethodName;
    //            oLog.Message__c   = oMessage;

    //            insert oLog;

    //            delete [Select id from Concierge_Live_Log__c where Delete_Required__c = true LIMIT 100];
    //      }
    //  }
    //  catch (Exception e) {
    //      LogDebug(sClassName, sMethodName, e);
    //  }
    //}

    /*----------------------------------------------------------------------------------------------*/
    /* Used for managing static trigger recursion flags */
    //Now handle in the BaseTriggerHandler class
    //DEMOTED public static Set<String> setRecursiveTriggerFlags = new Set<String>();
    /*----------------------------------------------------------------------------------------------*/


    /*----------------------------------------------------------------------------------------------*/
    Public static RecordType GetRecordType(String objectName, String typeName) {
        //NOTE: THIS USES SOQL

        //RecordType rt = GetRecordType('Product','Donation');
        //RecordType rt = GetRecordType('Opportunity','Kitchen and Bath');
        String sMethodName = 'GetRecordType';

        RecordType rt;

        try {

            rt = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype = :objectName and Name = :typeName LIMIT 1];

            return rt;

        } Catch (Exception e) {
            LogDebug(sClassName, sMethodName, e);
            return rt;

        }

    }

    Public static Id GetRecordTypeId(String objectName, String typeName) {
        //NOTE: THIS USES getDescribe. No SOQL involved.

        String sMethodName = 'GetRecordTypeId';

        Map <String, Schema.SObjectType> mapSchema              = Schema.getGlobalDescribe();

        Map<String,Schema.RecordTypeInfo> mapRecordTypeInfo;

        try {

            Schema.DescribeSObjectResult oDescribe  = mapSchema.get(objectName).getDescribe();

            mapRecordTypeInfo                       = oDescribe.getRecordTypeInfosByName();

            return mapRecordTypeInfo.get(typeName).getRecordTypeId();

        } Catch (System.NullPointerException e) {

            LogDebug(sClassName, sMethodName, e);

            return null;

        }
    }


    /*----------------------------------------------------------------------------------------------*/
    public static string BuildUrl(String a, String b) {

        String sMethodName = 'BuildUrl';

        LogDebug(sClassName, sMethodName, 'Parameter 1: ' + a + 'Parameter 2: ' + b);

        if (!String.IsBlank(a) && !String.IsBlank(b)) {

            return a.removeEnd('/') + '/' + b.removeStart('/');

        } else if (String.IsBlank(a) && !String.IsBlank(b)) {

            return b;

        } else if (!String.IsBlank(a) && String.IsBlank(b)) {

            return a;

        } else {

            return '';

        }
    }
    /*----------------------------------------------------------------------------------------------*/
    public static boolean SendEmail(string address, string subject, string body) {

        String sMethodName = 'SendEmail';

          List<String> toList = new List<String>();
          toList.add(address);

          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

          mail.setSaveAsActivity(false);
          mail.setToAddresses(toList);
          mail.setSenderDisplayName(ConciergeLiveConstants.EMAIL_SENDER_NAME_GENERIC);
          mail.setReplyTo(ConciergeLiveConstants.EMAIL_SENDER_GENERIC_REPLYTO);
          mail.setSubject(subject);
          mail.setPlainTextBody(body);

        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            return true;
        } catch (system.Emailexception e) {
            //TODO
            LogDebug(LOGTYPE.DEBUG, sClassName, sMethodName, e);
            return false;
        }

    }
    /*----------------------------------------------------------------------------------------------*/
    public static List<String> DelimitedStringToList(String sDelimitedString, String sDelimiter) {

        //Input would look like  "ABC;XYZ" OR "ABC,XYZ,"

        String sOriginal = sDelimitedString;
        List<String> listOf = new List<String>();

        if (sDelimitedString == null || sDelimitedString == '') return listOf;

        //Step 1 - Attempt to clean up any spaces around the delimiter
        sDelimitedString = sDelimitedString.Replace(sDelimiter+' ', sDelimiter);
        sDelimitedString = sDelimitedString.Replace(' ' + sDelimiter, sDelimiter);

        listOf.addall(sDelimitedString.split(sDelimiter));

        return listOf;

    }

    public static Concierge_Live_Settings__c getApplicationCustomSetting(){

        String sMethodName = 'getApplicationCustomSetting';

        Concierge_Live_Settings__c oSettings = Concierge_Live_Settings__c.getAll().get(ConciergeLiveConstants.APP_KEY);

        if (oSettings == null) {
                oSettings           = new Concierge_Live_Settings__c ();
                oSettings.Name      = ConciergeLiveConstants.APP_KEY;
                Insert oSettings;
        }

        return oSettings;

        //if (!Test.isRunningTest())
        // NOTE: Do not handle Test related logic here. It will cause Lock issues during Test Coverage
        //            See the Core Test Class for how to handle getting AppSettings during testing

    }

    @AuraEnabled(cacheable=true)
    public static String getApplicationApiKey(){
        Concierge_Live_Settings__c oSettings = ConciergeLiveUtils.getApplicationCustomSetting();

        return oSettings.Authorization_Key__c;
    }

    @AuraEnabled(cacheable=true)
    public static String getSubdomain() {
        Concierge_Live_Settings__c oSettings = ConciergeLiveUtils.getApplicationCustomSetting();

        return oSettings.Sub_Domain_Name__c;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsForAccount(String accountId) {
        return [SELECT Id FROM Contact WHERE AccountId = :accountId LIMIT 100];
    }

    /*----------------------------------------------------------------------------------------------*/
    public static list<SelectOption> GetFieldsForObject(String selectedObject) {

        list<SelectOption> listOBJECTFIELDS = new list<SelectOption>();

        if (selectedObject == null) return listOBJECTFIELDS;

        if (selectedObject == '') return listOBJECTFIELDS;

        map <String, Schema.SObjectType> mapSchema      = Schema.getGlobalDescribe();
        map <String, Schema.SObjectField> mapFields     = new map <String, Schema.SObjectField>();

        try {
            mapFields = mapSchema.get(selectedObject).getDescribe().fields.getMap();
        } catch (Exception e) {
            return listOBJECTFIELDS;
        }

        if (mapFields == null) return listOBJECTFIELDS;

        listOBJECTFIELDS.clear();

        for(Schema.SObjectField oField : mapFields.Values())
        {
            Schema.DescribeFieldResult oFieldResult = oField.getDescribe();
            listOBJECTFIELDS.add(new SelectOption(oFieldResult.getName(), oFieldResult.getName()));
        }

        listOBJECTFIELDS.sort();
        return listOBJECTFIELDS;

    }

    /*----------------------------------------------------------------------------------------------*/
    //TODO overload this for list of SelectOption
    public static List<string> GetPickListValues(String oObject, String oFieldName) {

        String sMethodName = 'GetPickListValues';

        List<Schema.PicklistEntry> ple = new List<Schema.PicklistEntry>();

        List<String> listValues     = new List<String>();

        map <String, Schema.SObjectType> mapSchema      = Schema.getGlobalDescribe();
        map <String, Schema.SObjectField> mapFields     = new map <String, Schema.SObjectField>();

        try {
            mapFields = mapSchema.get(oObject).getDescribe().fields.getMap();

            for(Schema.SObjectField oField : mapFields.Values())
            {
                Schema.DescribeFieldResult oFieldResult = oField.getDescribe();
                if (oFieldResult.getName() == oFieldName) {
                    ple = oFieldResult.getPicklistValues();
                    break;
                }
            }

            listValues.clear();

            //Add option entries. Consider new param od list<string>?
            //listValues.add(new SelectOption('All','All'));

            for(Schema.PicklistEntry pe : ple)
                listValues.add(pe.getValue());
                //listValues.add(new SelectOption(pe.getValue(),pe.getLabel()));

            listValues.sort();


        } catch (Exception e) {
            system.debug('@@@@@' + sClassName+'.'+sMethodName + '; '+ e.getMessage() + ';' +  e.getStackTraceString());
            listValues.clear();
        }

        return listValues;

    }
    /*----------------------------------------------------------------------------------------------*/
    /* Returns the current date */
    public static Date getCurrentDate(){
        return system.today();
    }
    /*----------------------------------------------------------------------------------------------*/
    /* Returns the current datetime */
    public static Datetime getCurrentDatetime(){
        return system.now();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static String getObjectNameFromId(Id oId) {
        return oID.getSObjectType().getDescribe().getName().toLowerCase();
    }
   /*----------------------------------------------------------------------------------------------*/
    public static String getObjectNameFromSObject(sObject oObject) {
         return oObject.getSObjectType().getDescribe().getName().toLowerCase();
    }
   /*----------------------------------------------------------------------------------------------*/
   // User u = getUserInformation(userinfo.getUserId());
    public static User getUserInformation(Id oUserId) {

        return  [Select Id, Name, Email, ContactId,
                        Profile.Id, Profile.Name, Profile.UserLicense.LicenseDefinitionKey,
                        LastLoginDate,
                        UserRole.Id, UserRole.DeveloperName, UserRole.Name
                From User
                Where Id = :oUserId];

        //https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_userlicense.htm
        //AUL:                                  corresponds to the Salesforce Platform user license
        //AUL1:                                 corresponds to the Salesforce Platform One user license
        //AUL_LIGHT:                            corresponds to the Salesforce Platform Light user license
        //FDC_ONE:                              corresponds to the Force.com - One App user license
        //FDC_SUB:                              corresponds to the Force.com App Subscription user license
        //High Volume Customer Portal_User:     corresponds to the High Volume Customer Portal user license
        //Overage_Platform_Portal_User          corresponds to the Overage Authenticated Website user license
        //PID_STRATEGIC_PRM:                    corresponds to the Gold Partner user license
        //PID_CHATTER:                          corresponds to the Chatter Only user license
        //PID_CONTENT:                          corresponds to the Content Only user license
        //PID_Customer_Portal_Basic:            corresponds to the Customer Portal Manager Standard user license and the Customer Portal User license
        //PID_Customer_Portal_Standard:         corresponds to the Customer Portal Manager Custom user license
        //PID_FDC_FREE:                         corresponds to the Force.com Free user license
        //PID_IDEAS:                            corresponds to the Ideas Only user license
        //PID_Ideas_Only_Portal:                corresponds to the Ideas Only Portal user license
        //PID_Ideas_Only_Site:                  corresponds to the Ideas Only Site user license
        //PID_KNOWLEDGE:                        corresponds to the Knowledge Only user license
        //PID_Customer_Community:               corresponds to the Customer Community license.
        //PID_Customer_Community_Login:         corresponds to the Customer Community Login license.
        //PID_Partner_Community:                corresponds to the Partner Community license.
        //PID_Partner_Community_Login:          corresponds to the Partner Community Login license.
        //PID_Limited_Customer_Portal_Basic:    corresponds to the Limited Customer Portal Manager Standard user license
        //PID_Limited_Customer_Portal_Standard: corresponds to the Limited Customer Portal Manager Custom user license
        //PID_Overage_Customer_Portal_Basic:    corresponds to the Overage Customer Portal Manager Standard user license
        //PID_Overage_High Volume Customer Portal: corresponds to the Overage High Volume Customer Portal user license
        //Platform_Portal_User:                 corresponds to the Authenticated Website user license
        //POWER_PRM:                            corresponds to the Partner user license
        //POWER_SSP:                            corresponds to the Customer Portal Manager user license
        //SFDC:                                 corresponds to the Full CRM user license
    }

    //public static void GetApplicationId() {

 //      // Get tab set describes for each app
 //       List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();

 //       for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
 //           if (tsr.getLabel() == ConciergeLiveConstants.APPLICATION_NAME) {
 //               system.debug('@@@@@'+tsr.getLabel());
 //               system.debug('@@@@@'+tsr);
 //           }
 //       }

    //}

}