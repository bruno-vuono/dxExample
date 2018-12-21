public class ASI_CRM_KR_PVAGuideline_TriggerClass {
    
    public static void routineBeforeUpsert(list<ASI_CRM_KR_A_P_Guideline__c> trigger_new,map<id, ASI_MFM_PO__c> trigger_oldMap) {
        
        Set<id> customerIdSet = new Set<id>();
        set<id> PVAIDSet= new set<id>();
        for (ASI_CRM_KR_A_P_Guideline__c new_guideline:trigger_new) { 
           /* if(new_guideline.ASI_CRM_KR_External_ID_Upload__c!=null){
                new_guideline.ASI_CRM_KR_External_ID_Upload__c=NULL;
            }*/
           
            if(new_guideline.ASI_CRM_KR_Customer__c!=null){
                customerIdSet.add(new_guideline.ASI_CRM_KR_Customer__c);
            }
            if(new_guideline.ASI_CRM_KR_PVA__c!=null){
                PVAIDSet.add(new_guideline.ASI_CRM_KR_PVA__c);
            }
            
            /*
            if(new_guideline.ASI_CRM_KR_PVA__r.ASI_CRM_KR_Brand__c!=null&&new_guideline.ASI_KOR_Brand_Code__c!=null){
                if(new_guideline.ASI_CRM_KR_PVA__r.ASI_CRM_KR_Brand__c != new_guideline.ASI_KOR_Brand_Code__c){
                    new_guideline.adderror('Brand Code is not the same as PVA Brand.');
                }
                
            }*/
        }
        
        Map<id,ASI_CRM_AccountsAdditionalField__c> customerMap = new Map<id,ASI_CRM_AccountsAdditionalField__c>();
        Map<id,ASI_CRM_KR_PVA__c> PVAMap =new Map<id,ASI_CRM_KR_PVA__c>() ;
        if(customerIdSet.size()>0){
            customerMap=New Map<id,ASI_CRM_AccountsAdditionalField__c> ([select id,ASI_CRM_Account__c from ASI_CRM_AccountsAdditionalField__c where id in : customerIdSet]);
        }
        
        if(PVAIDSet.size()>0){
            PVAMap = new Map<id,ASI_CRM_KR_PVA__c>([select id,ASI_CRM_KR_Brand__c from ASI_CRM_KR_PVA__c where id in : PVAIDSet]);
        }
        
        //Checking 
        for(ASI_CRM_KR_A_P_Guideline__c new_guideline:trigger_new){ 
            //checking 1: Customer should in Same Account
            if((new_guideline.ASI_CRM_KR_Customer__c!=null && customerMap.containsKey(new_guideline.ASI_CRM_KR_Customer__c))){
                if(customerMap.get(new_guideline.ASI_CRM_KR_Customer__c).ASI_CRM_Account__c!=new_guideline.ASI_CRM_KR_Account_Code__c){
                    new_guideline.adderror('Customer and Account Code is not match.');
                }
            }
            //checking 2: PVA should in Same Brand
            if(new_guideline.ASI_CRM_KR_PVA__c!=null && PVAMap.containsKey(new_guideline.ASI_CRM_KR_PVA__c)){
                if(PVAMap.get(new_guideline.ASI_CRM_KR_PVA__c).ASI_CRM_KR_Brand__c!=new_guideline.ASI_KOR_Brand_Code__c){
                    new_guideline.adderror('Brand Code is not the same as PVA Brand.');
                }
            }
        }
        
        
        
        
    }//end of routineBeforeInsert
}