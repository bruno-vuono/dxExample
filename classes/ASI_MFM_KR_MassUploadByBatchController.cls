public with sharing class ASI_MFM_KR_MassUploadByBatchController {
    //Attributes
    public string ObjAPIName {set;get;}
    public string ActivateTime {set;get;}
    public string parentID {set;get;}
    public string parentField {set;get;}
    public string fields {set;get;}
    public string fieldsLabel {set;get;}
    public string lookupEXID {set;get;}
    public string template {set;get;}
    public string PanelName {set;get;} 
    public string report{set;get;}
    public string recordtypeName {set;get;}
    public string currentPageURL {set;get;}
    public boolean inlineVF {set;get;}
    public Boolean reloadNeeded {get; set;}
    public string defaultValues {set;get;}
    public string recEXID {set;get;}
    public string recEXIDcol {set;get;} 
    public string parentObjectAPIName {set;get;}
    public string ParentObjectUploadMsg {set;get;}
    
    public boolean upsertMode {set;get;}
    public boolean batchMode {set;get;}
    public boolean opt_allOrNone{set;get;}    
    public boolean emailNotification {set;get;}
    // a dummy variable to invoke init() method
    public Boolean dummyVar { get { if (dummyVar != true) {init();} return dummyVar; } set; }
    
    Public Boolean offsetPayment{Set; Get;}//20180111 Introv
    
    public string objName {set;get;} 
    public string nameFile {set;get;}
    public integer fileSize {set;get;}
    
    public string Msg {set;get;}
    
    public Blob contentFile {set;get;}
    
    public string currentPageURLOutput {set;get;}
    private Schema.SObjectType ObjType;
    private list<String> LFieldAPIName; 
    private list<String> LFieldLabel; 
    private map<string,string> MAPINameLabel;
    private list<Row> LInputRow;
    public list<Row> LOutputRow {set;get;} 
    public list<Row> LErrorRows {set;get;} 
    private list<lookupRecord> LLookupField;
    private map<string,integer> MFieldPos;
    private map<string,integer> MLookupFieldPos;
    private transient map<string,id> MRecTypeID; 
    public boolean hasError {set;get;}
    public string msgEmail {set;get;}
    private id recordtypid;
    private list<string> LDefaultVales;
    private list<string> LDefaultValesHeader;
    
    private Integer rowCount;
    private Integer colCount;
    
    public Id BatchId {get;set;}
    public Id AttId {get;set;}
    private string HeaderId; 
    
    public ASI_MFM_KR_MassUploadByBatchController(){
      
    }

    
    public void init(){
        /*if(inlineVF){
            currentPageUrlOutput = currentPageUrl;
        }
        else*/
        msgEmail = 'Result should appear here...';
        if(emailNotification){
            msgEmail = 'Email Notification will be sent when upload process is completed';
        }
        ObjType = Schema.getGlobalDescribe().get(ObjAPIName);
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
        
        hasError = false;
        //msg = '';
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
    
    public void uploadCSVByBatch(){
        system.debug('See currentPageURL : '+currentPageURL );
        
        System.debug('fileSize'+fileSize);
        if(fileSize <= 5242880){ //Fix for 5MB size limit
            //init();
            if(currentPageURL == '' || currentPageURL == null || (ObjAPIName == 'ASI_MFM_Purchase_Request_Line__c' && recordtypeName == 'KR Purchase Request Line')||
             (ObjAPIName == 'ASI_MFM_Payment_Line_Item__c' && recordtypeName == 'KR Payment Line Item') ){
                if((ObjAPIName == 'ASI_MFM_Purchase_Request_Line__c' && recordtypeName == 'KR Purchase Request Line') || (ObjAPIName == 'ASI_MFM_Payment_Line_Item__c' && recordtypeName == 'KR Payment Line Item')){
                     HeaderId = currentPageURL;
                }else{
                    HeaderId='';
                }
               
                
                //Mass upload log for page without header
                ASI_MFM_Mass_Upload_Log__c uploadLog = new ASI_MFM_Mass_Upload_Log__c();
                insert uploadLog;
                currentPageURL = uploadLog.id;
            }
            if(namefile.toLowerCase().right(3)=='csv'){
                Attachment att = new Attachment(ParentId = currentPageURL, name = namefile, body=contentFile, ContentType ='text/plain; charset=ks_c_5601-1987'); //ks_c_5601-1987
                //Attachment att = new Attachment(ParentId = currentPageURL, name = namefile, body=contentFile, ContentType ='text/plain; charset=UTF-8');
                //  Attachment att = new Attachment(ParentId = currentPageURL, name = namefile, body=contentFile, ContentType ='text/plain; charset=GB2312'); 
                 system.debug('Test ActivateTime '+ActivateTime);
                insert att;
                msg = 'executeBatch';
                
                BatchId = Database.executeBatch(new ASI_MFM_KR_MassUploadProcess(ObjAPIName, parentID, parentField, fields, fieldsLabel, lookupEXID, recordtypeName, 
                    defaultValues, currentPageURL, att.id, recEXID, recEXIDcol, parentObjectAPIName, ParentObjectUploadMsg,
                    upsertMode, emailNotification, opt_allOrNone,ActivateTime,HeaderId, offsetPayment),1);
                
                AttId = att.id;
                msg = 'Batch Started';
            }
            else{
                    msg = 'Error: Please select csv file only!';
                }
        }
        else{
            msg = 'Error: File too large';
        }
 
    }
    
    public string[] StatusMsgs {
        get {
            string s = msg==null? '': msg;
            if(BatchId!=null) {
                list<AsyncApexJob> aajs = [SELECT Id, Status, ExtendedStatus FROM AsyncApexJob WHERE ID =: BatchId ];
                if(aajs.size()>0) {
                    s = aajs[0].Status;
                    if((aajs[0].Status=='Completed' && AttId!=null)  || Test.isRunningTest() ) {
                        if(aajs[0].ExtendedStatus!=null && aajs[0].ExtendedStatus=='First error: Regex too complicated'){
                            s='Upload Failed. The file is too large, please cut the file sizes down';
                        }else{
                            Attachment att = [SELECT Id, description FROM Attachment WHERE ID =:AttId];
                            if(att.description!=null){
                                s = att.description;
                            }   
                        }
                        
                    }
                }
            }
            return s.split('\n');
        }
    }
    
    // Non Batch mode with case-sensitive lookup
    public void uploadCSV(){

        //return;
        System.debug('File Size: '+fileSize);
        if(fileSize <= 140000){
            msg = '';
            init();
            reloadNeeded = false;
            LErrorRows = new list<Row>();
            system.debug('File Name: '+namefile);
            if(namefile.toLowerCase().right(3)=='csv'){
                list<list<String>> parsedCSV = genResults();
                list<String> LHeader = new list<String>();
                
                if(parsedCSV != null && parsedCSV.size()>0){
                    // retrieve header of csv
                    LHeader = addDefaultValues(parsedCSV[0],true);                  
                    parsedCSV.remove(0);
                    system.debug('LHeader: ' + LHeader);
                    integer i = 0;
                    for(List<String> LS : parsedCSV){
                        LS = addDefaultValues(LS,false);
                    }
                    MFieldPos = new map<string,integer>();
                    for(string h : LHeader){
                        MFieldPos.put(h.toLowerCase().trim(),i);
                        i++;
                        system.debug('MFieldPos' + MFieldPos + h);
                    }
                    
                    LLookupField = new list<lookupRecord>();
                    MLookupFieldPos = new map<string,integer>();
                    system.debug('lookupEXID: ' +lookupEXID);
                    if(lookupEXID != '' && lookupEXID != null){
                        for(string s : lookupEXID.split(';',0)){
                            lookupRecord tempLookupRecord = new lookupRecord(s);
                            LLookupField.add(tempLookupRecord);
                            system.debug('input string ' + s);
                            system.debug('templookuprecord: ' + templookuprecord);
                            MLookupFieldPos.put(tempLookupRecord.field,LLookupField.size()-1);
                        }
                    }
                    for(lookupRecord lookupField : LLookupField){
                        for(List<String> LS : parsedCSV){
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
                    for(string fieldname : LFieldAPIName){
                       
                        	MFieldType.put(fieldname,ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase());
                         
                    }
                    for(List<String> LS : parsedCSV){
                        // Start Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
                        Row r;                                          
                        if (parentField!= null && parentID!= null)
                            r = new row(ObjType.newSObject(), parentField, parentID);
                        else
                            r = new row(ObjType.newSObject());
                        // End Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
                        
                        if(recordtypid != null)  { r.sObj.put('recordtypeid',recordtypid);}
                        
                        Integer inputCol = 0;
                        system.debug('LS: ' + LS);
                        for(string fieldname : LFieldAPIName){
                            string labelname = MAPINameLabel.get(fieldname);
                            system.debug('MFieldPos'+MFieldPos);
                            system.debug('MFieldPosLabel'+labelname+MFieldPos.containsKey(labelname));
                            system.debug('MLookupFieldPos'+MLookupFieldPos);
                            system.debug('label'+labelname+'/'+MLookupFieldPos.containsKey(fieldname));
                            if(MLookupFieldPos.containsKey(fieldname)){
                                system.debug('Lookup Field:' + fieldname);
                                system.debug('MLookupFieldPos '+MLookupFieldPos);
                                system.debug('MLookupFieldPos.get(fieldname)'+MLookupFieldPos.get(fieldname));
                                if(matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID) == null){
                                    system.debug(matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID));
                                    r.addError(labelname + ': Cannot find record');
                                    hasError = true;
                                }
                                try{r.sObj.put(fieldname, matchLookupField(MLookupFieldPos.get(fieldname),LS,MFieldPos, MRecTypeID));}
                                catch(exception e){
                                    r.addError(labelname + ': Cannot find record');
                                    hasError = true;
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
                                        if(LS[MFieldPos.get(labelname)].toLowerCase().trim()=='y'||LS[MFieldPos.get(labelname)].trim()=='1'){
                                            try{r.sObj.put(fieldname, true);}
                                            
                                            catch(exception e){
                                                r.addError(labelname + ': ' + e.getMessage());
                                                hasError = true;
                                            }
                                        }
                                        else{
                                            try{r.sObj.put(fieldname, false);}
                                            
                                            catch(exception e){
                                                r.addError(labelname + ': ' + e.getMessage());
                                                hasError = true;
                                            }
                                        }
                                            
                                    }
                                    //else if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='date'){
                                    else if(tempFieldType=='date'){
                                        try{r.sObj.put(fieldname, date.valueof(LS[MFieldPos.get(labelname)]));}
                                        
                                            catch(exception e){
                                                r.addError(labelname + ': ' + e.getMessage());
                                                hasError = true;
                                            }
                                    }
                                    //else if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='double' ||
                                    //    ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='percent' ||
                                    //    ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='currency'
                                    //){
                                    else if(tempFieldType=='double' ||
                                        tempFieldType=='percent' ||
                                        tempFieldType=='currency'
                                    ){
                                        try{r.sObj.put(fieldname, decimal.valueof(LS[MFieldPos.get(labelname)]));}
                                            catch(exception e){
                                                    r.addError(labelname + ': ' + e.getMessage());
                                                    hasError = true;
                                            }
                                    }
                                    //else if(ObjType.getDescribe().fields.getMap().get(fieldname).getDescribe().getType().name().toLowerCase()=='integer'){
                                    else if(tempFieldType=='integer'){
                                        try{r.sObj.put(fieldname, integer.valueof(LS[MFieldPos.get(labelname)]));}
                                            catch(exception e){
                                                r.addError(labelname + ': ' + e.getMessage());
                                                hasError = true;
                                            }
                                    }
                                    else{
                                        try{r.sObj.put(fieldname, LS[MFieldPos.get(labelname)]);}
                                            catch(exception e){
                                                r.addError(labelname + ': ' + e.getMessage());
                                                hasError = true;
                                            }
                                    }
                                }
                                    
                                
                            }
                        }
                        r.rowNumber = rowNumber++;
                        if(r.errorMsg != ''){ LErrorRows.add(r);}
                        LInputRow.add(r);
                    }
                    list<sObject> lRecInsert = new list<sobject>();
                    if(!hasError){
                        for(Row r : LInputRow){
                            if(r.errorMsg == ''){
                                lRecInsert.add(r.sObj);
                            }
                        }
                        if(lRecInsert != null && lRecInsert.size()>0){
                            try{
                                insert lRecInsert;
                                msg = 'Import Success! ' + string.valueof(lRecInsert.size()) + ' record(s) imported.';
                                if(inlineVF)
                                    refreshPage2();
                                else refreshPage();
                            }
                            catch(exception e){
                                system.debug('error'+e);
                                hasError = true;
                                
                                for(integer j =0;j<e.getNumDml();j++){
                                    //debug += 'fieldname: ' + e.getDmlFieldNames(j)+'|';
                                    //debug += 'index: ' + e.getDmlIndex(j)+'|';
                                    LInputRow[j].addError(e.getDmlMessage(j));
                                    LErrorRows.add(LInputRow[j]);
                                    //debug += 'statuscode: ' + e.getDmlStatusCode(j)+'|';
                                }
                                msg = '';
                                
                                //e.getMessage();
                            }
                        }
                    }
                    
                    
                }
            }
            else{
                msg = 'Error: Please select csv file only!';
            }
        }
        else{
            msg = 'Error: File too large';
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
            if(mfpos.containsKey(label)){
                if(label.contains('recordtype')){
                    string tempKey = LLookupField[pos].objectName.toLowerCase() + ls[mfpos.get(label)].toLowerCase();
                    system.debug('MRecTypeID'+MRecTypeID);
                    system.debug('MRecTypeID.containsKey(tempKey)'+tempKey+'/'+MRecTypeID.containsKey(tempKey));
                    if(MRecTypeID.containsKey(tempKey)){ key += MRecTypeID.get(tempKey);}
                }
                else{key += ls[mfpos.get(label)];}
            }
        }
        system.debug(key);
  
        return LLookupField[pos].genid(key);
    }
    
    public pageReference refreshPage(){
        system.debug(currentPageURL);
        return ApexPages.currentPage();
    }
    
    public void refreshPage2(){
        reloadNeeded = true;
        {
            currentPageUrlOutput = URL.getSalesforceBaseUrl().toExternalForm() + '/' + currentPageUrl;
        }
        system.debug(ApexPages.currentPage().geturl());
        //currentpageurl = ApexPages.currentPage().geturl();
    }
    
    private List<List<String>> genResults() {
        List<List<String>> parsedCSV = new List<List<String>>();
        rowCount = 0;
        colCount = 0;
        if (contentFile != null){
            String fileString = contentFile.toString();
            
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
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            //lines = contents.split('\n'); //correction: this only accomodates windows files
            lines = contents.split('\r'); // using carriage return accomodates windows, unix, and mac files
            //http://www.maxi-pedia.com/Line+termination+line+feed+versus+carriage+return+0d0a
        } catch (System.ListException e) {System.debug('Limits exceeded?' + e.getMessage()); }
        Integer num = 0;
        for(String line: lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field: fields) {
                
                if (field.startsWith('"') && field.endsWith('"') && field.length()>1) { cleanFields.add(field.replaceAll('"','').replaceAll('DBLQT','"'));}
                else if (field.startsWith('"')  && !makeCompositeField) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"') && makeCompositeField) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('"','').replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                    system.debug('composite field2:'+compositeField.replaceAll('"','').replaceAll('DBLQT','"'));
                } else if (makeCompositeField) { compositeField +=  ',' + field;
                } else {cleanFields.add(field.replaceAll('"','').replaceAll('DBLQT','"'));
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
                        if(MRecTypeID.containsKey(key)){ LkeyFilter[MFieldLabelKeyFilter.get(label)].add(MRecTypeID.get(key));}
                    }
                    else{LkeyFilter[MFieldLabelKeyFilter.get(label)].add(ls[Mpos1.get(label)].trim()); }
                }
            }
 
        }
        
        public void queryResult(){
   
            soql = 'Select id ';
            for(String label : MFieldLabel.keySet()){soql += ',' + MFieldLabel.get(label);}
            soql += ' from ' + objectName;
            if(MFieldLabel.keySet().size()>0){soql += ' where id != null ';}
            Set<String> setFilter1;
            Set<String> setFilter2;
            Set<String> setFilter3;
            Set<String> setFilter4;
            for(String label : MFieldLabel.keySet()){
                //soql += ' and ' + MFieldLabel.get(label) + ' IN :LkeyFilter[MFieldLabelKeyFilter.get(label)]';
                soql += ' and (';
                system.debug('MFieldLabelKeyFilter '+MFieldLabelKeyFilter);
                for(string s : LkeyFilter[MFieldLabelKeyFilter.get(label)]){
                    soql += MFieldLabel.get(label) + ' = \'' + s + '\'  or ';
                }
                soql = soql.substring(0,soql.length()-5);
                if(LkeyFilter[MFieldLabelKeyFilter.get(label)].size()>0)
                    soql += ' ) ';
                
            }
            system.debug('soql'+soql);
            if(test.isRunningTest()){
                soql += ' limit 1';
            }
            list<sObject> LResult = database.query(soql);
            system.debug('LResult'+LResult);
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
    
    public class Row{
        public Integer rowNumber {set;get;}
        public sObject sObj {set;get;}
        public string errorMsg {set;get;}
        
        // Start Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
        public row(sObject obj){
            sObj = obj;            
            errorMsg = '';
        }
        // End Update by Howard Au (Introv)@18 Mar 2014 to handle if Parent Field and Field ID is null
        
        public row(sObject obj, string parentField, string parentID){
            sObj = obj;
            sObj.put(parentField,parentID);
            errorMsg = '';
        }
        public void addError(string errMsg){
            errorMsg = errMsg;
        }
    }
    
    

    
    
}