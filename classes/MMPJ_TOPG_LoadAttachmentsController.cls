public with sharing class MMPJ_TOPG_LoadAttachmentsController {
public Boolean isEditMode {get;set;}
public Id attachmentId {get;set;}
public MMPJ_TOPG_Project__c project{
        get;
        set{
            if(this.project == null){
                this.project = value;
                if(attachmenttype != null){
                    getLastAttachment();
                }
                
                //Seperate attachments
                FillListOfAttachments();
            }
        } 
    }
    public void FillListOfAttachments()
    {
    	system.debug('Project id ===' +project.id);
        if(project.id != null)
        {
            listAttachments = [SELECT Id, Name,lastModifiedDate,createdBy.name,createdBy.id,ContentType 
                               FROM Attachment 
                               WHERE ParentId =: project.id];
            Set <Id> setdelivIds = new Set <id>();
            Set <Id> setprojMangIds =new Set <id>();
            listDeliverablesAttach = new List<Attachment>();
            listProjMangAttach = new List<Attachment>();
            if (this.project.MMPJ_TOPG_DelivAttachments__c!=null)
                 setdelivIds = getAttIds(this.project.MMPJ_TOPG_DelivAttachments__c);
            if (this.project.MMPJ_TOPG_ProjManagAttachments__c!=null)
                 setprojMangIds = getAttIds(this.project.MMPJ_TOPG_ProjManagAttachments__c);   
            for (Attachment att : listAttachments){                           
                if (setdelivIds.contains(att.id)){
                    listDeliverablesAttach.add(att);
                }
                if (setprojMangIds.contains(att.id)) {
                    listProjMangAttach.add(att);
                }
            }
        }
    } 
    public PageReference deleteAttachment() {
         Attachment attachment = new Attachment();
         attachment.id=attachmentId;
         delete attachment; 
         FillListOfAttachments();
         return null;
    }  
     public PageReference addAttachmentDeliverables() {
         PageReference page = new PageReference('/p/attach/NoteAttach');
         String retURL ='/apex/MMPJ_TOPG_NewProject?id='+ project.id+'&TabName=Attachements&attchmenttype=del';
         String encreturl=EncodingUtil.URLEncode(retURL,'utf-8');
         page.getParameters().put('pid', project.id);
         page.getParameters().put('TabName','Attachements');
         page.getParameters().put('retURL', retURL);

       // PageReference redirect = new PageReference('/p/attach/NoteAttach?pid='+project.id+'&retURL=%2Fapex%2FMMPJ_TOPG_NewProject?id=' + project.id+ '%26TabName=Attachements%26attchmenttype=del%26core.apexpages.devmode.url%3D1');        
        return page.setRedirect(true);
    }
   
    public PageReference addAttachmentProjectManag() {   
        //URL Encode
         PageReference page = new PageReference('/p/attach/NoteAttach');
         String retURL ='/apex/MMPJ_TOPG_NewProject?id='+ project.id+'&TabName=Attachements&attchmenttype=pm';
         String encreturl=EncodingUtil.URLEncode(retURL,'utf-8');
         page.getParameters().put('pid', project.id);
         page.getParameters().put('TabName','Attachements');
         page.getParameters().put('retURL', retURL);
         //PageReference redirect = new PageReference('/p/attach/NoteAttach?pid='+projectId+'&retURL=%2Fapex%2FMMPJ_TOPG_NewProject?id=' + projectId + '%26TabName=Attachements%26attchmenttype=pm%26core.apexpages.devmode.url%3D1');
         return page.setRedirect(true);
      }
      
    public void getLastAttachment(){        
        system.debug ('in getLastAttachment ==');
        list<Attachment> listAtts = [select id from attachment where parentId=:projectId order by createdDate desc limit 1];
        
        if(listAtts.size() > 0 ){
            Attachment att = listAtts.get(0);
            if (project.MMPJ_TOPG_ProjManagAttachments__c ==null && attachmenttype == 'pm'){
            project.MMPJ_TOPG_ProjManagAttachments__c = att.Id;
            }
            else if (project.MMPJ_TOPG_ProjManagAttachments__c!=null && !project.MMPJ_TOPG_ProjManagAttachments__c .contains(att.Id) && attachmenttype == 'pm' ){
             project.MMPJ_TOPG_ProjManagAttachments__c = project.MMPJ_TOPG_ProjManagAttachments__c + ';'+att.Id;
            }
            if (project.MMPJ_TOPG_DelivAttachments__c==null && attachmenttype == 'del'){
            project.MMPJ_TOPG_DelivAttachments__c= att.Id;
            }
            else if (project.MMPJ_TOPG_DelivAttachments__c!=null &&!project.MMPJ_TOPG_DelivAttachments__c.contains(att.Id) && attachmenttype == 'del'){
            project.MMPJ_TOPG_DelivAttachments__c= project.MMPJ_TOPG_DelivAttachments__c+ ';' +att.Id; 
            }
           /* if( !project.MMPJ_TOPG_DelivAttachments__c.contains(att.Id) &&  !project.MMPJ_TOPG_ProjManagAttachments__c.contains(att.Id)){
                if(attachmenttype == 'pm'){                    
                    if(project.MMPJ_TOPG_ProjManagAttachments__c != null){
                        project.MMPJ_TOPG_ProjManagAttachments__c = project.MMPJ_TOPG_ProjManagAttachments__c + ';'+att.Id; 
                    }
                    else{
                        project.MMPJ_TOPG_ProjManagAttachments__c = att.Id;
                    }
                }
                else if(attachmenttype == 'del'){
                if(project.MMPJ_TOPG_DelivAttachments__c!= null){               
                        project.MMPJ_TOPG_DelivAttachments__c= project.MMPJ_TOPG_DelivAttachments__c+ ';' +att.Id; 
                    }
                    else{
                        project.MMPJ_TOPG_DelivAttachments__c= att.Id;
                    }
                }           
            } */
                               
        }
            
    }

  
public Set<Id> getAttIds(String deliverableIds){
     Set<Id>setDeliverIds = new Set<Id>();
     for (String theId :deliverableIds.split(';'))
     {   
     setDeliverIds.add(theId); 
     }
     return setDeliverIds;
    } 

public List<Attachment> listAttachments {get;set;}
public List<Attachment> listDeliverablesAttach{get;set;}
public List<Attachment> listProjMangAttach{get;set;}
public set<Attachment> SetAttachments {get;set;}
    public string attachmenttype{get;set;}
    public string projectId {get;set;}
    public MMPJ_TOPG_LoadAttachmentsController(){
        listAttachments = new List<Attachment>();
        SetAttachments  = new set<Attachment>();
        
        map<string, string> mapPageParams = ApexPages.currentPage().getParameters();
        system.debug('mapPageParams =='+mapPageParams);
        if(mapPageParams.containskey('attchmenttype')){
            attachmenttype = mapPageParams.get('attchmenttype');
            projectId =mapPageParams.get('id');
        }
    }

    
    public boolean ProjectSaved{get;set;}
    public void UpdateProject(){
        update new MMPJ_TOPG_Project__c(Id=project.Id, MMPJ_TOPG_ProjManagAttachments__c = project.MMPJ_TOPG_ProjManagAttachments__c, MMPJ_TOPG_DelivAttachments__c= project.MMPJ_TOPG_DelivAttachments__c);
        ProjectSaved = true;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public list<AttachmentWrapper> ListChatterProject{set;}
    public integer WrapperToDelete{get;set;}
    public list<AttachmentWrapper> getListChatterProject()
    {
        FillListOfAttachments();
        list<AttachmentWrapper> ListWrapper = new list<AttachmentWrapper>();
        list<ContentDocumentLink> listChatterAttachments = new list<ContentDocumentLink>();
        if(project.id != null)
        {
        	system.debug('Before listChatterAttachments ');
            listChatterAttachments =[SELECT ContentDocumentId,ContentDocument.ContentModifiedDate,ContentDocument.FileType,ContentDocument.Title,ContentDocument.OwnerId,ContentDocument.Owner.name
                                     FROM ContentDocumentLink
                                     WHERE LinkedEntityId =:Project.id];
           system.debug('after listChatterAttachments=='+Project.id);
        }
        for(ContentDocumentLink ChatterDoc : listChatterAttachments )
        {
            AttachmentWrapper Wrapper = new AttachmentWrapper();
            Wrapper.id = ChatterDoc.ContentDocumentId;
            Wrapper.title = ChatterDoc.ContentDocument.Title;
            Wrapper.type = ChatterDoc.ContentDocument.FileType;
            Wrapper.LastModified = ChatterDoc.ContentDocument.ContentModifiedDate;
            Wrapper.CreatedById = ChatterDoc.ContentDocument.OwnerId;
            Wrapper.CreatedByName = ChatterDoc.ContentDocument.Owner.name;
            Wrapper.ischatterDocument = true;
            ListWrapper.add(Wrapper);
        }
        if(listProjMangAttach != null)
            for(attachment att : listProjMangAttach)
            {
                AttachmentWrapper Wrapper = new AttachmentWrapper();
                Wrapper.id = att.id;
                Wrapper.title = att.name;
                Wrapper.type = att.ContentType;
                Wrapper.LastModified = att.LastModifieddate;
                Wrapper.CreatedById = att.createdbyid;
                Wrapper.CreatedByName = att.createdby.name;
                Wrapper.ischatterDocument = false;
                ListWrapper.add(Wrapper);
            }
        return ListWrapper;
    }
    public pagereference deleteWrapper()
    {
        try{
            list<AttachmentWrapper> ListWrapper = getListChatterProject();
            if(ListWrapper[WrapperToDelete].ischatterDocument)
            {
                ContentDocument contToDelete = new ContentDocument();
                contToDelete.id = ListWrapper[WrapperToDelete].Id;
                list<ContentVersion> ListContent = [select id, ContentDocumentId 
                                                    from ContentVersion 
                                                    where ContentDocumentId =:contToDelete.id];
                list<FeedItem> feedItemTodelete = [SELECT id,RelatedRecordId 
                                                   FROM FeedItem
                                                   WHERE ParentId =:Project.id];
                if(ListContent.size() > 0)
                {
                    for(FeedItem FdItem: feedItemTodelete)
                    {
                        if(FdItem.RelatedRecordId == ListContent[0].id)
                        {
                            delete FdItem;
                            break;
                        }
                    }
                }
                delete contToDelete ;
            }
            else
            {
                attachment AttDelete = new attachment();
                AttDelete.id = ListWrapper[WrapperToDelete].Id;
                delete AttDelete;
            }
        }
        catch(exception ex)
        {
            system.debug('##### ex ' +  ex.getMessage());
        }
        return null;
    }
    
    public class AttachmentWrapper{
        public string Id{get;set;}
        public string title{get;set;}
        public datetime LastModified{get;set;}
        public string createdbyId{get;set;}
        public string createdbyName{get;set;}
        public string Type{get;set;}
        public boolean ischatterDocument{get;set;}
    }
}