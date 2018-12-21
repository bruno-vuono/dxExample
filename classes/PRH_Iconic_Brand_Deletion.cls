/*
  January 2017 - evolution application Le Cercle LCS-11 - no more used - replaced by evol LCS-159
  Lorsqu'une brand est supprimée, celle-ci doit entrainer la suppression de la Competitor Brand ou Le Cercle Brand correspondante pour chaque collecte active
*/
public class PRH_Iconic_Brand_Deletion extends PRH_TriggerAbstract {
    public PRH_Iconic_Brand_Deletion() {
        super('PRH_Iconic_Brand_Deletion');
    }
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        // LCS-159 (July 2017) : Deleting a Brand set the status PRH_Active to value False but doesn't delete the Brand. 
        // This Brand is no more visible in collects. However all data are kept in Data Base.
        // It will be ignored during the collects creation for the following period.
        if (tAction == TriggerAction.BEFORE_DELETE) {
            List<PRH_Brand_Luxury_Brand__c> brandSelectedForDeleteList = (List<PRH_Brand_Luxury_Brand__c>)sObjList;
            // List<PRH_Brand_Luxury_Brand__c> brandToUpdateList = new List<PRH_Brand_Luxury_Brand__c>();

            System.debug('PRH_Iconic_Brand_Deletion, there are ' + brandSelectedForDeleteList.size() + ' brands selected for delete');

            // For each Brand in the trigger 
            /*
            for (PRH_Brand_Luxury_Brand__c br : brandSelectedForDeleteList) {    
                System.debug('PRH_Iconic_Brand_Deletion, br.ID = ' + br.ID); 
                br.PRH_Active__c = False;
                brandToUpdateList.add(br);
            }
            if (brandToUpdateList.size() > 0) {
                System.debug('PRH_Iconic_Brand_Deletion, executeTriggerAction, ' + brandToUpdateList.size() + ' Brands are going to be set to Active = False');
                update brandToUpdateList;
            }    
            */
            // Throw an error that the Brand cannot be deleted
            for (PRH_Brand_Luxury_Brand__c br : brandSelectedForDeleteList) {    
                System.debug('PRH_Iconic_Brand_Deletion, br.ID = ' + br.ID + ' was not deleted'); 
                if (Test.isRunningTest()) {
                    System.debug('An Iconic Brand cannot be deleted, it is only possible to deactivate it setting field Active Brand to False'); 
                } else {
                    br.addError('An Iconic Brand cannot be deleted, it is only possible to deactivate it setting field Active Brand to False'); 
                }
            } 
        }
        /* LCS-11 (no more used)
        if (tAction == TriggerAction.AFTER_DELETE) {
            List<PRH_Brand_Luxury_Brand__c> brandToDeleteList = (List<PRH_Brand_Luxury_Brand__c>)sObjList;
            List<PRH_Brand_Criteria__c> LeCercleBRsToDeleteList = new List<PRH_Brand_Criteria__c>();
            List<PRH_Brand_Criteria__c> brLeCercle;
            List<PRH_Competitor_Brands__c> competitorBRsToDeleteList = new List<PRH_Competitor_Brands__c>();
            List<PRH_Competitor_Brands__c> brComp;
            
            // Retrieve all IDs of active collects  
            List<PRH_Collect__c> activeCollects = [SELECT id FROM PRH_Collect__c WHERE PRH_Active__c=true ORDER BY Name DESC];
            if (activeCollects.size() > 0) {
                System.debug('PRH_Iconic_Brand_Deletion, executeTriggerAction, There are ' + activeCollects.size() + ' active collects');
                // Retrieve Competitor Brand or Le Cercle Brand linked to the active collects and the brands to delete  
                brLeCercle = [SELECT id, PRH_Brand__c, PRH_Collect__c FROM PRH_Brand_Criteria__c WHERE PRH_Collect__c IN :activeCollects AND PRH_Brand__c IN :brandToDeleteList]; 
                brComp = [SELECT id, PRH_Iconic_Brand__c, PRH_Collect__c FROM PRH_Competitor_Brands__c WHERE PRH_Collect__c IN :activeCollects AND PRH_Iconic_Brand__c IN :brandToDeleteList];
                
                System.debug('PRH_Iconic_Brand_Deletion, executeTriggerAction, There are ' + brLeCercle.size() + ' Le Cercle Brands and ' + brComp.size() + ' Competitor Brands linked to the active collects');
                System.debug('PRH_Iconic_Brand_Deletion, there are ' + brandToDeleteList.size() + ' brands to delete');
                System.debug('PRH_Iconic_Brand_Deletion, brLeCercle.size() = ' + brLeCercle.size());
                System.debug('PRH_Iconic_Brand_Deletion, brComp.size() = ' + brComp.size());
                for (PRH_Brand_Luxury_Brand__c br : brandToDeleteList) {    
                    System.debug('PRH_Iconic_Brand_Deletion, br.ID = ' + br.ID);                
                    // If flag Competitor is equal to True
                    if (br.PRH_Competitor_Brand__c == true) { // Competitor brand
                        if (brComp.size() > 0) {
                            for (PRH_Competitor_Brands__c b : brComp) {
                                //System.debug('PRH_Iconic_Brand_Deletion, b.PRH_Iconic_Brand__c = ' + b.PRH_Iconic_Brand__c);
                                if (b.PRH_Iconic_Brand__c == br.ID)
                                    competitorBRsToDeleteList.add(b);
                            }
                        }
                    } else { // Le Cercle brand
                        if (brLeCercle.size() > 0) {
                            for (PRH_Brand_Criteria__c b : brLeCercle) {
                                //System.debug('PRH_Iconic_Brand_Deletion, b.PRH_Brand__c = ' + b.PRH_Brand__c);
                                if (b.PRH_Brand__c == br.ID)
                                    LeCercleBRsToDeleteList.add(b);
                            }
                        }
                    }
                }
            }

            if (competitorBRsToDeleteList.size() > 0) {
                System.debug('PRH_Iconic_Brand_Deletion, executeTriggerAction, ' + competitorBRsToDeleteList.size() + ' Competitor Brands are going to be deleted');
                delete competitorBRsToDeleteList;
            }
            if (LeCercleBRsToDeleteList.size() > 0) {
                System.debug('PRH_Iconic_Brand_Deletion, executeTriggerAction, ' + LeCercleBRsToDeleteList.size() + ' Le Cercle Brands are going to be deleted');
                delete LeCercleBRsToDeleteList;
            }                   
        }
        */
    }
}