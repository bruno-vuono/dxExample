public class ASI_CN_NPL_ItemMasterStatusController {
    public ASI_CN_NPL_Item_Master__c im;
    public boolean succeed {get; private set;}
    
    public ASI_CN_NPL_ItemMasterStatusController (ApexPages.StandardController stdController){
        im = (ASI_CN_NPL_Item_Master__c)[select ASI_CN_NPL_Status__c, RecordTypeID, ASI_CN_NPL_New_Item_Group__c from ASI_CN_NPL_Item_Master__c where id = :stdController.getId() limit 1];    
    }
    
    public pageReference goBack() {
        return new pageReference('/' + im.id);
    }
    
    public PageReference proceedToNextStep(){
    
    RecordType rec = [select developerName from RecordType where id = :im.recordtypeid limit 1];
    
        if (rec.developername == 'ASI_CN_NPL_Item_Master_TypeA'){
                if (im.ASI_CN_NPL_Status__c == 'Waiting For Logistics Input Item Code')
                    im.ASI_CN_NPL_Status__c = 'Waiting For BA Input Category Code';
                    
                else if (im.ASI_CN_NPL_Status__c == 'Waiting For BA Input Category Code')
                    im.ASI_CN_NPL_Status__c  = 'Waiting For Logistics Finalize Chinese Name';
                    
                else if (im.ASI_CN_NPL_Status__c == 'Waiting For Logistics Finalize Chinese Name'){
                    if (im.ASI_CN_NPL_New_Item_Group__c){
                        //New Item Group selected, all steps is needed
                        im.ASI_CN_NPL_Status__c  = 'Waiting For Sales Planning Input Item Group Description (GE & CH)';
                    }
                    else {
                        //New Item Group not selected, skip Sales Planning step
                        im.ASI_CN_NPL_Status__c  = 'Waiting For Logistics Final Confirmation';            
                    }
                }
                else if (im.ASI_CN_NPL_Status__c == 'Waiting For Sales Planning Input Item Group Description (GE & CH)')
                    im.ASI_CN_NPL_Status__c  = 'Waiting For Logistics Final Confirmation';            
                
                else if (im.ASI_CN_NPL_Status__c == 'Waiting For Logistics Final Confirmation')
                    im.ASI_CN_NPL_Status__c  = 'Completed';                     
        }
        else if (rec.developername == 'ASI_CN_NPL_Item_Master_TypeB'){
            if (im.ASI_CN_NPL_Status__c == 'Waiting For Logistics Input Item Code')
                im.ASI_CN_NPL_Status__c = 'Completed';
        }
        //2016029 Ben @ Elufa
        try{
            update im;
            apexpages.addMessage(new apexpages.Message(apexpages.severity.info, 'The status has been updated. The next handler will be notified by email.'));
        	succeed = true;
        }catch(dmlException dmle){
            
        }
        //20160229 End
        
        
        
        return null;
    }        
    
}