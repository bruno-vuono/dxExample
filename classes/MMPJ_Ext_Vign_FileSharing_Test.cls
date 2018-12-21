@isTest
public class MMPJ_Ext_Vign_FileSharing_Test {
    @isTest static void test_InsertDocument() {
        
        Campaign camp = new Campaign(RecordTypeId='012D00000007M8T',
                                     IsActive=true,
                                     Name='New Campaign');

        insert camp;
        test.startTest();
        ContentVersion content=new ContentVersion();
        content.Title='Test Insert New Document';
        Blob bodyBlob=Blob.valueOf('Test Insert New Document Blob');
        content.PathOnClient ='test';
        content.VersionData=bodyBlob;
       // content.LinkedEntityId = testFacture.Id;
        content.origin = 'H';
        insert content;
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :content.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testContent.contentdocumentid;
        newFileShare.LinkedEntityId = camp.Id;
        newFileShare.ShareType= 'V';
        insert newFileShare;
        test.stopTest();
    }
}