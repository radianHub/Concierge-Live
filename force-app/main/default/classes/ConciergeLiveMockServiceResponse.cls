@isTest
public class ConciergeLiveMockServiceResponse implements HttpCalloutMock{

	public static final String sClassName 	= 'ConciergeLiveMockServiceResponse';

	public enum MethodName {NONE, HISTORY}

	protected Integer iStatusCode;
	protected String sResponse;
	protected MethodName eMethod;

	public ConciergeLiveMockServiceResponse() {
		this.iStatusCode 	= 200;
		this.sResponse 		= '{data:test}';
		this.eMethod 		= MethodName.NONE;
	}

	public ConciergeLiveMockServiceResponse(Integer iStatusCode, String sResponse) {
		this.iStatusCode 	= iStatusCode;
		this.sResponse 		= sResponse;
	}

	public ConciergeLiveMockServiceResponse(MethodName eMethod, Integer iStatusCode, String sResponse) {
		this.iStatusCode 	= iStatusCode;
		this.sResponse 		= sResponse;
		this.eMethod 		= eMethod;
	}

    public HTTPResponse respond(HTTPRequest req)
    {
        HttpResponse oRes = new HttpResponse();

        oRes.setHeader('Content-Type', 'application/json');

		oRes.setStatusCode(iStatusCode);

        oRes.setBody(sResponse);

        if (eMethod == MethodName.HISTORY) {
        	//Do anything special - if needed
        }

        return oRes;
    }

}