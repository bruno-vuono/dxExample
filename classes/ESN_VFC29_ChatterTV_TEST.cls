/*
+-----------------------+------------------------------------------------------------------------------------+
| Author                | Cécile Lartaud                                                                     |
+-----------------------+------------------------------------------------------------------------------------+
| Description           |                                                                                    |
|                       |                                                                                    |
|     - Object(s)       | ESN_Video__c                                                                       |
|     - Description     | Test class of ESN_VFC29_ChatterTV                                                  |
+-----------------------+------------------------------------------------------------------------------------+
| Creation Date         | 09/10/2013                                                                         |
+-----------------------+------------------------------------------------------------------------------------+
| Modifications         |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
| Governor informations |                                                                                    |
+-----------------------+------------------------------------------------------------------------------------+
*/
@isTest
private class ESN_VFC29_ChatterTV_TEST{

    static testMethod void myUnitTest() {
        User contextUsr;
        /* Query the permission set "Project Management" */
        List<PermissionSet> searchList = [SELECT Id FROM PermissionSet WHERE Name = 'ESN_ChatterTV_Viewer'];
        
        if(searchList.size() != 0) {
            String permId = searchList[0].Id;
            
            /* Create a context user */
            contextUsr = TestFactory.createUserWithProfile('ctxUsr', 'ESN SSO User');
            insert contextUsr;
            
            /* Assign the permission set to the user */
            PermissionSetAssignment permAssign = new PermissionSetAssignment( AssigneeId = contextUsr.Id, PermissionSetId = permId );
            insert permAssign;
        } else {
            /* Create a context user */
            contextUsr = TestFactory.createUserWithProfile('ctxUsr', 'System Administrator');
            insert contextUsr;
        }
        
        System.runas(contextUsr){               
            // Create Chatter Videos with contextUsr as owner //
            ESN_Video__c vid1 = new ESN_Video__c(Name = 'vid1', ESN_Description__c = 'vid1 descr', ESN_VideoTags__c = 'tag', ESN_Categories__c = 'cat');
            insert vid1;
            ESN_Video__c vid2 = new ESN_Video__c(Name = 'vid2', ESN_Description__c = 'vid2 descr', ESN_VideoTags__c = 'tag', ESN_Categories__c = 'cat', ESN_ViewsCount__c = 2);
            insert vid2;
            ESN_Video__c vid3 = new ESN_Video__c(Name = 'vid3', ESN_Description__c = 'vid3 descr', ESN_VideoTags__c = 'tag', ESN_Categories__c = '');
            insert vid3;
            ESN_Video__c vid4 = new ESN_Video__c(Name = 'vid4', ESN_Description__c = 'vid4 descr', ESN_VideoTags__c = 'tag', ESN_Categories__c = 'cat');
            insert vid4;
            
            
            /* Create new instance of Visualforce Page */
            Pagereference vf = Page.ESN_VFP29_ChatterTV;
            Test.setCurrentPageReference(vf);
            ESN_VFC29_ChatterTV con1 = new ESN_VFC29_ChatterTV();    
        }
    }
}