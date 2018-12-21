@isTest
private class EUR_CRM_ZA_TestContractBuilderController {
    
    static User eurSysUser; 
    static void setUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='EUR System Admin']; 
        UserRole r = [select id from UserRole where Developername ='EMEA'];
        eurSysUser = new User(Alias = 'standt', Email='userEmail1234aoke@test.com', userroleid=r.id,
                              EmailEncodingKey='UTF-8', LastName='userEmail1234aokelastName', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='userEmail1234aoke@test.com');
        insert eurSysUser;
    }
    
    static testMethod void testContractBuilder() {
        setUser();
        System.runAs(eurSysUser) {
            setMasterData();
            
            Id ZAOnTradeAccountRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Account__c', 'EUR_ZA_On_Trade_Direct');
            Id ZAOnContractRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract__c', 'EUR_ZA_Outlet_Contract');
            
            EUR_CRM_Account__c account = new EUR_CRM_Account__C(
                recordTypeId = ZAOnTradeAccountRecordTypeId,
                Name = 'Test Account',
                EUR_CRM_Business_Type__c = 'Outlet'
            );
            insert account;
            
            EUR_CRM_Contract__c contract = new EUR_CRM_Contract__c(
                recordTypeId = ZAOnContractRecordTypeId,
                EUR_CRM_Account__c = account.Id,
                EUR_CRM_Start_Date__c = System.today(),
                EUR_CRM_End_Date__c = System.today(),
                EUR_CRM_Status__c = 'Draft'
            );
            insert contract;
            
            Test.startTest();
            setPageData(contract);
            
            PageReference pageRef = Page.EUR_CRM_ZA_ContractSummaryPage;
            pageRef.getParameters().put('id', contract.id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(contract);
            
            EUR_CRM_ZA_ContractBuilderController con = new EUR_CRM_ZA_ContractBuilderController(sc);
            con.getContractAccount();
            con.getProfitColor();
            con.getIsCurrentUserApprover();
            con.getHasDeactivatePermissionSet();
            con.getEventsActivitiesTotal();  
            
            EUR_CRM_Mechanic_Type__c mechType = mechanicTypeMap.get('Listing');
            EUR_CRM_Mechanic_Type__c mechType2 = mechanicTypeMap.get('EVENTS');
                
            EUR_CRM_ZA_ContractBuilderController.MechanicTypeWrapper testWrapper = new EUR_CRM_ZA_ContractBuilderController.MechanicTypeWrapper(con, mechType, contractActivityItems[0], contractProductItems, null);
                        
            //testWrapper.setEventsMap();
            testWrapper.getProductName();
            testWrapper.getProductActiveFlag();
            testWrapper.getSelectableProducts();
            testWrapper.getContractProductItems();
            testWrapper.hasValue();
            testWrapper.getHasValue();
            testWrapper.getHasLumpSumValue();
            testWrapper.getHasVolumeValue();
            
            //EUR_CRM_ZA_ContractBuilderController.MechanicTypeWrapper testWrapper2 = new EUR_CRM_ZA_ContractBuilderController.MechanicTypeWrapper(con, mechType2, contractActivityItems[0], contractProductItems, null);
            
            Test.stopTest();
        }        
    }
    
    static Map<String, EUR_CRM_Mechanic_Type__c> mechanicTypeMap;
    static EUR_CRM_Brand__c brand;
    static EUR_CRM_Quality__c brandQuality;
    static testMethod void setMasterData() {
        // set products
        Id ZABrandRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Brand__c', 'EUR_ZA_Brand');
        Id ZABrandQualityRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Brand_Quality__c', 'EUR_ZA_Quality');
        
        brand = new EUR_CRM_Brand__c(
            name='test brand',
            recordTypeId = ZABrandRecordTypeId,
            EUR_CRM_Active__c = true
        );
        brandQuality = new EUR_CRM_Quality__c(
            name='test brand quality',
            recordTypeId = ZABrandQualityRecordTypeId,
            EUR_CRM_Active__c = true
        );
        
        // Mechanic type
        Id ZAMechanicTypeRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Mechanic_Type__c', 'EUR_ZA_Mechanic_Type');
        
        mechanicTypeMap = new Map<String, EUR_CRM_Mechanic_Type__c>();
        List<String> mechTypeNames = new List<String>{'Listing', 'Exclusivity', 'House pour', 'Stock deals', 'Events', 'POS material',
            'Uniforms', 'Drinks Menu', 'Bar Styling', 'Trainings', 'Displays', 'Promotions'
            };
                
                for(String mechTypeName: mechTypeNames) {
                    EUR_CRM_Mechanic_Type__c mechType = new EUR_CRM_Mechanic_Type__c(
                        recordTypeId = ZAMechanicTypeRecordTypeId,
                        Name = mechTypeName,
                        EUR_CRM_Mechanic_Type_Name_English__c = mechTypeName
                    );
                    mechanicTypeMap.put(mechTypeName, mechType);
                }
        insert mechanicTypeMap.values();
        
        // Mechanic
        Id ZAMechanicRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Mechanic__c', 'EUR_ZA_Mechanic');
        
        Map<String, EUR_CRM_Mechanic__c> mechanicMap = new Map<String, EUR_CRM_Mechanic__c>();
        
        for(String mechTypeName: mechTypeNames) {
            EUR_CRM_Mechanic__c mechType = new EUR_CRM_Mechanic__c(
                recordTypeId = ZAMechanicRecordTypeId,
                Name = mechTypeName,
                EUR_CRM_Mechanic_Type__c = mechanicTypeMap.get(mechTypeName).Id
            );
            mechanicMap.put(mechTypeName, mechType);
        }
        insert mechanicMap.values();
        
        // TODO: Remove Contract Mechanic from the controller
    }
    
    static Map<String, String> mechanicProductMap = new Map<String, String>{
        'Listing' => 'EUR_CRM_Brand_Quality__c',
            'Exclusivity' => 'EUR_CRM_Brand_Quality__c',
            'House pour' => 'EUR_CRM_Brand_Quality__c',
            'Stock deals' => 'EUR_CRM_Brand_Quality__c',
            'Events' => 'EUR_CRM_Brand__c',
            'POS material' => 'EUR_CRM_Brand__c',
            'Uniforms' => 'EUR_CRM_Brand__c',
            'Drinks Menu' => 'EUR_CRM_Brand__c',
            'Bar Styling' => 'EUR_CRM_Brand__c',
            'Trainings' => 'EUR_CRM_Brand__c',
            'Displays' => 'EUR_CRM_Brand__c',
            'Promotions' => 'EUR_CRM_Brand__c'
            };
                static List<EUR_CRM_Contract_Activity_Item__c> contractActivityItems;
    static List<EUR_CRM_Contract_Product_Item__c> contractProductItems; 
    
    static void setPageData(EUR_CRM_Contract__c contract) {
        Map<Id, EUR_CRM_Mechanic_Type__c> mechanicTypes = new Map<Id, EUR_CRM_Mechanic_Type__c>([SELECT Id, Name FROM EUR_CRM_Mechanic_Type__c WHERE EUR_CRM_Country_Code__c = 'ZA']);
        
        contractActivityItems = new List<EUR_CRM_Contract_Activity_Item__c>();
        contractProductItems = new List<EUR_CRM_Contract_Product_Item__c>();
        
        for(integer i = 0 ; i < 5; i++) {
            for(Id mechanicType: mechanicTypes.keySet()) {
                contractActivityItems.add(new EUR_CRM_Contract_Activity_Item__c(
                    EUR_CRM_Name__c = 'Test ContractActivityItems ' + mechanicTypes.get(mechanicType).Name,
                    EUR_CRM_Contract__c = contract.Id,
                    EUR_CRM_Mechanic_Type__c = mechanicType
                ));
            }
        }
        
        insert contractActivityItems;
        
        for(EUR_CRM_Contract_Activity_Item__c contractActivityItem : contractActivityItems) {
            EUR_CRM_Contract_Product_Item__c contractProductItem = new EUR_CRM_Contract_Product_Item__c(
                EUR_CRM_Contract_Activity_Item__c = contractActivityItem.Id
            );
            
            if(mechanicProductMap.get(mechanicTypes.get(contractActivityItem.EUR_CRM_Mechanic_Type__c).Name) == 'EUR_CRM_Brand__c') {
                contractProductItem.EUR_CRM_Brand__c = brand.Id;
            } else {
                contractProductItem.EUR_CRM_Brand_Quality__c = brandQuality.Id;
            }
            
            contractProductItems.add(contractProductItem);
        }
        
        insert contractProductItems;
    }
}