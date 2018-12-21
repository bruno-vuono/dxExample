/*********************************************************************************
 * Name: ASI_CRM_VN_MCF_Contract_Scheduler
 * Description: Scheduler for ASI_CRM_VN_MCF_Contract_Batch
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 25/01/2018       Hugo Cheung             Created          
*/
global class ASI_CRM_VN_MCF_Contract_Scheduler implements Schedulable {
	global void execute(SchedulableContext SC) {
    	Database.executeBatch(new ASI_CRM_VN_MCF_Contract_Batch());
    }
}