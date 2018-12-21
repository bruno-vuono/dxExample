public with sharing class ASI_MFM_SG_MakePaymentController {
    map<string, asi_mfm_role_prefix_relationship__c> px_map = new map<string, asi_mfm_role_prefix_relationship__c>();   
    
    public list<selectOption> available_prefixes {get; private set;}
    public string selected_prefix {get; set;}
    public boolean initcheck {get; set;}{initcheck=true;}
    public string Msg {get; set;}{Msg='';}
    public ASI_MFM_Payment__c pa {get; set;} 
    public ASI_MFM_SG_MakePaymentController(apexpages.standardController sc){}
    
     public pageReference getPrefixes() {
         pa= new ASI_MFM_Payment__c();
        user u = [select userRole.developerName, asi_mfm_country__c from user where id = :userInfo.getUserId()];
        if (u.userRole.developerName == null) {
            apexpages.message err = new apexpages.message(apexpages.severity.error, 'The role of the user is not defined yet');
            apexpages.addmessage(err); 
        }
        else if (u.asi_mfm_country__c == null) {
            apexpages.message err = new apexpages.message(apexpages.severity.error, 'The country of the user is not defined yet');
            apexpages.addmessage(err); 
        }
        else {
            list<asi_mfm_role_prefix_relationship__c> px_list = new list<asi_mfm_role_prefix_relationship__c>();
            for (asi_mfm_role_prefix_relationship__c px:[select asi_mfm_prefix__c, asi_mfm_prefix__r.name,asi_mfm_prefix__r.ASI_MFM_Location__c from asi_mfm_role_prefix_relationship__c
                                                         where asi_mfm_prefix__r.ASI_MFM_Inactive__c = false and asi_mfm_prefix__r.asi_mfm_module__c = 'Payment' and asi_mfm_role_name__c = :u.userRole.developerName and asi_mfm_prefix__r.asi_mfm_country_name__c = :u.asi_mfm_country__c order by asi_mfm_prefix__r.name]) {
                                                             px_map.put(px.asi_mfm_prefix__c, px);
                                                             px_list.add(px);    
                                                         }           
            if (px_list.size() == 0) {
                apexpages.message err = new apexpages.message(apexpages.severity.error, 'The user is not entitled to input payments');
                apexpages.addmessage(err); 
            }
            else if (px_list.size() == 1) {
                selected_prefix = px_list[0].asi_mfm_prefix__c;
                
            }
            else {
                available_prefixes = new list<selectOption>();
                available_prefixes.add(new selectOption('', '-- None --'));
                for (asi_mfm_role_prefix_relationship__c rp:px_list) {
                    available_prefixes.add(new selectOption(rp.asi_mfm_prefix__c, rp.asi_mfm_prefix__r.name));
                }
            }
        }       
        return null;
    }
    
    
    public pageReference proceed() {
        boolean paymentcreated=false;
        if (selected_prefix == null || selected_prefix == '') {
            apexpages.message err = new apexpages.message(apexpages.severity.error, 'Please select prefix first');
            apexpages.addmessage(err); 
            return null;            
        }
        else {
            String poid = ApexPages.currentPage().getParameters().get('id');
            ASI_MFM_PO__c po =[select id, ASI_MFM_Supplier_Name__c,ASI_MFM_Currency__c from ASI_MFM_PO__c where id =: poid];
            List<ASI_MFM_PO_Line_Item__c> polist=[select id,name,ASI_MFM_Amount__c, ASI_MFM_Requested_Balance__c from ASI_MFM_PO_Line_Item__c where ASI_MFM_PO__c =: poid];
            map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_MFM_Payment__c');  
            ASI_MFM_Payment__c insertpayment = new ASI_MFM_Payment__c(ASI_MFM_Prefix__c=selected_prefix,
                                                                      recordTypeId=rt_map.get('ASI_MFM_SG_Payment'),
                                                                      ASI_MFM_Invoice_Date__c=pa.ASI_MFM_Invoice_Date__c,
                                                                      ASI_MFM_Invoice_Number__c=pa.ASI_MFM_Invoice_Number__c,
                                                                      ASI_MFM_Currency__c=po.ASI_MFM_Currency__c,
                                                                     ASI_MFM_Supplier_Name__c=po.ASI_MFM_Supplier_Name__c); 
            
            try{
                insert insertpayment;
                
                List<ASI_MFM_Payment_Line_Item__c> palist = new List<ASI_MFM_Payment_Line_Item__c>();
                for(ASI_MFM_PO_Line_Item__c pol:polist){
                    palist.add(new ASI_MFM_Payment_Line_Item__c(ASI_MFM_Payment__c =insertpayment.id,
                                                                ASI_MFM_PO_Line_Item__c=pol.id, ASI_MFM_PO__c=poid,ASI_MFM_Payment_Amount__c=pol.ASI_MFM_Requested_Balance__c,
                                                                ASI_MFM_Payee__c=insertpayment.ASI_MFM_Supplier_Name__c,
                                                                ASI_MFM_Invoice_Date__c=insertpayment.ASI_MFM_Invoice_Date__c,
                                                                ASI_MFM_Invoice_Number__c=insertpayment.ASI_MFM_Invoice_Number__c,
                                                                recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Payment_Line_Item__cASI_MFM_SG_Payment_Line_Item'))
                                );
                }
                insert palist;
                paymentcreated=true;
                
                
            } catch (Exception e) {
                apexpages.message err = new apexpages.message(apexpages.severity.error, e.getMessage());
                apexpages.addmessage(err); 
                return null;  
            }
            PageReference pageRef = null;
            
            if(paymentcreated){
                pageRef = new PageReference('/apex/ASI_MFM_SG_InputPaymentItemsPage?&id='+insertpayment.id);
                pageRef.setRedirect(true);
                
            }
            return pageRef;    
        }
           
        
    }
    
}