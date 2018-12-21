/*********************************************************************************
 * Name:ASI_CRM_SG_CreditNote_TriggerClass 
 * Description: 
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2017-07-12       Wilken Lee              Created
*********************************************************************************/

public class ASI_CRM_SG_CreditNote_TriggerClass{
    
    public static void retrieveExchangeRate(List<ASI_CRM_Credit_Debit_Note__c> cNoteList , Map<ID, ASI_CRM_Credit_Debit_Note__c> oldMap) {
        List<String> currencyList = new List<String>();
        
        for (ASI_CRM_Credit_Debit_Note__c cNote : cNoteList ){
            currencyList.add(cNote.ASI_CRM_Currency__c);                        
        }
        
        List<ASI_MFM_Exchange_Rate__c> exRateList = [select id, ASI_MFM_Exchange_Rate__c, ASI_MFM_Counter_Currency__c from ASI_MFM_Exchange_Rate__c 
                                                    where ASI_MFM_Country__c = 'SG' and ASI_MFM_Effective_Date__c <= :System.Today() and ASI_MFM_Application__c = 'MFM' and ASI_MFM_Base_Currency__c = 'SGD'
                                                    and ASI_MFM_Counter_Currency__c in :currencyList order by ASI_MFM_Effective_Date__c desc];
        
        for (ASI_CRM_Credit_Debit_Note__c cNote : cNoteList ){
            if (oldMap == null || cNote.ASI_CRM_Currency__c != oldMap.get(cNote.Id).ASI_CRM_Currency__c)
                for (ASI_MFM_Exchange_Rate__c exRate:exRateList){
                    if (exRate.ASI_MFM_Counter_Currency__c == cNote.ASI_CRM_Currency__c){
                        cNote.ASI_CRM_Exchange_Rate__c = exRate.ASI_MFM_Exchange_Rate__c;
                        break;
                    }                   
                }
        }       
    }
	
	public static void calculateGST(List<ASI_CRM_Credit_Debit_Note__c> cNoteList , Map<ID, ASI_CRM_Credit_Debit_Note__c> oldMap) {
        Set<String> taxCodeSet = new Set<String>{'SG3','CA3','IC3','IN3','LA3','MM3','MY3','PH3'};
        
        for (ASI_CRM_Credit_Debit_Note__c cNote : cNoteList ){
			system.debug('Need GST: ' + taxCodeSet.contains(cNote.ASI_CRM_Tax_Rate_Area__c));
            if (taxCodeSet.contains(cNote.ASI_CRM_Tax_Rate_Area__c))
				cNote.ASI_CRM_GST__c = cNote.ASI_CRM_Total_Actual_Amount__c * 0.07;
			else 
				cNote.ASI_CRM_GST__c = 0;
        }       
    }
	
	public static void validateGLDateChange(List<ASI_CRM_Credit_Debit_Note__c> cNoteList , Map<ID, ASI_CRM_Credit_Debit_Note__c> oldMap) {
        List<GroupMember> gmList = [SELECT UserOrGroupId From GroupMember where GroupID in (Select ID from Group where DeveloperName = 'ASI_CRM_SG_Finance_Verify_Share')];
		Boolean isFinanceUser = false;
		
		for (GroupMember gm:gmList){
			if (UserInfo.getUserId() == gm.UserOrGroupId)
				isFinanceUser = true;
		}
		
        for (ASI_CRM_Credit_Debit_Note__c cNote : cNoteList ){
            if (oldMap != null && oldMap.get(cNote.Id).ASI_CRM_GL_Date__c != null && cNote.ASI_CRM_GL_Date__c != oldMap.get(cNote.Id).ASI_CRM_GL_Date__c){
				if (cNote.ASI_CRM_Sync_To_JDE__c || !isFinanceUser)
					cNote.addError('GL Date cannot be changed');
			}
        }       
    }
	
	public static void validationBeforeDelete(List<ASI_CRM_Credit_Debit_Note__c> cNoteList) {
		for (ASI_CRM_Credit_Debit_Note__c cNote : cNoteList ){
			if (cNote.ASI_CRM_Status__c != 'Draft' && cNote.ASI_CRM_Status__c != 'Rejected')
				cNote.addError('Only Draft or Rejected Credit/Debit Note can be deleted');
		}
	}
}