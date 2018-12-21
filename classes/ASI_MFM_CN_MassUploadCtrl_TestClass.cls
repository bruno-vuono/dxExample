@isTest
public class ASI_MFM_CN_MassUploadCtrl_TestClass {
 
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
    
    
    
        @isTest
    public static void ASI_MFM_MassUploadByBatch_Test(){
        Account a = new Account(name='test');
        insert a;
        Contact c = new Contact(accountid=a.id,firstname='James',lastname='test');
        insert c;
        
        
        test.startTest();
        ASI_MFM_CN_MassUploadByBatchController controller = new ASI_MFM_CN_MassUploadByBatchController();
        
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
        controller.contentFile = blob.valueOf('name,,NumberOfEmployeesAnnualRevenue\rJohn,1,3');
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
        String[] testGetter = controller.StatusMsgs;
        
        test.stopTest();
    }
    
}