public with sharing class EUR_CRM_MassUpdateControllerExt {
    /** Soon to be deleted
    public List<EUR_CRM_Pros_Segmentation__c> pros;
   
    private final ApexPages.StandardSetController cntr;
    private final PageReference fromPage;
    private final List<EUR_CRM_Pros_Segmentation__c> objs;
    private Map<String, Schema.SObjectField> fieldMap;
    private transient ApexPages.Message currentMsg;
    private final String newLine ='<br></br>';
    private Schema.SObjectField field;
    private String sType;
    private Object convertedFieldData;
    private List<SelectOption> picklistValues;
    private String currentStep;
   
    //new variables
    private EUR_CRM_CriteriaManager mgr {get;set;}
    private Double total;
    private Double answerWeight;
    private Set<Id> prosSegIds;
    private Set<Id> caImgLvlSetIds;
    private Set<Id> caVolPotSetIds;
    private List<EUR_CRM_Group_Outlet_Type__c> groupOutletTypeInfoList;
    private List<EUR_CRM_Criteria_Set__c> criteriaSetInfoList; //Image level
    private List<EUR_CRM_Criteria_Set__c> criteriaSetInfoListVol; //Vol Potential
   
   
    private Map<Id, EUR_CRM_Criteria_Threshold__c> criteriaThresholds; //Image Level
    private Map<Id, EUR_CRM_Criteria_Threshold__c> criteriaThresholdsVol; //Vol Potential
    private List<EUR_CRM_Criteria_Threshold__c> criteriaThresholdsList{get;set;}    //Image Level
    private List<EUR_CRM_Criteria_Threshold__c> criteriaThresholdsListVol{get;set;} //Vol Potential 
    private List<EUR_CRM_Criteria_Answer__c> answersList; //Image Level
    private List<EUR_CRM_Criteria_Answer__c> answersListVol; //Vol Potential
    private Map<Id, List<EUR_CRM_Criteria_Answer__c>> criteriaAnswers; //Image Level
    private Map<Id, List<EUR_CRM_Criteria_Answer__c>> criteriaAnswersVol; //Vol Potential
   
    public Map<Id, String> answerSheet{get;set;}
    public Map<Id, String> answerSheetVol{get;set;}
   
    private Map<Id, EUR_CRM_Pros_Image_Level__c> imageLevelMap{get;set;}{imageLevelMap = new Map<Id, EUR_CRM_Pros_Image_Level__c>();}
    private Map<Id, EUR_CRM_Pros_Volume_Potential__c> volumePotentialMap{get;set;}{volumePotentialMap = new Map<Id, EUR_CRM_Pros_Volume_Potential__c>();}
   
    private List<EUR_CRM_Pros_Image_Level__c>newImageLevels;
    private List<EUR_CRM_Pros_Volume_Potential__c>newVolumePotentials;     

    public  EUR_CRM_Pros_Image_Level__c accountCriteria;
    public  EUR_CRM_Pros_Volume_Potential__c accountCriteriaVolumePotential;
    
    public EUR_CRM_MassUpdateControllerExt(ApexPages.StandardSetController controller) {
        System.debug('controller' + controller);
           cntr = (ApexPages.StandardSetController)controller;
           System.debug('@@@cnt' + cntr);
           
           String pid = cntr.getFilterId();
         
       system.debug('****Id' + pid);
       fromPage = cntr.cancel();
       if (this.objs == null) {
            this.objs = (List<EUR_CRM_Pros_Segmentation__c>)cntr.getSelected();
       }
       if (getRecordSize()<1) {
            String msg = 'No record was selected on the list view.  Please click Previous button and select records for mass update.'; 
            currentMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
       } else {
            sType= discoverSObjectType(objs.get(0)).getName(); 
            String msg = 'Number of records selected for update: ' + getRecordSize(); 
            currentMsg = new ApexPages.Message(ApexPages.severity.INFO, msg);
       }
       ApexPages.addMessage(currentMsg);
       
       System.debug('@@@cnt' + this.objs);
       
       for (EUR_CRM_Pros_Segmentation__c eups : objs){
            system.debug('@@Ids' + eups.Id);
       }
       newImageLevels = new List<EUR_CRM_Pros_Image_Level__c>();
       newVolumePotentials = new List<EUR_CRM_Pros_Volume_Potential__c>();
       mgr = new EUR_CRM_CriteriaManager();
       answerWeight = 0;
       initProsSegRecords();
    }
    
    
    public void initProsSegRecords(){
        prosSegIds = new Set<Id>();
        caImgLvlSetIds  = new Set<Id>();
        caVolPotSetIds = new Set<Id>();
        
        Set<Id> groupOutletIds = new Set<Id>();
        Set<Id> volSetIds       = new Set<Id>();
        Set<Id> imgLvlSetIds    = new Set<Id>();
        Set<Id> ctVolSetIds     = new Set<Id>();
        Set<Id> ctImgLvlSetIds  = new Set<Id>();
        Set<Id> caVolSetIds     = new Set<Id>();
        
        for (EUR_CRM_Pros_Segmentation__c eups : objs){
            prosSegIds.add(eups.Id);
            groupOutletIds.add(eups.EUR_CRM_Group_Outlet_Type__c);
        }
        
        groupOutletTypeInfoList = new List<EUR_CRM_Group_Outlet_Type__c>();
        criteriaSetInfoList = new List<EUR_CRM_Criteria_Set__c>();
        criteriaSetInfoListVol = new List<EUR_CRM_Criteria_Set__c>();
        
        groupOutletTypeInfoList = [Select Id, EUR_CRM_Name__c, 
                                    EUR_CRM_Image_Criteria_Set__r.Id, EUR_CRM_Volume_Criteria_Set__r.Id, EUR_CRM_Country_Code__c
                                        FROM EUR_CRM_Group_Outlet_Type__c 
                                            where Id IN: groupOutletIds];
                                            
        
        if (groupOutletTypeInfoList != null){
            //Get Criteria Sets of the group outlet
            List<EUR_CRM_Criteria_Set__c> criteriaSetVolumeList = new List<EUR_CRM_Criteria_Set__c>();
            List<EUR_CRM_Criteria_Set__c> criteriaSetImgLvlList = new List<EUR_CRM_Criteria_Set__c>();
                                            
            for (EUR_CRM_Group_Outlet_Type__c grp: groupOutletTypeInfoList){
                volSetIds.add(grp.EUR_CRM_Volume_Criteria_Set__r.Id);
                imgLvlSetIds.add(grp.EUR_CRM_Image_Criteria_Set__r.Id);
            }
            
            criteriaSetImgLvlList = [SELECT Id, EUR_CRM_Name__c FROM EUR_CRM_Criteria_Set__c WHERE Id IN: imgLvlSetIds];
            criteriaSetVolumeList = [SELECT Id, EUR_CRM_Name__c FROM EUR_CRM_Criteria_Set__c WHERE Id IN: volSetIds];
            
            if (criteriaSetImgLvlList.size() > 0){
                criteriaSetInfoList = criteriaSetImgLvlList;
            }
            
            if (criteriaSetVolumeList.size () > 0){
                criteriaSetInfoListVol = criteriaSetVolumeList;
            }
            
            system.debug('criteriaSetInfoList' +criteriaSetInfoList);
        }
        
        
        getCriteriaThresholds();
        getCriteriaThresholdsVol();
        getAnswers();
        getAnswersVol();
        getCriteriaAnswers();
        getCriteriaAnswersVol();
        returnAnswerSheet();
        returnAnswerSheetVol();
        returnImageLevelMap();
        returnVolumePotentialMap();
    }
    
    //SETTER
    public void setCriteriaSetInfo(List<EUR_CRM_Criteria_Set__c> criteriaSetInfoList)
    {
        system.debug('XXXXX');
        this.criteriaSetInfoList = criteriaSetInfoList;
        
        system.debug('@@THIS' + this.criteriaSetInfoList);
    }
    
    public void setCriteriaThreshold(Map<Id, EUR_CRM_Criteria_Threshold__c> criteriaThresholds)
    {
        this.criteriaThresholds = criteriaThresholds;
    }
    public void setCriteriaAnswers(Map<Id, List<EUR_CRM_Criteria_Answer__c>> criteriaAnswers)
    {
        this.criteriaAnswers = criteriaAnswers;
    }
    public void setAnswers(List<EUR_CRM_Criteria_Answer__c> answersList)
    {
        this.answersList = answersList;
    }
    
    public void setCriteriaSetInfoVol(List<EUR_CRM_Criteria_Set__c> criteriaSetInfoListVol)
    {
        system.debug('XXXXX');
        this.criteriaSetInfoListVol = criteriaSetInfoListVol;
        
        system.debug('@@THIS' + this.criteriaSetInfoListVol);
    }
    
    public void setCriteriaThresholdVol(Map<Id, EUR_CRM_Criteria_Threshold__c> criteriaThresholdsVol)
    {
        this.criteriaThresholdsVol = criteriaThresholdsVol;
    }
    public void setCriteriaAnswersVol(Map<Id, List<EUR_CRM_Criteria_Answer__c>> criteriaAnswersVol)
    {
        this.criteriaAnswersVol = criteriaAnswersVol;
    }
    public void setAnswersVol(List<EUR_CRM_Criteria_Answer__c> answersListVol)
    {
        this.answersListVol = answersListVol;
    }
    
    //Image Level
    public Map<Id, EUR_CRM_Criteria_Threshold__c> getCriteriaThresholds()
    {   
        System.debug('Flag 2 getCriteriaSetInfo:'+criteriaSetInfoList);
        criteriaThresholds = new  Map<Id, EUR_CRM_Criteria_Threshold__c>();
        Set<Id> csIdImg = new Set<Id>();
        if (criteriaSetInfoList !=null)
        {
                for (EUR_CRM_Criteria_Set__c cs:criteriaSetInfoList){
                    csIdImg.add(cs.Id);
                }  
                criteriaThresholdsList = [SELECT Id, RecordTypeId,
                                    EUR_CRM_Question__c, EUR_CRM_Weight__c,
                                    EUR_CRM_Criteria_Order__c
                                    FROM EUR_CRM_Criteria_Threshold__c 
                                    WHERE EUR_CRM_Criteria_Set__r.Id=:csIdImg
                                    ORDER BY EUR_CRM_Criteria_Order__c, CreatedDate];
                                    
            for (EUR_CRM_Criteria_Threshold__c ct: criteriaThresholdsList) {
                criteriaThresholds.put(ct.Id, ct);
            }
        }
        System.debug('getCriteriaThresholds:'+criteriaThresholds);
        return criteriaThresholds;
    }
    
    //Volume Potential
    public Map<Id, EUR_CRM_Criteria_Threshold__c> getCriteriaThresholdsVol()
    {   
        System.debug('Flag 2 getCriteriaSetInfo:'+criteriaSetInfoList);
        criteriaThresholdsVol = new  Map<Id, EUR_CRM_Criteria_Threshold__c>();
        Set<Id> csIdVol = new Set<Id>();
        if (criteriaSetInfoListVol !=null)
        {
                for (EUR_CRM_Criteria_Set__c cs:criteriaSetInfoListVol){
                    csIdVol.add(cs.Id);
                }  
                criteriaThresholdsListVol = [SELECT Id, RecordTypeId,
                                    EUR_CRM_Question__c, EUR_CRM_Weight__c,
                                    EUR_CRM_Criteria_Order__c
                                    FROM EUR_CRM_Criteria_Threshold__c 
                                    WHERE EUR_CRM_Criteria_Set__r.Id=:csIdVol
                                    ORDER BY EUR_CRM_Criteria_Order__c, CreatedDate];
                                    
            for (EUR_CRM_Criteria_Threshold__c ct: criteriaThresholdsListVol) {
                criteriaThresholdsVol.put(ct.Id, ct);
            }
        }
        System.debug('getCriteriaThresholdsVol:'+criteriaThresholdsVol);
        return criteriaThresholdsVol;
    }
    
    //Image Level
    public List<EUR_CRM_Criteria_Answer__c> getAnswers()
    {
        System.debug('Flag 2 getCriteriaThresholds:'+criteriaThresholds.keyset());
        answersList = new List<EUR_CRM_Criteria_Answer__c>();
        if (criteriaThresholds.size()>0)
        {
            answersList = [SELECT Id, RecordTypeId,
                        EUR_CRM_Value__c, 
                        EUR_CRM_Base_Currency__c, EUR_CRM_Base_Integer__c,
                        EUR_CRM_Condition__c, EUR_CRM_Criteria_Threshold__r.Id,
                        EUR_CRM_Label__c, EUR_CRM_Weight__c
                        FROM EUR_CRM_Criteria_Answer__c 
                        WHERE EUR_CRM_Criteria_Threshold__r.Id in: criteriaThresholds.keySet()];
         }
        System.debug('getAnswers:'+answersList);
        return answersList;
    }
    //Volume Potential 
    public List<EUR_CRM_Criteria_Answer__c> getAnswersVol()
    {
        System.debug('Flag 2 getCriteriaThresholds:'+criteriaThresholdsVol.keyset());
        answersListVol = new List<EUR_CRM_Criteria_Answer__c>();
        if (criteriaThresholdsVol.size()>0)
        {
            answersListVol = [SELECT Id, RecordTypeId,
                        EUR_CRM_Value__c, 
                        EUR_CRM_Base_Currency__c, EUR_CRM_Base_Integer__c,
                        EUR_CRM_Condition__c, EUR_CRM_Criteria_Threshold__r.Id,
                        EUR_CRM_Label__c, EUR_CRM_Weight__c
                        FROM EUR_CRM_Criteria_Answer__c 
                        WHERE EUR_CRM_Criteria_Threshold__r.Id in: criteriaThresholdsVol.keySet()];
         }
        System.debug('getAnswersVol:'+answersListVol);
        return answersListVol;
    }
    
    //Image Level
    public Map<Id, List<EUR_CRM_Criteria_Answer__c>> getCriteriaAnswers()
    {
        System.debug('Flag 2 getAnswers:'+answersList);
        criteriaAnswers = new Map<Id, List<EUR_CRM_Criteria_Answer__c>>();
        if (answersList.size()>0)
        {
            for (EUR_CRM_Criteria_Answer__c ans: answersList){
                List<EUR_CRM_Criteria_Answer__c> criteriaAnsList = new List<EUR_CRM_Criteria_Answer__c>();
                if (criteriaAnswers.containsKey(ans.EUR_CRM_Criteria_Threshold__r.Id)){
                    criteriaAnsList = criteriaAnswers.get(ans.EUR_CRM_Criteria_Threshold__r.Id);
                }
                criteriaAnsList.add(ans);
                criteriaAnswers.put(ans.EUR_CRM_Criteria_Threshold__r.Id, criteriaAnsList);
            }
        }
        System.debug('getCriteriaAnswers:'+criteriaAnswers);
        return criteriaAnswers;
    }
    
    //Volume Potential criteriaAnswersVol
    public Map<Id, List<EUR_CRM_Criteria_Answer__c>> getCriteriaAnswersVol()
    {
        System.debug('Flag 2 getAnswers:'+answersListVol);
        criteriaAnswersVol = new Map<Id, List<EUR_CRM_Criteria_Answer__c>>();
        if (answersListVol.size()>0)
        {
            for (EUR_CRM_Criteria_Answer__c ans: answersListVol){
                List<EUR_CRM_Criteria_Answer__c> criteriaAnsList = new List<EUR_CRM_Criteria_Answer__c>();
                if (criteriaAnswersVol.containsKey(ans.EUR_CRM_Criteria_Threshold__r.Id)){
                    criteriaAnsList = criteriaAnswersVol.get(ans.EUR_CRM_Criteria_Threshold__r.Id);
                }
                criteriaAnsList.add(ans);
                criteriaAnswersVol.put(ans.EUR_CRM_Criteria_Threshold__r.Id, criteriaAnsList);
            }
        }
        System.debug('getCriteriaAnswersVol:'+criteriaAnswersVol);
        return criteriaAnswersVol;
    }
    //Image Level
    public Map<Id,  EUR_CRM_Pros_Image_Level__c> returnImageLevelMap(){
        //imageLevelMap = new Map<Id,  EUR_CRM_Pros_Image_Level__c>();
        
        if (prosSegIds != null)
        {
            List<EUR_CRM_Pros_Image_Level__c> prosImageLevels = [SELECT Id, EUR_CRM_Criteria_Threshold__r.Id, 
                            EUR_CRM_Weight__c, EUR_CRM_Answer__c
                            FROM EUR_CRM_Pros_Image_Level__c
                            WHERE EUR_CRM_Pros_Segmentation__c IN: prosSegIds];
                            
            for(EUR_CRM_Pros_Image_Level__c prosImageLevel: prosImageLevels)
            {
                imageLevelMap.put(prosImageLevel.EUR_CRM_Criteria_Threshold__r.Id, prosImageLevel);
                answerSheet.put(prosImageLevel.EUR_CRM_Criteria_Threshold__r.Id, (prosImageLevel.EUR_CRM_Answer__c==null)?'':prosImageLevel.EUR_CRM_Answer__c);
            }             
        }
            
        return imageLevelMap;
    }
    
    
    //Volume Potential
     public Map<Id,  EUR_CRM_Pros_Volume_Potential__c> returnVolumePotentialMap()
    {
        if (prosSegIds != null)
        {
            List<EUR_CRM_Pros_Volume_Potential__c> prosVolumePotentials = [SELECT Id, EUR_CRM_Criteria_Threshold__r.Id, 
                            EUR_CRM_Weight__c, EUR_CRM_Answer__c
                            FROM EUR_CRM_Pros_Volume_Potential__c
                            WHERE EUR_CRM_Pros_Segmentation__r.Id IN: prosSegIds];
                            
            for(EUR_CRM_Pros_Volume_Potential__c prosVolumePotential: prosVolumePotentials)
            {
                volumePotentialMap.put(prosVolumePotential.EUR_CRM_Criteria_Threshold__r.Id, prosVolumePotential);
                answerSheetVol.put(prosVolumePotential.EUR_CRM_Criteria_Threshold__r.Id, (prosVolumePotential.EUR_CRM_Answer__c==null)?'':prosVolumePotential.EUR_CRM_Answer__c);
            }    
        }
        System.debug('volumePotentialMap: ' + volumePotentialMap);
        return volumePotentialMap;
    }
    
    //Image Level
    public Map<Id, String>  returnAnswerSheet(){
        answerSheet = new Map<Id, String>();
        for (Id key : criteriaAnswers.keySet()){
            if (!answerSheet.containsKey(key)){
                answerSheet.put(key, '');
            }       
        }
        system.debug('answerSheet::' + answerSheet );
        return answerSheet;
    }
    
    //Volume Potential
    public Map<Id, String>  returnAnswerSheetVol(){
        answerSheetVol = new Map<Id, String>();
        for (Id key : criteriaAnswersVol.keySet()){
            if (!answerSheetVol.containsKey(key)){
                answerSheetVol.put(key, '');
            }       
        }
        
        system.debug('answerSheetVol::' + answerSheetVol );
        return answerSheetVol;
    }
    //Save Image Level
    private List<EUR_CRM_Pros_Image_Level__c> saveImageLevel(String key){
        system.debug('###KEY' + key);
        List<EUR_CRM_Pros_Image_Level__c> prosImgLvlList = new List<EUR_CRM_Pros_Image_Level__c>();
        
        for (EUR_CRM_Criteria_Threshold__c ctImg: criteriaThresholdsList) {
            caImgLvlSetIds.add(ctImg.Id);
        }
        system.debug('caImgLvlSetIds'+caImgLvlSetIds);
        
        prosImgLvlList = [Select Id, EUR_CRM_Answer__c, EUR_CRM_Pros_Segmentation__c, EUR_CRM_Criteria_Threshold__c from EUR_CRM_Pros_Image_Level__c
                             where EUR_CRM_Pros_Segmentation__c IN: prosSegIds
                                and EUR_CRM_Criteria_Threshold__c IN:caImgLvlSetIds];
                                
        system.debug('####prosImgLvlList' + prosImgLvlList);
        
        for (EUR_CRM_Pros_Image_Level__c prImg : prosImgLvlList){
            accountCriteria = new EUR_CRM_Pros_Image_Level__c();
            accountCriteria.EUR_CRM_Criteria_Threshold__c = key;
            accountCriteria.EUR_CRM_Answer__c = answerSheet.get(key);
            accountCriteria.EUR_CRM_Pros_Segmentation__c = prImg.EUR_CRM_Pros_Segmentation__c;
            
             
            Double answerWeight = mgr.newClassInstance(
                                    criteriaThresholds.get(key).RecordTypeId).calculateCriteria((Double)criteriaThresholds.get(key).EUR_CRM_Weight__c, 
                                    criteriaAnswers.get(key), 
                                    answerSheet.get(key));
        
            accountCriteria.EUR_CRM_Weight__c = answerWeight;
            accountCriteria.EUR_CRM_Is_Mass_Update__c = true;
        }        
        System.debug('Flag - On Save Criteria Threshold:' + criteriaThresholds.get(key).EUR_CRM_Question__c + '|' + answerSheet.get(key) + '|' + criteriaAnswers.get(key));
       
        this.newImageLevels.add(accountCriteria);
        system.debug('@@accountCriteria'+ accountCriteria);
        return prosImgLvlList;
    }
    
    //Save Volume Potential
    private List<EUR_CRM_Pros_Volume_Potential__c> saveVolumePotential(String key){
        system.debug('@@@@@@@@@VolKey::::' + key);
        List<EUR_CRM_Pros_Volume_Potential__c> prosVolPotentialList = new List<EUR_CRM_Pros_Volume_Potential__c>();
        
        for (EUR_CRM_Criteria_Threshold__c ctImg: criteriaThresholdsListVol) {
            caVolPotSetIds.add(ctImg.Id);
        }
        
        prosVolPotentialList = [Select Id, EUR_CRM_Answer__c, EUR_CRM_Pros_Segmentation__c, EUR_CRM_Criteria_Threshold__c from EUR_CRM_Pros_Volume_Potential__c
                                    where EUR_CRM_Pros_Segmentation__c IN: prosSegIds
                                        and EUR_CRM_Criteria_Threshold__c IN:caVolPotSetIds];                   
        
        system.debug('***prosVolPotentialList:' + prosVolPotentialList);
        for (EUR_CRM_Pros_Volume_Potential__c prVolP: prosVolPotentialList){
            accountCriteriaVolumePotential = new EUR_CRM_Pros_Volume_Potential__c();
            accountCriteriaVolumePotential.EUR_CRM_Criteria_Threshold__c = key;
            accountCriteriaVolumePotential.EUR_CRM_Answer__c = answerSheetVol.get(key);
            accountCriteriaVolumePotential.EUR_CRM_Pros_Segmentation__c = prVolP.EUR_CRM_Pros_Segmentation__c;
            
            Double answerWeight = mgr.newClassInstance(
            criteriaThresholdsVol.get(key).RecordTypeId).calculateCriteria((Double)criteriaThresholdsVol.get(key).EUR_CRM_Weight__c, 
            criteriaAnswersVol.get(key), 
            answerSheetVol.get(key)); 
            
            accountCriteriaVolumePotential.EUR_CRM_Weight__c = answerWeight;
            accountCriteriaVolumePotential.EUR_CRM_Is_Mass_Update__c = true;
        }   
        this.newVolumePotentials.add(accountCriteriaVolumePotential);
        
        return prosVolPotentialList;
    }
    
    public pageReference massUpdatePros(){
        PageReference pageRef = null;
        Database.Deleteresult[] deleteResults;
        //Database.Insertresult[] insertResults;
        System.Savepoint pSavepoint = Database.setSavepoint();
        Boolean isSaved = false;
        
        system.debug('answerSheet.keySet()' + answerSheet.keySet());

        for (String key: answerSheet.keySet()){
            if (criteriaThresholds.containsKey(key)){
                List<EUR_CRM_Pros_Image_Level__c> accountCriteria = saveImageLevel(key);
                //List<EUR_CRM_Pros_Volume_Potential__c> accountCriteriaVolPotential = saveVolumePotential(key);
                if (accountCriteria != null){
                    for (EUR_CRM_Pros_Image_Level__c x:accountCriteria){
                    //this.total += x.EUR_CRM_Weight__c;
                    }
                }
            }     
        }
        if (this.newImageLevels != null){
            
            List<EUR_CRM_Pros_Image_Level__c> queryIsMassUpdateProsImageLevelList = new List<EUR_CRM_Pros_Image_Level__c>();
            List<EUR_CRM_Pros_Image_Level__c> updateProsImageLevelList = new List<EUR_CRM_Pros_Image_Level__c>();
            queryIsMassUpdateProsImageLevelList = [Select Id, EUR_CRM_Is_Mass_Update__c, EUR_CRM_Pros_Segmentation__c from EUR_CRM_Pros_Image_Level__c 
                                            where EUR_CRM_Pros_Segmentation__c IN: prosSegIds and EUR_CRM_Is_Mass_Update__c = true];
            
            
            system.debug('@@queryIsMassUpdateProsImageLevelList' + queryIsMassUpdateProsImageLevelList.size());
            system.debug('@@queryIsMassUpdateProsImageLevelList' + queryIsMassUpdateProsImageLevelList);
            
            for(EUR_CRM_Pros_Image_Level__c x: queryIsMassUpdateProsImageLevelList){
                x.EUR_CRM_Is_Mass_Update__c = false;
                
                updateProsImageLevelList.add(x);
            }                               
            if (updateProsImageLevelList.size() > 0){
                update updateProsImageLevelList;
            }
            Database.insert(this.newImageLevels);
            isSaved = true; 
        }      
        System.debug('this.newImageLevels ' + this.newImageLevels.size());    
        
      
        if (isSaved){
            List<EUR_CRM_Pros_Image_Level__c> toDeleteProsImageLevelList = new List<EUR_CRM_Pros_Image_Level__c>();
            toDeleteProsImageLevelList = [Select Id, EUR_CRM_Is_Mass_Update__c, EUR_CRM_Pros_Segmentation__c from EUR_CRM_Pros_Image_Level__c 
                                            where EUR_CRM_Pros_Segmentation__c IN: prosSegIds and EUR_CRM_Is_Mass_Update__c = false];
            
            if (toDeleteProsImageLevelList.size() > 0){
                //delete toDeleteProsImageLevelList;
            }
            
            
            pageRef = new PageReference('/' + 'a9d?fcf=00BL0000000Qatw');  
            pageRef.setRedirect(true); 
        }
        
        massUpdateVol();
        return pageRef;
    }
    
    //Method for the mass update of Pros Seg - Volume Potentials
    public void massUpdateVol(){
        Boolean isMassUpdateVol = false;
        List<EUR_CRM_Pros_Volume_Potential__c> queryIsMassUpdateProsVolPotentialList = new List<EUR_CRM_Pros_Volume_Potential__c>();
        List<EUR_CRM_Pros_Volume_Potential__c> updateProsVolPotentialList = new List<EUR_CRM_Pros_Volume_Potential__c>();
        List<EUR_CRM_Pros_Volume_Potential__c> toDeleteProsVolPotentialList = new List<EUR_CRM_Pros_Volume_Potential__c>();
        
        for (String key: answerSheetVol.keySet()){
            if (criteriaThresholdsVol.containsKey(key)){
                //List<EUR_CRM_Pros_Image_Level__c> accountCriteria = saveImageLevel(key);
                List<EUR_CRM_Pros_Volume_Potential__c> accountCriteriaVolPotential = saveVolumePotential(key);
                if (accountCriteriaVolPotential != null){
                    for (EUR_CRM_Pros_Volume_Potential__c x:accountCriteriaVolPotential){
                    //this.total += x.EUR_CRM_Weight__c;
                    }
                }
            }     
        }
        system.debug('%%%this.newVolumePotentials' + this.newVolumePotentials);
        
        if (this.newVolumePotentials != null){
            
            queryIsMassUpdateProsVolPotentialList = [Select Id, EUR_CRM_Is_Mass_Update__c, EUR_CRM_Pros_Segmentation__c from EUR_CRM_Pros_Volume_Potential__c 
                                                        where EUR_CRM_Pros_Segmentation__c IN: prosSegIds and EUR_CRM_Is_Mass_Update__c = true];
            
            for (EUR_CRM_Pros_Volume_Potential__c x:queryIsMassUpdateProsVolPotentialList){
                x.EUR_CRM_Is_Mass_Update__c = false;
                
                updateProsVolPotentialList.add(x);  
            }
            
            if (updateProsVolPotentialList.size() > 0){
                update updateProsVolPotentialList;
            }
            
            if (this.newVolumePotentials != null){
                Database.insert(this.newVolumePotentials);  
                isMassUpdateVol = true;
            }
        }
        
        if (isMassUpdateVol){
            toDeleteProsVolPotentialList = [Select Id, EUR_CRM_Is_Mass_Update__c, EUR_CRM_Pros_Segmentation__c from EUR_CRM_Pros_Volume_Potential__c
                                                        where EUR_CRM_Pros_Segmentation__c IN: prosSegIds and EUR_CRM_Is_Mass_Update__c = false];
            
            if (toDeleteProsVolPotentialList.size() > 0){
                //delete toDeleteProsVolPotentialList;
            }                                           
        }   
       system.debug('%%%this.newVolumePotentials' + this.newVolumePotentials);
        
    }
    
    public integer getRecordSize() {
        if (objs!=null) {
            return objs.size();
        }else{
            return 0;
        }
    }
    public DescribeSObjectResult discoverSObjectType(SObject s) {
        Map<String, Schema.SObjectType> des = Schema.getGlobalDescribe();
            
        for(Schema.SObjectType o:des.values()) {
            if( s.getSObjectType()==o) {
                return o.getDescribe();
            }     
        }
        return null;
    }
   */
}