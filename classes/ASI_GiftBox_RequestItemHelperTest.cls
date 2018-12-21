/**********************************************************************************
 * Name : ASI_GiftBox_RequestItemHelperTest
 * Created : DC @03/30/2016 3:14 PM
 * Revision History:
 * 1. 03/30/2016 - [DC 1.0] Created
 
 **********************************************************************************/

@isTest(seeAllData=false)
    private class ASI_GiftBox_RequestItemHelperTest { 
        static ASI_GiftBox_Request_Header__c requestHeader=new ASI_GiftBox_Request_Header__c();
        static ASI_GiftBox_Request_Item__c requestItem=new ASI_GiftBox_Request_Item__c();
        static ASI_GiftBox_Customer__c customer = new ASI_GiftBox_Customer__c();
        static ASI_GiftBox_Inventory_Master__c item = new ASI_GiftBox_Inventory_Master__c();
        
        static void insertCustomer(){
            Id recordId = Schema.SObjectType.ASI_GiftBox_Request_Item__c.getRecordTypeInfosByName().get('ASI VN POSM Request Item').getRecordTypeId();
            customer.RecordTypeID = recordId ;
            customer.Name='test customer';
            insert customer;
            
            
        }
       
       
        static testMethod  void insertItem(){    
            item.RecordTypeID = Schema.SObjectType.ASI_GiftBox_Inventory_Master__c.getRecordTypeInfosByName().get('ASI GiftBox VN GiftBox Master').getRecordTypeId();
            item.Name='test_item1';
            item.ASI_CRM_Category__c = ' Podium stand';      
            insert item;
           
            
        }
        
        static testMethod  void insertRequest(){
            insertItem();
            requestHeader.RecordTypeID = Schema.SObjectType.ASI_GiftBox_Request_Header__c.getRecordTypeInfosByName().get('ASI POSM VN Request').getRecordTypeId();
            requestHeader.ASI_CRM_Customer__c=customer.RecordTypeID;   
            requestHeader.ASI_GiftBox_Status__c='Complete';
            
            insert requestHeader;
            
            
             
            ASI_GiftBox_Request_Header__c headerID = new ASI_GiftBox_Request_Header__c();
            headerID = [SELECT Id,OwnerId,
                               RecordTypeID,
                               ASI_CRM_Customer__c,
                               ASI_GiftBox_Status__c
                        FROM ASI_GiftBox_Request_Header__c];   
            System.assertEquals('Complete',headerID.ASI_GiftBox_Status__c);
            System.assertEquals(headerID.ASI_CRM_Customer__c,requestHeader.ASI_CRM_Customer__c);
            
           
            requestItem.RecordTypeID = Schema.SObjectType.ASI_GiftBox_Request_Item__c.getRecordTypeInfosByName().get('ASI VN POSM Request Item').getRecordTypeId();
            requestItem.ASI_GiftBox_Request_Item__c=item.Id;
            requestItem.ASI_GiftBox_Request_Id__c=requestHeader.Id;
            requestItem.ASI_GiftBox_Request_Item_Warehouse__c='W';
            requestItem.ASI_GiftBox_Request_Quantity__c = 1;
            insert requestItem;         
           
            requestItem=new ASI_GiftBox_Request_Item__c();
            requestItem.ASI_GiftBox_Request_Item__c=item.Id;
            requestItem.RecordTypeID = Schema.SObjectType.ASI_GiftBox_Request_Item__c.getRecordTypeInfosByName().get('ASI VN POSM Request Item').getRecordTypeId();
            requestItem.ASI_GiftBox_Request_Id__c=requestHeader.Id;
            requestItem.ASI_GiftBox_Request_Item_Warehouse__c='W';
            requestItem.ASI_GiftBox_Request_Quantity__c = 2;
            insert requestItem; 
            
            
            
                 
        } 
            
                                                               
    
    }