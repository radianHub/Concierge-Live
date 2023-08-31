/**
* {Purpose} - Test class for ConciergeLiveInstaller
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
public class ConciergeLiveInstallerTest {

@isTest
public static void testInstallScript() {

	ConciergeLiveInstaller oInstaller = new ConciergeLiveInstaller();

    Test.testInstall(oInstaller, null);

    //Test.testInstall(oInstaller, new Version(1,0), true);

    Concierge_Live_Settings__c oSettings = ConciergeLiveUtils.getApplicationCustomSetting();

    System.assertNotEquals(null, oSettings, 'Installer failed to create the Custom Setting');

  }

}