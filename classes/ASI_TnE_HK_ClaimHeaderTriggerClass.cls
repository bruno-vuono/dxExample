//Added by Elufa Support 5-12-2015
public without sharing class ASI_TnE_HK_ClaimHeaderTriggerClass {
    public static void routineAfterAll (list<ASI_TnE_ClaimHeader__c> trigger_new, map<id, ASI_TnE_ClaimHeader__c> trigger_oldMap) {
        //Get Header Id : 'Export to AP Voucher/GL' change from false to true 
        set<id> header_set = new set<id>();
        if (trigger_new != null) {
            for (ASI_TnE_ClaimHeader__c ClaimHeader:trigger_new) {
               /* if(ClaimHeader.ASI_TnE_Export_to_AP_Voucher_GL__c != trigger_oldMap.get(ClaimHeader.id).ASI_TnE_Export_to_AP_Voucher_GL__c){
                     header_set.add(ClaimHeader.id);
                }*/
                if(trigger_oldMap!=null){
                    // include :  ASI_TnE_Status__c change to 'Final' or  ASI_TnE_Sync_to_JDE_Date__c changed
                    // 20180110 Introv added ClaimHeader.ASI_TnE_3rd_Party__c for concur API
                    if(ClaimHeader.ASI_TnE_3rd_Party__c || (ClaimHeader.ASI_TnE_Status__c=='Draft' && trigger_oldMap.get(ClaimHeader.id).ASI_TnE_Status__c!='Draft') || (ClaimHeader.ASI_TnE_Status__c!='Draft' && trigger_oldMap.get(ClaimHeader.id).ASI_TnE_Status__c=='Draft') || (ClaimHeader.ASI_TnE_Status__c!='Final' && trigger_oldMap.get(ClaimHeader.id).ASI_TnE_Status__c=='Final')||(ClaimHeader.ASI_TnE_Status__c=='Final' && trigger_oldMap.get(ClaimHeader.id).ASI_TnE_Status__c!='Final')|| ( ClaimHeader.ASI_TnE_Sync_to_JDE_Date__c != trigger_oldMap.get(ClaimHeader.id).ASI_TnE_Sync_to_JDE_Date__c)){
                        header_set.add(ClaimHeader.id);
                    }
                }
                
            }
        }
        //All Line list
        List<ASI_TnE_ClaimDetail__c> headerClaimDetail;
        set<id> po_set = new set<id>();
        List<ASI_TnE_ClaimDetail__c> ClaimDetail;
        //All Line Map
        Map<id,ASI_MFM_PO__c> POMap =new Map<id,ASI_MFM_PO__c>();
        
        //Update
        List<ASI_MFM_PO__c> POlist = new List<ASI_MFM_PO__c>(); 
        
        Map<String, ASI_MFM_Exchange_Rate__c> map_ExRate = new Map<String, ASI_MFM_Exchange_Rate__c>();
        List <ASI_MFM_Exchange_Rate__c> List_ExRate = [SELECT id, name, ASI_MFM_Base_Currency__c, ASI_MFM_Counter_Currency__c, ASI_MFM_Country__c, ASI_MFM_Exchange_Rate__c from ASI_MFM_Exchange_Rate__c where ASI_MFM_Base_Currency__c in ('USD', 'SGD') and ASI_MFM_Counter_Currency__c in ('SGD', 'USD') AND ASI_MFM_Effective_Date__c <= :System.today() and ASI_MFM_Country__c = 'SG' ORDER BY ASI_MFM_Effective_Date__c DESC];
        for (ASI_MFM_Exchange_Rate__c idx : List_ExRate) {
            if (!map_ExRate.containsKey(idx.ASI_MFM_Base_Currency__c+idx.ASI_MFM_Counter_Currency__c)) {
                map_ExRate.put(idx.ASI_MFM_Base_Currency__c+idx.ASI_MFM_Counter_Currency__c, idx);
            }
        }
        
        Double nExchangeRate = null;
        
        if(header_set.size()>0 && !ASI_MFM_Function.bypassTriggersFunctionCache('ASI_TnE_HK_ClaimHeaderUpdatePO')){
            headerClaimDetail= [select id,ASI_TnE_MFM_PO__c, ASI_TnE_HK_Payment_Amount__c from ASI_TnE_ClaimDetail__c where ASI_TnE_ClaimHeader__c in:  header_set ];
            
            for(ASI_TnE_ClaimDetail__c cd: headerClaimDetail){
                if(cd.ASI_TnE_MFM_PO__c!=null){
                    po_set.add(cd.ASI_TnE_MFM_PO__c);
                }
            }
            
            //Check all Claim Detail Line
            
            ClaimDetail= [
                SELECT Id, ASI_TnE_MFM_PO__c, 
                       ASI_TnE_HK_Payment_Amount__c,
                       ASI_TnE_MFM_PO__r.ASI_MFM_Sys_Local_Currency__c,
                       ASI_TnE_ClaimHeader__r.ASI_TnE_Export_to_AP_Voucher_GL__c,
                       ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c,
                       ASI_TnE_ClaimHeader__r.ASI_TnE_Sync_to_JDE_Date__c 
                FROM ASI_TnE_ClaimDetail__c
                WHERE ASI_TnE_MFM_PO__c IN :po_set 
                AND RecordType.DeveloperName= 'ASI_TnE_HK_Claim_Detail'
                //AND ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != 'Draft'
            ];
            
            for(ASI_TnE_ClaimDetail__c cd: ClaimDetail){
                if(cd.ASI_TnE_MFM_PO__c!=null){    
                    try {
                        nExchangeRate = map_ExRate.get(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Currency__c+cd.ASI_TnE_MFM_PO__r.ASI_MFM_Sys_Local_Currency__c).ASI_MFM_Exchange_Rate__c;
                        System.Debug('PO Exchange Rate := ' + nExchangeRate);
                    }catch(Exception e) {
                        nExchangeRate = 1;
                    }
                
                    if (nExchangeRate == null) {
                        nExchangeRate = 1;
                    }
                    
                    if(!POMap.containsKey(cd.ASI_TnE_MFM_PO__c)){    
                        ASI_MFM_PO__c po =new ASI_MFM_PO__c(id=cd.ASI_TnE_MFM_PO__c,ASI_MFM_T_E_Amount_Posted__c=0,ASI_MFM_T_E_Amount__c=0);
                        if(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == 'Final' && cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Sync_to_JDE_Date__c!=null){
                            po.ASI_MFM_T_E_Amount_Posted__c = cd.ASI_TnE_HK_Payment_Amount__c;
                        }
                        
                        if(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != 'Draft'){
                            //po.ASI_MFM_T_E_Amount__c = cd.ASI_TnE_HK_Payment_Amount__c;
                        
                            if (nExchangeRate != null) {
                                po.ASI_MFM_T_E_Amount__c = po.ASI_MFM_T_E_Amount__c + (cd.ASI_TnE_HK_Payment_Amount__c / nExchangeRate);
                            }else{
                                po.ASI_MFM_T_E_Amount__c += cd.ASI_TnE_HK_Payment_Amount__c;
                            }
                        }
                        
                        POMap.put(cd.ASI_TnE_MFM_PO__c, po);
                    }else{
                        if(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c == 'Final' && cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Sync_to_JDE_Date__c!=null){
                            POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount_Posted__c = POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount_Posted__c + cd.ASI_TnE_HK_Payment_Amount__c;
                        }
                        
                        if(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != 'Draft'){
                            if (nExchangeRate != null) {
                                POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount__c += (cd.ASI_TnE_HK_Payment_Amount__c / nExchangeRate);
                            }else{
                                POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount__c += cd.ASI_TnE_HK_Payment_Amount__c;
                            }
                        }
                    }
                }               
            }
            //system.assertEquals(null, POMap);
            
            /*string soql='select id,ASI_TnE_MFM_PO__c, ASI_TnE_HK_Payment_Amount__c,ASI_TnE_ClaimHeader__r.ASI_TnE_Export_to_AP_Voucher_GL__c from ASI_TnE_ClaimDetail__c where';
            for(string poname: po_set){
                if(poname!=null){
                     soql=soql+' ASI_TnE_MFM_PO__c =\''+poname+ '\' and ';
                }
            }
            soql+=' RecordType.DeveloperName= \'ASI_TnE_HK_Claim_Detail\'';
            soql+=' AND ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != \'Draft\'';
            ClaimDetail=Database.query(soql);
            */
            /*
            ClaimDetail= [SELECT Id,ASI_TnE_MFM_PO__c, 
                                 ASI_TnE_HK_Payment_Amount__c,
                                 ASI_TnE_ClaimHeader__r.ASI_TnE_Export_to_AP_Voucher_GL__c 
                          FROM ASI_TnE_ClaimDetail__c 
                          WHERE ASI_TnE_MFM_PO__c IN :po_set 
                          AND RecordType.DeveloperName = 'ASI_TnE_HK_Claim_Detail'
                          AND ASI_TnE_ClaimHeader__r.ASI_TnE_Status__c != 'Draft' 
            ];
            
            for(ASI_TnE_ClaimDetail__c cd: ClaimDetail){
                if(cd.ASI_TnE_MFM_PO__c!=null){
                    
                    if(!POMap.containsKey(cd.ASI_TnE_MFM_PO__c)){
                        
                        ASI_MFM_PO__c po =new ASI_MFM_PO__c(id=cd.ASI_TnE_MFM_PO__c,ASI_MFM_T_E_Amount_Posted__c=0);
                        if(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Export_to_AP_Voucher_GL__c){
                            po.ASI_MFM_T_E_Amount_Posted__c=cd.ASI_TnE_HK_Payment_Amount__c;
                        }
                        POMap.put(cd.ASI_TnE_MFM_PO__c, po);
                    }else{
                       // POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount__c=POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount__c+cd.ASI_TnE_HK_Payment_Amount__c;
                        if(cd.ASI_TnE_ClaimHeader__r.ASI_TnE_Export_to_AP_Voucher_GL__c){
                            POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount_Posted__c=POMap.get(cd.ASI_TnE_MFM_PO__c).ASI_MFM_T_E_Amount_Posted__c+cd.ASI_TnE_HK_Payment_Amount__c;
                        }
                    }
                }               
            }*/
            //Update PO
            for(ASI_MFM_PO__c po : POMap.values()){
                POlist.add(po);                                                  
            }
            if(POlist.size()>0){
                update POlist;
            }
        }
    }
}