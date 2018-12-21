public class MMPJ_TOPG_ProjectDescriptionController 
{
    public list<SelectOption> AllMarket{get;set;}
    public list<SelectOption> SelectedMarket{get;set;}
    public list<SelectOption> AllBrand{get;set;}
    public list<SelectOption> SelectedBrand{get;set;}
    public list<SelectOption> AllProduct{get;set;}
    public list<SelectOption> AllProductFiltred{get;set;}
    public list<SelectOption> SelectedProduct{get;set;}
    private list<MMPJ_TOPG_Project_Market__c> listSelectedMarket {get;set;}
    private list<MMPJ_TOPG_Project_Brand__c> listSelectedBrand {get;set;}
    private list<MMPJ_TOPG_Project_Product__c> listSelectedProduct {get;set;}
    private Map<id,string> MapIdSelected{get;set;}
    public list<WrapperProjectTeamList> ListWrapperProjectTeam {get;set;}
    public Map<String,MMPJ_TOPG_ProjectTeamMember__c> MapCurrentProjectTeamMember {get;set;} 
    public integer saveComp{get;set;}
    //public Map<ID, Contact> ContactsMap {get;set;}
    public boolean isNewProject {get;set;}
    public Integer rowToRemove {get;set;}
    public Integer SizeMultipicklist {get;set;}
    public MMPJ_TOPG_Project__c project{get;
     set {
            if (project==null){
                this.project=value;
                DescriptionConstructor();
            }
      }
      
     }
    private integer ShowSaveMessage_oldCounter = 0;
    private integer ShowSaveMessage_newCounter = 0;
    public boolean ShowSaveMessage{
        get{
            if(ShowSaveMessage_newCounter > ShowSaveMessage_oldCounter){
                ShowSaveMessage = true;
                ShowSaveMessage_newCounter = ShowSaveMessage_oldCounter;
            }
            else
                ShowSaveMessage = false;

            return ShowSaveMessage;
        }
        set;
    }
      public MMPJ_TOPG_ProjectDescriptionController()
    {
     system.debug ('in constructor ====');
      saveComp =0;
      isNewProject =false;
    }

    public void DescriptionConstructor()
    {
        
        isNewProject =false;
        AllMarket = new list<selectoption>();
        AllProductFiltred = new list<selectoption>();
        AllBrand = new list<selectoption>();
        AllProduct = new list<selectoption>();
        SelectedMarket =new list<selectoption>();
        SelectedBrand = new list<selectoption>();
        SelectedProduct = new list<selectoption>();
        system.debug ('SelectedProduct  ==== '+SelectedProduct);
        listSelectedMarket =new list<MMPJ_TOPG_Project_Market__c >();
        listSelectedBrand = new list<MMPJ_TOPG_Project_Brand__c>();
        listSelectedProduct = new list<MMPJ_TOPG_Project_Product__c >();
        MapIdSelected = new Map<id,string>();
        system.debug ('project ===='+project);
        if(project.id != null)
        {
            listSelectedMarket = [select id,MMPJ_TOPG_Market__r.name from MMPJ_TOPG_Project_Market__c where MMPJ_TOPG_Project__c =:project.id];
            listSelectedBrand = [select id,MMPJ_TOPG_Brand__r.name from MMPJ_TOPG_Project_Brand__c where MMPJ_TOPG_Project__c =:project.id];
            listSelectedProduct = [select id,MMPJ_TOPG_Product__r.name from MMPJ_TOPG_Project_Product__c where MMPJ_TOPG_Project__c =:project.id];
            system.debug ('listSelectedMarket ===='+listSelectedMarket);
            system.debug ('listSelectedBrand ===='+listSelectedBrand);
            system.debug ('listSelectedProduct ===='+listSelectedProduct);
            system.debug ('project.id ===='+project.id);
            for(MMPJ_TOPG_Project_Market__c PM : listSelectedMarket)
            {
                SelectedMarket.add(new SelectOption(PM.MMPJ_TOPG_Market__c, PM.MMPJ_TOPG_Market__r.Name));
                MapIdSelected.put(PM.MMPJ_TOPG_Market__c,PM.id);
            }
            for(MMPJ_TOPG_Project_Brand__c PB : listSelectedBrand )
            {
                SelectedBrand.add(new SelectOption(PB.MMPJ_TOPG_Brand__c, PB.MMPJ_TOPG_Brand__r.Name));
                MapIdSelected.put(PB.MMPJ_TOPG_Brand__c,PB.id);
            }
            for(MMPJ_TOPG_Project_Product__c PP : listSelectedProduct )
            {
                SelectedProduct.add(new SelectOption(PP.MMPJ_TOPG_Product__c, PP.MMPJ_TOPG_Product__r.Name));
                MapIdSelected.put(PP.MMPJ_TOPG_Product__c,PP.id);
            }
        }
        system.debug('$$$$$$$ MapIdSelected ' + MapIdSelected );
        for(MMPJ_TOPG_Market__c M : [select id ,name from MMPJ_TOPG_Market__c])
        {
            if(MapIdSelected.containskey(M.Id))
                continue;
            AllMarket.add(new SelectOption(M.Id, M.Name));
        }
        for(MMPJ_TOPG_BRAND__c B : [select id ,name from MMPJ_TOPG_BRAND__c])
        {
            if(MapIdSelected.containskey(B.Id))
                continue;
            AllBrand.add(new SelectOption(B.Id, B.Name));
        }
 
      for(MMPJ_TOPG_ProductMix__c P : [select id ,name from MMPJ_TOPG_ProductMix__c])
        {
            if (selectedBrand.size()>0){
            setDefaultProducts();
            /*if (selectedProduct.size()>0){
             for (integer i = 0; i<selectedProduct.size();i++){
                 
             }
            }*/
            }
            else {
            if(MapIdSelected.containskey(P.Id))
                continue;
            AllProduct.add(new SelectOption(P.Id, P.Name));
            }
        } 
       
  
        SizeMultipicklist =  AllMarket.size();
        if(SizeMultipicklist < AllBrand.size())
            SizeMultipicklist = AllBrand.size();
        if(SizeMultipicklist < AllProduct.size())
            SizeMultipicklist = AllProduct.size();
        if(SizeMultipicklist > 15)
            SizeMultipicklist = 15;
        
        
        ListWrapperProjectTeam =new list<WrapperProjectTeamList>();
        FillListTeamMember();
    }
    // Save Functions
    public pagereference SaveProject()
    {
        if(!VerifyFormRules())
            return null;
        UpsertProject();
        return null;
    }
    public pagereference SaveProjectAndClose()
    {
        if(!VerifyFormRules())
            return null;
        if(!UpsertProject())
            return null;
        return new PageReference('/aKV/o'); 
    }
    public void LeavingDescription()
    {
        if(!VerifyFormRules())
        {
            return;
            saveComp =0;
        }
        if(!UpsertProject())
        {
            return;
            saveComp=0;
        }
        saveComp = 1;
    }
    Public boolean UpsertProject()
    {
        Savepoint spProject = Database.setSavepoint();
        if (SelectedProduct == null)
        {
         SelectedProduct = new list<selectoption>();
        }
        try{
            if(Project.id == null)
                isNewProject =true;
            else
                isNewProject = false;
            upsert Project;
            
            list<MMPJ_TOPG_Project_Brand__c> ListProjectBrandToInsert = new List<MMPJ_TOPG_Project_Brand__c>();
            list<MMPJ_TOPG_Project_Market__c> ListProjectMarketToInsert = new List<MMPJ_TOPG_Project_Market__c>();
            list<MMPJ_TOPG_Project_Product__c> ListProjectProductToInsert = new List<MMPJ_TOPG_Project_Product__c>();
            list<MMPJ_TOPG_Project_Brand__c> ListProjectBrandToDelete = new List<MMPJ_TOPG_Project_Brand__c>();
            list<MMPJ_TOPG_Project_Market__c> ListProjectMarketToDelete = new List<MMPJ_TOPG_Project_Market__c>();
            list<MMPJ_TOPG_Project_Product__c> ListProjectProductToDelete = new List<MMPJ_TOPG_Project_Product__c>();
            for(selectoption Opt : SelectedMarket)
            {
                if(MapIdSelected.containskey(Opt.getValue()))
                    continue;
                MMPJ_TOPG_Project_Market__c PM = new MMPJ_TOPG_Project_Market__c();
                PM.MMPJ_TOPG_Market__c = Opt.getValue();
                PM.MMPJ_TOPG_Project__c = Project.id;
                ListProjectMarketToInsert.add(PM);
            }
            for(selectoption Opt : SelectedBrand)
            {
                if(MapIdSelected.containskey(Opt.getValue()))
                    continue;
                MMPJ_TOPG_Project_Brand__c PB = new MMPJ_TOPG_Project_Brand__c();
                PB.MMPJ_TOPG_Brand__c = Opt.getValue();
                PB.MMPJ_TOPG_Project__c = Project.id;
                ListProjectBrandToInsert.add(PB);
            }
            for(selectoption Opt : SelectedProduct)
            {
                if(MapIdSelected.containskey(Opt.getValue()))
                    continue;
                system.debug('%%%%% PP.getValue() ' + Opt.getValue());
                MMPJ_TOPG_Project_Product__c PP = new MMPJ_TOPG_Project_Product__c();
                PP.MMPJ_TOPG_Product__c = Opt.getValue();
                PP.MMPJ_TOPG_Project__c = Project.id;
                ListProjectProductToInsert.add(PP);
            }
            for(selectoption Opt : AllMarket)
            {
                if(MapIdSelected.containskey(Opt.getValue()))
                {
                    MMPJ_TOPG_Project_Market__c PM = new MMPJ_TOPG_Project_Market__c();
                    PM.id = MapIdSelected.get(Opt.getValue());
                    ListProjectMarketToDelete.add(PM);
                }
            }
            for(selectoption Opt : AllBrand)
            {
                if(MapIdSelected.containskey(Opt.getValue()))
                {
                    MMPJ_TOPG_Project_Brand__c PB = new MMPJ_TOPG_Project_Brand__c();
                    PB.id = MapIdSelected.get(Opt.getValue());
                    ListProjectBrandToDelete.add(PB);
                }
            }
            for(selectoption Opt : AllProduct)
            {
                if(MapIdSelected.containskey(Opt.getValue()))
                {
                    MMPJ_TOPG_Project_Product__c PP = new MMPJ_TOPG_Project_Product__c();
                    PP.id = MapIdSelected.get(Opt.getValue());
                    ListProjectProductToDelete.add(PP);
                }
            }
            system.debug('##### insert and delete lists');
            insert ListProjectBrandToInsert;
            insert ListProjectMarketToInsert;
            insert ListProjectProductToInsert;
            delete ListProjectBrandToDelete;
            delete ListProjectMarketToDelete;
            delete ListProjectProductToDelete;
            system.debug('##### END insert and delete lists');
            map<string,string> MapProjectTeamMemberDouble = new Map<string,string>();
            list<MMPJ_TOPG_ProjectTeamMember__c> ListMembers = new list<MMPJ_TOPG_ProjectTeamMember__c>();
            for(integer i=0 ; i< ListWrapperProjectTeam.size() ; i++)
            {
                string IdWho = '';
                if(ListWrapperProjectTeam[i].SelectValue == 'Contact')
                {
                    IdWho = ListWrapperProjectTeam[i].ProjectTeam.MMPJ_TOPG_Contact__c;
                    ListWrapperProjectTeam[i].ProjectTeam.MMPJ_TOPG_User__c =null;
                }
                else
                {
                    IdWho = ListWrapperProjectTeam[i].ProjectTeam.MMPJ_TOPG_User__c ;
                    ListWrapperProjectTeam[i].ProjectTeam.MMPJ_TOPG_Contact__c = null;
                }
                if(MapProjectTeamMemberDouble.containsKey(IdWho))
                {
                    ListWrapperProjectTeam.remove(i);
                    continue;
                }
                MapProjectTeamMemberDouble.put(IdWho,IdWho);
                if(MapCurrentProjectTeamMember.containsKey(IdWho))
                {
                    MapCurrentProjectTeamMember.remove(IdWho);
                    //ListWrapperProjectTeam.remove(i);
                }
                else
                {
                    ListWrapperProjectTeam[i].ProjectTeam.MMPJ_TOPG_Project__c = Project.id;
                    ListWrapperProjectTeam[i].ProjectTeam.name = ListWrapperProjectTeam[i].TeamMemberName;
                    MMPJ_TOPG_ProjectTeamMember__c ProjectDum = ListWrapperProjectTeam[i].ProjectTeam.clone(false,true);
                    ListMembers.add(ProjectDum);
                }
            }
            system.debug('$$$ ListMembers ' + ListMembers + ' &&&& MapCurrentProjectTeamMember ' + MapCurrentProjectTeamMember);
            if(MapCurrentProjectTeamMember.size() > 0)
                delete MapCurrentProjectTeamMember.values();
            if(ListWrapperProjectTeam.size() > 0)
                upsert ListMembers;
            project = [SELECT Id, Name, MMPJ_TOPG_Actuals__c,  MMPJ_TOPG_Brand__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_EndDate__c, MMPJ_TOPG_ForecastBudget__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Product__c, MMPJ_TOPG_ProjectOwner__c, MMPJ_TOPG_ProjectTopic__c, MMPJ_TOPG_ProjectType__c,MMPJ_TOPG_NewProjectType__c, MMPJ_TOPG_StartDate__c,MMPJ_TOPG_DelivAttachments__c,MMPJ_TOPG_ProjManagAttachments__c,owner.email
                            ,(SELECT Id, Name, MMPJ_TOPG_Contact__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_User__c, MMPJ_TOPG_Who__c FROM Project_Team_Members__r)
                            ,(SELECT Id, Name, MMPJ_TOPG_A__c, MMPJ_TOPG_C__c, MMPJ_TOPG_Date__c, MMPJ_TOPG_DeliverableDescription__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_I__c, MMPJ_TOPG_MilestoneTitle__c, MMPJ_TOPG_Project__c, MMPJ_TOPG_R__c, MMPJ_TOPG_RemainingTime__c, MMPJ_TOPG_MMPJ_Status__c, MMPJ_TOPG_Rank__c,MMPJ_TOPG_IsDefault__c  FROM Milestones__r ORDER BY MMPJ_TOPG_Rank__c)
                            ,(SELECT Id, Name,lastModifiedDate,createdBy.name,createdBy.id,ContentType from Attachments)
                            ,(SELECT Id, Name, MMPJ_TOPG_Brand__c, MMPJ_TOPG_Desc__c, MMPJ_TOPG_Description__c, MMPJ_TOPG_ExpectedDate__c, MMPJ_TOPG_Flag__c, MMPJ_TOPG_Highlight__c, MMPJ_TOPG_Market__c, MMPJ_TOPG_Meeting__c, MMPJ_TOPG_Meeting__r.name, MMPJ_TOPG_Project__c, MMPJ_TOPG_RAID__c, MMPJ_TOPG_Responsible__c, MMPJ_TOPG_Status__c, MMPJ_TOPG_Title__c, MMPJ_TOPG_Rank__c, MMPJ_TOPG_Contact__c, MMPJ_TOPG_User__c,MMPJ_TOPG_LineItem__c FROM RAIDs__r ORDER BY MMPJ_TOPG_Rank__c)
                       FROM MMPJ_TOPG_Project__c
                       WHERE Id =:project.Id
                       ];
        }catch(exception ex)
        {
            system.debug('####### TestException ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
            Database.rollback(spProject);
            return false;
        }
        ShowSaveMessage_newCounter++;
        DescriptionConstructor();
        return true;
    }
    public boolean VerifyFormRules()
    {
        if(Project.MMPJ_TOPG_ProjectType__c == 'Central Development')
        {
            if(!((SelectedMarket.size() == 1 && SelectedBrand.size() >= 1 ) || (SelectedMarket.size() >= 1 && SelectedBrand.size() == 1 ) ))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You can select one Brand and several Market or one Market and several Brand');
                ApexPages.addMessage(myMsg);
                return false;
            }
        }
        return true;
    }
    // Cancel
    public pagereference cancel()
    {
        PageReference Page = new PageReference('/aLs/o'); 
        return Page.setRedirect(true);
    }
    
    //Print PDF
    /*public PageReference PrintPDF(){
        try{
            if(!VerifyFormRules())
                return null;
            if(!UpsertProject())
                return null;
            PageReference page = new PageReference('/apex/VF01ProjectDescriptionPDF?ProjectId='+project.id);
            Blob pdfBLob = page.getcontentAsPdf();
            
            //insert attachment 
            Attachment att = new Attachment();
            att.body=pdfBLob;
            att.name='Attachment_Project_'+project.name+'.pdf';
            att.ContentType = 'application/pdf';
            att.parentId=project.id;
            insert att;
            
            // update Project
            if (att.id!=null){
                if(project.MMPJ_TOPG_DelivAttachments__c == null)
                    project.MMPJ_TOPG_DelivAttachments__c = att.id;
                else
                    project.MMPJ_TOPG_DelivAttachments__c = project.MMPJ_TOPG_DelivAttachments__c+';'+att.id ;
                update project;
            }
           
            List <MMPJ_TOPG_ProjectTeamMember__c> ListOfprojectTeams =[Select MMPJ_TOPG_Contact__r.email,MMPJ_TOPG_User__r.Email from MMPJ_TOPG_ProjectTeamMember__c
                                                                       where MMPJ_TOPG_Project__c=:project.id ];
            List<String> listTeamEmails = new List <String>();
            for (MMPJ_TOPG_ProjectTeamMember__c projectTeam : ListOfprojectTeams ){
                if(projectTeam.MMPJ_TOPG_Contact__c !=null && projectTeam.MMPJ_TOPG_Contact__r.email!=null){
                    listTeamEmails.add(projectTeam.MMPJ_TOPG_Contact__r.email); 
                }
                if(projectTeam.MMPJ_TOPG_User__c !=null && projectTeam.MMPJ_TOPG_User__r.email!=null){
                    listTeamEmails.add(projectTeam.MMPJ_TOPG_User__r.email); 
                }
            }                                                           
            sendEmail(att,project,listTeamEmails);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Attachment Record Created Successfully.'));
        }
        catch(exception ex)
        {
            system.debug('####### Exception ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        return null;
    } */
    public void SendEmail(Attachment att,MMPJ_TOPG_Project__c project,List<String> listTeamEmails){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String [] ToAddress = New String[]{};
        system.debug('listTeamEmails =='+ listTeamEmails);
        for (String theList :listTeamEmails){
            ToAddress.add(theList);
        }
        system.debug('ToAddress =='+ToAddress);
        message.toAddresses = ToAddress;
        String [] CCAddress = new String []{ };
        if(project.owner.Email != null)
            CCAddress.add(project.owner.Email);
        message.setCcAddresses(CCAddress);
        message.setHtmlBody('<b>Please find Informations in the Attachment</b>');
        message.subject = 'Informative Email';
        //for sending attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(att.name);
        efa.setBody(att.body);
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
         Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> {message};
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } 
        else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }    
    }
    // Project Team Functions 
    public void DelProjectTeam()
    {
        ListWrapperProjectTeam.remove(rowToRemove);
    }
    
    public  PageReference addProjectTeam()
    {
        WrapperProjectTeamList WrapperClass = new WrapperProjectTeamList();       
        WrapperClass.ProjectTeam = new MMPJ_TOPG_ProjectTeamMember__c();
        WrapperClass.SelectValue ='User';
        ListWrapperProjectTeam.add(WrapperClass);
        system.debug('##### ListWrapperProjectTeam ' +ListWrapperProjectTeam);
        return null ;
    }
    //Function automated
    public void FillListTeamMember(){
        MapCurrentProjectTeamMember = new Map<String,MMPJ_TOPG_ProjectTeamMember__c >(); 
        if (project.id !=null){
            List<MMPJ_TOPG_ProjectTeamMember__c> ListCurrentProjectTeamMember =[Select id,MMPJ_TOPG_Contact__c
                                                                                         ,MMPJ_TOPG_Project__c
                                                                                         ,MMPJ_TOPG_Title__c
                                                                                         ,MMPJ_TOPG_User__c
                                                                                         ,MMPJ_TOPG_Who__c 
                                                                                from MMPJ_TOPG_ProjectTeamMember__c 
                                                                                where MMPJ_TOPG_Project__c=:project.id ] ;
        
            for(MMPJ_TOPG_ProjectTeamMember__c Member: ListCurrentProjectTeamMember)
            {
               WrapperProjectTeamList WrapperClass = new WrapperProjectTeamList();       
               WrapperClass.ProjectTeam = new MMPJ_TOPG_ProjectTeamMember__c ();
               WrapperClass.ProjectTeam = Member;
               if( Member.MMPJ_TOPG_Contact__c != null)
               {
                   
                   WrapperClass.SelectValue ='Contact';
                   ListWrapperProjectTeam.add(WrapperClass);
                   MapCurrentProjectTeamMember.put(Member.MMPJ_TOPG_Contact__c ,Member);
               }
               else if( Member.MMPJ_TOPG_User__c != null )
               {
                   WrapperClass.SelectValue ='User';
                   ListWrapperProjectTeam.add(WrapperClass);
                   MapCurrentProjectTeamMember.put(Member.MMPJ_TOPG_User__c ,Member);
               } 
            }
            AutomateFunction();
        }
    }
    
    public void AutomateFunction()
    {
        List<String> ListIds = new List<String>();
        for(WrapperProjectTeamList Wrapp : ListWrapperProjectTeam)
        {
            if(Wrapp.SelectValue == 'User' && Wrapp.ProjectTeam.MMPJ_TOPG_User__c!= null)
                ListIds.add(Wrapp.ProjectTeam.MMPJ_TOPG_User__c);
            else if(Wrapp.SelectValue == 'Contact' && Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c != null)
                ListIds.add(Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c);
        }
        Map<ID, Contact> mContact = new Map<ID, Contact>([SELECT id,Title,email,name
                                                          FROM Contact
                                                          WHERE id IN : ListIds]);
        Map<ID, User> mUser = new Map<ID, User>([SELECT id,Title,email,name
                                                 FROM User
                                                 WHERE id IN : ListIds]);
        for(WrapperProjectTeamList Wrapp : ListWrapperProjectTeam)
        {
            Wrapp.TeamMemberName='';
            Wrapp.ProjectTeam.MMPJ_TOPG_Title__c = '';
            if(Wrapp.SelectValue == 'User' && Wrapp.ProjectTeam.MMPJ_TOPG_User__c!= null && mUser.containsKey(Wrapp.ProjectTeam.MMPJ_TOPG_User__c))
            {
                if(mUser.get(Wrapp.ProjectTeam.MMPJ_TOPG_User__c).Title != null)
                {
                    Wrapp.ProjectTeam.MMPJ_TOPG_Title__c = mUser.get(Wrapp.ProjectTeam.MMPJ_TOPG_User__c).Title;
                }
                Wrapp.TeamMemberName = mUser.get(Wrapp.ProjectTeam.MMPJ_TOPG_User__c).name;
            }
            else if(Wrapp.SelectValue == 'Contact' && Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c!= null && mContact.containsKey(Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c))
            {
                if(mContact.get(Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c).Title != null)
                {
                    Wrapp.ProjectTeam.MMPJ_TOPG_Title__c = mContact.get(Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c).Title;
                }
                Wrapp.TeamMemberName = mContact.get(Wrapp.ProjectTeam.MMPJ_TOPG_Contact__c).name;
            }
        }
    }
    public pageReference setDefaultProducts(){
    system.debug('in ======selectedBrand======');
    system.debug('in ====selectedProduct=========');
   
    AllProductFiltred.clear();
    if (selectedBrand.size()>0)
    {
    for (SelectOption sel :selectedBrand){
        String brandName= sel.getLabel().substring(0,3);
        for(MMPJ_TOPG_ProductMix__c prod:[select id ,name from MMPJ_TOPG_ProductMix__c]){
         if (prod.Name.contains(brandName)){
             AllProductFiltred.add(new selectOption(prod.Id,prod.Name));
         }
        } 
    }        
             
    }
    else{
        for(MMPJ_TOPG_ProductMix__c prod:[select id ,name from MMPJ_TOPG_ProductMix__c]){
             AllProductFiltred.add(new selectOption(prod.Id,prod.Name));
         
        } 
    }
            AllProduct.clear();
           AllProduct.addAll(AllProductFiltred);
            
    return null;
    }
    public class WrapperProjectTeamList
    {
        public string TeamMemberName{get;set;}
        public String SelectValue {get;set;}
        //public Integer index {get;set;}
        public MMPJ_TOPG_ProjectTeamMember__c ProjectTeam{get;set;}
    }
}