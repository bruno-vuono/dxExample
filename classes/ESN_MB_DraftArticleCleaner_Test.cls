@isTest
public class ESN_MB_DraftArticleCleaner_Test {
    static public testmethod void testExecute(){
        
        ESN_MB_Article__c oldArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('OldArticle', DateTime.now().addDays(-100), DateTime.now().addDays(-100), 'Draft');
        
        
        DateTime yesterday = DateTime.now().addDays(-1);
        ESN_MB_Article__c newArticle = ESN_MB_NOP_Homepage_Cx_Test_Utils.createArticle('NewArticle', DateTime.now().addDays(-1), DateTime.now().addDays(-1), 'Draft');
            
        Database.SaveResult res = Database.insert(oldArticle);
        System.debug('resOld=' + res);
        res = Database.insert(newArticle);
        System.debug('resNew=' + res);
        
        
        Test.startTest();
        ESN_MB_DraftArticleCleaner cleaner = new ESN_MB_DraftArticleCleaner();
        cleaner.execute(null);
        Test.stopTest();
        
        //Check that only the "Old" draft has been deleted
        List<ESN_MB_Article__c> actual = [Select Id, Name From ESN_MB_Article__c];
        System.assertEquals(1, actual.size());
        System.assertEquals('NewArticle', actual.get(0).Name);
    }
}