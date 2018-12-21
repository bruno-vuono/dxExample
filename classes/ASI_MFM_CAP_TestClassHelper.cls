/*
*    CAPEX/OPEX
*    Help Create CAP Data
*    Call Class
*/
@isTest
public class ASI_MFM_CAP_TestClassHelper {

//A/C Code
    public static ASI_MFM_A_C_Code__c createACCode()
    {
        ASI_MFM_A_C_Code__c acCode = new ASI_MFM_A_C_Code__c(
            Name='testAcCode',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_A_C_Code__cASI_MFM_CAP_A_C_Code')
        );
        insert acCode;
        return acCode;
    }

//AP Code    
    public static ASI_MFM_AP_Code__c createAPCode()
    {
         ASI_MFM_AP_Code__c apCode = new ASI_MFM_AP_Code__c(
             Name='testApCode',
             ASI_MFM_AP_Description__c = 'testApCode',
             recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_AP_Code__cASI_MFM_CAP_AP_Code'),
             ASI_MFM_A_C_Code__c = createACCode().id
         );
         insert apCode;
         return apCode;
    }
    
    public static ASI_MFM_AP_Code__c createCAPEXAPCode()
    {
         ASI_MFM_AP_Code__c apCode = new ASI_MFM_AP_Code__c(
             Name='testApCode',
             recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_AP_Code__cASI_MFM_CAP_AP_Code'),
             ASI_MFM_A_C_Code__c = createACCode().id,
             ASI_MFM_OPEX__c = false
         );
         insert apCode;
         return apCode;
    }
    
    public static ASI_MFM_AP_Code__c createOPEXAPCode()
    {
         ASI_MFM_AP_Code__c apCode = new ASI_MFM_AP_Code__c(
             Name='testApCode',
             recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_AP_Code__cASI_MFM_CAP_AP_Code'),
             ASI_MFM_A_C_Code__c = createACCode().id,
             ASI_MFM_OPEX__c = true
         );
         insert apCode;
         return apCode;
    }

//BU    
    public static ASI_MFM_BU__c createBUCode()
    {
        ASI_MFM_BU__c buCode = new ASI_MFM_BU__c(
            Name='testBUCode',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_BU__cASI_MFM_CAP_BU')
        );
        insert buCode;
        return buCode;
    }

    public static ASI_MFM_BU__c createCAPEXBUCode()
    {
        ASI_MFM_BU__c buCode = new ASI_MFM_BU__c(
            Name='testBUCode',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_BU__cASI_MFM_CAP_BU'),
            ASI_MFM_OPEX__c = false
        );
        insert buCode;
        return buCode;
    }

    public static ASI_MFM_BU__c createOPEXBUCode()
    {
        ASI_MFM_BU__c buCode = new ASI_MFM_BU__c(
            Name='testBUCode',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_BU__cASI_MFM_CAP_BU'),
            ASI_MFM_OPEX__c = true
        );
        insert buCode;
        return buCode;
    }

//Custom Setting Default Value    
    public static void createMFMDefaultValues()
    {
        ASI_MFM_Default_Value__c defaultVal = new ASI_MFM_Default_Value__c(
            Name = 'CAP_AP_Consulting_Code__c',
            ASI_MFM_Value__c = null,
            Country__c = 'HK'
        );
        insert defaultVal;
    }

//Supplier    
    public static Account createAccSupplier ()
    {
        Account acc = new Account(recordTypeId = Global_RecordTypeCache.getRtId('AccountASI_MFM_HK_Supplier'), Name='Name3');
        insert acc;
        return acc;
    }

//Prefix
    public static ASI_MFM_Prefix__c createPrefixPlan ()
    {
        user u = [SELECT ID, ASI_MFM_Country__c FROM user WHERE ID = : userinfo.getUserID()];
        u.ASI_MFM_Country__c = 'HK';
        update u;
        ASI_MFM_Prefix__c prefixCap = new ASI_MFM_Prefix__c
        (
            Name = 'CAPTest',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_CAP_Prefix'),
            ASI_MFM_Module__c = 'Plan',
            ASI_MFM_Fiscal_year__c = 'FY1415'
        );
        insert prefixCap;
        userRole r = [SELECT ID, name, DeveloperName FROM userRole WHERE ID = : userinfo.getUserRoleId() ];
        ASI_MFM_Role_Prefix_Relationship__c rel = new ASI_MFM_Role_Prefix_Relationship__c
        (
            ASI_MFM_Prefix__c = prefixCap.id,
            ASI_MFM_Role_Name__c = r.DeveloperName
        );
        insert rel;
        return prefixCap;
    }

//Payment Route Type    
    public static void createRoutePaymentType()
    {
        ASI_MFM_Route_Type__c routeType = new ASI_MFM_Route_Type__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Route_Type__cASI_MFM_CAP_Route_Type'),
            //ASI_MFM_Country__c = 'HK',
            ASI_MFM_Module__c = 'Payment',
            name = 'Route Payment Test'
        );
        insert routeType;
        List<ASI_MFM_Route_Rule_Detail__c> routeDetails = new List<ASI_MFM_Route_Rule_Detail__c>();
        for(integer i = 0; i < 10; i++)
        {
            ASI_MFM_Route_Rule_Detail__c routedetail = new ASI_MFM_Route_Rule_Detail__c
            (
                ASI_MFM_Route_Type__c = routeType.id,
                ASI_MFM_Approver__c = userinfo.getuserid(),
                ASI_MFM_Minimum_Amount__c = 0
            );
            routeDetails.add(routedetail);
        }
        insert routeDetails;
    }
    
