/*********************************************************************************
 * Name: ASI_CRM_VN_CusPopulateApprovers
 * Description: It is handler class for trigger 'ASI_CRM_AccountsAdditionalField_BeforeInsert'
 *              The method populateSysApproverFields() populates 3 fields Sys Approver 1, Sys Approver 2, Sys Approver 3 
 *              of Customer record
 *
 * Version History
 * Date                Developer             Comments
 * ---------------  --------------------  --------------------------------------------------------------------------------
 * 29/10/2015         Neha Sonawane         Created
 * 01/17/2018         Vincent Kwok          Updated, Revamp approval process to support new COA structure
 * 
*********************************************************************************/


public class  ASI_CRM_VN_CusPopulateApprovers{
     
    public void populateSysApproverFields(List<ASI_CRM_AccountsAdditionalField__c> lstCustomers){
        Set<String> RSD_APPROVAL_SERVICE_PACK = new Set<String>{'Iconic', 'Leading', 'Premium'};
        Set<String> NSD_APPROVAL_SERVICE_PACK = new Set<String>{'Iconic', 'Leading'};
        Set<String> OFF_TRADE_RECORD_DEVELOPER_NAME = new Set<String>{'ASI_CRM_VN_Off_Trade_Outlet', 'ASI_CRM_VN_Inactive_Off_Trade_Outlet'};
        Set<String> ON_TRADE_RECORD_DEVELOPER_NAME = new Set<String>{'ASI_CRM_VN_Outlet', 'ASI_CRM_VN_Outlet_Inactive'};
        
         //Logic to populate Sys Approver 1, Sys Approver 2, Sys Approver 3     
        set<Id> setOwnerId = new set<Id>();//set to store ownerId of Customer records
        Set<Id> setCustId = new Set<Id>();//set to store current customer Id
        
        //Added by Vincent@2018/01/17
        //Get all Vietnam Users
        map<Id,User> mapIdUserVN = new map<Id,User>([select Id, ManagerId, UserRoleId, Userrole.Name, Manager.Userrole.Name from User where UserRole.DeveloperName LIKE 'ASI_VN%']);
        map<Id,String> mapCustRecType = new map<Id,String>();
        
        //Populate set with Customer ownerId
        for(ASI_CRM_AccountsAdditionalField__c objCustomer : lstCustomers){
            setOwnerId.add(objCustomer.OwnerId);//Add Owner Id in set
            setCustId.add(objCustomer.Id);//Add Cust Id in Set
        }
        
        List<ASI_CRM_AccountsAdditionalField__c> listCust = [select Id, RecordType.DeveloperName from ASI_CRM_AccountsAdditionalField__c where Id IN :setCustId];
        for(ASI_CRM_AccountsAdditionalField__c idx : listCust) {
            mapCustRecType.put(idx.id, idx.RecordType.DeveloperName);
        }

        for(ASI_CRM_AccountsAdditionalField__c objCustomer : lstCustomers){
            //Clear Approver 1, Approver 2, Approver 3
            objCustomer.ASI_CRM_CN_Sys_Approver_1__c = null;
            objCustomer.ASI_CRM_CN_Sys_Approver_2__c = null;
            objCustomer.ASI_CRM_CN_Sys_Approver_3__c = null;
            if (mapIdUserVN != null && mapIdUserVN.containsKey(objCustomer.ownerId)) {
                if(!String.isBlank(String.valueOf(mapIdUserVN.get(objCustomer.ownerId).ManagerId))){ //Line Manager
                    String Approver1 = mapIdUserVN.get(objCustomer.ownerId).ManagerId;
                    objCustomer.ASI_CRM_CN_Sys_Approver_1__c = mapIdUserVN.get(objCustomer.ownerId).ManagerId;
                    //System.debug('Assigned Approver 1');               
                    if (mapIdUserVN != null && mapIdUserVN.containsKey(Approver1)) {                   
                        if(String.isNotBlank(Approver1) && ((mapIdUserVN.get(Approver1).Manager.Userrole.Name != Label.ASI_CRM_VN_RoleName && RSD_APPROVAL_SERVICE_PACK.contains(objCustomer.ASI_CRM_CN_New_Image__c) && ON_TRADE_RECORD_DEVELOPER_NAME.contains(mapCustRecType.get(objCustomer.Id))) || (mapIdUserVN.get(Approver1).Manager.Userrole.Name != Label.ASI_CRM_VN_RoleName && OFF_TRADE_RECORD_DEVELOPER_NAME.contains(mapCustRecType.get(objCustomer.Id))))){ //CDP > LM > RSD > NSD
                               String Approver2 = mapIdUserVN.get(Approver1).ManagerId;
                               objCustomer.ASI_CRM_CN_Sys_Approver_2__c = mapIdUserVN.get(Approver1).ManagerId;
                               //System.debug('Assigned Approver 2');
                               if (mapIdUserVN != null && mapIdUserVN.containsKey(Approver2)) {
                                   if(String.isNotBlank(Approver2) && ((mapIdUserVN.get(Approver2).Manager.Userrole.Name != Label.ASI_CRM_VN_RoleName && RSD_APPROVAL_SERVICE_PACK.contains(objCustomer.ASI_CRM_CN_New_Image__c) && ON_TRADE_RECORD_DEVELOPER_NAME.contains(mapCustRecType.get(objCustomer.Id))) || (mapIdUserVN.get(Approver2).Manager.Userrole.Name != Label.ASI_CRM_VN_RoleName && OFF_TRADE_RECORD_DEVELOPER_NAME.contains(mapCustRecType.get(objCustomer.Id))))){
                                          String Approver3 = mapIdUserVN.get(Approver2).ManagerId;
                                          objCustomer.ASI_CRM_CN_Sys_Approver_3__c = mapIdUserVN.get(Approver2).ManagerId;
                                          //System.debug('Assigned Approver 3. Exception Case');
                                    }else if (String.isNotBlank(Approver2) && ( mapIdUserVN.get(Approver2).Manager.Userrole.Name == Label.ASI_CRM_VN_RoleName && NSD_APPROVAL_SERVICE_PACK.contains(objCustomer.ASI_CRM_CN_New_Image__c) && ON_TRADE_RECORD_DEVELOPER_NAME.contains(mapCustRecType.get(objCustomer.Id)))) {
                                        objCustomer.ASI_CRM_CN_Sys_Approver_3__c = mapIdUserVN.get(Approver2).ManagerId;
                                        //System.debug('Assigned Approver 3.');
                                    }
                               }
                        }else if (String.isNotBlank(Approver1) && mapIdUserVN.get(Approver1).Manager.Userrole.Name == Label.ASI_CRM_VN_RoleName && NSD_APPROVAL_SERVICE_PACK.contains(objCustomer.ASI_CRM_CN_New_Image__c) && ON_TRADE_RECORD_DEVELOPER_NAME.contains(mapCustRecType.get(objCustomer.Id))){ //CDP > RSD > NSD
                            //System.debug('Assigned Approver 2');
                            objCustomer.ASI_CRM_CN_Sys_Approver_2__c = mapIdUserVN.get(Approver1).ManagerId;
                        }
                    }
                }
            }
		}
	}
}
/* 				//Vincent Kwok@20180117 Disabled original code to support the new COA structure
                //Populate map with User Id and User instance
                map<Id,User> mapIdUser = new map<Id,User>([select Id, ManagerId, UserRoleId, Userrole.Name from User where Id IN : setOwnerId]);
                System.debug(' ---- mapIdUser ----' + mapIdUser);
                
                //Add Sys approver1's Id in set setOwnerId
                for(ASI_CRM_AccountsAdditionalField__c objCustomer : lstCustomers){
                   if(!String.isBlank(String.valueOf(mapIdUser.get(objCustomer.ownerId).ManagerId))){
                    objCustomer.ASI_CRM_CN_Sys_Approver_1__c = mapIdUser.get(objCustomer.ownerId).ManagerId;
                    setOwnerId.add(objCustomer.ASI_CRM_CN_Sys_Approver_1__c);
                   } 
                }
                
                mapIdUser = new map<Id,User>([select Id, ManagerId, UserRoleId, Userrole.Name, Manager.Userrole.Name from User where Id IN : setOwnerId]);
                //Add Sys approver2's Id in set setOwnerId
                System.debug(' ---- mapIdUser 1 ----' + mapIdUser);
                for(ASI_CRM_AccountsAdditionalField__c objCustomer : lstCustomers){
                    System.debug(' ---- ManagerId ---- ' + mapIdUser.get(objCustomer.ownerId).ManagerId);
                    if(!String.isBlank(String.valueOf(mapIdUser.get(objCustomer.ownerId).ManagerId))){
                    objCustomer.ASI_CRM_CN_Sys_Approver_1__c = mapIdUser.get(objCustomer.ownerId).ManagerId;
                    setOwnerId.add(objCustomer.ASI_CRM_CN_Sys_Approver_1__c);
                    
                    system.debug(mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_1__c)+'------------wow--------------'+mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_1__c).Userrole.Name);
                    if(mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_1__c).Userrole.Name != Label.ASI_CRM_VN_RoleName){
                        objCustomer.ASI_CRM_CN_Sys_Approver_2__c = mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_1__c).ManagerId;
                        setOwnerId.add(objCustomer.ASI_CRM_CN_Sys_Approver_2__c);
                    }
                    }
                    
                }
                
                mapIdUser = new map<Id,User>([select Id, ManagerId, UserRoleId, Userrole.Name, Manager.Userrole.Name from User where Id IN : setOwnerId]);
                //Populate Sys Approver 1, Sys Approver 2, Sys Approver 3 with correct information
                for(ASI_CRM_AccountsAdditionalField__c objCustomer : lstCustomers){
                    if(!String.isBlank(String.valueOf(mapIdUser.get(objCustomer.ownerId).ManagerId))){
                        objCustomer.ASI_CRM_CN_Sys_Approver_1__c = mapIdUser.get(objCustomer.ownerId).ManagerId;
                        //Check if Sys Approver 1 has role other than ''
                        if(String.isNotBlank(objCustomer.ASI_CRM_CN_Sys_Approver_1__c) // DC - 02/12/2016 - Added null check if User's manager is empty
                        && mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_1__c).Userrole.Name != Label.ASI_CRM_VN_RoleName){
                            objCustomer.ASI_CRM_CN_Sys_Approver_2__c = mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_1__c).ManagerId;
                            // //Check if Sys Approver 2 has role other than ''
                            if(String.isNotBlank(objCustomer.ASI_CRM_CN_Sys_Approver_2__c) // DC - 02/12/2016 - Added null check if User's manager's manager is empty
                            && mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_2__c).Userrole.Name != Label.ASI_CRM_VN_RoleName){
                                objCustomer.ASI_CRM_CN_Sys_Approver_3__c = mapIdUser.get(objCustomer.ASI_CRM_CN_Sys_Approver_2__c).ManagerId;                    
                            }
                        }
                    }  
                }
*/