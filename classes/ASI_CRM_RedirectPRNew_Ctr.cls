/*
    - This Controller controls the Page Traffic of the Payment Request Standard New Action.
*/

public class ASI_CRM_RedirectPRNew_Ctr {
    private ASI_TH_CRM_PaymentRequest__c pr{get;set;}
    private String recordTypeId{get;set;}
    private String recordId{get;set;}
    private String recordTypeName{get;set;}
    public PageReference redirectPage {get;set;}
    public String retURL {get;set;}
    private String paramList {get;set;} // store parameters from previos page and pass it to the next
    
    public ASI_CRM_RedirectPRNew_Ctr (ApexPages.StandardController controller) {
        
        recordTypeId = ((ASI_TH_CRM_PaymentRequest__c)controller.getRecord()).RecordTypeId;
        recordId = ((ASI_TH_CRM_PaymentRequest__c)controller.getRecord()).Id;
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        
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
        
        // handle user with only one record type    
        if(recordTypeId  == null){
            Schema.DescribeSObjectResult describeOpp = Schema.SObjectType.ASI_TH_CRM_PaymentRequest__c;    
            List<Schema.RecordTypeInfo> rtInfos = describeOpp.getRecordTypeInfos();
            system.debug(rtInfos);
            for(Schema.RecordTypeInfo rtInfo : rtInfos) {
                System.debug(rtInfo);
                System.debug(rtInfo.isDefaultRecordTypeMapping());
                // For only one record type available user
                if(rtInfo.isAvailable() && rtInfo.getName() != 'Master') {               
                    //ApexPages.currentPage().getParameters().put('RecordType', rtInfo.getRecordTypeId());
                    recordTypeId  = rtInfo.getRecordTypeId();
                    break;
                }
            }
            
        }
        recordTypeName = 'null';
        if(recordTypeId != '' && recordTypeId != null){
            Recordtype rt = Global_RecordTypeCache.getRt(recordTypeId);
            recordTypeName = rt.DeveloperName;
        }
        /*for(RecordType rt:[select id,DeveloperName from RecordType where id = :recordTypeId limit 1])
             recordTypeName = rt.DeveloperName;
        */
    }
    public PageReference redirect(){
        //if RecordTypeName = 'ASI_TH_CRM_Payment_Request', redirect to its default create page. if 'ASI_CRM_CN_Payment_Request', redirect to page 'ASI_CRM_CN_EditPayment_Header_Page'

        if(recordTypeName == 'ASI_TH_CRM_Payment_Request')
        {
            Schema.DescribeSObjectResult prObj = ASI_TH_CRM_PaymentRequest__c.sObjectType.getDescribe();
            //redirectPage =  new PageReference('/'+ prObj.getKeyPrefix() +'/e?RecordType='+recordTypeId+'&nooverride=1&retURL='+retURL);
            redirectPage = new PageReference('/'+ prObj.getKeyPrefix() +'/e?RecordType='+recordtypeid+'&nooverride=1'+ paramList);
        }
        else if(recordTypeName == 'ASI_CRM_CN_Payment_Request') 
        {
            redirectPage =  new PageReference('/apex/ASI_CRM_CN_EditPayment_Header_Page?RecordType='+recordTypeId+'&retURL='+retURL);
        }
        else if(recordTypeName == 'ASI_SG_CRM_Payment_Request' || recordTypeName == 'ASI_CRM_SG_Payment_Request') 
        {
            Schema.DescribeSObjectResult contractObj = ASI_TH_CRM_PaymentRequest__c.sObjectType.getDescribe();
            redirectPage =  new PageReference('/'+ contractObj.getKeyPrefix() +'/e?RecordType='+recordTypeId+'&nooverride=1&retURL='+retURL+'&Name=[Auto-generated]');
        }
        else if(recordTypeName == 'ASI_CRM_MY_Payment_Request') 
        {
            Schema.DescribeSObjectResult contractObj = ASI_TH_CRM_PaymentRequest__c.sObjectType.getDescribe();
            redirectPage =  new PageReference('/'+ contractObj.getKeyPrefix() +'/e?RecordType='+recordTypeId+'&nooverride=1&retURL='+retURL+'&Name=Auto-generated Number');
        }
        else{
            Schema.DescribeSObjectResult contractObj = ASI_TH_CRM_PaymentRequest__c.sObjectType.getDescribe();
            if(recordTypeId != null)
                redirectPage =  new PageReference('/'+ contractObj.getKeyPrefix() +'/e?RecordType='+recordTypeId+'&nooverride=1&retURL='+retURL);
            else{
                redirectPage =  new PageReference('/'+ contractObj.getKeyPrefix() +'/e?nooverride=1&retURL='+retURL);
            }
        }
        
        return redirectPage;
    }

}