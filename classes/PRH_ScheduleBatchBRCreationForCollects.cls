// Le Cercle application - evolution LCS-11 - January 2017
// Scheduler for launching the batch of creation of Le Cercle Brand et Competitor brands
// There are 3 collects per year and one collect per iconic account. 
// These collects are created automatically in 2 steps in order to avoid Salesforce limitation regarding 10000 max query rows in APEX class
// Step one : launch of schedulable class PRH_ManageCollectsForIconicAcc for deactivation of active collects and creation of new ones
// Step two : launch of schedulable class PRH_ScheduleBatchBRCreationForCollects that execute batch PRH_BatchBrandCreationForCollects
// for creation of Competitor brands and Le Cercle brands for each new collect
global class PRH_ScheduleBatchBRCreationForCollects implements Schedulable{

    global void execute(SchedulableContext ctx) {
        // Limitation for default batch size to 50 instaed of 200 
		// This is done to avoid problem of limit of 10000 query rows when the entry point is an APEX 
        Database.executeBatch(new PRH_BatchBrandCreationForCollects(), 50);
    }
    
}