//PO Route Type 
    public static void createRoutePOType()
    {
        ASI_MFM_Route_Type__c routeType = new ASI_MFM_Route_Type__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Route_Type__cASI_MFM_CAP_Route_Type'),
            //ASI_MFM_Country__c = 'HK',
            ASI_MFM_Module__c = 'PO',
            name = 'Route Payment Test'
        );
        insert routeType;
        List<ASI_MFM_Route_Rule_Detail__c> routeDetails = new List<ASI_MFM_Route_Rule_Detail__c>();
        for(integer i = 0; i < 10; i++)
        {
            ASI_MFM_Route_Rule_Detail__c routedetail = new ASI_MFM_Route_Rule_Detail__c
            (
                ASI_MFM_Route_Type__c = routeType.id,
                ASI_MFM_Approver__c = userinfo.getuserid(),
                ASI_MFM_Minimum_Amount__c = 0
            );
            routeDetails.add(routedetail);
        }
        insert routeDetails;
    }

//Plan Route Type    
    public static void createRoutePlanType()
    {
        ASI_MFM_Route_Type__c routeType = new ASI_MFM_Route_Type__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Route_Type__cASI_MFM_CAP_Route_Type'),
            //ASI_MFM_Country__c = 'HK',
            ASI_MFM_Module__c = 'Plan',
            name = 'Route Payment Test'
        );
        insert routeType;
        List<ASI_MFM_Route_Rule_Detail__c> routeDetails = new List<ASI_MFM_Route_Rule_Detail__c>();
        for(integer i = 0; i < 10; i++)
        {
            ASI_MFM_Route_Rule_Detail__c routedetail = new ASI_MFM_Route_Rule_Detail__c
            (
                ASI_MFM_Route_Type__c = routeType.id,
                ASI_MFM_Approver__c = userinfo.getuserid(),
                ASI_MFM_Minimum_Amount__c = 0
            );
            routeDetails.add(routedetail);
        }
        insert routeDetails;
    }

//PO Prefix 
    public static ASI_MFM_Prefix__c createPrefixPO ()
    {
        ASI_MFM_Prefix__c prefixCap = new ASI_MFM_Prefix__c
        (
            Name = 'PO14',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_CAP_Prefix'),
            ASI_MFM_Module__c = 'PO',
            ASI_MFM_Fiscal_year__c = 'FY1415'
        );
        insert prefixCap;
        userRole r = [SELECT ID, name, DeveloperName FROM userRole WHERE ID = : userinfo.getUserRoleId() ];
        ASI_MFM_Role_Prefix_Relationship__c rel = new ASI_MFM_Role_Prefix_Relationship__c
        (
            ASI_MFM_Prefix__c = prefixCap.id,
            ASI_MFM_Role_Name__c = r.DeveloperName
        );
        insert rel;
        return prefixCap;
    }

