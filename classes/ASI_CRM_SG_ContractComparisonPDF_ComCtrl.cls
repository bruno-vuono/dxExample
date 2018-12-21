/*********************************************************************************
 * Name: ASI_CRM_SG_ContractComparisonPDF_ComCtrl
 * Description: Controller class for ASIshowing PDF in approval email
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 03/04/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_SG_ContractComparisonPDF_ComCtrl {
    
    public Id contractId {get; set;}
    public String body;
    
    public ASI_CRM_SG_ContractComparisonPDF_ComCtrl() {
    }
    
    public String getBody() {
        String bodyStr = '';
        // ASI_CRM_SG_PDF_Attachment__c is string with format: Object:attachmentId;
    	ASI_TH_CRM_Contract__c contract = [SELECT Id, ASI_CRM_SG_PDF_Attachment__c FROM ASI_TH_CRM_Contract__c WHERE Id =: contractId];
        if(String.isNotBlank(contract.ASI_CRM_SG_PDF_Attachment__c)) {
           	List<String> pdfAttachmentList = contract.ASI_CRM_SG_PDF_Attachment__c.split(';');
            
            String contractComparsionAttId;
            for(String pdfAtt : pdfAttachmentList) {
            	if(pdfAtt.contains('ContractComparsionPDF')) {
                    contractComparsionAttId = pdfAtt.split(':')[1];
                }
            }
            if(String.isNotBlank(contractComparsionAttId)) {
            	Attachment tempAttachment = [SELECT Body FROM Attachment WHERE Id = :contractComparsionAttId];
            	bodyStr = tempAttachment.Body.toString();
            }
        }
        return bodyStr;
    }
}