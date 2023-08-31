/**
* {Purpose} - Test class for ConciergeLiveHistoryController
*
* @author   Cirrius Solutions
* @version
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2016-06-24    Sarbello                Created
* =============================================================================
*/
@isTest (OnInstall=false)
public class ConciergeLiveServiceResponseTest {
	@isTest
	public static void testMain() {

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new ConciergeLiveMockServiceResponse(500, '{"error":"AccessDenied","message":"Api token is not valid"}'));

		ConciergeLiveServiceResponse oResponse1 = new ConciergeLiveServiceResponse();
		System.assertEquals(False, oResponse1.IsOk);

		ConciergeLiveServiceResponse oResponse2 = new ConciergeLiveServiceResponse(new HttpResponse(), True, '', '');
		System.assertEquals(True, oResponse2.IsOk);

		Test.stopTest();

	}
}