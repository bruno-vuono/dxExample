public class MMPJ_TOPG_AP03_RAID {
     //static variable to prevent the infinite update calls between RAID update and task update 
    //when a task is updated the RAID is updated RAID is updated and when a RAID is updated a task is updated
    public static boolean isFirstTime = true;
    
      //When a Raid is added to a project it should be added to the todo section of of its project
    public static void createTask(List <MMPJ_TOPG_RAID__c> listRAID){  
        List<Task> listTaskToInsert = new  List<Task>();  
        for(MMPJ_TOPG_RAID__c raid: listRAID){
            Task task = new Task();
            setFieldsOfTask(raid,task);
            listTaskToInsert.add(task);
        }
        if(listTaskToInsert.size() > 0){
            insert(listTaskToInsert );
        }   
    }
   
    //When a RAID is delete the corresponding task should be also deleted
    public static void deleteTask(Set<ID> RAIDID){ 
        List<Task> listRelatedTask = new  List<Task> ();
        //get the list of Tasks releted to that line item
        listRelatedTask = [Select id, WhatId 
                           From Task
                           Where WhatId IN : RAIDID];
        if(listRelatedTask.size() > 0){
            delete(listRelatedTask);
        }   
    }
    
    //When a RAID is updated the corresponding task should also be updated
    public static void updateTask(Map<Id,MMPJ_TOPG_RAID__c> mapRAID){ 
        List<Task> listTaskToUpdate = new  List<Task>();
        Set<ID> RAIDID = mapRAID.keySet();
       
        List<Task> listRelatedTask = new  List<Task> ();
        listRelatedTask = [SELECT id, OwnerId,WhoId,  Description, ActivityDate, WhatId, Status, Subject, MMPJ_TOPG_ProjectRaid__c, MMPJ_TOPG_ProjectChanged__c
                           FROM task
                           Where WhatId IN : RAIDID];

        for(Task task: listRelatedTask ){
            MMPJ_TOPG_RAID__c raid = mapRAID.get(task.WhatId );
            if(raid != null){
                setFieldsOfTask(raid, task);
                listTaskToUpdate.add(task);
            }
        }
        
        if(listTaskToUpdate.size() > 0){
            update(listTaskToUpdate);
        }   
    }
    
    //match the fields of task to the corresponding fields of raids
    public static void setFieldsOfTask(MMPJ_TOPG_RAID__c raid, Task task){
        if(raid.MMPJ_TOPG_User__c == null){
        	task.OwnerId = UserInfo.getUserId();    
        }
        else{
        	task.OwnerId = raid.MMPJ_TOPG_User__c;
        }
        task.WhoId = raid.MMPJ_TOPG_Contact__c;
        task.Description = raid.MMPJ_TOPG_Description__c;
        task.ActivityDate = raid.MMPJ_TOPG_ExpectedDate__c;
        task.WhatId = raid.id;
        task.Status = raid.MMPJ_TOPG_Status__c;
        task.Subject = raid.MMPJ_TOPG_Title__c;
    }

}