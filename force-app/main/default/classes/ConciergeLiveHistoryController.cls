/**
* {Purpose} - Controller for ConciergeLiveHistory
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
public with sharing class ConciergeLiveHistoryController extends ConciergeLiveServiceBase {

    private static final String sClassName = 'ConciergeLiveHistoryController';

    /* Public Variables */
    public Concierge_Live_Settings__c oSettings			{Get; Set;}
    public Boolean DisplayLoadingMessage				{Get; Set;}
    public String mode									{Get; Set;}
    public String ContactId								{Get; Set;}
    //public String HistoryHTML							{Get; Set;}
    public List<History> oHistoryList					{Get; Set;}
    public String GeneralMessage						{Get; Set;}
    public ConciergeLiveServiceResponse JSONResponce	{Get; Set;}

   /*------------------------------------------------------------*/
	public ConciergeLiveHistoryController(ApexPages.StandardController stdController) {

		String sMethodName  = 'ConciergeLiveHistoryController';

		Contact c 					= (Contact)stdController.getRecord();

		GeneralMessage 			= '';
		//HistoryHTML 			= '';
		oHistoryList			= new List<History>();

		try {

			mode 					= ApexPages.currentPage().getParameters().get('mode');

			ContactId				= ApexPages.currentPage().getParameters().get('Id');

			if (String.isNotBlank(ContactId)) {
				ContactId = String.escapeSingleQuotes(ContactId);
			}

			if (c != null) {
				ContactId = c.Id;
			}

			if (String.isNotBlank(mode)) {
				mode = String.escapeSingleQuotes(mode);
				if (mode == 'loaded') {
					DisplayLoadingMessage = false;
				} else {
					DisplayLoadingMessage 	= true;
				}
			} else {
				DisplayLoadingMessage 	= true;
			}

		} Catch(Exception e) {
			DisplayLoadingMessage = false;
			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

	}
   /*------------------------------------------------------------*/
	public void PostLoad() {

		String sMethodName  = 'PostLoad';
		Boolean bHeader 	= true;

		if (String.isBlank(mode)) return;

		oSettings 				= ConciergeLiveUtils.getApplicationCustomSetting();

		try {

			//=============================================================
			//Possible return results observed:
			//=============================================================
			//1. {"error":"AccessDenied","message":"Api token is not valid"}
			//
			//2. Event,Venue,Date,Number of Tickets,Requester
			//   UFC: 200,Las Vegas Arena,2016-07-09,2,John Bryan
			//
			//3. {"error":"ApiError","message":"Salesforce contact not found"}
			//=============================================================

			String sURL = ConciergeLiveConstants.eventHistoryUrl();

			sURL = sURL.Replace('[CONTACTID]', ContactId);
			//Testing sURL = sURL.Replace('[CONTACTID]', '0033600000DV9xOAAT');

			if (String.isBlank(oSettings.Authorization_Key__c)) {
				GeneralMessage 			= ConciergeLiveConstants.MESSAGE_MISSING_AUTHORIZATION_KEY;
				return;
			}

			ConciergeLiveServiceResponse oServiceResponce = super.getRESTResponse(sURL, 'GET', (String)null, oSettings.Authorization_Key__c);

			//How did it go?
			if (oServiceResponce.IsOK) {
				//return oServiceResponce.oResponse.getBody();
				String sBody = oServiceResponce.oResponse.getBody();
				bHeader 	= false;
				//For bounds testing

				//sBody = 'Event,Venue,Date,Number of Tickets,Requester\n';
				//sBody += 'UFC: 200,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 201,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 202,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 203,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 204,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 205,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 206,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 207,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 208,Las Vegas Arena,2016-07-09,2,John Bryan\n';
				//sBody += 'UFC: 209,Las Vegas Arena,2016-07-09,2,John Bryan\n';

				List<String> listRows = sBody.split('\n');

				//HistoryHTML = '<table width="100%">';

				for(String sRow : listRows) {
					//HistoryHTML += '<tr valign="top">';

					if (bHeader) {

						History h = new History();

						List<String> listColumns = sRow.split(',');

						//'Event', 'Venue', 'Date', 'Number of Assigned Tickets', 'Value', 'Ticket Request ID', ‘Requester'

						try {
							h.oEvent 			= listColumns[0];
							h.oVenue 			= listColumns[1];
							h.oDate 			= listColumns[2];
							h.oNumberOfTickets 	= listColumns[3];
							h.oTicketRequestId 	= listColumns[5];
							h.oRequester 		= listColumns[6];

							h.oValue 			= Decimal.valueOf(listColumns[4]);

						} Catch (Exception e) {}

						oHistoryList.add(h);
					}

					bHeader 	= true;

					//for (String sCol : listColumns) {

					//	if (bHeader == true)
							//HistoryHTML += '<td Width="200px" style="font-weight:bold">' + sCol + '</td>';
					//	else

							//HistoryHTML += '<td Width="200px">' + sCol + '</td>';

					//}

					//HistoryHTML += '</tr>';
					//bHeader 	= false;
				}


				//HistoryHTML += '</table>';

				ConciergeLiveUtils.LogDebug(sClassName, sMethodName, oServiceResponce.oResponse.getBody());
			}
			else {

				ConciergeLiveUtils.LogDebug(sClassName, sMethodName, 'Callout had a Status Code not equal to 200: ' + oServiceResponce.FaultCode + '; ' + oServiceResponce.FaultString);

 				if (String.isNotBlank(oServiceResponce.FaultString)) {
 					if (oServiceResponce.FaultString.contains('not found')) {
 						GeneralMessage 			= ConciergeLiveConstants.MESSAGE_NOHISTORY;
 						return;
 					}
 				}

 				try {

	 				if (oSettings.Historical_Debug__c)
	 					GeneralMessage 			= oServiceResponce.oResponse.getBody() + oServiceResponce.FaultString;
	 				else
						GeneralMessage 			= ConciergeLiveConstants.MESSAGE_CALLOUT_FAILURE;

				} Catch(Exception e) {
					GeneralMessage 			= ConciergeLiveConstants.MESSAGE_CALLOUT_FAILURE;
				}


				//return oServiceResponce.FaultCode + oServiceResponce.FaultString;
				//throw new ConciergeLiveUtils.CoreAppException('Callout had a Status Code not equal to 200: ' + sClassName + sMethodName + ': ' + oServiceResponce.FaultCode + '; ' + oServiceResponce.FaultString);
			}

		} Catch(Exception e) {

			try {

 				if (oSettings.Historical_Debug__c)
 					GeneralMessage 			= e.getMessage();
 				else
					GeneralMessage 			= ConciergeLiveConstants.MESSAGE_CALLOUT_FAILURE;

			} Catch(Exception ex) {
				GeneralMessage 			= ConciergeLiveConstants.MESSAGE_CALLOUT_FAILURE;
			}

			ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e);
		}

	}

	//'Event', 'Venue', 'Date', 'Number of Assigned Tickets', 'Value', 'Ticket Request ID', ‘Requester'

	public class History {
		public String oEvent 			{Get;Set;}
		public String oVenue 			{Get;Set;}
		public String oDate 			{Get;Set;}
		public String oNumberOfTickets 	{Get;Set;}
		public Decimal oValue 			{Get;Set;}
		public String oTicketRequestId 	{Get;Set;}
		public String oRequester 		{Get;Set;}
	}

}