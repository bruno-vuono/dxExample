public class PRH_Luxury_Account_Full_Active extends PRH_TriggerAbstract{
    public PRH_Luxury_Account_Full_Active() {
        super('PRH_Luxury_Account_Full_Active');
    }
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        
        if (tAction == TriggerAction.AFTER_UPDATE) {
            List<ID> accIDList = new List<ID>();
            List<PRH_Brand_Criteria__c> updatedBrandCriteriaList = (List<PRH_Brand_Criteria__c>) sObjList;
            for(PRH_Brand_Criteria__c updated: updatedBrandCriteriaList){
                accIDList.add(updated.PRH_Collect__c);
            }
            System.debug('accIDList : ' + accIDList);
            List<PRH_Brand_Criteria__c> criteriaList =[Select id,PRH_Presence__c, PRH_Brand__c,PRH_Collect__c, PRH_Brand__r.PRH_Presence_Category__c From PRH_Brand_Criteria__c where PRH_Collect__c in :accIDList and PRH_Collect__r.PRH_Active__c=true];
            
            // *** WARNING *** The algoritm below must be the same as the one used in class PRH_UpdateCollectsCalculatedValues
            //Evolution LCS-170
            // New rules update for "Full Active Portfolio"(previous field name) or now "Full Le Cercle" [objet Collect PRH_Collect__c, field PRH_Full_Active_Le_Cercle_Portfolio__c ]
            // The rules to set Full Le Cercle = True has been updated. From now on, the 2 following rules must be fulfilled : 
            // 1- All Le Cercle brand must have Presence checked if iconic brand(PRH_Brand_Luxury_Brand__c) field PRH_Portfolio_Presence__c(Portfolio Presence) is true 
            // 2- One of the Le Cercle Brand “Rum“ Category must have Presence checked (PRH_Brand_Luxury_Brand__c.PRH_Presence_Category__c)
            
            Try {
            //RULE 1
                        
            // Search Le Cercle Brand on active collect which have Portfolio presence to true on iconic brand and iconic brand active
            List<PRH_Brand_Criteria__c> idLCB = [select id from PRH_Brand_Criteria__c 
                                            	where PRH_Brand__r.PRH_Portfolio_Presence__c = true 
                                                and PRH_Collect__r.PRH_Active__c=true 
                                                and PRH_Collect__c in :accIDList
                                                and PRH_Brand__r.PRH_Active__c = true];  
                
            // Number of Le Cercle Brand on active collect which have Portfolio presence to true on iconic brand and iconic brand active 
            long nbidLCB = idLCB.size();
            System.debug('Number of Le Cercle Brand which have Portfolio presence to true on iconic brand and iconic brand active nbidLCB' + nbidLCB);    
                
            // Search Le Cercle Brand on active collect which have Portfolio presence to true
            List<PRH_Brand_Criteria__c> idLCBPresencePortfolio = [select PRH_Brand__r.id from PRH_Brand_Criteria__c 
                                            					  where PRH_Brand__r.PRH_Portfolio_Presence__c = true 
                                                                  and PRH_Collect__r.PRH_Active__c=true 
                                                                  and PRH_Collect__c in :accIDList
                                                                  and  PRH_Presence__c=true 
                                                                  and PRH_Brand__r.PRH_Active__c = true];
             
                
                
            // Number of Le Cercle Brand on active collect which have Portfolio presence to true
            long nbLCBPresencePortfolio = idLCBPresencePortfolio.size();
            System.debug('Number of Le Cercle Brand on active collect which have Portfolio presence to true nbLCBPresencePortfolio ' + nbLCBPresencePortfolio );
                  
            //RULE 2
            // Search le cercle brand "Rum" category on active collect
            //List<PRH_Brand_Criteria__c> idRumCollect =[select id from PRH_Brand_Criteria__c 
            //                                              where PRH_Collect__r.PRH_Active__c=true 
            //                                              and PRH_Collect__c in :accIDList 
            //                                              and PRH_Brand__r.PRH_Active__c = true 
            //                                              and PRH_Brand__r.PRH_Presence_Category__c='Rum'];
            
            // Number of le cercle brand "Rum" category on active collect
        	//long numberRumCollect = idRumCollect.size();
            //System.debug('Number of le cercle brand "Rum" category on active collect numberRumCollect ' + numberRumCollect );
            
            // Search le cercle brand "Rum" category which have presence to true on active collect
            List<PRH_Brand_Criteria__c> idRumPresenceCollect =[select id from PRH_Brand_Criteria__c 
                                                           where PRH_Collect__r.PRH_Active__c=true 
                                                           and PRH_Collect__c in :accIDList 
                                                           and PRH_Brand__r.PRH_Active__c = true 
                                                           and PRH_Brand__r.PRH_Presence_Category__c='Rum'
                                                           and PRH_Presence__c=true];   
            
            // Number of le cercle brand "Rum" category which have presence to true on active collect
            long numberRumPresenceCollect = idRumPresenceCollect.size();
            System.debug('Number of le cercle brand "Rum" category which have presence to true on active collect numberRumPresenceCollect ' + numberRumPresenceCollect );
            
            
            // Search active collect to update with id of iconic account
            List<PRH_Collect__c> collectToUpdate = [Select id , PRH_Full_Active_Le_Cercle_Portfolio__c From PRH_Collect__c where ID in :accIDList];
            
            // Application of rules
            // For information if there's no portfolio presence on iconic brands PRH_Full_Active_Le_Cercle_Portfolio__c stay false
            // For information if there's no rum category on iconic brands the rule 2 is not canceled
            System.debug('nbidLCB' + nbidLCB );
            System.debug('nbLCBPresencePortfolio' + nbLCBPresencePortfolio );
            System.debug('numberRumPresenceCollect' + numberRumPresenceCollect );
            for(PRH_Collect__c coll : collectToUpdate){                 
                    if (nbidLCB==nbLCBPresencePortfolio && nbidLCB!=0 && numberRumPresenceCollect>=1){
                        coll.PRH_Full_Active_Le_Cercle_Portfolio__c=true;   
                    }
                    else{
                        coll.PRH_Full_Active_Le_Cercle_Portfolio__c=false;  
                    }
            }
            
            //Update field Full Le Cercle
            update collectToUpdate;
                
            } catch (Exception e) {
            System.Debug('--> PRH_Luxury_Account_Full_Active, error:'+ e.getMessage());
            System.Debug('--> PRH_Luxury_Account_Full_Active, error:'+ e.getLineNumber());
            System.Debug('--> PRH_Luxury_Account_Full_Active, error:'+ e.getStackTraceString());
        }   
            //END LCS-170
            
            
            
            
/////////////PREVIOUS RULES
           /* Map<ID, Set<PRH_Brand_Criteria__c>> accountCriteriaMap = new Map<ID, Set<PRH_Brand_Criteria__c>>();
            Set<ID> accIDs = new Set<ID>();
            for(PRH_Brand_Criteria__c criteria : criteriaList){
                if(!accIDs.contains(criteria.PRH_Collect__c)){
                    accIDs.add(criteria.PRH_Collect__c);
                }
                if(accountCriteriaMap.containsKey(criteria.PRH_Collect__c)){
                    Set<PRH_Brand_Criteria__c> criteriaSet = accountCriteriaMap.get(criteria.PRH_Collect__c);
                    if(!criteriaSet.contains(criteria)){
                        criteriaSet.add(criteria);
                        accountCriteriaMap.put(criteria.PRH_Collect__c,criteriaSet);
                    }
                }else{
                    Set<PRH_Brand_Criteria__c> criteriaSet = new Set<PRH_Brand_Criteria__c>();
                    criteriaSet.add(criteria);
                    accountCriteriaMap.put(criteria.PRH_Collect__c,criteriaSet);
                }
                
            }
            accIDList = new List<ID>(accIDs);
            List<ID> updateAccountList = new List<ID>();
            List<ID> updateAccountFalseList = new List<ID>();
            for(ID accID : accIDList){
                System.debug('Test acc : ' + accID);
                List<PRH_Brand_Criteria__c> bcList = new List<PRH_Brand_Criteria__c>(accountCriteriaMap.get(accID));
                Map<String,Set<PRH_Brand_Criteria__c>> categoryCriteriaMap= new Map<String,Set<PRH_Brand_Criteria__c>>();
                for(PRH_Brand_Criteria__c bc : bcList){
                    if(categoryCriteriaMap.containsKey(bc.PRH_Brand__r.PRH_Presence_Category__c)){
                       Set<PRH_Brand_Criteria__c> criteriaSet = categoryCriteriaMap.get(bc.PRH_Brand__r.PRH_Presence_Category__c);
                        if(!criteriaSet.contains(bc)){
                            criteriaSet.add(bc);
                            categoryCriteriaMap.put(bc.PRH_Brand__r.PRH_Presence_Category__c,criteriaSet);
                        }
                    }else{
                            Set<PRH_Brand_Criteria__c> criteriaSet = new Set<PRH_Brand_Criteria__c>();
                            criteriaSet.add(bc);
                            categoryCriteriaMap.put(bc.PRH_Brand__r.PRH_Presence_Category__c,criteriaSet); 
                    }
                    System.debug('Test map : ' + bc);
                    System.debug('Test map : ' + categoryCriteriaMap);
                }
                
                List<String> categories = new List<String> (categoryCriteriaMap.keySet());
                
                Boolean finalChecker = true;
                for(String category : categories){
                    Boolean checker = false;
                    System.debug('Test cate : ' +category);
                    
                    List<PRH_Brand_Criteria__c> bcL  =  new List<PRH_Brand_Criteria__c>( categoryCriteriaMap.get(category));
                    System.debug('Test CRITERIA : ' +bcl);
                    for(PRH_Brand_Criteria__c bc : bcL){
                        System.debug('Test cate : ' + bc.PRH_Presence__c );
                        if(bc.PRH_Presence__c == true){
                            checker = true;
                        }
                    }
                    if(checker ==false){
                        finalChecker = false;
                    }
                    System.debug('finalChecker' + finalChecker );
                }
                System.debug('Test fc: ' + finalChecker + ' ' + accID);
                if(finalChecker==true){
                    updateAccountList.add(accID);
                }else{
                    updateAccountFalseList.add(accID);
                }
            }

            List<PRH_Collect__c> collUpdate = [Select id , PRH_Full_Active_Le_Cercle_Portfolio__c From PRH_Collect__c where ID in :updateAccountList];
             List<PRH_Collect__c> collFalseUpdate = [Select id , PRH_Full_Active_Le_Cercle_Portfolio__c From PRH_Collect__c where ID in :updateAccountFalseList];
           // List<PRH_Luxury_Accounts__c> luxAccUpdate = [Select id , PRH_Full_Active_l_Atelier_Portfolio__c From PRH_Luxury_Accounts__c where ID in :updateAccountList];
            //List<PRH_Luxury_Accounts__c> luxAccFalseUpdate = [Select id , PRH_Full_Active_l_Atelier_Portfolio__c From PRH_Luxury_Accounts__c where ID in :updateAccountFalseList];
            /*System.debug('Final Test : ' + luxAccUpdate);
            for(PRH_Luxury_Accounts__c acc: luxAccUpdate){
                acc.PRH_Full_Active_l_Atelier_Portfolio__c= true;
            }
            for(PRH_Luxury_Accounts__c acc: luxAccFalseUpdate){
                acc.PRH_Full_Active_l_Atelier_Portfolio__c= false;
            }
            update luxAccUpdate;
            update luxAccFalseUpdate;*/
             /* System.debug('Final Test : ' + collUpdate);
            for(PRH_Collect__c acc: collUpdate){
                acc.PRH_Full_Active_Le_Cercle_Portfolio__c= true;
            }
            for(PRH_Collect__c acc: collFalseUpdate){
                acc.PRH_Full_Active_Le_Cercle_Portfolio__c= false;
            }
            //update collUpdate;
            //update collFalseUpdate;*/
        }
    }
}