global class ESN_MB_NOP_GlobalDirectory_Cx {
     
    
    /**
    * Method create
    */
    @RemoteAction
    global static String createGlobalDirectory(String currentBrandId, String currentProduct) {
        String returnActivation = '';
        
        String brandId = currentBrandId;
        if(brandId.length() > 15) {
            brandId = brandId.SubString(0,15);
        }
        
        List<ESN_MB_Activation__c> activationGA = [Select Id, Name 
                                                   FROM ESN_MB_Activation__c 
                                                   WHERE recordType.DeveloperName = 'ESN_MB_Global_Directory' AND ESN_MB_BrandId__c = :brandId];
        
        if(activationGA.isEmpty()){
            ESN_MB_Activation__c activation = new ESN_MB_Activation__c();
            activation.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Global_Directory');
            activation.ESN_MB_Stage__c = 'Published';
            activation.CurrencyIsoCode = UserInfo.getDefaultCurrency();
            activation.ESN_MB_Product__c = currentProduct;
            insert(activation);    
            returnActivation = activation.Id;
        }else{
            ESN_MB_Activation__c activationGAreturn = [Select Id, Name FROM ESN_MB_Activation__c WHERE recordType.DeveloperName = 'ESN_MB_Global_Directory' AND ESN_MB_BrandId__c = :brandId];returnActivation = activationGAreturn.Id;
        }
        
        
        return returnActivation;
    }
    
    
        @RemoteAction
    global static String createEntryAssetGlobalDirectory(String currentActivationId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Activation__c = currentActivationId;
        entry.ESN_MB_Asset__c = assetId;
        entry.ESN_MB_RoleAsset__c = roleAsset;
        entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
        insert entry;
        return entry.Id;
    }
    
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveGlobalDirectoryAssets(String activationId) {
        List<ESN_MB_Entry__c> assetsList = [Select Id, 
                                            ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c ,ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c,ESN_MB_Asset__r.ESN_MB_Storyboard_Slide_Count__c,ESN_MB_Asset__r.ESN_MB_Storyboard_URL__c, 
                                             ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Asset__r.ESN_MB_SizeMo__c,ESN_MB_Asset__r.ESN_MB_URL_originalFile__c,ESN_MB_Asset__r.ESN_MB_Storyboard_LargeURL__c,
                                             ESN_MB_Asset__r.ESN_MB_originalFile_extension__c, ESN_MB_RoleAsset__c, ESN_MB_Asset__r.ESN_MB_Link_URL__c,ESN_MB_Asset__r.ESN_MB_DAMId__c,ESN_MB_Asset__r.ESN_MB_URL_bamVideoPreview__c
                                             FROM ESN_MB_Entry__c 
                                             WHERE recordType.DeveloperName = 'ESN_MB_Activations_to_Assets'
                                             AND ESN_MB_RoleAsset__c != 'MainAsset'
                                             AND ESN_MB_Activation__c = :activationId
                                             ORDER BY CreatedDate DESC];
        return assetsList;
    }
    
     @remoteAction 
    global static void deleteEntryAssetGlobalDirectory(String currentActivationId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entryAssetActivation = [Select Id 
                                                From ESN_MB_Entry__c 
                                                Where ESN_MB_Activation__c = :currentActivationId 
                                                And ESN_MB_Asset__c = :assetId
                                                And ESN_MB_RoleAsset__c = :roleAsset
                                                limit 1];
        delete entryAssetActivation;
    }
    
    @RemoteAction 
    global static boolean isBroadcasterUser(){ return ESN_MB_UtilsUser.isBroadcasterUser();}
    @RemoteAction 
    global static boolean isBroadCasterAssigned(String brandId){return ESN_MB_UtilsUser.isBroadCasterUser(brandId);}

}