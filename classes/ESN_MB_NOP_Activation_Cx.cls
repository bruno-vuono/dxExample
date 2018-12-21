/**
    About
    -----
    Description: Controler Class for MyBrands Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jul 2014

    Details
    -------
    This class contains methods for controlling MyBrands Activations
    
    Update History
    --------------
    Jul 2014 / Created by Kévin Gérard

    Issues / TODOs
    --------------
    Use custom labels for the strings used everywhere.
*/

global class ESN_MB_NOP_Activation_Cx {
    
    /**
    * Method retrieveActivation(currentProductId, currentRubricName)
    * @param currentProductId: String param containing the product selected by the user
    * @param currentRubricName: String param containing the rubric selected by the user
    * @return activationList: returns a list of activations
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveListBrandActivation(String currentBrandId, String currentProductId, String currentRubricId) {
        String brandId = currentBrandId;
        if(brandId.length() > 15) {
            brandId = brandId.substring(0,15);
        }
        String productId = currentProductId;
        if(productId.length() > 15) {
            productId = productId.substring(0,15);
        }
        String currentRubricName = [Select Name From ESN_MB_NodePage__c
                                Where id=:currentRubricId limit 1].Name;
        System.debug('currentRubricName = ' + '"' + currentRubricName+ '"');
        
        system.debug(brandId + '----' + productId);
        List<ESN_MB_Entry__c> activationList = new List<ESN_MB_Entry__c>();
        //Get the masterBrand Id
        String masterBrandId = [SELECT Id 
                                FROM ESN_MB_Nodepage__c 
                                WHERE recordType.DeveloperName = 'ESN_MB_Product'
                                AND ESN_MB_IsMasterbrand__c = true
                                AND ESN_MB_ParentId__c = :brandId
                                ORDER BY ESN_MB_Order__c ASC limit 1].Id;
        if(masterBrandId.length() > 15){
            masterBrandId = masterBrandId.substring(0,15);
        }
        system.debug('product Id : ' + productId + '----- masterbrand Id :' + masterBrandId);
        
        
        //Get the "Brand Activation" recordType id
        String brandActivationId = getRecordTypeId('ESN_MB_Brand_Activation');
  
        List<String> listIdActivationToRetrieve = new List<String>();
        //Get all the activations if user is manager or broadcaster
        if (isBroadCasterAssigned(brandId)) {
            List<ESN_MB_Entry__c> listEntryIdActivation = [Select ESN_MB_Activation__c
                              FROM ESN_MB_Entry__c 
                              WHERE RecordType.DeveloperName = 'Activations_To_Products'
                              AND ESN_MB_Activation__r.recordTypeId = :brandActivationId
                              AND ESN_MB_Node_Page__c = :productId
                              AND ESN_MB_Activation__r.ESN_MB_Activation_Type__c INCLUDES (:currentRubricName)]; 

            for(ESN_MB_Entry__c entryTmp:listEntryIdActivation) {
              listIdActivationToRetrieve.add(entryTmp.ESN_MB_Activation__c);
            }

        //Else only the activations tagged for this product and this rubric are added
        }else {
            List<ESN_MB_Entry__c> listEntryIdActivation = [Select ESN_MB_Activation__c
                              FROM ESN_MB_Entry__c 
                              WHERE RecordType.DeveloperName = 'Activations_To_Products'
                              AND ESN_MB_Activation__r.recordTypeId = :brandActivationId
                              //AND ESN_MB_Activation__r.ESN_MB_Stage__c = 'Published'
                              AND ESN_MB_Node_Page__c = :productId
                              AND ESN_MB_Activation__r.ESN_MB_Activation_Type__c INCLUDES (:currentRubricName)]; 

            for(ESN_MB_Entry__c entryTmp:listEntryIdActivation) {
              listIdActivationToRetrieve.add(entryTmp.ESN_MB_Activation__c);
            }
        }

        activationList = [Select ESN_MB_Entry__c.Id, ESN_MB_Activation__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Target__c, ESN_MB_Activation__r.ESN_MB_MarketType__c,
                          ESN_MB_Activation__r.ESN_MB_Budget__c,ESN_MB_Activation__r.ESN_MB_Legal_Constraints__c, ESN_MB_Activation__r.ESN_MB_Market__c,ESN_MB_Activation__r.ESN_MB_PROS__c,
                          ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Maturity_Stage__c, ESN_MB_Activation__r.ESN_MB_Results__c, ESN_MB_Activation__r.ESN_MB_TotalLike__c, ESN_MB_Asset__r.ESN_MB_DocumentId__c,
                          ESN_MB_Activation__r.ESN_MB_How__c, ESN_MB_Activation__r.ESN_MB_ToWhom__c, ESN_MB_Activation__r.ESN_MB_What__c, ESN_MB_Activation__r.ESN_MB_Why__c,
						  ESN_MB_Activation__r.OwnerId, ESN_MB_Activation__r.ESN_MB_BigIdea__c, ESN_MB_Activation__r.ESN_MB_StrategicFit__c, ESN_MB_Activation__r.ESN_MB_ExcellenceOfExecution__c, ESN_MB_Activation__r.ESN_MB_BusinessImpact__c, ESN_MB_Activation__r.ESN_MB_ScalabilityAndReplicability__c,
                          ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Activation__r.CreatedDate, ESN_MB_Activation__r.ESN_MB_Product__c, ESN_MB_Activation__r.ESN_MB_Activation_Type__c,
                          ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Activation__r.ESN_MB_Stage__c,ESN_MB_Activation__r.ESN_MB_StartingDate__c,ESN_MB_Activation__r.ESN_MB_EndingDate__c, ESN_MB_Activation__r.ESN_MB_AlsoInMasterbrand__c
                          FROM ESN_MB_Entry__c 
                          WHERE ESN_MB_Activation__c in :listIdActivationToRetrieve
                          AND ESN_MB_RoleAsset__c = 'MainAsset' 
                          AND recordType.DeveloperName = 'ESN_MB_Activations_to_Assets'
                          ORDER BY ESN_MB_Activation__r.CreatedDate DESC];
        return activationList;
    }
    
    /**
    * Method retrieveToolkitUserNb(activationIdsList)
    * @param currentProductId: String param containing the product selected by the user
    * @param currentRubricName: String param containing the rubric selected by the user
    * @return activationList: returns a list of activations
    */
    @RemoteAction
    global static List<ESN_MB_NOP_ToolkitUsed_DTO> retrieveToolkitUsedNb(List<String> activationIdsList) {
        List<AggregateResult> toolkitAggregateList = [Select ESN_MB_Parent_Activation__c, count(id)toolkitUsedNb
                                                      From ESN_MB_Activation__c 
                                                      Where ESN_MB_Parent_Activation__c IN :activationIdsList
                                                      AND ESN_MB_Stage__c = 'Published'
                                                      Group by ESN_MB_Parent_Activation__c];
        List<ESN_MB_NOP_ToolkitUsed_DTO> toolkitUsedList = new List<ESN_MB_NOP_ToolkitUsed_DTO>();
        for(AggregateResult ar : toolkitAggregateList) {
            ESN_MB_NOP_ToolkitUsed_DTO toolkitUsed = new ESN_MB_NOP_ToolkitUsed_DTO();
            toolkitUsed.toolkitId = String.valueOf(ar.get('ESN_MB_Parent_Activation__c'));
            toolkitUsed.toolkitUsedNb = Integer.valueOf(ar.get('toolkitUsedNb'));
            toolkitUsedList.add(toolkitUsed);
        }
        return toolkitUsedList;
    }
    
    
    
    /**
    * Method retrieveActivation(currentProductId, currentRubricName)
    * @param currentProductId: String param containing the product selected by the user
    * @param currentRubricName: String param containing the rubric selected by the user
    * @return activationList: returns a list of activations
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveBrandActivationById(String activationId) {
        List<ESN_MB_Entry__c> activationList = [Select ESN_MB_Activation__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Target__c,
                                                ESN_MB_Activation__r.ESN_MB_Budget__c,ESN_MB_Activation__r.ESN_MB_Legal_Constraints__c, ESN_MB_Activation__r.ESN_MB_Market__c,
                                                ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Maturity_Stage__c, ESN_MB_Activation__r.ESN_MB_Results__c,ESN_MB_Activation__r.ESN_MB_PROS__c,
                                                ESN_MB_Activation__r.ESN_MB_How__c, ESN_MB_Activation__r.ESN_MB_ToWhom__c, ESN_MB_Activation__r.ESN_MB_What__c, ESN_MB_Activation__r.ESN_MB_Why__c,
												ESN_MB_Activation__r.ESN_MB_BigIdea__c, ESN_MB_Activation__r.ESN_MB_StrategicFit__c, ESN_MB_Activation__r.ESN_MB_ExcellenceOfExecution__c, ESN_MB_Activation__r.ESN_MB_BusinessImpact__c, ESN_MB_Activation__r.ESN_MB_ScalabilityAndReplicability__c,
                                                ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c, ESN_MB_Activation__r.CreatedDate, ESN_MB_Activation__r.ESN_MB_AlsoInMasterbrand__c
                                                FROM ESN_MB_Entry__c 
                                                WHERE ESN_MB_Activation__c = :activationId
                                                ORDER BY ESN_MB_Activation__r.CreatedDate DESC];  
        
        return activationList;
    }
    
    /**
    * Method retrieveMarketActivation()
    * @return activationList: returns a list of all the market activations
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveListMarketActivation(String currentBrandId) {    
        String brandId = '';
        List<ESN_MB_NodePage__c> brandInfo = [SELECT Id, Name, ESN_MB_Brand_Category__c, ESN_MB_BrandParentId__c FROM ESN_MB_NodePage__c WHERE RecordType.DeveloperName = 'ESN_MB_Brand' AND Id=:currentBrandId LIMIT 1];
        for(ESN_MB_NodePage__c brand : brandInfo) {
            if(brand.ESN_MB_Brand_Category__c == Label.ESN_MB_LeCercle && brand.Name != Label.ESN_MB_LeCercle && brand.ESN_MB_BrandParentId__c != null) {
                brandId = brand.ESN_MB_BrandParentId__c;
            } else {
                brandId = currentBrandId;
            } 
        }
        
        if(brandId.length() > 15) {
            brandId = brandId.SubString(0,15);
        }
        //Get the "Market Activation" recordType id
        String marketActivationId = getRecordTypeId('ESN_MB_Market_Activation');
        List<ESN_MB_Entry__c> marketActivationList = new List<ESN_MB_Entry__c>();
        
        if (isBroadCasterAssigned(brandId)) {
        //if(ESN_MB_UtilsUser.isBroadcasterUser() || ESN_MB_UtilsUser.isBrandManagerUser()) {
            //Get the Market Activation List
            marketActivationList = [Select ESN_MB_Entry__c.Id, ESN_MB_Activation__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Target__c, ESN_MB_Activation__r.ESN_MB_MarketType__c,
                                    ESN_MB_Activation__r.ESN_MB_Budget__c,ESN_MB_Activation__r.ESN_MB_Legal_Constraints__c, ESN_MB_Activation__r.ESN_MB_Market__c,
                                    ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Maturity_Stage__c, ESN_MB_Activation__r.ESN_MB_Results__c,ESN_MB_Activation__r.ESN_MB_PROS__c,
                                    ESN_MB_Activation__r.ESN_MB_How__c, ESN_MB_Activation__r.ESN_MB_ToWhom__c, ESN_MB_Activation__r.ESN_MB_What__c, ESN_MB_Activation__r.ESN_MB_Why__c,
									ESN_MB_Activation__r.ESN_MB_BigIdea__c, ESN_MB_Activation__r.ESN_MB_StrategicFit__c, ESN_MB_Activation__r.ESN_MB_ExcellenceOfExecution__c, ESN_MB_Activation__r.ESN_MB_BusinessImpact__c, ESN_MB_Activation__r.ESN_MB_ScalabilityAndReplicability__c,
                                    ESN_MB_Activation__r.ESN_MB_RatingAvg__c, ESN_MB_Activation__r.ESN_MB_TotalLike__c, ESN_MB_Activation__r.ESN_MB_AvgCrit1__c, 
                                    ESN_MB_Activation__r.ESN_MB_AvgCrit2__c, ESN_MB_Activation__r.ESN_MB_AvgCrit3__c, ESN_MB_Activation__r.ESN_MB_AvgCrit4__c, ESN_MB_Activation__r.ESN_MB_AvgCrit5__c,
                                    ESN_MB_Activation__r.OwnerId, ESN_MB_Activation__r.ESN_MB_CountCrit1__c, ESN_MB_Activation__r.ESN_MB_CountCrit2__c, 
                                    ESN_MB_Activation__r.ESN_MB_CountCrit3__c, ESN_MB_Activation__r.ESN_MB_CountCrit4__c, ESN_MB_Activation__r.ESN_MB_CountCrit5__c,
                                    ESN_MB_Asset__r.ESN_MB_DocumentId__c, ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Activation__r.CreatedDate, ESN_MB_Activation__r.ESN_MB_Product__c, ESN_MB_Activation__r.ESN_MB_Activation_Type__c,
                                    ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Activation__r.ESN_MB_Stage__c,ESN_MB_Activation__r.ESN_MB_StartingDate__c,ESN_MB_Activation__r.ESN_MB_EndingDate__c, ESN_MB_Activation__r.ESN_MB_AlsoInMasterbrand__c, ESN_MB_Activation__r.ESN_MB_LeCercle__c
                                    FROM ESN_MB_Entry__c 
                                    WHERE ESN_MB_RoleAsset__c = 'MainAsset' 
                                    AND recordType.DeveloperName = 'ESN_MB_Activations_to_Assets' 
                                    AND ESN_MB_Activation__r.recordTypeId = :marketActivationId
                                    //AND ESN_MB_Activation__r.ESN_MB_Stage__c = 'Published' 
                                    AND ESN_MB_Activation__r.ESN_MB_BrandId__c = :brandId
                                    ORDER BY ESN_MB_Activation__r.CreatedDate DESC];
        }else {
            //Get the Market Activation List with only published activations for basic user
            marketActivationList = [Select ESN_MB_Entry__c.Id, ESN_MB_Activation__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Target__c, ESN_MB_Activation__r.ESN_MB_MarketType__c,
                                    ESN_MB_Activation__r.ESN_MB_Budget__c,ESN_MB_Activation__r.ESN_MB_Legal_Constraints__c, ESN_MB_Activation__r.ESN_MB_Market__c,
                                    ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Maturity_Stage__c, ESN_MB_Activation__r.ESN_MB_Results__c,ESN_MB_Activation__r.ESN_MB_PROS__c,
                                    ESN_MB_Activation__r.ESN_MB_How__c, ESN_MB_Activation__r.ESN_MB_ToWhom__c, ESN_MB_Activation__r.ESN_MB_What__c, ESN_MB_Activation__r.ESN_MB_Why__c,
									ESN_MB_Activation__r.ESN_MB_BigIdea__c, ESN_MB_Activation__r.ESN_MB_StrategicFit__c, ESN_MB_Activation__r.ESN_MB_ExcellenceOfExecution__c, ESN_MB_Activation__r.ESN_MB_BusinessImpact__c, ESN_MB_Activation__r.ESN_MB_ScalabilityAndReplicability__c,
                                    ESN_MB_Activation__r.ESN_MB_RatingAvg__c, ESN_MB_Activation__r.ESN_MB_TotalLike__c, ESN_MB_Activation__r.ESN_MB_AvgCrit1__c, 
                                    ESN_MB_Activation__r.ESN_MB_AvgCrit2__c, ESN_MB_Activation__r.ESN_MB_AvgCrit3__c, ESN_MB_Activation__r.ESN_MB_AvgCrit4__c, ESN_MB_Activation__r.ESN_MB_AvgCrit5__c,
                                    ESN_MB_Activation__r.OwnerId, ESN_MB_Activation__r.ESN_MB_CountCrit1__c, ESN_MB_Activation__r.ESN_MB_CountCrit2__c, 
                                    ESN_MB_Activation__r.ESN_MB_CountCrit3__c, ESN_MB_Activation__r.ESN_MB_CountCrit4__c, ESN_MB_Activation__r.ESN_MB_CountCrit5__c,
                                    ESN_MB_Asset__r.ESN_MB_DocumentId__c, ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Activation__r.CreatedDate, ESN_MB_Activation__r.ESN_MB_Product__c, ESN_MB_Activation__r.ESN_MB_Activation_Type__c,
                                    ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Activation__r.ESN_MB_Stage__c,ESN_MB_Activation__r.ESN_MB_StartingDate__c,ESN_MB_Activation__r.ESN_MB_EndingDate__c, ESN_MB_Activation__r.ESN_MB_AlsoInMasterbrand__c, ESN_MB_Activation__r.ESN_MB_LeCercle__c
                                    FROM ESN_MB_Entry__c 
                                    WHERE ESN_MB_RoleAsset__c = 'MainAsset' 
                                    AND recordType.DeveloperName = 'ESN_MB_Activations_to_Assets' 
                                    AND ESN_MB_Activation__r.recordTypeId = :marketActivationId
                                    //AND ESN_MB_Activation__r.ESN_MB_Stage__c = 'Published' 
                                    AND ESN_MB_Activation__r.ESN_MB_BrandId__c = :brandId
                                    ORDER BY ESN_MB_Activation__r.CreatedDate DESC];
        }
       
        system.debug('Market activation list : ' + marketActivationList);
        
        return marketActivationList;
    }
    
    
     /**
    * Method retrieveMarketActivationById()
    * @return activationList: returns a list of all the market activations
    */
    @RemoteAction
    global static ESN_MB_Entry__c retrieveMarketActivationById(String currentBrandId, String activationId) {
        //Get the brand Id from url param
        String brandId = currentBrandId;
        if(brandId.length() > 15) {
            brandId = brandId.SubString(0,15);
        }
        //Get the "Market Activation" recordType id
        String marketActivationId = getRecordTypeId('ESN_MB_Market_Activation');
        List<ESN_MB_Entry__c> marketActivationList = new List<ESN_MB_Entry__c>();
        //Get the Market Activation List
        marketActivationList = [Select ESN_MB_Entry__c.Id, ESN_MB_Activation__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Target__c, ESN_MB_Activation__r.ESN_MB_MarketType__c,ESN_MB_Activation__r.ESN_MB_Embedded_Video__c,
                                ESN_MB_Activation__r.ESN_MB_Budget__c,ESN_MB_Activation__r.ESN_MB_Legal_Constraints__c, ESN_MB_Activation__r.ESN_MB_Market__c,
                                ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Maturity_Stage__c, ESN_MB_Activation__r.ESN_MB_Results__c,ESN_MB_Activation__r.ESN_MB_PROS__c,
                                ESN_MB_Activation__r.ESN_MB_How__c, ESN_MB_Activation__r.ESN_MB_ToWhom__c, ESN_MB_Activation__r.ESN_MB_What__c, ESN_MB_Activation__r.ESN_MB_Why__c,
								ESN_MB_Activation__r.ESN_MB_BigIdea__c, ESN_MB_Activation__r.ESN_MB_StrategicFit__c, ESN_MB_Activation__r.ESN_MB_ExcellenceOfExecution__c, ESN_MB_Activation__r.ESN_MB_BusinessImpact__c, ESN_MB_Activation__r.ESN_MB_ScalabilityAndReplicability__c,
                                ESN_MB_Activation__r.ESN_MB_RatingAvg__c, ESN_MB_Activation__r.ESN_MB_TotalLike__c, ESN_MB_Activation__r.ESN_MB_AvgCrit1__c, 
                                ESN_MB_Activation__r.ESN_MB_AvgCrit2__c, ESN_MB_Activation__r.ESN_MB_AvgCrit3__c, ESN_MB_Activation__r.ESN_MB_AvgCrit4__c, ESN_MB_Activation__r.ESN_MB_AvgCrit5__c,
                                ESN_MB_Activation__r.ESN_MB_CountCrit1__c, ESN_MB_Activation__r.ESN_MB_CountCrit2__c, 
                                ESN_MB_Activation__r.ESN_MB_CountCrit3__c, ESN_MB_Activation__r.ESN_MB_CountCrit4__c, ESN_MB_Activation__r.ESN_MB_CountCrit5__c,ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c,
                                ESN_MB_Asset__r.ESN_MB_DocumentId__c, ESN_MB_Activation__r.CreatedDate,ESN_MB_Activation__r.OwnerId, ESN_MB_Activation__r.CreatedById, ESN_MB_Activation__r.ESN_MB_Product__c, ESN_MB_Activation__r.ESN_MB_Activation_Type__c,
                                ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Activation__r.ESN_MB_Stage__c,ESN_MB_Activation__r.ESN_MB_StartingDate__c,ESN_MB_Activation__r.ESN_MB_EndingDate__c, ESN_MB_Activation__r.ESN_MB_AlsoInMasterbrand__c, ESN_MB_Activation__r.ESN_MB_LeCercle__c
                                FROM ESN_MB_Entry__c 
                                WHERE ESN_MB_Activation__c = :activationId
                                AND ESN_MB_RoleAsset__c = 'MainAsset' 
                                ORDER BY ESN_MB_Activation__r.CreatedDate DESC];
        return (marketActivationList.size()>0)?marketActivationList[0]:null;
    }
    
    /**
    * Method retrieveBAById(String currentBrandId, String activationId)
    * @return activationList: returns a list of all the market activations
    */
    @RemoteAction
    global static ESN_MB_Entry__c retrieveBAById(String currentBrandId, String activationId) {
        //Get the brand Id from url param
        String brandId = currentBrandId;
        if(brandId.length() > 15) {
            brandId = brandId.SubString(0,15);
        }
        //Get the "Market Activation" recordType id
        String marketActivationId = getRecordTypeId('ESN_MB_Brand_Activation');
        List<ESN_MB_Entry__c> marketActivationList = new List<ESN_MB_Entry__c>();
        //Get the Market Activation List
        marketActivationList = [Select ESN_MB_Entry__c.Id, ESN_MB_Activation__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.ESN_MB_Target__c, ESN_MB_Activation__r.ESN_MB_MarketType__c, ESN_MB_Activation__r.ESN_MB_Embedded_Video__c,
                                ESN_MB_Activation__r.ESN_MB_Budget__c,ESN_MB_Activation__r.ESN_MB_Legal_Constraints__c, ESN_MB_Activation__r.ESN_MB_Market__c,
                                ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Maturity_Stage__c, ESN_MB_Activation__r.ESN_MB_Results__c,ESN_MB_Activation__r.ESN_MB_PROS__c,
                                ESN_MB_Activation__r.ESN_MB_How__c, ESN_MB_Activation__r.ESN_MB_ToWhom__c, ESN_MB_Activation__r.ESN_MB_What__c, ESN_MB_Activation__r.ESN_MB_Why__c,
								ESN_MB_Activation__r.ESN_MB_BigIdea__c, ESN_MB_Activation__r.ESN_MB_StrategicFit__c, ESN_MB_Activation__r.ESN_MB_ExcellenceOfExecution__c, ESN_MB_Activation__r.ESN_MB_BusinessImpact__c, ESN_MB_Activation__r.ESN_MB_ScalabilityAndReplicability__c,
                                ESN_MB_Activation__r.ESN_MB_RatingAvg__c, ESN_MB_Activation__r.ESN_MB_TotalLike__c, ESN_MB_Activation__r.ESN_MB_AvgCrit1__c, 
                                ESN_MB_Activation__r.ESN_MB_AvgCrit2__c, ESN_MB_Activation__r.ESN_MB_AvgCrit3__c, ESN_MB_Activation__r.ESN_MB_AvgCrit4__c, ESN_MB_Activation__r.ESN_MB_AvgCrit5__c,
                                ESN_MB_Activation__r.ESN_MB_CountCrit1__c, ESN_MB_Activation__r.ESN_MB_CountCrit2__c,ESN_MB_Asset__c,
                                ESN_MB_Activation__r.ESN_MB_CountCrit3__c, ESN_MB_Activation__r.ESN_MB_CountCrit4__c, ESN_MB_Activation__r.ESN_MB_CountCrit5__c,ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c,
                                ESN_MB_Asset__r.ESN_MB_DocumentId__c, ESN_MB_Activation__r.CreatedDate,ESN_MB_Activation__r.OwnerId,ESN_MB_Activation__r.CreatedById, ESN_MB_Activation__r.ESN_MB_Product__c, ESN_MB_Activation__r.ESN_MB_Activation_Type__c,
                                ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Activation__r.ESN_MB_Stage__c,ESN_MB_Activation__r.ESN_MB_StartingDate__c,ESN_MB_Activation__r.ESN_MB_EndingDate__c, ESN_MB_Activation__r.ESN_MB_AlsoInMasterbrand__c
                                FROM ESN_MB_Entry__c 
                                WHERE ESN_MB_Activation__c = :activationId
                                AND ESN_MB_RoleAsset__c = 'MainAsset' 
                                ORDER BY ESN_MB_Activation__r.CreatedDate DESC];
        return (marketActivationList.size()>0)?marketActivationList[0]:null;
    }
        
   /** method retrieveActivationOwner(userId)
    * @param activationId: id of the user to get the infos from
    * @return activationOwner: returns the user that own the activation
    */
    @RemoteAction
    global static User retrieveActivationOwner(String userId) {
        User activationOwner = [Select Name, Title, Email, SmallPhotoUrl
                                  From User
                                  Where id = :userId];
        return activationOwner;
    }

     /*
     * Returns the Products this activation is attached to. Format = Product1, Product2
     */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveProductsByActivationId(String activationId){
        List<ESN_MB_Entry__c> listProduct = [Select ESN_MB_Node_Page__c
                                  From ESN_MB_Entry__c
                                  Where RecordType.DeveloperName='Activations_To_Products'
                                  And ESN_MB_Activation__c=:activationId];

        return listProduct;
    }

     /*
     * Returns the userInteraction between the current user and the activation passed in parameter
     * If no userInteraction exists between them, then an empty interaction is returned
     */
    @RemoteAction
    global static ESN_MB_User_Interaction__c retrieveUserInteraction(String activationId){
        ESN_MB_User_Interaction__c result = null;
        String userId=UserInfo.getUserId();
        System.debug('retrieveUserInteraction ' + userId + '-' + activationId);
        List<ESN_MB_User_Interaction__c> listInteractions = [Select ESN_MB_Activation__c, ESN_MB_Average_Rating__c, ESN_MB_Follow__c, ESN_MB_KeyContact__c, ESN_MB_Like__c, ESN_MB_Rating_Criteria_1__c, ESN_MB_Rating_Criteria_2__c, ESN_MB_Rating_Criteria_3__c, ESN_MB_Rating_Criteria_4__c, ESN_MB_Rating_Criteria_5__c, ESN_MB_User__c
                                                                From ESN_MB_User_Interaction__c
                                                                Where ESN_MB_User__c = :userId
                                                                And ESN_MB_Activation__c = :activationId
                                                                Limit 1];
        System.debug('Result ' + listInteractions);
        //If no userInteraction exists between them, then an empty interaction is returned
        if(listInteractions.size()>0){
            result = listInteractions[0];
        } else {
            result = new ESN_MB_User_Interaction__c();
        }
        return result;
    }
    
    /**
    * Method createActivationDraft(String activationType)
    * @param activationType: String param containing the activation Type developer name (ESN_MB_Brand_Activation or ESN_MB_Market_Activation)
    * @return activation.Id: returns the activation id to match on entry with an asset and to update on save.
    * This method creates an activation draft
    */
    @RemoteAction
    global static String createActivationDraft(String activationType) {
        ESN_MB_Activation__c activation = new ESN_MB_Activation__c();
        activation.RecordTypeId = getRecordTypeId(activationType);
        activation.ESN_MB_Stage__c = 'Draft';
        activation.CurrencyIsoCode = UserInfo.getDefaultCurrency();    
        insert(activation);    
        return activation.Id;
    }
    
    
    /**
    * Method updateActivation(activationId)
    * @param activationId: id of the activation to update
    * @param activationName: name of the activation, user input
    * @param activationAudience: audience of the activation, user input
    * @param activationBudget: budget of the activation, user input
    * @param activationLegalConstraints: legal constraints of the activation, user input
    * @param activationMarket: market of the activation, user input
    * @param activationBusinessPriority: business priority stage of the activation, user input
	* @param activationAffiliate: affiliate of the activation, user input
	* @param activationMaturityStage: maturity stage of the activation, user input
    * @param activationPros: pros of the activation, user input
    * @param activationResults: results of the activation, user input
    * @param activationHow: how of the activation, user input
    * @param activationToWhom: to whom of the activation, user input
    * @param activationWhat: what of the activation, user input
    * @param activationWhy: why of the activation, user input
	* @param activationBigIdea: bigIdea of the activation, user input
	* @param activationStrategicFit: strategicFit of the activation, user input
	* @param activationExcellenceOfExecution: excellenceOfExecution of the activation, user input
	* @param activationBusinessImpact: businessImpact of the activation, user input
	* @param activationScalabilityAndReplicability: scalabilityAndReplicability of the activation, user input
    * This method updates an activation (draft or published)
    */
    @RemoteAction
    global static void updateActivation(String activationId, String activationName, String activationAudience, String activationBudget,
                                          String activationLegalConstraints, String activationMarket, String activationBusinessPriority, String activationAffiliate, String activationMaturityStage, String activationPros,
                                          String activationResults, String activationHow, String activationToWhom, String activationWhat, String activationWhy, Map<String,String> activationDatas,
										  String activationProduct, String activationActivationType, Boolean previewMA, String activationStartingDate, String activationEndingDate, Boolean activationAlsoInMasterbrand, Boolean deleteActivation, 
                                          String idMainAsset,String idMainAssetOld, Boolean assetFromDAM, Boolean doDelete, String activationEmbeddedVideo, Boolean activationIsLeCercle) {
        
		String activationBigIdea = '';
		String activationStrategicFit = '';
		String activationExcellenceOfExecution = '';
		String activationBusinessImpact = '';
		String activationScalabilityAndReplicability = '';

		for(String key : activationDatas.keySet()) { 
			if (key == 'activationBigIdea') {
				activationBigIdea = activationDatas.get(key);
			} else if(key == 'activationStrategicFit') {
				activationStrategicFit = activationDatas.get(key);
			} else if(key == 'activationExcellenceOfExecution') {
				activationExcellenceOfExecution = activationDatas.get(key);
			} else if(key == 'activationBusinessImpact') {
				activationBusinessImpact = activationDatas.get(key);
			} else if(key == 'activationScalabilityAndReplicability') {
				activationScalabilityAndReplicability = activationDatas.get(key);
			}
		}
		System.debug('MDL:' + activationBusinessPriority);

		
		if(idMainAssetOld == '000'){
            // Create entry
            ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
            entry.ESN_MB_Activation__c = activationId;
            entry.ESN_MB_Asset__c = idMainAsset;
            entry.ESN_MB_RoleAsset__c = 'MainAsset';
            entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
            insert entry;     
             
        }else if((assetFromDAM == true) && (doDelete== true)){  
            // Create entry
            ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
            entry.ESN_MB_Activation__c = activationId;
            entry.ESN_MB_Asset__c = idMainAsset;
            entry.ESN_MB_RoleAsset__c = 'MainAsset';
            entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
            insert entry;
            
            //Delete ancienne entry
            ESN_MB_Entry__c entryAssetActivation = [Select Id From ESN_MB_Entry__c Where ESN_MB_Activation__c = :activationId And ESN_MB_Asset__c = :idMainAssetOld And ESN_MB_RoleAsset__c = 'MainAsset' limit 1];
            delete entryAssetActivation;
            
        }else if((assetFromDAM != true) && (doDelete== true)){
            
            //Si interne
            ESN_MB_Entry__c existingEntry = [SELECT Id From ESN_MB_Entry__c WHERE ESN_MB_Activation__c = :activationId And ESN_MB_RoleAsset__c = 'MainAsset' limit 1];
            delete existingEntry;
            
            // Create entry
            ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
            entry.ESN_MB_Activation__c = activationId;
            entry.ESN_MB_Asset__c = idMainAsset;
            entry.ESN_MB_RoleAsset__c = 'MainAsset';
            entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
            insert entry;    
        }
        List<String> listActivationProduct = activationProduct.split(';', 0);
        //We delete and re-insert the entries linking this activation and the products.
        List<ESN_MB_Entry__c> listEntryProductToDelete = [SELECT Id From ESN_MB_Entry__c
                  WHERE ESN_MB_Activation__c = :activationId
                  And RecordType.DeveloperName = 'Activations_To_Products'];
        delete(listEntryProductToDelete);
        List<ESN_MB_Entry__c> listEntryProductToInsert = new List<ESN_MB_Entry__c>();
        //Let's retrieve the correct Record Type Id for the entries 'Articles To Products'
        List <RecordType> listRT = [Select Id From RecordType Where DeveloperName='Activations_To_Products'];
        String rtAtP = null;
        if(listRT.size()>0){
            rtAtP = listRT[0].Id;
        }
        for(String idProductTmp:listActivationProduct){
          ESN_MB_Entry__c entryProductTmp = new ESN_MB_Entry__c();
          entryProductTmp.recordTypeId = rtAtP;
          entryProductTmp.ESN_MB_Activation__c = activationId;
          entryProductTmp.ESN_MB_Node_Page__c = idProductTmp;
          listEntryProductToInsert.add(entryProductTmp);
        }
        insert(listEntryProductToInsert);
                                              
        ESN_MB_Activation__c activation = [SELECT Id, Name, ESN_MB_Budget__c, ESN_MB_Legal_Constraints__c, ESN_MB_Market__c, ESN_MB_Stage__c, RecordTypeId, 
                                           ESN_MB_BusinessPriority__c, ESN_MB_Affiliate__c, ESN_MB_Region__c, ESN_MB_Maturity_Stage__c, ESN_MB_Results__c, ESN_MB_How__c, ESN_MB_ToWhom__c, ESN_MB_What__c, ESN_MB_Why__c, ESN_MB_Product__c,
										   ESN_MB_BigIdea__c, ESN_MB_StrategicFit__c, ESN_MB_ExcellenceOfExecution__c, ESN_MB_BusinessImpact__c, ESN_MB_ScalabilityAndReplicability__c,
                                           ESN_MB_Activation_Type__c, ESN_MB_StartingDate__c, ESN_MB_EndingDate__c, ESN_MB_MainActivationId__c, ESN_MB_PROS__c, ESN_MB_AlsoInMasterbrand__c, ESN_MB_LeCercle__c
                                           FROM ESN_MB_Activation__c
                                           WHERE Id = :activationId
                                           limit 1];
        Boolean wasAlreadyPublished = (activation.ESN_MB_Stage__c == 'Published');
        Date sd = Date.valueOf(activationStartingDate);   
        Date ed = Date.valueOf(activationEndingDate); 
        activation.Name = activationName;
        if(previewMA == false){activation.ESN_MB_Stage__c = 'Published';}
        activation.ESN_MB_Target__c = activationAudience;
        activation.ESN_MB_Budget__c = activationBudget;
        activation.ESN_MB_Legal_Constraints__c = activationLegalConstraints;
        activation.ESN_MB_Market__c = activationMarket; 
        activation.ESN_MB_BusinessPriority__c = activationBusinessPriority;
		activation.ESN_MB_Affiliate__c = activationAffiliate;
		for (ESN_MB_MappingAffiliateRegion__c CS : ESN_MB_MappingAffiliateRegion__c.getAll().values()) {
			if(CS.Affiliate__c == activationAffiliate) {
				activation.ESN_MB_Region__c = CS.Region__c;
			}
		}
		activation.ESN_MB_Maturity_Stage__c = activationMaturityStage;
        activation.ESN_MB_PROS__c = activationPros;
        activation.ESN_MB_Results__c = activationResults;
        activation.ESN_MB_How__c = activationHow;
        activation.ESN_MB_ToWhom__c = activationToWhom;
        activation.ESN_MB_What__c = activationWhat;
        activation.ESN_MB_Why__c = activationWhy;
		
		activation.ESN_MB_BigIdea__c = activationBigIdea;
		activation.ESN_MB_StrategicFit__c = activationStrategicFit;
		activation.ESN_MB_ExcellenceOfExecution__c = activationExcellenceOfExecution;
		activation.ESN_MB_BusinessImpact__c = activationBusinessImpact;
		activation.ESN_MB_ScalabilityAndReplicability__c = activationScalabilityAndReplicability;

        activation.ESN_MB_Product__c = listActivationProduct[0];
        activation.ESN_MB_Activation_Type__c = activationActivationType;
        activation.ESN_MB_StartingDate__c = sd;
        activation.ESN_MB_EndingDate__c = ed;
        activation.ESN_MB_AlsoInMasterbrand__c = activationAlsoInMasterbrand;
        activation.ESN_MB_Embedded_Video__c = activationEmbeddedVideo;
        activation.ESN_MB_LeCercle__c = activationIsLeCercle;
        update(activation);

        //We publish a message in chatter only for MA that are being published, that were not published before, and that don't have a "parent" activation (which means they are a copy)
        List<ESN_MB_Activation__c> listActTmp = [SELECT Id, ESN_MB_Stage__c From ESN_MB_Activation__c WHERE Id = :activation.ESN_MB_MainActivationId__c];
        if(activation.recordTypeId == getRecordTypeId('ESN_MB_Market_Activation')
           && !previewMA
           && !wasAlreadyPublished
           && (listActTmp.size() == 0 || listActTmp[0].ESN_MB_Stage__c != 'Published') ){
               
               //Retrieve the Brand Id
               String brandId = [Select ESN_MB_ParentId__c From ESN_MB_NodePage__c Where id = :activationProduct].ESN_MB_ParentId__c;
               String chatterFeedId = null;
               String productName = null;
               List <ESN_MB_NodePage__c> listNodePageTmp = [SELECT Name, ESN_MB_ParentId__r.ESN_MB_ChatterGroup_Id__c From ESN_MB_NodePage__c Where Id=:activation.ESN_MB_Product__c];
               if(listNodePageTmp.size()>0){
                   chatterFeedId = listNodePageTmp[0].ESN_MB_ParentId__r.ESN_MB_ChatterGroup_Id__c;
                   productName = listNodePageTmp[0].Name;
               }
               String groupOwnerId = null;
               List<Collaborationgroup> listGroupTmp = [Select ownerid from Collaborationgroup where id=:chatterFeedId Limit 1];
               if(listGroupTmp.size()>0){
                   groupOwnerId = listGroupTmp[0].ownerid;
               }
               
               String[] tabTextSegment = Label.ESN_MB_TextChatterMsg.split('\\;');
               
               ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
               messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
               
               ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
               textSegment.text = tabTextSegment[0] + activationName + tabTextSegment[1] + productName + tabTextSegment[2] + 'Mature' + tabTextSegment[3];
               messageInput.messageSegments.add(textSegment);
               
               ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
               mentionSegment.id = groupOwnerId; // The ID of the user to mention.
               messageInput.messageSegments.add(mentionSegment);
               
               ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
               input.body = messageInput;
               
               ConnectApi.LinkAttachmentInput linkIn = new ConnectApi.LinkAttachmentInput();
               String host = URL.getSalesforceBaseUrl().getHost();
               system.debug('HOST : ' + host);
               linkIn.urlName = activationName;
               linkIn.url = 'https://' + host + '/apex/ESN_MB_NOP_Brand?brandId=' + brandId + '#?page=article-local-activation&content=' + activationId + '&mode=light';
               system.debug('url : ' + linkIn.url);
               input.attachment = linkIn;
               system.debug('input: ' + input);
               
               ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, chatterFeedId, input, null);
               
               /*System.debug('New activation created');
                FeedItem post = new FeedItem();
                post.ParentId = '0F9c00000008nq6';
                post.Title = 'activationName';
                String postBody = 'Check out my new activation <NAME> of <PRODUCT> for <MARKET> ! @[sebastien chateau]';
                postBody = postBody.replace('<NAME>', activationName)
                .replace('<PRODUCT>', activationProduct)
                .replace('<MARKET>', activationMarket);
                post.Body = messageInput;
                post.LinkUrl = 'http://www.accenture.com';
                insert post;*/
        }
        
        //String mainID = activation.ESN_MB_MainActivationId__c;                                      
        if((previewMA == false) && (deleteActivation == true)){
            ESN_MB_Activation__c existingActivation = [SELECT Id From ESN_MB_Activation__c WHERE Id = :activation.ESN_MB_MainActivationId__c];
            
            
            delete existingActivation;
            
        }
       
    } 
    @RemoteAction
    global static void updateActivationOnlyMainAsset(String activationId, String idMainAsset,String idMainAssetOld, Boolean assetFromDAM){
        
        if(idMainAssetOld == '000'){
            // Create entry
            ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
            entry.ESN_MB_Activation__c = activationId;
            entry.ESN_MB_Asset__c = idMainAsset;
            entry.ESN_MB_RoleAsset__c = 'MainAsset';
            entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
            insert entry;     
             
        } 
        
    }
    
    @RemoteAction
    global static void updateActivationToStagePublish(String activationId) {
                                              
        ESN_MB_Activation__c activation = [SELECT Id, ESN_MB_MainActivationId__c,ESN_MB_Stage__c FROM ESN_MB_Activation__c
                                           WHERE Id = :activationId];
        
        activation.ESN_MB_Stage__c = 'Published';
        update(activation);   
        
        ESN_MB_Activation__c existingActivation = [SELECT Id From ESN_MB_Activation__c WHERE Id = :activation.ESN_MB_MainActivationId__c];
        delete existingActivation;
    } 
    
    
    @RemoteAction
    global static void updateActivationToStageArchived(String activationId) {
                                              
        ESN_MB_Activation__c activation = [SELECT Id FROM ESN_MB_Activation__c
                                           WHERE Id = :activationId 
                                           limit 1];
        
        activation.ESN_MB_Stage__c = 'Archived';
        update(activation);    
    }
    
   /**
    * Method createEntryActivationAsset(String activationId, String assetId)
    * @param activationId: param of type String, content Id to match on the entry
    * @param assetId: param of type String, asset Id to match on the entry
    * @return entry.Id: returns the id of the new entry
    * This method adds an entry depending on the content Id and the asset Id
    */
    @RemoteAction
    global static String createEntryActivationAsset(String activationId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.recordTypeId = getRecordTypeId('ESN_MB_Activations_To_Assets');
        entry.ESN_MB_Activation__c = activationId;
        entry.ESN_MB_Asset__c = assetId;
        entry.ESN_MB_RoleAsset__c = roleAsset;
        insert(entry);
        return entry.Id;
    }
    
    /**
    * Method getRecordTypeId(String recordTypeName)
    * @param recordTypeName: param of type String, recordtype developer Name to get id from
    * @return recordTypeId: returns the record type Id depending on its developerame
    * DeveloperName field is its API name, used to fill the recordTypeId field
    * Dynamically on the creation of a record
    */ 
    @TestVisible private static String getRecordTypeId(String recordTypeName) {
        String recordTypeId = [select id 
                               from recordtype 
                               where DeveloperName = :recordTypeName].id;
        return recordTypeId;
    }
    
    /**
    * Method retrieveActivationAssets(String activationId)
    * @param activationId: param of type String, Id of the activation to get the assets from
    * @return assetsList: returns the informations of assets linked to the activation
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveGlobalActivationAssets(String activationId) {
        List<ESN_MB_Entry__c> assetsList = [Select Id,ESN_MB_Asset__r.Name, ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c ,ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_URL_bamArticleFull__c,
                                             ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Asset__r.ESN_MB_SizeMo__c,ESN_MB_Asset__r.ESN_MB_URL_originalFile__c, ESN_MB_Asset__r.ESN_MB_fileName__c,
                                             ESN_MB_Asset__r.ESN_MB_originalFile_extension__c, ESN_MB_RoleAsset__c, ESN_MB_Asset__r.ESN_MB_Link_URL__c,ESN_MB_Asset__r.ESN_MB_DAMId__c,ESN_MB_Asset__r.ESN_MB_URL_bamVideoPreview__c,
                                             ESN_MB_Asset__r.ESN_MB_Storyboard_LargeURL__c, ESN_MB_Asset__r.ESN_MB_Storyboard_Slide_Count__c, ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_DocumentId__c
                                             FROM ESN_MB_Entry__c 
                                             WHERE recordType.DeveloperName = 'ESN_MB_Activations_to_Assets'
                                             AND ESN_MB_RoleAsset__c != 'MainAsset'
                                             AND ESN_MB_Activation__c = :activationId
                                             ORDER BY CreatedDate DESC];
        return assetsList;
    }
    
    /**
    * Method addAsset(String contentId)
    * @param contentId: param of type String, content Id to match on the entry
    * @return asset.Id: returns the asset id to match on entry with activation
    * This method adds an entry depending on the content Id
    */
    @RemoteAction
    global static String addAsset(String contentId, String description) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.RecordTypeId = getRecordTypeId('ESN_MB_Internal_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
        asset.ESN_MB_DocumentId__c = contentId;
        asset.ESN_MB_description__c = description; 
        insert(asset); 
        return asset.Id;
    }
    
    /**
    * Method addLink(String contentId)
    * @param contentId: param of type String, content Id to match on the entry
    * @return asset.Id: returns the asset id to match on entry with activation
    * This method adds an entry depending on the content Id
    */
    @RemoteAction
    global static String addLink(String linkText, String linkURL) {
        // MDL
        transient String[] linkURL_array = linkURL.split('=', 2);
        for (Integer i=0; i<linkURL_array.size(); i++) {
            if(i==0) {
                linkURL = linkURL_array[i];
            } else {
                linkURL += '=' + EncodingUtil.urlEncode(linkURL_array[i], 'UTF-8'); 
            }
        }

        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.RecordTypeId = getRecordTypeId('ESN_MB_Link_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
        asset.ESN_MB_description__c = linkText;
        asset.ESN_MB_Link_URL__c = linkURL; 
        insert(asset); 
        return asset.Id;
    }
    
    /**
    * Method retrieveActivationAssets(String activationId)
    * @param activationId: param of type String, Id of the activation to get the assets from
    * @return assetsList: returns the informations of assets linked to the activation
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveMarketActivationAssets(String activationId) {
        List<ESN_MB_Entry__c> assetsList = [Select ESN_MB_Asset__c, ESN_MB_Asset__r.ESN_MB_UrlAsset__c,  ESN_MB_Asset__r.ESN_MB_DocumentId__c,
                                             ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_Asset__r.ESN_MB_SizeMo__c,
                                             ESN_MB_Asset__r.ESN_MB_originalFile_extension__c, ESN_MB_RoleAsset__c,ESN_MB_Asset__r.ESN_MB_Link_URL__c, ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_URL_bamArticleFull__c, ESN_MB_Asset__r.ESN_MB_URL_bamVideoPreview__c, ESN_MB_Asset__r.ESN_MB_URL_originalFile__c, ESN_MB_Asset__r.ESN_MB_DAMId__c, ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_Storyboard_LargeURL__c, ESN_MB_Asset__r.ESN_MB_Storyboard_Slide_Count__c
                                             FROM ESN_MB_Entry__c 
                                             WHERE recordType.DeveloperName = 'ESN_MB_Activations_to_Assets'
                                             AND ESN_MB_RoleAsset__c != 'MainAsset'
                                             AND ESN_MB_Activation__c = :activationId
                                             ORDER BY CreatedDate DESC];
        return assetsList;
    }
    
    /**
    * Method addAsset(String contentId)
    * @param contentId: param of type String, content Id to match on the entry
    * @return asset.Id: returns the asset id to match on entry with activation
    * This method adds an entry depending on the content Id
    */
    /*@RemoteAction
    global static String deleteAsset(String contentId) {
        ESN_MB_Asset__c asset = new ESN_MB_Asset__c();
        asset.RecordTypeId = getRecordTypeId('ESN_MB_Internal_Asset');
        asset.CurrencyIsoCode = UserInfo.getDefaultCurrency(); 
        asset.ESN_MB_DocumentId__c = contentId;
        asset.ESN_MB_UrlAsset__c = 'https://pernod-ricard--holsb2dev--c.cs14.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + contentId;
        delete(asset); 
        return asset.Id;
    }*/
    
     /**
    * Method matchEntryAssetArticle(String articleId, String assetId)
    * @param articleId: param of type String, content Id to match on the entry
    * @param assetId: param of type String, asset Id to match on the entry
    * @return entry.Id: returns the id of the new entry
    * This method adds an entry depending on the content Id and the asset Id
    */
    @RemoteAction
    global static String matchEntryAssetActivation(String activationId, String assetId) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Activation__c = activationId;
        entry.ESN_MB_Asset__c = assetId;
        insert(entry);
        return entry.Id;
    }
    

    /* TODO: Créer une Map - Valentin PLITTA 09/09/2014*/
    @RemoteAction 
    global static List<SelectOption> retrieveActivationValues(String activationField, String brandId) 
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult;
        
        if(activationField == 'ActivationType')
        {
            fieldResult = ESN_MB_Activation__c.ESN_MB_Activation_Type__c.getDescribe();
        }
		else if(activationField == 'BusinessPriority' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_BusinessPriority__c.getDescribe();
        }
		else if(activationField == 'Affiliate' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_Affiliate__c.getDescribe();
        }
        else if(activationField == 'Maturity' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_Maturity_Stage__c.getDescribe();
        }
        else if(activationField == 'Pros' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_PROS__c.getDescribe();
        }

        else if(activationField == 'Target' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_Target__c.getDescribe();
        }
        else if(activationField == 'Bugdet' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_Budget__c.getDescribe();
        }
        else if(activationField == 'Legal' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_Legal_Constraints__c.getDescribe();
        }
        else if(activationField == 'Market' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_Market__c.getDescribe();
        }
        else if(activationField == 'MarketType' )
        {
           fieldResult = ESN_MB_Activation__c.ESN_MB_MarketType__c.getDescribe();
        }
        
        /*else if(activationField == 'Product' )
        {
           fieldResult = ESN_MB_Activation__c.  ESN_MB_Product__c.getDescribe();
        }*/

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        //SCH : 07/01/2015 : adding a filter for activation types. Depending on the brand, we only want to display the appropriate types.
        //Appropriate types are defined by entries linking this brand and rubrics in the section 'Brand Activations Library'
        if(activationField == 'ActivationType')
        {
			List<ESN_MB_Entry__c> listEntry = new List<ESN_MB_Entry__c>();
			ESN_MB_NodePage__c[] brand = [SELECT Name FROM ESN_MB_NodePage__c WHERE Id=:brandId LIMIT 1];
			if (brand.size() > 0) {
				if(brand[0].Name.equals('Pernod_Ricard')) {
        			//Retrieving the entries linking this brand and 'Business Activation Library' rubrics
            		listEntry = [SELECT ESN_MB_Rubric__r.Name FROM ESN_MB_Entry__c WHERE ESN_MB_Node_Page__c= :brandId AND ESN_MB_Rubric__r.ESN_MB_Section__c='Business Activation Library'];
        		} else {
        			//Retrieving the entries linking this brand and 'Brand Activations Library' rubrics
            		listEntry = [SELECT ESN_MB_Rubric__r.Name FROM ESN_MB_Entry__c WHERE ESN_MB_Node_Page__c= :brandId AND ESN_MB_Rubric__r.ESN_MB_Section__c='Brand Activations Library'];	
        		}
			} else {
				listEntry = [SELECT ESN_MB_Rubric__r.Name FROM ESN_MB_Entry__c WHERE ESN_MB_Node_Page__c= :brandId AND ESN_MB_Rubric__r.ESN_MB_Section__c='Brand Activations Library'];	
			}
			
        	
            
			//Creating a set with all 'Brand Activations Library' rubric names
            Set<String> setRubricName = new Set<String>();
            for(ESN_MB_Entry__c entryTmp:listEntry){
                if(entryTmp.ESN_MB_Rubric__r != null){
                    setRubricName.add(entryTmp.ESN_MB_Rubric__r.Name);
                }
            }
            
            //Only keeping options matching one on this brand's 'Brand Activations Library' rubric names
            List<SelectOption> listOptionTmp = new List<SelectOption>();
            for(SelectOption optionTmp:options){
                if(setRubricName.contains(optionTmp.getLabel())){
                    listOptionTmp.add(optionTmp);
                }
            }
            //Puting back correct options in the final list.
            options = listOptionTmp;
        }
        
        return options;
    }
    
    @RemoteAction
    global static String deleteAssetEntry(String entryId) 
    {   
        ESN_MB_Entry__c existingEntry = [SELECT Id,ESN_MB_Asset__c From ESN_MB_Entry__c WHERE Id = :entryId];
        ESN_MB_Asset__c  existingAsset = [SELECT Id FROM ESN_MB_Asset__c WHERE Id = :existingEntry.ESN_MB_Asset__c];
        delete existingEntry;
        delete existingAsset;
        return entryId;
    }
    
    @RemoteAction
    global static String deleteActivation(String activationId) 
    {   
        ESN_MB_Activation__c existingActivation = [SELECT Id From ESN_MB_Activation__c WHERE Id = :activationId];
        delete existingActivation;
        return activationId;
    }
    
    /*
     * Creates a ESN_MB_NOP_Article_DTO based on the informations contained in the parameters 
     * - article : contains basic informations (id, title, abstract, texts)
     * - list of Entries : contains Entries (for assets) linked to this article (can contain other entries, only the ones attached to the article are added to the DTO)
     * The entries must contain the following fields of asset : Name, ESN_MB_URL_imagePreview__c, ESN_MB_description__c, ESN_MB_mimeType__c, ESN_MB_Size__c
     */
    public static ESN_MB_NOP_Activation_DTO prepareDTOFromActivation(ESN_MB_Activation__c activation, List<ESN_MB_Entry__c> assetEntryList){
        System.debug('INPUT article = ' + activation);
        System.debug('INPUT assetEntryList = ' + assetEntryList);
        
        ESN_MB_NOP_Activation_DTO activationDTO = new ESN_MB_NOP_Activation_DTO();
        List<ESN_MB_Asset__c> listAssetTmp = new List<ESN_MB_Asset__c>();
        System.debug('Before List of entries activationDTO = ' + activationDTO);

        for(ESN_MB_Entry__c assetEntryTmp:assetEntryList){
            System.debug('Comparing  ' + assetEntryTmp.ESN_MB_Article__c + ' AND ' + activation.Id);
            if(assetEntryTmp.ESN_MB_Article__c == activation.Id){
                System.debug('MATCH FOUND ' + assetEntryTmp.ESN_MB_Asset__r.Name);
                ESN_MB_Asset__c assetTmp = new ESN_MB_Asset__c();
                assetTmp.Name = assetEntryTmp.ESN_MB_Asset__r.Name;
                assetTmp.ESN_MB_URL_imagePreview__c = assetEntryTmp.ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c;
                assetTmp.ESN_MB_description__c = assetEntryTmp.ESN_MB_Asset__r.ESN_MB_description__c;
                assetTmp.ESN_MB_mimeType__c = assetEntryTmp.ESN_MB_Asset__r.ESN_MB_mimeType__c;
                assetTmp.ESN_MB_Size__c = assetEntryTmp.ESN_MB_Asset__r.ESN_MB_Size__c;
                
                listAssetTmp.add(assetTmp);
                System.debug('assetTmp=' + assetTmp);
                System.debug('listAssetTmp=' + listAssetTmp);
            }
        }
        //activationDTO.listAsset = listAssetTmp;
        System.debug('Output activationDTO = ' + activationDTO);
        return activationDTO;
    }
    
    
    /**
    * Method retrieveSelectedArticle(String articleId) 
    * @param articleId: param of type String, id of the article to retrieve
    * @return article
    */
    public static ESN_MB_Activation__c retrieveActivation(String activationId) {

        ESN_MB_Activation__c activation = [SELECT Id, Name, ESN_MB_Target__c, ESN_MB_Budget__c, ESN_MB_Legal_Constraints__c, ESN_MB_Market__c,
                                           ESN_MB_BusinessPriority__c, ESN_MB_Affiliate__c, ESN_MB_Maturity_Stage__c, ESN_MB_Results__c, ESN_MB_How__c, ESN_MB_ToWhom__c, ESN_MB_What__c, ESN_MB_Why__c, ESN_MB_Product__c,
										   ESN_MB_BigIdea__c, ESN_MB_StrategicFit__c, ESN_MB_ExcellenceOfExecution__c, ESN_MB_BusinessImpact__c, ESN_MB_ScalabilityAndReplicability__c,
                                           ESN_MB_Activation_Type__c
                                           FROM ESN_MB_Activation__c
                                           WHERE Id = :activationId 
                                           limit 1];
        return activation;
    }

    
    
    /*
     * Clones an article in parameter.
     * Also clones Entries (to link the article to the rubric and fetch the assets
     */
    @RemoteAction
    global static ESN_MB_NOP_Activation_DTO cloneArticleStageDraft(String activationId){
        System.debug('activationId = ' + activationId);
        ESN_MB_Activation__c activationToClone = retrieveActivation(activationId);
        System.debug('activationToClone = ' + activationToClone);
        ESN_MB_Activation__c activationClone = activationToClone.clone(false, true);
        System.debug('activationClone before refining = ' + activationClone);
        
        activationClone.ESN_MB_Stage__c = 'Draft';
        /*if(activationToClone.ESN_MB_ParentArticle__c == null || activationToClone.ESN_MB_Stage__c == 'Published'){
            activationClone.ESN_MB_ParentArticle__c = activationId;
        }*/
        Database.SaveResult result = Database.insert(activationClone);
        
        List<ESN_MB_Entry__c> listEntryToClone = [Select id, ESN_MB_RoleAsset__c, ESN_MB_Activation__c, ESN_MB_Asset__c, ESN_MB_Node_Page__c, ESN_MB_Resource__c, ESN_MB_Rubric__c from ESN_MB_Entry__c
            Where ESN_MB_Activation__r.id=:activationId];
        
        List<ESN_MB_Entry__c> listEntryClone = new List<ESN_MB_Entry__c>();
        for(ESN_MB_Entry__c entryToCloneTmp:listEntryToClone){
            ESN_MB_Entry__c cloneEntry = entryToCloneTmp.clone(false, true);
            System.debug('==========>entryToCloneTmp=' + entryToCloneTmp);
            System.debug('==========>cloneEntry=' + cloneEntry);
            
            cloneEntry.ESN_MB_Activation__c = result.getId();
            listEntryClone.add(cloneEntry);
        }
        System.debug('listEntryClone=' + listEntryClone);
        List<Database.SaveResult> listResult = Database.insert(listEntryClone);
        
        List<ESN_MB_Entry__c> listEntries = [Select ESN_MB_Activation__c, ESN_MB_Activation__r.Id, ESN_MB_Asset__c, ESN_MB_Asset__r.Name,
                                                ESN_MB_Asset__r.ESN_MB_URL_imagePreview__c, ESN_MB_Asset__r.ESN_MB_description__c,
                                                ESN_MB_Asset__r.ESN_MB_mimeType__c, ESN_MB_Asset__r.ESN_MB_Size__c
                                                From ESN_MB_Entry__c
                                                Where ESN_MB_Activation__r.Id = :result.getId()
                                                And ESN_MB_Asset__c<>null];
        return prepareDTOFromActivation(activationClone, listEntries);
    }
    
     /*
     * Clones an activation in parameter.
     * Also clones Entries (to link the activation to the assets and users interactions
     */
    @RemoteAction
    global static ESN_MB_NOP_Activation_DTO cloneActivationStageDraft(String activationId){
        //Creation activation Draft
        ESN_MB_Activation__c activation = new ESN_MB_Activation__c();
        List<ESN_MB_Entry__c> assetListEntryClone = new List<ESN_MB_Entry__c>();
        List<ESN_MB_User_Interaction__c> userInteractionListClone = new List<ESN_MB_User_Interaction__c>();
        
        // Recuperation Activation
        ESN_MB_Activation__c retrieveActivation = [SELECT Id, Name, ESN_MB_Market__c,ESN_MB_Results__c, ESN_MB_How__c, ESN_MB_ToWhom__c, 
                                                   ESN_MB_What__c, ESN_MB_Why__c, ESN_MB_Product__c, ESN_MB_Parent_Activation__c, ESN_MB_AvgCrit1__c, ESN_MB_AvgCrit2__c,
												   ESN_MB_BigIdea__c, ESN_MB_StrategicFit__c, ESN_MB_ExcellenceOfExecution__c, ESN_MB_BusinessImpact__c, ESN_MB_ScalabilityAndReplicability__c,
                                                   ESN_MB_AvgCrit3__c ,ESN_MB_AvgCrit4__c, ESN_MB_AvgCrit5__c, ESN_MB_CountCrit1__c, ESN_MB_CountCrit2__c, ESN_MB_CountCrit3__c,
                                                   ESN_MB_CountCrit4__c, ESN_MB_CountCrit5__c, ESN_MB_AlsoInMasterbrand__c
                                                   FROM ESN_MB_Activation__c
                                                   WHERE Id = :activationId  
                                                   limit 1];
        
        activation = retrieveActivation.clone(false,true);
        activation.ESN_MB_Stage__c = 'Draft';
        activation.ESN_MB_MainActivationId__c = activationId;
        insert(activation); 
        
        // Recuperation Assets
        List<ESN_MB_Entry__c> assetsListToClone = [Select ESN_MB_Asset__c, ESN_MB_Asset__r.ESN_MB_UrlAsset__c,  ESN_MB_Asset__r.ESN_MB_DocumentId__c,
                                                   ESN_MB_Asset__r.ESN_MB_description__c, ESN_MB_RoleAsset__c,ESN_MB_KeyContact__c
                                                   FROM ESN_MB_Entry__c 
                                                   WHERE ESN_MB_Activation__c = :activationId
                                                   ORDER BY CreatedDate DESC];
        
        for(ESN_MB_Entry__c entryToCloneTmp:assetsListToClone){
            ESN_MB_Entry__c cloneEntry = entryToCloneTmp.clone(false, true);
            System.debug('==========>entryToCloneTmp=' + entryToCloneTmp);
            System.debug('==========>cloneEntry=' + cloneEntry);
            
            cloneEntry.ESN_MB_Activation__c = activation.Id;
            assetListEntryClone.add(cloneEntry);
        }
        insert(assetListEntryClone);
        
        // Recuperation User Interactions
        List<ESN_MB_User_Interaction__c> userInteractionToClone = [Select ESN_MB_User__c, ESN_MB_Average_Rating__c, ESN_MB_Follow__c, ESN_MB_KeyContact__c,
                                                                   ESN_MB_Like__c, ESN_MB_Rating_Criteria_1__c, ESN_MB_Rating_Criteria_2__c, ESN_MB_Rating_Criteria_3__c, 
                                                                   ESN_MB_Rating_Criteria_4__c, ESN_MB_Rating_Criteria_5__c 
                                                                   FROM ESN_MB_User_Interaction__c
                                                                   WHERE ESN_MB_Activation__c = :activationId];
        
        for(ESN_MB_User_Interaction__c userInteractionToCloneTmp:userInteractionToClone) {
            ESN_MB_User_Interaction__c cloneUserInteraction = userInteractionToCloneTmp.clone(false, true);
            System.debug('==========>userInteractionToCloneTmp=' + userInteractionToCloneTmp);
            System.debug('==========>userInteractionToClone=' + cloneUserInteraction);
            cloneUserInteraction.ESN_MB_Activation__c = activation.Id;
            userInteractionListClone.add(cloneUserInteraction);
        }
        insert(userInteractionListClone);
        
        ESN_MB_NOP_Activation_DTO activationDTO = new ESN_MB_NOP_Activation_DTO();
        
        activationDTO.activationId = activation.Id;
        activationDTO.countryText = activation.ESN_MB_Market__c;
        activationDTO.titleText = activation.Name;
        activationDTO.whyText = activation.ESN_MB_Why__c;
        activationDTO.whatText = activation.ESN_MB_What__c;
        activationDTO.toWhomText = activation.ESN_MB_ToWhom__c;
        activationDTO.howText = activation.ESN_MB_How__c;
        activationDTO.resultsText = activation.ESN_MB_Results__c;
        activationDTO.stage = activation.ESN_MB_Stage__c;
		activationDTO.bigIdea = activation.ESN_MB_BigIdea__c;
		activationDTO.strategicFitText = activation.ESN_MB_StrategicFit__c;
		activationDTO.excellenceOfExecutionText = activation.ESN_MB_ExcellenceOfExecution__c;
		activationDTO.businessImpactText = activation.ESN_MB_BusinessImpact__c;
		activationDTO.scalabilityAndReplicabilityText = activation.ESN_MB_ScalabilityAndReplicability__c;
        activationDTO.alsoInMasterbrand = activation.ESN_MB_AlsoInMasterbrand__c;
        
        activationDTO.listEntryAsset = assetListEntryClone;
        activationDTO.listUserInteraction = userInteractionListClone;
        
        return activationDTO;
    }
    
    /*
     * This method creates a User Interaction between the current User and the MarketActivation passed in paramater, and sets the criteria value.
     * If this User Interacion already exists, it is updated instead.
     * idMA : the MA to rate
     * criteriaPosition : the position of the criteria (1 to 5 at the moment)
     * ratingValue : the number of stars to set in the criteria
     */
    @RemoteAction
    global static ESN_MB_Activation__c rateMACriteria(String idMA, Integer criteriaPosition, Integer ratingValue){
        System.debug('rateMACriteria(' + idMA + ', ' + criteriaPosition + ', ' + ratingValue + ')');
        ESN_MB_User_Interaction__c ui = retrieveOrInsertUserInteraction(idMA, UserInfo.getUserId());
        if(criteriaPosition == 1) {
            ui.ESN_MB_Rating_Criteria_1__c = ratingValue;
        } else if(criteriaPosition == 2) {
            ui.ESN_MB_Rating_Criteria_2__c = ratingValue;
        } else if(criteriaPosition == 3) {
            ui.ESN_MB_Rating_Criteria_3__c = ratingValue;
        } else if(criteriaPosition == 4) {
            ui.ESN_MB_Rating_Criteria_4__c = ratingValue;
        } else if(criteriaPosition == 5) {
            ui.ESN_MB_Rating_Criteria_5__c = ratingValue;
        }
        
        if(Database.update(ui).isSuccess()){
            System.debug('UI updated successfully : ' + ui);
        }
        ESN_MB_Activation__c maAvgRate = [Select ESN_MB_AvgCrit1__c,ESN_MB_AvgCrit2__c,ESN_MB_AvgCrit3__c,ESN_MB_AvgCrit4__c,ESN_MB_AvgCrit5__c,
                                          ESN_MB_CountCrit1__c,ESN_MB_CountCrit2__c,ESN_MB_CountCrit3__c,ESN_MB_CountCrit4__c,ESN_MB_CountCrit5__c
                                          From ESN_MB_Activation__c 
                                          Where Id = :idMA];
        return maAvgRate;
    }
    
    /**
     * Method thumbUpMA(String idMA)
     * @param idMA : string param corresponding to the market activation to like/unlike by user
     */ 
    @RemoteAction
    global static decimal thumbUpMA(String idMA) {
        ESN_MB_User_Interaction__c ui = retrieveOrInsertUserInteraction(idMA, UserInfo.getUserId());
        if(ui.ESN_MB_Like__c == true) {
            ui.ESN_MB_Like__c = false;
        }else {
            ui.ESN_MB_Like__c = true;
        }
        if(Database.update(ui).isSuccess()){
            System.debug('UI updated successfully : ' + ui);
        }
        decimal nbTotalLike = [Select ESN_MB_TotalLike__c
                               From ESN_MB_Activation__c 
                               Where id = :idMA].ESN_MB_TotalLike__c;
        return nbTotalLike;
    }
    
    
     @RemoteAction
    global static void likeMA(String idMA){
        System.debug('likeMA(' + idMA + ')');
        ESN_MB_User_Interaction__c ui = retrieveOrInsertUserInteraction(idMA, UserInfo.getUserId());
        ui.ESN_MB_Like__c = true;
        if(Database.update(ui).isSuccess()){
            System.debug('UI updated successfully : ' + ui);
        }
    }

     @RemoteAction
    global static void unlikeMA(String idMA){
        System.debug('unlikeMA(' + idMA + ')');
        ESN_MB_User_Interaction__c ui = retrieveOrInsertUserInteraction(idMA, UserInfo.getUserId());
        ui.ESN_MB_Like__c = false;
        if(Database.update(ui).isSuccess()){
            System.debug('UI updated successfully : ' + ui);
        }
    }

     @RemoteAction
    global static void followMA(String idMA){
        System.debug('followMA(' + idMA + ')');
        ESN_MB_User_Interaction__c ui = retrieveOrInsertUserInteraction(idMA, UserInfo.getUserId());
        ui.ESN_MB_Follow__c = true;
        if(Database.update(ui).isSuccess()){
            System.debug('UI updated successfully : ' + ui);
        }
        EntitySubscription subToInsert = new EntitySubscription();
        subToInsert.SubscriberId = UserInfo.getUserId();
        subToInsert.ParentId = idMA;
        Database.insert(subToInsert);
    }

     @RemoteAction
    global static void unfollowMA(String idMA){
        System.debug('unfollowMA(' + idMA + ')');
        ESN_MB_User_Interaction__c ui = retrieveOrInsertUserInteraction(idMA, UserInfo.getUserId());
        ui.ESN_MB_Follow__c = false;
        if(Database.update(ui).isSuccess()){
            System.debug('UI updated successfully : ' + ui);
        }
        
        List<EntitySubscription> listSubToDelete = [SELECT Id
            FROM EntitySubscription 
            WHERE SubscriberId = :UserInfo.getUserId()
            And ParentId = :idMA];
            
        if(listSubToDelete.size() > 0){
            Database.delete(listSubToDelete);
        }
    }

    
    public static ESN_MB_User_Interaction__c retrieveOrInsertUserInteraction(String idActivation, String idUser){
        System.debug('retrieveOrInsertUserInteraction(' + idActivation + ', ' + idUser + ')');
        ESN_MB_User_Interaction__c result = null;
        //We look for the UI
        List<ESN_MB_User_Interaction__c> listUI = [Select Id, ESN_MB_Activation__c, ESN_MB_Average_Rating__c, ESN_MB_Follow__c, ESN_MB_KeyContact__c, ESN_MB_Like__c, ESN_MB_Rating_Criteria_1__c, ESN_MB_Rating_Criteria_2__c, ESN_MB_Rating_Criteria_3__c, ESN_MB_Rating_Criteria_4__c, ESN_MB_Rating_Criteria_5__c, ESN_MB_User__c
                                                   From ESN_MB_User_Interaction__c
                                                   Where ESN_MB_User__c = :idUser
                                                   And ESN_MB_Activation__c = :idActivation
                                                   Limit 1];
        //If no UI is returned, then we insert one
        if(listUI.size()==0){
            result = new ESN_MB_User_Interaction__c();
            result.ESN_MB_User__c = idUser;
            result.ESN_MB_Activation__c = idActivation;
            System.debug('We insert this UI ' + result);
            if(Database.insert(result).isSuccess()){
                System.debug('Insert successful for UI ' + result.Id);
            }
        } else { //Otherwise, we return the existing one
            System.debug('We return the existing UI ' + listUI[0]);
            result = listUI[0];
        }
        
        System.debug('Returned UI=' + result);
        return result;
    }
     /**
    * Method createEntryAssetActivation(String currentActivationId, String assetId, boolean mainAsset)
    * @param currentActivationId: String param containing the id of the current activation
    * @param assetId: String param containing the asset to link to the article on the entry
    * @param roleAsset: String param containing the role of the asset on the entry
    * @return entry.Id: returns the id of the entry.
    */
    @RemoteAction
    global static String createEntryAssetActivation(String currentActivationId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entry = new ESN_MB_Entry__c();
        entry.ESN_MB_Activation__c = currentActivationId;
        entry.ESN_MB_Asset__c = assetId;
        entry.ESN_MB_RoleAsset__c = roleAsset;
        entry.RecordTypeId = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_Assets');
        insert entry;
        return entry.Id;
    }
    
    /**
    * Method deleteEntryAssetActivation(String currentActivationId, String assetId)
    * @param currentActivationId: String param containing the current activation Id
    * @param assetId: String param containing the asset id linked to the activation
    */ 
    @remoteAction 
    global static void deleteEntryAssetActivation(String currentActivationId, String assetId, String roleAsset) {
        ESN_MB_Entry__c entryAssetActivation = [Select Id 
                                                From ESN_MB_Entry__c 
                                                Where ESN_MB_Activation__c = :currentActivationId 
                                                And ESN_MB_Asset__c = :assetId
                                                And ESN_MB_RoleAsset__c = :roleAsset
                                                limit 1];
        delete entryAssetActivation;
    }
    
    /**
    * Method setParentActivation(String marketActivationId, String brandActivationId)
    * @param marketActivationId: id of the market activation to edit
    * @param brandActivationId: id of the brand activation to set as the toolkit
    */
    @RemoteAction
    global static void deleteParentActivation(String marketActivationId) {
        ESN_MB_Activation__c currentActivation = [Select Id, ESN_MB_Parent_Activation__c 
                                                  From ESN_MB_Activation__c 
                                                  Where Id = :marketActivationId];
        currentActivation.ESN_MB_Parent_Activation__c = null;
        update currentActivation;
    }
    
    /**
    * Method retrieveMALinkToBA(String marketActivationId)
    */
    @RemoteAction
    global static ESN_MB_Entry__c retrieveMALinkToBA(String marketActivationId) {
        String bAId = [Select ESN_MB_Parent_Activation__c 
                       From ESN_MB_Activation__c
                       Where id = :marketActivationId].ESN_MB_Parent_Activation__c;
        ESN_MB_Entry__c brandActivation = [Select ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c, ESN_MB_Activation__r.Name, ESN_MB_Activation__c, ESN_MB_Asset__r.ESN_MB_DocumentId__c
                                           From ESN_MB_Entry__c
                                           Where ESN_MB_Activation__c = :bAId
                                           AND ESN_MB_RoleAsset__c = 'MainAsset'
                                           limit 1];
        return brandActivation;
    }
    
    /**
    * Method retrieveMAToDisplayOnBA(String brandActivationId)
    */
    @RemoteAction
    global static List<ESN_MB_Entry__c> retrieveMAToDisplayOnBA(String brandActivationId) {
          List<ESN_MB_Entry__c> listEntryOfMarketActivationLinked = [Select ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c, 
                                                                    ESN_MB_Activation__r.Name, ESN_MB_Activation__c, ESN_MB_Asset__r.ESN_MB_DocumentId__c,ESN_MB_Activation__r.ESN_MB_Market__c
                                                                    From ESN_MB_Entry__c
                                                                    Where ESN_MB_Activation__r.ESN_MB_Parent_Activation__c = :brandActivationId
                                                                    AND ESN_MB_RoleAsset__c = 'MainAsset'];
        return listEntryOfMarketActivationLinked; 
    }
    
    /**
    * Method deleteEntryActivationKeyContact(String currentActivationId, String keyContactId)
    * @param currentActivationId: String param containing the current activation Id
    * @param keyContactId: String param containing the user id linked to the activation
    */ 
    @remoteAction 
    global static void deleteEntryActivationKeyContact(String currentActivationId, String keyContactId) {
        ESN_MB_Entry__c entryAssetActivation = [Select Id 
                                                From ESN_MB_Entry__c 
                                                Where ESN_MB_Activation__c = :currentActivationId 
                                                And ESN_MB_KeyContact__c = :keyContactId
                                                limit 1];
        delete entryAssetActivation;
    }
    
    /**
    * Method retrieveActivationKeyContacts(String currentActivationId)
    * @param currentActivationId: String param containing the current activation Id
    * @return keyContactList: returns a list of key contacts
    */ 
    @remoteAction 
    global static List<ESN_MB_Entry__c> retrieveActivationKeyContacts(String currentActivationId) {
        String activationToKeyContactRT = ESN_MB_Utils.getRecordTypeId('ESN_MB_Activations_To_KeyContacts');
        List<ESN_MB_Entry__c> keyContactList = [Select ESN_MB_KeyContact__c, ESN_MB_KeyContact__r.Name,ESN_MB_KeyContact__r.Title, 
                                                ESN_MB_KeyContact__r.SmallPhotoUrl,ESN_MB_KeyContact__r.Email
                                                From ESN_MB_Entry__c
                                                Where ESN_MB_Activation__c = :currentActivationId
                                                And recordTypeId = :activationToKeyContactRT];
        return keyContactList;
    }
    
    /**
    * Method retrieveUserMALikes(List<String> marketActivationIdsList)
    * @param marketActivationIdsList: List of strings, containing the current market activations ids list to check  
    * @return marketActivationLikedList: returns a list of ids of the market activations the user likes
    */ 
    @RemoteAction
    global static List<ESN_MB_User_Interaction__c> retrieveUserMALikes(List<String> marketActivationIdsList) {
        String userId = userInfo.getUserId();
        List<ESN_MB_User_Interaction__c> marketActivationLikedList = [Select ESN_MB_Activation__c 
                                                                      From ESN_MB_User_Interaction__c 
                                                                      Where ESN_MB_Like__c = true 
                                                                      And ESN_MB_User__c = :userId
                                                                      And ESN_MB_Activation__c IN :marketActivationIdsList];
        system.debug('Market Activations Liked by this user : ' + marketActivationLikedList);
        return marketActivationLikedList;
    }
    
    
    
    @RemoteAction 
    global static boolean isBroadCasterUser(){
        return ESN_MB_UtilsUser.isBroadCasterUser();
    }
    @RemoteAction 
    global static boolean isBasicUser(){
        return ESN_MB_UtilsUser.isBasicUser();
    }
    @RemoteAction 
    global static boolean isBroadCasterAssigned(String brandId){
        return ESN_MB_UtilsUser.isBroadCasterUser(brandId);
    }
    @RemoteAction 
    global static boolean isBroadCasterManagerAssigned(String brandId){
        return ESN_MB_UtilsUser.isBroadcasterManagerUser(brandId);
    }

	@RemoteAction 
    global static boolean isBusinessActivationOwnerOrBroadCasterAssigned(String brandId, String activationId){
        boolean ret = false;

		boolean owner = ESN_MB_UtilsUser.isBusinessActivationOwner(activationId);
		boolean broadcaster = ESN_MB_UtilsUser.isBroadCasterUser(brandId);
		if (owner || broadcaster) {
			ret = true;
		}
		
		return ret;
    }

	@RemoteAction 
    global static boolean isBusinessActivationOwnerOrBroadCasterManagerAssigned(String brandId, String activationId){
        boolean ret = false;

		boolean owner = ESN_MB_UtilsUser.isBusinessActivationOwner(activationId);
		boolean broadcasterManager = ESN_MB_UtilsUser.isBroadcasterManagerUser(brandId);
		if (owner || broadcasterManager) {
			ret = true;
		}
		
		return ret;
    }

	@RemoteAction 
    global static String currentUserId(){
        return UserInfo.getUserId();
    }

	public String getCoordinator() {
		return System.currentPageReference().getParameters().get('Coordinator');
	}

	public String getListCoordinators() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_Coordinator__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}
}