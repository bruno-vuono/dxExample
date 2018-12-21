/**********************************************************************************
 * Name : ASI_CRM_SG_GenWSDepletion_Scheduler
 * Created : Vincent Lam @24 Mar 2016
 * Revision History:
 * 1. 24 Mar 2016 - [VL 1.0] Created
 **********************************************************************************/

global class ASI_CRM_SG_GenWSDepletion_Scheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        Id jobId = Database.executeBatch(new ASI_CRM_SG_GenStockInTradeDetail_Batch(), 200);
        System.debug('------ jobId ------ : ' + jobId);

    }

}