public with sharing class ASI_KOR_VisitationConfirmController {
    
    public ID visitId { get; private set; }
    public Boolean hasError { get; private set; }
    
    private ASI_KOR_Visitation_Plan__c visitHeader;
    
    public ASI_KOR_VisitationConfirmController(ApexPages.StandardController stdController) {
        this.visitId = stdController.getId();
        List<ASI_KOR_Visitation_Plan__c> tempVisitHeaders = [SELECT Id, ASI_KOR_Confirmed__c FROM ASI_KOR_Visitation_Plan__c WHERE Id = :visitId];
        if (tempVisitHeaders.size() > 0)
            this.visitHeader = tempVisitHeaders.get(0);
        this.hasError = false;
    }
    
    public PageReference initPage() {
        if (visitId == null) {
            this.hasError = true;
            showPageError('Visitation ID is not specified');
        } else if (this.visitHeader.ASI_KOR_Confirmed__c) {
            this.hasError = true;
            showPageError(Label.ASI_KOR_VF_VISIT_ERR_AlreadyConfirmed);
        } else {
            ASI_KOR_VisitationConfirmProcess visitConfirmProcess = new ASI_KOR_VisitationConfirmProcess(visitId);
            this.hasError = !visitConfirmProcess.processConfirmation();
        }
        return this.hasError ? null : new PageReference('/' + visitId);
    }
    
    private void showPageMessage(ApexPages.Severity severity, String msg) {
        ApexPages.addMessage(new ApexPages.Message(severity, msg));
    }
    
    private void showPageError(String msg) {
        showPageMessage(ApexPages.Severity.ERROR, msg);
    }
    
    
}