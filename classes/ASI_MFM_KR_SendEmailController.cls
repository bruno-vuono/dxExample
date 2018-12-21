public class ASI_MFM_KR_SendEmailController {

    public Id PLAN_ID{get;set;}
    public String PLAN_Description{get;set;}
    public String PLAN_BrandCode{get;set;}
    public String PLAN_BrandDescription{get;set;}
    public String PLAN_ProjectCode{get;set;}
    public String PLAN_ProjectActivityGroup{get;set;}
    public String PLAN_APtype{get;set;}
    public String PLAN_FiscalYear{get;set;}
    

    public void SendEmail(){
       
        String templateApiName = 'ASI_MFM_KR_POReceiptClosing_Notify';
        List <String> ToAddresses = new List <String>(); 
        ToAddresses.add('prsg.sfdc@gmail.com');
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        
                      //  email.setTargetObjectId(this.PLAN_ID);
                        email.setToAddresses(ToAddresses); 
                        email.setWhatId('PLAN_ID');    
                        email.setSaveAsActivity(false);  
                        email.setBccSender(false);
                        email.setUseSignature(false);  
                        email.setTemplateId('00XL0000000IcSt');
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   //Send the email
        
    }
    
    
    //system.assertEquals(PORID, null);
}