public with sharing class ASI_DFPM_ProjectAndChildDeleteController {

    public ID pjId { get; private set; }
    
    public ASI_DFPM_ProjectAndChildDeleteController(ApexPages.StandardController stdController) {
        this.pjId = stdController.getId();
    }
    
    public PageReference deleteProjectAndChilds() {
        PageReference redirectPage = null;
        if (this.pjId == null) {
            showErrorMessage('Incorrect URL parameter');
        } else {
            List<ASI_DFPM_Promotional_Project__c> pjList = [SELECT Id FROM ASI_DFPM_Promotional_Project__c WHERE Id = :pjId];
            ASI_DFPM_Promotional_Project__c pj = pjList.size() > 0 ? pjList[0] : null;
            if (pj == null) {
                showErrorMessage(String.format('Project not found for ID {0}', new String[] {this.pjId}));
            } else {
                List<ASI_DFPM_Project_Milestone__c> mstList = [SELECT Id FROM ASI_DFPM_Project_Milestone__c WHERE ASI_DFPM_Promotional_Project__c = :pjId];
                List<ASI_DFPM_Project_Task__c> tkList = [SELECT Id FROM ASI_DFPM_Project_Task__c WHERE ASI_DFPM_Project_Milestone__c IN :mstList];
                
                System.Savepoint sp = database.setSavepoint();
                try {
                    delete tkList;
                    delete mstList;
                    delete pj;
                    redirectPage = new PageReference('/' + Schema.SObjectType.ASI_DFPM_Promotional_Project__c.getKeyPrefix() + '/o');
                } catch (Exception e) {
                    database.rollback(sp);
                    showErrorMessage(e.getMessage());
                }
            }
        }
        return redirectPage;
    }
    
    private void showErrorMessage(String msg) { showMessage(ApexPages.Severity.ERROR, msg); }
    private void showMessage(ApexPages.Severity severity, String msg) {ApexPages.addMessage(new ApexPages.Message(severity, msg));}
    
    static testMethod void test_main() {
        // Initialize Data
        final Integer numOfTestMst = 1;
        final Integer numOfTestTasksPerMst = 2;
        
        ASI_DFPM_PromotionalProjectGenerator pjGen = new ASI_DFPM_PromotionalProjectGenerator();
        ASI_DFPM_PromotionalMilestoneGenerator mstGen = new ASI_DFPM_PromotionalMilestoneGenerator();
        ASI_DFPM_PromotionalTaskGenerator taskGen = new ASI_DFPM_PromotionalTaskGenerator();
        
        ASI_DFPM_Promotional_Project__c testPj = pjGen.generateProject(ASI_DFPM_PromotionalProjectGenerator.RT_Standard, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testPj;
        List<ASI_DFPM_Project_Milestone__c> testMstList = mstGen.generateMilestonesInSequence(testPj, numOfTestMst, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testMstList;
        List<ASI_DFPM_Project_Task__c> testTaskList = taskGen.generateTasksInSequence(testMstList, ASI_DFPM_PromotionalTaskGenerator.RT_Standard, numOfTestTasksPerMst, ASI_DFPM_PromotionalTaskGenerator.DEF_VALUE_DURATION);
        insert testTaskList;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(testPj);
        
        Test.startTest();
        
        // Init page
        PageReference testPage = Page.ASI_DFPM_ProjectAndChildDeletePage;
        Test.setCurrentPageReference(testPage);
        ASI_DFPM_ProjectAndChildDeleteController testController = new ASI_DFPM_ProjectAndChildDeleteController(stdCon);
        PageReference redirectPage = testController.deleteProjectAndChilds();
        
        System.assert(null != redirectPage );
        
        Test.stopTest();
    }
    
}