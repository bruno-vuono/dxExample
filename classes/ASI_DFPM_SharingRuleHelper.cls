public without sharing class ASI_DFPM_SharingRuleHelper {
	
	public enum AccessLevel {READ, EDIT, NONE, ALL}
	
	private String shareTypeStr;
	private Schema.SObjectType shareType;
	private Map<ID, ASI_DFPM_ChangeRequest> changeReqMap;
	
	public ASI_DFPM_SharingRuleHelper(String shareTypeStr) {
		this.shareTypeStr = shareTypeStr;
		this.shareType = Schema.getGlobalDescribe().get(shareTypeStr).getDescribe().getSobjectType();
		reset();
	}
	
	public void addChangeRequest(ASI_DFPM_ChangeRequest changeReq) {
		this.changeReqMap.put(changeReq.targetId, changeReq);
	}
	
	public void commitChanges() {
		Set<ID> targetIdSet = this.changeReqMap.keySet();
		if (targetIdSet.size() > 0) {
			List<sObject> deleteShareList = new List<sObject>();
			List<sObject> insertShareList = new List<sObject>();
			List<ASI_DFPM_ChangeRequest> changeReqList = changeReqMap.values();
			Set<String> sharingReasonSet = new Set<String>();
			for (ASI_DFPM_ChangeRequest cReq : changeReqList) {
				if (cReq.includedSharingReasons.size() > 0)
					sharingReasonSet.addAll(cReq.includedSharingReasons);
				List<List<ASI_DFPM_UserOrGroupSetting>> tempUserOrGroupSettingsList = cReq.userOrGoupIdToSettingsMap.values();
				for (List<ASI_DFPM_UserOrGroupSetting> tempUserOrGroupSettings : tempUserOrGroupSettingsList)
					for (ASI_DFPM_UserOrGroupSetting tempUserOrGroupSetting : tempUserOrGroupSettings)
						sharingReasonSet.add(tempUserOrGroupSetting.sharingReason);
			}
			
			// Get the existing sharing rules
			List<sObject> allShareList = database.query('SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM ' + shareTypeStr + ' WHERE ParentId IN :targetIdSet AND RowCause IN :sharingReasonSet');
			Map<ID, List<sObject>> targetIdToSharesMap = new Map<ID, List<sObject>>();
			for (sObject tempShare : allShareList) {
				List<sObject> shareList = targetIdToSharesMap.get((ID)tempShare.get('ParentId'));
				if (shareList == null) {
					shareList = new List<sObject>();
					targetIdToSharesMap.put((ID)tempShare.get('ParentId'), shareList);
				}
				shareList.add(tempShare);
			}
			
			// Handle target record one by one
			for (ID targetId : targetIdSet) {
				ASI_DFPM_ChangeRequest changeReq = this.changeReqMap.get(targetId);
				List<sObject> shareList = targetIdToSharesMap.get(targetId);
				if (shareList == null) shareList = new List<sObject>();
				
				// Delete existing sharing rules if not matched
				Map<ID, Set<String>> alreadyExistOwnerIdAndSharingReasonMap = new Map<ID, Set<String>>();
				for (sObject share : shareList) {
					String sharingReason = (String)share.get('RowCause');
					ID uOrGId = (ID)share.get('UserOrGroupId');
					ASI_DFPM_UserOrGroupSetting foundUserOrGroupSetting = null;
					List<ASI_DFPM_UserOrGroupSetting> userOrGroupSettings = changeReq.userOrGoupIdToSettingsMap.get(uOrGId);
					if (UserOrGroupSettings != null) {
						for (ASI_DFPM_UserOrGroupSetting userOrGroupSetting : userOrGroupSettings) {
							if (UserOrGroupSetting.sharingReason == sharingReason) {
								foundUserOrGroupSetting = userOrGroupSetting;
							}
						}
					}
					if (foundUserOrGroupSetting == null || accessLevelStr(foundUserOrGroupSetting.accLevel) != (String)share.get('AccessLevel')) {
						deleteShareList.add(share);
					} else {
						Set<String> srSet = alreadyExistOwnerIdAndSharingReasonMap.get(uOrGId);
						if (srSet == null) {
							srSet = new Set<String>();
							alreadyExistOwnerIdAndSharingReasonMap.put(uOrGId, srSet);
						}
						srSet.add(sharingReason);
					}
				}
				
				// Insert sharing rules
				Set<ID> changeRequserOrGoupIdSet = changeReq.userOrGoupIdToSettingsMap.keySet();
				for (ID changeRequserOrGoupId : changeRequserOrGoupIdSet) {
					List<ASI_DFPM_UserOrGroupSetting> userOrGroupSettings = changeReq.userOrGoupIdToSettingsMap.get(changeRequserOrGoupId);
					Set<String> alreadyExistSharingReasonSet = alreadyExistOwnerIdAndSharingReasonMap.get(changeRequserOrGoupId);
					for (ASI_DFPM_UserOrGroupSetting oSetting : userOrGroupSettings) {
						String cReqSharingReason = oSetting.sharingReason;
						if (alreadyExistSharingReasonSet == null || !alreadyExistSharingReasonSet.contains(cReqSharingReason)) {
							String accLevelStr = accessLevelStr(oSetting.accLevel);
							insertShareList.add(generateShareSObj(targetId, changeRequserOrGoupId, accLevelStr, cReqSharingReason));
						}
					}
				}
			}
			
			// Commit to database
			if (deleteShareList.size() > 0 || insertShareList.size() > 0) {
				System.Savepoint sp = database.setSavepoint();
				try {
					delete deleteShareList;
					insert insertShareList;
				} catch (Exception e) {
					database.rollback(sp);
					throw e;
				}
			}
			reset();
		}
	}
	
	private void reset() {
		this.changeReqMap = new Map<ID, ASI_DFPM_ChangeRequest>();
	}
	
	private sObject generateShareSObj(ID parentId, ID userOrGroupId, String accessLevel, String rowCause) {
		sObject result = this.shareType.newSObject();
		result.put('ParentId', parentId);
		result.put('UserOrGroupId', userOrGroupId);
		result.put('AccessLevel', accessLevel);
		result.put('RowCause', rowCause);
		return result;
	}
	
	private String accessLevelStr(AccessLevel accLevel) {
		if (accLevel == AccessLevel.READ) {
			return 'Read';
		} else if (accLevel == AccessLevel.EDIT) {
			return 'Edit';
		} else if (accLevel == AccessLevel.NONE) {
			return 'None';
		} else if (accLevel == AccessLevel.ALL) {
			return 'All';
		}
		return null;
	}
	
	public with sharing class ASI_DFPM_ChangeRequest {
		public ID targetId;
		public Set<String> includedSharingReasons;
		public Map<ID, List<ASI_DFPM_UserOrGroupSetting>> userOrGoupIdToSettingsMap;
		
		public ASI_DFPM_ChangeRequest(ID targetId) {
			this(targetId, null);
		}
		
		public ASI_DFPM_ChangeRequest(ID targetId, Set<String> includedSharingReasons) {
			this.targetId = targetId;
			this.includedSharingReasons = includedSharingReasons == null ? new Set<String>() : includedSharingReasons;
			this.userOrGoupIdToSettingsMap = new Map<ID, List<ASI_DFPM_UserOrGroupSetting>>();
		}
		
		public void addUserOrGroup(ID userOrGoupId, AccessLevel accLevel, String sharingReason) {
			List<ASI_DFPM_UserOrGroupSetting> settings = this.userOrGoupIdToSettingsMap.get(userOrGoupId);
			if (settings == null) {
				settings = new List<ASI_DFPM_UserOrGroupSetting>();
				this.userOrGoupIdToSettingsMap.put(userOrGoupId, settings);
			}
			// TODO: Do not allow duplicate sharing reason in setting list
			settings.add(new ASI_DFPM_UserOrGroupSetting(accLevel, sharingReason));
		}
	}
	
	private with sharing class ASI_DFPM_UserOrGroupSetting {
		public AccessLevel accLevel;
		public String sharingReason;
		
		private ASI_DFPM_UserOrGroupSetting(AccessLevel accLevel, String sharingReason) {
			this.accLevel = accLevel;
			this.sharingReason = sharingReason;
		}
	}
}