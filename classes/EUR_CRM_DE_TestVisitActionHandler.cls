@isTest
public class EUR_CRM_DE_TestVisitActionHandler{ 
    @isTest
    public static void testOffTrade(){
        EUR_CRM_DE_TestClassUtilityHelper.initOffTradeUsers();
        system.runAs(EUR_CRM_DE_TestClassUtilityHelper.offTradeNationalManager){
            
            EUR_CRM_DE_TestClassUtilityHelper.initOffTradeDataSet();  
            EUR_CRM_OP_Action_List_Template__c actionListTemplate = EUR_CRM_DE_TestClassUtilityHelper.creaActionListTemplate('testDE_OFF_ALT_Leaflet_Campaign','DE_OFF_ALT_Leaflet_Campaign' ,EUR_CRM_DE_TestClassUtilityHelper.DE_ACTION_LIST_TEMPLATE_RECORD_TYPE  );
            Id rt1 = [select id from RecordType where developername = 'EUR_DE_OFF_Confirm_Agreement_To_Buy' and sobjecttype ='EUR_CRM_ObjPromo_Action__c'][0].id;
            Id rt2 = [select id from RecordType where developername = 'EUR_DE_OFF_Enter_Sell_In_Qty' and sobjecttype ='EUR_CRM_ObjPromo_Action__c'][0].id;
            EUR_CRM_ObjPromo_Action__c opaction1 = new EUR_CRM_ObjPromo_Action__c(recordtypeid = rt1,name='test', EUR_CRM_OP_Action_List_Template__c = actionListTemplate.id
                ,EUR_CRM_Visit_Action_RecordType_DevName__c = 'EUR_DE_OFF_Leaflet_Campaign_Agree_To_Buy');
            insert opaction1;
            EUR_CRM_ObjPromo_Action__c opaction2 = new EUR_CRM_ObjPromo_Action__c(recordtypeid = rt1,name='test', EUR_CRM_OP_Action_List_Template__c = actionListTemplate.id
                ,EUR_CRM_Visit_Action_RecordType_DevName__c = 'EUR_DE_OFF_Leaflet_Campaign_Sell_In_Qty');
            insert opaction2;

            EUR_CRM_ObjPromo__c objPromo = EUR_CRM_DE_TestClassUtilityHelper.createObjPromo(
            1,EUR_CRM_DE_TestClassUtilityHelper.OP_DE_LEAFLET_CAMPAIGN,'test')[0];
            objPromo.EUR_CRM_Active_Start_Date__c = Date.newInstance(2014, 07,02); 
            insert objPromo;
            EUR_CRM_OP_Customer_Taxonomy_Mapping__c accountCustTax= new EUR_CRM_OP_Customer_Taxonomy_Mapping__c();
            accountCustTax.EUR_CRM_Customer_Taxonomy__c = EUR_CRM_DE_TestClassUtilityHelper.customerTaxonomy1.id;
            accountCustTax.EUR_CRM_ObjPromo__c = objPromo.id;
            insert accountCustTax;


            List<EUR_CRM_ObjPromo_Target__c> targets = new List<EUR_CRM_ObjPromo_Target__c>();
            EUR_CRM_ObjPromo_Target__c leafletTarget = EUR_CRM_DE_TestClassUtilityHelper.createOPTarget(1, 'Objective Volume Target', objPromo.Id, null)[0];
            leafletTarget.EUR_CRM_BQS__c = EUR_CRM_DE_TestClassUtilityHelper.bqs.id;
            leafletTarget.EUR_CRM_BQS__r  = EUR_CRM_DE_TestClassUtilityHelper.bqs; 
            insert leafletTarget;

            EUR_CRM_Account__c testAccount = EUR_CRM_DE_TestClassUtilityHelper.offTradeAccount1;
            EUR_CRM_Visit__c accountVisit = new EUR_CRM_Visit__c();
            accountVisit.EUR_CRM_Account__c = testAccount.id;
            accountVisit.RecordTypeId = [select id from RecordType where sobjecttype='EUR_CRM_Visit__c' and developername = 'EUR_DE_Off_Trade_Visit'].id;
            accountVisit.EUR_CRM_Visit_Data_Capture_EndDateTime__c =  date.today();
            accountVisit.EUR_CRM_Visit_Data_Capture_StartDateTime__c=   date.today();
            accountVisit.EUR_CRM_End_Datetime__c=  date.today();
            accountVisit.EUR_CRM_Start_Datetime__c=  date.today();
            insert accountVisit;
            EUR_CRM_ObjPromo_Account_Mapping__c opAccountMap = new EUR_CRM_ObjPromo_Account_Mapping__c();
            opAccountMap.EUR_CRM_Account__c = testAccount.id;
            opAccountMap.EUR_CRM_Is_Active__c = true;
            opAccountMap.EUR_CRM_ObjPromo__c = objPromo.id;
            opAccountMap.RecordTypeId = [select id from RecordType where sobjecttype='EUR_CRM_ObjPromo_Account_Mapping__c' and developername = 'EUR_CRM_DE_O_P_Account_Mapping'].id;
            insert opAccountMap;
            Test.startTest();
            //-- test leaflet
            EUR_CRM_Visit_Action__c visitAction = new EUR_CRM_Visit_Action__c();
            visitAction.EUR_CRM_Account__c = testAccount.id;  
            visitAction.EUR_CRM_Status__c = 'Yes';  
            visitAction.EUR_CRM_Brand_Quality_Size__c = EUR_CRM_DE_TestClassUtilityHelper.bqs.id;  
            visitAction.EUR_CRM_OP_Action__c = opaction1.id;  
            visitAction.EUR_CRM_ObjPromo__c= objPromo.id;  
            visitAction.EUR_CRM_Visit_ID__c = accountVisit.id;  
            visitAction.EUR_CRM_ObjPromo_Target__c = leafletTarget.id;
             visitAction.RecordTypeId = [select id from RecordType where sobjecttype='EUR_CRM_Visit_Action__c' and developername = 'EUR_DE_OFF_Leaflet_Campaign_Agree_To_Buy'].id;
           
            insert visitAction;
            
            EUR_CRM_Visit_Action__c visitAction2 = new EUR_CRM_Visit_Action__c();
            visitAction2.EUR_CRM_Account__c = testAccount.id;  
            visitAction2.EUR_CRM_Status__c = 'Yes';  
            visitAction2.EUR_CRM_Brand_Quality_Size__c = EUR_CRM_DE_TestClassUtilityHelper.bqs.id;  
            visitAction2.EUR_CRM_OP_Action__c = opaction1.id;  
            visitAction2.EUR_CRM_ObjPromo__c= objPromo.id;  
            visitAction2.EUR_CRM_Visit_ID__c = accountVisit.id;  
            visitAction2.EUR_CRM_ObjPromo_Target__c = leafletTarget.id;
            visitAction2.RecordTypeId = [select id from RecordType where sobjecttype='EUR_CRM_Visit_Action__c' and developername = 'EUR_DE_OFF_Leaflet_Campaign_Sell_In_Qty'].id;
           
            insert visitAction2;
            
            Test.stopTest();
        }
    }
}