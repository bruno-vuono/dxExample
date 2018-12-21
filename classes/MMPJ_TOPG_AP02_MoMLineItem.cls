public class MMPJ_TOPG_AP02_MoMLineItem {
 //static variable to prevent the infinite update calls between task update and MOM line item update 
    //when a MOM line item is updated the task is updated and when a task is updated MOM line item is updated
    public static boolean isFirstTime = true;
    
    //When a MOM line item is added to a project a task should be created
    public static void createTask(List <MMPJ_TOPG_MoMLineItem__c> listMoMLineItem){  
        List<Task> listTaskToInsert = new  List<Task>();  
        for(MMPJ_TOPG_MoMLineItem__c lineItem: listMoMLineItem){
            Task task = new Task();
            setFieldsOfTask(task, lineItem);
            listTaskToInsert.add(task);
        }
        if(listTaskToInsert.size() > 0){
            System.debug('???insert');
            insert(listTaskToInsert );
        }   
    }
   
    //When a MOM line item is delete the corresponding task should be also deleted
    public static void deleteTask(Set<ID> MoMlineItemID){ 
        List<Task> listRelatedTask = new  List<Task> ();
        //get the list of Tasks releted to that line item
        listRelatedTask = [Select id, WhatId 
                           From Task
                           Where WhatId IN : MoMlineItemID];
        if(listRelatedTask.size() > 0){
            delete(listRelatedTask);
        }   
    }
    
    //When a MOM line item is updated the corresponding task should also be updated
    public static void updateTask(Map<Id,MMPJ_TOPG_MoMLineItem__c> newLineItem){ 
        List<Task> listTaskToUpdate = new  List<Task>();
        Set<ID> MoMlineItemID = newLineItem.keySet();
       
        List<Task> listRelatedTask = new  List<Task> ();
        listRelatedTask = [SELECT id, OwnerId,WhoId,  Description, ActivityDate, WhatId, Status, Subject, MMPJ_TOPG_ProjectRaid__c, MMPJ_TOPG_ProjectChanged__c
                           FROM task
                           Where WhatId IN : MoMlineItemID];

        for(Task task: listRelatedTask ){
            MMPJ_TOPG_MoMLineItem__c lineItem = newLineItem.get(task.WhatId );
            if(lineItem != null){
                setFieldsOfTask(task, lineItem);
                listTaskToUpdate.add(task);
            }
        }
        
        if(listTaskToUpdate.size() > 0){
            update(listTaskToUpdate);
        }   
    }
    
    //match the fields of Task to the corresponding fields of the line item
    public static void setFieldsOfTask(Task task, MMPJ_TOPG_MoMLineItem__c lineItem){                   
        if(lineItem.MMPJ_TOPG_WhoU__c == null){
        	task.OwnerId = UserInfo.getUserId();    
        }
        else{
        	task.OwnerId = lineItem.MMPJ_TOPG_WhoU__c ;    
        }
        task.WhoId = lineItem.MMPJ_TOPG_WhoC__c;
        task.Description = LineItem.MMPJ_TOPG_Comment__c;
        task.ActivityDate = lineItem.MMPJ_TOPG_When__c;
        task.WhatId = lineItem.id;
        task.Subject = LineItem.MMPJ_TOPG_Action_Title__c;
    }
}