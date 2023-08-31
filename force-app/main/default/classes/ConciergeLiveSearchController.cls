/**
* {Purpose} - Controller for ConciergeLiveSearch
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
public with sharing class ConciergeLiveSearchController {

	public static final String sClassName = 'ConciergeLiveSearchController';

    /* Public Variables */
    public Concierge_Live_Settings__c oSettings	{Get; Set;}

    public String SearchFirstName			{Get; Set;}
    public String SearchLastName			{Get; Set;}
    public Account SearchAccount			{Get; Set;}

    public String currentId 				{Get; Set;}
    public String oSubmissionURL			{Get; Set;}
    public String PassedAccountId 			{Get; Set;}
    public String PassedContactId 			{Get; Set;}

    public List<Contact> listFoundContacts				{Get; Set;}
    public List<Contact> listFoundContactsIgnored		{Get; Set;}
    public List<Contact> listSubmissionContacts			{Get; Set;}

    String oMasterContactSelect = 'Select Id, FirstName, LastName, Title, Account.Name From Contact ';

	public ConciergeLiveSearchController() {

		listFoundContacts 		= new List<Contact>();
		listSubmissionContacts 	= new List<Contact>();
		SearchAccount 			= new Account();
		oSubmissionURL 			= '';

		PassedContactId = ApexPages.currentPage().getParameters().get('ContactId');

		if (String.isNotBlank(PassedContactId)) {
			PassedContactId = String.escapeSingleQuotes(PassedContactId);
		}

		PassedAccountId = ApexPages.currentPage().getParameters().get('AccountId');

		if (String.isNotBlank(PassedAccountId)) {
			PassedAccountId = String.escapeSingleQuotes(PassedAccountId);
		}

	}

	public void PostLoad() {

		String sMethodName = 'PostLoad';

		oSettings = ConciergeLiveUtils.getApplicationCustomSetting();

		try {
			Integer addedContacts = 0;

			if (String.isNotBlank(PassedContactId)) {
				Contact c = Database.query(oMasterContactSelect + ' Where Id = \'' + String.escapeSingleQuotes(PassedContactId) + '\'');

				if ( c != null) {
					listSubmissionContacts.add(c);
					addedContacts++;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, c.FirstName + ' ' + c.LastName + ' has been added below.'));
				}
			}

			if (String.isNotBlank(PassedAccountId)) {
				List<Contact> listFoundContacts = Database.query(oMasterContactSelect + ' Where AccountId = \'' + String.escapeSingleQuotes(PassedAccountId) + '\'');
				for (Contact c : listFoundContacts) {
					listSubmissionContacts.add(c);
					addedContacts++;
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, c.FirstName + ' ' + c.LastName + ' has been added below.'));
				}
			}

			if (addedContacts > 0) { 
				BuildSubmissionUrl();
			}

		} Catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_GENERAL_ISSUE));
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

	}
   /*------------------------------------------------------------*/
    @TestVisible private Boolean IsSearchCriteriaValid() {

		String sMethodName = 'IsSearchCriteriaValid';

		try {

	    	if (String.isBlank(SearchFirstName) && String.isBlank(SearchLastName) && SearchAccount.ParentId == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please enter at least one search criteria'));
	    		return false;
	    	} else {
	    		return true;
	    	}

		} Catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_GENERAL_ISSUE));
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
			return false;
		}

    }
   /*------------------------------------------------------------*/
  //  public PageReference doClear() {

		//String sMethodName = 'doClear';

		//SearchFirstName = '';
		//SearchLastName 	= '';
		//SearchAccount   = new Account();
		//SearchAccount.ParentId   = null;

		//return null;
  //  }
   /*------------------------------------------------------------*/
  //  public PageReference doSubmit() {

		//String sMethodName = 'doSubmit';

		//Boolean firstPass = true;

  //  	if (String.isBlank(oSettings.Sub_Domain_Name__c)) {
  //  		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Submit not currently available. Sub Domain is empty in the settings area.'));
  //  		return null;
  //  	}

  //  	String sURL = ConciergeLiveConstants.SUBMISSION_URL;
  //  	sURL = sURL.replace('[SUBDOMAIN]', oSettings.Sub_Domain_Name__c);

  //  	sURL += '?';

  //  	for (Contact c : listSubmissionContacts) {

  //  		ConciergeLiveUtils.LogDebug(sClassName, sMethodName, 'Processing:'+c.id);

  //  		if (firstPass)
		//		sURL += 'ids[]='+c.id;
  //  		else
  //  			sURL += '&ids[]='+c.id;

  //  		firstPass = false;

  //  	}

  //  	ConciergeLiveUtils.LogDebug(sClassName, sMethodName, 'URL:'+sURL);

  //  	if (listSubmissionContacts.size() == 0) {
  //  		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Submit not currently available. No Contacts have been selected.'));
  //  		return null;
  //  	}

  //  	PageReference nextPage = new PageReference(sURL);
  //      nextPage.setRedirect(true);
  //      return nextPage;
  //  }
   /*------------------------------------------------------------*/
   @TestVisible private void BuildSubmissionUrl() {

		String sMethodName = 'BuildSubmissionUrl';

		Boolean firstPass = true;

		if (String.isBlank(oSettings.Sub_Domain_Name__c)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_MISSING_SUB_DOMAIN));
			return;
		}

		try {

	   		oSubmissionURL = ConciergeLiveConstants.SUBMISSION_URL;

	    	oSubmissionURL = oSubmissionURL.replace('[SUBDOMAIN]', oSettings.Sub_Domain_Name__c);

	    	oSubmissionURL += '?';

	    	for (Contact c : listSubmissionContacts) {

	    		ConciergeLiveUtils.LogDebug(sClassName, sMethodName, 'Processing:'+c.id);

	    		if (firstPass)
					oSubmissionURL += 'ids[]='+c.id;
	    		else
	    			oSubmissionURL += '&ids[]='+c.id;

	    		firstPass = false;

	    	}

		} Catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_GENERAL_ISSUE));
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

   }
   /*------------------------------------------------------------*/
    public PageReference doAdd() {

		String sMethodName = 'doAdd';

    	try {
	    	//Check to make sure its not already in the list
			for (Contact c : listSubmissionContacts) {
				if (c.id == currentId) {
					return null;
				}
			}

			//Add it to the list
			for (Contact c : listFoundContacts) {
				if (c.id == currentId) {
					listSubmissionContacts.add(c);
					break;
				}
			}

			BuildSubmissionUrl();

		} Catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_GENERAL_ISSUE));
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

		return null;
    }
   /*------------------------------------------------------------*/
    public PageReference doRemove() {

		String sMethodName = 'doRemove';

		Integer i = 0;

		try {

			for (Contact c : listSubmissionContacts) {
				if (c.id == currentId) {
					listSubmissionContacts.remove(i);
					return null;
				} else {
					i += 1;
				}
			}

			BuildSubmissionUrl();

		} Catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_GENERAL_ISSUE));
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

		return null;
    }
   /*------------------------------------------------------------*/
    public PageReference doSearch() {

		String sMethodName = 'doSearch';

    	Boolean bIncludedWhere = false;

    	try {

	    	if (IsSearchCriteriaValid() == false) {
	    		return null;
	    	}

			listFoundContacts.clear();

			//String oSelect = 'Select Id, FirstName, LastName, Title, Account.Name From Contact ';
			String oWhere = ' Where ';

			if (String.isNotBlank(SearchFirstName)) {

				oWhere += ' FirstName LIKE \''+String.escapeSingleQuotes(SearchFirstName)+'%' +'\'';

				bIncludedWhere = true;

			}

			if (String.isNotBlank(SearchLastName)) {

				if (bIncludedWhere)
					oWhere += ' and LastName LIKE \''+String.escapeSingleQuotes(SearchLastName)+'%' +'\'';
				else
					oWhere += ' LastName LIKE \''+String.escapeSingleQuotes(SearchLastName)+'%' +'\'';

				bIncludedWhere = true;

			}

			if (SearchAccount.ParentId != null) {

				if (bIncludedWhere)
					oWhere += ' and AccountId = \''+ SearchAccount.ParentId +'\'';
				else
					oWhere += ' AccountId = \''+ SearchAccount.ParentId + '\'';

				bIncludedWhere = true;

			}

			listFoundContacts = Database.query(oMasterContactSelect + oWhere + ' Order By LastName LIMIT 999');
			//listFoundContacts = Database.query(oMasterContactSelect);

		} Catch(Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ConciergeLiveConstants.MESSAGE_GENERAL_ISSUE));
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

    	return null;
    }

}