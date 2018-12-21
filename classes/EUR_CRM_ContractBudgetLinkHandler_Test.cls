/*
  @Company:     IP-Converge Data Services, Inc.
  @Description: Test Class for EUR_CRM_ContractBudgetLinkHandler Class.
  @Author:      IPC
  @History:     July 2014 - Created
*/
@isTest

private with sharing class EUR_CRM_ContractBudgetLinkHandler_Test{
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
    private static Organization fiscalYearOrgDetails;
    
    public static void dataInsert1(){
        //Create account
        EUR_CRM_DE_TestClassUtilityHelper.initData();
        accountEU = EUR_CRM_DE_TestClassUtilityHelper.euAccount;
        
        //Create Wine Spirit
        wineSpirits = EUR_CRM_TestClassUtilityHelper.createWineSpirits(1, EUR_CRM_DE_TestClassUtilityHelper.DE_WINE_SPIRIT_RECORD_TYPE, 'TEST-0001', 'SPIRITS')[0];
        insert wineSpirits;
        system.assertNotEquals(wineSpirits, null);

        //Create category
        category = EUR_CRM_TestClassUtilityHelper.createCategory(1, EUR_CRM_DE_TestClassUtilityHelper.DE_CATEGORY_RECORD_TYPE, 'TEST-0001', wineSpirits.Id)[0];
        insert category;
        system.assertNotEquals(category, null);
        
        //Create Brand
        brand = EUR_CRM_TestClassUtilityHelper.createBrand(1, EUR_CRM_DE_TestClassUtilityHelper.DE_BRAND_RECORD_TYPE, 'VODKA', 'TEST-0001', category.Id)[0];
        insert brand;
        system.assertNotEquals(brand, null);
        
        //Create BQ
        brandQuality = EUR_CRM_TestClassUtilityHelper.createBrandQuality(1, EUR_CRM_DE_TestClassUtilityHelper.DE_QUALITY_RECORD_TYPE, 'Cocktail', 'TEST-0001', brand.Id)[0];
        insert brandQuality;
        system.assertNotEquals(brandQuality, null);
        
        //Create Mechanic Type
        mechType1 = EUR_CRM_TestClassUtilityHelper.createMechType(1, EUR_CRM_DE_TestClassUtilityHelper.DE_MECHANIC_TYPE_RECORD_TYPE, mechanicTypeName1)[0];
        mechType1.EUR_CRM_Grouping_Name__c = 'Germany';
        mechType1.EUR_CRM_Has_Lump_Sum__c = false;
        mechType1.EUR_CRM_Has_Per_BQ__c = true;
        mechType1.EUR_CRM_Lump_Sum_Or_Per_BQ__c  = false;
        mechType1.EUR_CRM_Is_Pro_Rated_by_Month__c = true;
        mechType1.EUR_CRM_Has_Multiple_Activity_Item__c = false;
        insert mechType1;
        
        //Create Mechanic Type
        mechType2 = EUR_CRM_TestClassUtilityHelper.createMechType(1, EUR_CRM_DE_TestClassUtilityHelper.DE_MECHANIC_TYPE_RECORD_TYPE, mechanicTypeName2)[0];
        mechType2.EUR_CRM_Grouping_Name__c = 'Germany';
        mechType2.EUR_CRM_Has_Lump_Sum__c = true;
        mechType2.EUR_CRM_Has_Per_BQ__c = true;
        mechType2.EUR_CRM_Lump_Sum_Or_Per_BQ__c  = false;
        mechType2.EUR_CRM_Is_Pro_Rated_by_Month__c = false;
        mechType2.EUR_CRM_Has_Multiple_Activity_Item__c = true;
        insert mechType2;

        //Create Contract
        contract = EUR_CRM_TestClassUtilityHelper.createContracts(1, EUR_CRM_DE_TestClassUtilityHelper.DE_CONTRACT_RECORD_TYPE, accountEU.Id, date.today(), date.today().addDays(30))[0];
        insert contract;

        contract.EUR_CRM_Start_Date__c =   date.today().addDays(30);
        update contract;

        //Create Budget
        budget = EUR_CRM_DE_TestClassUtilityHelper.createBudget(EUR_CRM_DE_TestClassUtilityHelper.DE_BUDGET_RECORD_TYPE,
                                                    UserInfo.getUserId(), 
                                                    determineFiscalYear(contract.EUR_CRM_Start_Date__c), EXTERNAL_ID,
                                                    ALLOCATED_BUDGET, CARRY_FWD);
        insert budget;
        
        //Create Transaction Initial Budget Load
        initialLoadTransaction = EUR_CRM_DE_TestClassUtilityHelper.createBudgetInitialLoad(EUR_CRM_DE_TestClassUtilityHelper.DE_TRANSACTION_RECORD_TYPE,
                                    budget.Id, 10000);
        insert initialLoadTransaction;
    }

    public static void dataInsert2(){
        //Create account
//        EUR_CRM_DE_TestClassUtilityHelper.initData();
//        accountEU = EUR_CRM_DE_TestClassUtilityHelper.euAccount;
        createZAaccount();

        //Create Wine Spirit
        wineSpirits = EUR_CRM_TestClassUtilityHelper.createWineSpirits(1, EUR_CRM_DE_TestClassUtilityHelper.DE_WINE_SPIRIT_RECORD_TYPE, 'TEST-0001', 'SPIRITS')[0];
        insert wineSpirits;
        system.assertNotEquals(wineSpirits, null);

        //Create category
        category = EUR_CRM_TestClassUtilityHelper.createCategory(1, EUR_CRM_DE_TestClassUtilityHelper.DE_CATEGORY_RECORD_TYPE, 'TEST-0001', wineSpirits.Id)[0];
        insert category;
        system.assertNotEquals(category, null);
        
        //Create Brand
        brand = EUR_CRM_TestClassUtilityHelper.createBrand(1, EUR_CRM_DE_TestClassUtilityHelper.DE_BRAND_RECORD_TYPE, 'VODKA', 'TEST-0001', category.Id)[0];
        insert brand;
        system.assertNotEquals(brand, null);
        
        //Create BQ
        brandQuality = EUR_CRM_TestClassUtilityHelper.createBrandQuality(1, EUR_CRM_DE_TestClassUtilityHelper.DE_QUALITY_RECORD_TYPE, 'Cocktail', 'TEST-0001', brand.Id)[0];
        insert brandQuality;
        system.assertNotEquals(brandQuality, null);
        
        //Create Mechanic Type
        mechType1 = EUR_CRM_TestClassUtilityHelper.createMechType(1, EUR_CRM_DE_TestClassUtilityHelper.DE_MECHANIC_TYPE_RECORD_TYPE, mechanicTypeName1)[0];
        mechType1.EUR_CRM_Grouping_Name__c = 'Germany';
        mechType1.EUR_CRM_Has_Lump_Sum__c = false;
        mechType1.EUR_CRM_Has_Per_BQ__c = true;
        mechType1.EUR_CRM_Lump_Sum_Or_Per_BQ__c  = false;
        mechType1.EUR_CRM_Is_Pro_Rated_by_Month__c = true;
        mechType1.EUR_CRM_Has_Multiple_Activity_Item__c = false;
        insert mechType1;
        
        //Create Mechanic Type
        mechType2 = EUR_CRM_TestClassUtilityHelper.createMechType(1, EUR_CRM_DE_TestClassUtilityHelper.DE_MECHANIC_TYPE_RECORD_TYPE, mechanicTypeName2)[0];
        mechType2.EUR_CRM_Grouping_Name__c = 'Germany';
        mechType2.EUR_CRM_Has_Lump_Sum__c = true;
        mechType2.EUR_CRM_Has_Per_BQ__c = true;
        mechType2.EUR_CRM_Lump_Sum_Or_Per_BQ__c  = false;
        mechType2.EUR_CRM_Is_Pro_Rated_by_Month__c = false;
        mechType2.EUR_CRM_Has_Multiple_Activity_Item__c = true;
        insert mechType2;

        //Create Contract
        contract = EUR_CRM_TestClassUtilityHelper.createContracts(1, 'EUR ZA Outlet Contract', accountEU.Id, date.today().addDays(180), date.today().addDays(360))[0];
//        contract.EUR_CRM_Country_Code__c = 'EUR ZA Outlet Contract';
        insert contract;

        contract.EUR_CRM_Start_Date__c =   date.today().addDays(30);
        update contract;

        //Create Budget
        budget = EUR_CRM_DE_TestClassUtilityHelper.createBudget(EUR_CRM_DE_TestClassUtilityHelper.DE_BUDGET_RECORD_TYPE,
                                                    UserInfo.getUserId(), 
                                                    determineFiscalYear(contract.EUR_CRM_Start_Date__c), EXTERNAL_ID,
                                                    ALLOCATED_BUDGET, CARRY_FWD);
        insert budget;
        
        //Create Transaction Initial Budget Load
        initialLoadTransaction = EUR_CRM_DE_TestClassUtilityHelper.createBudgetInitialLoad(EUR_CRM_DE_TestClassUtilityHelper.DE_TRANSACTION_RECORD_TYPE,
                                    budget.Id, 10000);
        insert initialLoadTransaction;
    }
    
    static testMethod void testContractBuilder1(){
        EUR_CRM_DE_TestClassUtilityHelper.initUsersOntrade();
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.regionalUser){
            test.StartTest();
            
            dataInsert1();
            EUR_CRM_ContractBudgetLinkHandler handler = new EUR_CRM_ContractBudgetLinkHandler();
            handler.fiscalYearOrgDetails = EUR_CRM_BudgetUtil.retrieveFiscalYearOrg();
            handler.determineFiscalYear(System.today());
            handler.determineFiscalYear(null);

            //insert contract;
            test.StopTest();
        }
    }

    static testMethod void testContractBuilder2(){
        EUR_CRM_DE_TestClassUtilityHelper.initUsersOntrade();
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.regionalUser){
            test.StartTest();
            
            dataInsert2();
            
            //insert contract;
            test.StopTest();
        }
    }



    static String determineFiscalYear(Date contractStartDate){
        if (contractStartDate != null){
        Integer contractYear = contractStartDate.year();
        Integer contractMonth = contractStartDate.month();

        Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        
        if (contractMonth>=FiscalYearStartMonth){
            return 'FY'+ String.valueOf(contractYear+1).substring(2);
        }else{
            return 'FY' + String.valueOf(contractYear).substring(2);
        }
        }
        return null;
    }

    static void createZAaccount(){
        accountEU = new EUR_CRM_Account__c(
                EUR_CRM_Postal_Code__c = '12345',
                EUR_CRM_Street__c = 'Street',
                recordtypeid=[SELECT Id FROM RecordType WHERE Name = 'EUR ZA Off Trade'].get(0).Id,
                name = 'test ZA',
                EUR_CRM_Owner_Role_API_Name__c = 'EMEA' );
        insert accountEU;
    }
}