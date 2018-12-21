trigger EUR_CRM_ServicePackTrigger on EUR_CRM_Service_Pack__c (before insert) {
    
    EUR_CRM_Affiliate__c affiliate = EUR_CRM_ProsSegmentationClass.returnAffiliate();
    
    for(EUR_CRM_Service_Pack__c servicePack: Trigger.new)
    {
        if (affiliate!=null){
            servicePack.EUR_CRM_Affiliate__c = affiliate.Id;
        }else{
            servicePack.addError('Please contact System Administrator, affiliate is not set');
        }
    }

    
}