/*********************************************************************************
 * Name:ASI_CRM_SG_YTDPromotionAchieved_Sche
 * Description: Scheduler for ASI_CRM_SG_YTDPromotionAchieved_Batch
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-06-15       Vincent Lam             Created
*********************************************************************************/
global class ASI_CRM_SG_YTDPromotionAchieved_Sche implements Schedulable {

    global void execute(SchedulableContext sc) {

        date lastMonth = system.today().addmonths(-1);
        string yearStr = String.valueOf(lastMonth.year());
        string monthStr = String.valueOf(lastMonth.month());
        
        Id jobId = Database.executeBatch(new ASI_CRM_SG_YTDPromotionAchieved_Batch(yearStr, monthStr, 'Wholesaler', true), 200);
        System.debug('------ jobId ------ : ' + jobId);

    }

}