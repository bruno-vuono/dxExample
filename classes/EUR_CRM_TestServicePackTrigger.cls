public with sharing class EUR_CRM_TestServicePackTrigger {
    private static User user;
    private static EUR_CRM_Affiliate__c affiliate;
    
    public static void init(){
        user = EUR_CRM_TestClassHelper.runAsStandardUserPortugal();
    }
    
    static testMethod void test(){
        init();
        System.runAs(user){
	        String groupOutletName = 'Test';
	        String imageLevelName = 'Iconic';
	        
	        affiliate = EUR_CRM_TestClassHelper.createAffiliate();
	        insert affiliate;
	        
	        EUR_CRM_Service_Pack__c servicePack = EUR_CRM_TestClassHelper.createServicePack(
	                                            affiliate.Id, 
	                                            groupOutletName, 
	                                            imageLevelName);
	        
	        insert servicePack;
	        
	        System.assert(servicePack.EUR_CRM_Affiliate__c!=null);
        }
    }
}