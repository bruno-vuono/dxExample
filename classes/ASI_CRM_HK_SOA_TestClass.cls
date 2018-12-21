@isTest
private class ASI_CRM_HK_SOA_TestClass {
	private static ASI_HK_CRM_TestUtils.CommonData cmData;
    
   static {
        ASI_HK_CRM_TestUtils.initSOEssentialSettings();
        cmData = new ASI_HK_CRM_TestUtils.CommonData();
        ASI_HK_CRM_TestUtils.assignCreditAccountData(cmData, 3, 3);
        ASI_HK_CRM_TestUtils.assignSalesOrderData(cmData, 3, 3);
    }
	
    @isTest static void testCalloutSOInterface() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ASI_CRM_HK_SOA_CallOutMock());

        // Call the method that invokes a callout
        ASI_HK_CRM_Sales_Order__c so = cmData.so;

		Set<Id> soID = new Set<Id>();
		soID.add(so.Id);
		
        ASI_SOA_Setting__c setting = new ASI_SOA_Setting__c(Name='ASI_CRM_HK_SO_EnableSOAInterface', ASI_SOA_Enable__c=true);
        insert setting;
        
		Test.startTest();
		
		ASI_CRM_HK_SOA_InvokeSOA.submitSO(soID);

		ASI_CRM_HK_SOA_BSSVTypes.detail_element bssvDetail = new ASI_CRM_HK_SOA_BSSVTypes.detail_element();
		ASI_CRM_HK_SOA_BSSVTypes.OrderDetail_element bssvOrderDetail = new ASI_CRM_HK_SOA_BSSVTypes.OrderDetail_element();
		ASI_CRM_HK_SOA_BSSVTypes.header_element bssvHeaderElement = new ASI_CRM_HK_SOA_BSSVTypes.header_element();
		

		ASI_CRM_HK_SOA_WSSSecurity.UsernameToken_element wsSecurityUserName = new ASI_CRM_HK_SOA_WSSSecurity.UsernameToken_element();
		ASI_CRM_HK_SOA_WSSSecurity.HeaderSecurityType wsSecurityType = new ASI_CRM_HK_SOA_WSSSecurity.HeaderSecurityType();

		ASI_CRM_HK_SOA_SOHeader.header_element headerElement = new ASI_CRM_HK_SOA_SOHeader.header_element();
		ASI_CRM_HK_SOA_SOHeader.OrderHeader_element orderHeaderElement = new ASI_CRM_HK_SOA_SOHeader.OrderHeader_element();

		//Test coverage for callout mock
		ASI_CRM_HK_SOA_SOIntegration.processResponse_element obj = new ASI_CRM_HK_SOA_SOIntegration.processResponse_element();
		Map<String, Object> responseMap = new Map<String, Object>();
		responseMap.put('Test', obj);
		
		Test.stopTest();
    }
	
	@isTest static void testCalloutARCheck() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ASI_CRM_HK_SOA_CallOutMockARCheck());

        // Call the method that invokes a callout
        ASI_HK_CRM_Sales_Order__c so = cmData.so;
		
        ASI_SOA_Setting__c setting = new ASI_SOA_Setting__c(Name='ASI_CRM_HK_SO_EnableSOAInterface', ASI_SOA_Enable__c=true);
        insert setting;
        
		Test.startTest();
		
		ApexPages.StandardController stdController = new ApexPages.StandardController(so);		
		ASI_HK_CRM_SalesOrderARCheckController controller = new ASI_HK_CRM_SalesOrderARCheckController(stdController);
		
		controller.requestARInfo();
		
		ASI_CRM_HK_SOA_BSSVTypes.detail_element bssvDetail = new ASI_CRM_HK_SOA_BSSVTypes.detail_element();
		ASI_CRM_HK_SOA_BSSVTypes.OrderDetail_element bssvOrderDetail = new ASI_CRM_HK_SOA_BSSVTypes.OrderDetail_element();
		ASI_CRM_HK_SOA_BSSVTypes.header_element bssvHeaderElement = new ASI_CRM_HK_SOA_BSSVTypes.header_element();
		

		ASI_CRM_HK_SOA_ARCheck_WSSecurity.UsernameToken_element wsSecurityUserName = new ASI_CRM_HK_SOA_ARCheck_WSSecurity.UsernameToken_element();
		ASI_CRM_HK_SOA_ARCheck_WSSecurity.HeaderSecurityType wsSecurityType = new ASI_CRM_HK_SOA_ARCheck_WSSecurity.HeaderSecurityType();
		
		//Test coverage for callout mock
		ASI_CRM_HK_SOA_ARCheck.processResponse_element obj = new ASI_CRM_HK_SOA_ARCheck.processResponse_element();
		Map<String, Object> responseMap = new Map<String, Object>();
		responseMap.put('Test', obj);
		
		Test.stopTest();
    }
}