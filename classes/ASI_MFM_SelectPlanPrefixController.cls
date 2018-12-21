public with sharing class ASI_MFM_SelectPlanPrefixController {
    map<string, asi_mfm_role_prefix_relationship__c> px_map = new map<string, asi_mfm_role_prefix_relationship__c>();   
    
    public list<selectOption> available_prefixes {get; private set;}
    public string selected_prefix {get; set;}

    public ASI_MFM_SelectPlanPrefixController(apexpages.standardController sc) {
    }
    
    public pageReference getPrefixes() {
        user u = [select userRole.developerName, asi_mfm_country__c from user where id = :userInfo.getUserId()];
        if (u.userRole.developerName == null) {
            apexpages.message err = new apexpages.message(apexpages.severity.error, 'The role of the user is not defined yet');
            apexpages.addmessage(err); 
        }
        else if (u.asi_mfm_country__c == null) {
            apexpages.message err = new apexpages.message(apexpages.severity.error, 'The country of the user is not defined yet');
            apexpages.addmessage(err); 
        }
        else {
            list<asi_mfm_role_prefix_relationship__c> px_list = new list<asi_mfm_role_prefix_relationship__c>();
            for (asi_mfm_role_prefix_relationship__c px:[select asi_mfm_prefix__c, asi_mfm_prefix__r.name,asi_mfm_prefix__r.RecordType.DeveloperName from asi_mfm_role_prefix_relationship__c
                where asi_mfm_prefix__r.ASI_MFM_Inactive__c = false and asi_mfm_prefix__r.asi_mfm_module__c = 'Plan' and asi_mfm_role_name__c = :u.userRole.developerName and asi_mfm_prefix__r.asi_mfm_country_name__c = :u.asi_mfm_country__c order by asi_mfm_prefix__r.name]) {
                px_map.put(px.asi_mfm_prefix__c, px);
                px_list.add(px);    
            }
             if(u.asi_mfm_country__c=='KR'){//For KR User only
                return new pageReference('/apex/ASI_MFM_KR_SelectProjectCodePage?Module=Plan'); 
            }
            
            if (px_list.size() == 0) {
                apexpages.message err = new apexpages.message(apexpages.severity.error, 'The user is not entitled to input plans');
                apexpages.addmessage(err); 
            }
            else if (px_list.size() == 1) {
                selected_prefix = px_list[0].asi_mfm_prefix__c;
                return proceed();
            }
            else if(u.asi_mfm_country__c=='PH' && px_list.size()>1){ 
                String Recordtypeid = ApexPages.currentPage().getParameters().get('RecordType');
                System.debug('Recordtypeid = ' +ApexPages.currentPage().getParameters());
                Map<String, id> MPlanRecType = new Map<String,id>();
                for(Recordtype r : Global_recordTypeCache.getRtList('ASI_MFM_Plan__c')){
                    MPlanRecType.put(r.developername,r.id);
                }
                if(MPlanRecType.get('ASI_MFM_PH_DP_Plan')==Recordtypeid){
                    available_prefixes = new list<selectOption>();
                    available_prefixes.add(new selectOption('', '-- None --'));
                    for (asi_mfm_role_prefix_relationship__c rp:px_list) {
                        if(rp.asi_mfm_prefix__r.name.contains('DP')){
                            available_prefixes.add(new selectOption(rp.asi_mfm_prefix__c, rp.asi_mfm_prefix__r.name));
                        }
                  }
                    
                    if(available_prefixes.size()==2){
                        selected_prefix=available_prefixes[1].getValue();
                        return proceed();
                    }else{
                        return null;
                    }
                    
                }
                 if(MPlanRecType.get('ASI_MFM_PH_DF_Plan')==Recordtypeid){
                    available_prefixes = new list<selectOption>();
                    available_prefixes.add(new selectOption('', '-- None --'));
                    for (asi_mfm_role_prefix_relationship__c rp:px_list) {
                        if(rp.asi_mfm_prefix__r.name.contains('DF')){
                            available_prefixes.add(new selectOption(rp.asi_mfm_prefix__c, rp.asi_mfm_prefix__r.name));
                        }
                  }
                    if(available_prefixes.size()==2){
                        selected_prefix=available_prefixes[1].getValue();
                        return proceed();
                    }else{
                        return null;
                    }
                }
                
                if(MPlanRecType.get('ASI_MFM_PH_DF_Plan')!=Recordtypeid && MPlanRecType.get('ASI_MFM_PH_DP_Plan')!=Recordtypeid){
                    available_prefixes = new list<selectOption>();
                    available_prefixes.add(new selectOption('', '-- None --'));
                    for (asi_mfm_role_prefix_relationship__c rp:px_list) {
                        available_prefixes.add(new selectOption(rp.asi_mfm_prefix__c, rp.asi_mfm_prefix__r.name));
                    }
                }
                
            }
            else {
                available_prefixes = new list<selectOption>();
                available_prefixes.add(new selectOption('', '-- None --'));
                for (asi_mfm_role_prefix_relationship__c rp:px_list) {
                    available_prefixes.add(new selectOption(rp.asi_mfm_prefix__c, rp.asi_mfm_prefix__r.name));
                }
            }
        }       
        return null;
    }
    
    public pageReference proceed() {
        /* Added by Michael Yip (Introv) 6Jan2013
                Override Plan id with "System generated" for CN Plan record type
        */
        String Recordtypeid = ApexPages.currentPage().getParameters().get('RecordType');
        System.debug('Recordtypeid = ' +ApexPages.currentPage().getParameters());
        // Modified by Michael Yip (Introv) 2May2014 for reduce SOQL for recordtype
        //Map<String, id> MPlanRecType = ASI_MFM_function.getRecordTypeId('ASI_MFM_Plan__c');
        Map<String, id> MPlanRecType = new Map<String,id>();
        for(Recordtype r : Global_recordTypeCache.getRtList('ASI_MFM_Plan__c')){
            MPlanRecType.put(r.developername,r.id);
        }
        System.debug(' ----- MPlanRecType ----- : ' + MPlanRecType);
        Boolean overRidePlanID = false;
        System.debug(Recordtypeid + '/' + MPlanRecType.get('ASI_MFM_CN_Plan'));
        Set<id> SCNProf = new Set<id>();
        for(Profile p : [Select id from profile where name like 'ASI CN%']){
            SCNProf.add(p.id);
        }
        System.debug(SCNProf);
        System.debug(UserInfo.getProfileId());
        if((MPlanRecType.containsKey('ASI_MFM_CN_Plan') && ((String)MPlanRecType.get('ASI_MFM_CN_Plan')).substring(0,15) == Recordtypeid) || 
           (MPlanRecType.containsKey('ASI_MFM_JP_Plan') && ((String)MPlanRecType.get('ASI_MFM_JP_Plan')).substring(0,15) == Recordtypeid) || 
       // ((String)MPlanRecType.get('ASI_MFM_MY_Plan')).substring(0,15) == Recordtypeid ||
        SCNProf.contains(UserInfo.getProfileId())){
            overRidePlanID = true;
        }
        // Added by Michael Yip (Introv) 6Jan2013
        if (selected_prefix == null || selected_prefix == '') {
            apexpages.message err = new apexpages.message(apexpages.severity.error, 'Please select prefix first');
            apexpages.addmessage(err); 
            return null;            
        }
        else {
            string prefix_name = px_map.get(selected_prefix).asi_mfm_prefix__r.name;
            string obj_id = sObjectType.ASI_MFM_Plan__c.getKeyPrefix();
            string field_id = ASI_MFM_Function.getFieldId('ASI_MFM_Plan__c', 'ASI_MFM_Prefix__c');
            system.debug(overRidePlanID);
            // Added by Michael Yip (Introv) 6Jan2013
            if(overRidePlanID){             
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + 'Automated, Do not change';
                        
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }
            // Added by Conrad Pantua (Laputa) 3Jul2013
            else if (MPlanRecType.containsKey('ASI_MFM_CAP_Plan') && ((String)MPlanRecType.get('ASI_MFM_CAP_Plan')).substring(0,15) == Recordtypeid)
            {
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                        
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }       
             // Added by Alan Wong (Elufa) 3Feb2015
	            else if ((MPlanRecType.containsKey('ASI_MFM_SG_Plan') && ((String)MPlanRecType.get('ASI_MFM_SG_Plan')).substring(0,15) == Recordtypeid)||(MPlanRecType.containsKey('ASI_MFM_TH_Plan') && ((String)MPlanRecType.get('ASI_MFM_TH_Plan')).substring(0,15) == Recordtypeid))
            {
                System.debug('Entered!');
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                        
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }
            else if (MPlanRecType.containsKey('ASI_MFM_PH_DP_Plan') && ((String)MPlanRecType.get('ASI_MFM_PH_DP_Plan')).substring(0,15) == Recordtypeid)
            {
                
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }
            else if (MPlanRecType.containsKey('ASI_MFM_PH_DF_Plan') && ((String)MPlanRecType.get('ASI_MFM_PH_DF_Plan')).substring(0,15) == Recordtypeid)
            {
                
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }
            
            // added by Tony Ren  (Elufa) 16Feb2015
            /*
            else if (MPlanRecType.containsKey('ASI_MFM_TH_Plan') && ((String)MPlanRecType.get('ASI_MFM_TH_Plan')).substring(0,15) == Recordtypeid)
            {
                System.debug('Entered!');
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                        
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }*/
            else if (MPlanRecType.containsKey('ASI_MFM_MY_Plan') && ((String)MPlanRecType.get('ASI_MFM_MY_Plan')).substring(0,15) == Recordtypeid)
            {
                System.debug('Entered!');
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                        
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }
            // Added by DC (Eternus) 25Nov2015
            else if (MPlanRecType.containsKey('ASI_MFM_CAP_TW_Plan') && ((String)MPlanRecType.get('ASI_MFM_CAP_TW_Plan')).substring(0,15) == Recordtypeid)
            {
	                System.debug('Entered!');			
                string url = '/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name;
                        
                if(Recordtypeid != null && Recordtypeid != ''){
                    url += '&RecordType=' + Recordtypeid;
                }
                return new pageReference(url ); 
            }
            else{               
                return new pageReference('/' + obj_id + '/e?retURL=%2F' + obj_id + '%2Fo&nooverride=1&CF' + field_id + '_lkid=' + selected_prefix + '&CF' + field_id + '=' + prefix_name + '&Name=' + prefix_name);         
            }
        }
    } 
}