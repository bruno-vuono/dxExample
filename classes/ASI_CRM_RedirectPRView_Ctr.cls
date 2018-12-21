/*
    - This Controller controls the Page Traffic of the Payment Request Standard View Action.
*/

public class ASI_CRM_RedirectPRView_Ctr {
    private String recordTypeId{get;set;}
    private ASI_TH_CRM_PaymentRequest__c pr {get;set;}
    private String recordId{get;set;}
    private String recordTypeName{get;set;}
    public PageReference redirectPage {get;set;}
    private String paramList {get;set;}
    
    public ASI_CRM_RedirectPRView_Ctr (ApexPages.StandardController controller) {
        Map<String, String> pageParam = ApexPages.currentPage().getParameters(); 
        paramList='';
        if(pageParam!=null){
            for(String param : pageParam.keySet()){
                if(pageParam.get(param)==null){
                    paramList +='&'+param+'=null';
                }else{
                    if(!param.contains('save_new')&&!param.contains('sfdc.override'))
                    paramList +='&'+param+'='+pageParam.get(param);
                }
            }
        }
        
        pr = (ASI_TH_CRM_PaymentRequest__c)controller.getRecord();
        recordTypeId = ((ASI_TH_CRM_PaymentRequest__c)controller.getRecord()).RecordTypeId;
        recordId = ((ASI_TH_CRM_PaymentRequest__c)controller.getRecord()).Id;
        recordTypeName = 'null';
        for(RecordType rt:[select id,DeveloperName from RecordType where id = :recordTypeId limit 1])
             recordTypeName = rt.DeveloperName;
    }
    public PageReference redirect(){
        //if RecordTypeName = 'ASI_TH_CRM_Payment_Request', redirect to its default view page. if 'ASI_CRM_CN_Payment_Request', redirect to page 'ASI_CRM_CN_Payment_Header_Page'

        if(recordTypeName == 'ASI_TH_CRM_Payment_Request')
        {
            redirectPage =  new PageReference('/'+ this.pr.id + '?nooverride=1'+ paramList);
            redirectPage.setRedirect(true);
        }
        else if(recordTypeName == 'ASI_CRM_CN_Payment_Request') 
        {
            ASI_TH_CRM_PaymentRequest__c PaymentRequest =[select Id,Name,ASI_CRM_CN_Promotion_Type__c from ASI_TH_CRM_PaymentRequest__c where id=:recordId];
            if(PaymentRequest.ASI_CRM_CN_Promotion_Type__c!=null &&  PaymentRequest.ASI_CRM_CN_Promotion_Type__c=='Heavy Contract On'){
                if(PaymentRequest.Name.length()>3){
                    if(PaymentRequest.Name.substring(PaymentRequest.Name.length()-3, PaymentRequest.Name.length()) == '000'){
                        redirectPage =  new PageReference('/apex/ASI_CRM_CN_Payment_Header_Page?id='+ recordId);
                    }else{
                        redirectPage =  new PageReference('/apex/ASI_CRM_CN_HeavyPaymentHeader_Page?id='+ recordId); 
                    }
                }
            }else{
                redirectPage =  new PageReference('/apex/ASI_CRM_CN_Payment_Header_Page?id='+ recordId);
            }
            
            //redirectPage =  new PageReference('/apex/ASI_CRM_CN_Payment_Header_Page?id='+ recordId);
        }
        else if(recordTypeName == 'ASI_SG_CRM_Payment_Request') 
        {
            redirectPage =  new PageReference('/'+ this.pr.id + '?nooverride=1'+ paramList);
            redirectPage.setRedirect(true);
        }
        else if(recordTypeName.startsWith('ASI_CRM_MY_Payment_Request')) 
        {
            redirectPage =  new PageReference('/apex/ASI_CRM_PaymentRequest_Standard?id='+ this.pr.id + paramList);
            redirectPage.setRedirect(true);
        }
        else
        {
            redirectPage =  new PageReference('/'+ this.pr.id + '?nooverride=1'+ paramList);
            redirectPage.setRedirect(true);
        }
        
        
        return redirectPage;
    }

}