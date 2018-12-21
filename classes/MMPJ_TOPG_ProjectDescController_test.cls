@isTest
public class MMPJ_TOPG_ProjectDescController_test{
    private static  Datetime myDT = Datetime.now();
    private static String  mailPrefix = myDT.format('ddMMyyyy');
 static testMethod void myUnitTest() {
 Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        User u = new User(Username = mailPrefix+'-test-supervisor@pernod-ricard.com', email = mailPrefix+'-test-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
        insert u;
        
        Contact c = new Contact();
        c.LastName='Test Contact';
        c.FirstName='Test Contact';
        insert c;
         //create market 
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c();
        market.Name='France ID';
        insert market;
        //create brand 
        MMPJ_TOPG_Brand__c brand= new MMPJ_TOPG_brand__c();
        brand.Name='testBrand';
        insert brand;
        
         //insert project 
        MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
        project.name = 'testProject';
        project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project.MMPJ_TOPG_ProjectOwner__c=u.id;  
        insert project;
        
        
        MMPJ_TOPG_Project__c project2 = new MMPJ_TOPG_Project__c();
        project2.name = 'testProject2';
        project2.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project2.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project2.MMPJ_TOPG_ProjectOwner__c=u.id;
        project2.MMPJ_TOPG_ProjectType__c='Central Development';
        
        
        MMPJ_TOPG_Project__c project3 = new MMPJ_TOPG_Project__c();
        project3.name = 'testProject3';
        project3.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
        project3.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
        project3.MMPJ_TOPG_ProjectOwner__c=u.id;
        project3.MMPJ_TOPG_ProjectType__c='Central Development';
        
        //product mix
        MMPJ_TOPG_ProductMix__c prodMix = new MMPJ_TOPG_ProductMix__c();
        prodMix.Name='product_mix';
        insert prodMix; 
        
        // project market 
        MMPJ_TOPG_Project_Market__c projMarket = new MMPJ_TOPG_Project_Market__c ();
        projMarket.MMPJ_TOPG_Project__c=project.id;
        projMarket.MMPJ_TOPG_Market__c = market.id;
        insert projMarket; 
        system.debug(' projMarketin test classs == '+project.id);
        // project product 
        MMPJ_TOPG_Project_Product__c projectProd = new MMPJ_TOPG_Project_Product__c();
        projectProd.MMPJ_TOPG_Project__c=project.id;
        projectProd.MMPJ_TOPG_Product__c=prodMix.id;
        insert projectProd;
        system.debug(' projectProduct in test classs == '+projectProd);
        
        // project Brand 
        MMPJ_TOPG_Project_Brand__c projBrand = new MMPJ_TOPG_Project_Brand__c();
        projBrand.MMPJ_TOPG_Project__c=project.id;
        projBrand.MMPJ_TOPG_Brand__c = brand.id;
        insert projBrand ; 
        // insert project team member 
        MMPJ_TOPG_ProjectTeamMember__c teamMember = new MMPJ_TOPG_ProjectTeamMember__c();
        teamMember.MMPJ_TOPG_Title__c = 'team member 1';
        teamMember.MMPJ_TOPG_User__c = u.id;
        teamMember.MMPJ_TOPG_Who__c = u.id;
        teamMember.MMPJ_TOPG_Project__c = project.id;
        insert teamMember;
        
        MMPJ_TOPG_ProjectTeamMember__c teamMember2 = new MMPJ_TOPG_ProjectTeamMember__c();
        teamMember2.MMPJ_TOPG_Title__c = 'team member 2';
        teamMember2.MMPJ_TOPG_Contact__c= c.id;
        teamMember2.MMPJ_TOPG_Who__c = c.id;
        teamMember2.MMPJ_TOPG_Project__c = project.id;
        insert teamMember2;
        
          MMPJ_TOPG_ProjectDescriptionController mmpj = new MMPJ_TOPG_ProjectDescriptionController();
           Test.startTest();
           mmpj.project=project2;
           Boolean bool =mmpj.ShowSaveMessage;
            
           MMPJ_TOPG_ProjectDescriptionController.WrapperProjectTeamList wrapper = new MMPJ_TOPG_ProjectDescriptionController.WrapperProjectTeamList();
           wrapper.TeamMemberName='test userss';
           wrapper.SelectValue='User';
           wrapper.ProjectTeam = teamMember;
           
           MMPJ_TOPG_ProjectDescriptionController.WrapperProjectTeamList wrapper2 = new MMPJ_TOPG_ProjectDescriptionController.WrapperProjectTeamList();
           wrapper2.TeamMemberName='test Contactsss';
           wrapper2.SelectValue='Contact';
           wrapper2.ProjectTeam = teamMember2;
           
           
           mmpj.ListWrapperProjectTeam.add(wrapper);
           mmpj.ListWrapperProjectTeam.add(wrapper2);
           
           mmpj.SelectedMarket=new List <selectOption>();
           mmpj.SelectedMarket.add(new SelectOption(market.id,market.name));
           mmpj.SelectedBrand=new List <selectOption>();
           mmpj.SelectedBrand.add(new SelectOption(brand.id,brand.name));
           mmpj.SelectedProduct.add(new SelectOption(prodMix.id,prodMix.name));
           //mmpj.listSelectedProduct.add(projectProduct);
            mmpj.SaveProject(); 
            mmpj.SaveProjectAndClose();
            mmpj.LeavingDescription();
            mmpj.cancel();
            //mmpj.DelProjectTeam();
            mmpj.addProjectTeam();
            mmpj.project =project3 ;
             mmpj.SelectedMarket.clear();
             mmpj.SelectedBrand.clear();
            mmpj.SaveProject();
           Test.stopTest();
 }
}