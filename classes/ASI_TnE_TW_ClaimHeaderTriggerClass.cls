public with sharing class ASI_TnE_TW_ClaimHeaderTriggerClass {


    public static void beforeDeleteMethod(Map<Id, ASI_TnE_ClaimHeader__c> pMapOldClaimHeaders) {
        system.debug('**beforeDeleteMethod**' + pMapOldClaimHeaders);
        //Initiallizing collections
        List<ASI_MFM_PO__c> lstPO_ToUpdate = new List<ASI_MFM_PO__c>();
        Map<Id, Double> mapPOWithAmt = new Map<Id, Double>();
        Map<Id, Double> mapPOWithAmtToReduce = new Map<Id, Double>();
        
        Double amt;
        
        //Iterating to calculate amount to deduct for a PO
        for(ASI_TnE_ClaimDetail__c claimDtl : [SELECT Id, ASI_TnE_Receipt_Amount__c, 
                                                      ASI_TnE_MFM_PO__c,
                                                      ASI_TnE_MFM_PO__r.ASI_MFM_T_E_Amount__c
                                               FROM ASI_TnE_ClaimDetail__c
                                               WHERE ASI_TnE_Receipt_Amount__c != null 
                                               AND ASI_TnE_MFM_PO__c != null 
                                               AND  ASI_TnE_ClaimHeader__c IN : pMapOldClaimHeaders.keySet()]){
            
            amt = mapPOWithAmtToReduce.get(claimDtl.ASI_TnE_MFM_PO__c);
            
            if(amt == null) 
                amt  = 0.0;
               
            amt = amt + claimDtl.ASI_TnE_Receipt_Amount__c;
            
            mapPOWithAmtToReduce.put(claimDtl.ASI_TnE_MFM_PO__c, amt);
            mapPOWithAmt.put(claimDtl.ASI_TnE_MFM_PO__c, claimDtl.ASI_TnE_MFM_PO__r.ASI_MFM_T_E_Amount__c);
        }//End for
        
        system.debug('**mapPOWithAmt**' + mapPOWithAmt); 
        system.debug('**mapPOWithAmtToReduce**' + mapPOWithAmtToReduce);  
                                                  
        //Calculating remaining amount for PO
        for(Id poId : mapPOWithAmtToReduce.keySet()){
            amt = mapPOWithAmt.get(poId ) == null ? 0.0 : mapPOWithAmt.get(poId );
            
            lstPO_ToUpdate.add(new ASI_MFM_PO__c(Id = poId, 
                                                 ASI_MFM_T_E_Amount__c = (amt - mapPOWithAmtToReduce.get(poId))));
        }//End for
        
        system.debug('**lstPO_ToUpdate**' + lstPO_ToUpdate);
               
        if(!lstPO_ToUpdate.isEmpty()) {
            try {
                update lstPO_ToUpdate;
            } catch(DmlException exceptionInstance) {
                System.debug('Error occurred : ' + exceptionInstance.getMessage());
            }//End Catch
        }//End if !lstPosToUpdate.isEmpty()
    }//End beforeDeleteMethod method

}//End ASI_TnE_TW_ClaimHeaderTriggerClass  Class