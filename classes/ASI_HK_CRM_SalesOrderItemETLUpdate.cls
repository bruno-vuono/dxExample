public without sharing class ASI_HK_CRM_SalesOrderItemETLUpdate extends ASI_HK_CRM_TriggerAbstract {

    //private ASI_HK_CRM_SalesOrderManager.SalesOrderManagerHttpPort soPort;
    /*
    *   This Trigger class is used to update the Has Cancelled Item checkbox in the related Sales Order record 
    *   When the related sales order items are manually updated through ETL
    */
    
    public ASI_HK_CRM_SalesOrderItemETLUpdate() {
        super('ASI_HK_CRM_SalesOrderItemETLUpdate');
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) 
    {                
        if ((tAction == TriggerAction.AFTER_INSERT || tAction == TriggerAction.AFTER_UPDATE || tAction == TriggerAction.AFTER_DELETE) && !isBypassByCurrentUser()) 
        { 
            //initSalesOrderPortIfNeeded();
            
            List<ASI_HK_CRM_Sales_Order_Item__c> soDetails = (List<ASI_HK_CRM_Sales_Order_Item__c>)sObjList;
            
            Set<ID> soIds = new Set<ID>();
            for (ASI_HK_CRM_Sales_Order_Item__c soDetail : soDetails)
                soIds.add(soDetail.ASI_HK_CRM_Sales_Order__c);
                
            List<ASI_HK_CRM_Sales_Order__c> soList = [SELECT ID, ASI_HK_CRM_Has_Cancelled_Line_Item__c, name, owner.Name, owner.email, ASI_HK_CRM_Customer_DA__r.Name FROM ASI_HK_CRM_Sales_Order__c WHERE ID IN: soIds];
            List<ASI_HK_CRM_Sales_Order_Item__c> relatedsoDetails = [SELECT ID, ASI_HK_CRM_Quantity__c, ASI_HK_CRM_Cancel_Qty__c, ASI_HK_CRM_Sales_Order__c FROM ASI_HK_CRM_Sales_Order_Item__c WHERE ASI_HK_CRM_Sales_Order__c IN: soIds];
            Map<ID, List<ASI_HK_CRM_Sales_Order_Item__c>> soDetailsMap = new Map<ID, List<ASI_HK_CRM_Sales_Order_Item__c>>();
            
            //Map the sales order item list according to their master relationship: Sales Order
            for (ASI_HK_CRM_Sales_Order_Item__c soDetail : soDetails)
            {
                List<ASI_HK_CRM_Sales_Order_Item__c> tempsoDetail = new List<ASI_HK_CRM_Sales_Order_Item__c>();
                for (ASI_HK_CRM_Sales_Order_Item__c relatedsoDetail : relatedsoDetails)
                {
                    if (soDetail.ASI_HK_CRM_Sales_Order__c == relatedsoDetail.ASI_HK_CRM_Sales_Order__c)
                        tempsoDetail.add(relatedsoDetail);
                }
                if (tempsoDetail.size() > 0)
                    soDetailsMap.put(soDetail.ASI_HK_CRM_Sales_Order__c, tempsoDetail);
            }
            
            Set<ASI_HK_CRM_Sales_Order__c> soToUpdateSet = new Set<ASI_HK_CRM_Sales_Order__c>();
            for (ASI_HK_CRM_Sales_Order__c so : soList) 
            {
                List<ASI_HK_CRM_Sales_Order_Item__c> tempSoDetail = soDetailsMap.get(so.id) == null ? new List<ASI_HK_CRM_Sales_Order_Item__c>() :  soDetailsMap.get(so.id);
                boolean isCancel = true;
                for (ASI_HK_CRM_Sales_Order_Item__c soDetail : tempSoDetail)
                {
                    if (soDetail.ASI_HK_CRM_Cancel_Qty__c == null && so.ASI_HK_CRM_Has_Cancelled_Line_Item__c == true)
                    {
                        so.ASI_HK_CRM_Has_Cancelled_Line_Item__c = false;
                        isCancel = false;
                    }
                    
                    if (soDetail.ASI_HK_CRM_Cancel_Qty__c != null && so.ASI_HK_CRM_Has_Cancelled_Line_Item__c == false)
                    {
                        so.ASI_HK_CRM_Has_Cancelled_Line_Item__c = true;
                        soToUpdateSet.add(so);
                        isCancel = true;
                        break;
                    }
                }
                if (!isCancel)
                    soToUpdateSet.add(so);
            }
            if (soToUpdateSet.size() > 0)
            {
                List<ASI_HK_CRM_Sales_Order__c> soToUpdateList = new List<ASI_HK_CRM_Sales_Order__c>();
                soToUpdateList.addAll(soToUpdateSet);
                for(ASI_HK_CRM_Sales_Order__c updateSO : soToUpdateList){
                System.debug('updclk1 ' + updateSo.name);
                    if(updateSO.ASI_HK_CRM_Has_Cancelled_Line_Item__c){
                        System.debug('updclk2 ' + updateSo.name);
                        if (updateSO.name != null)
                        {
                            sendHasUnavailableEmail(updateSO);
                        }
                    }
                }
                update soToUpdateList;
            }

        }
    }
    
    public void sendHasUnavailableEmail(ASI_HK_CRM_Sales_Order__c so){
        System.debug('aku1'+so.Name); 
        System.debug('aku2'+so.owner.Name);
        System.debug('aku3'+so.Id);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        EmailTemplate et = [select id, subject, Body, developerName from EmailTemplate where developerName = 'ASI_HK_CRM_SO_Has_Unavailable_Item'];
        //String[] toAddresses = new String[]{'cpantua@laputatech.com'};
        //String[] toAddresses = new String[]{'aku@laputatech.com','vkoh@laputatech.com','kxie@laputatech.com'};
        //String[] toAddresses = getRecipientFromCustomSet();
        //String[] toAddresses = new String[]{'vkoh@laputatech.com'};       
        //String[] toAddresses = new String[]{'aku@laputatech.com','vkoh@laputatech.com'};  
        String[] toAddresses = new String[]{};
        if (so.ownerId != null) {
            if(so.owner.email != null){ 
                System.debug('aku4'+so.owner.email);
                toAddresses.add(so.owner.email);
            }
        }   
        System.debug('address mailing3:'+toAddresses);
        System.debug('aku1:'+so.ASI_HK_CRM_Customer_DA__r.Name);
        mail.setToAddresses(toAddresses);
        //Mailing Subject
        String mailingSubject = et.subject;
        mailingSubject = mailingSubject.replace('soNumber', so.Name);
        mailingSubject = mailingSubject.replace('customerDA', so.ASI_HK_CRM_Customer_DA__r.Name);
        mailingSubject = mailingSubject.replace('salesmanName', so.owner.Name);
        
        //Mailing Message
        String mailingBody = et.body;
        mailingBody = mailingBody.replace('{soOwner}', so.owner.Name);
        mailingBody = mailingBody.replace('{soURL}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + so.Id);
        
        
        mail.setSubject(mailingSubject);              
        mail.setPlainTextBody(mailingBody);
        mail.setEmailPriority('High');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});        
    }    
    
    /*private ASI_HK_CRM_SalesOrderManagerTypes.ShowSalesHeader checkForExtraItems(ASI_HK_CRM_Sales_Order__c so) {
        ASI_HK_CRM_SalesOrderManagerTypes.GetSalesHeader reqInput = new ASI_HK_CRM_SalesOrderManagerTypes.GetSalesHeader();
        reqInput.company = so.ASI_HK_CRM_SYS_DocumentCompany__c;
        reqInput.businessUnit = so.ASI_HK_CRM_Business_Unit__c;
        ASI_HK_CRM_SalesOrderManagerTypes.SalesOrderKey soKey = new ASI_HK_CRM_SalesOrderManagerTypes.SalesOrderKey();
        reqInput.salesOrderKey = soKey;
        soKey.documentNumber = Integer.valueOf(so.ASI_HK_CRM_Code__c);
        soKey.documentCompany = reqInput.company;
        soKey.documentTypeCode = so.ASI_HK_CRM_JDE_Order_Type_Code__c;
        
        ASI_HK_CRM_SalesOrderManagerTypes.ShowSalesOrder reqResult = soPort.getSalesOrder(reqInput);
        if (reqResult != null && reqResult.header != null && reqResult.header.size() > 0) {
            System.debug('clkHEADER ' + reqResult.header[0]);
            return reqResult.header[0];
        }
        return null;
    }
    
    private void initSalesOrderPortIfNeeded() {
        if (soPort == null) {
            List<ASI_HK_CRM_Web_Service_Setting__c> wsSettings = [
                SELECT Id, ASI_HK_CRM_Base_URL__c, ASI_HK_CRM_Username__c, ASI_HK_CRM_Password__c
                FROM ASI_HK_CRM_Web_Service_Setting__c
                WHERE ASI_HK_CRM_Key__c = 'ASI_HK_CRM_SalesOrderSubmit'
            ];
            if (wsSettings.size() == 1) {
                ASI_HK_CRM_Web_Service_Setting__c wsSetting = wsSettings[0];
                soPort = new ASI_HK_CRM_SalesOrderManager.SalesOrderManagerHttpPort(
                    wsSetting.ASI_HK_CRM_Base_URL__c
                    , wsSetting.ASI_HK_CRM_Username__c
                    , wsSetting.ASI_HK_CRM_Password__c
                );
                soPort.timeout_x = 120000;
            } else if (wsSettings.size() == 0) {
                throw new SalesOrderExtraItemException('ASI HK CRM web service setting not found');
            } else {
                throw new SalesOrderExtraItemException('Duplicate ASI HK CRM web service settings');
            }
        }
    }
    
    public class SalesOrderExtraItemException extends Exception {
        
    }*/


}