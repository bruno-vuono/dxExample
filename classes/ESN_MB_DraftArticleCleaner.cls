/**
    About
    -----
    Description: Schedulable class responsible for deleting Draft articles older than yesterday
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jun 2015

    Details
    -------
    This class execution should be scheduled once a day.
    
    Update History
    --------------
    Jun 2015 / Created by Sébastien Chateau

    Issues / TODOs
    --------------
    
*/
global class ESN_MB_DraftArticleCleaner implements Schedulable {
    global void execute(SchedulableContext ctx) {
        //Retrieving and deleting the Articles with status Draft and last modified date before yesterday
        List<Database.DeleteResult> listResult = 
            Database.delete([SELECT id
                             FROM ESN_MB_Article__c
                             WHERE ESN_MB_Stage__c = 'Draft'
                             AND LastModifiedDate < YESTERDAY]);
        
        System.debug('listResult delete ESN_MB_Article__c = ' + listResult);
        
        //Retrieving and deleting entries with Record Type=Articles_To_Products linked to no article
        //These entries are "orphans", their related article has been deleted so they must be deleted
        listResult = Database.delete([Select id from ESN_MB_Entry__c
                             Where RecordType.DeveloperName = 'Articles_To_Products'
                             And ESN_MB_Article__c = NULL]);
        
        System.debug('listResult delete ESN_MB_Entry__c = ' + listResult);
    }
}