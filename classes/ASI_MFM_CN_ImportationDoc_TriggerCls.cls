public without Sharing class ASI_MFM_CN_ImportationDoc_TriggerCls {

    Private Final Static Map<String, Schema.SObjectField> importationDoc_FIELD_MAP = Schema.SObjectType.ASI_MFM_Importation_Document__c.fields.getMap();
    Private Final Static Map<String, Schema.SObjectField> FixApproval_FIELD_MAP = Schema.SObjectType.ASI_CRM_Fix_Approval_Route__c.fields.getMap();
    
    Private Static Map<Id, ASI_CRM_Region__c> regionMap = new Map<Id, ASI_CRM_Region__c>([Select id, Name From ASI_CRM_Region__c Where recordType.developerName Like 'ASI_CRM_CN_Region']);
    
    Public Static void beforeInsertFunction(List<ASI_MFM_Importation_Document__c> triggerNew){
        
        Set<Id> ownerSet = new Set<Id>();
        Map<id, ASI_CRM_Sales_Team__c> ownerRegionMap = new Map<id, ASI_CRM_Sales_Team__c>();
        Map<String, ASI_CRM_Fix_Approval_Route__c> fixApprovalMap = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
        
        String whereClause = ' WHERE ASI_CRM_CN_Type__c Like \'Importation Document\' AND RecordType.developerName Like \'ASI_CRM_CN_%\'';
        
        for(ASI_CRM_Fix_Approval_Route__c obj : RetrieveFixApprovalInfo(FixApproval_FIELD_MAP, whereClause)){
            
            fixApprovalMap.put(obj.ASI_CRM_CN_Region_Area_Channel__c, obj);
        }
        
        for(ASI_MFM_Importation_Document__c obj : triggerNew){
            
            ownerSet.add(obj.ownerId);
        }
        
        ownerRegionMap = getUserRegion(ownerSet);
        
        for(ASI_MFM_Importation_Document__c obj : triggerNew){
            
            if(ownerRegionMap.containsKey(obj.ownerId)){
                
                obj.ASI_MFM_Region__c = ownerRegionMap.get(obj.OwnerId).ASI_CRM_Division__r.ASI_CRM_Region__c;
            }
            
            if(obj.ASI_MFM_Status__c == 'Draft' && obj.ASI_MFM_Region__c != Null && regionMap.containsKey(obj.ASI_MFM_Region__c) && fixApprovalMap.containsKey(regionMap.get(obj.ASI_MFM_Region__c).Name)){
                setApproverToNull(obj);
                setApprover(obj, fixApprovalMap.get(regionMap.get(obj.ASI_MFM_Region__c).Name));
            }
        }
    }
    
    Public Static void beforeUpdateFunction(List<ASI_MFM_Importation_Document__c> triggerNew, Map<Id, ASI_MFM_Importation_Document__c> triggerOldMap){
        
        Set<Id> ownerSet = new Set<Id>();
        Map<id, ASI_CRM_Sales_Team__c> ownerRegionMap = new Map<id, ASI_CRM_Sales_Team__c>();
        Map<String, ASI_CRM_Fix_Approval_Route__c> fixApprovalMap = new Map<String, ASI_CRM_Fix_Approval_Route__c>();
        
        String whereClause = ' WHERE ASI_CRM_CN_Type__c Like \'Importation Document\' AND RecordType.developerName Like \'ASI_CRM_CN_%\'';
        
        for(ASI_CRM_Fix_Approval_Route__c obj : RetrieveFixApprovalInfo(FixApproval_FIELD_MAP, whereClause)){
            
            fixApprovalMap.put(obj.ASI_CRM_CN_Region_Area_Channel__c, obj);
        }
        
        for(ASI_MFM_Importation_Document__c obj : triggerNew){
            
            if(triggerOldMap.get(obj.id).ownerId != obj.ownerId)
                ownerSet.add(obj.ownerId);
        }
        
        ownerRegionMap = getUserRegion(ownerSet);
        
        for(ASI_MFM_Importation_Document__c obj : triggerNew){
            
            if(ownerRegionMap.containsKey(obj.ownerId)){
                
                if(ownerSet.contains(obj.ownerId)){
                    obj.ASI_MFM_Region__c = ownerRegionMap.get(obj.OwnerId).ASI_CRM_Division__r.ASI_CRM_Region__c;
                }
            }
            
            if(obj.ASI_MFM_Status__c == 'Draft' && obj.ASI_MFM_Region__c != Null && regionMap.containsKey(obj.ASI_MFM_Region__c) && fixApprovalMap.containsKey(regionMap.get(obj.ASI_MFM_Region__c).Name)){
                setApproverToNull(obj);
                setApprover(obj, fixApprovalMap.get(regionMap.get(obj.ASI_MFM_Region__c).Name));
            }
            
            if(obj.ASI_MFM_Status__c == 'Submitted' && triggerOldMap.get(obj.id).ASI_MFM_Status__c == 'Draft' && (obj.ASI_MFM_Request_Purpose__c == Null || obj.ASI_MFM_Request_Purpose__c == '')){
                
                obj.ASI_MFM_Request_Purpose__c.addError('Please input Request Purpose before submission');
            }
        }
    }
    
    Public Static void setApprover(ASI_MFM_Importation_Document__c ImpDoc, ASI_CRM_Fix_Approval_Route__c fixApproval){
        
        Integer i = 1;
        Integer j = 1;
        String sysApprover = 'asi_mfm_sys_approver_' + i + '__c';
        String fixApprover = 'asi_crm_cn_approver_' + j + '__c';
        
        if(importationDoc_FIELD_MAP.containsKey(sysApprover)){
            
            user recordOwner = ASI_CRM_CN_RoleAndSubordinateHelperCLS.getUser(ImpDoc.OwnerId);
            
            if(recordOwner != Null){
                ImpDoc.put(sysApprover, recordOwner.ManagerId);
                
                i++;
                sysApprover = 'ASI_MFM_Sys_Approver_' + i + '__c';
            }
        }

        While(importationDoc_FIELD_MAP.containsKey(sysApprover) && FixApproval_FIELD_MAP.containsKey(fixApprover)){
            
            if(ImpDoc.get(sysApprover) != Null){
                
                i++;
                sysApprover = 'ASI_MFM_Sys_Approver_' + i + '__c';
                continue;
            }
            
            if(fixApproval.get(fixApprover) == Null){
                
                j++;
                fixApprover = 'ASI_CRM_CN_Approver_' + j + '__c';
                continue;
            }
            
            ImpDoc.put(sysApprover, fixApproval.get(fixApprover));
            
            i++;
            sysApprover = 'ASI_MFM_Sys_Approver_' + i + '__c';
            
            j++;
            fixApprover = 'ASI_CRM_CN_Approver_' + j + '__c';
        }
    }
    
    Public Static void setApproverToNull(ASI_MFM_Importation_Document__c ImpDoc){
        
        Integer i = 1;
        String sysApprover = 'ASI_MFM_Sys_Approver_' + i + '__c';
        
        While(importationDoc_FIELD_MAP.containsKey(sysApprover)){
            
            ImpDoc.put(sysApprover, null);
            
            i++;
            sysApprover = 'ASI_MFM_Sys_Approver_' + i + '__c';
        }
    }
    
    Public Static Map<id, ASI_CRM_Sales_Team__c> getUserRegion(Set<id> OwnerSet){
        
        Map<Id, ASI_CRM_Sales_Team__c> userRegionMap = new Map<Id, ASI_CRM_Sales_Team__c>();
        Map<String, String> userSalesTeam = new Map<String, String>();
        
        for(Id ownerid : OwnerSet){
            
            user obj = ASI_CRM_CN_RoleAndSubordinateHelperCLS.getUser(ownerid);
            
            if(obj != Null)
                userSalesTeam.put(obj.ASI_CRM_Sales_Team__c, obj.id);
        }
        
        for(ASI_CRM_Sales_Team__c obj : [SELECT id, Name, ASI_CRM_Division__r.ASI_CRM_Region__c, ASI_CRM_Division__r.ASI_CRM_Region__r.Name FROM ASI_CRM_Sales_Team__c WHERE Name IN : userSalesTeam.keySet()]){
            
            if(userSalesTeam.containsKey(obj.Name)){
                
                userRegionMap.put(userSalesTeam.get(obj.Name), obj);
            }
        }
        
        return userRegionMap;
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
}