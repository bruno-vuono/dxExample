/*********************************************************************************
 * Name: ASI_CRM_MY_ActualOfftakeProcess
 * Description: For Actual Offtake Calculation (Caution!!! Backend process only, WITHOUT SHARING)
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------
 * 2015-01-25       Axel                   Initial
 *********************************************************************************/
public without sharing class ASI_CRM_MY_ActualOfftakeProcess {

    // Declaration
	integer intCutoffDay;
    // Declaration - End

    /** Constructor */
    public ASI_CRM_MY_ActualOfftakeProcess() {
        List<ASI_CRM_MY_Settings__c> lstCustomSetting = [SELECT ASI_CRM_MY_Offtake_Cutoff_Day__c FROM ASI_CRM_MY_Settings__c LIMIT 1];
		intCutoffDay = 26;
		if (lstCustomSetting != null && lstCustomSetting.size() == 1) 
			intCutoffDay = (integer) lstCustomSetting[0].ASI_CRM_MY_Offtake_Cutoff_Day__c;
    }
	
    /***
     * Perform cutoff to change all the draft Actual Offtake to 
     */
	public void performCutoff() {
        // Delcaration
        list<ASI_CRM_ActualOfftakeHeader__c> lstAO = new list<ASI_CRM_ActualOfftakeHeader__c>();
        Date dteToday = Date.today();
        Date dteCutoff = Date.newInstance(Date.today().Year(), Date.today().month(), intCutoffDay);
        id idRT_AO = Global_RecordTypeCache.getRTId('ASI_CRM_ActualOfftakeHeader__cASI_CRM_ActualOfftakeHeader__c');
        // Delcaration - End
        
        // Check if yesterday date = is equal to 
		if (dteToday.addDays(-1).isSameDay(dteCutoff) || true) {
            lstAO = [
                SELECT id, ASI_CRM_Status__c, ASI_CRM_OfftakeDate__c
                FROM ASI_CRM_ActualOfftakeHeader__c
                WHERE ASI_CRM_Status__c = 'Draft'
                AND ASI_CRM_OfftakeDate__c = THIS_MONTH
                AND RecordTypeID = :idRT_AO
            ];
            for (ASI_CRM_ActualOfftakeHeader__c objAO : lstAO) {
                System.debug('AO ID: ' + objAO.id + ', Status: ' + objAO.ASI_CRM_Status__c + ', ASI_CRM_OfftakeDate__c: ' + objAO.ASI_CRM_OfftakeDate__c);
                objAO.ASI_CRM_Status__c = 'Final';
            }
            //update lstAO;
		}
        System.debug('ASI_CRM_MY_ActualOfftakeProcess:performCutoff - Done');
	}
    
    /***
     * To calculate and store the calculated for the freezed month
     */
    public void snapCalculatedFOC() {
        
    }
}