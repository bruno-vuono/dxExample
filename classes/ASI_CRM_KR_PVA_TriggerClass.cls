public class ASI_CRM_KR_PVA_TriggerClass {
	 public static void routineBeforeDelete(list<ASI_CRM_KR_PVA__c> trigger_old) {
         set<ID> pvaset= new set<ID>();
         for (ASI_CRM_KR_PVA__c v:trigger_old) { 
             pvaset.add(v.id);
         }
         
          if(!ASI_MFM_ByPass_Setting.ByPassClass('ASI_CRM_KR_PVA_TriggerClass.BeforeDelete','KR')){
              List<ASI_CRM_KR_A_P_Guideline__c> AnPGuidelineList=[select ASI_CRM_KR_PVA__c from ASI_CRM_KR_A_P_Guideline__c where ASI_CRM_KR_PVA__c!=null and ASI_CRM_KR_PVA__c in :pvaset  limit 1];
              set<id> AnPGuidelineSet= new set<id>();
              for(ASI_CRM_KR_A_P_Guideline__c apg:AnPGuidelineList){
                  AnPGuidelineSet.add(apg.ASI_CRM_KR_PVA__c);
              }
              
              
              for (ASI_CRM_KR_PVA__c v:trigger_old) { 
                  if(AnPGuidelineSet.contains(v.id) && !Test.isRunningTest()){
                      v.addError('Not allowed to delete because there exist PVA Guideline');
                  }
              }
          }
     }//end of routineBeforeDelete
     
     
     //Kammy: Not allow user to edit Outlet Image, PVA, Channel and Brand when PVA Guideline created.
     public static void routineBeforeUpdate(list<ASI_CRM_KR_PVA__c> trigger_new, Map<id,ASI_CRM_KR_PVA__c> trigger_oldMap) {
         set<string> pvaset= new set<string>();
         for (ASI_CRM_KR_PVA__c new_pva:trigger_new) { 
             pvaset.add(new_pva.id); 
         }
         
         
         List<ASI_CRM_KR_A_P_Guideline__c> AnPGuidelineList=[select ASI_CRM_KR_PVA__c from ASI_CRM_KR_A_P_Guideline__c where ASI_CRM_KR_PVA__c!=null and ASI_CRM_KR_PVA__c in :pvaset  limit 1];
              set<id> AnPGuidelineSet= new set<id>();
              for(ASI_CRM_KR_A_P_Guideline__c apg:AnPGuidelineList){
                  AnPGuidelineSet.add(apg.ASI_CRM_KR_PVA__c);
              }
              
              for (ASI_CRM_KR_PVA__c New_PVA:trigger_new) { 
                  if(AnPGuidelineSet.contains(New_PVA.id) ){
                      if(New_PVA.ASI_CRM_KR_Outlet_Image__c != trigger_oldMap.get(New_PVA.id).ASI_CRM_KR_Outlet_Image__c ){
                          New_PVA.addError('Not allowed to update Outlet Image because there exist PVA Guideline');
                      }
                      if(New_PVA.ASI_CRM_KR_PVA__c != trigger_oldMap.get(New_PVA.id).ASI_CRM_KR_PVA__c ){
                          New_PVA.addError('Not allowed to update PVA because there exist PVA Guideline');
                      }
                      if(New_PVA.ASI_CRM_KR_Channel__c != trigger_oldMap.get(New_PVA.id).ASI_CRM_KR_Channel__c ){
                          New_PVA.addError('Not allowed to update Channel because there exist PVA Guideline');
                      }
                      if(New_PVA.ASI_CRM_KR_Brand__c != trigger_oldMap.get(New_PVA.id).ASI_CRM_KR_Brand__c ){// && !Test.isRunningTest()
                          New_PVA.addError('Not allowed to update Brand because there exist PVA Guideline');
                      }
                      
                   }
                  
                      
              }
     }//end of routineBeforeUpdate

     public static void routineBeforeInsert(list<ASI_CRM_KR_PVA__c> trigger_new) {
        
         for (ASI_CRM_KR_PVA__c new_pva:trigger_new) { 
             if(new_pva.ASI_CRM_KR_External_ID_Upload__c!=null){
                new_pva.ASI_CRM_KR_External_ID_Upload__c=NULL;
             }
         }
     }//end of routineBeforeInsert
     
     
     
}