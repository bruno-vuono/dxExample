/**
 * Class that handles the accounts and recordtypes for LATAM
 */
public with sharing class LAT_AccountOneTriggerHandler {
	
	// Keep adding migrated record types
	public static final Set<String> LAT_RECORDTYPES = new Set<String> {'On_Trade', 'Off_Trade', 'Eventos','LAT_MX_ACC_OffTrade', 'LAT_MX_ACC_OnTrade'};
	public Set<Id> latRecordTypesId;
	public Map<Id, Account> oldAccountMap;
	public Map<Id, List<Account>> accountByRecordType;
	public Map<Id, Lat_Account__c> latAccountByAccountId {get;set;}
	public boolean isInsert {get;set;}
	public boolean isUpdate {get;set;}
	public boolean isDelete {get;set;}
	public boolean isBefore {get;set;}
	public boolean isAfter {get;set;}

	/**
	 * Constructor 
	 */
	public LAT_AccountOneTriggerHandler(List<Account> triggerNew, 
										Map<Id, Account> triggerOldMap,
										boolean isInsert,
										boolean isUpdate,
										boolean isDelete,
										boolean isBefore,
										boolean isAfter
										) {
		this.isInsert = isInsert;
		this.isUpdate = isUpdate;
		this.isDelete = isDelete;
		this.isBefore = isBefore;
		this.isAfter = isAfter;
		oldAccountMap = triggerOldMap;
		accountByRecordType = new Map<Id, List<Account>>();
		latRecordTypesId = Global_RecordTypeCache.getRtIdSet('Account', LAT_RECORDTYPES);
		if (!isDelete) {
			for (Account acc:triggerNew){
				// DO NOT ADD TO THE MAP IF IT'S NOT A LAT ACCOUNT
				if (latRecordTypesId.contains(acc.RecordTypeId)){
					
					// create List if empty
					if (accountByRecordType.get(acc.RecordTypeId) == null) {
						accountByRecordType.put(acc.RecordTypeId, new List<Account>());
					}

					//add account to list
					accountByRecordType.get(acc.RecordTypeId).add(acc);
				}
			}

			latAccountByAccountId = Lat_Utils.getLatAccountMapByAccId(triggerNew);
		} else {
			for (Account acc : triggerOldMap.values()){
				// DO NOT ADD TO THE MAP IF IT'S NOT A LAT ACCOUNT
				if (latRecordTypesId.contains(acc.RecordTypeId)){
					
					// create List if empty
					if (accountByRecordType.get(acc.RecordTypeId) == null) {
						accountByRecordType.put(acc.RecordTypeId, new List<Account>());
					}

					//add account to list
					accountByRecordType.get(acc.RecordTypeId).add(acc);
				}
			}
		}
	}
	
	/**
	 * get Accounts for a certain RecordTypeName
	 * @param record type developer name
	 * @return the accounts of that recordtype
	 */
	public List<Account> getAccountsForRt(String recordTypeName) {
		return getAccountsForRts(new Set<String>{recordTypeName});
	} 

	/**
	 * get Accounts for a several RecordTypes
	 * @param record type list developer name
	 * @return the accounts of that recordtypes
	 */
	public List<Account> getAccountsForRts(Set<String> recordTypesName) {
		set<Id> recordTypesToProcess = Global_RecordTypeCache.getRtIdSet('Account', recordTypesName);
		List<Account> retAccs = new List<Account>();
		for (String rt: recordTypesToProcess){
			if (accountByRecordType.get(rt) != null ){
				retAccs.addAll(accountByRecordType.get(rt));
			}
		}
		return retAccs;
	} 

	/**
	 * Returns if the trigger has lat accounts on it
	 */
	public boolean hasLatAccounts(){
		return !accountByRecordType.isEmpty();
	}

	public Map<Id, Account> getOldMap(){
		return oldAccountMap;	
	}
	
}