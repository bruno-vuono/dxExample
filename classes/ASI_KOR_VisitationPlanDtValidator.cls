public without sharing class ASI_KOR_VisitationPlanDtValidator extends ASI_KOR_TriggerAbstract {

    private ASI_KOR_Visitation_Plan__c defaultPlan = [select id from ASI_KOR_Visitation_Plan__c where Name = 'Default Plan for Mobile App' limit 1];
    
    public ASI_KOR_VisitationPlanDtValidator() {
        super('ASI_KOR_VisitationPlanDtValidator');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        if (tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UPDATE || tAction == TriggerAction.AFTER_UNDELETE) {
            // Check whether validations are needed
            Boolean hasNewVisitDate = (tAction ==  TriggerAction.AFTER_UPDATE) ? false : true;
            List<ASI_KOR_Visitation_Plan_Detail__c> visitDetailList = (List<ASI_KOR_Visitation_Plan_Detail__c>)sObjList;
            if (tAction ==  TriggerAction.AFTER_UPDATE) {
                for (ASI_KOR_Visitation_Plan_Detail__c visitDetail : visitDetailList) {
                    ASI_KOR_Visitation_Plan_Detail__c oldVisitDetail = (ASI_KOR_Visitation_Plan_Detail__c)oldMap.get(visitDetail.Id);
                    if (visitDetail.ASI_KOR_Visit_Date__c != oldVisitDetail.ASI_KOR_Visit_Date__c) {
                        hasNewVisitDate = true;
                        break;
                    }
                }
            }
            
            if (hasNewVisitDate) {
                system.debug('Start After Trigger hasNewVisitDate');
                final String errMsgNotMatchHeaderDate = Label.ASI_KOR_TG_VPD_ERR_NotMatchHeaderDate;
                final String errMsgConflictDate = Label.ASI_KOR_TG_VPD_ERR_ConflictDate;
                Map<String, Integer> visitMonthStrToIntMap = ASI_KOR_VisitationPlanGenerator.getMonthPLValueToIntegerMap();
                // Get visitation headers
                Set<ID> visitHeaderIdSet = new Set<ID>();
                for (ASI_KOR_Visitation_Plan_Detail__c visitDetail : visitDetailList) visitHeaderIdSet.add(visitDetail.ASI_KOR_Visitation_Plan__c);
                Map<ID, ASI_KOR_Visitation_Plan__c> visitHeaderMap = new Map<ID, ASI_KOR_Visitation_Plan__c>(
                    [SELECT Id, ASI_KOR_Sys_Year__c, ASI_KOR_Month__c
                        , (SELECT Id, ASI_KOR_Wholesaler__c, ASI_KOR_Visit_Date__c FROM ASI_KOR_Visitation_Plan_Details__r)
                    FROM ASI_KOR_Visitation_Plan__c
                    WHERE Id IN: visitHeaderIdSet]


                );
                
                Set<ID> foundDuplicateVDetailIdSet = new Set<ID>();
                // Start validating visitation details
                for (ASI_KOR_Visitation_Plan_Detail__c visitDetail : visitDetailList) {
                    ASI_KOR_Visitation_Plan__c visitHeader = visitHeaderMap.get(visitDetail.ASI_KOR_Visitation_Plan__c);
                    Date visitDate = visitDetail.ASI_KOR_Visit_Date__c;
                    ID visitAcctId = visitDetail.ASI_KOR_Wholesaler__c;
                    
                    // Visit date must be matched to its header year and month
                    if (defaultPlan != null && visitDetail.ASI_KOR_Visitation_Plan__c != defaultPlan.id){
                        if (visitDate.year() != visitHeader.ASI_KOR_Sys_Year__c || visitDate.month() != visitMonthStrToIntMap.get(visitHeader.ASI_KOR_Month__c)) {
                            visitDetail.addError(errMsgNotMatchHeaderDate);
                            system.debug('Visit After update errMsgNotMatchHeaderDate');
                        }
                    }
                    
                    // Do not allow visitations having same date for same Account
                    List<ASI_KOR_Visitation_Plan_Detail__c> existingVisitDetails = visitHeader.ASI_KOR_Visitation_Plan_Details__r;
                    Set<ID> tempFoundVDetailIdSet = new Set<ID>();
                    for (ASI_KOR_Visitation_Plan_Detail__c existingVisitDetail : existingVisitDetails) {
                        if (existingVisitDetail.Id != visitDetail.Id && !foundDuplicateVDetailIdSet.contains(existingVisitDetail.Id)) {
                            if (existingVisitDetail.ASI_KOR_Visit_Date__c == visitDate && existingVisitDetail.ASI_KOR_Wholesaler__c == visitAcctId) {
                                //KR confirm not to check this
                                //visitDetail.addError(errMsgConflictDate);
                                tempFoundVDetailIdSet.add(visitDetail.Id);
                                ASI_KOR_Visitation_Plan_Detail__c triggerVisitDetail = (ASI_KOR_Visitation_Plan_Detail__c)newMap.get(existingVisitDetail.Id);
                                if (triggerVisitDetail != null) {
                                    //triggerVisitDetail.addError(errMsgConflictDate);
                                }
                                tempFoundVDetailIdSet.add(existingVisitDetail.Id);
                            }
                        }
                    }
                    foundDuplicateVDetailIdSet.addAll(tempFoundVDetailIdSet);
                }
                system.debug('End After Trigger hasNewVisitDate');
            }
        }
        else if (tAction == TriggerAction.BEFORE_INSERT ){
            
            system.debug('Start visit before insert');
            List<ASI_KOR_Visitation_Plan_Detail__c> visitDetailList = (List<ASI_KOR_Visitation_Plan_Detail__c>)sObjList;
            
            Map<Integer,String> monthMap = new Map<Integer,String>();
            monthMap.put(1,'January');
            monthMap.put(2,'February');
            monthMap.put(3,'March');
            monthMap.put(4,'April');
            monthMap.put(5,'May');
            monthMap.put(6,'June');
            monthMap.put(7,'July');
            monthMap.put(8,'August');
            monthMap.put(9,'September');
            monthMap.put(10,'October');
            monthMap.put(11,'November');
            monthMap.put(12,'December');
    
            
            if (defaultPlan != null){
                system.debug('default plan ID: ' + defaultPlan.id);
                for (ASI_KOR_Visitation_Plan_Detail__c visitDetail : visitDetailList) {
                    system.debug('start evaludate each visit detail. Visit Plan: ' + visitDetail.ASI_KOR_Visitation_Plan__c);
                    if (visitDetail.ASI_KOR_Visitation_Plan__c == defaultPlan.id && visitDetail.ASI_KOR_Visit_Date__c != null){
                        system.debug('New visit with default visitation plan ID');
                        //Visit created by api call from Mobile App, check for existing Visit Header or create a new one
                        String strMonth = monthMap.get(visitDetail.ASI_KOR_Visit_Date__c.month());
                        String strYear = String.valueOf(visitDetail.ASI_KOR_Visit_Date__c.year());
                        system.debug('Visit Month and Year: ' + strMonth + ' ' + strYear);
                        ID currentUserID = UserInfo.getUserId();
                        
                        visitDetail.recordTypeID = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan_Detail__cASI_CRM_KR_Visitation_Plan_Detail_Ad_Hoc');
                        
                        List<ASI_KOR_Visitation_Plan__c> planList = [select id from ASI_KOR_Visitation_Plan__c where ownerID = :currentUserID and ASI_KOR_Year__c = :strYear and ASI_KOR_Month__c = :strMonth limit 1];
                        system.debug('existing plan list size: ' +  planList.size());
                        if (planList.size() > 0){
                            visitDetail.ASI_KOR_Visitation_Plan__c = planList.get(0).id;
                            system.debug('existing plan found. ID: ' + planList.get(0).id);
                        }
                        else {
                            system.debug('no existing Plan matched, create new Plan instead');
                            ASI_KOR_Visitation_Plan__c newPlan = new ASI_KOR_Visitation_Plan__c();
                            newPlan.Name = UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' ' + strMonth + ' ' + strYear;
                            newPlan.ASI_KOR_Month__c = strMonth;
                            newPlan.ASI_KOR_Year__c = strYear;
                            newPlan.recordTypeID = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan__cASI_CRM_KR_Visitation_Plan');
                            
                            system.debug('newPlan: ' + newPlan);
                            
                            try {
                                insert newPlan;
                                system.debug('no existing plan, created new Plan: ' + newPlan.id);
                                visitDetail.ASI_KOR_Visitation_Plan__c = newPlan.id;
                            } 
                            catch (DmlException e){
                                System.debug('The following exception has occurred: ' + e.getMessage());
                            }
                            
                            
                        }
                    }
                }
            }
            system.debug('End visit before insert');
        }
        if (tAction == TriggerAction.BEFORE_UPDATE) {
            List<ASI_KOR_Visitation_Plan_Detail__c> visitDetailList = (List<ASI_KOR_Visitation_Plan_Detail__c>)sObjList;
            List<Profile> userProfile = [SELECT Id, Name FROM Profile WHERE Id=:userInfo.getProfileId() LIMIT 1];
            String currentUserProflieName = userProfile[0].Name;
                
            for (ASI_KOR_Visitation_Plan_Detail__c visitDetail : visitDetailList) {
                ASI_KOR_Visitation_Plan_Detail__c oldVisitDetail = (ASI_KOR_Visitation_Plan_Detail__c)oldMap.get(visitDetail.Id);
                
                //Wilken 20161018 If end user update visit station from Achieved into other status, then keep the old status and continue to save, avoid validation error blocking mobile app sync
                if (!currentUserProflieName.contains('Administrator') && oldVisitDetail.ASI_KOR_Status__c == 'Achieved' && visitDetail.ASI_KOR_Status__c != oldVisitDetail.ASI_KOR_Status__c)
                    visitDetail.ASI_KOR_Status__c = 'Achieved';
            }
        }
    }
}