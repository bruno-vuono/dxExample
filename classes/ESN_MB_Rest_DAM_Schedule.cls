/**
* can't call htpp callouts from Scheduler class. So this Schedulable class calls the ESN_MB_Rest_DAM_Batch batch
*
* Create Schedule Jobs : Setup > Develop > Apex Class > 'Schedule Apex' button
* See Jobs : Setup > Jobs > Schedules Jobs
*
* Javascript in a Custom Button:
* {!REQUIRESCRIPT("/soap/ajax/31.0/connection.js")} 
* {!REQUIRESCRIPT("/soap/ajax/31.0/apex.js")} 
*    var result = sforce.apex.execute("ESN_MB_Rest_DAM_Schedule","importLastModifiedAssets",{brandDamId:""}); alert(result);
* OR var result = sforce.apex.executeAnonymous("Database.executeBatch(new ESN_MB_Rest_DAM_Batch());");
**/
global class ESN_MB_Rest_DAM_Schedule implements Schedulable {

    // Run every day the cron job at 02 AM (Seconds Minutes Hours Day_of_month Month Day_of_week optional_year)
    //public static String CRON_EXP = '0 0 02 * * ?';

    global void execute(SchedulableContext sc) {
        List<String> listDamIdToSync = new List<String>();
        
        List <ESN_MB_NodePage__c> listActiveBrand = [Select Id, ESN_MB_Brand_DAM_Id__c, ESN_MB_Brand_LastImportAssetsDate__c from ESN_MB_NodePage__c
            Where recordtype.developername='ESN_MB_Brand'
            And ESN_MB_Deployment_Status__c <> 'Disable'
            And ESN_MB_Brand_Initialization__c = TRUE];
        
        for(ESN_MB_NodePage__c brandTmp:listActiveBrand){
            brandTmp.ESN_MB_Brand_LastImportAssetsDate__c = Datetime.newInstance(2013,1,1);
            if(!String.isEmpty(brandTmp.ESN_MB_Brand_DAM_Id__c)){
	            listDamIdToSync.add(brandTmp.ESN_MB_Brand_DAM_Id__c);
            }
        }
        
        List <Database.SaveResult> listResult = Database.update(listActiveBrand);
        
        ESN_MB_Rest_DAM_BatchParams params = new ESN_MB_Rest_DAM_BatchParams(listDamIdToSync);
        ESN_MB_Rest_DAM_Batch damAssetBatch = new ESN_MB_Rest_DAM_Batch(params);
        damAssetBatch.scheduleApexJob(0, 0);
        
    }

}