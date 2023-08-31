/**
* {Purpose} - Constants file
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
public with sharing class ConciergeLiveConstants {

    public static final String APP_KEY                              = 'CONCIERGELIVE'; //Concierge Live
    public static final String CL_NAME                              = 'Concierge Live'; //Concierge Live
    public static final String APPLICATION_NAME                     = 'Concierge Live'; //Concierge Live

	public static final String EMAIL_SUPPORT_FOR_DEBUG				= 'dev@conciergelive.com';
	public static final String EMAIL_SUPPORT_FOR_DEBUG_SUBJECT		= 'Salesforce - Debug';
	public static final String EMAIL_SENDER_NAME_GENERIC 			= 'Salesforce';
    public static final String EMAIL_SENDER_GENERIC_REPLYTO         = 'dev@conciergelive.com';

    public static final String SUBMISSION_URL         				= 'https://[SUBDOMAIN].conciergelive.com/integrations/salesforce_calls/new';
    public static final String SUBMISSION_URL_SANDBOX         				= 'https://[SUBDOMAIN].conciergelive-staging.com/integrations/salesforce_calls/new';

    public static final String HISTORY_URL         					= 'https://[SUBDOMAIN].conciergelive.com/api/salesforce/contacts/[CONTACTID]/event_history';
    public static final String HISTORY_URL_SANDBOX         					= 'https://[SUBDOMAIN].conciergelive-staging.com/api/salesforce/contacts/[CONTACTID]/event_history';

    public static final String BULK_HISTORY_URL                     = 'https://[SUBDOMAIN].conciergelive.com/api/salesforce/contacts/event_history_bulk';
    public static final String BULK_HISTORY_URL_SANDBOX = 'https://[SUBDOMAIN].conciergelive-staging.com/api/salesforce/contacts/event_history_bulk';

    public static final String MESSAGE_NOHISTORY                    = 'No events found.';
    public static final String MESSAGE_GENERAL_ISSUE       			= 'We\'re having an issue completing your request.';
    public static final String MESSAGE_CALLOUT_FAILURE              = 'Concierge Live Event History is Unavailable at this time.';
    public static final String MESSAGE_MISSING_SUB_DOMAIN           = 'Please set the \'Sub Domain Name\' in Concierge Live Settings.';
    public static final String MESSAGE_MISSING_AUTHORIZATION_KEY	= 'Please set the \'Authorization Key\' in Concierge Live Settings.';

    @AuraEnabled(cacheable=true)
    public static String eventHistoryUrl() {
        Concierge_Live_Settings__c settings = ConciergeLiveUtils.getApplicationCustomSetting();
        if (settings.UseSandbox__c) {
            return HISTORY_URL_SANDBOX;
        }

        return HISTORY_URL;
    }

    @AuraEnabled(cacheable=true)
    public static String bulkEventHistoryUrl() {
        Concierge_Live_Settings__c settings = ConciergeLiveUtils.getApplicationCustomSetting();
        if (settings.UseSandbox__c) {
            return BULK_HISTORY_URL_SANDBOX;
        }

        return BULK_HISTORY_URL;
    }

    @AuraEnabled(cacheable=true)
    public static String submissionUrl() {
        Concierge_Live_Settings__c settings = ConciergeLiveUtils.getApplicationCustomSetting();
        if (settings.UseSandbox__c) {
            return SUBMISSION_URL_SANDBOX;
        }

        return SUBMISSION_URL;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean manualSelectAccountContacts() {
        Concierge_Live_Settings__c settings = ConciergeLiveUtils.getApplicationCustomSetting();
        return settings.Manual_Select_Account_Contacts__c;
    }

    @AuraEnabled(cacheable=true)
    public static String disallowedMessage() {
        Concierge_Live_Settings__c settings = ConciergeLiveUtils.getApplicationCustomSetting();
        String msg = settings.Disallowed_Message__c;

        if (msg != null && msg.length() > 0) {
            return msg;
        } else {
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static String contactFilterSql() {
        Concierge_Live_Settings__c settings = ConciergeLiveUtils.getApplicationCustomSetting();
        String contactFilter = settings.Contact_Filter__c;

        if (validContactFilter(contactFilter)) {
            return contactFilter;
        }

        return '';
    }

    // This is used to determine if a valid Contact Filter setting has been
    // provided. If the filter contains a semicolon, probably someone is trying
    // to do some SQL injection so just reject it outright.
    private static Boolean validContactFilter(String filterString) {
        return filterString != null &&
            filterString.length() > 0 &&
            filterString.split(';').size() == 1;
    }
}