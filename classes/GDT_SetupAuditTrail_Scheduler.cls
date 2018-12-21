global class GDT_SetupAuditTrail_Scheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		/* Batch execution */
		GDT_SetupAuditTrail_Batch b = new GDT_SetupAuditTrail_Batch();
		database.executebatch(b);
	}
}