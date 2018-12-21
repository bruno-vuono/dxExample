public class ASI_TnE_ClaimDetailTriggerClass {
    public static void routineBeforeUpsert(list<ASI_TnE_ClaimDetail__c> trigger_new, map<id, ASI_TnE_ClaimDetail__c> trigger_oldMap) {
            
        integer numOfLine = 0;    
        set<id> detail_set = new set<id>();
        Set<id> ownerIDSet = new Set<id>();
        
        Map<id,string> headerOwnerIDMap = new Map<id,string>();
        Map<id,string> ownerDeptCodeMap = new Map<id,string>();
        Map<String, String> accMap = new Map<String, String>(); 
        Set<id> headerIDSet = new Set<id>();
        
        if (trigger_new != null) {
            for (ASI_TnE_ClaimDetail__c d:trigger_new) {
                headerIDSet.add(d.ASI_TnE_ClaimHeader__c);
            }
            
            for (ASI_TnE_ClaimHeader__c header:[select OwnerID, ASI_TnE_Number_of_Line__c from ASI_TnE_ClaimHeader__c where id = :headerIDSet]){
                ownerIDSet.add(header.OwnerID);
                headerOwnerIDMap.put(header.id, header.OwnerID);
                numOfLine = Integer.valueOf(header.ASI_TnE_Number_of_Line__c);
            }
            
            for (User u:[select ASI_TnE_Department_Code__c from User where id = :ownerIDSet]){
                ownerDeptCodeMap.put(u.id, u.ASI_TnE_Department_Code__c);
            }
            
                  
            for(ASI_TnE_Account_Mapping__c accountmapping : [select ASI_TnE_Account_Number__c, ASI_TnE_Expense_Type__c from ASI_TnE_Account_Mapping__c where ASI_TnE_Country__c = 'VN']){
                accMap.put(accountmapping.ASI_TnE_Expense_Type__c, accountmapping.ASI_TnE_Account_Number__c);
            }
        
            for (ASI_TnE_ClaimDetail__c d:trigger_new) {                
                if (d.ASI_TnE_Amount__c != null){
                    if (d.ASI_TnE_VAT__c){
                        d.ASI_TnE_Original_Amount__c = Math.Round((d.ASI_TnE_Amount__c / 1.1).setScale(0));
                        d.ASI_TnE_Tax_Amount__c = Math.Round((d.ASI_TnE_Amount__c - (d.ASI_TnE_Amount__c / 1.1)).setScale(0));
                    }
                    else {
                        d.ASI_TnE_Original_Amount__c = d.ASI_TnE_Amount__c;
                        d.ASI_TnE_Tax_Amount__c = 0;
                    }
                }
                
                //20160804 Wilken: Update Account Number again whenever T&E Detail is updated
                if (headerOwnerIDMap.get(d.ASI_TnE_ClaimHeader__c) != null && ownerDeptCodeMap.get(headerOwnerIDMap.get(d.ASI_TnE_ClaimHeader__c)) != null && accMap.get(d.ASI_TnE_Expense_Type__c) != null)
                    d.ASI_TnE_Account_Number__c = '7781D' + ownerDeptCodeMap.get(headerOwnerIDMap.get(d.ASI_TnE_ClaimHeader__c)) + 'VN.' + accMap.get(d.ASI_TnE_Expense_Type__c);               
            }
            
            // Added 2017-11-13 Linus@introv 
            // limit the maximum line created in 25
            if(Global_RecordTypeCache.getRt(trigger_new[0].recordTypeid).developerName.contains('ASI_TnE_VN_Claim_Detail')){ 
                if(numOfLine == 25 && trigger_oldMap == null){
                    trigger_new[0].addError('Not allowed create more than 25 lines');
                 }
            }
        }
    }
    
    public static void routineBeforeDelete(list<ASI_TnE_ClaimDetail__c> trigger_old) {
        set<id> detailID_set = new set<id>();
        for (ASI_TnE_ClaimDetail__c detail:trigger_old) {
            detailID_set.add(detail.ASI_TnE_ClaimHeader__c);
        }
        map<id, ASI_TnE_ClaimHeader__c> claim_map = new map<id, ASI_TnE_ClaimHeader__c>([select id from ASI_TnE_ClaimHeader__c where id in :detailID_set and ASI_TnE_Status__c = 'Finance Director Approved']);        
        for (ASI_TnE_ClaimDetail__c detail:trigger_old) {
            if (claim_map.containsKey(detail.ASI_TnE_ClaimHeader__c)) {
                detail.addError('Not allowed to delete because the claim form has been approved');
            }
        }
    }
        
    public static void routineAfterInsert(list<ASI_TnE_ClaimDetail__c> trigger_new, map<id, ASI_TnE_ClaimDetail__c> trigger_oldMap) {       
        //Wilken 20160804, migrated Account Code update logic to BeforeUpsert method
    }
}