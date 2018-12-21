@isTest
public class MMPJ_TOPG_SchedulerMilestones_Test
{
    public static testMethod void testschedule() {
        Test.StartTest();
        MMPJ_TOPG_SchedulerMilestones sh1 = new MMPJ_TOPG_SchedulerMilestones();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest(); 
    }
}