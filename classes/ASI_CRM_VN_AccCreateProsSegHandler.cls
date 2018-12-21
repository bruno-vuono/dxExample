/*********************************************************************************
 * Name:ASI_CRM_VN_AccCreateProsSegHandler
 * Description: Customer Trigger Handler for CRM VN, copy from SG
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 21/11/2014       Laputa: Alvin           Created
*********************************************************************************/

public with sharing class ASI_CRM_VN_AccCreateProsSegHandler{
    public void createProsSegRecord(List<ASI_CRM_AccountsAdditionalField__c> ASIAccountList) {
        manageAccountProsSegRecord(ASIAccountList);
    }
    
    public void updateProsSegRecord(List<ASI_CRM_AccountsAdditionalField__c> accountList, Map<Id, ASI_CRM_AccountsAdditionalField__c> oldAccountMap) {
        List<ASI_CRM_AccountsAdditionalField__c> filteredAccountList = new List<ASI_CRM_AccountsAdditionalField__c>();
        
        for(ASI_CRM_AccountsAdditionalField__c acc : accountList) {
            ASI_CRM_AccountsAdditionalField__c oldAcc = oldAccountMap.get(acc.Id);
            if(acc.ASI_CRM_VN_OutletType__c != oldAcc.ASI_CRM_VN_OutletType__c || 
               acc.ASI_CRM_Outlet_Sub_Type__c != oldAcc.ASI_CRM_Outlet_Sub_Type__c || 
               acc.ASI_CRM_Area__c != oldAcc.ASI_CRM_Area__c) {
            	filteredAccountList.add(acc);
            }
        }
        
        manageAccountProsSegRecord(filteredAccountList);
    }
    
    private void manageAccountProsSegRecord(List<ASI_CRM_AccountsAdditionalField__c> ASIAccountList){
        Map<Id, ASI_CRM_AccountsAdditionalField__c> accountMap = new Map<Id, ASI_CRM_AccountsAdditionalField__c>(ASIAccountList);
      	
        List<ASI_CRM_Pros_Segmentation__c> prosSegList = new List<ASI_CRM_Pros_Segmentation__c>();
        Set<String> outletTypeSet = new Set<String>();
        for(ASI_CRM_AccountsAdditionalField__c asAcc : ASIAccountList){ 
            outletTypeSet.add(asAcc.ASI_CRM_VN_OutletType__c);               
        }
        
        Map<String, ASI_CRM_Group_Outlet_Type__c> outletMap = new Map<String, ASI_CRM_Group_Outlet_Type__c>();
        for(ASI_CRM_Group_Outlet_Type__c outlet: [Select Id, ASI_CRM_SG_Group_Outlet_Name__c, ASI_CRM_Outlet_Sub_Type__c, ASI_CRM_Area__c From ASI_CRM_Group_Outlet_Type__c Where ASI_CRM_SG_Group_Outlet_Name__c In :outletTypeSet And RecordType.DeveloperName = 'ASI_CRM_VN_Group_Outlet_Type']){
            
            String key = outlet.ASI_CRM_SG_Group_Outlet_Name__c.toLowerCase();
            if(String.isNotBlank(outlet.ASI_CRM_Outlet_Sub_Type__c)) {
                for(String outletSubType : outlet.ASI_CRM_Outlet_Sub_Type__c.split(';')) {
                	key += '_' + outletSubType.toLowerCase().trim();
                    
                    if(String.isNotBlank(outlet.ASI_CRM_Area__c)) {
                        for(String area : outlet.ASI_CRM_Area__c.split(';')) {
                            key += '_' + area.toLowerCase().trim();
                            outletMap.put(key, outlet);
                            key = key.removeEnd('_' + area.toLowerCase().trim());
                        }
                    } else {
                        outletMap.put(key, outlet);
                    }
                    
                    key = outlet.ASI_CRM_SG_Group_Outlet_Name__c.toLowerCase();
                }
            } else if(String.isNotBlank(outlet.ASI_CRM_Area__c)) {
                List<String> areaList = outlet.ASI_CRM_Area__c.split(';');
                for(String area : areaList) {
                	key += '_' + area.toLowerCase().trim();
            		outletMap.put(key, outlet);
                    key = key.removeEnd('_' + area.toLowerCase().trim());
                }
            } else {
            	outletMap.put(key, outlet);
            }
        }
        
        System.debug(outletMap.keySet());
        
        for(ASI_CRM_AccountsAdditionalField__c asAcc : ASIAccountList){  
            ASI_CRM_Pros_Segmentation__c ps = new ASI_CRM_Pros_Segmentation__c();
            
            ps.ASI_CRM_SG_Customer__c = asAcc.Id;
            ps.recordtypeid = Global_RecordTypeCache.getRTId('ASI_CRM_Pros_Segmentation__cASI_CRM_VN_PROS_Segmentation');
            
            String outletType = String.isBlank(asAcc.ASI_CRM_VN_OutletType__c) ? '' : asAcc.ASI_CRM_VN_OutletType__c.toLowerCase();
            String outletSubType = String.isBlank(asAcc.ASI_CRM_Outlet_Sub_Type__c) ? '' : asAcc.ASI_CRM_Outlet_Sub_Type__c.toLowerCase();
            String area = String.isBlank(asAcc.ASI_CRM_Area__c) ? '' : asAcc.ASI_CRM_Area__c.toLowerCase();
            
            String key1 = outletType + '_' + outletSubType + '_' + area;
            String key2 = outletType + '_' + outletSubType;
            String key3 = outletType + '_' + area;
            String key4 = outletType;
            
            System.debug(key1);
            System.debug(key2);
            System.debug(key3);
            System.debug(key4);
            
            if(outletMap.containsKey(key1)){
                ps.ASI_CRM_SG_Group_Outlet_Type__c = outletMap.get(key1).Id;
            } else if(outletMap.containsKey(key2)) {
                ps.ASI_CRM_SG_Group_Outlet_Type__c = outletMap.get(key2).Id;
            } else if(outletMap.containsKey(key3)) {
                ps.ASI_CRM_SG_Group_Outlet_Type__c = outletMap.get(key3).Id;
            } else if(outletMap.containsKey(key4)) {
                ps.ASI_CRM_SG_Group_Outlet_Type__c = outletMap.get(key4).Id;
            }
            prosSegList.add(ps);                        
        }
        
        
        List<ASI_CRM_Pros_Segmentation__c> existProSegList = [SELECT Id, ASI_CRM_SG_Customer__c 
                                                              FROM ASI_CRM_Pros_Segmentation__c 
                                                              WHERE ASI_CRM_SG_Customer__c in :accountMap.keySet()];
        
        if(existProSegList.size() > 0) delete existProSegList;
        
        if(prosSegList.size() > 0) insert prosSegList;
    }
    
}