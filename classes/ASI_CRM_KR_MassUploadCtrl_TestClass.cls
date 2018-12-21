@isTest
public class ASI_CRM_KR_MassUploadCtrl_TestClass {
    
    public static string getFiscalYear(){
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;  //i.e. 7
        Date orgFiscalYear = Date.newinstance(system.today().year(), orgFiscalMonth, 1);    
        Datetime GMTdate = Datetime.now();
        String yearA1 = GMTdate.format('YY');
        Integer yearA0 = Integer.valueOf(yearA1) -1;
        Integer yearA2 = Integer.valueOf(yearA1) +1;
        String Current_Fiscal_year;
        
        if(system.today()< orgFiscalYear){
            Current_Fiscal_year = 'FY' + yearA0 + yearA1 ;
        }else{
            Current_Fiscal_year = 'FY' + yearA1 + yearA2 ;
        }
        
        return Current_Fiscal_year;
    }
    
    static testMethod void ASI_MFM_MassUploadByBatch_Test(){
        Account a = new Account(name='test', recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_GF_Customer'));
        insert a;
        Contact c = new Contact(accountid=a.id,firstname='James',lastname='test', recordTypeId = Global_RecordTypeCache.getRtId('ContactASI_HK_CRM_Wholesalers_Outlets'));
        insert c;
        
        
        test.startTest();
        ASI_CRM_KR_MassUploadByBatchController controller = new ASI_CRM_KR_MassUploadByBatchController();
        controller.emailNotification = true;
        controller.ObjAPIName = 'Contact';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'AccountID';  
        controller.recordtypeName = 'contactType1';
        controller.fields = 'firstname,lastname,description,reportstoid,DoNotCall,Birthdate,reportstoid';
        controller.fieldsLabel = 'firstname,lastname,description,reportsto,DoNotCall,Birthdate,reportsto';
        controller.lookupEXID = 'contact/reportstoid:reportsto-lastname';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = 'birthdate:2013-01-01';
        controller.upsertMode = false;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        
        controller.init();
        controller.filesize = 2000;
        controller.namefile = 'test.csv';
        controller.contentFile = blob.valueOf('firstname,lastname,description,DoNotCall,Birthdate,reportsto\rJohn,Test,desc,Y,2013-08-01,test\rJohn,Test,desc,N,2013-08-01,test');
        controller.uploadCSVByBatch();
        
        
        controller.ObjAPIName = 'Account';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'ParentId';
        controller.recordtypeName = '';
        //controller.fields = 'name,NumberOfEmployees,AnnualRevenue,PersonDoNotCall,PersonBirthdate,PersonMobilePhone';
        controller.fields = 'PersonDoNotCall,PersonBirthdate,PersonMobilePhone';
        controller.fieldsLabel = 'DoNotCall,Birthdate,mobile';
        controller.lookupEXID = 'account/ParentId:ParentId-par';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = false;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.contentFile = blob.valueOf('True,,NumberOfEmployeesAnnualRevenue\rJohn,1,3');
        controller.emailNotification = true;
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        
        controller.ObjAPIName = 'Account';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'ParentId';
        controller.recordtypeName = '';
        controller.fields = 'name,NumberOfEmployees,AnnualRevenue';
        controller.fieldsLabel = 'name,NumberOfEmployees,AnnualRevenue';
        controller.lookupEXID = 'account/ParentId:ParentId-par';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = true;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.contentFile = blob.valueOf('name,,NumberOfEmployeesAnnualRevenue\rJohn,1,3');
        controller.emailNotification = true;
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        
        //Kammy starts:
        controller.ObjAPIName = 'Account';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'ParentId';
        controller.recordtypeName = '';
        controller.fields = 'PersonDoNotCall,PersonBirthdate,PersonMobilePhone';
        controller.fieldsLabel = 'DoNotCall,Birthdate,mobile';
        controller.lookupEXID = 'account/ParentId:ParentId-par';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = false;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.contentFile = blob.valueOf('True,NumberOfEmployeesAnnualRevenue\rJohn,1,3');
        controller.emailNotification = true;
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        
        //Kammy starts:
        controller.ObjAPIName = 'Account';
        controller.parentID = String.valueof(a.id);
        controller.parentField = 'ParentId';
        controller.recordtypeName = '';
        controller.fields = 'PersonDoNotCall,AnnualRevenue,PersonMobilePhone,ASI_KOR_Venue_PR_Market_Share__c';
        controller.fieldsLabel = 'DoNotCall,Annual Revenue,mobile,PRK_MS';
        controller.lookupEXID = 'account/ParentId:ParentId-par';
        controller.template = 'ASI_MFM_PlanLineItemTemplate';
        controller.currentPageURL = String.valueof(a.id);
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = false;
        controller.parentObjectAPIName = 'Account';
        controller.ParentObjectUploadMsg = 'Description';
        controller.contentFile = blob.valueOf('1,19,3,10');
        controller.emailNotification = true;
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        
        //Kammy starts:  KR Budget 
        controller.emailNotification = true;
        controller.ObjAPIName = 'ASI_MFM_Budget__c';
        controller.recordtypeName = 'KR Budget';
        controller.fields = 'asi_mfm_type__c,ASI_MFM_P10_Amount__c,ASI_MFM_Total_Amount__c,ASI_MFM_Fiscal_Year__c';       //API Name
        controller.fieldsLabel = 'Type,P10 Amount,Total Amount,Fiscal Year';  //Label 
        controller.template = 'ASI_KR_Budget_Tempalte';
        controller.inlineVF = true;
        controller.DefaultValues = '';
        controller.upsertMode = false;
        controller.contentFile = blob.valueOf('LE10,100,100,FY1516');
        controller.uploadCSVByBatch();
        
        controller.uploadCSV();
        controller.refreshPage();
        controller.refreshPage2();
        test.stopTest();
    }
    
    static testMethod void ASI_MFM_MassUploadByBatch_Test_2(){
        
        userrole Role_Test= new userrole(Name='XXXTrade Marketing',developerName='test');
        insert Role_Test;
        
        user u = [select userRole.developerName, ASI_MFM_Country__c,UserRoleid,CompanyName,ASI_KOR_User_Branch_Code__c from user where id = :userInfo.getUserId() limit 1]; 
        u.UserRoleid =Role_Test.id;
        u.CompanyName = 'Pernod Ricard Korea';
        u.ASI_MFM_Country__c  = 'KR';
        update u;
        
        System.runAs(u){ 
            
            Account a = new Account(name='test', recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_GF_Customer'));
            insert a;
            Contact c = new Contact(accountid=a.id,firstname='James',lastname='test', recordTypeId = Global_RecordTypeCache.getRtId('ContactASI_HK_CRM_Wholesalers_Outlets'));
            insert c;
            
            Account b = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_KOR_Venue'),name = 'Venue');
            insert b;
            
            ASI_CRM_KR_MassUploadByBatchController controller = new ASI_CRM_KR_MassUploadByBatchController();
            controller.emailNotification = true;
            controller.batchMode = false;
            controller.ObjAPIName = 'Contact';
            controller.parentID = String.valueof(a.id);
            controller.parentField = 'AccountID';  
            controller.recordtypeName = 'contactType1';
            controller.fields = 'firstname,lastname,description,reportstoid,DoNotCall,Birthdate,reportstoid';
            controller.fieldsLabel = 'firstname,lastname,description,reportsto,DoNotCall,Birthdate,reportsto';
            controller.lookupEXID = 'contact/reportstoid:reportsto-lastname';
            controller.template = 'ASI_MFM_PlanLineItemTemplate';
            controller.currentPageURL = String.valueof(a.id);
            controller.inlineVF = true;
            controller.DefaultValues = 'birthdate:2013-01-01';
            controller.upsertMode = false;
            controller.parentObjectAPIName = 'Account';
            controller.ParentObjectUploadMsg = 'Description';
            
            controller.init();
            controller.filesize = 2000;
            controller.namefile = 'test.csv';
            controller.contentFile = blob.valueOf('firstname,lastname,description,DoNotCall,Birthdate,reportsto\rJohn,Test,desc,Y,2013-08-01,test\rJohn,Test,desc,N,2013-08-01,test');
            controller.uploadCSVByBatch();
            
            //Kammy starts:  POSM
            controller.currentPageURLOutput = '12';
            controller.template2 = 'string';
            controller.report = 'report';
            controller.batchMode = true;
            controller.dummyVar = true;
            controller.objName = 'ObjectName';
            controller.emailNotification = false;
            controller.ObjAPIName = 'ASI_KOR_POSM_Order_Request__c';
            controller.recordtypeName = 'New POSM Request';
            controller.fields = 'ASI_MFM_KR_POSM_Order_Request_Name__c,ASI_MFM_Total_Amount__c,ASI_MFM_KR_EmailSentTime__c';       //API Name
            controller.fieldsLabel = 'POSM Order Request Name,Total Amount,Email Sent Time';  //Label 
            controller.template = 'ASI_KR_POSM_Tempalte';
            controller.inlineVF = true;
            controller.DefaultValues = '';
            controller.upsertMode = false;
            controller.recEXID = 'POSM Order Request Name';
            controller.recEXIDcol = 'ASI_MFM_KR_POSM_Order_Request_Name__c';
            controller.contentFile = blob.valueOf('1234500000000067,100,2015-08-01:T08:00:00');
            controller.uploadCSVByBatch();
            
            
            controller.uploadCSV();
            controller.refreshPage();
            controller.refreshPage2();
            
            controller.emailNotification = false;
            controller.ObjAPIName = 'ASI_KOR_POSM_Order_Request__c';
            controller.recordtypeName = 'New POSM Request';
            controller.fields = 'ASI_MFM_KR_POSM_Order_Request_Name__c,ASI_MFM_Total_Amount__c';       //API Name
            controller.fieldsLabel = 'POSM Order Request Name,Total Amount';  //Label 
            controller.template = 'ASI_KR_POSM_Tempalte';
            controller.inlineVF = true;
            controller.DefaultValues = '';
            controller.upsertMode = false;
            controller.recEXIDcol = 'ASI_MFM_KR_POSM_Order_Request_Name__c';
            controller.filesize = 5242881;
            controller.namefile = 'test.csv';
            controller.contentFile = blob.valueOf('"1234567",100');
            controller.currentPageURL ='';
            controller.uploadCSVByBatch();
            
            controller.uploadCSV();
            controller.refreshPage();
            controller.refreshPage2();
            
            test.startTest();     
            
            controller.emailNotification = false;
            controller.ObjAPIName = 'ASI_KOR_POSM_Order_Request__c';
            controller.recordtypeName = 'New POSM Request';
            controller.fields = 'ASI_MFM_KR_POSM_Order_Request_Name__c,ASI_MFM_Total_Amount__c,ASI_MFM_PO_External_ID1__c';       //API Name
            controller.fieldsLabel = 'POSM Order Request Name,Total Amount,PO External ID';  //Label 
            controller.template = 'ASI_KR_POSM_Tempalte';
            controller.lookupEXID = 'ASI_MFM_PO__c/ASI_MFM_PO_External_ID1__c:PO External ID&ASI_MFM_PO_External_ID__c';
            controller.inlineVF = true;
            controller.DefaultValues = '';
            controller.upsertMode = false;  
            controller.recEXIDcol = 'ASI_MFM_KR_POSM_Order_Request_Name__c';
            controller.filesize = 100;
            controller.namefile = 'test.doc';
            controller.contentFile = blob.valueOf('1234567,100');
            controller.currentPageURL ='';
            controller.uploadCSVByBatch();
            
            controller.uploadCSV();
            controller.refreshPage();
            controller.refreshPage2();
            
            
            test.stopTest();
        } 
    }
    
    
}