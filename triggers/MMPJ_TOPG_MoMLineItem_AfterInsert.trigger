trigger MMPJ_TOPG_MoMLineItem_AfterInsert on MMPJ_TOPG_MoMLineItem__c (after insert) {
       List< MMPJ_TOPG_MoMLineItem__c > listLineItemToAddRaids = new List<MMPJ_TOPG_MoMLineItem__c >(); //list of MOM line items used to create new RAIDS
    List< MMPJ_TOPG_MoMLineItem__c > listLineItemToAddTasks = new List<MMPJ_TOPG_MoMLineItem__c >(); //list of MOM line items used to create new Tasks

  /*  for(MMPJ_TOPG_MoMLineItem__c lineItem : Trigger.new){
        //only take MOM line items that have a Project and Raid != null 
        if(
            !String.ISBLANK(trigger.newMap.get(lineItem.id).MMPJ_TOPG_RelatedProject__c) 
            && 
            !String.ISBLANK(trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c) 
        ){
            listLineItemToAddRaids.add(lineItem );
        }
        //only take MOM line items that have a Project and (Raid == Action) and Who != null
        if( (trigger.newMap.get(lineItem.id ).MMPJ_TOPG_RAID__c == 'Action') &&
               (trigger.newMap.get(lineItem.id).MMPJ_TOPG_WhoC__c != null )){
            listLineItemToAddTasks.add(lineItem );
        }
    }
    if(listLineItemToAddRaids.size() > 0){
        MMPJ_TOPG_AP01_MoMLineItem.createProjectRAID(listLineItemToAddRaids );
    }
    if(listLineItemToAddTasks.size() > 0){
        MMPJ_TOPG_AP02_MoMLineItem.createTask(listLineItemToAddTasks);
    }*/

}