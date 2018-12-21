public class ASI_KOR_SR_CalculateBMAmount extends ASI_KOR_TriggerAbstract {
	
    private final static Set<String> categorySet = new Set<String> {
        'Local Whisky', 'International Whisky', 'Modern Spirits', 'Competitor’s brands'
    };
    
    public ASI_KOR_SR_CalculateBMAmount() {
        super('ASI_KOR_SR_CalculateBMAmount');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        List<ASI_KOR_SR_Proposal_Header__c> srProposalHeaderList = (List<ASI_KOR_SR_Proposal_Header__c>) sObjList;
        Map<Id, ASI_KOR_SR_Proposal_Header__c> srProposalHeaderMap = (Map<Id, ASI_KOR_SR_Proposal_Header__c>) oldMap;
        
       	Set<Id> bmProposalHeaderIdSet = new Set<Id>();
        Set<Id> srProposalHeaderIdSet = new Set<Id>();
        for(ASI_KOR_SR_Proposal_Header__c srProposalHeader : srProposalHeaderList) {
            if(srProposalHeaderMap.get(srProposalHeader.Id).ASI_KOR_Status__c == 'Draft' && 
               srProposalHeader.ASI_KOR_Status__c == 'Submitted') {
                   bmProposalHeaderIdSet.add(srProposalHeader.ASI_KOR_BM_Proposal_Header__c);
               }
            
            if(srProposalHeaderMap.get(srProposalHeader.Id).ASI_KOR_Status__c == 'Submitted' && 
               srProposalHeader.ASI_KOR_Status__c == 'Draft') {
                bmProposalHeaderIdSet.add(srProposalHeader.ASI_KOR_BM_Proposal_Header__c);
            }
            srProposalHeaderIdSet.add(srProposalHeader.Id);
        }
        
        if(bmProposalHeaderIdSet.size() > 0) {
            Map<Id, Decimal> totalCAAmountPerSRHeaderMap = calculateTotalCAAmountPerSRHeader(srProposalHeaderIdSet);
            
            List<ASI_KOR_BM_Proposal_Header__c> bmProposalHeaderList = calculatBMAmount(totalCAAmountPerSRHeaderMap, srProposalHeaderList, srProposalHeaderMap, bmProposalHeaderIdSet);
            
            if(bmProposalHeaderList.size() > 0) {
                update bmProposalHeaderList;
            }
        }
    }
    
    private Map<Id, Decimal> calculateTotalCAAmountPerSRHeader(Set<Id> srProposalHeaderIdSet) {
        Map<Id, Decimal> totalCAAmountPerSRHeaderMap = new Map<Id, Decimal>();
        
        List<ASI_KOR_SR_Proposal_By_Brand__c> srProposalByBrandList = [SELECT Id, ASI_KOR_SR_Proposal_Header__c, 
                                                                              ASI_KOR_Total_CA_Amount_excl_Basic__c, ASI_KOR_Brand__r.ASI_KOR_Product_Categoray__r.Name
                                                                       FROM ASI_KOR_SR_Proposal_By_Brand__c 
                                                                       WHERE ASI_KOR_SR_Proposal_Header__c in :srProposalHeaderIdSet];
        
        for(ASI_KOR_SR_Proposal_By_Brand__c srProposalByBrand : srProposalByBrandList) {
            if(categorySet.contains(srProposalByBrand.ASI_KOR_Brand__r.ASI_KOR_Product_Categoray__r.Name)) {
                Decimal totalCAAmount = srProposalByBrand.ASI_KOR_Total_CA_Amount_excl_Basic__c;
                if(totalCAAmountPerSRHeaderMap.containsKey(srProposalByBrand.ASI_KOR_SR_Proposal_Header__c)) {
                    totalCAAmount += totalCAAmountPerSRHeaderMap.get(srProposalByBrand.ASI_KOR_SR_Proposal_Header__c);
                }
                totalCAAmountPerSRHeaderMap.put(srProposalByBrand.ASI_KOR_SR_Proposal_Header__c, totalCAAmount);
            }
        }
        
        return totalCAAmountPerSRHeaderMap;
    }
    
    private List<ASI_KOR_BM_Proposal_Header__c> calculatBMAmount(Map<Id, Decimal> totalCAAmountPerSRHeaderMap, List<ASI_KOR_SR_Proposal_Header__c> srProposalHeaderList, Map<Id, ASI_KOR_SR_Proposal_Header__c> srProposalHeaderMap, Set<Id> bmProposalHeaderIdSet) {
        Map<Id, ASI_KOR_BM_Proposal_Header__c> bmProposalHeaderMap = new Map<Id, ASI_KOR_BM_Proposal_Header__c>(
            															[SELECT Id, ASI_KOR_NoofSubmittedSalesRepresentative__c, ASI_KOR_CA_Amount_Pending__c
                                                                    	FROM ASI_KOR_BM_Proposal_Header__c
                                                                    	WHERE Id in :bmProposalHeaderIdSet]
        															 );
        
        for(ASI_KOR_SR_Proposal_Header__c srProposalHeader : srProposalHeaderList) {
            ASI_KOR_BM_Proposal_Header__c bmProposalHeader = bmProposalHeaderMap.get(srProposalHeader.ASI_KOR_BM_Proposal_Header__c);
            
            if(srProposalHeaderMap.get(srProposalHeader.Id).ASI_KOR_Status__c == 'Draft' && 
               srProposalHeader.ASI_KOR_Status__c == 'Submitted') {
                   
                   if(bmProposalHeader.ASI_KOR_NoofSubmittedSalesRepresentative__c == null) {
                       bmProposalHeader.ASI_KOR_NoofSubmittedSalesRepresentative__c = 1;
                   } else {
                       bmProposalHeader.ASI_KOR_NoofSubmittedSalesRepresentative__c += 1;
                   }
                   
                   if(bmProposalHeader.ASI_KOR_CA_Amount_Pending__c == null) {
                       bmProposalHeader.ASI_KOR_CA_Amount_Pending__c = totalCAAmountPerSRHeaderMap.get(srProposalHeader.Id);
                   } else {
                       bmProposalHeader.ASI_KOR_CA_Amount_Pending__c += totalCAAmountPerSRHeaderMap.get(srProposalHeader.Id);
                   }
                   
               }
            
            if(srProposalHeaderMap.get(srProposalHeader.Id).ASI_KOR_Status__c == 'Submitted' && 
               srProposalHeader.ASI_KOR_Status__c == 'Draft') {
                   
                   if(bmProposalHeader.ASI_KOR_NoofSubmittedSalesRepresentative__c == null) {
                       bmProposalHeader.ASI_KOR_NoofSubmittedSalesRepresentative__c = 0;
                   } else {
                       bmProposalHeader.ASI_KOR_NoofSubmittedSalesRepresentative__c -= 1;
                   }
                   
                   if(bmProposalHeader.ASI_KOR_CA_Amount_Pending__c == null) {
                       bmProposalHeader.ASI_KOR_CA_Amount_Pending__c = 0;
                   } else {
                       bmProposalHeader.ASI_KOR_CA_Amount_Pending__c -= totalCAAmountPerSRHeaderMap.get(srProposalHeader.Id);
                   }
                   
               }
        }
        
        return bmProposalHeaderMap.values();
    }
}