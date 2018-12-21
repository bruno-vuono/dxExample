public without sharing class EUR_CRM_NG_ShareEUAccountHandler extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_NG_ShareEUAccountHandler(){
        super('EUR_CRM_NG_ShareEUAccountHandler');
    } 

    private static Set<String> allEUAccountRecordTypeSet = new Set<String>{
          'EUR_NG_On_Trade'
    };

    private static String ON_TRADE = 'ON TRADE';
    private static String OFF_TRADE = 'OFF TRADE';
    private static String TERRITORY_NG_DEV_NAME = 'EUR_CRM_NG_Territory';
    private static String EUACCOUNT_NG_ON_TRADE = 'EUR_NG_On_Trade';

    public static Set<String> TargetRecordSet {
        get{
            Set<String> TRt = new Set<String>();
            TRt.addAll(allEUAccountRecordTypeSet);

            return TRt;
        }private set;
    }

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){ 
        System.Debug('EUR_CRM_NG_ShareEUAccountHandler');

        /*Boolean ProcessCheck = false;
        for(sObject tacc : newMap.values()){
            If(allEUAccountRecordTypeSet.contains(((EUR_CRM_Account__c)tacc).RecordType.DeveloperName))
            {ProcessCheck = true;}
        }

        if(!ProcessCheck)
        {
            return;
        }*/

        List<Recordtype> accountRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Account__c');
        List<Recordtype> territoryTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Territory__c');
        Map<Id,Recordtype> accountRecordTypesMap = new Map<Id,Recordtype>();
        Map<Id,Recordtype> territoryTypesMap = new Map<Id,Recordtype>();
        Map<Id,EUR_CRM_Territory__c> territoryMap = new Map<Id,EUR_CRM_Territory__c>();
        Map<Id,Id> euAccountUnshareMap = new Map<Id,Id>();
        Set<Id> euAccountIds = new Set<Id>();
        Set<Id> unShareUserIds = new Set<Id>();
        Id territoryNGId;

        List<EUR_CRM_Account__Share> euAcctSharelistDelete = new List<EUR_CRM_Account__Share>();
        List<AccountShare> stdAcctSharelistDelete = new List<AccountShare>();

        List<EUR_CRM_Account__Share> euAcctSharelist = new List<EUR_CRM_Account__Share>();
        List<AccountShare> stdAcctSharelist = new List<AccountShare>();

        for(Recordtype rt : accountRecordTypes){
           accountRecordTypesMap.put(rt.id,rt);
        }
        for(Recordtype rt : territoryTypes){
           //territoryTypesMap.put(rt.id,rt);
            if(rt.DeveloperName == TERRITORY_NG_DEV_NAME){
                territoryNGId = rt.Id;
            }
        }

        for(EUR_CRM_Territory__c territory : [SELECT
                                                        Id,
                                                        EUR_CRM_KD_Owner__c,
                                                        EUR_CRM_Off_Trade_Owner__c,
                                                        EUR_CRM_On_Trade_Owner__c,
                                                        RecordtypeId
                                                      FROM
                                                        EUR_CRM_Territory__c
                                                      WHERE
                                                        RecordtypeId
                                                      =
                                                        :territoryNGId]){

            
            territoryMap.put(territory.Id, territory);
        }
        
		// Code to retrieve image level
		Set<ID> imageLevelIDs = new Set<ID>();
		Map<ID, EUR_CRM_Image_Level__c> imageLevelMap = new Map<ID, EUR_CRM_Image_Level__c>();
		for (EUR_CRM_Account__c acct : (List<EUR_CRM_Account__c>) sObjList){   
			if(acct.EUR_CRM_Image_Level__c != null) {
				imageLevelIDs.add(acct.EUR_CRM_Image_Level__c);
			}
		}
		
		if(imageLevelIDs.size() > 0) {
			imageLevelMap = new Map<ID, EUR_CRM_Image_Level__c>([SELECT ID, Name, EUR_CRM_Affiliate_Country__c, EUR_CRM_Name__c, EUR_CRM_External_ID__c
																	FROM EUR_CRM_Image_Level__c
																	WHERE ID IN : imageLevelIDs]);
		}

        for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){
        	
			EUR_CRM_Image_Level__c imgLevel = imageLevelMap.containsKey(euAccount.EUR_CRM_Image_Level__c) ? imageLevelMap.get(euAccount.EUR_CRM_Image_Level__c) : new EUR_CRM_Image_Level__c();
			
            String accountRecordTypeDeveloperName = accountRecordTypesMap.get(euAccount.RecordtypeId).DeveloperName;
            EUR_CRM_Account__c oldEuAccount = tAction == TriggerAction.AFTER_UPDATE ? ((EUR_CRM_Account__c) oldMap.get(euAccount.id)) : null;
            

            if(tAction == TriggerAction.AFTER_UPDATE || tAction == TriggerAction.AFTER_INSERT){
                System.debug(accountRecordTypesMap.get(euAccount.RecordTypeId).Developername);
                System.debug(imgLevel.EUR_CRM_Name__c);
                if(accountRecordTypesMap.get(euAccount.RecordtypeId).Developername == EUACCOUNT_NG_ON_TRADE && imgLevel.EUR_CRM_Name__c != 'Mainstream'){
                    //System.debug('%%IS NG'); 
                    if(tAction == TriggerAction.AFTER_UPDATE){
                        if(euAccount.EUR_CRM_Territory__c != oldEuAccount.EUR_CRM_Territory__c && euAccount.EUR_CRM_Territory__c != null){
                           euAccountIds.add(euAccount.Id);
                           if(oldEuAccount.EUR_CRM_Territory__c != null) {
                           		euAccountUnshareMap.put(euAccount.Id, territoryMap.get(oldEuAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c);
                           }
                           
                        }
                    }
                    if(tAction == TriggerAction.AFTER_INSERT){
                        if(territoryMap.containskey(euAccount.EUR_CRM_Territory__c) && euAccount.EUR_CRM_Territory__c != null){
                            euAccountIds.add(euAccount.Id);
                        }
                    }
                }
            }

        }

        System.debug('&&UNSHAREMAP: '+euAccountUnshareMap);

        for(Id euAccountId: euAccountUnshareMap.keySet()){
            unShareUserIds.add(euAccountUnshareMap.get(euAccountId));
        }

        System.debug('&&EUACCTIDS: '+euAccountIds);

        Map<Id,Id> euAccountToAccountMap = new Map<Id,Id>();
        Map<Id,Id> accountToEUAccountMap = new Map<Id,Id>();

        if(euAccountIds.size() > 0){
            for(EUR_CRM_Account_Link__c link: [select EUR_CRM_Standard_Account__c,EUR_CRM_EU_Account__c from EUR_CRM_Account_Link__c where EUR_CRM_EU_Account__c in:euAccountIds]){
                euAccountToAccountMap.put(link.EUR_CRM_EU_Account__c, link.EUR_CRM_Standard_Account__c);
                accountToEUAccountMap.put(link.EUR_CRM_Standard_Account__c, link.EUR_CRM_EU_Account__c);
            }
        }

        System.debug('&&EU: '+euAccountToAccountMap);
        System.debug('&&STD ACT: '+accountToEUAccountMap);

        if(euAccountToAccountMap.size() > 0){
            for(EUR_CRM_Account__Share aShare : [select RowCause, id,ParentId,UserOrGroupId from EUR_CRM_Account__Share where parentid in: euAccountToAccountMap.keyset() and UserOrGroupId in:unShareUserIds and rowCause = 'Manual']){
                euAcctSharelistDelete.add(aShare);
            }
        }

        if(euAccountToAccountMap.size() > 0){
            for(AccountShare aShare : [select RowCause, id,AccountId,UserOrGroupId from AccountShare where AccountId in: accountToEUAccountMap.keyset() and UserOrGroupId in:unShareUserIds and rowCause = 'Manual']){
                stdAcctSharelistDelete.add(aShare);
            }
        }

        System.debug('&&EUSHARE: '+euAcctSharelistDelete);
        System.debug('&&STD ACTSHARE: '+euAcctSharelistDelete);

        if(euAcctSharelistDelete.size() > 0){
            delete euAcctSharelistDelete;
        }

        if(stdAcctSharelistDelete.size() > 0){
            delete stdAcctSharelistDelete;
        }

        for(EUR_CRM_Account__c euAccount : (List<EUR_CRM_Account__c>) sObjList){

            String accountRecordTypeDeveloperName = accountRecordTypesMap.get(euAccount.RecordtypeId).DeveloperName;
            EUR_CRM_Account__c oldEuAccount = tAction == TriggerAction.AFTER_UPDATE ? ((EUR_CRM_Account__c) oldMap.get(euAccount.id)) : null;
            
            EUR_CRM_Image_Level__c imgLevel = imageLevelMap.containsKey(euAccount.EUR_CRM_Image_Level__c) ? imageLevelMap.get(euAccount.EUR_CRM_Image_Level__c) : new EUR_CRM_Image_Level__c();
			
            if(tAction == TriggerAction.AFTER_UPDATE || tAction == TriggerAction.AFTER_INSERT){
                if(accountRecordTypesMap.get(euAccount.RecordtypeId).Developername == EUACCOUNT_NG_ON_TRADE && imgLevel.EUR_CRM_Name__c != 'Mainstream'){
                    //System.debug('%%IS NG'); 
                    if(tAction == TriggerAction.AFTER_UPDATE){
                        if(euAccount.EUR_CRM_Territory__c != oldEuAccount.EUR_CRM_Territory__c){
                            // Only grant access to account which doesn't already belong to the KD owner
                            if(territoryMap.containskey(euAccount.EUR_CRM_Territory__c) && territoryMap.get(euAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c != euAccount.OwnerId){
                                euAcctSharelist.add(createEUAcctShare(euAccount.Id, territoryMap.get(euAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c));
                                stdAcctSharelist.add(createAcctShare(euAccountToAccountMap.get(euAccount.Id),territoryMap.get(euAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c));
                            }
                        }
                    }
                    if(tAction == TriggerAction.AFTER_INSERT){
                        if(territoryMap.containskey(euAccount.EUR_CRM_Territory__c) && territoryMap.get(euAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c != euAccount.OwnerId){
                            if(euAccount.EUR_CRM_Channel__c == ON_TRADE && euAccount.EUR_CRM_Territory__c != null){
                                euAcctSharelist.add(createEUAcctShare(euAccount.Id, territoryMap.get(euAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c));
                                stdAcctSharelist.add(createAcctShare(euAccountToAccountMap.get(euAccount.Id),territoryMap.get(euAccount.EUR_CRM_Territory__c).EUR_CRM_KD_Owner__c));
                            }
                        }
                    }
                }
            }

        }
 
        if(euAcctSharelist.size() > 0){
            insert euAcctSharelist;
        }
        if(stdAcctSharelist.size() > 0){
            insert stdAcctSharelist;
        }
    }

    @testVisible private EUR_CRM_Account__Share createEUAcctShare(Id euAccountId, Id userOrGroupId){
      EUR_CRM_Account__Share teamMember = new EUR_CRM_Account__Share();
      teamMember.AccessLevel = 'Edit';
      teamMember.ParentId = euAccountId;
      teamMember.UserOrGroupId = userOrGroupId;
      return teamMember;
    }
    @testVisible private  AccountShare createAcctShare(Id accountId, Id userOrGroupId){
      AccountShare teamMember = new AccountShare();
      teamMember.AccountAccessLevel = 'Edit';
      teamMember.AccountId = accountId;
      teamMember.OpportunityAccessLevel = 'None';
      teamMember.UserOrGroupId = userOrGroupId;
      return teamMember;
    }

}