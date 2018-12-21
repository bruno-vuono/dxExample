public with sharing class EUR_CRM_Account_PRSegPageSectionCntrl {

    public EUR_CRM_PRS_Segmentation__c prSegmentation   {get;set;}
    public EUR_CRM_Account__c euAccount                 {get;set;}

    public String groupOutletType                       {get;set;}
    public String outletType                            {get;set;}
    public String priority                              {get;set;}
    public Boolean isPRSPopulated                       {get;set;}
    public String url                                   {get;set;}
    public Boolean isRedirect                           {get;set;}{isRedirect = false;}

    public List<String> businessPotentialLabels         {get;set;}
    public List<String> brandBuildingPotentialLabels    {get;set;}
    public List<String> imageLevelLabels                {get;set;}
    public List<String> volumePotentialLabels           {get;set;}
    
    public Map<String, Boolean> potentialMap            {get;set;}


    public Boolean isPROS                               {get;set;}
    public Boolean isPROFS                              {get;set;}

    public Integer noOfRow                              {get;set;}
    public Integer noOfCol                              {get;set;}


    public EUR_CRM_Account_PRSegPageSectionCntrl(ApexPages.StandardController standardController){
        List<EUR_CRM_PRS_Segmentation__c> prSegmentationList = [SELECT Id, EUR_CRM_Account__c
                                                                FROM EUR_CRM_PRS_Segmentation__c
                                                                WHERE EUR_CRM_Account__c =: standardController.getId()
                                                               ];
        euAccount = [SELECT Id, RecordTypeId, RecordType.DeveloperName,
                            EUR_CRM_Force_Group_Outlet_Type__c,
                            EUR_CRM_Force_Outlet_Type__c,
                            EUR_CRM_Force_Business_potential__c,
                            EUR_CRM_Force_Brand_Building_Potential__c,
                            EUR_CRM_PRS_Group_Outlet_Type__c,
                            EUR_CRM_PRS_Outlet_Type__c,
                            EUR_CRM_Business_Potential__c,
                            EUR_CRM_Brand_Building_Potential__c,
                            EUR_CRM_PRS_Image_Level__c,
                            EUR_CRM_PRS_Volume_Potential__c,
                            EUR_CRM_Force_PRS_Image_Level__c,
                            EUR_CRM_Force_PRS_Volume_Potential__c,
                            EUR_CRM_PRS_Priority_Level_Criteria__c,
                            EUR_CRM_PRS_Group_Outlet_Type__r.EUR_CRM_Group_Outlet_Type_Name__c,
                            EUR_CRM_PRS_Outlet_Type__r.EUR_CRM_PRS_Outlet_Type_Name__c,
                            EUR_CRM_Brand_Building_Potential__r.EUR_CRM_Segmentation_BBP_Aspect_Name__c,
                            EUR_CRM_Business_Potential__r.EUR_CRM_Segmentation_BP_Aspect_Name__c,
                            EUR_CRM_PRS_Image_Level__r.EUR_CRM_Segmentation_IL_Aspect_Name__c,
                            EUR_CRM_PRS_Volume_Potential__r.EUR_CRM_Segmentation_VP_Aspect_Name__c,
                            EUR_CRM_PRS_Priority_Level_Criteria__r.EUR_CRM_Priority_Level__c
                     FROM EUR_CRM_Account__c
                     WHERE Id =: standardController.getId()
                    ];

        if(prSegmentationList.size() > 0){
            prSegmentation = prSegmentationList[0];

            isPROS = EUR_CRM_RecordTypeHelper.euAccounts_PRS_SegmentationTypeMap.get(euAccount.RecordType.DeveloperName).get('isPROS');
            isPROFS = EUR_CRM_RecordTypeHelper.euAccounts_PRS_SegmentationTypeMap.get(euAccount.RecordType.DeveloperName).get('isPROFS');
        }

        if(isPROFS){
            // Verify that the PRS details are already filled                      
            if(euAccount != null &&
               euAccount.EUR_CRM_PRS_Group_Outlet_Type__c != null &&
               euAccount.EUR_CRM_PRS_Outlet_Type__c != null &&
               euAccount.EUR_CRM_Brand_Building_Potential__c != null &&
               euAccount.EUR_CRM_Business_Potential__c != null)
            {
                this.groupOutletType = euAccount.EUR_CRM_PRS_Group_Outlet_Type__r.EUR_CRM_Group_Outlet_Type_Name__c;
                this.outletType = euAccount.EUR_CRM_PRS_Outlet_Type__r.EUR_CRM_PRS_Outlet_Type_Name__c;
                this.brandBuildingPotentialLabels = EUR_CRM_PRSegmentationClass.returnBrandBuildingPotentialLabels();
                this.businessPotentialLabels = EUR_CRM_PRSegmentationClass.returnBusinessPotentialLabels();
                this.potentialMap = EUR_CRM_PRSegmentationClass.returnEUAccountPROFSPotentialMatrix(this.euAccount);
                this.priority = euAccount.EUR_CRM_PRS_Priority_Level_Criteria__r.EUR_CRM_Priority_Level__c;
                noOfRow = this.brandBuildingPotentialLabels.size();
                noOfCol = this.businessPotentialLabels.size();
                this.isPRSPopulated = true;
            }
            else {
                this.isPRSPopulated = false;
            }
        }
        else if(isPROS){
            // Verify that the PRS details are already filled                      
            if(euAccount != null &&
               euAccount.EUR_CRM_PRS_Group_Outlet_Type__c != null &&
               euAccount.EUR_CRM_PRS_Outlet_Type__c != null &&
               euAccount.EUR_CRM_PRS_Image_Level__c != null &&
               euAccount.EUR_CRM_PRS_Volume_Potential__c != null)
            {
                this.groupOutletType = euAccount.EUR_CRM_PRS_Group_Outlet_Type__r.EUR_CRM_Group_Outlet_Type_Name__c;
                this.outletType = euAccount.EUR_CRM_PRS_Outlet_Type__r.EUR_CRM_PRS_Outlet_Type_Name__c;
                this.imageLevelLabels = EUR_CRM_PRSegmentationClass.returnImageLevelLabels();
                this.volumePotentialLabels = EUR_CRM_PRSegmentationClass.returnVolumePotentialLabels();
                this.potentialMap = EUR_CRM_PRSegmentationClass.returnEUAccountPROSPotentialMatrix(this.euAccount);
                noOfRow = this.imageLevelLabels.size();
                noOfCol = this.volumePotentialLabels.size();
                this.isPRSPopulated = true;
            }
            else {
                this.isPRSPopulated = false;
            }
        }
    }

    public PageReference setPRSUrl() {
        if (prSegmentation!=null){
            url = '/' + prSegmentation.Id;
            System.debug('redirect url:' + '/' + prSegmentation.Id); 
            isRedirect = true;        
        }
        return null;
    }
}