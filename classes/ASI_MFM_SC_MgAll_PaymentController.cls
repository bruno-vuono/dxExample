public class ASI_MFM_SC_MgAll_PaymentController {
    
    public class OtherException extends Exception {}
    
    public static String PAYMENT_LINE_TABLE_PREFIX {get{ return 'PaymentLineItemTable_';}}
    public static String PAYMENT_LINE_ITEM_NEWRECORD_PREFIX {get{ return 'zzzzzzPaymentNEWZ';}}
    
    public Integer PAYMENT_LINE_ITEM_NEWRECORD_COUNTER {get;set;}
    public ID headerID {get;set;}
    public ASI_MFM_Payment__c header {get;set;}
    public Map<String, paymentLineWrapper> allPaymentLineMap {get;set;}{allPaymentLineMap = new Map<String, paymentLineWrapper>();}
    
    public boolean isReadOnlyView {get;set;}
    public boolean isFinanceOnlyView {get;set;}
    
    public List<ASI_MFM_Payment_Line_Item__c> paymentLinesToDelete {get;set;}
    
    public List<SelectOption> acSelectionList {get;set;}{acSelectionList = new List<SelectOption>();}
    public List<SelectOption> apSelectionList {get;set;}{apSelectionList = new List<SelectOption>();}
    public List<SelectOption> buSelectionList {get;set;}{buSelectionList = new List<SelectOption>();}
    
    public boolean isAllNull {get;set;}
    public boolean isPaymentAmountNull {get;set;}
    public boolean isQtyxVapAmountNotPayment {get;set;}
    public boolean isWarnisAllNull {get;set;}
    public boolean isWarnisPaymentAmountNull {get;set;}
    public boolean isWarnisQtyxVapAmountNotPayment {get;set;}
    public Map<ID, ASI_MFM_A_C_Code__c> acCodeMap {get;set;}
    public Map<ID, ASI_MFM_AP_Code__c> apCodeMap {get;set;}
    public Map<ID, ASI_MFM_BU__c> buCodeMap {get;set;}
    public Map<ID, ID> apcCMap {get;set;}
    public String JsonMap{get;set;} 

    private String defaultBUId = '',defaultAPId = '',defaultACId = '';
    
    public ASI_MFM_SC_MgAll_PaymentController(ApexPages.StandardController stdCon) {
        
        this.isAllNull = false;
        this.isPaymentAmountNull = false;
        this.isQtyxVapAmountNotPayment = false;
        this.isWarnisAllNull = false;
        this.isWarnisPaymentAmountNull = false;
        this.isWarnisQtyxVapAmountNotPayment = false;
        this.acCodeMap = new Map<ID, ASI_MFM_A_C_Code__c>();
        this.apCodeMap = new Map<ID, ASI_MFM_AP_Code__c>();
        this.buCodeMap = new Map<ID, ASI_MFM_BU__c>();
        this.apcCMap = new Map<ID, ID>();
        
        this.headerId = ApexPages.currentPage().getParameters().get('id');
        header = ((List<ASI_MFM_Payment__c>)queryAll(this.headerId, 'ASI_MFM_Payment__c', 'ID', '')).get(0);
        
        paymentLinesToDelete = new List<ASI_MFM_Payment_Line_Item__c>();
        
        String customSettingName = 'SC_BU_' + header.ASI_MFM_Company_Code__c;
        
        List<Id> buidList= new List<Id> ();  
        List<asi_mfm_po_line_item__c> pos=[select asi_mfm_bu_code__c from asi_mfm_po_line_item__c where asi_mfm_po__c = :header.asi_mfm_po__c];
        
        for(asi_mfm_po_line_item__c po :pos){
            buidList.add(po.asi_mfm_bu_code__c);
        }
            
                
        boolean IsOpex= false;
        if(header.ASI_MFM_Payment_Type__c!=null && header.ASI_MFM_Payment_Type__c.equalsIgnoreCase('OPEX'))
            IsOpex= true;

        //List<ASI_MFM_Default_Value__c> mfmDefault_PaymentTypeList = [SELECT Name, Country__c, ASI_MFM_Value__c, ASI_MFM_Object__c FROM ASI_MFM_Default_Value__c WHERE Country__c = 'HK' AND Name = :customSettingName AND ASI_MFM_Object__c = 'ASI_MFM_Payment_Line_Item__c'];

        //Retrieve all existing Payment Lines
        List<ASI_MFM_Payment_Line_Item__c> paymentLineList = (List<ASI_MFM_Payment_Line_Item__c>)queryAll(header.id, ' ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c, ', 'ASI_MFM_Payment_Line_Item__c', 'ASI_MFM_Payment__c', '');
        
        List<ASI_MFM_BU__c> buList = [SELECT Id, Name FROM ASI_MFM_BU__c WHERE ASI_MFM_Inactive__c = false and recordtype.developername = 'ASI_MFM_SC_BU' and id in :buidList order by Name desc];
        List<ASI_MFM_A_C_Code__c> acList = [SELECT Id, Name FROM ASI_MFM_A_C_Code__c WHERE RecordType.DeveloperName = 'ASI_MFM_SC_A_C_Code' ORDER BY ASI_MFM_A_C_Code__c DESC];
        List<ASI_MFM_AP_Code__c> apList = [SELECT Id, Name,asi_mfm_sc_Need_Subleger__c , ASI_MFM_A_C_Code__c FROM ASI_MFM_AP_Code__c WHERE RecordType.DeveloperName = 'ASI_MFM_SC_AP_Code' AND ASI_MFM_Inactive__c = false ORDER BY ASI_MFM_AP_Code__c DESC];
               
        acSelectionList.add(new SelectOption('', ''));
        
        for(ASI_MFM_A_C_Code__c ac : acList){
            acCodeMap.put(ac.id, ac);
            acSelectionList.add(new SelectOption(ac.Id, ac.Name));
        }
        
        for(ASI_MFM_AP_Code__c ap : apList){
            apCodeMap.put(ap.id, ap);
            apSelectionList.add(new SelectOption(ap.Id , ap.Name));
            apcCMap.put(ap.ID,ap.ASI_MFM_A_C_Code__c);
            
        }
        
        JsonMap=JSON.serialize(apcCMap);
        
        for(ASI_MFM_BU__c bu : buList){
            buCodeMap.put(bu.id, bu);
            buSelectionList.add(new SelectOption(bu.Id, bu.Name));
        }
        
        
        defaultBUId = buList!=null && buList.size() > 0 ? buList.get(0).Id: null;
        defaultAPId = apList !=null && apList .size() > 0 ? apList .get(0).Id: null;
        defaultACId = apList !=null && apList .size() > 0 ? apcCMap.get(apList .get(0).Id): null;

        for(ASI_MFM_Payment_Line_Item__c paymentLine : paymentLineList) {
            if(!String.isNotBlank(paymentLine.ASI_MFM_BU__c)) {
                paymentLine.ASI_MFM_BU__c = defaultBUId;
            }
            paymentLineWrapper paymentLineItemWrap = new paymentLineWrapper(paymentLine, acSelectionList, apSelectionList,buSelectionList);
            allPaymentLineMap.put((String)paymentLine.id, paymentLineItemWrap);
        }

        if(header.ASI_MFM_Status__c != 'Draft') {
            this.isReadOnlyView = true; 
        } else {
           this.isReadOnlyView = false; 
        }

        boolean isFinanceGroup = retrieveFinanceState('ASI_MFM_SC_Finance');
        this.isFinanceOnlyView = isFinanceGroup && isReadOnlyView;
        
    }

    private Boolean retrieveFinanceState(String pGroupDevName){
        String userId = UserInfo.getUserId();
        Boolean financeView = false;
        List<Group> publicGroup = new List<Group>();
        publicGroup = [Select Id, DeveloperName From Group Where DeveloperName =: pGroupDevName];
        if(publicGroup.size() > 0){
            for(GroupMember grpM :[Select Id, UserOrGroupId From GroupMember Where GroupId =: publicGroup[0].Id]){
                if(grpM.UserOrGroupId == userId){
                    financeView = true;
                }
            }
        }
        return financeView;
    }

    private List<sObject> queryAll(ID filterID, String extraFieldQuery, String sObjectName, String filteringField, String extraQuery) {
    
        List<sObject> sObjectList = new List<sObject>();
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
        Schema.sObjectType sObjType = globalDescription.get(sObjectName);  
        Schema.DescribeSObjectResult r1 = sObjType.getDescribe();  
        
        Map<String, Schema.SObjectField> sObjectFieldMap = r1.fields.getMap();
        String theQuery = 'Select ' + extraFieldQuery;
        
        for(String fields  : sObjectFieldMap.keySet()){
            theQuery += fields + ' ,';
        }
        thequery = theQuery.subString(0,theQuery.length()-1);
        thequery +=' , recordtype.developername From '+sObjectName+' where '+filteringField+' = \''+ filterID + '\' ' + extraQuery;
                
        sObjectList = Database.query(theQuery);
        
        return sObjectList;
    }

    private List<sObject> queryAll(ID filterID, String sObjectName, String filteringField, String extraQuery) {
    
        return queryAll( filterID, '',  sObjectName,  filteringField,  extraQuery) ;
    }
    
    public PageReference savePayment () {
        Pagereference ref;
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String isQuickSaveStr = params.get('IS_QUICK_SAVE');
        System.debug('Flag - Save Payment - isQuickSave:' + isQuickSaveStr);
        Boolean isQuickSave = (isQuickSaveStr==null)?false:Boolean.valueOf(isQuickSaveStr);
        
        Database.upsertResult[] upsertTarget;
        Database.deleteResult[] deleteTarget;

        Savepoint sp = Database.setSavepoint();
        try {
            user u = [select userRole.developerName, asi_mfm_country__c from user where id = :userInfo.getUserId()];
            
            Set<ID> poHeaderToDeleteSet = new Set<ID>();
            List<ASI_MFM_PO__c> poHeaderToDeleteList = new List<ASI_MFM_PO__c>();
            
            for(ASI_MFM_Payment_Line_Item__c paymentLine : paymentLinesToDelete) {
                poHeaderToDeleteSet.add(paymentLine.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__c);
            }

            for(ID poHeaderID : poHeaderToDeleteSet) {
                ASI_MFM_PO__c poHeader = new ASI_MFM_PO__c(ID = poHeaderID);
                poHeaderToDeleteList.add(poHeader);
            }

            if(paymentLinesToDelete.size()>0){
                deleteTarget = Database.delete(paymentLinesToDelete);
                delete poHeaderToDeleteList;
            }

            List<ASI_MFM_Payment_Line_Item__c> upsertTargetList = new List<ASI_MFM_Payment_Line_Item__c>();
                        
            List<String> sortMapKey = new List<String>();
            for(String key : allPaymentLineMap.keySet()) {
                sortMapKey.add(key);
            }
            
            sortMapKey.sort();
            Boolean isError = false;
            for(String key : sortMapKey){
                ASI_MFM_Payment_Line_Item__c paymentLineItem = allPaymentLineMap.get(key).paymentLineItem;
                                
                if(apCodeMap.get(paymentLineItem.asi_mfm_ap_code__c).asi_mfm_sc_Need_Subleger__c!=null && apCodeMap.get(paymentLineItem.asi_mfm_ap_code__c).asi_mfm_sc_Need_Subleger__c){
                    if(paymentLineItem.asi_mfm_sc_Subledger__c==null){
                       throw new OtherException('Subledger must be fill in as AP code required');
                    }
                }
                
                if(paymentLineItem.ASI_MFM_A_C_Code__c==null){
                    paymentLineItem.ASI_MFM_A_C_Code__c=apcCMap.get(paymentLineItem.asi_mfm_ap_code__c);
                }
                
                                
                upsertTargetList.add(paymentLineItem);
            }
            
            if(isError) {
                upsertTargetList.clear();
                return null;
            }
                
            if(upsertTargetList.size()>0)
                upsertTarget = Database.upsert(upsertTargetList);

        }
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Fatal,ex.getMessage()));
            Database.rollback(sp);
            return null;
        }
        
        if (!isQuickSave){
            ref = new PageReference('/'+header.Id);
            ref.setRedirect(true);
        }
        else {
            isAllNull = false;
            isPaymentAmountNull = false;
            isQtyxVapAmountNotPayment = false;
        }
        return ref;
    }
    
    public void addPaymentLine () {
        
        string newIDCounter = newCounterCreator();
        ASI_MFM_Payment_Line_Item__c newPaymentLine = new ASI_MFM_Payment_Line_Item__c
                                    (
                                        recordtypeid = Global_RecordTypeCache.getRTId('ASI_MFM_Payment_Line_Item__cASI_MFM_SC_Payment_Line_Item'),
                                        ASI_MFM_Payment__c = header.id,
                                        ASI_MFM_BU__c = defaultBUId,
                                        ASI_MFM_AP_Code__c = defaultAPId,
                                        ASI_MFM_A_C_Code__c = defaultACId
                                    );
        paymentLineWrapper paymentLineWrap = new paymentLineWrapper(newPaymentLine, acSelectionList, apSelectionList,buSelectionList);
        allPaymentLineMap.put(PAYMENT_LINE_ITEM_NEWRECORD_PREFIX+newIDCounter, paymentLineWrap);
        
    }
    
    public void clonePaymentLine () {

        string newIDCounter = newCounterCreator();
    
        PageReference pageRef = null;
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_paymentLineID = params.get('PARAM_Payment_SOURCE_ITEM_ID');
        
        if (allPaymentLineMap.containsKey(param_paymentLineID)) {
        
            ASI_MFM_Payment_Line_Item__c PaymentLine = allPaymentLineMap.get(param_paymentLineID).paymentLineItem;
            ASI_MFM_Payment_Line_Item__c paymentLineClone = null;
            
            paymentLineClone = PaymentLine.clone(false, true, false, false);
            
            paymentLineWrapper paymentLineWrap = new paymentLineWrapper(paymentLineClone, acSelectionList, apSelectionList,buSelectionList);
            allPaymentLineMap.put(PAYMENT_LINE_ITEM_NEWRECORD_PREFIX+newIDCounter, paymentLineWrap);
        }
        
    }
    
    public void removePaymentLine () {
        PageReference pageRef = null;
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String param_paymentLineID = params.get('PARAM_PAYMENT_LINE_ID');
        
        if (allPaymentLineMap.containsKey(param_paymentLineID)) {
            ASI_MFM_Payment_Line_Item__c PaymentLine = allPaymentLineMap.get(param_paymentLineID).paymentLineItem;
            allPaymentLineMap.remove(param_paymentLineID);
            if(!param_paymentLineID.contains(PAYMENT_LINE_ITEM_NEWRECORD_PREFIX)) {
                paymentLinesToDelete.add(PaymentLine);
            }
        }
        
    }
    
    public String newCounterCreator() {
    
        String idNew;
        IF(PAYMENT_LINE_ITEM_NEWRECORD_COUNTER == null) {
            PAYMENT_LINE_ITEM_NEWRECORD_COUNTER = 0;
        }
        else {
            PAYMENT_LINE_ITEM_NEWRECORD_COUNTER+=1;
        }
        
        String zParser = '';
        Integer oneDigitCounter = PAYMENT_LINE_ITEM_NEWRECORD_COUNTER;
        
        if(PAYMENT_LINE_ITEM_NEWRECORD_COUNTER > 9) {
            Integer zNumber = PAYMENT_LINE_ITEM_NEWRECORD_COUNTER/10;
            for (Integer i = 0; i < zNumber; i++) {
                zParser += 'z';
            }
            oneDigitCounter = Math.mod(PAYMENT_LINE_ITEM_NEWRECORD_COUNTER, 10);
        }
        
        idNew = zParser + string.valueof(oneDigitCounter);
        return idNew;
        
    }
    
    public PageReference cancel() {
        Pagereference ref;
        ref = new PageReference('/'+header.Id);
        ref.setRedirect(true);
        return ref;
    }
    
    public void updateACPick() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String acChoice = params.get('ACChoice');
        String cpiKey = params.get('cpiKey');

        if(allPaymentLineMap.containsKey(cpiKey)){
            paymentLineWrapper paymentLineWrap = allPaymentLineMap.get(cpiKey);
            paymentLineWrap.ACSelected = acChoice;
            paymentLineWrap.updateAC();
        }
    }
    
    public PageReference updateAPPick() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String apChoice = params.get('APChoice');
        String cpiKey = params.get('cpiKey');

        if(allPaymentLineMap.containsKey(cpiKey)){
            paymentLineWrapper paymentLineWrap = allPaymentLineMap.get(cpiKey);     
            paymentLineWrap.APSelected = apChoice;
            paymentLineWrap.ACSelected = apCodeMap.get(apChoice).ASI_MFM_A_C_Code__c;
  
            paymentLineWrap.updateAP();
        }
        
        return null;
    }
    
    public void updateBUPick() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String buChoice = params.get('BUChoice');
        String cpiKey = params.get('cpiKey');

        if(allPaymentLineMap.containsKey(cpiKey)){
            paymentLineWrapper paymentLineWrap = allPaymentLineMap.get(cpiKey);     
            paymentLineWrap.BUSelected = buChoice;
            paymentLineWrap.updateBU();
        }
    }
    
    /*********************************
    Payment Line Wrapper
    *********************************/
    public class paymentLineWrapper {
        public ASI_MFM_Payment_Line_Item__c paymentLineItem {get;set;}
        public List<SelectOption> ACSelectOption {get;set;}
        public List<SelectOption> APSelectOption {get;set;}
        public List<SelectOption> BUSelectOption {get;set;}
        public String ACSelected {get;set;}
        public String APSelected {get;set;}
        public String BUSelected {get;set;}

        public paymentLineWrapper (ASI_MFM_Payment_Line_Item__c paymentLine, List<SelectOption> ACSelectOptionP,List<SelectOption> APSelectOptionP,List<SelectOption> BUSelectOptionP) {
            this.ACSelectOption = ACSelectOptionP;
            this.APSelectOption = APSelectOptionP;
            this.BUSelectOption = BUSelectOptionP;
            this.paymentLineItem = paymentLine;
            this.ACSelected = (String)paymentLineItem.ASI_MFM_A_C_Code__c;
            this.APSelected = (String)paymentLineItem.ASI_MFM_AP_Code__c;
            this.BUSelected = (String)paymentLineItem.ASI_MFM_BU__c;
        }
        
        public void updateAC() {
            this.paymentLineItem.ASI_MFM_A_C_Code__c = (ACSelected != null && ACSelected != '' ) ? (ID)ACSelected : null;
        }
        
        public void updateAP() {
            this.paymentLineItem.ASI_MFM_AP_Code__c = (APSelected != null && APSelected != '' ) ? (ID)APSelected : null;
            this.paymentLineItem.ASI_MFM_A_C_Code__c = (ACSelected != null && ACSelected != '' ) ? (ID)ACSelected : null;
        }
        
        public void updateBU() {
            this.paymentLineItem.ASI_MFM_BU__c = (BUSelected != null && BUSelected != '' ) ? (ID)BUSelected : null;
        }

    }
      
}