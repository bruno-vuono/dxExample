public class ASI_CN_NPL_RequestTriggerAbstract {
    
    //20170814 Introv
    Private Final Static Map<String, Schema.SObjectField> npl_FIELD_MAP = Schema.SObjectType.ASI_CN_NPL_NPL_Request__c.fields.getMap();
    Private Final Static Map<String, Schema.SObjectField> FixApproval_FIELD_MAP = Schema.SObjectType.ASI_CRM_Fix_Approval_Route__c.fields.getMap();
    //20170814 End
    
    private List<Id> nplIDs = new List<Id>();   
    public ASI_CN_NPL_RequestTriggerAbstract(){                
    }
     
    public void executeAfterInsertTriggerAction(ASI_CN_NPL_NPL_Request__c[] npls){
        //Create NPL Forecast Childs for VisualForce page
        createNPLForecastChilds(npls);
    }

    public static void executeBeforeInsertTriggerAction(List<ASI_CN_NPL_NPL_Request__c> trigger_new, map<id, ASI_CN_NPL_NPL_Request__c> trigger_oldMap){
//Set Classification for display
        for (ASI_CN_NPL_NPL_Request__c npl : trigger_new){
            npl.ASI_CN_NPL_Classification_Text__c = Global_RecordTypeCache.getRt(npl.RecordTypeID).Name;
        }
    }
    
    public static void executeAfterUpdateTriggerAction(List<ASI_CN_NPL_NPL_Request__c> trigger_new, map<id, ASI_CN_NPL_NPL_Request__c> trigger_oldMap){
        List<ASI_CN_NPL_NPL_Request__c> nplUpdateList = new List<ASI_CN_NPL_NPL_Request__c>();
        
        for (ASI_CN_NPL_NPL_Request__c npl : trigger_new){
            System.debug('Class: ' + npl.ASI_CN_NPL_Classification__c + ' Status: ' + npl.ASI_CN_NPL_Status__c);
                    
            if (npl.ASI_CN_NPL_Status__c == 'Pre-Approved' && trigger_oldMap.get(npl.id).ASI_CN_NPL_Status__c != 'Pre-Approved'){
                //Check if there are already Item Master record created
                List<ASI_CN_NPL_Item_Master__c> imList = [select id from ASI_CN_NPL_Item_Master__c where ASI_CN_NPL_NPL_Reference_No__c = :npl.id];
                
                
                if (imList.size() == 0){
                    string productName;
                    if (npl.ASI_CN_NPL_Product_Name_English__c != null){
                        if (npl.ASI_CN_NPL_Product_Name_English__c.length() > 30)
                            productName = npl.ASI_CN_NPL_Product_Name_English__c.substring(0, 30);
                        else 
                            productName = npl.ASI_CN_NPL_Product_Name_English__c;
                    }
                    ASI_CN_NPL_Item_Master__c im = new ASI_CN_NPL_Item_Master__c(ASI_CN_NPL_Item_Description_GE__c = productName, 
                        RecordTypeID = Global_RecordTypeCache.getRtId('ASI_CN_NPL_Item_Master__cASI_CN_NPL_Item_Master_TypeA'), ASI_CN_NPL_Item_Description_CH__c = npl.ASI_CN_NPL_Product_Name_Chinese__c, 
                            ASI_CN_NPL_NPL_Reference_No__c = npl.id, ASI_CN_NPL_Status__c = 'Waiting For Logistics Input Item Code', ASI_CN_NPL_VAP__c = npl.ASI_CN_NPL_VAP__c);
                    
                    List<Group> gList = [Select ID From Group where DeveloperName = 'ASI_CN_NPL_Item_Master_Logistics_User'];
                    
                    if (gList.size() == 1){
                        List<GroupMember> gmList = [select UserOrGroupId from GroupMember where GroupId = :gList.get(0).id];
                        
                        if (gmList.size() == 0)
                            im.ownerID = UserInfo.getUserId();
                        else 
                            im.ownerID = gmList.get(0).UserOrGroupId;
                    }
                    
                    System.debug('Item Master: ' + im);
                    insert im;
                    
                    ASI_CN_NPL_NPL_Request__c nplUpdate = [select ASI_CN_NPL_Item_Master__c from ASI_CN_NPL_NPL_Request__c where id = :npl.id];
                    nplUpdate.ASI_CN_NPL_Item_Master__c = im.id;
                    
                    nplUpdateList.add(nplUpdate);
                }
            }
        }
        
        update nplUpdateList;
    }
    
    public static void executeBeforeUpdateTriggerAction(List<ASI_CN_NPL_NPL_Request__c> trigger_new, map<id, ASI_CN_NPL_NPL_Request__c> trigger_oldMap){
//setDefaultApprover
		
        //20170814 Introv
        List<ASI_CN_NPL_NPL_Request__c> FinalApprovedNPL = new List<ASI_CN_NPL_NPL_Request__c>();
        
        for (ASI_CN_NPL_NPL_Request__c npl : trigger_new){
            System.debug('Start setDefaultApprover');
            //Assign if all 5 director's lookup field is empty or before final approval // 20170921 remove trade marketing director, Introv
            if ((npl.ASI_CN_NPL_National_Sales_Dev_VP__c == null && /*npl.ASI_CN_NPL_Trade_Marketing_Director__c == null &&*/ npl.ASI_CN_NPL_Finance_Director__c == null && npl.ASI_CN_NPL_Marketing_Director__c == null &&
                npl.ASI_CN_NPL_Deputy_Managing_Director__c == null && npl.ASI_CN_NPL_Brand_Director__c == null) 
                    || (npl.ASI_CN_NPL_Status__c == 'Waiting for S&OP Alignment' && npl.ASI_CN_NPL_National_Sales_Dev_VP__c != null && /*npl.ASI_CN_NPL_Trade_Marketing_Director__c != null &&*/ npl.ASI_CN_NPL_Marketing_Director__c != null && npl.ASI_CN_NPL_Deputy_Managing_Director__c != null && npl.ASI_CN_NPL_Brand_Director__c != null)){         //***
                
                System.debug('Assign Approvers');
                
                //Assign Directors base on Role
                //npl.ASI_CN_NPL_Trade_Marketing_Director__c = getPublicGroupUserIDByGroupName('ASI CN NPL Trade Marketing Director'); //20161013 Ben @ Elufa Commented
                npl.ASI_CN_NPL_Marketing_Director__c = getPublicGroupUserIDByGroupName('ASI CN NPL Marketing Director');
                npl.ASI_CN_NPL_Deputy_Managing_Director__c = getPublicGroupUserIDByGroupName('ASI CN NPL Deputy Managing Director');
                npl.ASI_CN_NPL_National_Sales_Dev_VP__c = getPublicGroupUserIDByGroupName('ASI CN NPL National Sales Dev VP');
                
                //Assign Brand Director from Public Group base on NPL Category
                System.debug('Start assign Brand Director: Current User Id: ' + UserInfo.getUserId() + ' NPL Owner: ' + npl.OwnerID);
                if(npl.ASI_CN_NPL_Request_By__c != null){
                    npl.ASI_CN_NPL_Brand_Director__c = getBrandDirectorIdFromOwnerId(npl.ASI_CN_NPL_Request_By__c);
                }
                else if (npl.OwnerID == null){
                    System.debug('Owner ID is null, UserInfo.getUserId(): ' + UserInfo.getUserId());
                    npl.ASI_CN_NPL_Brand_Director__c = getBrandDirectorIdFromOwnerId(UserInfo.getUserId());
                }
                else {
                    System.debug('Owner ID is not null, npl.OwnerID: ' + npl.OwnerID);
                    npl.ASI_CN_NPL_Brand_Director__c = getBrandDirectorIdFromOwnerId(npl.OwnerID);
                }
                
                //Only assign FD for Final Approval
                if (npl.ASI_CN_NPL_Status__c == 'Waiting for S&OP Alignment'){                  //***
                    npl.ASI_CN_NPL_Finance_Director__c = getPublicGroupUserIDByGroupName('ASI CN NPL Finance Director');
                }
                System.debug('End assign Brand Director');
            }
            System.debug('End setDefaultApprover');
            
            //201708014 Introv
            if(npl.ASI_CN_NPL_Status__c == 'Final Approved'){
                FinalApprovedNPL.add(npl);
            }
            
            //Clear all approver fields before assign
            /*npl.ASI_CN_NPL_Approver1__c = null;
            npl.ASI_CN_NPL_Approver2__c = null;
            npl.ASI_CN_NPL_Approver3__c = null;
            npl.ASI_CN_NPL_Approver4__c = null;
            npl.ASI_CN_NPL_Approver5__c = null;
            npl.ASI_CN_NPL_Approver6__c = null;
            
            if (npl.ASI_CN_NPL_Brand_Director__c != null){
                System.debug('Assign BD to approver');
                fillFirstEmptyApproverLookup(npl.ASI_CN_NPL_Brand_Director__c, npl);
            }

            if (npl.ASI_CN_NPL_Marketing_Director__c != null){
                System.debug('Assign MKTD to approver');
                fillFirstEmptyApproverLookup(npl.ASI_CN_NPL_Marketing_Director__c, npl);
            }
            
            if (npl.ASI_CN_NPL_Trade_Marketing_Director__c != null){
                System.debug('Assign TMKTD to approver');
                fillFirstEmptyApproverLookup(npl.ASI_CN_NPL_Trade_Marketing_Director__c, npl);
            }
                        
            if (npl.ASI_CN_NPL_National_Sales_Dev_VP__c != null){
                System.debug('Assign DMD to approver');
                fillFirstEmptyApproverLookup(npl.ASI_CN_NPL_National_Sales_Dev_VP__c, npl);
            }
            
            if (npl.ASI_CN_NPL_Deputy_Managing_Director__c != null){
                System.debug('Assign DMD to approver');
                fillFirstEmptyApproverLookup(npl.ASI_CN_NPL_Deputy_Managing_Director__c, npl);
            }
            
            if (npl.ASI_CN_NPL_Finance_Director__c != null){
                System.debug('Assign FD to approver');
                fillFirstEmptyApproverLookup(npl.ASI_CN_NPL_Finance_Director__c, npl);
            }          
            System.debug('End assignHiddenApproverForProcess');          
            */


            Set<ID> subordinateID = new Set<ID>();
            
            List<User> requestByRoleName = [Select UserRole.DeveloperName from user where id =:npl.ASI_CN_NPL_Request_By__c];
            
            if(requestByRoleName.size() > 0){
                if (requestByRoleName.get(0).UserRole.DeveloperName.contains('Logistic')){
                    ID logisticDirector = [select id from userrole where developername='ASI_FOC_Logistic_Director' limit 1][0].ID;
                    subordinateID = getRoleSubordinateUsers(logisticDirector,false);
                }
                else if (npl.ASI_CN_NPL_Brand_Director__c != null){
                    subordinateID = getRoleSubordinateUsers(npl.ASI_CN_NPL_Brand_Director__c,true);
                }
            }
            else if (npl.ASI_CN_NPL_Brand_Director__c != null){
                subordinateID = getRoleSubordinateUsers(npl.ASI_CN_NPL_Brand_Director__c,true);
            }
                
            if(subordinateID != null && subordinateID.size()>0){
                System.debug('Subordinate ID Set: ' + subordinateID);
                List<User> subordinateUsers = [Select Id, Email From User Where Id = :subordinateID AND isActive = TRUE];//20160427 Ben @ Elufa Added isActive = TRUE
                
                if (subordinateUsers.size() > 0){
                    npl.ASI_CN_NPL_Email1__c = null;
                    npl.ASI_CN_NPL_Email2__c = null;
                    npl.ASI_CN_NPL_Email3__c = null;
                    npl.ASI_CN_NPL_Email4__c = null;
                    npl.ASI_CN_NPL_Email5__c = null;
                    npl.ASI_CN_NPL_Email6__c = null;
                    npl.ASI_CN_NPL_Email7__c = null;
                    npl.ASI_CN_NPL_Email8__c = null;
                    npl.ASI_CN_NPL_Email9__c = null;
                    npl.ASI_CN_NPL_Email10__c = null;
                    npl.ASI_CN_NPL_Email11__c = null;
                    npl.ASI_CN_NPL_Email12__c = null;
                    npl.ASI_CN_NPL_Email13__c = null;
                    npl.ASI_CN_NPL_Email14__c = null;
                    npl.ASI_CN_NPL_Email15__c = null;
                    npl.ASI_CN_NPL_Email16__c = null;
                    npl.ASI_CN_NPL_Email17__c = null;
                    npl.ASI_CN_NPL_Email18__c = null;
                    npl.ASI_CN_NPL_Email19__c = null;
                    npl.ASI_CN_NPL_Email20__c = null;
                }
                
                for (User u : subordinateUsers){
                    System.debug('Email: ' + u.Email);
                    
                    if (npl.ASI_CN_NPL_Email1__c == null)
                        npl.ASI_CN_NPL_Email1__c = u.Email;
                        
                    else if (npl.ASI_CN_NPL_Email2__c == null)
                        npl.ASI_CN_NPL_Email2__c = u.Email;
                        
                    else if (npl.ASI_CN_NPL_Email3__c == null)
                        npl.ASI_CN_NPL_Email3__c = u.Email;
                    
                    else if (npl.ASI_CN_NPL_Email4__c == null)
                        npl.ASI_CN_NPL_Email4__c = u.Email;
                        
                    else if (npl.ASI_CN_NPL_Email5__c == null)
                        npl.ASI_CN_NPL_Email5__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email6__c == null)
                        npl.ASI_CN_NPL_Email6__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email7__c == null)
                        npl.ASI_CN_NPL_Email7__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email8__c == null)
                        npl.ASI_CN_NPL_Email8__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email9__c == null)
                        npl.ASI_CN_NPL_Email9__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email10__c == null)
                        npl.ASI_CN_NPL_Email10__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email11__c == null)
                        npl.ASI_CN_NPL_Email11__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email12__c == null)
                        npl.ASI_CN_NPL_Email12__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email13__c == null)
                        npl.ASI_CN_NPL_Email13__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email14__c == null)
                        npl.ASI_CN_NPL_Email14__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email15__c == null)
                        npl.ASI_CN_NPL_Email15__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email16__c == null)
                        npl.ASI_CN_NPL_Email16__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email7__c == null)
                        npl.ASI_CN_NPL_Email17__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email18__c == null)
                        npl.ASI_CN_NPL_Email18__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email19__c == null)
                        npl.ASI_CN_NPL_Email19__c = u.Email;
                                                
                    else if (npl.ASI_CN_NPL_Email20__c == null)
                        npl.ASI_CN_NPL_Email20__c = u.Email;
                }
            }
