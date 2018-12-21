public virtual with sharing class ASI_DFPM_AbstractPageController {

	public Boolean hasError { get; protected set; }
	
	public ASI_DFPM_AbstractPageController() {
		this.hasError = false;
	}
	
	protected void showPageMessage(ApexPages.Severity severity, String msg) {
		ApexPages.addMessage(new ApexPages.Message(severity, msg));
	}
	protected void showPageError(String msg) {
		this.hasError = true;
		showPageMessage(ApexPages.Severity.ERROR, msg);
	}
}