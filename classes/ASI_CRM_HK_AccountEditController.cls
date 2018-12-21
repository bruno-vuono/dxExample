public class ASI_CRM_HK_AccountEditController {
    public ASI_CRM_AccountsAdditionalField__c accountAdditionalField {set;get;}
   // public ASI_CRM_AccountsAdditionalField__c iconicAdditionalField {set;get;}
    public ApexPages.StandardController standardController;    
    public boolean IsOutlet {set;get;}
    public boolean IsWholesaler {set;get;}
    public boolean IsCashAccount {set;get;}
    public boolean IsPotentialAccount {set;get;}
    public boolean IsPotentialAccountPrestige {set;get;}
    
    /*public String selectedOutletTypeId{ 
    	get{
        if(accountAdditionalField.ASI_TH_CRM_OutletType__c!=null && selectedOutletTypeId == Null)
            selectedOutletTypeId = accountAdditionalField.ASI_TH_CRM_OutletType__c;
        return selectedOutletTypeId;
    	}
        set;
    }
    public String selectedOutletImageId{ 
    	get{
        if(accountAdditionalField.ASI_TH_CRM_OutletImage__c!=null && selectedOutletImageId == Null)
            selectedOutletImageId = accountAdditionalField.ASI_TH_CRM_OutletImage__c;
        return selectedOutletImageId;
    	}
        set;
    }
    public String selectedVolumePotentialId{ 
    	get{
        if(accountAdditionalField.ASI_CRM_SG_Volume_Potential__c!=null && selectedVolumePotentialId == Null)
            selectedVolumePotentialId = accountAdditionalField.ASI_CRM_SG_Volume_Potential__c;
        return selectedVolumePotentialId;
    	}
        set;
    }*/
    public Account account {get;set;}
    
    public ASI_CRM_HK_AccountEditController(ApexPages.StandardController controller) {
        standardController = controller;        
        system.debug('enter');
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('OwnerId'); //20160203, added by Leo
        if(!Test.isRunningTest())
        	controller.addFields(fields);
        account = (Account)controller.getRecord();
        accountAdditionalField = getAccountsAdditionalField_DynamiCSOQL(account.id);        
        if (accountAdditionalField == null){
            accountAdditionalField = new ASI_CRM_AccountsAdditionalField__c();
            accountAdditionalField.ASI_CRM_Account__c = controller.getRecord().id;                 //change from ASI_CRM_HK_Outlet
            RecordType recordType = [SELECT DeveloperName, id FROM RecordType WHERE DeveloperName = 'ASI_CRM_HK_Outlet' AND SobjectType = 'ASI_CRM_AccountsAdditionalField__c'];
            accountAdditionalField.RecordTypeId = recordType.id;
            accountAdditionalField.Name = account.Name;
            accountAdditionalField.OwnerId = account.OwnerId; //20160203, added by Leo
            system.debug('Name::'+accountAdditionalField.Name);
        } 
        if (account.RecordTypeId == null){
            IsOutlet = true;
            RecordType recordType = [SELECT DeveloperName, id FROM RecordType WHERE DeveloperName = 'ASI_HK_CRM_Outlet' AND SobjectType = 'Account'];
            account.RecordTypeId = recordType.id;
        } else{
            RecordType recordType = [SELECT DeveloperName, id FROM RecordType WHERE id = :account.RecordTypeId];
            
            if (recordType.DeveloperName == 'ASI_HK_CRM_Outlet'){
                IsOutlet = true;
            }else if (recordType.DeveloperName == 'ASI_HK_CRM_Wholesaler'){
                IsWholesaler = true;
            }else if (recordType.DeveloperName == 'ASI_HK_CRM_JDE_Salesman_Cash_Account'){
                IsCashAccount = true;
            }else if (recordType.DeveloperName == 'ASI_HK_CRM_Potential_Account'){
                IsPotentialAccount = true;
            }else if (recordType.DeveloperName == 'ASI_HK_CRM_Potential_Account_Prestige'){
                IsPotentialAccountPrestige = true;
            }
        }                                
    }
    
    private ASI_CRM_AccountsAdditionalField__c getAccountsAdditionalField_DynamiCSOQL(String accountId) {
        try{    
            String query = 'SELECT ';    
            for(Schema.FieldSetMember f : SObjectType.ASI_CRM_AccountsAdditionalField__c.FieldSets.ASI_CRM_HK_AdditionalField.getFields()) {    
                query += f.getFieldPath() + ', ';    
            }  
            for(Schema.FieldSetMember g : SObjectType.ASI_CRM_AccountsAdditionalField__c.FieldSets.ASI_CRM_HK_IconicField.getFields()) {    
                query += g.getFieldPath() + ', ';    
            }  
            query += 'Id, Name, ASI_CRM_CN_Phone_Number__c, ASI_CRM_CN_Fax_Number__c, ASI_CRM_Account__c FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_Account__c = \''+accountId+'\' Order by LastModifiedDate desc LIMIT 1';  
            
            System.Debug('query:::' + query);  
            return Database.query(query);    
        }    
        catch(Exception e){   
            System.Debug('---------------Error showing additional field ---------------------');
            System.Debug(e);
            //Utility.addError('There is error while Fetching existing Question using Dynamic SOQL in Field Set. Error Detail - '+e.getMessage()); //This is Utility Method to display error message on VF Page    
        }    
        return null;
        
    }   
    public PageReference save() {
        try {
            //upsert(standardController.getRecord());   
            if (accountAdditionalField.ASI_CRM_Account__c == null) {
                accountAdditionalField.ASI_CRM_Account__c = standardController.getRecord().id;          //change from ASI_CRM_HK_Outlet
                RecordType recordType = [SELECT DeveloperName, id FROM RecordType WHERE DeveloperName = 'ASI_CRM_HK_Outlet' AND SobjectType = 'ASI_CRM_AccountsAdditionalField__c'];
                accountAdditionalField.RecordTypeId = recordType.id;
                accountAdditionalField.Name = account.Name; 
                accountAdditionalField.OwnerId = account.OwnerId; //20160203, added by Leo
            }
            /*if(selectedOutletTypeId!='')
                accountAdditionalField.ASI_TH_CRM_OutletType__c = selectedOutletTypeId;
            if(selectedOutletImageId!='')
                accountAdditionalField.ASI_TH_CRM_OutletImage__c = selectedOutletImageId;
            if(selectedVolumePotentialId!='')
                accountAdditionalField.ASI_CRM_SG_Volume_Potential__c = selectedVolumePotentialId;*/
            upsert(accountAdditionalField);
            system.debug('additional id'+accountAdditionalField.id);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        PageReference ReturnPage = new PageReference('/' + standardController.getRecord().id);     
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    
    /*public List<SelectOption> OutletTypeList{
        get{
            List<ASI_TH_CRM_OutletType__c> outletTypes = [
                SELECT id, Name 
                FROM ASI_TH_CRM_OutletType__c 
                WHERE RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_OutletType__cASI_CRM_HK_Outlet_Type') //.DeveloperName = 'ASI_CRM_MO_Outlet_Type'
                ORDER BY Name
            ];
            
            List<SelectOption> outletTypeList = new List<SelectOption>();
            outletTypeList.add(new SelectOption('', '--None--'));
            for(ASI_TH_CRM_OutletType__c outletType : outletTypes){
                outletTypeList.add(new SelectOption(outletType.id, outletType.Name));
            }
            return outletTypeList;
        }
    }*/
    
    /*public List<SelectOption> OutletImageList{
        get{
            List<ASI_TH_CRM_OutletImage__c> outletImages = [
                SELECT id, Name 
                FROM ASI_TH_CRM_OutletImage__c
                WHERE RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_TH_CRM_OutletImage__cASI_CRM_MO_Outlet_Image')
                ORDER BY ASI_CRM_Sequence__c
            ];
            
            List<SelectOption> outletImageList = new List<SelectOption>();
            outletImageList.add(new SelectOption('', '--None--'));
            for(ASI_TH_CRM_OutletImage__c outletImage : outletImages){
                outletImageList.add(new SelectOption(outletImage.id, outletImage.Name));
            }
            return outletImageList;
        }
    }*/
    
    /*public List<SelectOption> VolumePotentialList{
        get{
            List<ASI_CRM_Volume_Potential__c> VolumePotentials = [
                SELECT id, ASI_CRM_SG_Name__c
                FROM ASI_CRM_Volume_Potential__c
                WHERE RecordTypeId = :Global_RecordTypeCache.getRtId('ASI_CRM_Volume_Potential__cASI_CRM_HK_Volume_Potential')
            ];
            
            List<SelectOption> VolumePotentialList = new List<SelectOption>();
            VolumePotentialList.add(new SelectOption('', '--None--'));
            for(ASI_CRM_Volume_Potential__c VolumePotential : VolumePotentials){
                VolumePotentialList.add(new SelectOption(VolumePotential.id, VolumePotential.ASI_CRM_SG_Name__c));
            }
            return VolumePotentialList;
        }
    }*/
    
}