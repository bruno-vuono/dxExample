/**********************************************************************************
 * Name : ASI_CRM_SG_RecalWSDepletion_Scheduler
 * Created : Vincent Lam - 13 May 2016
 * Revision History:
 * 1. 2016-05-13 - [VL 1.0] Created
 **********************************************************************************/

global class ASI_CRM_SG_RecalWSDepletion_Scheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        Id jobId = Database.executeBatch(new ASI_CRM_SG_RecalculateWSDepletion_Batch(), 50);
        System.debug('------ jobId ------ : ' + jobId);

    }

}