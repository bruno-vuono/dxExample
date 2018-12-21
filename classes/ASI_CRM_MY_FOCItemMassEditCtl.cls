public with sharing class ASI_CRM_MY_FOCItemMassEditCtl{
    public List<SelectOption> ContractSetupCodeValue {get; set;} {ContractSetupCodeValue = ASI_CRM_MY_Function.getContractSetupCodeValue();}
    public string pid;
    public ASI_FOC_Free_Goods_Request__c FOC {get; set;}
    
    //for Paging
    private integer counter  = 0;  //keeps track of the offset
    private integer pageSize = 50;
    public boolean disablePrevious {set;get;}
    public boolean disableNext {set;get;}
    public string recordNumberDisplay {get;set;} //show current no out of total no.
    public boolean isEdit {get;set;}
    {isEdit = true;}
    
    /*
    public boolean isEdit 
    { 
        get{
            return isEdit;
        }
     	set{
            isEdit = true;
        } 
    } 
	*/

    public List <ASI_FOC_Request_Item__c> delItemList = new List <ASI_FOC_Request_Item__c>();
    
    //for search()
    public integer intTotalSize;
    public String  strQuery;
    
    //for result List
    public Class interimData{
        public String id{ 
            get{
                if(String.isBlank(id)){
                    return null;
                }
                return id;
            } 
            set;
        }
        public Boolean selected {get; set;}{selected = false;}
        public ASI_FOC_Request_Item__c ppl {get; set;}
    }
    
    //for Record Type
    public ID ItemRecTypeID = Global_RecordTypeCache.getRtId('ASI_FOC_Request_Item__cASI_FOC_MY_RequestItem');
    
    //for VF
    public boolean allSelected {get; set;}
    public List<interimData> results {get; set;}
    public string strPageID {get; set;} {strPageID = 'ERROR';}
    public boolean modified = FALSE;
    public string modifiedVF {get; set;} {modifiedVF = 'N';}
    
    
    public ASI_CRM_MY_FOCItemMassEditCtl(ApexPages.StandardController controller){
    }
	

    public ASI_CRM_MY_FOCItemMassEditCtl(ApexPages.StandardSetController controller){
        pid = apexpages.currentPage().getParameters().get('id');
        List <ASI_FOC_Free_Goods_Request__c> lstFOC = [
            SELECT id, name, ASI_FOC_Date_of_Delivery__c, ASI_CRM_Contract__c,
                   ASI_CRM_JDE_SO_Number__c
            FROM ASI_FOC_Free_Goods_Request__c
            WHERE id = :pid
        ];
        FOC = lstFOC[0];
        system.debug(FOC);
        results = new List<interimData>();
        search();
    }
   
    public void search(){
        intTotalSize = Database.countquery('SELECT COUNT() FROM ASI_FOC_Request_Item__c WHERE ASI_FOC_Request_Order__c = :pid');         
        results = new List<interimData>();
        counter = 0;
        
        if (intTotalSize > 0){
            strQuery  = 'SELECT id, Name, ASI_FOC_SKU__c, ASI_FOC_Issued_Qty__c,';
            strQuery +=' ASI_CRM_SetupCode__c, ASI_CRM_GLReasonCode__c,';
            strQuery +=' ASI_FOC_Request_Order__r.ASI_CRM_Auto_Generation__c,';
            strQuery +=' ASI_CRM_JDECOA__c, ASI_FOC_Remark__c';
            strQuery +=' FROM ASI_FOC_Request_Item__c';
            strQuery +=' WHERE ASI_FOC_Request_Order__c = :pid'; 
                          
            searchCurrentPage();
        }else{
            results = new List<interimData>();
            disablePrevious = true;
            disableNext = true;
        }                
    }
    
    public void searchCurrentPage(){
        try{
            results = new List<interimData>();
             
            System.debug('strQuery :' + strQuery + ' LIMIT ' + String.valueOf(pageSize) + ' OFFSET '+ String.valueof(counter));
            
            disablePrevious = getDisablePrevious();
            disableNext = getDisableNext();
            recordNumberDisplay = '(' + String.valueOf(counter + 1)+ ' - ' + String.valueOf(intTotalSize > counter + pageSize? (counter + pageSize) : intTotalSize) + ' of ' + String.valueOf(intTotalSize) + ')';
            
            List<ASI_FOC_Request_Item__c> lstFOCLineItem = Database.query(strQuery + ' LIMIT ' + String.valueOf(pageSize) + ' OFFSET '+ String.valueof(counter));

            for (ASI_FOC_Request_Item__c itm: lstFOCLineItem){
                interimData FOCLineItem_O = new interimData();
                
                boolean isAutoGen = itm.ASI_FOC_Request_Order__r.ASI_CRM_Auto_Generation__c;
                id recordTypeId = itm.ASI_FOC_Request_Order__r.RecordTypeId;
                id read_only_recordTypeId = Global_RecordTypeCache.getRTId('ASI_FOC_Free_Goods_Request__cASI_FOC_MY_FreeGoodsRequest_Read_Only');
                // read-only
                boolean isReadOnly = (recordTypeId == read_only_recordTypeId) ? true : false;
                
                isEdit = (isAutoGen || isReadOnly) ? false : true;
                
                FOCLineItem_O.ppl = itm;
                FOCLineItem_O.selected = false;
                results.add(FOCLineItem_O);      
            }                      
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }// END of function searchCurrentPage
    
    public void ADDNEW(){
        modified = TRUE;
        
        if (results != null && results.size() > 0){
            interimData FOCLineItem_O= new interimData();
            FOCLineItem_O.ppl = new ASI_FOC_Request_Item__c(ASI_FOC_Request_Order__c = FOC.id);
            FOCLineItem_O.selected = false;
            results.add(0,FOCLineItem_O);   
        }else{
            results = new List<interimData>();
            interimData FOCLineItem_O= new interimData ();
            FOCLineItem_O.ppl = new ASI_FOC_Request_Item__c(ASI_FOC_Request_Order__c = FOC.id);
            FOCLineItem_O.selected = false;
            results.add(FOCLineItem_O);  
        }
    }// END of function ADDNEW
    
    
    public PageReference CLONESELECTED(){
        modified = TRUE;
        
        interimData selected_rpl;
        Boolean isSelected = false;
        List<interimData> cloneList = new List<interimData>();
        
        for(interimData rpl : results){
            if(Test.isRunningTest())
            	rpl.selected = TRUE;
            if(rpl.selected){
                selected_rpl = new interimData();
                selected_rpl.selected = true;
                selected_rpl.ppl = new ASI_FOC_Request_Item__c();
                selected_rpl.ppl.ASI_FOC_SKU__c              = rpl.ppl.ASI_FOC_SKU__c;
                selected_rpl.ppl.ASI_FOC_Issued_Qty__c       = rpl.ppl.ASI_FOC_Issued_Qty__c;
                selected_rpl.ppl.ASI_CRM_SetupCode__c        = rpl.ppl.ASI_CRM_SetupCode__c;
                selected_rpl.ppl.ASI_CRM_GLReasonCode__c     = rpl.ppl.ASI_CRM_GLReasonCode__c;
                selected_rpl.ppl.ASI_CRM_JDECOA__c           = rpl.ppl.ASI_CRM_JDECOA__c;
                selected_rpl.ppl.ASI_FOC_Remark__c           = rpl.ppl.ASI_FOC_Remark__c;
                selected_rpl.ppl.ASI_FOC_Request_Order__c    = FOC.id;
                cloneList.add(selected_rpl);
            }
         }
         for(interimData  i : cloneList)
             results.add(0, i);
         //results.addall(cloneList);
         return null;
    }// END of function CLONESELECTED
    
    public PageReference DELETESELECTED(){
        modified = TRUE;
        
        interimData selected_rpl;
        integer i = 0;
        integer c = 0;
        List <integer> temp_index = new List <integer>();
        
        for(interimData r : results){  
            if(Test.isRunningTest())
            	r.selected = TRUE;
            if(r.selected){
                temp_index.add(i);
                 if(r.ppl.id != null)
                    delItemList.add(r.ppl);
            }
            i++;
        }
        system.debug(temp_index);
        
        for(integer n : temp_index){
            if(n!=0){
                if(c>0) n=n-c;
                results.remove(n);
                c++;
            }else{
                results.remove(0);
                c++;
            }
        }
        
        return null;
    }
    
    public PageReference BEGINNING(){
        counter = 0;
        if(modified || modifiedVF == 'Y'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please save your changes before navigating to next pages.'));
            return null;
        }
        searchCurrentPage();
        return null;
    }
    
    public PageReference PREVIOUS(){
        counter -= pageSize;
        if(modified || modifiedVF == 'Y'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please save your changes before navigating to next pages.'));
            return null;
        }
        searchCurrentPage();
        return null;
    }
    
    public PageReference NEXT(){
        counter += pageSize;
        if(counter >= 1000){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum no. of search result (1000 records) reached! Please narrow down your search range.'));
            return null;
        }
        if(modified || modifiedVF == 'Y'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please save your changes before navigating to next pages.'));
            return null;
        }
        searchCurrentPage();
        return null;
    }
    
    public PageReference END(){
        counter = intTotalSize - pageSize;    
        if(counter >= 1000){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum no. of search result (1000 records) reached! Please narrow down your search range.'));
            return null;
        }
        if(modified || modifiedVF == 'Y'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please save your changes before navigating to next pages.'));
            return null;
        }
        searchCurrentPage();
        return null;
    }
    
    public Boolean getDisablePrevious(){ 
        //this will disable the previous and beginning buttons
        if(counter > 0) 
            disablePrevious = false;
        else 
            disablePrevious = true;
        return disablePrevious;
    }
    
    public Boolean getDisableNext(){
        //this will disable the next and end buttons
        if (counter + pageSize < intTotalSize) 
            disableNext = false; 
        else 
            disableNext = true;
        return disableNext;
    }
    
    public boolean onCommitted(){
        if(results == null) return false;
        boolean isBlanked = true;  
        for(interimData rpl : results){
            if(Test.isRunningTest())
            	rpl.selected = TRUE;
             if(rpl.selected){
                 if(rpl.ppl.ASI_FOC_SKU__c== null){
                    rpl.ppl.ASI_FOC_SKU__c.addError('Required field.');
                    isBlanked = false;
                 }
             }
        }
        return isBlanked;
    }
    
    public PageReference SAVE(){
        if(addItem()){ //add error checking later
            strPageID = (String)FOC.id;
        }
        return null;
    }
    
    public PageReference QUICKSAVE(){
        if(addItem()){ //add error checking later
            modified = FALSE;
            modifiedVF = 'N';
        }
        return null;
    }
    
    public boolean addItem(){
        System.Savepoint sp = database.setSavepoint();
        List<ASI_FOC_Request_Item__c> saveItemList = new List<ASI_FOC_Request_Item__c>();
        
        for(interimData r : results){
                ASI_FOC_Request_Item__c ppl = new ASI_FOC_Request_Item__c();
                ppl = r.ppl;
                //ppl.ASI_FOC_Request_Order__c = FOC.id;
                ppl.recordtypeid = ItemRecTypeID;
                
                saveItemList.add(ppl);
        }
        
        system.debug('---- in addItem --- saveItemList : ' + saveItemList);
        
        try{
            upsert saveItemList;
            if(delItemList != null && delItemList.size() > 0){
                delete delItemList;
                delItemList.clear();
            }
            
            return true;
        }catch(Exception e){
            strPageID = 'ERROR';
            System.debug('Upsert Error: ' + e);
            String strError = e.getMessage();    
            //String strError = e.getMessage() +'|'+ String.valueOf(e.getLineNumber());
            System.debug('Flag- Saving Error Info: getTypeName: ' + e.getTypeName() + ' getDmlType: '+e.getDmlType(0));
            system.debug('-------------Error------------' + strError);
            if(e.getTypeName() == 'System.DmlException' && e.getDmlType(0) == System.Statuscode.DUPLICATE_VALUE) 
            {
                //String s = e.getDmlMessage(0);
                //strError += strError.substring(strError.indexOf(':') + ':'.length(), strError.length());    
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, strError));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Invoice Number'));
            }else if(e.getTypeName() == 'System.DmlException' && e.getDmlType(0) == System.Statuscode.FIELD_CUSTOM_VALIDATION_EXCEPTION){
                String s = e.getDmlMessage(0);
                s = 'Update Fail on Line ' + e.getNumDml() + ' : ' + s;   
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
            }else if(e.getTypeName().contains('System.DmlException') && e.getDmlType(0) == System.Statuscode.INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insufficient Privileges: You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strError));
            }
            database.rollback(sp);
            return false;
        }   
        
    }// END OF addItem
}