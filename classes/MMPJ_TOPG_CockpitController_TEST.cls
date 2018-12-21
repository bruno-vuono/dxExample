@isTest
private class MMPJ_TOPG_CockpitController_TEST
{
    private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
    @testSetup static void testDataCreation()
    {
        // BMC
        
       
        MMPJ_TOPG_Brand__c brand = new MMPJ_TOPG_Brand__c(Name='Mumm');
         insert brand;
        
        MMPJ_TOPG_Market__c market = new MMPJ_TOPG_Market__c(Name='France');        
        insert market;
         //BTO=> MAJ BMC : Suppresion champ "Brand & Market" dans BMC==== //
         insert new MMPJ_TOPG_BMC__c(Name='testBMC', MMPJ_TOPG_BISFolder__c='testFolder');
       // insert new MMPJ_TOPG_BMC__c(Name='testBMC', MMPJ_TOPG_Market__c=market.Id, MMPJ_TOPG_BISFolder__c='testFolder');
        //create IWSR
        List<sObject> iwsr = Test.loadData(MMPJ_TOPG_IWSRData__c.sObjectType, 'MMPJ_TOPG_testIWSR');
        // //create VOL
        List<sObject> vols = Test.loadData(MMPJ_TOPG_PRISMADataVol__c.sObjectType, 'MMPJ_TOPG_testVOLs');
        // //create PL
        List<sObject> pls = Test.loadData(MMPJ_TOPG_PRISMADataPL__c.sObjectType, 'MMPJ_TOPG_testPLs');
        //create Effects
        List<sObject> effects = Test.loadData(MMPJ_TOPG_PRISMADataEffect__c.sObjectType, 'MMPJ_TOPG_testEffectss');

        List<MMPJ_TOPG_PL_Correspondence__c> plCorrespondences = new List<MMPJ_TOPG_PL_Correspondence__c>();
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='R072', MMPJ_TOPG_LABEL__C='Other Consumer A&P',MMPJ_TOPG_ORDER__C=6));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='R071', MMPJ_TOPG_LABEL__C='Media',MMPJ_TOPG_ORDER__C=5));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='RSTT09', MMPJ_TOPG_LABEL__C='CAAP S/T Marchés',MMPJ_TOPG_ORDER__C=8));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='VOL_CEQ', MMPJ_TOPG_LABEL__C='Volume KC9L',MMPJ_TOPG_ORDER__C=1));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='R073', MMPJ_TOPG_LABEL__C='Trade A&P',MMPJ_TOPG_ORDER__C=4));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='RSTT06', MMPJ_TOPG_LABEL__C='Contribution Margin S/T',MMPJ_TOPG_ORDER__C=3));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='RT070', MMPJ_TOPG_LABEL__C='Total A&P',MMPJ_TOPG_ORDER__C=7));
        plCorrespondences.add(new MMPJ_TOPG_PL_Correspondence__c(NAME='RT02', MMPJ_TOPG_LABEL__C='Net Sales',MMPJ_TOPG_ORDER__C=2));
        insert plCorrespondences;
        
        //Add params for PowerBI
        MMPJ_TOPG_Param__c param = new MMPJ_TOPG_Param__c();
        param.Name= 'PowerBI';
        //param.MMPJ_TOPG_IWSR_Url__c= 'https://app.powerbi.com/view?r=eyJrIjoiYWEzMTI5MzItOTQ1Zi00YzU2LThlZDktYWYwM2I2NmExNWFlIiwidCI6IjkzM2M5Y2JlLTM1ZDMtNDQxNi1hYmJkLWRkZDFiY2E1ODc5YyIsImMiOjEwfQ%3D%3D';
        //param.MMPJ_TOPG_Prisma_Url__c= 'https://app.powerbi.com/view?r=eyJrIjoiYzJkMjViNjMtMDIxYy00MGI3LWE3MWUtMGY5M2QwYzM2Nzg5IiwidCI6IjkzM2M5Y2JlLTM1ZDMtNDQxNi1hYmJkLWRkZDFiY2E1ODc5YyIsImMiOjEwfQ%3D%3D';
    	param.MMPJ_TOPG_Prisma_ReportID__c = '10b1a1d0-7fdb-462e-8408-2d2703d2068d';
        param.MMPJ_TOPG_IWSR_ReportID__c = 'fd229f02-6e50-47eb-a955-ad784ba2c703';
        insert param;        
    }

    @isTest static void test_Cockpit()
    {
     

        //Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        // Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator']; 
        // PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'MMPJ_Top_Gun_Full_Acess_User'];

       // User testUser = new User(Username = mailPrefix+'-NPLsuper2visor@pernod-ricard.com', email = mailPrefix+'-super2visor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
       // insert testUser;

       // PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = ps.Id);
       // insert psa;
       // System.runAs(testUser)
        
            PageReference cockpit = page.MMPJ_TOPG_Cockpit;
            Test.setCurrentPage(cockpit);

            MMPJ_TOPG_CockpitController cockpitCtrl = new MMPJ_TOPG_CockpitController();

            Test.startTest();
           // System.debug(cockpitCtrl.allBrands);
            cockpitCtrl.allMarkets.add(new SelectOption('France', 'France'));
            cockpitCtrl.allMarkets.add(new SelectOption('Japon', 'Japon'));
            //cockpitCtrl.allMarkets.add(new SelectOption(All Markets, All Markets));
            //System.debug(cockpitCtrl.allMarkets);
            //cockpitCtrl.applyFilters();

            cockpitCtrl.selectedMarkets.add(new SelectOption('France', 'France'));
            cockpitCtrl.selectedBrandVFP = 'Martell';
           // cockpitCtrl.applyFilters();
			
            cockpitCtrl.selectedMarkets.clear();
            cockpitCtrl.selectedMarkets.add(new SelectOption('Japon', 'Japon'));
            cockpitCtrl.selectedMarketVFP = 'Japon';
            cockpitCtrl.selectedBrands.add(new SelectOption('Martell', 'Martell'));
            cockpitCtrl.InteractionSelectedDate = system.today();
           // cockpitCtrl.applyFilters();           

            cockpitCtrl.selectedMarkets.clear();
            cockpitCtrl.selectedBrands.clear();
           // cockpitCtrl.applyFilters();
            Test.stopTest();
     
    }
}