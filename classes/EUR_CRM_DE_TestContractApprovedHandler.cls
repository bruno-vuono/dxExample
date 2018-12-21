/*
  @Company:     IP-Converge Data Services, Inc.
  @Description: Test Class for EUR_CRM_DE_ContractApprovedHandler Class.
  @Author:      IPC
  @History:     July 2014 - Created
*/
@isTest(SeeAllData=true)
private with sharing class EUR_CRM_DE_TestContractApprovedHandler{
    private static String mechanicTypeName1 = 'Drinks Menu';
    private static String mechanicTypeName2 = 'Events';

    private static EUR_CRM_Account__c accountEU;
    private static EUR_CRM_Contract__c contract;
    
    private static EUR_CRM_Wine_Spirits__c wineSpirits;
    private static EUR_CRM_Category__c category;
    private static EUR_CRM_Brand__c brand;
    private static EUR_CRM_Quality__c brandQuality;
    
    private static EUR_CRM_Mechanic_Type__c mechType1;
    private static EUR_CRM_Mechanic_Type__c mechType2;
    
    private static EUR_CRM_Contract_Activity_Item__c contractActivity1;
    private static EUR_CRM_Contract_Activity_Item__c contractActivity2;
    
    private static EUR_CRM_Budget__c budget;
    private static EUR_CRM_Budget_Transaction__c initialLoadTransaction;
    
    private static String FY_STR = 'FY15';
    private static String EXTERNAL_ID = 'TEST_'+FY_STR;
    private static Decimal ALLOCATED_BUDGET = 10000;
    private static Decimal CARRY_FWD = 0;
    
    public static void dataInsert1(){
        //Create account
        EUR_CRM_Postal_Code_Territory_Mapping__c thisPostalMap = [SELECT Id FROM EUR_CRM_Postal_Code_Territory_Mapping__c WHERE RecordType.DeveloperName = 'EUR_DE_On_Trade_Postal_Code_Territory_Mapping' LIMIT 1];
        EUR_CRM_Territory__c thisTerritory = [SELECT Id FROM EUR_CRM_Territory__c WHERE RecordType.DeveloperName = 'EUR_DE_Territory' LIMIT 1];
        EUR_CRM_Region__c thisRegion = [SELECT Id FROM EUR_CRM_Region__c WHERE RecordType.DeveloperName = 'EUR_DE_Region' LIMIT 1];
		EUR_CRM_Customer_Taxonomy__c thisCT = [SELECT ID FROM EUR_CRM_Customer_Taxonomy__c WHERE  RecordType.DeveloperName = 'EUR_DE_Customer_Taxonomy' LIMIT 1];   
        EUR_CRM_OP_Action_List_Template__c  thisALT = [SELECT ID FROM EUR_CRM_OP_Action_List_Template__c WHERE RecordType.DeveloperName = 'EUR_DE_OP_Action_List_Template' LIMIT 1];
        
        
        System.Debug('@@TEST - GET Postal Map:' + thisPostalMap);
        System.Debug('@@TEST - GET Territory:' + thisTerritory);
        System.Debug('@@TEST - GET Region:' + thisRegion);    
        System.Debug('@@TEST - GET CT:' + thisCT); 
        System.Debug('@@TEST - GET ActListTemp:' + thisALT); 
        EUR_CRM_DE_TestClassUtilityHelper.initByData(thisRegion,thisTerritory,thisPostalMap,thisCT,thisALT);
        //accountEU = EUR_CRM_DE_TestClassUtilityHelper.euAccount;
        //>>> GET ACCOUNT LIKE THIS! >>>creaEUAccount('testname', TEST_POSTAL , DE_EUACCOUNT_RECORD_TYPE , customerTaxonomy.id);
        //TEST_POSTAL = 12345
        //DE_EUACCOUNT_RECORD_TYPE = DE OFF STD
        //
        accountEU = [SELECT Id,Name,EUR_CRM_Postal_Code__c,EUR_CRM_Territory__c
					FROM EUR_CRM_Account__c WHERE REcordType.DeveloperName = 'EUR_DE_ON_Gastronomy' Limit 1];
        test.StartTest();
        
        
        
        //Create Wine Spirit
        system.debug('@@TEST - dataInsert1: Create wineSpirits');
        wineSpirits = EUR_CRM_TestClassUtilityHelper.createWineSpirits(1, EUR_CRM_DE_TestClassUtilityHelper.DE_WINE_SPIRIT_RECORD_TYPE, 'TEST-0001', 'SPIRITS')[0];
        insert wineSpirits;
        system.assertNotEquals(wineSpirits, null);

        //Create category
        system.debug('@@TEST - dataInsert1: Create category');
        category = EUR_CRM_TestClassUtilityHelper.createCategory(1, EUR_CRM_DE_TestClassUtilityHelper.DE_CATEGORY_RECORD_TYPE, 'TEST-0001', wineSpirits.Id)[0];
        insert category;
        system.assertNotEquals(category, null);
        
        //Create Brand
        system.debug('@@TEST - dataInsert1: Create brand');
        brand = EUR_CRM_TestClassUtilityHelper.createBrand(1, EUR_CRM_DE_TestClassUtilityHelper.DE_BRAND_RECORD_TYPE, 'VODKA', 'TEST-0001', category.Id)[0];
        insert brand;
        system.assertNotEquals(brand, null);
        
        //Create BQ
        system.debug('@@TEST - dataInsert1: Create brandQuality');
        brandQuality = EUR_CRM_TestClassUtilityHelper.createBrandQuality(1, EUR_CRM_DE_TestClassUtilityHelper.DE_QUALITY_RECORD_TYPE, 'Cocktail', 'TEST-0001', brand.Id)[0];
        insert brandQuality;
        system.assertNotEquals(brandQuality, null);
        
        //Create Mechanic Type
        system.debug('@@TEST - dataInsert1: Create mechType1');
        mechType1 = EUR_CRM_TestClassUtilityHelper.createMechType(1, EUR_CRM_DE_TestClassUtilityHelper.DE_MECHANIC_TYPE_RECORD_TYPE, mechanicTypeName1)[0];
        mechType1.EUR_CRM_Grouping_Name__c = 'Germany';
        mechType1.EUR_CRM_Has_Lump_Sum__c = false;
        mechType1.EUR_CRM_Has_Per_BQ__c = true;
        mechType1.EUR_CRM_Lump_Sum_Or_Per_BQ__c  = false;
        mechType1.EUR_CRM_Is_Pro_Rated_by_Month__c = true;
        mechType1.EUR_CRM_Has_Multiple_Activity_Item__c = false;
        insert mechType1;
        
        //Create Mechanic Type
        system.debug('@@TEST - dataInsert1: Create mechType2');
        mechType2 = EUR_CRM_TestClassUtilityHelper.createMechType(1, EUR_CRM_DE_TestClassUtilityHelper.DE_MECHANIC_TYPE_RECORD_TYPE, mechanicTypeName2)[0];
        mechType2.EUR_CRM_Grouping_Name__c = 'Germany';
        mechType2.EUR_CRM_Has_Lump_Sum__c = true;
        mechType2.EUR_CRM_Has_Per_BQ__c = true;
        mechType2.EUR_CRM_Lump_Sum_Or_Per_BQ__c  = false;
        mechType2.EUR_CRM_Is_Pro_Rated_by_Month__c = false;
        mechType2.EUR_CRM_Has_Multiple_Activity_Item__c = true;
        insert mechType2;

        //Create Budget
        budget = EUR_CRM_DE_TestClassUtilityHelper.createBudget(EUR_CRM_DE_TestClassUtilityHelper.DE_BUDGET_RECORD_TYPE,
                                                    UserInfo.getUserId(), 
                                                    FY_STR, EXTERNAL_ID,
                                                    ALLOCATED_BUDGET, CARRY_FWD);
        insert budget;

        //Create Contract
        system.debug('@@TEST - dataInsert1: Create Contract');
        contract = EUR_CRM_TestClassUtilityHelper.createContracts(1, EUR_CRM_DE_TestClassUtilityHelper.DE_CONTRACT_RECORD_TYPE, accountEU.Id, date.today(), date.today().addDays(180))[0];
        contract.EUR_CRM_Contract_Approved_Date__c = null;
        insert contract;
        
        // Update Contract
        system.debug('@@TEST - dataInsert1: update Contract');
        contract.EUR_CRM_Contract_Approved_Date__c = date.today()+10;
        contract.EUR_CRM_Contract_Type__c = 'Standard Contract';
        //contract.EUR_CRM_Status__c='Draft'; 						//REMOVE
        //contract.EUR_CRM_Contract_Type__c = 'Standard Contract'; 	//REMOVE
        //contract.EUR_CRM_Status__c='Approved';
        contract.EUR_CRM_Total_Pro_Rated_Amount__c = 10;
        contract.EUR_CRM_Budget__c = budget.Id;
        
        update contract;
 		test.StopTest();
        system.debug('@@TEST - dataInsert1: Create ContractActivity1');
        //Create Contract Activity1
        contractActivity1 = EUR_CRM_DE_TestClassUtilityHelper.createContractActivityItem(null, contract.Id, mechType1.Id);
        contractActivity1.EUR_CRM_Amount__c = 100;
        insert contractActivity1;
        
        //Create Contract Activity 2
        system.debug('@@TEST - dataInsert1: Create ContractActivity2');
        contractActivity2 = EUR_CRM_DE_TestClassUtilityHelper.createContractActivityItem(null, contract.Id, mechType2.Id);
        contractActivity2.EUR_CRM_Name__c = 'Test';
        insert contractActivity2;
        
        
        //Create Transaction Initial Budget Load
        system.debug('@@TEST - dataInsert1: Create initialLoadTransaction');
        initialLoadTransaction = EUR_CRM_DE_TestClassUtilityHelper.createBudgetInitialLoad(EUR_CRM_DE_TestClassUtilityHelper.DE_TRANSACTION_RECORD_TYPE,
                                    budget.Id, 10000);
        insert initialLoadTransaction;
    }


    static void testMethod1(){
        EUR_CRM_DE_TestClassUtilityHelper.initUsersOntrade();
        
        Profile p = [SELECT Id FROM Profile WHERE Name ='EUR DE ON Trade User' LIMIT 1]; 
        UserRole r = [select id from UserRole where Name ='EUR DE GSL Nord / East' LIMIT 1];
        User u = [Select Id from User where userroleid =: r.id AND ProfileId =: p.Id LIMIT 1];
        Id CurrentUserId = UserInfo.getUserId();
        User cu = [Select Id FROM User WHERE Id =: UserInfo.getUserId()];
        
        system.runAs(u){
            dataInsert1();
            //contract.EUR_CRM_Status__c = 'Approved';
        	//update contract
        }
        //system.runAs(cu){
        //	teststep2();
        //}

        
       // system.runAs(EUR_CRM_DE_TestClassUtilityHelper.salesRepUser){
       //     contract.EUR_CRM_Contract_Approved_Date__c = Date.Today();
       //     update contract;
       //     
       //     contract.EUR_CRM_Contract_Approved_Date__c = Date.Today().addDays(10);
       // }
    }
    
    static testMethod void testStep2(){
        //Create account
        EUR_CRM_Postal_Code_Territory_Mapping__c thisPostalMap = [SELECT Id FROM EUR_CRM_Postal_Code_Territory_Mapping__c WHERE RecordType.DeveloperName = 'EUR_DE_On_Trade_Postal_Code_Territory_Mapping' LIMIT 1];
        EUR_CRM_Territory__c thisTerritory = [SELECT Id FROM EUR_CRM_Territory__c WHERE RecordType.DeveloperName = 'EUR_DE_Territory' LIMIT 1];
        EUR_CRM_Region__c thisRegion = [SELECT Id FROM EUR_CRM_Region__c WHERE RecordType.DeveloperName = 'EUR_DE_Region' LIMIT 1];
		EUR_CRM_Customer_Taxonomy__c thisCT = [SELECT ID FROM EUR_CRM_Customer_Taxonomy__c WHERE  RecordType.DeveloperName = 'EUR_DE_Customer_Taxonomy' LIMIT 1];   
        EUR_CRM_OP_Action_List_Template__c  thisALT = [SELECT ID FROM EUR_CRM_OP_Action_List_Template__c WHERE RecordType.DeveloperName = 'EUR_DE_OP_Action_List_Template' LIMIT 1];
        
        
        System.Debug('@@TEST - GET Postal Map:' + thisPostalMap);
        System.Debug('@@TEST - GET Territory:' + thisTerritory);
        System.Debug('@@TEST - GET Region:' + thisRegion);    
        System.Debug('@@TEST - GET CT:' + thisCT); 
        System.Debug('@@TEST - GET ActListTemp:' + thisALT); 
        EUR_CRM_DE_TestClassUtilityHelper.initByData(thisRegion,thisTerritory,thisPostalMap,thisCT,thisALT);
        
        Integer fiscalYear = System.Today().year();
        
        If (System.Today().month() >= 7)
        {
            fiscalYear += 1;
        }
        
        EUR_CRM_Contract__c testContract = [SELECT Id,EUR_CRM_Contract_Type__c ,EUR_CRM_Account__r.Name,EUR_CRM_Start_Date__c FROM EUR_CRM_Contract__c WHERE EUR_CRM_Contract_Type__c = 'Standard Contract' AND RecordType.DeveloperName = 'EUR_DE_Contract' AND  CALENDAR_YEAR(EUR_CRM_Start_Date__c) >= : fiscalYear  LIMIT 1];
        System.Debug('@@testContract:' + testContract);
        List<EUR_CRM_Contract__c> contractList = EUR_CRM_DE_AttachContractPDF.retrieveContracts(testContract.Id);
        String IdString = EUR_CRM_DE_AttachContractPDF.formatContractIds(contractList);
        EUR_CRM_DE_AttachContractPDF.attachPDF(IdString,UserInfo.getSessionId());
    }

    

}