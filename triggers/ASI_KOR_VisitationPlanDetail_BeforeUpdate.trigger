trigger ASI_KOR_VisitationPlanDetail_BeforeUpdate on ASI_KOR_Visitation_Plan_Detail__c (before update) {
    List<ASI_KOR_TriggerAbstract> triggerClasses = new List<ASI_KOR_TriggerAbstract> {
        new ASI_KOR_VisitationPlanDtValidator()
    };
  
    for (ASI_KOR_TriggerAbstract triggerClass : triggerClasses) {
        triggerClass.executeTriggerAction(ASI_KOR_TriggerAbstract.TriggerAction.BEFORE_UPDATE, trigger.new, trigger.newMap, trigger.oldMap);
    }
}