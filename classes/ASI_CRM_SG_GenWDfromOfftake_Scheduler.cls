/**********************************************************************************
 * Name : ASI_CRM_SG_GenWDfromOfftake_Scheduler 
 * Created : Vincent Lam
 * Revision History:
 * 1. 2016-11-15 - [VL 1.0] Created
 **********************************************************************************/

global class ASI_CRM_SG_GenWDfromOfftake_Scheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        Id jobId = Database.executeBatch(new ASI_CRM_SG_GenWDnewSKU_Batch('offtake'), 1);
        System.debug('------ jobId ------ : ' + jobId);

    }

}