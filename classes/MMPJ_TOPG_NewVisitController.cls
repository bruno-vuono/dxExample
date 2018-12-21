public with sharing class MMPJ_TOPG_NewVisitController {
    public MMPJ_TOPG_Meeting__c Meeting{
        get;
        set{
            if(this.Meeting == null){
                this.Meeting = value;
                LoadVisits(); 
            }
        }
    }    
    
    //Validated by SJ
    public boolean displayVisitPopUp {get;set;} //Visit Popup Panel
    public boolean NewOutlet {get;set;} //New Outlet Popup (displayVisitPopUp = true)
    public Boolean ShowBenchmark {get;set;} //Benchmark Panel
    public list<MMPJ_TOPG_Visit__c> ListVisits {get;set;}
    public Id delVisitId{get;set;}
    public Id editVisitId{get;set;}
    public MMPJ_TOPG_Outlet__c outletPopup {get;set;} //New Outlet
    public MMPJ_TOPG_Visit__c visitPopup { //New or edit Visit
        get{
        system.debug('editVisitId =='+editVisitId );
            if(editVisitId != null){
                for(MMPJ_TOPG_Visit__c visit : ListVisits){
                system.debug('visit =='+visit );
                system.debug('visit =='+ListVisits);
                    if(visit.Id == editVisitId){
                        visitPopup = visit;                        
                        break;
                    }
                }
            }
           
            system.debug('visit after==');
            if(meeting!=null && Meeting.MMPJ_TOPG_BMC__r!=null) 
                //BTO => begin : BMC is now the Market
            //visitPopup.MMPJ_TOPG_Market__c = Meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Market__c;
            visitPopup.MMPJ_TOPG_BMC__c = Meeting.MMPJ_TOPG_BMC__c;
            //BTO => end : BMC is now the Market
            system.debug('visit after2=='+visitPopup);
            return visitPopup ;
        }
        set;
    }
    
    public Id SelectedRadioId{get;set;}
    public MMPJ_TOPG_Visit__c PicsComVisit { //Pics
        get{
            if(SelectedRadioId != null){
                for(MMPJ_TOPG_Visit__c visit : ListVisits){
                    if(visit.Id == SelectedRadioId){
                        PicsComVisit = visit;
                        break;
                    }
                }
            }
            else
                PicsComVisit = null;
            return PicsComVisit;
        }
        set;
    }
    public string tempRichText{get;set;}        
    
    public MMPJ_TOPG_NewVisitController(){
        displayVisitPopUp = false;
        NewOutlet =false;        
        ShowBenchmark = false;
    }
    
    public void LoadVisits()
    {
        if(Meeting != null && Meeting.Id != null){
            system.debug('Visit Controller');
           
            //Error =false; //TOCHECK
            visitPopup = new MMPJ_TOPG_Visit__c ();
            outletPopup = new MMPJ_TOPG_Outlet__c();
            
            ListVisits  =[SELECT Id, Name, MMPJ_TOPG_Outlet__c, MMPJ_TOPG_PICTURE_LOAD__c, MMPJ_TOPG_Comments__c, MMPJ_TOPG_StatementDate__c, 
                            MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Email__c,MMPJ_TOPG_Outlet__r.MMPJ_TOPG_ContactName__c,MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Partner__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Partner__r.name, MMPJ_TOPG_Outlet__r.name, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Adress__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_City__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Country__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_DescriptionPictures__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Street__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_VisitDate__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Visitor__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_Channel__c, MMPJ_TOPG_Outlet__r.MMPJ_TOPG_OutletCategory__c,MMPJ_TOPG_Outlet__r.MMPJ_TOPG_OutletType__c, 
                            MMPJ_TOPG_OutletContact__c, MMPJ_TOPG_MMPJVisitor__c, MMPJ_TOPG_Market__c,MMPJ_TOPG_Bench_Currency__c
                          FROM MMPJ_TOPG_Visit__c
                          Where MMPJ_TOPG_Meeting__c=:Meeting.Id];
                                  
            if(ListVisits.size() > 0){
                SelectedRadioId = ListVisits.get(0).Id;            
            }
            else
                SelectedRadioId = null;
        }
    }
    
    public pagereference ShowVisitPopup()
    {        
        displayVisitPopUp =true;
        NewOutlet =false;
        editVisitId = null;
        outletPopup = new MMPJ_TOPG_Outlet__c();
        visitPopup = new MMPJ_TOPG_Visit__c();
        system.debug('UserInfo==='+ UserInfo.getUserId());
        visitPopup.MMPJ_TOPG_MMPJVisitor__c = UserInfo.getUserId();
        return null;
    }
    
    public pagereference EditVisit()
    {
        displayVisitPopUp = true;  
        NewOutlet = false;
        return null;
    }
    
    public pagereference hideVisitPopup()
    {
        displayVisitPopUp = false;  
        NewOutlet = false;
        return null;
    }
    
    public pagereference hideOutletPopup()
    {
        displayVisitPopUp = true;  
        NewOutlet = false;
        return null;
    }
    
    public pagereference NewOultetPopup()
    {
        outletPopup.MMPJ_TOPG_Visitor__c = UserInfo.getUserId() ;  
        NewOutlet =true;
        return null;
    }
    
    //Load Outlet Name and Address    
    public void AutomatePartnerFunction()
    {
        system.debug('###visitPopup: ' + visitPopup);
        system.debug('###visitPopup.MMPJ_TOPG_Outlet__c: ' + visitPopup.MMPJ_TOPG_Outlet__c);
        if(visitPopup.MMPJ_TOPG_Outlet__c != null){
            list<MMPJ_TOPG_Outlet__c> listOutletsdumy = [SELECT id,MMPJ_TOPG_Partner__r.Name, MMPJ_TOPG_Adress__c,MMPJ_TOPG_Email__c,MMPJ_TOPG_ContactName__c
                                                         FROM MMPJ_TOPG_Outlet__c
                                                         WHERE id =:visitPopup.MMPJ_TOPG_Outlet__c ];
            if(listOutletsdumy.size() > 0){
                visitPopup.MMPJ_TOPG_Outlet__r = listOutletsdumy[0];
            }
        }
            system.debug('#### OutletPartner :' + visitPopup.MMPJ_TOPG_Outlet__r );
    }
    
    //DML Operations
    public pagereference SaveVisit()
    {
                system.debug('### SaveVisit');
        try{
                
                visitPopup.MMPJ_TOPG_BMC__c = Meeting.MMPJ_TOPG_BMC__c;
                visitPopup.MMPJ_TOPG_Meeting__c = Meeting.Id;
                upsert visitPopup;        
                LoadVisits();
                
                displayVisitPopUp = false;
                NewOutlet = false;
                editVisitId = null;
        }
        catch(Exception ex){
                HandleException(ex);
        }
        return null;
    }
    
    public PageReference SaveNewVisit() {       
        system.debug('### SaveNewVisit');
        try{
        
                visitPopup.MMPJ_TOPG_BMC__c = Meeting.MMPJ_TOPG_BMC__c;
                visitPopup.MMPJ_TOPG_Meeting__c = Meeting.Id;
                upsert visitPopup;   
                LoadVisits();
                displayVisitPopUp = true;
                NewOutlet = false;
                editVisitId = null;
        }
        catch(Exception ex){
                HandleException(ex);
        }
        return null;    
    }

    public PageReference SaveOutlet() {
        system.debug('### SaveOutlet');
        try{     
                //BTO => Begin : Supp market in BMC. Use BMC like Market ?
               // outletPopup.MMPJ_TOPG_Market__c = Meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Market__c;
                //BTO => End : Supp market in BMC. Use BMC like Market ?
                insert outletPopup;   
                displayVisitPopUp = true;
                NewOutlet = false;
                
                
                visitPopup.MMPJ_TOPG_Outlet__c = outletPopup.Id;
                AutomatePartnerFunction();
                outletPopup = new MMPJ_TOPG_Outlet__c();
        }
        catch(Exception ex){
                HandleException(ex);
        }
        return null;
    }


    public PageReference SaveNewOutlet() {
        system.debug('### SaveNewOutlet');
        try{
            //BTO => Begin : Supp market in BMC. Use BMC like Market ?
               // outletPopup.MMPJ_TOPG_Market__c = Meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Market__c;
                //BTO => End : Supp market in BMC. Use BMC like Market ?
                insert outletPopup; 
                displayVisitPopUp = true;
                NewOutlet = true;  
                outletPopup = new MMPJ_TOPG_Outlet__c();
        }
        catch(Exception ex){
                HandleException(ex);
        }
        return null;
    }

    
    //Delete Visits
    public void DelVisit()
    {
        if(delVisitId != null){
            delete new MMPJ_TOPG_Visit__c (Id = delVisitId);
            delVisitId = null;
            LoadVisits();
        }        
    }
    
    /*public PageReference Cancel() {
        return new Pagereference('/' + Bmc.id);
    }*/
    
    //Save Visit Comment
    public PageReference saveComment() {
                try{
                update PicsComVisit;
                }
                catch(Exception ex){
                        HandleException(ex);
                }
        return null;
    }  
    
    public void HandleException(Exception ex){
        string errormsg = '';
        if(ex.getTypeName() == 'DmlException' && ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            errormsg = ex.getMessage();
            errormsg = errormsg.split(':')[2];
        }
        //else
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , errormsg));
    }     
}