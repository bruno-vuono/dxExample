@istest


//ASI_CRM_KR_SetVisitationPlanStatusCtler
//ASI_CRM_KR_VisitationPlan_TriggerClass
//ASI_CRM_KR_VisitationPlanEditController
//ASI_CRM_KR_VisitationPlanHomeCtrl
//ASI_CRM_KR_RequiredCallsFuncCls
public class ASI_CRM_KR_VisitationPlanTestClass {
    
    
    static testMethod void TestVisitationPlanEditClass(){
        date systoday= system.today();
        Map<Integer, string> MonthMap = new Map<Integer, string>{ 1 => 'January',2 => 'February',3 => 'March',4 => 'April',5 => 'May',6 => 'June',7 => 'July', 8 => 'August',9 => 'September',10 => 'October',11 => 'November',12 => 'December'};
            
        userrole Role_Test= new userrole(Name='XXXTrade Marketing',developerName='test');
        insert Role_Test;
        
        user u = [select userRole.developerName, ASI_MFM_Country__c,UserRoleid,CompanyName,ASI_KOR_User_Branch_Code__c from user where id = :userInfo.getUserId() limit 1]; 
        u.UserRoleid =Role_Test.id;
        u.CompanyName = 'Pernod Ricard Korea';
        u.ASI_KOR_User_Branch_Code__c='530';
        u.ASI_MFM_Country__c  = 'KR';
        update u;
        
        System.runAs(u){ 
            //Holiday 
            ASI_CRM_Holiday__c holiday= new ASI_CRM_Holiday__c(name='Test Holiday',recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_Holiday__cASI_CRM_KR_Holiday'),ASI_CRM_Date_From__c=system.today(),ASI_CRM_Date_To__c=system.today(),ASI_CRM_Holiday_Type__c='Public');
            insert holiday;
            
            List<ASI_CRM_KR_Required_Number_of_Calls__c> RNOCList= new List<ASI_CRM_KR_Required_Number_of_Calls__c>();
            RNOCList.add(new ASI_CRM_KR_Required_Number_of_Calls__c(name='1',ASI_CRM_KR_Account_Record_Type__c='ASI_KOR_Venue',ASI_CRM_KR_Branch_Code__c='530,523,521,515,516',ASI_CRM_KR_Grade__c='A',ASI_CRM_KR_No_of_Required_Visitation__c=3 ) );
            RNOCList.add(new ASI_CRM_KR_Required_Number_of_Calls__c(name='2',ASI_CRM_KR_Account_Record_Type__c='ASI_KOR_Wholesaler',ASI_CRM_KR_Branch_Code__c='530,523,521,515,516',ASI_CRM_KR_Grade__c='T1',ASI_CRM_KR_No_of_Required_Visitation__c=3,ASI_CRM_KR_Strategic_Outlet_Mapping__c='High Profile Profit Accelarators' ) );
            
            insert RNOCList;
            
            
            //color custom setting 
            ASI_KR_Setting__c KRColor= new ASI_KR_Setting__c(name='Test',ASI_CRM_Color__c='000000',ASI_CRM_Type__c='VisitationPlan');
            insert KRColor; 
            
            
            // Visitation Plan Header
            List<ASI_KOR_Visitation_Plan__c> vpList= new List<ASI_KOR_Visitation_Plan__c>();
            ASI_KOR_Visitation_Plan__c vp= new ASI_KOR_Visitation_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan__cASI_CRM_KR_Visitation_Plan'), ownerid=u.id,ASI_KOR_Month__c=MonthMap.get(systoday.month()),ASI_KOR_Year__c=String.valueOf(systoday.year()),Name = 'Default Plan for Mobile App');
            vpList.add(vp);
            ASI_KOR_Visitation_Plan__c vp1= new ASI_KOR_Visitation_Plan__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_KOR_Visitation_Plan__cASI_CRM_KR_Visitation_Plan'),ownerid=u.id,ASI_KOR_Month__c=MonthMap.get(systoday.month()),ASI_KOR_Year__c=String.valueOf(systoday.year()-1),Name = 'Default Plan for Mobile App');
            vpList.add(vp1);
            
            insert vpList;
            
            
            // Test class :  ASI_CRM_KR_VisitationPlan_TriggerClass : trigger ASI_KOR_VisitationPlan_BeforeDelete 
            delete vp1;
            
            
            //Account 
            List<Account> accToInsert = new List<Account>();
            Account acc1 = new Account(ownerid=u.id,recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_KOR_Venue'), Name='Name1',ASI_KOR_Venue_Status__c='Active',ASI_KOR_Grade__c='A');           
            accToInsert.add(acc1);
            Account acc2 = new Account(ownerid=u.id,recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_KOR_Wholesaler'),Name='Name2',ASI_KOR_Venue_Status__c='Active');           
            accToInsert.add(acc2);
            Account acc3 = new Account(ownerid=u.id,recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_KOR_Wholesaler'),Name='Name3',ASI_KOR_Venue_Status__c='Active');           
            accToInsert.add(acc3);
            Account acc4 = new Account(ownerid=u.id,recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_KOR_Wholesaler'),Name='Name4',ASI_KOR_Venue_Status__c='Active');           
            accToInsert.add(acc4);
            insert accToInsert;
            
            
            List <ASI_CRM_AccountsAdditionalField__c> CustomerList = new List <ASI_CRM_AccountsAdditionalField__c>();
            ASI_CRM_AccountsAdditionalField__c cus1= new ASI_CRM_AccountsAdditionalField__c (ASI_CRM_Account__c=acc1.id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_KR_Venue'),ownerid=u.id, name='Customer1') ;
            CustomerList.add(cus1);
            ASI_CRM_AccountsAdditionalField__c cus2= new ASI_CRM_AccountsAdditionalField__c (ASI_CRM_Account__c=acc2.id,recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_KR_Wholesaler'),ownerid=u.id, name='Customer2',ASI_CRM_Strategic_Outlet_Mapping__c='High Profile Profit Accelarators') ;
            CustomerList.add(cus2);
            insert CustomerList;
            
            
            //Visitation Plan Detail Line
            List<ASI_KOR_Visitation_Plan_Detail__c> visitPlanDetails = new List<ASI_KOR_Visitation_Plan_Detail__c>();
            ASI_KOR_Visitation_Plan_Detail__c KORvpd=new ASI_KOR_Visitation_Plan_Detail__c(ASI_KOR_Visitation_Plan__c=vp.id,ASI_KOR_Wholesaler__c=acc1.id,ASI_KOR_Visit_Date__c=system.today());
            visitPlanDetails.add(KORvpd);
            
            insert visitPlanDetails;
            
            ApexPages.StandardSetController stdSetConroller = new ApexPages.StandardSetController(visitPlanDetails);
            Test.startTest();
            
            
            //Test class :  ASI_CRM_KR_VisitationPlanEditController 
            
            PageReference testPage = Page.ASI_CRM_KR_VisitationPlanEditPage;
            Map<String, String> pageParams = testPage.getParameters();
            pageParams.put('id', vp.Id);
            Test.setCurrentPageReference(testPage);
            
            ASI_CRM_KR_VisitationPlanEditController testController = new ASI_CRM_KR_VisitationPlanEditController(stdSetConroller);
            PageReference redirectPage=testController.pageLoad();
            List<ASI_CRM_KR_VisitationPlanEditController.AccountObj> TestAccountObjList=ASI_CRM_KR_VisitationPlanEditController.findAccount('',u.id);
            
            List<ASI_KOR_Visitation_Plan_Detail__c> Planlist= new List<ASI_KOR_Visitation_Plan_Detail__c>();
            Planlist.add(new ASI_KOR_Visitation_Plan_Detail__c(ASI_KOR_Visitation_Plan__c=vp.id,ASI_KOR_Wholesaler__c=acc2.id,ASI_KOR_Visit_Date__c=system.today()));
            Planlist.add(new ASI_KOR_Visitation_Plan_Detail__c(ASI_KOR_Visitation_Plan__c=vp.id,ASI_KOR_Wholesaler__c=acc3.id,ASI_KOR_Visit_Date__c=system.today()));
            ASI_KOR_Visitation_Plan_Detail__c vpd= new ASI_KOR_Visitation_Plan_Detail__c(ASI_KOR_Visitation_Plan__c=vp.id,ASI_KOR_Wholesaler__c=acc4.id,ASI_KOR_Visit_Date__c=system.today());
            Planlist.add(vpd);
            
            
            //Normal Save
            List<String> DeList = new List<String>();
            DeList.add(KORvpd.id);
            String testmesg=ASI_CRM_KR_VisitationPlanEditController.updatePlan(Planlist,DeList,vp.id, 'Save','0');
            testmesg= ASI_CRM_KR_VisitationPlanEditController.ResetProcess(vp.id);
            
            
            //Confirm Save
            Planlist= new List<ASI_KOR_Visitation_Plan_Detail__c>();
            Planlist.add(new ASI_KOR_Visitation_Plan_Detail__c(ASI_KOR_Visitation_Plan__c=vp.id,ASI_KOR_Wholesaler__c=acc2.id,ASI_KOR_Visit_Date__c=system.today()));
            DeList = new List<String>();
            testmesg=ASI_CRM_KR_VisitationPlanEditController.updatePlan(Planlist,DeList,vp.id, 'Confirm','0');
            
            List<ASI_CRM_KR_VisitationPlanEditController.VisitationPlanDetail> TestList=ASI_CRM_KR_VisitationPlanEditController.findVisitationPlanDetail('');		  
			
            
           //Test Class For ASI_CRM_KR_VisitationPlanHomeCtrl
            ASI_CRM_KR_VisitationPlanHomeCtrl con = new ASI_CRM_KR_VisitationPlanHomeCtrl();
            List<ASI_CRM_KR_VisitationPlanHomeCtrl.PublicHolidays> PublicHolidays = ASI_CRM_KR_VisitationPlanHomeCtrl.findHolidays('');
            List<ASI_CRM_KR_VisitationPlanHomeCtrl.VisitationPlanDetail> VisitationPlanDetail = ASI_CRM_KR_VisitationPlanHomeCtrl.findVisitationPlanDetail('WHERE ASI_KOR_Wholesaler__c != null','','exclude');
            VisitationPlanDetail = ASI_CRM_KR_VisitationPlanHomeCtrl.findVisitationPlanDetail('WHERE ASI_KOR_Wholesaler__c != null','','');
            List<SelectOption> SelectOptionList= con.getUserItems();
            
            
            ////Test class for : ASI_CRM_KR_SetVisitationPlanStatusCtler
             PageReference pageRef = new Pagereference('/apex/ASI_MFM_PODetailPage');
            Test.setCurrentPage(pageRef);
            
            ASI_CRM_KR_SetVisitationPlanStatusCtler con2 = new ASI_CRM_KR_SetVisitationPlanStatusCtler(new ApexPages.StandardController(vp));
            con2.setStatus();
        
        
            Test.stopTest();
            
        }
    }
    //Test ASI_CRM_KR_RequiredCallsFuncCls 

}