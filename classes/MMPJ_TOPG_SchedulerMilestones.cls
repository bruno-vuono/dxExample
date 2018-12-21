global class MMPJ_TOPG_SchedulerMilestones implements Schedulable {
  
   public static String CRON_EXP = '0 0 23 ? * 2';
     global void execute(SchedulableContext ctx) {
      MMPJ_TOPG_ManipulateMilestones.AlertMilestones();
   }   
     

}