//Validate Category with IsBrandNewProduct flag
            if (npl.ASI_CN_NPL_Category__c == 'N/A'){
                npl.ASI_CN_NPL_Is_Brand_New_Product__c = true;
            }
            else {
                npl.ASI_CN_NPL_Is_Brand_New_Product__c = false;
            }
        }
        
        //201708014 Introv
        if(FinalApprovedNPL.size() > 0){
            
            Map<String, ASI_CRM_Fix_Approval_Route__c> fixApprovalMap = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
            String whereClause = ' WHERE ASI_CRM_CN_Type__c Like \'New Product Launch%\' AND RecordType.developerName Like \'ASI_CRM_CN_%\'';
            
            for(ASI_CRM_Fix_Approval_Route__c obj : RetrieveFixApprovalInfo(FixApproval_FIELD_MAP, whereClause)){
                
                fixApprovalMap.put(obj.ASI_CRM_CN_Type__c, obj);
            }
            
            for(ASI_CN_NPL_NPL_Request__c npl : FinalApprovedNPL){
                
                if(fixApprovalMap.containsKey('New Product Launch - TP Approval')){
                    setApproverToNull(npl);
                    setApprover(npl, fixApprovalMap.get('New Product Launch - TP Approval'));
                }
            }
        }
        //201708014 End
    }
    
    private void createNPLForecastChilds(ASI_CN_NPL_NPL_Request__c[] npls){
        //List<Id> nplIDs = new List<Id>();
        List<String> forecastTypes = new List<String>{'Sales Volume','Old Stock Inventory','Old Stock Depletion','Monitoring'}; 
        List<String> forecastRegions = new List<String>{'South','East','Central','North','North West', 'South West', 'Macau', 'Mongolia','STK3','HQ'};
        List<ASI_CN_NPL_NPL_Forecast__c> forecasts = new List<ASI_CN_NPL_NPL_Forecast__c>();
        
        System.debug('List Size of NPLs:' + npls.size());
        
        for (ASI_CN_NPL_NPL_Request__c npl : npls){
            for (String forecastType : forecastTypes){
                for (String forecastRegion : forecastRegions){
                    ASI_CN_NPL_NPL_Forecast__c forecast = new ASI_CN_NPL_NPL_Forecast__c(New_Product_Launch_Request__c = npl.Id, ASI_CN_NPL_Type__c = forecastType, ASI_CN_NPL_Region__c = forecastRegion);
                    forecasts.add(forecast);
                    nplIDs.add(npl.Id);
                }
            }
        }       
        insert forecasts;
    }
    
    private static Set<ID> getRoleSubordinateUsers(Id userId,boolean userFlag) {
        // get requested user's role
        Id roleId =NULL;
        if(userFlag)
            roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
        else
            roleId = userId;
             
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where 
          UserRoleId IN :allSubRoleIds]);
        
        //Modified by Wilken on 20130911, add Brand Director for notification
        if(userFlag){
            User approver = [select Id, Name from User where Id = :userId];
            users.put(approver.Id, approver);
        }
        //End modification on 20130911
        
        // return the ids as a set so you can do what you want with them
        return users.keySet();
     
    }
 
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();
     
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
          IN :roleIds AND ParentRoleID != null])
        currentRoleIds.add(userRole.Id);
     
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0)
          currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
     
        return currentRoleIds;
     
    }
    
    
    /*private static void fillFirstEmptyApproverLookup(Id approver, ASI_CN_NPL_NPL_Request__c npl){
        if (npl.ASI_CN_NPL_Approver1__c == null)
            npl.ASI_CN_NPL_Approver1__c = approver;
            
        else if (npl.ASI_CN_NPL_Approver2__c == null)
            npl.ASI_CN_NPL_Approver2__c = approver;
            
        else if (npl.ASI_CN_NPL_Approver3__c == null)
            npl.ASI_CN_NPL_Approver3__c = approver;
            
        else if (npl.ASI_CN_NPL_Approver4__c == null)
            npl.ASI_CN_NPL_Approver4__c = approver;
            
        else if (npl.ASI_CN_NPL_Approver5__c == null)
            npl.ASI_CN_NPL_Approver5__c = approver;
            
        else if (npl.ASI_CN_NPL_Approver6__c == null)
            npl.ASI_CN_NPL_Approver6__c = approver;
    }*/
    
    private static Id getPublicGroupUserIDByGroupName(String name){
        String userType = Schema.SObjectType.User.getKeyPrefix();
        List<Group> publicGroup = [Select Id From Group Where Name = :name Limit 1];
        if(publicGroup.size() > 0){
            List<GroupMember> member = [Select UserOrGroupId From GroupMember Where GroupId = :publicGroup[0].Id Limit 1];
            
            if(member.size() > 0){
                if (((String)member[0].UserOrGroupId).startsWith(userType)){
                    return member[0].UserOrGroupId;
                }
                else {
                    return null;
                }
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
    
    private static Id getSupervisorID(Id ownerId){
        if(ownerId==null)
            return null;
            
        System.debug('start getSupervisorID, ownerID: ' + ownerId);
        User u = [Select UserRoleId From User Where Id = :ownerId Limit 1];
        List<UserRole> ur = [Select ParentRoleId From UserRole Where Id = :u.UserRoleId];
        ID result;
        
        if (ur.size() == 1){
            List<User> su = [Select Id From User Where UserRoleId = :ur.get(0).ParentRoleId];
            
            if (su.size() >= 1){
                result = su.get(0).Id;
            }
            else if(su.size() == 0){//20151224 Ben @ Elufa System
                
                List<UserRole> ur2 = [Select ParentRoleId From UserRole Where Id = :ur.get(0).ParentRoleId];
                if(ur2.size() > 0){
                    List<User> su2 = [Select Id From User Where UserRoleId = :ur2.get(0).ParentRoleId];
                    if(su2.size() > 0)
                        result = su2.get(0).id;
                }
            }//20151224 End
        }
        
        System.debug('end getSupervisorID, return supervisor ID: ' + result);
        return result;
    }
   
    private static Id getBrandDirectorIdFromOwnerId(Id ownerId){
        String userType = Schema.SObjectType.User.getKeyPrefix();
        List<User> nplOwner = [Select Id, ManagerId From User Where Id = :ownerId];
        Group approverGroup = [Select Id From Group Where DeveloperName = 'ASI_CN_NPL_Brand_Director_Approvers'];
        Boolean result = false;
        Id brandDirectorId;
        Id supervisorID = getSupervisorID(ownerId);

        if (nplOwner.size() == 1){
            for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :approverGroup.Id]){
                if (((String)m.UserOrGroupId).startsWith(userType)){
                    if (m.UserOrGroupId == supervisorID){
                        System.debug('getBrandDirectorIdFromOwnerId m.UserOrGroupId: ' + m.UserOrGroupId + ' supervisorID: ' + supervisorID);
                        result = true;
                        brandDirectorId = supervisorID;
                    }
                }
            }
            
            if (result == false){
                System.debug('getBrandDirectorIdFromOwnerId Result = false');
                brandDirectorId = getBrandDirectorIdFromOwnerId(supervisorID);
            }
        }
        
        return brandDirectorId;
    }
    
    //20170814 Introv
    
    Private Static void setApprover(ASI_CN_NPL_NPL_Request__c npl, ASI_CRM_Fix_Approval_Route__c fixApproval){
        
        Integer i = 1;
        Integer j = 1;
        String sysApprover = 'ASI_CN_NPL_Approver' + i + '__c';
        String fixApprover = 'asi_crm_cn_approver_' + j + '__c';
        
        While(npl_FIELD_MAP.containsKey(sysApprover) && FixApproval_FIELD_MAP.containsKey(fixApprover)){
            
            if(npl.get(sysApprover) != Null){
                
                i++;
                sysApprover = 'ASI_CN_NPL_Approver' + i + '__c';
                continue;
            }
            
            if(fixApproval.get(fixApprover) == Null){
                
                j++;
                fixApprover = 'ASI_CRM_CN_Approver_' + j + '__c';
                continue;
            }
            
            npl.put(sysApprover, fixApproval.get(fixApprover));
            
            i++;
            sysApprover = 'ASI_CN_NPL_Approver' + i + '__c';
            
            j++;
            fixApprover = 'ASI_CRM_CN_Approver_' + j + '__c';
        }
    }
    
    Private Static void setApproverToNull(ASI_CN_NPL_NPL_Request__c npl){
        
        Integer i = 1;
        String sysApprover = 'ASI_CN_NPL_Approver' + i + '__c';
        
        While(npl_FIELD_MAP.containsKey(sysApprover)){
            
            npl.put(sysApprover, null);
            
            i++;
            sysApprover = 'ASI_CN_NPL_Approver' + i + '__c';
        }
    }
    
    Private Static List<ASI_CRM_Fix_Approval_Route__c> RetrieveFixApprovalInfo(Map<String, Schema.SObjectField> fieldMap, String whereClause) {
        
        String query = 'SELECT ' + genQueryField(fieldMap) + ' FROM ASI_CRM_Fix_Approval_Route__c ' + whereClause;
        
        List<ASI_CRM_Fix_Approval_Route__c> fixApprovalList = (List<ASI_CRM_Fix_Approval_Route__c>) Database.query(query);
        return fixApprovalList.size() > 0 ? fixApprovalList : new List<ASI_CRM_Fix_Approval_Route__c>();
    }
    
    Private Static String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
        String queryField = '';
        for(String fields : fieldMap.keySet()) {
            queryField += fields + ',';
        }
        return queryField.subString(0, queryField.length() - 1);
    }
    //20170814 End
}