public class ASI_eForm_HK_VendorFormAttac_Security {

    Public Static void updateContentVersionSecurity(Set<Id> contentVersionId, Set<Id> userIDSet, Id soaAdmin){
        
        if(contentVersionId != Null){
            
            Set<Id> contentDoc = new Set<Id>();
            Set<Id> userId = new Set<Id>();
            
            List<ContentVersion> cv = new List<ContentVersion>([SELECT Id, ContentDocumentId, SharingPrivacy FROM ContentVersion WHERE Id IN : contentVersionId]);
            List<ContentDocumentLink > cdl = new List<ContentDocumentLink>();
            
            List<ContentDocumentLink> deleteList = new List<ContentDocumentLink>();
            List<ContentDocumentLink> insertList = new List<ContentDocumentLink>();
            Set<Id> docIdSet = new Set<Id>();
            
            if(cv.size() > 0){
                for(ContentVersion obj : cv){
                    
                    contentDoc.add(obj.ContentDocumentId);
                }
                
                if(contentDoc.size() > 0){
                    
                    List<ContentDocument> cd = new List<ContentDocument>([SELECT Id, OwnerId FROM ContentDocument WHERE Id IN : contentDoc]);
                    cdl = new List<ContentDocumentLink>([SELECT ContentDocumentId, LinkedEntityId, ShareType, Visibility FROM ContentDocumentLink WHERE ContentDocumentId IN : contentDoc]);
                    
                    if(cd.size() > 0 && soaAdmin != Null){
                        for(ContentDocument obj : cd){
                            obj.OwnerId = soaAdmin;
                        }
                        
                        Try{
                            
                            Update cd;
                            
                        }catch(dmlException dmle){
                            
                        }
                    }
                    
                    if(cdl.size() > 0){
                        for(ContentDocumentLink obj : cdl){
                            if(obj.LinkedEntityId.getSObjectType().getDescribe().getName().toLowerCase() != 'user'){
                                
                                deleteList.add(obj);
                            }else if(obj.LinkedEntityId.getSObjectType().getDescribe().getName().toLowerCase() == 'user'){
                                    
                                    userId.add(obj.LinkedEntityId);
                                    docIdSet.add(obj.ContentDocumentId);
                            }
                        }
                        
                        for(Id obj : docIdSet){
                            for(Id user : userIDSet){
                                if(!userId.contains(user) && user != soaAdmin){
                                    insertList.add(new ContentDocumentLink(ContentDocumentId = obj
                                                                           , LinkedEntityId = user
                                                                           , ShareType = 'V'
                                                                           , Visibility = 'AllUsers'
                                                                          ));
                                }
                            }
                        }
                        
                        Try{
                            
                            if(insertList.size() > 0)
                                Insert insertList;
                            if(deleteList.size() > 0)
                                Delete deleteList;
                            
                        }catch(dmlException dmle){
                            
                        }
                    }
                }
            }
        }
    }
}