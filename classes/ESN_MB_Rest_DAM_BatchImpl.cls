global class ESN_MB_Rest_DAM_BatchImpl implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts, Schedulable {

    private ESN_MB_Rest_DAM_Batch batch;
	
    
    global ESN_MB_Rest_DAM_BatchImpl(ESN_MB_Rest_DAM_BatchParams params) {
        batch = new ESN_MB_Rest_DAM_Batch(params);
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return batch.start(BC);
    }

    global void execute(SchedulableContext sc) {
        execute();
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        execute();
    }

    // method used when the batch is called manually (not by scheduling)
    global String execute() {
        return batch.execute();
    }
    
    global void finish(Database.BatchableContext BC) {
        batch.finish(BC);
    }
}