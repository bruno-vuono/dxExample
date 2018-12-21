@isTest
public class ASI_CRM_CN_DTF_Test
{
    static testMethod void testTriggerClass()
    {
        List<User> tempUsers = ASI_TnE_KR_TestClassHelper.createTestUser(); //user list
        ASI_CRM_DTF__c dtf = new ASI_CRM_DTF__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_DTF__cASI_CRM_CN_DTF_Standard'), 
                                                ASI_CRM_CN_Project_Name__c = 'Test', 
                                                ASI_CRM_CN_Status__c = 'Draft', 
                                                ASI_CRM_CN_Planned_Launch_Date__c=Date.TODAY(), 
                                                ASI_CRM_CN_Project_Duration__c = 'One off', 
                                                ASI_CRM_CN_Duration_Detail__c = 'Test', 
                                                ASI_CRM_CN_Elements_of_backgroundContext__c = 'Test', 
                                                ASI_CRM_CN_Idea_Description__c = 'Test', 
                                                ASI_CRM_CN_ObjectivesAchievements__c = 'Test', 
                                                ASI_CRM_CN_Require_Support__c = 'Test', 
                                                ASI_CRM_CN_Data_Capture_Mechanism__c = 'Test', 
                                                ASI_CRM_CN_Measurements__c = 'Test', 
                                                ASI_CRM_CN_Website__c = TRUE, 
                                                ASI_CRM_CN_Improve_Awareness_Affinity__c = TRUE, 
                                                ASI_CRM_CN_autoApprove__c = FALSE);
        
        /*Group pg = new Group(Name = 'ASI CRM CN DTF Approver Group', 
                             DeveloperName = 'ASI_CRM_CN_DTF_Approver_Group');
        insert pg;
        List<GroupMember> GMlist = new List<GroupMember>();
        GroupMember GM = new GroupMember();
        GM.GroupId = pg.Id;
        GM.UserOrGroupId = tempUsers[0].Id;
        GMList.add(GM);
        insert GMList;*/
        
        Test.startTest();
        insert dtf;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(dtf.Id);
        Approval.process(req1);
        dtf.ASI_CRM_CN_autoApprove__c = TRUE;
        dtf.ASI_CRM_CN_Status__c = 'Submitted';
        update dtf;
        Test.stopTest();
    }//end test method: testTriggerClass
}//end class: ASI_CRM_CN_DTF_Test