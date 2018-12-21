public  with sharing  class ASI_MFM_PH_Payment_TriggerClass {
    //For MFM PH Use Only
    public static void routineAfterUpdate(list<ASI_MFM_Payment__c> trigger_new, map<id, ASI_MFM_Payment__c> trigger_oldMap) {   
        if (Global_RecordTypeCache.getRt(trigger_new[0].recordTypeId).developerName.startsWith('ASI_MFM_PH')){
            Set<ID> paymentIDs = new Set<ID>();
            for (ASI_MFM_Payment__c pay:trigger_new) {
                if (pay.ASI_MFM_Status__c == 'Final' && trigger_oldMap.get(pay.id).ASI_MFM_Status__c == 'Submitted'){
                    paymentIDs.add(pay.id);
                }
            }
            ID Rectypeid = Schema.SObjectType.ASI_MFM_PO_Line_Item__c.getRecordTypeInfosByName().get('PH PO Line Item').getRecordTypeId();
            List<ASI_MFM_PO_Line_Item__c> newPOL = new List<ASI_MFM_PO_Line_Item__c>();
            List<ASI_MFM_Payment_Line_Item__c> payLineList = [select id,ASI_MFM_Payment_Amount__c,ASI_MFM_PO_Line_Item__r.name,ASI_MFM_PO_Line_Item__r.ASI_MFM_Paid_Amount__c,ASI_MFM_PO_Line_Item__r.ASI_MFM_Amount__c,ASI_MFM_PO_Line_Item__c, ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c, ASI_MFM_PO_Line_Item__r.ASI_MFM_Customer_Name__c, ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__c, ASI_MFM_PO_Line_Item__r.ASI_MFM_A_C_Code__c, ASI_MFM_PO_Line_Item__r.ASI_MFM_Remaining_Balance__c,ASI_MFM_PO_Line_Item__r.ASI_MFM_G_L_Date__c from ASI_MFM_Payment_Line_Item__c where ASI_MFM_Payment__c = :paymentIDs and ASI_MFM_Complete_POL__c = true  AND ASI_MFM_PO_Line_Item__r.ASI_MFM_Complete__C=false];//AND ASI_MFM_PO_Line_Item__r.ASI_MFM_Remaining_Balance__c > 0
            String Description;
            for (ASI_MFM_Payment_Line_Item__c payL : payLineList){
                if(payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_Remaining_Balance__c!=0){
                    decimal Remaining = payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_Amount__c - payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_Paid_Amount__c;
                    Description='Closing PO Adjustment: '+payL.ASI_MFM_PO_Line_Item__r.name+'- Paid Amount: '+payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_Paid_Amount__c+'; Remaining Amount: '+ Remaining;
                    ASI_MFM_PO_Line_Item__c pol = new ASI_MFM_PO_Line_Item__c(ASI_MFM_List_Item_Description__c = Description, ASI_MFM_Amount__c = 0-Remaining , ASI_MFM_PO__c = payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c,ASI_MFM_Customer_Name__c = payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_Customer_Name__c, ASI_MFM_A_C_Code__c = payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_A_C_Code__c, ASI_MFM_Sub_brand_Code__c = payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__c, ASI_MFM_Complete__C = true, recordTypeId=Rectypeid, ASI_MFM_G_L_Date__c = payL.ASI_MFM_PO_Line_Item__r.ASI_MFM_G_L_Date__c,ASI_MFM_Adjustment_Line__c = true);
                    newPOL.add(pol);
                }
                ASI_MFM_PO_Line_Item__c CompletePol = new ASI_MFM_PO_Line_Item__c(ASI_MFM_Complete__c = true, ID = payL.ASI_MFM_PO_Line_Item__c);
                
                newPOL.add(CompletePol);
            }
            upsert newPOL;
            
        }
    }
}