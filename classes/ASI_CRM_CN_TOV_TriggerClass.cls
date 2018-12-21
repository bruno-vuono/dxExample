public without sharing class ASI_CRM_CN_TOV_TriggerClass {
    
    public static void routineAfterUpdate (list<ASI_CRM_TOV__c> trigger_new, map<id, ASI_CRM_TOV__c> trigger_oldMap) {
        Set<id> FOC_Set = new Set<id>();
        for(ASI_CRM_TOV__c tov: trigger_new){
            if(tov.ASI_CRM_Free_Goods_Request__c != null){
                FOC_Set.add(tov.ASI_CRM_Free_Goods_Request__c);
            }
        }
        if(FOC_Set.size() > 0) {
            for (ASI_CRM_TOV__c tov : [select ASI_CRM_Free_Goods_Request__c, ASI_CRM_Free_Goods_Request__r.ASI_FOC_Delivery_Status__c , ASI_CRM_Status__c FROM ASI_CRM_TOV__c WHERE ASI_CRM_Free_Goods_Request__c IN : FOC_Set]){
                if(tov.ASI_CRM_Status__c != 'Received' || tov.ASI_CRM_Free_Goods_Request__r.ASI_FOC_Delivery_Status__c == 'Delivered'){
                    if (FOC_Set.contains(tov.ASI_CRM_Free_Goods_Request__c)){
                        FOC_Set.remove(tov.ASI_CRM_Free_Goods_Request__c);
                    }
                }
            }
            if (FOC_Set.size() > 0) {
                List<ASI_FOC_Free_Goods_Request__c> focList = [SELECT id FROM ASI_FOC_Free_Goods_Request__c WHERE id IN: FOC_Set];
                for (ASI_FOC_Free_Goods_Request__c foc :  focList){
                    foc.ASI_FOC_Delivery_Status__c = 'Delivered';
                }
                update focList;
            }
        }
        
    }
    Public Static void routineBeforeInsert(List<ASI_CRM_TOV__c> triggerNew){
        
        Set<String> soID = new Set<String>();
        
        for(ASI_CRM_TOV__c obj : triggerNew){
            if(obj.ASI_CRM_SF_SO_Request_Number__c != NULL)
                soID.add(obj.ASI_CRM_SF_SO_Request_Number__c);
        }
        
        Map<id, ASI_KOR_Sales_Order_Request__c> mapSO = new Map<id, ASI_KOR_Sales_Order_Request__c>([SELECT id, ownerID FROM ASI_KOR_Sales_Order_Request__c WHERE Id IN : soID]);
        
        for(ASI_CRM_TOV__c obj : triggerNew){
            if(obj.ASI_CRM_SF_SO_Request_Number__c != NULL)
                obj.ASI_CRM_SF_SO_Owner__c = mapSO.get(obj.ASI_CRM_SF_SO_Request_Number__c).ownerID;
        }
    }
}