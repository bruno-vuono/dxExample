public class ASI_MFM_CN_SKU_TriggerClass {
    
    Public Static void beforeInsertMedthod(List<ASI_MFM_SKU_Code__c> triggerNew){
        
        //Map<String, String> allUserName = new Map<String, String>();
        
        /*for(ASI_MFM_SKU_Code__c obj : triggerNew){
            
            if(obj.ASI_CRM_Location_Owner_JDE__c != NULL && obj.ASI_CRM_Location_Owner_JDE__c != '' && obj.ASI_MFM_SKU_Code__c != NULL && obj.ASI_MFM_SKU_Code__c != '')
                allUserName.put(obj.ASI_MFM_SKU_Code__c, obj.ASI_CRM_Location_Owner_JDE__c.length() > 14 ? ('%' + obj.ASI_CRM_Location_Owner_JDE__c.subString(0,15).toLowerCase() + '%') : '%' + obj.ASI_CRM_Location_Owner_JDE__c.subString(0,obj.ASI_CRM_Location_Owner_JDE__c.length()).toLowerCase() + '%');
        }*/
        
        //20161110 Elufa
        
        /*Map<String, String> mapUser2 = new Map<String, String>();
        
        for(User ur : [SELECT id, Name FROM User WHERE CompanyName LIKE 'Pernod Ricard China' AND isActive = TRUE]){
            
            String fl = ur.Name.replace(' ', '').trim();
            
            if(fl.length()>14)
                mapUser2.put((fl.toLowerCase().subString(0,15)), ur.id);
            else
                mapUser2.put((fl.toLowerCase().subString(0,fl.length())), ur.id);
            
        }*///20170602 Introv Commented
        
        /*List<User> userList = new List<User>([SELECT id, Name FROM User WHERE Name like : allUserName.values() AND isActive = TRUE]);//20160503 Ben @ Elufa Added **AND isActive = TRUE
        
        Map<String, String> mapUser = new Map<String, String>();
        for(User obj : userList){
            if(obj.Name.length()>14)
                mapUser.put(('%' + obj.Name.toLowerCase().subString(0,15) + '%'), obj.id);
            else
                mapUser.put(('%' + obj.Name.toLowerCase().subString(0,obj.Name.length()) + '%'), obj.id);
        }*/
        
        /*for(ASI_MFM_SKU_Code__c obj : triggerNew){
            
            String JDEOwner = '';
            
            if(obj.ASI_CRM_Location_Owner_JDE__c != NULL && obj.ASI_CRM_Location_Owner_JDE__c != '')
                JDEOwner = obj.ASI_CRM_Location_Owner_JDE__c.replace(' ', '').toLowerCase();
            
            if(JDEOwner.length() > 14)
                JDEOwner = JDEOwner.subString(0,15);
            else
                JDEOwner = JDEOwner.subString(0,JDEOwner.length());
            
            if(mapUser2.containsKey(JDEOwner) && !obj.ASI_CRM_By_Pass_Trigger__c){
                
                obj.ASI_FOC_Location_Item_Owner__c = mapUser2.get(JDEOwner);
            }else if(!obj.ASI_CRM_By_Pass_Trigger__c){
                
                obj.ASI_FOC_Location_Item_Owner__c = NULL;
            }*///20170602 Introv Commented
            
            /*if(mapUser.containsKey(allUserName.get(obj.ASI_MFM_SKU_Code__c)) && !obj.ASI_CRM_By_Pass_Trigger__c){
                
                obj.ASI_FOC_Location_Item_Owner__c = mapUser.get(allUserName.get(obj.ASI_MFM_SKU_Code__c));
            }else if(/*( obj.ASI_CRM_Location_Owner_JDE__c == NULL || obj.ASI_CRM_Location_Owner_JDE__c == '' ) && *//*!obj.ASI_CRM_By_Pass_Trigger__c){
                
                obj.ASI_FOC_Location_Item_Owner__c = NULL;
            }*/
        //}
    }
    
    Public Static Void afterInsertMethod(List<ASI_MFM_SKU_Code__c> triggerNew){
        
        if(!ASI_CRM_CN_Function.IsBypassTrigger('ASI_MFM_CN_SKU_TriggerClass')){
            Set<Id> itemGroupId = new Set<Id>();
            List<ASI_CRM_SKU_Photo__c> listOfSKUPhoto = new List<ASI_CRM_SKU_Photo__c>();
            Map<Id, Map<String, ASI_CRM_Product_Warehouse_Photo__c>> mapProductPhoto = new Map<Id, Map<String, ASI_CRM_Product_Warehouse_Photo__c>>();
            
            for(ASI_MFM_SKU_Code__c obj : triggerNew){
                
                if(obj.ASI_MFM_Item_Group__c != NULL){
                    itemGroupId.add(obj.ASI_MFM_Item_Group__c);
                }
            }
            
            for(ASI_CRM_Product_Warehouse_Photo__c obj : [SELECT id
                                                          , ASI_CRM_Photo_Category__c
                                                          , ASI_CRM_Item_Group__c
                                                          , ASI_CRM_Photo_Version__c
                                                          FROM ASI_CRM_Product_Warehouse_Photo__c
                                                          WHERE ASI_CRM_Item_Group__c IN : itemGroupId
                                                          AND ASI_CRM_Photo_Version__c != NULL
                                                          AND ASI_CRM_Photo_Category__c != NULL
                                                          AND ASI_CRM_Photo_Category__c != ''
                                                          AND RecordType.DeveloperName = 'ASI_CRM_CN_Product_Warehouse_Photo'
                                                          ORDER BY ASI_CRM_Photo_Category__c ASC
                                                          , ASI_CRM_Photo_Version__c DESC
                                                         ]){
                                                             
                                                             Map<String, ASI_CRM_Product_Warehouse_Photo__c> mapProductPhoto2 = new Map<String, ASI_CRM_Product_Warehouse_Photo__c>();
                                                             
                                                             if(mapProductPhoto.containsKey(obj.ASI_CRM_Item_Group__c)){
                                                                 mapProductPhoto2 = mapProductPhoto.get(obj.ASI_CRM_Item_Group__c);
                                                                 
                                                                 if(mapProductPhoto2.containsKey(obj.ASI_CRM_Photo_Category__c)){
                                                                     if(mapProductPhoto2.get(obj.ASI_CRM_Photo_Category__c).ASI_CRM_Photo_Version__c < obj.ASI_CRM_Photo_Version__c){
                                                                         mapProductPhoto2.put(obj.ASI_CRM_Photo_Category__c, obj);
                                                                     }else if(mapProductPhoto2.get(obj.ASI_CRM_Photo_Category__c).ASI_CRM_Photo_Version__c == obj.ASI_CRM_Photo_Version__c){
                                                                         mapProductPhoto2.put('' + obj.ASI_CRM_Photo_Category__c + obj.Id, obj);
                                                                     }
                                                                 }else{
                                                                     mapProductPhoto2.put(obj.ASI_CRM_Photo_Category__c, obj);
                                                                 }
                                                             }else{
                                                                 mapProductPhoto2.put(obj.ASI_CRM_Photo_Category__c, obj);
                                                             }
                                                             mapProductPhoto.put(obj.ASI_CRM_Item_Group__c, mapProductPhoto2);
                                                         }
            
            for(ASI_MFM_SKU_Code__c obj : triggerNew){
                
                if(obj.ASI_MFM_Item_Group__c != NULL && mapProductPhoto.containsKey(obj.ASI_MFM_Item_Group__c)){
                    for(ASI_CRM_Product_Warehouse_Photo__c photo : mapProductPhoto.get(obj.ASI_MFM_Item_Group__c).values()){
                        
                        ASI_CRM_SKU_Photo__c tmpSKUPhoto = new ASI_CRM_SKU_Photo__c(ASI_CRM_Attachment__c = photo.id, ASI_CRM_SKU__c = obj.id, RecordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_SKU_Photo__cASI_CRM_CN_SKU_Photo'));
                        
                        listOfSKUPhoto.add(tmpSKUPhoto);
                    }
                }
            }
            
            try{
                insert listOfSKUPhoto;
            }catch(dmlException dmle){
                
            }
        }
    }
}