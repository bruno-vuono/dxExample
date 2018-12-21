trigger MMPJ_TOPG_MoMLineItem_AfterUpdate on MMPJ_TOPG_MoMLineItem__c (after update){
    if(MMPJ_TOPG_AP01_MoMLineItem.isFirstTime){     
        //to prevent the RAID trigger on update to be triggered causing an infinite call between update RAID and update MOM line Item          
        MMPJ_TOPG_AP01_MoMLineItem.isFirstTime = false;
        //when a MOM line item is update the corresponding RAID should also be updated
        map< ID, MMPJ_TOPG_MoMLineItem__c > mapIDAndLineItemToUpdateItem = new map< ID, MMPJ_TOPG_MoMLineItem__c >(); 
        //when the raid field of a MOM line item changes from NONE to a value a RAID should be created
        //or when the project of a MOM line item changes to !=null the corresponding RAID should be added
        List< MMPJ_TOPG_MoMLineItem__c > listLineItemToAddRaids = new List<MMPJ_TOPG_MoMLineItem__c >();
        //when the raid field of a MOM line item changes from != NONE to NONE the corresponding RAID should be deleted
        //or when the project of a MOM line item changes to null the corresponding RAID should be deleted
        Set< ID > setIDLineItemToDeleteRaids = new Set< ID >(); 
        
        for(MMPJ_TOPG_MoMLineItem__c lineItem : Trigger.new){
           /* if(          
                //if project was != null and then raid was filled
                (
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_RelatedProject__c) 
                    && !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c) 
                    && String.ISBLANK(trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_RAID__c)
                )
                //if raid was != null and then project was filled
                ||
                (
                    !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c )
                    && !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RelatedProject__c) 
                    && String.ISBLANK(trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_RelatedProject__c)
                )
               ){
                listLineItemToAddRaids.add(lineItem );
            }*/
            if(
            //if raid was filled and it was emptied and project was still != null
                (
                    String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c)
                    && !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RelatedProject__c) 
                    && !String.ISBLANK(trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_RAID__c)
                )     
            //if project was filled and it was emptied and raidwas still != null
                ||
                (
                    !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c)
                    && String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RelatedProject__c) 
                    && !String.ISBLANK(trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_RelatedProject__c)
                )           
                ){
                setIDLineItemToDeleteRaids.add(lineItem.id);
            }
            else{
                mapIDAndLineItemToUpdateItem.put(lineItem.id,lineItem);    
            }
        }
        if(listLineItemToAddRaids.size() > 0){
            MMPJ_TOPG_AP01_MoMLineItem.createProjectRAID(listLineItemToAddRaids);
        }
        if(setIDLineItemToDeleteRaids.size() > 0){
            MMPJ_TOPG_AP01_MoMLineItem.deleteRAID(setIDLineItemToDeleteRaids );
        }
        if(mapIDAndLineItemToUpdateItem.size() > 0){
            MMPJ_TOPG_AP01_MoMLineItem.updateProjectRAID(mapIDAndLineItemToUpdateItem );
        }
    }
     if(MMPJ_TOPG_AP02_MoMLineItem.isFirstTime){     
        //to prevent the task  trigger on update to be triggered causing an infinite call between update task and update MOM line Item          
        MMPJ_TOPG_AP02_MoMLineItem.isFirstTime = false;
        //when a MOM line item is update the corresponding task should also be updated
        map< ID, MMPJ_TOPG_MoMLineItem__c > mapTaskIDAndLineItemToUpdateItem = new map< ID, MMPJ_TOPG_MoMLineItem__c >(); 
        //when the raid field of a MOM line item changes from NONE to a value or highlight is checked and Who is diff than none a task should be created
        //or when the project of a MOM line item changes to !=null the corresponding a task should be added
        List< MMPJ_TOPG_MoMLineItem__c > listLineItemToAddTasks = new List<MMPJ_TOPG_MoMLineItem__c >();
        //when the raid field of a MOM line item changed from != NONE to NONE and highlight = false the corresponding task should be deleted
        //or when the highlight field of a MOM line item changes to false and raid = none the corresponding task should be deleted
        //or when the project of a MOM line item changes to null the corresponding task should be deleted
        //or when the value Who is setto none
        Set< ID > setIDLineItemToDeleteTasks = new Set< ID >(); 
        
        for(MMPJ_TOPG_MoMLineItem__c lineItem : Trigger.new){
            if(          
                //if after modification this condition is met: project != null and (raid was filled or highlight = true) and who != null
                (
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_RelatedProject__c)
                    &&
                    (    
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_WhoU__c) 
                    || 
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_WhoC__c)
                    )
                    &&
                    (
                    !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c) 
                    ||
                    trigger.newMap.get(lineItem.id ).MMPJ_TOPG_IsHighlight__c == true
                    )
                )
                && 
                !(
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id).MMPJ_TOPG_RelatedProject__c)
                    &&
                    (    
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id).MMPJ_TOPG_WhoU__c) 
                    || 
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id).MMPJ_TOPG_WhoC__c)
                    )
                    &&
                    (
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_RAID__c) 
                    ||
                    trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_IsHighlight__c == true
                    )
                )
            ){
                //listLineItemToAddTasks.add(lineItem );
            }
            else if(
                //if after modification this condition is no longer met: project != null and (raid was filled or highlight = true) and who != null
                (
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id).MMPJ_TOPG_RelatedProject__c)
                    &&
                    (
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_RAID__c) 
                    ||
                    trigger.oldMap.get(lineItem.id ).MMPJ_TOPG_IsHighlight__c == true
                    )
                    &&
                    (    
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id).MMPJ_TOPG_WhoC__c) 
                    || 
                    !String.ISBLANK(trigger.oldMap.get(lineItem.id).MMPJ_TOPG_WhoU__c)
                    )
                )
                && 
                !(
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_RelatedProject__c)
                    &&
                    (
                    !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c) 
                    ||
                    trigger.newMap.get(lineItem.id ).MMPJ_TOPG_IsHighlight__c == true
                    )
                    &&
                    (    
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_WhoU__c) 
                    || 
                    !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_WhoC__c)
                    )
                )           
                ){
                setIDLineItemToDeleteTasks.add(lineItem.id);
            }
            else{
                mapTaskIDAndLineItemToUpdateItem.put(lineItem.id,lineItem);    
            }
        }
        if(listLineItemToAddTasks.size() > 0){
            MMPJ_TOPG_AP02_MoMLineItem.createTask(listLineItemToAddTasks);
        }
        if(setIDLineItemToDeleteTasks.size() > 0){
            MMPJ_TOPG_AP02_MoMLineItem.deleteTask(setIDLineItemToDeleteTasks);
        }
        if(mapTaskIDAndLineItemToUpdateItem.size() > 0){
            MMPJ_TOPG_AP02_MoMLineItem.updateTask(mapTaskIDAndLineItemToUpdateItem );
        }
    }
}