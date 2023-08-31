public virtual class ConciergeLiveServiceBase {

	public static final String sClassName 			= 'ConciergeLiveServiceBase';
	public static final Integer TIMEOUT_IN_SECONDS	= 90;

	public ConciergeLiveServiceBase() {

	}

	/*----------------------------------------------------------------------------------------------*/
	@TestVisible private ConciergeLiveServiceResponse ProcessResponse(HttpResponse oRes) {

		String sMethodName = 'ProcessResponse';

		ConciergeLiveServiceResponse r 	= new ConciergeLiveServiceResponse(oRes, true, (String)null, (String)null);

		try {

			r.IsOk = (oRes.getStatusCode() == 200);

			//IF MULTIPLE CODES CAN REPRESENT SUCCESS
			//List<integer> listOKStatusCodes = new List<integer>{200,201};
            //for (Integer i : listOKStatusCodes) {
            //    r.IsOk = (oRes.getStatusCode() == i);
            //    if (r.IsOk) break;
            //}

			//IMPORTANT - This tells us what went wrong and what the general response was from the web service
			// string.ValueOf(res) only returns something like "System.HttpResponse[Status=Bad Request, StatusCode=400]"
			// or "System.HttpResponse[Status=OK, StatusCode=200]". It does NOT return the GetBody() contents.

			if (r.IsOK == false) {
				r.FaultCode 	= string.ValueOf(oRes.getStatusCode());
				r.FaultString 	= oRes.getStatus() + ' ' + oRes.GetBody();
			}

    	} catch(System.Exception e) {
    		ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e, 'Body: '+  oRes.GetBody());
    	}

 		return r;

	}

    /*----------------------------------------------------------------------------------------------*/
	//@TestVisible private String getAuthorizationHeader() {
	//
	//	Cirrius_Settings__c oSettings = CirriusUtils.getApplicationCustomSetting();
	//
	//	String sAuthFormat = '{1}:{2}';
	//
	//	//Build the Password
	//	String sConcat = EncodingUtil.urlEncode(oSettings.Service_Access_Token__c + CirriusConstants.CODE_PEPPER, 'UTF-8');
	//
	//	String sPassword = String.ValueOf(oSettings.Service_Access_Token_Id__c) + '_' + CirriusUtils.getMD5Hash(sConcat);
	//
	//	sAuthFormat = sAuthFormat.replace('{1}', oSettings.Service_Username__c);
	//	sAuthFormat = sAuthFormat.replace('{2}', sPassword);
	//
	//	Blob headerValue = Blob.valueOf(sAuthFormat);
	//
	//	return 'Basic ' + EncodingUtil.base64Encode(headerValue);
	//}

    /*----------------------------------------------------------------------------------------------*/
    public virtual ConciergeLiveServiceResponse getRESTResponse(String oEndPoint, String oVerb, String oBody, String oAuthorization_Key) {

        String sMethodName = 'getRESTResponse';

        Http oHttp          = new Http();
        HttpRequest oReq    = new HttpRequest();
        HttpResponse oRes   = new HttpResponse();

        oReq.setTimeout(TIMEOUT_IN_SECONDS * 1000);

        //*****************************************************************************************//
        //NOTE: If Content is 'application/json' then BODY can be simply JSON:
        oReq.setHeader('Content-Type', 'application/json');
        //*****************************************************************************************//

        //*****************************************************************************************//
        //NOTE:  CUSTOM HEADERS
        //oReq.setHeader('X-Salesforce-User', UserInfo.getUserId());
        oReq.setHeader('X-ConciergeLive-ApiKey', oAuthorization_Key);
        //*****************************************************************************************//

        //*****************************************************************************************//
        //NOTE:  Any space in the URL needs to be encoded. BTW - encodeURL did not work here
        oReq.setEndpoint(oEndPoint.replace(' ','%20'));
        //*****************************************************************************************//

        oReq.setMethod(oVerb);

        //*****************************************************************************************//
        //NOTE: If you need to see Authorization
		//oReq.setHeader('Authorization', sAuthorizationHeader);
        //*****************************************************************************************//

		//*****************************************************************************************//
        //NOTE: If Content is 'application/json' then BODY can be simply JSON:
        if (String.isNotBlank(oBody))  oReq.setBody(oBody);
		 //*****************************************************************************************//

        try {

			Concierge_Live_Settings__c oSettings = ConciergeLiveUtils.getApplicationCustomSetting();

			//if (oSettings.Active__c) {
				oRes = oHttp.send(oReq);
			//}
			//else {
			//	oRes = new HttpResponse();
			//	oRes.setBody('Disabled in App Settings');
			//	oRes.SetStatusCode(0);
			//	oRes.SetStatus('Disabled in App Settings');
			//}

    	} catch(System.Exception e) {
    		ConciergeLiveUtils.LogDebug(sClassName, sMethodName, e, 'oEndPoint: '+ oEndPoint + ', oVerb: ' + oVerb + ', oBody:' + oBody);
    		return new ConciergeLiveServiceResponse(oRes, false, '0', e.getMessage());
    	}

    	return ProcessResponse(oRes);


    }

}