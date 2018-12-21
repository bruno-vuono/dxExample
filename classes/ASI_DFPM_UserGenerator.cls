public with sharing class ASI_DFPM_UserGenerator {
	public static final String DEF_VALUE_PROFILE_NAME = 'ADF';
	public static final ID DEF_VALUE_PROFILE_ID;
	public static final String DEF_VALUE_ROLE_NAME = null;
	public static final ID DEF_VALUE_ROLE_ID;
	public static final String DEF_VALUE_PERMISSION_SET_NAME = 'ASI_DFPM_User';
	public static final ID DEF_VALUE_PERMISSION_SET_ID;
	public static final String DEF_VALUE_EMAIL_DOMAIN = '@pernod-ricard.com.asipm';
	public static final String DEF_VALUE_EMAIL_ENCODE_KEY = 'UTF-8';
	public static final String DEF_VALUE_LOCALE = 'en_US';
	public static final String DEF_VALUE_LANG = 'en_US';
	public static final String DEF_VALUE_TIMEZONE = 'Europe/Paris';
	public static final String DEF_BYPASS_TRIGGERS = 'Autofollow_User_InsertUpdate;AutoJoin_User_InsertUpdate;ChatterEmailSettings;AP01';
	
	static {
		if (DEF_VALUE_PROFILE_NAME != null) {
			List<Profile> defProfileList = [SELECT Id FROM Profile WHERE Name = :DEF_VALUE_PROFILE_NAME];
			if (defProfileList.size() > 0) {
				DEF_VALUE_PROFILE_ID = defProfileList.get(0).Id;
			}
		}
		if (DEF_VALUE_ROLE_NAME != null) {
			List<UserRole> defRoleList = [SELECT Id FROM UserRole WHERE Name = :DEF_VALUE_ROLE_NAME];
			if (defRoleList.size() > 0) {
				DEF_VALUE_ROLE_ID = defRoleList.get(0).Id;
			}
		}
		if (DEF_VALUE_PERMISSION_SET_NAME != null) {
			List<PermissionSet> defPSList = [SELECT Id FROM PermissionSet WHERE Name = :DEF_VALUE_PERMISSION_SET_NAME];
			if (defPSList.size() > 0) {
				DEF_VALUE_PERMISSION_SET_ID = defPSList.get(0).Id;
			}
		}
	}
	
	public User generateBasicUser(String username, String email
		, String lastName, String firstName, String nickName, String alias
		, ID userProfileId, ID userRoleId) {
		return new User(
			Username = username
			, Email = email
			, LastName = lastName
			, FirstName = firstName
			, CommunityNickname = nickName
			, Alias = alias
			, ProfileId = userProfileId
			, UserRoleId = userRoleId
			, EmailEncodingKey = DEF_VALUE_EMAIL_ENCODE_KEY
			, LocaleSidKey = DEF_VALUE_LOCALE
			, LanguageLocaleKey = DEF_VALUE_LANG
			, TimeZoneSidKey = DEF_VALUE_TIMEZONE
			, BypassTriggers__c = DEF_BYPASS_TRIGGERS
			, Autofollow__c = false
		);
	}

	public User generateUser(String lastName) {
		String convertedName = lastName.trim().replace(' ', '_').toLowerCase();
		return generateBasicUser(
			convertedName + DEF_VALUE_EMAIL_DOMAIN, convertedName + DEF_VALUE_EMAIL_DOMAIN
			, lastName, null, convertedName, convertedName.substring(0, convertedName.length() >= 8 ? 8 : convertedName.length())
			, DEF_VALUE_PROFILE_ID, DEF_VALUE_ROLE_ID
		);
	}
	
	public PermissionSetAssignment generatePermissionSetAssignment(User theUser, ID permissionSetId) {
		return new PermissionSetAssignment(
			AssigneeId = theUser.Id
			, PermissionSetId = permissionSetId
		);
	}
	public PermissionSetAssignment generatePermissionSetAssignment(User theUser) {
		return generatePermissionSetAssignment(theUser, DEF_VALUE_PERMISSION_SET_ID);
	}
	
}