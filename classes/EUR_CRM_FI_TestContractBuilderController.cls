@isTest
public class EUR_CRM_FI_TestContractBuilderController{

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
    
    /**
       EUR_CRM_FI_ContractBuilderController
    */
    static testMethod  void testContractBuilder(){
        setUser();
        System.runAs(eurSysUser){
            setMasterData();
            
            //create eu account, contact, contract
            Id fiOnAccountRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Account__c' ,'EUR_FI_Direct_On_Trade');
          //  Id fiOnContactRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('Contact' ,'EUR_Contact_FI');         
            Id fiOnContractRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract__c' ,'EUR_FI_Independent_Contract');
         
            EUR_CRM_Account__c account = new EUR_CRM_Account__c(recordtypeid = fiOnAccountRecordTypeId,
            name = 'test', eur_crm_business_type__c = 'Outlet');
            insert account;
         //   Contact contact = new Contact (EUR_CRM_Account__c = account.id, recordtypeid = fiOnContactRecordTypeId, lastname='test');
        //    insert contact;
            EUR_CRM_Contract__c contract = new EUR_CRM_Contract__c(
                 recordtypeid = fiOnContractRecordTypeId,
                 EUR_CRM_Account__c = account.id, 
                 EUR_CRM_Start_Date__c = System.today(),
                 EUR_CRM_End_Date__c = System.today(),
                 EUR_CRM_Status__c = 'Draft',
                 EUR_CRM_Is_this_contract_material__c = 60000,
                 EUR_CRM_Is_this_contract_profitable__c = 60
            );
            insert contract;
            contract = [select id, EUR_CRM_Include_VAT__c,EUR_CRM_Contact__c,EUR_CRM_Account__c,EUR_CRM_Account__r.ownerid ,EUR_CRM_Is_this_contract_material__c,EUR_CRM_Is_this_contract_profitable__c,RecordType.developername,EUR_CRM_Country_Code__c
                             from  EUR_CRM_Contract__c where id=:contract.id];
            Test.startTest();           
            // START TEST ---
            PageReference aPage = Page.EUR_CRM_FI_ContractBuilderPage;
            test.setCurrentPage(aPage);
            ApexPages.StandardController sc = new ApexPages.StandardController(contract);
            
            EUR_CRM_FI_ContractBuilderController con = new EUR_CRM_FI_ContractBuilderController(sc);
            
            EUR_CRM_FI_ContractBuilderController.MechanicTypeWrapper pouringRefundSpiritsMechType = con.mechanicTypeWrapperMap.get('Pouring Refund Spirits');
            
            system.assert(pouringRefundSpiritsMechType.getSelectableProducts() != null && pouringRefundSpiritsMechType.getSelectableProducts().size() == 1);
            
            //add contract product item
            aPage.getParameters().put('PARAM_MECHANIC_TYPE_NAME', 'Pouring Refund Spirits');
            aPage.getParameters().put('PARAM_PRODUCT_ID', bqs.id);
            aPage.getParameters().put('PARAM_ROW_NUMBER', '0');
            con.addContractLineItem();
            system.assert(pouringRefundSpiritsMechType.getSelectableProducts().size() == 0);
            //remove contract product item
            con.removeContractLineItem();
            //add contract product item
            con.addContractLineItem(); 
            pouringRefundSpiritsMechType.getProductName();
            
            //PORUING REFUNDS
            List<EUR_CRM_Contract_Product_Item__c> productItems = pouringRefundSpiritsMechType.getContractProductItems();
            EUR_CRM_Contract_Product_Item__c prod= productItems.get(0);
            prod.EUR_CRM_Quantity__c = 10000; 
            prod.EUR_CRM_Amount__c = 0.1;
            //retrive product items.
            //system.assert(pouringRefundSpiritsMechType.getProductName() == 'test bqs');
            
            //- TRIPS
            aPage.getParameters().put('PARAM_MECHANIC_TYPE_NAME', 'Trips');
            aPage.getParameters().put('PARAM_PRODUCT_ID', brand.id);
            aPage.getParameters().put('PARAM_ROW_NUMBER', '0');
            con.addContractLineItem();
               
            EUR_CRM_FI_ContractBuilderController.MechanicTypeWrapper tripsMechType = con.mechanicTypeWrapperMap.get('Trips');
            EUR_CRM_Contract_Product_Item__c tripProd= tripsMechType .getContractProductItems().get(0);
            tripProd.EUR_CRM_Contract_Event__c= contractEventTrip.id; 
            tripProd.EUR_CRM_Marketing_Amount__c= 1000;
            tripProd.EUR_CRM_No_of_People__c= 1000;
            tripsMechType.productContractEventMap.get(brand.id).getContractEventOptions(); 
            con.getContractMaterialColor();
            con.getProfitColor();
            con.save();
            system.assert(pouringRefundSpiritsMechType.getHasValue());
            system.assert(!pouringRefundSpiritsMechType.getHasLumpSumValue());
            system.assert(pouringRefundSpiritsMechType.getHasVolumeValue());
            tripsMechType.productContractEventMap.get(brand.id).getContractEventOptions(); 
            con.getContractAccount();
            tripsMechType.productContractEventMap.get(brand.id).getContractEventOptions(); 
            
            //reload
            con = new EUR_CRM_FI_ContractBuilderController(sc);
            tripsMechType = con.mechanicTypeWrapperMap.get('Trips');
            pouringRefundSpiritsMechType = con.mechanicTypeWrapperMap.get('Pouring Refund Spirits');
            con.removeContractLineItem();
            
            Test.stopTest();           
            // STOP TEST --- 
        }
    }
    
