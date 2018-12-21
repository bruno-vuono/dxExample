public with sharing class MMPJ_TOPG_ImageCarouselController {
    public string testrich{get;set;}
    public Id theVisitId{
        get;
        set{
            System.Debug('### theVisitId' );
            if(this.theVisitId == null || (this.theVisitId != null && this.theVisitId != value)){
                this.theVisitId = value;
                LoadAttachments();
            }                        
        }
    }
    
    public list<Attachment> listAttachments{
        get{
            System.Debug('### listAttachments' );
            if(listAttachments == null){
                listAttachments = new list<Attachment>();
            }
            return listAttachments;
        }
        set;
    }
    
    public MMPJ_TOPG_ImageCarouselController(){
        System.Debug('### Constructor' );
        //For Test
        theVisitId = 'aKX250000000006GAA';
    }
    
    public void LoadAttachments(){
        System.Debug('### LoadAttachments' );
        listAttachments = [SELECT Id FROM Attachment WHERE ParentId = :theVisitId AND Name like 'VIMG_%'];
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //Attach a snapshot
    //////////////////////////////////////////////////////////////////////////////////////////
    public Attachment snapshot_attachment{        
        get{
            System.Debug('### snapshot_attachment' );
            if(snapshot_attachment== null) 
                snapshot_attachment = new Attachment(); 
                return snapshot_attachment;
            }
        set;
    }
    
    public PageReference UploadPicture() {    
        System.Debug('### UploadPicture ' );
        System.Debug('### snapshot_attachment.Name ' + snapshot_attachment.Name );        
        try{
            if(snapshot_attachment.body != null && snapshot_attachment.Name != null && theVisitId != null){
                snapshot_attachment.ParentId = theVisitId; 
                snapshot_attachment.Name = 'VIMG_' + snapshot_attachment.Name;
                insert snapshot_attachment;
                LoadAttachments();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm,'The image have been uploaded.');
                ApexPages.addMessage(myMsg);
            }
        }
        catch(Exception ex){
            HandleException(ex);            
        }
        finally{
            snapshot_attachment = new Attachment();
        }
        return null;
    }     
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //Error Handling
    //////////////////////////////////////////////////////////////////////////////////////////
    public string errortitle{get;set;}
    public string errordetail{get;set;}
    public void  HandleException(Exception ex){
        System.Debug('### UploadPicture ' );
        errortitle= ex.getMessage() + '\n' + ex.getLineNumber(); 
        errordetail = ex.getStackTraceString();
    } 
}