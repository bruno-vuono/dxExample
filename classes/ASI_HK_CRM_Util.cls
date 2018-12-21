public without sharing class ASI_HK_CRM_Util {

    // Checking to avoid firing HK_CRM account trigger irrelevant to its recordtype
    public static boolean isTwAcct(list<Account> triggerlist)
    {
        boolean isTw = false;
        map<string, id> rt_map = getRecordTypeId('Account');
        for (Account acctCheck : triggerlist)
        {
            if (acctCheck.recordTypeId == rt_map.get('ASI_MFM_TW_Supplier') || acctCheck.recordTypeId == rt_map.get('ASI_MFM_TW_Customer'))
            {
                isTw = true;
                break;
            }
        }  
        return isTw;
    }
    
    // Checking to avoid firing HK_CRM account trigger irrelevant to its recordtype
    public static boolean isLuxAcct(list<Account> triggerlist)
    {
        boolean isLux = false;
        map<string, id> rt_map = getRecordTypeId('Account');
        for (Account acctCheck : triggerlist)
        {
            if (acctCheck.recordTypeId == rt_map.get('ASI_Luxury_Account_HK_First_Contact') || 
            	acctCheck.recordTypeId == rt_map.get('ASI_Luxury_Account_HK_Second_Contact') ||
            	acctCheck.recordTypeID == rt_map.get('ASI_Luxury_Account_HK_Potential') ||
            	acctCheck.recordTypeID == rt_map.get('ASI_Luxury_Account_HK_Second_Contact_Le_Cercle_Locked')||
            	acctCheck.recordTypeID == rt_map.get('ASI_Luxury_Account_Regional_Second_Contact')|| 
            	acctCheck.recordTypeID == rt_map.get('ASI_Luxury_Account_Regional_Second_Contact_Le_Cercle_Locked'))
            {
                isLux = true;
                break;
            }
        }  
        return isLux;
    }
    
    public static map<string, id> getRecordTypeId(string object_type) {
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, DeveloperName from recordType where SobjectType = :object_type]) {
            rt_map.put(rt.DeveloperName, rt.id);            
        }
        return rt_map;
    }

}