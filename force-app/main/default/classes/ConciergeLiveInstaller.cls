/**
 * {Purpose} - Post Installer class
 *
 * @author   Cirrius Solutions
 * @version
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date          Name                    Description
 * 2016-06-09    Sarbello                Created
 * =============================================================================
 */
global class ConciergeLiveInstaller implements InstallHandler {
	public static final string sClassName = 'ConciergeLiveInstaller';

	global void onInstall(InstallContext context) {
		if (context.previousVersion() == null) {
			//In here because this is the FIRST install

			//TODO Configure CustomSettings
			ConciergeLiveAppSettingsController oController = new ConciergeLiveAppSettingsController();
			oController.doDefaults();
		} else {
			Database.executeBatch(new AttendeeContactBatch());
		}
	}
}
