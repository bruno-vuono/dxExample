public with sharing class ASI_CRM_CN_ProductWarehouse_ListCTRL {
    
    Public List<ASI_CRM_Product_Warehouse_Photo__c> attachmentList{Get; Set;}
    Public List<ASI_CRM_SKU_Photo__c> attachmentList_SKU{Get; Set;}
    //Public Map<Id, String> mapFile{Get; Set;}
    
    Public ASI_CRM_CN_ProductWarehouse_ListCTRL(ApexPages.StandardController controller){
        
        Id headerId = controller.getId();
        
        String sObjType = headerId.getSObjectType().getDescribe().getName();
        
        if(sObjType == 'ASI_MFM_Item_Group__c'){
            
            //Set<Id> fileIdSet = new Set<Id>();
            //mapFile = new Map<Id, String>();
            attachmentList = new List<ASI_CRM_Product_Warehouse_Photo__c>();
            
            List<ASI_CRM_Product_Warehouse_Photo__c> tmpAttachmentList = [SELECT Id
                                                                          , ASI_Name__c
                                                                          , ASI_Preview__c
                                                                          , ASI_CRM_Photo_Category__c
                                                                          , ASI_CRM_Photo_Version__c
                                                                          , ASI_CRM_Comments__c
                                                                          , ASI_CRM_Preview_URL__c
                                                                          , ASI_Image_URL__c
                                                                          , ASI_FileID__c
                                                                          , ASI_File_Extension__c
                                                                          FROM ASI_CRM_Product_Warehouse_Photo__c
                                                                          WHERE ASI_CRM_Item_Group__c = : headerId
                                                                          AND ASI_CRM_Photo_Version__c != NULL
                                                                          AND RecordType.DeveloperName = 'ASI_CRM_CN_Product_Warehouse_Photo'
                                                                          ORDER BY ASI_CRM_Photo_Category__c ASC
                                                                          , ASI_CRM_Photo_Version__c DESC
                                                                          , ASI_Name__c ASC
                                                                         ];
            
            
                /*for(ASI_CRM_Product_Warehouse_Photo__c obj : tmpAttachmentList){
                    fileIdSet.add(obj.ASI_FileID__c);
                }

				List<ContentVersion> fileList = new List<ContentVersion>([SELECT VersionData FROM ContentVersion WHERE ID IN : fileIdSet]);
                    
				for(ContentVersion obj : fileList){
                    
                        String data = EncodingUtil.base64Encode(obj.VersionData);
                        
                        mapFile.put(obj.id, data);
            	}*/
            
            Map<String, ASI_CRM_Product_Warehouse_Photo__c> tmpMap = new Map<String, ASI_CRM_Product_Warehouse_Photo__c>();
            for(ASI_CRM_Product_Warehouse_Photo__c obj : tmpAttachmentList){
                
                if(!tmpMap.containsKey(obj.ASI_CRM_Photo_Category__c)){
                    
                    tmpMap.put(obj.ASI_CRM_Photo_Category__c, obj);
                }else if(tmpMap.containsKey(obj.ASI_CRM_Photo_Category__c)){
                    
                    if(tmpMap.get(obj.ASI_CRM_Photo_Category__c).ASI_CRM_Photo_Version__c < obj.ASI_CRM_Photo_Version__c){
                        tmpMap.put(obj.ASI_CRM_Photo_Category__c, obj);
                    }else if(tmpMap.get(obj.ASI_CRM_Photo_Category__c).ASI_CRM_Photo_Version__c == obj.ASI_CRM_Photo_Version__c){
                        tmpMap.put('' + obj.ASI_CRM_Photo_Category__c + obj.Id, obj);
                    }
                }
            }
            attachmentList = tmpMap.values();
        }else if(sObjType == 'ASI_MFM_SKU_Code__c'){
            attachmentList_SKU = new List<ASI_CRM_SKU_Photo__c>([SELECT Id
                                                                 , ASI_CRM_Attachment__c
                                                                 , ASI_CRM_Attachment__r.ASI_Name__c
                                                                 , ASI_CRM_Attachment__r.ASI_Preview__c
                                                                 , ASI_CRM_Attachment__r.ASI_CRM_Photo_Category__c
                                                                 , ASI_CRM_Attachment__r.ASI_CRM_Photo_Version__c
                                                                 , ASI_CRM_Attachment__r.ASI_CRM_Comments__c
                                                                 , ASI_CRM_Attachment__r.ASI_CRM_Preview_URL__c
                                                                 , ASI_CRM_Attachment__r.ASI_Image_URL__c
                                                                 , ASI_CRM_Attachment__r.ASI_FileID__c
                                                                 , ASI_CRM_Attachment__r.ASI_File_Extension__c
                                                                 FROM ASI_CRM_SKU_Photo__c
                                                                 WHERE ASI_CRM_SKU__c = : headerId
                                                                 ORDER BY ASI_CRM_Attachment__r.ASI_CRM_Photo_Category__c ASC
                                                                 , ASI_CRM_Photo_Version__c DESC
                                                                 , ASI_CRM_Attachment__r.ASI_Name__c ASC
                                                                ]);
        }
    }
}