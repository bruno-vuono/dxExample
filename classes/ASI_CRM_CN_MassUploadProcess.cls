global class ASI_CRM_CN_MassUploadProcess implements Database.Batchable<sObject>{

 global final String ObjAPIName;
    global final String parentID;
    global final String parentField;
    global final String fields;
    global final String fieldsLabel;
    global final String lookupEXID;
    //global final String template;
    global final String recordtypeName;
    global final String currentPageURL;
    global final String defaultValues;
    global final String AttID;
    //global final boolean inlineVF;
    //global final boolean reloadNeeded;
    global final string recEXID {set;get;}
    global final string recEXIDcol {set;get;} 
    global final string parentObjectAPIName {set;get;}
    global final string ParentObjectUploadMsg {set;get;}
    global final boolean upsertMode {set;get;}
    global final boolean batchMode {set;get;}
    global final boolean opt_allOrNone {set;get;}
    global final boolean emailNotification {set;get;}
    global List<Attachment> LAttUpdate;
    
    public string currentPageURLOutput {set;get;}
    private Schema.SObjectType ObjType;
    private Schema.SObjectType ParentObjType;
    private list<String> LFieldAPIName; 
    private list<String> LFieldLabel; 
    private map<string,string> MAPINameLabel;
    private list<Row> LInputRow;
    public list<Row> LErrorRows {set;get;} 
    private list<lookupRecord> LLookupField;
    private map<string,integer> MFieldPos;
    private map<string,integer> MLookupFieldPos;
    private map<string,id> MRecTypeID; 
    public boolean hasError {set;get;}
    public string msg {set;get;}
    private id recordtypid;
    private list<string> LDefaultVales;
    private list<string> LDefaultValesHeader;
    private list<string> LEXIDFieldLabel;
    
    private Integer rowCount;
    private Integer colCount;

    global ASI_CRM_CN_MassUploadProcess(String ObjAPIName, String parentID, String parentField, String fields, String fieldsLabel, String lookupEXID, String recordtypeName, 
        string defaultValues, string currentPageURL, string AttID, string recEXID, string recEXIDcol, string parentObjectAPIName, string ParentObjectUploadMsg,
        boolean upsertMode, boolean emailNotification , boolean opt_allOrNone){
        this.ObjAPIName = ObjAPIName;
        this.parentID = parentID;
        this.parentField = parentField;
        this.fields = fields;
        this.fieldsLabel = fieldsLabel;
        this.lookupEXID = lookupEXID;
        this.recordtypeName = recordtypeName;
        this.AttID = AttID;
        this.defaultValues = defaultValues;
        this.recEXID = recEXID;
        this.recEXIDcol = recEXIDcol;
        this.parentObjectAPIName = parentObjectAPIName;
        this.ParentObjectUploadMsg = ParentObjectUploadMsg;
        this.upsertMode = upsertMode;
        this.emailNotification = emailNotification;
        this.opt_allOrNone = opt_allOrNone;
   }

    global database.querylocator start(Database.BatchableContext BC){
     // This methods returns a SOQL query locator containing the records
            return Database.getQueryLocator([select id, name, body, description, parentid,owner.email from attachment where id =:AttID]);
     }
    
    // The executeBatch method is called for each chunk of records returned from start.    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        if(scope != null){
            init();
            LAttUpdate = new List<Attachment>();
            List<sObject> LParentObj = new List<sObject>();
            map<Id, string> resultTexts = new map<Id, string>();
            
            for(sobject sc : scope){
                Attachment att = (Attachment)sc;                
                att.description = '';
                resultTexts.put(att.Id, '');
                LErrorRows = new list<Row>();
                String namefile = att.name;
                system.debug('namefile'+namefile);
                if(namefile.toLowerCase().right(3)=='csv'){
                    list<list<String>> parsedCSV = genResults(att.body);
                    list<String> LHeader = new list<String>();
                    
                    if(parsedCSV != null && parsedCSV.size()>0){
                        // retrieve header of csv
                        LHeader = addDefaultValues(parsedCSV[0],true);                  
                        parsedCSV.remove(0);
                        system.debug(LHeader);
                        integer i = 0;
                        for(List<String> LS : parsedCSV){
                            LS = addDefaultValues(LS,false);
                        }
                        MFieldPos = new map<string,integer>();
                        for(string h : LHeader){
                            system.debug('h.toLowerCase().trim() ' + h.toLowerCase().trim());
                            MFieldPos.put(h.toLowerCase().trim(),i);
                            i++;
                            system.debug('MFieldPos' + MFieldPos + h);
                        }
                        
                        LLookupField = new list<lookupRecord>();
                        MLookupFieldPos = new map<string,integer>();
                        //system.debug('lookupEXID' +lookupEXID);
                        if(lookupEXID != '' && lookupEXID != null){
                            system.debug('lookupEXID' +lookupEXID);
                            for(string s : lookupEXID.split(';',0)){
                                system.debug('input string ' + s);
                                lookupRecord tempLookupRecord = new lookupRecord(s);
                                LLookupField.add(tempLookupRecord);
                                system.debug(templookuprecord);
                                MLookupFieldPos.put(tempLookupRecord.field,LLookupField.size()-1);
                            }
                        }
                        for(lookupRecord lookupField : LLookupField){
                            for(List<String> LS : parsedCSV){
                                system.debug(LS);
                                lookupField.addKey(LS, MFieldPos,MRecTypeID);
                                //LS = addDefaultValues(LS,false);
                            }
                            lookupField.queryResult();
                        }
                        system.debug('LLookupField: ' + LLookupField);
                        
                        system.debug('MFieldPos: ' + MFieldPos);
                        LInputRow = new list<Row>();
                        Integer rowNumber = 1;
                        Map<string,string> MFieldType = new map<string,string>();
                        System.debug(LFieldAPINAme);
                        System.debug(MFieldType);
                        System.debug(ObjType);
                        for(string fieldname : LFieldAPIName){
                            System.debug(fieldname);
                            MFieldType.put(fieldname,ObjType.getDescribe().fields.getMap().get(fieldname.trim()).getDescribe().getType().name().toLowerCase());
                            
                        }
                        LEXIDFieldLabel = new List<String>();
                        if(recEXID != null && recEXID != ''){
                            LEXIDFieldLabel = recEXID.split(';',0);
                        }
                        
                        for(List<String> LS : parsedCSV){
                            // Start Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
                            Row r;                                          
                            if (parentField!= null && parentID!= null)
                                r = new row(ObjType.newSObject(), parentField, parentID);
                            else
                                r = new row(ObjType.newSObject());
                            // End Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
                            
                            if(recordtypid != null){
                                r.sObj.put('recordtypeid',recordtypid);
                            }
                            string testUOMf;
                            string testOrder;
                            String testSO;
                            Integer inputCol = 0;
                            system.debug(LS);
                            system.debug('LFieldAPIName' + LFieldAPIName);
                            for(string fieldname : LFieldAPIName){
                                string labelname = MAPINameLabel.get(fieldname);
                                system.debug('MAPINameLabel.get(fieldname)' + MAPINameLabel.get(fieldname));
                                system.debug('MFieldPos'+MFieldPos);
                                system.debug('MFieldPosLabel'+labelname+MFieldPos.containsKey(labelname));
                                system.debug('MLookupFieldPos'+MLookupFieldPos);
                                system.debug('label'+labelname+'/'+MLookupFieldPos.containsKey(fieldname));
                                if(MAPINameLabel.get(fieldname)=='Order Quantity(Wholesaler Input)'){
                                      testorder=LS[MFieldPos.get(labelname)];
                                
                                }else if(MAPINameLabel.get(fieldname)=='UOM(BOTTLE/CASE)(Wholesaler input)'){
                                      testUOMf=LS[MFieldPos.get(labelname)];
                                }
                                if (testOrder!=''){
                                if(MLookupFieldPos.containsKey(fieldname)){
                                    system.debug('Lookup Field:' + fieldname);
                                    system.debug('MLookupFieldPos '+MLookupFieldPos);
                                    system.debug('MLookupFieldPos.get(fieldname)'+MLookupFieldPos.get(fieldname));
                                    if(matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID) == null){
                                        if(labelname=='Promotion Code'){
                                            if(LS[MFieldPos.get(labelname)]==''){
                                                break;
                                            }
                                            else if(LS[MFieldPos.get(labelname)]!=''){
                                                 r.addError('Please verify the Promotion Code.');
                                        hasError = true;
                                            }
                                        }
                                        //system.debug(matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID));
                                        
                                        else 
                                        {
                                            r.addError('Imcomplete information, Please check the Sales Order ID or UOM');
                                        hasError = true;
                                    }
                                    }
                                    else if(matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID) != null){
                                       
                                         if(labelname=='Promotion Code'){
                                             
                                             string discount = LS[MFieldPos.get(labelname)];
                                             string testdis=discount.toLowerCase();
                                             if(testdis.contains('g')){
                                        integer orderqty=integer.valueof(testorder);
                                             integer index;
                                             string [] chars=discount.tolowercase().split('');
                                             string  char2='';
                                             for(integer testi=0;testi<chars.size();testi++){
                                                 if(chars[testi]=='g'){index=testi;
                                                                      }
                                             }
                                             for(integer testi2=1;testi2<index;testi2++){
                                                 char2 =char2+chars[testi2];
                                             }
                                             integer discount2=integer.valueof(char2);
                                             if(math.mod(orderqty,discount2)!=0||discount2>orderqty){
                                                 r.addError(labelname + ' For Buy X Get Y Promotion type, order quantity must be less than X or multiple of X.');
                                                 hasError = true;
                                             } else if(math.mod(orderqty,discount2)==0) {
                                                 break;
                                             }
                                             } 
                                             else if(!testdis.contains('g')){
                                                 r.addError(labelname + ' break test.');
                                                 hasError = true;
                                             }
                                         }
                                    }
                                    try{
                                        if(labelname!='Promotion Code'){
                                    r.sObj.put(fieldname, matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID));
                                    }
                                    }
                                    catch(exception e){
                                        if(labelname!='Promotion Code'){
                                        r.addError(labelname + ': Cannot find record.');
                                        hasError = true;
                                        }
                                    }
                                }
                                   
                                else if(MAPINameLabel.get(fieldname)=='Order Quantity(Wholesaler Input)'&&LS[MFieldPos.get(labelname)]==''){
                                    try{
                                        
                                    }
                                    catch(exception e){
                                         r.addError(labelname + ': Please verify the input.');
                                        hasError = true;
                                    }
                                }
                                  /*   else if(MAPINameLabel.get(fieldname)=='Promotion Code'){
                                 string discount = LS[MFieldPos.get(labelname)];
                                        integer orderqty=integer.valueof(testorder);
        integer index;
       string [] chars=discount.split('');
        string  char2='';
        for(integer testi=0;testi<chars.size();testi++){
            if(chars[testi]=='G'){
                index=testi;
            }
        }
        for(integer testi2=1;testi2<index;testi2++){
            char2 =char2+chars[testi2];
        }
        integer discount2=integer.valueof(char2);
                                        if(math.mod(orderqty,discount2)!=0){
                                            r.addError(labelname + ': incorrect');
                                        hasError = true;
                                        }
                                       else{
                                           break;
                                       }
                                    } */
                                   //20160122 Start
                                     /*else if(MAPINameLabel.get(fieldname)=='UOM(BOTTLE/CASE)(Wholesaler input)'&&LS[MFieldPos.get(labelname)]==''){
                                       r.addError('Imcomplete information. Please check the UOM.');
                                        hasError = true;
                                     }*/
                                    //20160122 End
                                    else if(MAPINameLabel.get(fieldname)=='UOM(BOTTLE/CASE)(Wholesaler input)'){//&&LS[MFieldPos.get(labelname)]!=''){
                                        if(LS[MFieldPos.get(labelname)]!=''){//20160122
                                            string testUOM=LS[MFieldPos.get(labelname)].toLowerCase();
                                            if(testUOM=='bottle'){
                                                r.sObj.put(fieldname,'BT');
                                            }
                                            else if(testUOM=='case'){
                                                r.sObj.put(fieldname,'CA');
                                            }
                                            else{
                                                r.addError('UOM should be either Bottle or Case, Please check the input!');
                                                hasError = true;
                                            }
                                        }else if(LS[MFieldPos.get(labelname)]==''){//20160122 Ben @ Elufa
                                            r.sObj.put(fieldname,'CA');
                                        }
                                }
                                else if(MFieldPos.containsKey(labelname) && LS[MFieldPos.get(labelname)] != null && LS[MFieldPos.get(labelname)] != ''){
                                    system.debug('Non-Lookup Field:' + fieldname);
                                    system.debug('MFieldPos'+MFieldPos);
                                    system.debug(MFieldPos.get(labelname));
                                    system.debug(ObjType);
                                    //system.debug(ObjType.getDescribe().fields.getMap().get(labelname));
                                    //system.debug(ObjType.getDescribe().fields.getMap().get(labelname).getDescribe().getType().name());
                                   
                                    if(MFieldType.containsKey(fieldname)){
                                        string tempFieldType = MFieldType.get(fieldname);
                                        //if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='boolean'){
                                        if(tempFieldType=='boolean'){
                                            system.debug('Boolean source '+LS[MFieldPos.get(labelname)].toLowerCase());
                                            if(LS[MFieldPos.get(labelname)].toLowerCase().trim()=='y'||LS[MFieldPos.get(labelname)].trim()=='1'||LS[MFieldPos.get(labelname)].toLowerCase().trim()=='true'){
                                                try{
                                                r.sObj.put(fieldname, true);
                                                }
                                                catch(exception e){
                                                    r.addError(labelname + ': ' + e.getMessage());
                                                    hasError = true;
                                                }
                                            }
                                            else{
                                                try{
                                                    r.sObj.put(fieldname, false);
                                                }
                                                catch(exception e){
                                                    r.addError(labelname + ': ' + e.getMessage());
                                                    hasError = true;
                                                }
                                            }
                                                
                                        }
                                        //else if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='date'){
                                         else if(tempFieldType=='date'){
                                            try{
                                                string dateText = LS[MFieldPos.get(labelname)];
                                               if(dateText.contains('/')){
                                                    date tempdate=dateSpliter(dateText);
                                                     r.sObj.put(fieldname,tempdate);
                                                }
                                                    else{
                                                     r.sObj.put(fieldname, date.newInstance(integer.valueOf(dateText.subString(0,4)), integer.valueOf(dateText.subString(4,6)), integer.valueOf(dateText.subString(6,8))));
                                                }
                                                
                                            }
                                            
                                            catch(exception e){
                                                r.addError(labelname + ': ' + e.getMessage());
                                                hasError = true;
                                            }
                                        }//Added by steve at 12/2015. Handle different formatting issues, e.g. DD/MM/YYYY , YYYYMMDD.
                                        
                                        //else if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='double' ||
                                        //    ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='percent' ||
                                        //    ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='currency'
                                        //){
                                        else if(tempFieldType=='double' ||
                                            tempFieldType=='percent' ||
                                            tempFieldType=='currency'
                                        ){ /*string test = LS[MFieldPos.get(labelname)];
                                          if(test.contains(',')){
                                             decimal finalPrice=currencySpliter(test);
                                                  r.sObj.put(fieldname,finalPrice);
                                          }
                                            else*/
                                            try{
                                                r.sObj.put(fieldname, decimal.valueof(LS[MFieldPos.get(labelname)]));
                                            }
                                                catch(exception e){
                                                        r.addError(labelname + ': ' + e.getMessage());
                                                        hasError = true;
                                                }
                                        }
                                        //else if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='integer'){
                                        else if(tempFieldType=='integer'){
                                            try{
                                                r.sObj.put(fieldname, integer.valueof(LS[MFieldPos.get(labelname)]));
                                            }
                                                catch(exception e){
                                                    r.addError(labelname + ': ' + e.getMessage());
                                                    hasError = true;
                                                }
                                        }
                                        else{
                                            try{
                                            r.sObj.put(fieldname, LS[MFieldPos.get(labelname)]);
                                            }
                                                catch(exception e){
                                                    r.addError(labelname + ': ' + e.getMessage());
                                                    hasError = true;
                                                }
                                        }
                                        }
                                    }
                                        
                                    
                                }
                                /*else if(testOrder==''&&MAPINameLabel.get(fieldname)=='UOM(BOTTLE/CASE)(Wholesaler input)'){
                                    if(LS[MFieldPos.get(labelname)]!=''){
                                       r.addError('Imcomplete information, Please check the Order Qty or Sales Order ID.');
                                        hasError = true;
                                    }
                                }*/
                                else if (testOrder==''&&testUOMf==''&&MAPINameLabel.get(fieldname)=='Sales Order ID(User Input)'){
                                    if(LS[MFieldPos.get(labelname)]!=''){
                                         r.addError('Imcomplete information, Please check the Order Qty or UOM.');
                                        hasError = true;
                                    }
                                }
                          
                            }
                            r.rowNumber = rowNumber++;
                            if(r.hasErrors){
                                LErrorRows.add(r);
                            }
                            // to generate EXID column
                            String tempEXIDValue = '';
                            for(String exid : LEXIDFieldLabel){
                                exid = exid.tolowercase();
                                system.debug(exid);
                                if(MFieldPos.containsKey(exid) && LS[MFieldPos.get(exid)] != null && LS[MFieldPos.get(exid)] != ''){
                                    tempEXIDvalue += LS[MFieldPos.get(exid)].toLowerCase();
                                    System.debug(tempEXIDvalue);
                                }
                            }
                            if(tempEXIDvalue != ''){
                                r.sObj.put(recEXIDcol,tempEXIDvalue);
                            }
                            System.debug(tempEXIDvalue);
                            LInputRow.add(r);
                            System.debug('row to be insert or updated: ' + r);
                        }
                        list<sObject> lRecInsert = new list<sobject>();
                        
                        System.debug('Has Error: ' + hasError + ' Is upsertMode?: ' + upsertMode);
                        
                        if(!hasError || upsertMode){
                            for(Row r : LInputRow){
                                System.debug('Input Row has Error?: ' + r.hasErrors);
                                if(!r.hasErrors){
                                    lRecInsert.add(r.sObj);
                                }
                            }
                            
                            System.debug('Insert Row: ' + lRecInsert);
                            if(lRecInsert != null && lRecInsert.size()>0){
                                try{
                                    List<Database.upsertResult> uResults = new List<Database.upsertResult>();
                                    List<Database.SaveResult> insertResults = new List<Database.SaveResult>();
                                    
                                    if(upsertMode){
                                        // Hard Code for Casting before upsert
                                    if(ObjAPIName == 'ASI_KOR_Sales_Order_Transaction__c'){
                                            List<ASI_KOR_Sales_Order_Transaction__c> LUpsert = new List<ASI_KOR_Sales_Order_Transaction__c>();
                                        if(!hasError){
                                            for(sObject s : lRecInsert){
                                                if (((ASI_KOR_Sales_Order_Transaction__c)s).ASI_KOR_Order_Qty__c != null&&((ASI_KOR_Sales_Order_Transaction__c)s).ASI_KOR_Sales_Order_Request__c!=null&&((ASI_KOR_Sales_Order_Transaction__c)s).ASI_CRM_UOM_Text__c!=null){
                                                LUpsert.add((ASI_KOR_Sales_Order_Transaction__c)s);
                                                        }
                                            }
                                        }
                                            try{
                                                System.debug(LUpsert);
                                                uResults = database.upsert(LUpsert,ObjType.getDescribe().fields.getMap().get(recEXIDcol),opt_allOrNone);
                                                System.debug(ObjType.getDescribe().fields.getMap().get(recEXIDcol));
                                                System.debug(recEXIDcol);
                                                
                                                System.debug(LUpsert);
                                                //insert LUpsert;
                                                System.debug(LUpsert);
                                            }
                                            catch(exception e){
                                                throw e;
                                                System.debug(e.getMessage());
                                            }
                                        }
                                        /*else if(ObjAPIName == 'ASI_MFM_Plan_Line_Item__c'){
                                            List<ASI_MFM_Plan_Line_Item__c> LUpsert = new List<ASI_MFM_Plan_Line_Item__c>();
                                            Integer randomKey = lRecInsert.size();
                                            for(sObject s : lRecInsert){
                                                //Special Handling to clear plan line amount
                                                ASI_MFM_Plan_Line_Item__c item = (ASI_MFM_Plan_Line_Item__c)s;
                                                item.ASI_MFM_Total_Cost__c = null;
                                                //System.debug(s.ASI_MFM_Plan_External_ID_Upload__c );
                                                //((ASI_MFM_Plan_Line_Item__c)s).ASI_MFM_TR_Rec_Type__c = '';
                                                if (((ASI_MFM_Plan_Line_Item__c)s).ASI_MFM_Plan_Line_Item_External_IDUpload__c == null || ((ASI_MFM_Plan_Line_Item__c)s).ASI_MFM_Plan_Line_Item_External_IDUpload__c == ''){
                                                    item.ASI_MFM_Plan_Line_Item_External_IDUpload__c= String.valueOf(Datetime.now())+ randomKey;
                                                    randomKey++;
                                                }
                                                LUpsert.add(item);
                                            }
                                            System.debug('ObjType.getDescribe().fields.getMap().get(recEXIDcol)' + ObjType.getDescribe().fields.getMap().get(recEXIDcol));
                                            uResults = database.upsert(LUpsert,ObjType.getDescribe().fields.getMap().get(recEXIDcol),opt_allOrNone);
                                            System.debug(LUpsert);
                                             
                                        }
                                        else if(ObjAPIName == 'ASI_MFM_PO_Line_Item__c'){
                                            List<ASI_MFM_PO_Line_Item__c> LUpsert = new List<ASI_MFM_PO_Line_Item__c>();
                                            Integer randomKey = lRecInsert.size();
                                            for(sObject s : lRecInsert){
                                                ASI_MFM_PO_Line_Item__c item = (ASI_MFM_PO_Line_Item__c)s;
                                                if (((ASI_MFM_PO_Line_Item__c)s).ASI_MFM_PO_Line_Item_External_IDUpload__c == null || ((ASI_MFM_PO_Line_Item__c)s).ASI_MFM_PO_Line_Item_External_IDUpload__c == ''){
                                                    item.ASI_MFM_PO_Line_Item_External_IDUpload__c= String.valueOf(Datetime.now())+ randomKey;
                                                    randomKey++;
                                                }
                                                System.debug('item.ASI_MFM_PO_Line_Item_External_IDUpload__c' + item.ASI_MFM_PO_Line_Item_External_IDUpload__c);
                                                LUpsert.add(item);
                                            }
                                            System.debug('ObjType.getDescribe().fields.getMap().get(recEXIDcol)' + ObjType.getDescribe().fields.getMap().get(recEXIDcol)); 
                                            uResults = database.upsert(LUpsert,ObjType.getDescribe().fields.getMap().get(recEXIDcol),opt_allOrNone);
                                            System.debug(LUpsert);
                                        }
                                        else if(ObjAPIName == 'ASI_MFM_Budget__c'){
                                            List<ASI_MFM_Budget__c> LUpsert = new List<ASI_MFM_Budget__c>();
                                            Integer randomKey = lRecInsert.size();
                                            for(sObject s : lRecInsert){
                                                ASI_MFM_Budget__c item = (ASI_MFM_Budget__c)s;
                                                if (((ASI_MFM_Budget__c)s).ASI_MFM_Budget_External_ID__c == null || ((ASI_MFM_Budget__c)s).ASI_MFM_Budget_External_ID__c == ''){
                                                    item.ASI_MFM_Budget_External_ID__c= String.valueOf(Datetime.now())+ randomKey;
                                                    randomKey++;
                                                }
                                                System.debug('item.ASI_MFM_Budget_External_ID__c' + item.ASI_MFM_Budget_External_ID__c);
                                                LUpsert.add(item);
                                            }
                                            System.debug('ObjType.getDescribe().fields.getMap().get(recEXIDcol)' + ObjType.getDescribe().fields.getMap().get(recEXIDcol)); 
                                            uResults = database.upsert(LUpsert,ObjType.getDescribe().fields.getMap().get(recEXIDcol),opt_allOrNone);
                                            System.debug(LUpsert);
                                        }
                                        else if(ObjAPIName == 'ASI_CRM_WS_Target__c'){
                                            //Upsert for MY CRM
                                            List<ASI_CRM_WS_Target__c> LUpsert = new List<ASI_CRM_WS_Target__c>();
                                            Integer randomKey = lRecInsert.size();
                                            for(sObject s : lRecInsert){
                                                ASI_CRM_WS_Target__c item = (ASI_CRM_WS_Target__c)s;
                                                if (((ASI_CRM_WS_Target__c)s).ASI_CRM_External_ID__c == null || ((ASI_CRM_WS_Target__c)s).ASI_CRM_External_ID__c == ''){
                                                    item.ASI_CRM_External_ID__c= String.valueOf(Datetime.now())+ randomKey;
                                                    randomKey++;
                                                }
                                                System.debug('Upsert ASI_CRM_WS_Target__c, empty external ID in ASI_CRM_External_ID__c field, randomly generated key: ' + item.ASI_CRM_External_ID__c);
                                                LUpsert.add(item);
                                            }
                                            System.debug('ObjType.getDescribe().fields.getMap().get(recEXIDcol)' + ObjType.getDescribe().fields.getMap().get(recEXIDcol)); 
                                            uResults = database.upsert(LUpsert,ObjType.getDescribe().fields.getMap().get(recEXIDcol),opt_allOrNone);
                                            System.debug(LUpsert);
                                        }
                                        else if(ObjAPIName == 'ASI_CRM_Budget__c'){
                                            //Upsert for SG CRM
                                            List<ASI_CRM_Budget__c> LUpsert = new List<ASI_CRM_Budget__c>();
                                            Integer randomKey = lRecInsert.size();
                                            for(sObject s : lRecInsert){
                                                ASI_CRM_Budget__c item = (ASI_CRM_Budget__c)s;
                                                if (((ASI_CRM_Budget__c)s).ASI_CRM_External_Key__c == null || ((ASI_CRM_Budget__c)s).ASI_CRM_External_Key__c == ''){
                                                    item.ASI_CRM_External_Key__c= String.valueOf(Datetime.now())+ randomKey;
                                                    randomKey++;
                                                }
                                                System.debug('Upsert ASI_CRM_Budget__c, empty external ID in ASI_CRM_External_Key__c field, randomly generated key: ' + item.ASI_CRM_External_Key__c);
                                                LUpsert.add(item);
                                            }
                                            System.debug('ObjType.getDescribe().fields.getMap().get(recEXIDcol)' + ObjType.getDescribe().fields.getMap().get(recEXIDcol)); 
                                            uResults = database.upsert(LUpsert,ObjType.getDescribe().fields.getMap().get(recEXIDcol),opt_allOrNone);
                                            System.debug(LUpsert);
                                        }*/
                                        else {
                                            System.debug('Error, upsert target object is not defined in ASI_MFM_MassUploadProcess apex class!');
                                        }
                                        //Schema.SObjectField f = ObjType.getDescribe().fields.getMap().get(recEXIDcol);
                                        //upsert (List<ASI_MFM_Event_Outlet__c>)lRecInsert ASI_MFM_EXID__c;
                                    }
                                    else {
                                        //Added by Wilken on 20150113 Add Insert Result to VF page display
                                        insertResults = Database.insert(lRecInsert, opt_allOrNone);
                                    }
                                    integer succInsert = 0;
                                    integer succUpdate = 0;
                                    string validationErrorText = '';
                                    integer rowNo = 0;
                                    
                                    //Upsert Result
                                   
                                    for(Database.upsertResult res:uResults) {
                                        rowNo ++;
                                        if (res.isSuccess()) {
                                            if (res.isCreated()) {
                                                System.debug('Created record ID ' + res.getId() + '.');
                                                succInsert ++;
                                            } else {
                                                System.debug('Updated record ID ' + res.getId() + '.');
                                                succUpdate ++;
                                            }
                                        }
                                        else {
                                            if (res.getErrors().size() > 0) {
                                                System.debug(res.getErrors()[0].getMessage());
                                                validationErrorText += 'Row' + String.valueof(rowNo)+': ' + res.getErrors()[0].getMessage();
                                            }
                                        
                                    }
                                    }
                                    
                                    //Insert Result
                                    for(Database.SaveResult res:insertResults) {
                                        rowNo ++;
                                        if (res.isSuccess()) {
                                            System.debug('Created record ID ' + res.getId() + '.');
                                            succInsert ++;                                            
                                        }
                                        else {
                                            if (res.getErrors().size() > 0) {
                                                System.debug(res.getErrors()[0].getMessage());
                                                validationErrorText += 'Row' + String.valueof(rowNo)+': ' + res.getErrors()[0].getMessage();
                                            }
                                        }
                                    }
                                    
                                    msg = 'Import Completed! ' + string.valueof(succInsert) + ' record(s) created.\n';
                                    msg += '' + string.valueof(succUpdate) + ' record(s) updated.\n';
                                    string errorText = '';
                                    for(Row r : LInputRow){
                                        if(r.hasErrors){
                                            for(string errorMsg :r.errorMsgs) {
                                                if(errorText!='') errorText += '\n';
                                                errorText += 'Row' + String.valueof((r.rowNumber+1))+': ' + errorMsg;
                                            }
                                        }
                                    }
                                    if(errorText!='')
                                        msg += errorText;
                                    resultTexts.put(att.Id, msg);
                                    LAttUpdate.add(att);
                                    sObject tempParent = ParentObjType.newSObject();
                                    tempParent.put('id',att.parentid);
                                    tempParent.put(ParentObjectUploadMsg,att.description);
                                    LParentObj.add(tempParent);
                                    //LParentObj.add(new ASI_MFM_Event__c(id=att.parentid,ASI_MFM_Event_Outlet_Msg__c=att.description));
                                    /*if(inlineVF)
                                        refreshPage2();
                                    else
                                        refreshPage();*/
                                }
                                catch(dmlexception de){
                                    hasError = true;
                                    
                                    for(integer j =0;j<de.getNumDml();j++){
                                        //debug += 'fieldname: ' + e.getDmlFieldNames(j)+'|';
                                        //debug += 'index: ' + e.getDmlIndex(j)+'|';
                                        LInputRow[j].addError(de.getDmlMessage(j));
                                        //att.description += e.getDmlMessage(j) + '\n';
                                        resultTexts.put(att.Id, resultTexts.get(att.Id)+'\n'+de.getDmlMessage(j));
                                        LErrorRows.add(LInputRow[j]);
                                        //debug += 'statuscode: ' + e.getDmlStatusCode(j)+'|';
                                    }
                                    msg = '';
                                    LAttUpdate.add(att);
                                    sObject tempParent = ParentObjType.newSObject();
                                    tempParent.put('id',att.parentid);
                                    tempParent.put(ParentObjectUploadMsg,  resultTexts.get(att.Id).length()>32000? resultTexts.get(att.Id).substring(0,32000): resultTexts.get(att.Id));
                                    LParentObj.add(tempParent);
                                    //LParentObj.add(new ASI_MFM_Event__c(id=att.parentid,ASI_MFM_Event_Outlet_Msg__c=att.description));
                                    
                                }
                                catch(exception e){
                                    system.debug('error'+e);
                                    hasError = true;
                                    LInputRow[0].addError(e.getMessage());
                                    resultTexts.put(att.Id, resultTexts.get(att.Id)+'\n'+e.getMessage());
                                    LErrorRows.add(LInputRow[0]);
                                    msg = '';
                                    LAttUpdate.add(att);
                                    sObject tempParent = ParentObjType.newSObject();
                                    tempParent.put('id',att.parentid);
                                    tempParent.put(ParentObjectUploadMsg,  resultTexts.get(att.Id).length()>32000? resultTexts.get(att.Id).substring(0,32000): resultTexts.get(att.Id));
                                    LParentObj.add(tempParent);
                                    //LParentObj.add(new ASI_MFM_Event__c(id=att.parentid,ASI_MFM_Event_Outlet_Msg__c=att.description));
                                    
                                    //e.getMessage();
                                }
                            }
                            else{
                                string errorText = '';
                                for(Row r : LInputRow){
                                    if(r.hasErrors){
                                        for(string errorMsg :r.errorMsgs) {
                                            if(errorText!='') errorText += '\n';
                                            errorText += 'Row' + String.valueof(r.rowNumber)+': ' + errorMsg;
                                        }
                                    }
                                }
                                if(errorText!='')
                                    resultTexts.put(att.Id, resultTexts.get(att.Id)+'\n'+errorText);
                                LAttUpdate.add(att);
                                sObject tempParent = ParentObjType.newSObject();
                                tempParent.put('id',att.parentid);
                                tempParent.put(ParentObjectUploadMsg,resultTexts.get(att.Id).length()>32000? resultTexts.get(att.Id).substring(0,32000): resultTexts.get(att.Id));
                                LParentObj.add(tempParent);
                            }
                        }
                        else{
                            string errorText = '';
                            for(Row r : LInputRow){
                                if(r.hasErrors){
                                    for(string errorMsg :r.errorMsgs) {
                                        if(errorText!='') errorText += '\n';
                                        errorText += 'Row' + String.valueof(r.rowNumber)+': ' + errorMsg;
                                    }
                                }
                            }
                            if(errorText!='')
                                resultTexts.put(att.Id, resultTexts.get(att.Id)+'\n'+errorText);
                            LAttUpdate.add(att);
                            sObject tempParent = ParentObjType.newSObject();
                            tempParent.put('id',att.parentid);
                            tempParent.put(ParentObjectUploadMsg,resultTexts.get(att.Id).length()>32000? resultTexts.get(att.Id).substring(0,32000): resultTexts.get(att.Id));
                            LParentObj.add(tempParent);
                            //LParentObj.add(new ASI_MFM_Event__c(id=att.parentid,ASI_MFM_Event_Outlet_Msg__c=att.description));
                        }
                        
                        
                    }
                    System.debug(LAttUpdate);
                    if(LAttUpdate != null && LAttUpdate.size()>0){
                        
                        for(Attachment att1: LAttUpdate) {
                            att1.description = resultTexts.get(att.Id).length()>500? resultTexts.get(att.Id).substring(0,500): resultTexts.get(att.Id);
                        }

                        update LAttUpdate;
                    }
                    if(LParentObj != null && LParentObj.size()>0){
                        update LParentObj;
                    }
                    List<Messaging.Email> LEmails = new List<Messaging.Email>();
                    for(Attachment att1 : LAttUpdate){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        string resultText = resultTexts.get(att1.Id);
                        String resultTextHtml = resultText.replace('\n','<br/>');
                        String URLDownload = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file=' + att1.id;
                        mail.setHtmlBody('Your mass upload submission was processed.<br/>' + resultTextHtml + '<br/><br/>Please do not reply to this message.<br/>Contact your system administrator if you feel you received this message in error.<br/>Download Uploaded csv: <a href=\"'+URLDownload+'\">'+URLDownload+'</a>');
                        mail.setPlainTextBody('Your mass upload submission was processed.\n' + resultText + '\n\nPlease do not reply to this message.\nContact your system administrator if you feel you received this message in error.\nDownload Uploaded csv: '+ URLDownload);
                        mail.setToAddresses(new List<String>{att1.owner.email});
                        mail.setReplyTo('noreply@salesforce.com');
                        mail.setSenderDisplayName('Mass Upload Process');
                        mail.setSubject('Mass Upload Process is Completed');
                        LEmails.add(mail);
                    }
                    if(LEmails.size()>0 && emailNotification){
                        if(!test.isrunningtest()){
                            Messaging.sendEmail(LEmails);
                        }
                    }
                }
                else{
                    msg = 'Error: Please select csv file only!';
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
    public void init(){
        /*if(inlineVF){
            currentPageUrlOutput = currentPageUrl;
        }
        else*/
        ObjType = Schema.getGlobalDescribe().get(ObjAPIName);
        ParentObjType = Schema.getGlobalDescribe().get(parentObjectAPIName);
        LFieldAPIName = fields.toLowerCase().split(',',0);
        LFieldLabel = fieldsLabel.toLowerCase().split(',',0);
        if([select id from recordType where name = :recordtypeName and SobjectType = :ObjAPIName].size()>0){
            recordtypid = [select id from recordType where name = :recordtypeName and SobjectType = :ObjAPIName].id;
        }
        MAPINameLabel = new map<string,string>();
        for(integer i=0;i<LFieldAPIName.size();i++){
            MAPINameLabel.put(LFieldAPIName[i].toLowerCase().trim(),LFieldLabel[i].toLowerCase().trim());
        }
        MRecTypeID = new map<string,id>();
        for(RecordType r: [Select id, name, SobjectType from RecordType]){
            string key = r.SobjectType+r.name;
            key = key.toLowerCase();
            MRecTypeID.put(key,r.id);
        }
        system.debug('MRecTypeID'+MRecTypeID);
        hasError = false;
        msg = '';
        //MRecTypeDefault = new Map<string,string>();
        LDefaultVales = new list<string>();
        LDefaultValesHeader = new list<string>();
        if(defaultValues != null && defaultValues != ''){
            list<string> LDefaultValuePair = defaultValues.split(';',0);
            for(String s : LDefaultValuePair){
                list<string> l = s.split(':',0);
                LDefaultValesHeader.add(l[0]);
                LDefaultVales.add(l[1]);
            }
            //MRecTypeDefault.put()
        }
        
        
    }
    
    private list<string> addDefaultValues(list<string> ls, boolean isHeader){
        if(isHeader)
            ls.addAll(LDefaultValesHeader);
        else
            ls.addAll(LDefaultVales);
        return ls;
    }
    
    private id matchLookupField(integer pos,list<string> ls, map<string,integer> mfpos, map<string,id> MRecTypeID){
        String key = '';
        //LLookupField[pos]
        system.debug('mfpos'+mfpos);
        system.debug('ls'+ls);
        system.debug('LLookupField[pos]'+LLookupField[pos]);
        for(string label : LLookupField[pos].MFieldLabelKeyFilter.keySet()){
            system.debug('label '+label+'/'+mfpos.containsKey(label));
            if(mfpos.containsKey(label.toLowerCase())){
                if(label.contains('recordtype')){
                    string tempKey = LLookupField[pos].objectName.toLowerCase() + ls[mfpos.get(label)].toLowerCase();
                    system.debug('MRecTypeID'+MRecTypeID);
                    system.debug('MRecTypeID.containsKey(tempKey)'+tempKey+'/'+MRecTypeID.containsKey(tempKey));
                    if(MRecTypeID.containsKey(tempKey)){
                        key += String.valueof(MRecTypeID.get(tempKey)).toLowerCase();
                    }
                }
                else{
                    key += ls[mfpos.get(label)].toLowerCase().trim();
                    system.debug('key: '+key);
                }
            }
        }
        system.debug(key);
        return LLookupField[pos].genid(key);
    }
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }        
    private List<List<String>> genResults(blob contentFile) {
        List<List<String>> parsedCSV = new List<List<String>>();
        rowCount = 0;
        colCount = 0;
        if (contentFile != null){
            //String fileString = contentFile.toString().toLowerCase();
            //Modify by Steve 20140617
            //String fileString = contentFile.toString();
            String fileString = blobToString( contentFile,'GB2312');
            parsedCSV = parseCSV(fileString, false);
            rowCount = parsedCSV.size();
            for (List<String> row : parsedCSV){
                if (row.size() > colCount){
                    colCount = row.size();
                }
            }
            // fill in empty value to make sure col size is the same for each row
            for (list<string> row : parsedCSV){
                while(row.size()<colCount){
                    row.add('');
                }
            }
        }
        return parsedCSV;
    }

    
    /* 
    Credit to 
    http://wiki.developerforce.com/index.php/Code_Samples#Parse_a_CSV_with_APEX
    */
    private static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        
        contents = contents.replaceAll('""','DBLQT');
        contents = contents.replaceAll('\r\n','\r');
        contents = contents.replaceAll('\n','\r');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            //lines = contents.split('\n'); //correction: this only accomodates windows files
            lines = contents.split('\r'); // using carriage return accomodates windows, unix, and mac files
            //http://www.maxi-pedia.com/Line+termination+line+feed+versus+carriage+return+0d0a
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line: lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field: fields) {
                
                if (field.startsWith('"') && field.endsWith('"') && field.length()>1) {
                    cleanFields.add(field.replaceAll('"','').replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')  && !makeCompositeField) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"') && makeCompositeField) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('"','').replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                    system.debug('composite field2:'+compositeField.replaceAll('"','').replaceAll('DBLQT','"'));
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('"','').replaceAll('DBLQT','"'));
                }
            }
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields;       
    }
    
    
    
    // class for storing lookup field name and corresponding key fields
    public class lookupRecord{
        public string Field {set;get;}                        //lookup field name
        public string objectName {set;get;}                   //object of lookup field point to
        public map<string,string> MFieldLabel {set;get;}      //Map for header name & field api name
        private string soql {set;get;}
        private list<set<string>> LkeyFilter;                 //key field values for searching records by soql
        private map<string,integer> MFieldLabelKeyFilter;     //map for key field to access corresponding set of values for filter in LkeyFilter 
        public map<string,id> MResult;
        public lookupRecord(string input){
            soql = '';
            LkeyFilter = new list<set<string>>();
            MFieldLabelKeyFilter = new map<string,integer>();
            MFieldLabel = new map<string,string>();
            list<string> temp = input.split(':',0);
            if(temp.size()>1){
                list<string> objectinfo = temp[0].split('/',0);
                objectName = objectinfo[0].trim();
                Field = objectinfo[1].trim().toLowerCase();
                for(string s : temp[1].split(',',0)){
                    temp = s.split('&',0);
                    if(temp.size()>1){
                        MFieldLabel.put(temp[0].trim().toLowerCase(),temp[1].trim().toLowerCase());
                        LkeyFilter.add(new set<String>());
                        MFieldLabelKeyFilter.put(temp[0].trim().toLowerCase(),LkeyFilter.size()-1);
                    }
                }
            }
        }
        public void addKey(list<string> ls, map<string,integer> Mpos1, map<string,id> MRecTypeID){
            system.debug('ls'+ls);
            system.debug('Mpos1'+Mpos1);
            system.debug('MFieldLabel'+MFieldLabel);
            for(string label : MFieldLabel.keySet()){
                system.debug('Mpos1.containsKey(label)) '+label + '/'+Mpos1.containsKey(label));
                
                if(Mpos1.containsKey(label)){
                    system.debug('key1'+ls[Mpos1.get(label)]);
                    system.debug('MFieldLabelKey'+MFieldLabelKeyFilter.get(label));
                    system.debug('LKeyFilter'+LkeyFilter[MFieldLabelKeyFilter.get(label)]);
                    //handle recordtype id in lookup field component
                    system.debug('label'+label+'/'+label.contains('recordtype'));
                    system.debug('MRecTypeID'+MRecTypeID);
                    if(label.contains('recordtype')){
                        string key = objectName + ls[Mpos1.get(label)].trim();
                        key = key.toLowerCase();
                        
                        system.debug('MRecTypeID.get(key)'+key+'/'+MRecTypeID.containsKey(key));
                        if(MRecTypeID.containsKey(key)){
                            LkeyFilter[MFieldLabelKeyFilter.get(label)].add(MRecTypeID.get(key));
                        }
                    }
                    else{
                        LkeyFilter[MFieldLabelKeyFilter.get(label)].add(ls[Mpos1.get(label)].trim());
                    }
                }
            }
        }
        
        public void queryResult(){
        
            soql = 'Select id ';
            for(String label : MFieldLabel.keySet()){
                soql += ',' + MFieldLabel.get(label);
            }
            soql += ' from ' + objectName;
            if(MFieldLabel.keySet().size()>0){
                soql += ' where id != null ';
            }
            Set<String> setFilter1;
            Set<String> setFilter2;
            Set<String> setFilter3;
            Set<String> setFilter4;
            for(String label : MFieldLabel.keySet()){
                //soql += ' and ' + MFieldLabel.get(label) + ' IN :LkeyFilter[MFieldLabelKeyFilter.get(label)]';
                soql += ' and (';
                system.debug('MFieldLabelKeyFilter '+MFieldLabelKeyFilter); 
                system.debug('MFieldLabel '+MFieldLabel.get(label));
                system.debug('LkeyFilter '+LkeyFilter[MFieldLabelKeyFilter.get(label)]);
                for(string s : LkeyFilter[MFieldLabelKeyFilter.get(label)]){
                    system.debug('string '+ s.replace('\'','\\\''));
                    soql += MFieldLabel.get(label) + ' = \'' + s.replace('\'','\\\'') + '\'  or ';
                }
                soql = soql.substring(0,soql.length()-5);
                if(LkeyFilter[MFieldLabelKeyFilter.get(label)].size()>0)
                    soql += ' ) ';
                
            }
            system.debug('soql: '+soql);
            if(test.isRunningTest()){
                soql += ' limit 1';
            }
            list<sObject> LResult = database.query(soql);
            system.debug('LResult SOQL Result: '+LResult);
            if(LResult != null && LResult.size()>0){
                MResult = new map<string,id>();
                for(sObject s : LResult){
                    string key = '';
                    for(String label : MFieldLabel.keySet()){
                        system.debug('MFieldLabel.get(label)'+MFieldLabel.get(label));
                        system.debug('objectName '+objectName);
                        key += s.get(MFieldLabel.get(label));
                    }
                    MResult.put(key.toLowerCase(),s.id);
                    System.debug('Map of SOQL Result: ' + MResult);
                }
            }
        }
        public id genid(string inputKey){
            System.debug(inputKey);
            System.debug(MResult);
            inputKey = inputKey.trim();
            if(MResult != null && inputKey != null && inputKey != ''){
                system.debug('MResult'+MResult);
                system.debug('genid'+MResult.get(inputKey));
                system.debug('inputKey'+inputKey);
                return MResult.get(inputKey);
                
            }
            
            return null;
        }
    }
    
    
    public class Row {
        public Integer rowNumber {set;get;}
        public sObject sObj {set;get;}
        
        private list<string> m_errorMsgs = new list<string>();
        public list<string> errorMsgs { get { return m_errorMsgs; }}
        public boolean hasErrors { get { return errorMsgs.size()>0; }}
        
        // Start Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
        public row(sObject obj){
            sObj = obj;            
        }
        // End Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
        
        public row(sObject obj, string parentField, string parentID){
            sObj = obj;
            sObj.put(parentField,parentID);
        }
        public void addError(string errMsg){
            errorMsgs.add( errMsg);
        }
    }
      /*public static decimal currencySpliter(string testString){
        list<string>part=new list<string>();
        string sresult;
        decimal result;
        if(testString.length()==4){
           part.add(testString.substring(0,1));
             part.add(testString.substring(2,4));
            sresult=part[0]+'.'+part[1];
            result=decimal.valueof(sresult);
        }
          if(testString.length()==5){
           part.add(testString.substring(0,2));
             part.add(testString.substring(3,5));
            sresult=part[0]+'.'+part[1];
            result=decimal.valueof(sresult);
        }
          if(testString.length()==6){
           part.add(testString.substring(0,3));
             part.add(testString.substring(4,6));
            sresult=part[0]+'.'+part[1];
            result=decimal.valueof(sresult);
        }
        else if(testString.length()==8){
             part.add(testString.substring(0,1));
           part.add(testString.substring(2,5));
            part.add(testString.substring(6,8));
            sresult=part[0]+part[1]+'.'+part[2];
            result=decimal.valueof(sresult);
        }
        else if(testString.length()==9){
             part.add(testString.substring(0,2));
           part.add(testString.substring(3,6));
            part.add(testString.substring(7,9));
            sresult=part[0]+part[1]+'.'+part[2];
            result=decimal.valueof(sresult);
        }
        else if(testString.length()==10){
             part.add(testString.substring(0,3));
           part.add(testString.substring(4,7));
            part.add(testString.substring(8,10));
            sresult=part[0]+part[1]+'.'+part[2];
            result=decimal.valueof(sresult);
        }
         else if(testString.length()==12){
             part.add(testString.substring(0,1));
           part.add(testString.substring(2,5));
            part.add(testString.substring(6,9));
            part.add(testString.substring(10,12));
            sresult=part[0]+part[1]+part[2]+'.'+part[3];
            result=decimal.valueof(sresult);
        }
        return result;
    }*///added by steve on 12/28/2015. To handle currency formatt,e.g. $1,450.00, the range is from $0.00 up to $9,999,999,99.
    public static date dateSpliter(string dateText){
        string test=dateText.substring(0,2);
        integer year;
        integer day;
        integer month;
        if(dateText.length()==10){
        year=integer.valueOf(dateText.subString(6,10));
        day=integer.valueOf(datetext.substring(3,5));
        month=integer.valueOf(dateText.substring(0,2)); 
        }
         else if(dateText.length()==9){
                                                    if(test.contains('/')){
                                                          year=integer.valueOf(dateText.subString(5,9));
                                                     day=integer.valueOf(datetext.substring(2,4));
                                                     month=integer.valueOf(dateText.substring(0,1));
                                             
                                                    }
                                                    else{
                                                         year=integer.valueOf(dateText.subString(5,9));
                                                     day=integer.valueOf(datetext.substring(3,4));
                                                     month=integer.valueOf(dateText.substring(0,2));
                                                
                                                    }
                                                }
         else if (dateText.length()==8){
                                                    if(test.contains('/')){
                                                     year=integer.valueOf(dateText.subString(4,8));
                                                     day=integer.valueOf(datetext.substring(2,3));
                                                     month=integer.valueOf(dateText.substring(0,1));
                                                    }
         }
        date result=date.newInstance(year, month, day);
        return result;
       
    }//Added by steve on 12/28/2015. Handle different formatting issues, e.g. MM/DD/YYYY 
}