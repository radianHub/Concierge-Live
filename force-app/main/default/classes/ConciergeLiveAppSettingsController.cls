/**
* {Purpose} - Controller class used to manage the entries from Concierge_Live_Settings__c custom setting
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
public with sharing class ConciergeLiveAppSettingsController {

     public static final string sClassName          = 'ConciergeLiveAppSettingsController';

    /* Public Variables */
    public Concierge_Live_Settings__c oAppSettings          {get; set;}
    public Boolean bEditMode                            {get; set;}

    /*------------------------------------------------------------*/
    /* Constructor */
    public ConciergeLiveAppSettingsController () {

        this.bEditMode  = false;
        //loadSettings();

    }
    /*------------------------------------------------------------*/
    public void loadSettings() {

       this.oAppSettings    = ConciergeLiveUtils.getApplicationCustomSetting();

    }
    /*------------------------------------------------------------*/
    public Concierge_Live_Settings__c doDefaults() {

        Concierge_Live_Settings__c oNewSetting = new Concierge_Live_Settings__c ();
        oNewSetting.Name = ConciergeLiveConstants.APP_KEY;
        insert oNewSetting;
        return ConciergeLiveUtils.getApplicationCustomSetting();

    }
    /*------------------------------------------------------------*/
    public PageReference editPage() {

        this.bEditMode = true;

       if (this.oAppSettings == null) {
            this.oAppSettings = doDefaults();
        }

        return null;

    }
    /*------------------------------------------------------------*/
    public PageReference cancelPage() {

        this.bEditMode = false;
        loadSettings();
        return null;

    }
    /*------------------------------------------------------------*/
    public PageReference savePage() {

        update oAppSettings;

        this.bEditMode = false;

        return null;
    }

}