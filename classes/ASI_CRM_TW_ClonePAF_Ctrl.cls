/*********************************************************************************
 * Name: ASI_CRM_TW_ClonePAF_Ctrl
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 01/16/2017       Introv: Twinkle LI      Created
*********************************************************************************/

public without sharing class ASI_CRM_TW_ClonePAF_Ctrl {
    public Id pafId { get; set; }
     
    public ASI_CRM_TW_ClonePAF_Ctrl (ApexPages.StandardController standardController){
         ASI_HK_CRM_Pre_Approval_Form__c paf = new ASI_HK_CRM_Pre_Approval_Form__c();        
    }
    
    public PageReference clonePAF(){
        pafId = apexpages.currentPage().getParameters().get('id');     
        
        ASI_HK_CRM_Pre_Approval_Form__c newPaf = new ASI_HK_CRM_Pre_Approval_Form__c();
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafNewDetailList = new List<ASI_HK_CRM_Pre_Approval_Form_Item__c>();
         
        ASI_HK_CRM_Pre_Approval_Form__c oldPaf = [SELECT Id, recordTypeID, ASI_HK_CRM_PAF_Customer__c, ASI_CRM_Channel__c, ASI_CRM_Sub_Channel__c,
                                                  ASI_CRM_No_of_Outlets__c, ASI_CRM_Valid_Invoice__c, ASI_HK_CRM_PAF_Start_Date__c,
                                                  ASI_HK_CRM_PAF_End_Date__c, ASI_CRM_BA_Comment__c, ASI_HK_CRM_Other_Comments__c,
                                                  ASI_CRM_Achievement_for_Conditional__c, ASI_CRM_Achievement_for_Variable__c, 
                                                  ASI_CRM_Incentives_for_Conditional__c, ASI_CRM_Incentives_for_Variable__c
                                                  FROM ASI_HK_CRM_Pre_Approval_Form__c WHERE id =: pafId];      
                                                   
        //Assign values from oldPaf to new Paf     
        newPaf = oldPaf.clone(FALSE, TRUE, FALSE, FALSE);
        newPaf.ASI_HK_CRM_PAF_Status__c = 'Draft';
        newPaf.ASI_CRM_No_of_Outlets__c = null;
        insert newPaf;
        
        //Assign values from oldPafDetail to newPafDetail
        for(ASI_HK_CRM_Pre_Approval_Form_Item__c oldDetail : [SELECT Id, recordTypeID, ASI_HK_CRM_Pre_Approval_Form_Lookup__c,
                                                              ASI_HK_CRM_Mechanic__c, ASI_CRM_Mechanic_Detail__c, ASI_CRM_Expenses_Product__c,
                                                              ASI_CRM_AD_or_AP__c, ASI_CRM_Cash_or_FOC__c, ASI_CRM_Cash_Amounts_w_VAT__c,
                                                              ASI_CRM_FOC_Volume__c, ASI_CRM_Q1_hrs__c, ASI_CRM_Q2_hrs__c, ASI_CRM_Q3_hrs__c,
                                                              ASI_CRM_Q4_hrs__c, ASI_CRM_Cost_Hr_w_VAT__c, ASI_CRM_Sub_Total_hrs__c, 
                                                              ASI_CRM_Total_PG_Cost__c, ASI_CRM_Contracted_Item__c, ASI_HK_CRM_Target_Volume_Qty__c,
                                                              ASI_CRM_Cash_Per_Bottle_w_VAT__c, ASI_CRM_Cash_per_Bottle_A_D_Budget__c, 
                                                              ASI_CRM_Over_Budget_Cash_per_Bottle__c, ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c,
                                                              ASI_HK_CRM_FOC_Free_Bottle_Option_1__c
                                                              FROM ASI_HK_CRM_Pre_Approval_Form_Item__c 
                                                              WHERE ASI_HK_CRM_Pre_Approval_Form_Lookup__c =: pafId]){
            ASI_HK_CRM_Pre_Approval_Form_Item__c pafDetailTemp = oldDetail.clone(FALSE, TRUE, FALSE, FALSE);  
            pafDetailTemp.ASI_HK_CRM_Pre_Approval_Form_Lookup__c = newPaf.Id;          
            pafNewDetailList.add(pafDetailTemp);
        }
        insert pafNewDetailList;
                
        return new PageReference('/' + newPaf.id);
    }
}