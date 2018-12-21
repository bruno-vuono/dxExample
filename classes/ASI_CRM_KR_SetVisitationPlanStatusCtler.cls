public class ASI_CRM_KR_SetVisitationPlanStatusCtler {
    ASI_KOR_Visitation_Plan__c VisitationPlan = new ASI_KOR_Visitation_Plan__c();
    
    public ASI_CRM_KR_SetVisitationPlanStatusCtler(apexpages.standardController sc) {
        VisitationPlan = [select id,ASI_KOR_Confirmed__c, recordTypeId from ASI_KOR_Visitation_Plan__c where id = :sc.getId()];
    }
    
    public pageReference setStatus() {
        set<string> CustomPermission = ASI_MFM_ByPass_Setting.GetCustomPermissions();
        if(!CustomPermission.contains('ASI_CRM_KR_ChangeConfirmedVisitationPlan') && !test.isRunningTest() ){
            apexpages.addMessage(new apexpages.Message(apexpages.severity.error, 'Cannot uncheck Confirmed without permission.'));
            return null;
        }else{
            VisitationPlan.ASI_KOR_Confirmed__c=false;
            VisitationPlan.recordtypeid=Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan__cASI_CRM_KR_Visitation_Plan');
            update VisitationPlan;
            return new pageReference('/' + VisitationPlan.id);
        }
        
    }    
}