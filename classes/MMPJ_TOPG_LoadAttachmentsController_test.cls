@isTest
public class MMPJ_TOPG_LoadAttachmentsController_test{
    private static  Datetime myDT = Datetime.now();
     private static String  mailPrefix = myDT.format('ddMMyyyy');
 static testMethod void myUnitTest() {
 Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
 User u = new User(Username = mailPrefix+'-test-supervisor@pernod-ricard.com', email = mailPrefix+'-test-supervisor@pernod-ricard.com', profileID = adminProfile.id, IsActive = true, LastName='Supervisor', Alias='sup', TimeZoneSidKey='GMT', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US'); 
 insert u;
  MMPJ_TOPG_Project__c project = new MMPJ_TOPG_Project__c();
    project.name = 'testProject';
    project.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
    project.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
    project.MMPJ_TOPG_ProjectOwner__c=u.id; 
 insert project;

Attachment attach=new Attachment();    
attach.Name='Unit Test Attachment';
Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
attach.body=bodyBlob;
attach.parentId=project.id;
insert attach;

Attachment attach2=new Attachment();    
attach2.Name='Unit Test Attachment 2';
Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body22');
attach2.body=bodyBlob;
attach2.parentId=project.id;
insert attach2;

Attachment attach3=new Attachment();    
attach3.Name='Unit Test Attachment 3';
Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body22');
attach3.body=bodyBlob;
attach3.parentId=project.id;
insert attach3;


MMPJ_TOPG_Project__c project2 = new MMPJ_TOPG_Project__c();
    project2.name = 'testProject2';
    project2.MMPJ_TOPG_StartDate__c= Date.newInstance(2016,11,11);
    project2.MMPJ_TOPG_EndDate__c= Date.newInstance(2016,12,12);
    project2.MMPJ_TOPG_ProjectOwner__c=u.id;
    project2.MMPJ_TOPG_DelivAttachments__c=attach2.id;
    project2.MMPJ_TOPG_ProjManagAttachments__c =attach3.id; 
 insert project2;
 
 string before = 'Testing base 64 encode';            
  Blob beforeblob = Blob.valueOf(before);         
 //Insert contentdocument data
 ContentVersion cv = new ContentVersion();
 cv.title = 'test content trigger';      
 cv.PathOnClient ='test';           
 cv.VersionData =beforeblob;          
 insert cv;         

ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
       
 //insert new ContentDocumentLink
ContentDocumentLink newFileShare = new ContentDocumentLink();
newFileShare.contentdocumentid = testcontent.contentdocumentid;
newFileShare.LinkedEntityId = project2.Id;
newFileShare.ShareType= 'V';

  MMPJ_TOPG_LoadAttachmentsController mmpj = new MMPJ_TOPG_LoadAttachmentsController();
  MMPJ_TOPG_LoadAttachmentsController.AttachmentWrapper wrapper = new MMPJ_TOPG_LoadAttachmentsController.AttachmentWrapper();
  
  Test.startTest();
  //Test.setCurrentPageReference(new PageReference('Page.myPage'));
 wrapper.Id=newFileShare.id;  
  wrapper.title='test';
  wrapper.LastModified= Datetime.newInstance(1960, 2, 17);
  wrapper.createdbyId=u.id;
  wrapper.createdbyName='Testeur';
  wrapper.Type='Testeur';
  wrapper.ischatterDocument=true;

  mmpj.WrapperToDelete=0;
  Boolean bool =mmpj.isEditMode;
  //mmpj.ListChatterProject.add(wrapper); 
  mmpj.attachmenttype='del';
  mmpj.project=project;
  mmpj.projectId=project.id;
  mmpj.attachmentId=attach2.id;
  mmpj.FillListOfAttachments();
  mmpj.deleteAttachment();
  mmpj.addAttachmentDeliverables(); 
  mmpj.addAttachmentProjectManag();
  mmpj.getLastAttachment();
  mmpj.UpdateProject();
  mmpj.deleteWrapper();
  mmpj.attachmenttype='pm';
  mmpj.getLastAttachment();
  mmpj.project=project2;
  mmpj.getLastAttachment();
  mmpj.FillListOfAttachments();
  mmpj.deleteWrapper();
Test.stopTest();
    
 }
 }