public class ASI_eForm_KR_DonationRequestTriggerClass {
    public static void routineBeforeUpsert(List<ASI_eForm_Donation_Request__c> triggerNew, Map<Id, ASI_eForm_Donation_Request__c> triggerOldMap) {
        Set<Id> OwnerIdSet = New Set<Id>();
        Map<String,ASI_MFM_Fix_Approval_Route__c>  FixApprovalRouteMap = new Map<String,ASI_MFM_Fix_Approval_Route__c>();  
        Map<Id,User> UserMap = new Map<Id,User>();
        
        for(ASI_eForm_Donation_Request__c obj : triggerNew){
            OwnerIdSet.add(obj.OwnerId);
        }
        if(OwnerIdSet.size()>0 ){
            Set<String> UserSalesTeamSet = new Set<String>();
            List<User> UserList= [select Id,Email,ASI_MFM_Team__c from User where Id in : OwnerIdSet and ASI_MFM_Team__c!=null ];
            for(User u : UserList){
                UserMap.put(u.Id,u);
                UserSalesTeamSet.add(u.ASI_MFM_Team__c); 
            }

            List<ASI_MFM_Fix_Approval_Route__c> FARList = new List<ASI_MFM_Fix_Approval_Route__c>([SELECT Id,ASI_MFM_Team__c, ASI_MFM_Corporate_Approver_1__c
                                                                                                   FROM ASI_MFM_Fix_Approval_Route__c 
                                                                                                   WHERE ASI_MFM_Team__c in :UserSalesTeamSet  and RecordType.DeveloperName LIKE 'ASI_MFM_KR_Fix_Approval_Route' 
                                                                                                   AND ASI_MFM_Module__c LIKE 'eForm' and ASI_MFM_KR_Grand_Category__c ='Donation' AND ASI_MFM_Inactive__c = false ]);
            
            for(ASI_MFM_Fix_Approval_Route__c FixApprovalRoute : FARList){
                FixApprovalRouteMap.put(FixApprovalRoute.ASI_MFM_Team__c,FixApprovalRoute);
            }
        }
        
        String handlerUserName = [select id,ASI_eForm_KR_Donation_Handler__c from  ASI_MFM_Setting__c ][0].ASI_eForm_KR_Donation_Handler__c;
        String delegatorId = [select id, delegatedApproverId from user where username = :handlerUserName limit 1][0].delegatedApproverId;
        
        for(ASI_eForm_Donation_Request__c obj : triggerNew){
            if(FixApprovalRouteMap.containsKey(UserMap.get(obj.OwnerId).ASI_MFM_Team__c) ){
                obj.ASI_eForm_Sys_Approver_1__c = FixApprovalRouteMap.get(UserMap.get(obj.OwnerId).ASI_MFM_Team__c).ASI_MFM_Corporate_Approver_1__c; 
            }
            if(delegatorId != null){
                obj.ASI_eForm_Sys_Approver_2__c = delegatorId;
            }
        }
        
        
    }
}