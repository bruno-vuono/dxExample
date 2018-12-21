public with sharing class ASI_KOR_SalesOrderRequestDtLockSubmitted extends ASI_KOR_TriggerAbstract {
    
    public static Set<String> STATUS_SKIP_LOCK = new Set<String>{'New','Draft','Rejected'};
    public static Set<String> SKIP_PROFILE_NAMES = new Set<String>{
        'System Administrator'
        , 'ASI KOR System Administrator'
    };
    private Integer autoNum;
    
    public ASI_KOR_SalesOrderRequestDtLockSubmitted() {
        super('ASI_KOR_SalesOrderRequestDtLockSubmitted');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        if (tAction == TriggerAction.BEFORE_UPDATE || tAction == TriggerAction.BEFORE_INSERT
            || tAction == TriggerAction.BEFORE_DELETE) {
            List<ASI_KOR_Sales_Order_Transaction__c> soReqDetails = (List<ASI_KOR_Sales_Order_Transaction__c>)sObjList;
            
            Set<ID> soReqIdSet = new Set<ID>();
            for (ASI_KOR_Sales_Order_Transaction__c soReqDetail : soReqDetails) {
                soReqIdSet.add(soReqDetail.ASI_KOR_Sales_Order_Request__c);
            }
            Map<ID, ASI_KOR_Sales_Order_Request__c> soReqMap = new Map<ID, ASI_KOR_Sales_Order_Request__c>([SELECT Id, ASI_KOR_Order_Status__c FROM ASI_KOR_Sales_Order_Request__c WHERE Id IN :soReqIdSet]);
            
            ID userProfileId = UserInfo.getProfileId();
            Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id = :userProfileId];
            for (ASI_KOR_Sales_Order_Transaction__c soReqDetail : soReqDetails) {
                ASI_KOR_Sales_Order_Request__c soReq = soReqMap.get(soReqDetail.ASI_KOR_Sales_Order_Request__c);
                if (!STATUS_SKIP_LOCK.contains(soReq.ASI_KOR_Order_Status__c) && !SKIP_PROFILE_NAMES.contains(userProfile.Name)) {
                    soReqDetail.addError(Label.ASI_KOR_TG_SORD_ERR_LockedHeader);
                }
            }
        }
    }

}