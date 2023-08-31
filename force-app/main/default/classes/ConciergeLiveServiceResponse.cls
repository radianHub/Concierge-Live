/**
* {Purpose} - Service Response Class
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
public class ConciergeLiveServiceResponse {

	public HttpResponse oResponse	{get;set;}
	public boolean IsOK 			{get;set;}
	public String FaultCode 		{get;set;}
	public String FaultString 		{get;set;}

	public ConciergeLiveServiceResponse() {
		IsOK			= false;
		FaultCode		= '';
		FaultString		= '';
	}

	public ConciergeLiveServiceResponse(HttpResponse oRes, boolean IsOK, String FaultCode, String FaultString) {
		this.oResponse		= oRes;
		this.IsOK			= IsOK;
		this.FaultCode		= FaultCode;
		this.FaultString	= FaultString;
	}

}