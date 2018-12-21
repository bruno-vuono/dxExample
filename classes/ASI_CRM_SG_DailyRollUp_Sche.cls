/*********************************************************************************
 * Name: ASI_CRM_SG_DailyRollUp_Sche
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-17       Wilken         			Created
 * 2018-07-04		Vincent Lam				[VL 1.0] Put the promotion incentive calculation into existing scheduler because there's hard limit in Production scheduled job
*********************************************************************************/
global class ASI_CRM_SG_DailyRollUp_Sche implements Schedulable {
    global void execute(SchedulableContext sc) {

        Id jobId = Database.executeBatch(new ASI_CRM_SG_DailyRollUp_Batch(), 200);
        System.debug('------ jobId ------ : ' + jobId);

        /* [VL 1.0] BEGIN */
        date lastMonth = system.today().addmonths(-1);
        string yearStr = String.valueOf(lastMonth.year());
        string monthStr = String.valueOf(lastMonth.month());
        
        Id jobId1 = Database.executeBatch(new ASI_CRM_SG_YTDPromotionAchieved_Batch(yearStr, monthStr, 'Wholesaler', true), 200);
        System.debug('------ jobId1 ------ : ' + jobId1);
        /* [VL 1.0] END */
    }
}