//Payment Prefix    
    public static ASI_MFM_Prefix__c createPrefixPayment ()
    {
        ASI_MFM_Prefix__c prefixCap = new ASI_MFM_Prefix__c
        (
            Name = 'PA14',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Prefix__cASI_MFM_CAP_Prefix'),
            ASI_MFM_Module__c = 'Payment',
            ASI_MFM_Fiscal_year__c = 'FY1415'
        );
        insert prefixCap;
        userRole r = [SELECT ID, name, DeveloperName FROM userRole WHERE ID = : userinfo.getUserRoleId() ];
        ASI_MFM_Role_Prefix_Relationship__c rel = new ASI_MFM_Role_Prefix_Relationship__c
        (
            ASI_MFM_Prefix__c = prefixCap.id,
            ASI_MFM_Role_Name__c = r.DeveloperName
        );
        insert rel;
        return prefixCap;
    }

//CAPEX Plan Data
    public static ASI_MFM_Plan__c createPlan()
    {
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c
        (
            Name = 'Test Plan1',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_CAP_Plan'),
            //ASI_MFM_Actual_Depreciation_Start_Date__c = date.today().adddays(1),
            ASI_MFM_Estimated_Depreciation_Start_Dat__c = date.today().adddays(1),
           // ASI_MFM_Expenditure_Type__c = 'Computer Hardware',
            ASI_MFM_Prefix__c = createPrefixPlan().id,
            ASI_MFM_Plan_Type__c = 'CAPEX'
        );
        
        insert plan;
        
        ASI_MFM_Plan_Line_Item__c planLine = createCAPEXPlanLines(plan);
        
        return plan;
    }
    
    public static ASI_MFM_Plan__c createPlanOpex()
    {
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c
        (
            // DC - 01/25/2016 - Added logic to create unique plan name.
            Name = 'Test Plan ' + String.valueOf(System.now()),
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_CAP_Plan'),
            //ASI_MFM_Actual_Depreciation_Start_Date__c = date.today().adddays(1),
            ASI_MFM_Estimated_Depreciation_Start_Dat__c = date.today().adddays(1),
           // ASI_MFM_Expenditure_Type__c = 'Computer Hardware',
            ASI_MFM_Prefix__c = createPrefixPlan().id,
            ASI_MFM_Plan_Type__c = 'OPEX'
        );
        plan.id = null;
        
        insert plan;
        
        ASI_MFM_Plan_Line_Item__c planLine = createOPEXPlanLines(plan);
        
        return plan;
    }
    
    public static ASI_MFM_Plan__c createPlanFinal()
    {
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c
        (
            Name = 'Test Plan1',
            ASI_MFM_Status__c = 'Final',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_CAP_Plan'),
            //ASI_MFM_Actual_Depreciation_Start_Date__c = date.today().adddays(1),
            ASI_MFM_Estimated_Depreciation_Start_Dat__c = date.today().adddays(1),
           // ASI_MFM_Expenditure_Type__c = 'Computer Hardware',
            ASI_MFM_Prefix__c = createPrefixPlan().id,
            ASI_MFM_Plan_Type__c = 'CAPEX'
        );
        
        insert plan;
        
        ASI_MFM_Plan_Line_Item__c planLine = createCAPEXPlanLines(plan);
        
        return plan;
    }
    
    public static ASI_MFM_Plan__c createPlanOpexFinal()
    {
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c
        (
            Name = 'Test Plan',
            ASI_MFM_Status__c = 'Final',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_CAP_Plan'),
            //ASI_MFM_Actual_Depreciation_Start_Date__c = date.today().adddays(1),
            ASI_MFM_Estimated_Depreciation_Start_Dat__c = date.today().adddays(1),
           // ASI_MFM_Expenditure_Type__c = 'Computer Hardware',
            ASI_MFM_Prefix__c = createPrefixPlan().id,
            ASI_MFM_Plan_Type__c = 'OPEX'
        );
        plan.id = null;
        
        insert plan;
        
        ASI_MFM_Plan_Line_Item__c planLine = createOPEXPlanLines(plan);
        
        return plan;
    }
    
    public static ASI_MFM_Plan__c createPlanReadOnly()
    {
        ASI_MFM_Plan__c plan = new ASI_MFM_Plan__c
        (
            Name = 'Test Plan',
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_CAP_Plan_Read_Only'),
            //ASI_MFM_Actual_Depreciation_Start_Date__c = date.today().adddays(1),
            ASI_MFM_Estimated_Depreciation_Start_Dat__c = date.today().adddays(1),
          //  ASI_MFM_Expenditure_Type__c = 'Computer Hardware',
            ASI_MFM_Prefix__c = createPrefixPlan().id,
            ASI_MFM_Plan_Type__c = 'OPEX'
        );
        
        insert plan;
        
        ASI_MFM_Plan_Line_Item__c planLine = createOPEXPlanLines(plan);
        
        return plan;
    }
    
    public static ASI_MFM_Plan__c createPlanClone(ASI_MFM_Plan__c planCloned)
    {
        ASI_MFM_Plan__c plan1 = new ASI_MFM_Plan__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan__cASI_MFM_CAP_Plan'),
            ASI_MFM_Cloned_Plan_ID__c = planCloned.id,
            ASI_MFM_Prefix__c = planCloned.ASI_MFM_Prefix__c,
            ASI_MFM_Plan_Type__c = 'CAPEX'
        );
        insert plan1;
        
        ASI_MFM_Plan_Line_Item__c planLine = createCAPEXPlanLines(plan1);
        
        return plan1;
    }

    public static ASI_MFM_Plan_Line_Item__c createPlanLines(ASI_MFM_Plan__c plan)
    {
        ASI_MFM_Plan_Line_Item__c planLine = new ASI_MFM_Plan_Line_Item__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_CAP_Plan_Line_Item'),
            ASI_MFM_List_Item_Description__c = 'test description',
            ASI_MFM_Total_Cost__c = 1234,
            ASI_MFM_Plan__c = plan.id,
            ASI_MFM_AP_Code__c = createCAPEXAPCode().id,
            ASI_MFM_BU_Code__c = createCAPEXBUCode().id
        );
        insert planLine;
        return planLine;
    }
    
    public static ASI_MFM_Plan_Line_Item__c createCAPEXPlanLines(ASI_MFM_Plan__c plan)
    {
        ASI_MFM_Plan_Line_Item__c planLine = new ASI_MFM_Plan_Line_Item__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_CAP_Plan_Line_Item'),
            ASI_MFM_List_Item_Description__c = 'test description',
            ASI_MFM_Total_Cost__c = 1234,
            ASI_MFM_Plan__c = plan.id,
            ASI_MFM_AP_Code__c = createCAPEXAPCode().id,
            ASI_MFM_BU_Code__c = createCAPEXBUCode().id
        );
        insert planLine;
        return planLine;
    }
    
    public static ASI_MFM_Plan_Line_Item__c createOPEXPlanLines(ASI_MFM_Plan__c plan)
    {
        ASI_MFM_Plan_Line_Item__c planLine = new ASI_MFM_Plan_Line_Item__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Plan_Line_Item__cASI_MFM_CAP_Plan_Line_Item'),
            ASI_MFM_List_Item_Description__c = 'test description',
            ASI_MFM_Total_Cost__c = 1234,
            ASI_MFM_Plan__c = plan.id,
            ASI_MFM_AP_Code__c = createOPEXAPCode().id,
            ASI_MFM_BU_Code__c = createOPEXBUCode().id
        );
        insert planLine;
        return planLine;
    }
    
    public static void createFormAttachment(Id parentId)
    {
        ASI_MFM_CAP_Plan_Attachment__c CAPattachment=new ASI_MFM_CAP_Plan_Attachment__c();     
        CAPattachment.ASI_MFM_CAP_Category__c='Others';
        CAPattachment.ASI_MFM_CAP_File_Name__c = 'File Attachment' + parentId;
        CAPattachment.ASI_MFM_Plan__c = parentId;
        CAPattachment.ASI_MFM_CAP_Attach_in_Approval_Email__c = true;
        insert CAPattachment;   
    }
    
    public static void createNote(Id parentId)
    {
        Note note=new Note();     
        note.Title='Unit Test Note';
        //Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'+parentId);
        note.body='Unit Test Note Body'+parentId;
        note.parentId=parentId;
        insert note;   
    }
    
    public static ASI_MFM_PO__c createPo()
    {       
        return createPo('OPEX', createPlanOPEXFinal());
    }
    
    public static ASI_MFM_PO__c createPo(String type, ASI_MFM_Plan__c plan)
    {
        ASI_MFM_PO__c po = new ASI_MFM_PO__c
        (
            Name = 'Test PO',
            ASI_MFM_PO_Type__c = type,
            ASI_MFM_PO_Raised_Date__c = date.today(),
            ASI_MFM_PO_Start_Date__c = date.today(),
            ASI_MFM_PO_End_Date__c = date.today().addmonths(1),
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_CAP_PO'),
            ASI_MFM_Prefix__c = createPrefixPO().id,
            ASI_MFM_Plan__c = plan.id
        );
        insert po;
        return po;
    }
    
    public static ASI_MFM_PO__c createPoClone(ASI_MFM_PO__c poCloned)
    {
        ASI_MFM_PO__c po = new ASI_MFM_PO__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_PO__cASI_MFM_CAP_PO'),
            ASI_MFM_Prefix__c = poCloned.ASI_MFM_Prefix__c,
            ASI_MFM_Cloned_PO_ID__c = poCloned.id
        );
        insert po;
        return po;
    }
    
    public static ASI_MFM_PO_Line_Item__c createPoLines(ASI_MFM_PO__c po)
    {
        
        ASI_MFM_PO_Line_Item__c poLine = new ASI_MFM_PO_Line_Item__c
        (
            ASI_MFM_G_L_Date__c = date.today(),
            ASI_MFM_PO__c = po.id,
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_PO_Line_Item__cASI_MFM_CAP_PO_Line_Item'),
            ASI_MFM_Exchange_Rate__c = 1,
            ASI_MFM_Amount__c = 100,
            ASI_MFM_AP_Code__c = createAPCode().id
        );
        insert poLine;
        return poLine;
    }
    
    public static ASI_MFM_Payment__c createPayment()
    {
        ASI_MFM_Payment__c payment = new ASI_MFM_Payment__c
        (
            ASI_MFM_Payment_Type__c = 'OPEX',
            ASI_MFM_Plan__c = createPlanOpex().id,
            ASI_MFM_Currency__c = 'HKD',
            ASI_MFM_Prefix__c= createPrefixPayment().id,
            ASI_MFM_Supplier_Name__c = createAccSupplier().id,
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Payment__cASI_MFM_CAP_Payment'),
            ASI_MFM_Is_Direct_Payment__c = true,
            ASI_MFM_Status__c = 'Draft',
            ASI_MFM_Invoice_Date__c = date.today(),
            ASI_MFM_Invoice_Number__c = '123Tesyt'
        );
        insert payment;
        return payment;
    }
    
    public static ASI_MFM_Payment__c createPayment(ASI_MFM_PO__c PO)
    {
        ASI_MFM_Payment__c payment = new ASI_MFM_Payment__c
        (
            ASI_MFM_Payment_Type__c = 'OPEX',
            ASI_MFM_Plan__c = PO.ASI_MFM_Plan__c,
            ASI_MFM_Currency__c = 'HKD',
            ASI_MFM_Prefix__c= createPrefixPayment().id,
            ASI_MFM_Supplier_Name__c = createAccSupplier().id,
            recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Payment__cASI_MFM_CAP_Payment'),
            ASI_MFM_Is_Direct_Payment__c = true,
            ASI_MFM_Status__c = 'Draft',
            ASI_MFM_Invoice_Date__c = date.today(),
            ASI_MFM_Invoice_Number__c = '123Tesyt'
        );
        insert payment;
        return payment;
    }
    
    public static ASI_MFM_Payment_Line_Item__c createPaymentLines(ASI_MFM_Payment__c payment, ASI_MFM_PO_Line_Item__c poi)
    {
        ASI_MFM_Payment_Line_Item__c pyi = new ASI_MFM_Payment_Line_Item__c
        (
        recordTypeId = Global_RecordTypeCache.getRtId('ASI_MFM_Payment_Line_Item__cASI_MFM_CAP_Payment_Line_Item'),
        ASI_MFM_Payment__c=payment.id, 
        ASI_MFM_Payment_Amount__c=10, 
        ASI_MFM_PO_Line_Item__c=poi.id, 
        ASI_MFM_Invoice_Date__c = date.today(), 
        ASI_MFM_Invoice_Number__c = '123456',
        ASI_MFM_AP_Code__c = createOPEXAPCode().id,
        ASI_MFM_A_C_Code__c = createACCode().id,
        ASI_MFM_BU__c = createOPEXBUCode().id
        );                       
        insert pyi;
        return pyi;
    }
    
    public static ASI_MFM_Budget__c createBudget()
    {
        ASI_MFM_Budget__c budget = new ASI_MFM_Budget__c
        (
            recordtypeid = Global_RecordTypeCache.getRtId('ASI_MFM_Budget__cASI_MFM_CAP_Budget'),
            ASI_MFM_AP_Code__c = createCAPEXAPCode().id,
            ASI_MFM_Budget_Type__c = 'CAPEX',
            ASI_MFM_Type__c = 'Original Budget',
            ASI_MFM_Fiscal_Year__c = 'FY1314'
        );
        
        insert budget;
        return budget;
    }

}