    static Map<String, EUR_CRM_Mechanic_Type__c> mechanicTypeMap;
    static EUR_CRM_Brand__c brand;
    static EUR_CRM_Quality__c bq;
    static EUR_CRM_Size__c bqs;
    static EUR_CRM_SKU__c sku;
    static EUR_CRM_Contract_Event__c contractEventEducation;
    static EUR_CRM_Contract_Event__c contractEventTrip;
    static void setMasterData(){
        //set products
        Id fiBrandRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Brand__c' ,'EUR_FI_Brand');
        Id fiBQRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Quality__c' ,'EUR_FI_Quality');
        Id fiBQSRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Size__c' ,'EUR_FI_Size');
        Id fiSKURecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_SKU__c' ,'EUR_FI_SKU');
        
        brand = new EUR_CRM_Brand__c(name = 'test brand', recordtypeid = fiBrandRecordTypeId, EUR_CRM_Active__c = true);
        insert brand;
        bq= new EUR_CRM_Quality__c(name = 'test bq', recordtypeid = fiBQRecordTypeId,EUR_CRM_Active__c = true );
        insert bq;
        bqs= new EUR_CRM_Size__c(name = 'test bqs', recordtypeid = fiBQSRecordTypeId, EUR_CRM_Active__c = true );
        insert bqs;
        sku= new EUR_CRM_SKU__c(name = 'test sku', recordtypeid = fiSKURecordTypeId,EUR_CRM_Active__c = true );
        insert sku;
        
        //mechanic type
        Id fiMechanicTypeRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Mechanic_Type__c' ,'EUR_FI_Mechanic_Type');
         
        mechanicTypeMap = new Map<String, EUR_CRM_Mechanic_Type__c>();
        //List<EUR_CRM_Mechanic_Type__c> mechTypes = new List<EUR_CRM_Mechanic_Type__c>();
        List<String> mechTypeNames = new List<String>{'Education','Free Stock','Marketing Activity Spirits','Marketing Activity Wines'
        ,'Pouring Refund Spirits','Pouring Refund Wines','Selection Brands Spirits','Selection Brands Wines','Trips'};
        
        for(String mechTypeName : mechTypeNames){
            EUR_CRM_Mechanic_Type__c mechType = new EUR_CRM_Mechanic_Type__c(
                recordtypeid = fiMechanicTypeRecordTypeId,
                Name = mechTypeName,
                EUR_CRM_Mechanic_Type_Name_English__c = mechTypeName
            ); 
            mechanicTypeMap.put(mechTypeName, mechType);
        }
        insert mechanicTypeMap.values();
        Id fiMechanicRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Mechanic__c' ,'EUR_FI_Mechanic');
       
        Map<String, EUR_CRM_Mechanic__c> mechanicMap = new Map<String, EUR_CRM_Mechanic__c>(); 
        //mechanic
        for(String mechTypeName : mechTypeNames) {
            EUR_CRM_Mechanic__c mechType = new EUR_CRM_Mechanic__c(
                recordtypeid = fiMechanicRecordTypeId,
                Name = mechTypeName,
                EUR_CRM_Mechanic_Type__c = mechanicTypeMap.get(mechTypeName).id
            ); 
            mechanicMap.put(mechTypeName, mechType);
        }
        insert mechanicMap.values();
        
        //contract mechanic
        Id fiContractMechanicRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract_Mechanic__c' ,'EUR_FI_Contract_Mechanic');
        
        Map<String,EUR_CRM_Contract_Mechanic__c> contractMechanicMap = new   Map<String,EUR_CRM_Contract_Mechanic__c>();
        
        EUR_CRM_Contract_Mechanic__c pouringRefundSpiritsCM = new EUR_CRM_Contract_Mechanic__c(
            recordTypeId = fiContractMechanicRecordTypeId,
            EUR_CRM_Brand_Quality_Size__c = bqs.id,
            EUR_CRM_Mechanic__c = mechanicMap.get('Pouring Refund Spirits').id
        );
        contractMechanicMap.put('Pouring Refund Spirits', pouringRefundSpiritsCM );

        EUR_CRM_Contract_Mechanic__c pouringRefundWinesCM = new EUR_CRM_Contract_Mechanic__c(
            recordTypeId = fiContractMechanicRecordTypeId,
            EUR_CRM_SKU__c = sku.id,
            EUR_CRM_Mechanic__c = mechanicMap.get('Pouring Refund Wines').id
        );
        contractMechanicMap.put('Pouring Refund Wines', pouringRefundWinesCM );

        EUR_CRM_Contract_Mechanic__c selectionBransSpiritsCM = new EUR_CRM_Contract_Mechanic__c(
            recordTypeId = fiContractMechanicRecordTypeId,
            EUR_CRM_Brand_Quality_Size__c = bqs.id,
            EUR_CRM_Mechanic__c = mechanicMap.get('Selection Brands Spirits').id
        );
        contractMechanicMap.put('Selection Brands Spirits', selectionBransSpiritsCM );
        
        EUR_CRM_Contract_Mechanic__c selectionBransWinesCM = new EUR_CRM_Contract_Mechanic__c(
            recordTypeId = fiContractMechanicRecordTypeId,
            EUR_CRM_Brand__c = brand.id,
            EUR_CRM_Mechanic__c = mechanicMap.get('Selection Brands Wines').id
        );
        contractMechanicMap.put('Selection Brands Wines', selectionBransWinesCM );
        
        EUR_CRM_Contract_Mechanic__c education = new EUR_CRM_Contract_Mechanic__c(
            recordTypeId = fiContractMechanicRecordTypeId,
            EUR_CRM_Brand__c = brand.id,
            EUR_CRM_Mechanic__c = mechanicMap.get('Education').id
        );
        contractMechanicMap.put('Education', education);
        
        EUR_CRM_Contract_Mechanic__c trips = new EUR_CRM_Contract_Mechanic__c(
            recordTypeId = fiContractMechanicRecordTypeId,
            EUR_CRM_Brand__c = brand.id,
            EUR_CRM_Mechanic__c = mechanicMap.get('Trips').id
        );
        contractMechanicMap.put('Trips', trips );
        
        insert contractMechanicMap.values();
        Id fiContractEventEducationRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract_Event__c' ,'EUR_CRM_FI_Contract_Event_Education');
        Id fiContractEventTripRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract_Event__c' ,'EUR_CRM_FI_Contract_Event_Trip');
        Id fiContractEventEducationMapRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract_Event_To_Prod_Mapping__c' ,'EUR_CRM_FI_Contract_Event_Product_Mapping_Education');
        Id fiContractEventTripMapRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Contract_Event_To_Prod_Mapping__c' ,'EUR_CRM_FI_Contract_Event_Product_Mapping_Trip');
        
          contractEventEducation = new EUR_CRM_Contract_Event__c(
             recordtypeid = fiContractEventEducationRecordTypeId ,
             name = 'edu'
         );
         insert contractEventEducation;
          contractEventTrip = new EUR_CRM_Contract_Event__c(
             recordtypeid = fiContractEventTripRecordTypeId ,
             name = 'trip'
         );
         insert contractEventTrip ;
         
         EUR_CRM_Contract_Event_To_Prod_Mapping__c cemEdu = new EUR_CRM_Contract_Event_To_Prod_Mapping__c(
             recordtypeid = fiContractEventEducationMapRecordTypeId ,
             EUR_CRM_Contract_Event__c = contractEventEducation.id,
             EUR_CRM_Contract_Mechanic__c =contractMechanicMap.get('Education').id
         );
         
         insert cemEdu;
         
         EUR_CRM_Contract_Event_To_Prod_Mapping__c cemTrip = new EUR_CRM_Contract_Event_To_Prod_Mapping__c(
             recordtypeid = fiContractEventTripMapRecordTypeId ,
             EUR_CRM_Contract_Event__c = contractEventTrip.id,
             EUR_CRM_Contract_Mechanic__c = contractMechanicMap.get('Trips').id
         );
         
         insert cemTrip ;
          
        
        Id fiConfigRecordTypeId = EUR_CRM_TestClassUtilityHelper.getRecordTypeId('EUR_CRM_Apex_Configuration__c' ,'EUR_CRM_General_Configuration');
        List<EUR_CRM_Apex_Configuration__c > configs = new List<EUR_CRM_Apex_Configuration__c >();
        EUR_CRM_Apex_Configuration__c config1 = new EUR_CRM_Apex_Configuration__c(
            recordtypeid = fiConfigRecordTypeId,
            EUR_CRM_Country_Code__c = 'fi',
            EUR_CRM_Decimal_Value__c = 20,
            EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder',
            EUR_CRM_Sub_Module__c = 'EUR_CRM_Profitability',
            EUR_CRM_Text_Value__c = 'red',
            EUR_CRM_Sequence__c = 1
        );
        EUR_CRM_Apex_Configuration__c config2 = new EUR_CRM_Apex_Configuration__c (
            recordtypeid = fiConfigRecordTypeId,
            EUR_CRM_Country_Code__c = 'fi',
            EUR_CRM_Decimal_Value__c = 20,
            EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder',
            EUR_CRM_Sub_Module__c = 'EUR_CRM_Profitability',
            EUR_CRM_Text_Value__c = 'red',
            EUR_CRM_Sequence__c = 2
        );
        EUR_CRM_Apex_Configuration__c config3 = new EUR_CRM_Apex_Configuration__c (
            recordtypeid = fiConfigRecordTypeId,
            EUR_CRM_Country_Code__c = 'fi',
            EUR_CRM_Decimal_Value__c = 40,
            EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder',
            EUR_CRM_Sub_Module__c = 'EUR_CRM_Profitability',
            EUR_CRM_Text_Value__c = 'red',
            EUR_CRM_Sequence__c = 3
        );
        EUR_CRM_Apex_Configuration__c  config4 = new EUR_CRM_Apex_Configuration__c (
            recordtypeid = fiConfigRecordTypeId,
            EUR_CRM_Country_Code__c = 'fi',
            EUR_CRM_Decimal_Value__c = 1000,
            EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder',
            EUR_CRM_Sub_Module__c = 'EUR_CRM_ContractMaterial',
            EUR_CRM_Text_Value__c = 'red',
            EUR_CRM_Sequence__c = 1
        );
        EUR_CRM_Apex_Configuration__c  config5 = new EUR_CRM_Apex_Configuration__c (
            recordtypeid = fiConfigRecordTypeId,
            EUR_CRM_Country_Code__c = 'fi',
            EUR_CRM_Decimal_Value__c = 1000,
            EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder',
            EUR_CRM_Sub_Module__c = 'EUR_CRM_ContractMaterial',
            EUR_CRM_Text_Value__c = 'red',
            EUR_CRM_Sequence__c = 1
        );
        EUR_CRM_Apex_Configuration__c  config6 = new EUR_CRM_Apex_Configuration__c (
            recordtypeid = fiConfigRecordTypeId,
            EUR_CRM_Country_Code__c = 'fi',
            EUR_CRM_Decimal_Value__c = 2000,
            EUR_CRM_Module__c = 'EUR_CRM_FI_ContractBuilder',
            EUR_CRM_Sub_Module__c = 'EUR_CRM_ContractMaterial',
            EUR_CRM_Text_Value__c = 'red',
            EUR_CRM_Sequence__c = 1
        );
        configs.add(config1); configs.add(config2); configs.add(config3); configs.add(config4); configs.add(config5); configs.add(config6); 
        insert configs;
    }

}