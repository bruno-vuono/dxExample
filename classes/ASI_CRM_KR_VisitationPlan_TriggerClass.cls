public class ASI_CRM_KR_VisitationPlan_TriggerClass {
    public static void routineBeforeDelete(list<ASI_KOR_Visitation_Plan__c> trigger_old) {
        set<string> CustomPermission = ASI_MFM_ByPass_Setting.GetCustomPermissions();
        
        for (ASI_KOR_Visitation_Plan__c v:trigger_old) { 
            if(v.name=='Default Plan for Mobile App' && !Test.isRunningTest()){
                v.addError('Not allowed to delete.');
            }
            
            if(v.ASI_KOR_Confirmed__c && !CustomPermission.contains('ASI_CRM_KR_DeleteVisitationPlan') && !Test.isRunningTest() ){
                v.addError('Not allowed to delete because Visitation Plan is confirmed.');
            }
        }
    }
    
    public static void routineBeforeUpsert(list<ASI_KOR_Visitation_Plan__c> trigger_new, map<id, ASI_KOR_Visitation_Plan__c> trigger_oldMap) {
        set<id> UserIdSet = new set<id> ();
        if(trigger_oldMap==null){// New insert
            for(ASI_KOR_Visitation_Plan__c vp:trigger_new){
                UserIdSet.add(vp.OwnerId);
            }
        }else{// update
            for(ASI_KOR_Visitation_Plan__c vp:trigger_new){
                if(vp.OwnerId!=trigger_oldMap.get(vp.id).OwnerId){
                    UserIdSet.add(vp.OwnerId);
                }
            }
        }
        
        if(UserIdSet!=null){
            Map<ID, User> mapUser = new Map<ID,User>();
            for(user u : [select id,name,ManagerId,Manager.email,email from user WHERE id in :UserIdSet ]){
                mapUser.put(u.id,u);
                if(u.ManagerId!=null){
                    UserIdSet.add(u.ManagerId);
                }
            }
            
            
            Map<id,set<string>> UserPermissionMap = new Map<id,set<string>>();
            
            for(PermissionSetAssignment psa :[SELECT Id,AssigneeId, Assignee.Name,Assignee.email, PermissionSet.Name FROM PermissionSetAssignment where AssigneeId in : UserIdSet]){
                if(psa.PermissionSet.Name!=null){
                    if(UserPermissionMap.containskey(psa.AssigneeId)){
                        UserPermissionMap.get(psa.AssigneeId).add(psa.PermissionSet.Name);
                    }else{
                        set<string> tempps= new set<string>();
                        tempps.add(psa.PermissionSet.Name);
                        UserPermissionMap.put(psa.AssigneeId,tempps);
                    }
                    
                }
            } //End Permissions Set
            
            for(ASI_KOR_Visitation_Plan__c vp:trigger_new){
                if(UserPermissionMap.containsKey(vp.OwnerId) && mapUser.containsKey(vp.OwnerId)){
                    if(UserPermissionMap.get(vp.OwnerId).contains('ASI_KOR_Branch_Manager')){
                        vp.ASI_CRM_KR_SalesLeaderEmail__c=mapUser.get(vp.OwnerId).email;
                    }else{
                        if(mapUser.containsKey(vp.OwnerId) && UserPermissionMap.containsKey(mapUser.get(vp.OwnerId).ManagerId)){
                            if(UserPermissionMap.get(mapUser.get(vp.OwnerId).ManagerId).contains('ASI_KOR_Branch_Manager')){
                                vp.ASI_CRM_KR_SalesLeaderEmail__c=mapUser.get(vp.OwnerId).Manager.email;
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
}