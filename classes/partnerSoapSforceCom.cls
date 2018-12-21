//Generated by wsdl2apex

public class partnerSoapSforceCom {
    public class getUserInfo_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class LoginResult {
        public String metadataServerUrl;
        public Boolean passwordExpired;
        public Boolean sandbox;
        public String serverUrl;
        public String sessionId;
        public String userId;
        public partnerSoapSforceCom.GetUserInfoResult userInfo;
        private String[] metadataServerUrl_type_info = new String[]{'metadataServerUrl','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] passwordExpired_type_info = new String[]{'passwordExpired','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] sandbox_type_info = new String[]{'sandbox','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] serverUrl_type_info = new String[]{'serverUrl','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] userInfo_type_info = new String[]{'userInfo','urn:partner.soap.sforce.com','GetUserInfoResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'metadataServerUrl','passwordExpired','sandbox','serverUrl','sessionId','userId','userInfo'};
    }
      
    public class logout_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    
    public class loginResponse_element {
        public partnerSoapSforceCom.LoginResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com','LoginResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class getServerTimestamp_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetUserInfoResult {
        public Boolean accessibilityMode;
        public String currencySymbol;
        public Integer orgAttachmentFileSizeLimit;
        public String orgDefaultCurrencyIsoCode;
        public Boolean orgDisallowHtmlAttachments;
        public Boolean orgHasPersonAccounts;
        public String organizationId;
        public Boolean organizationMultiCurrency;
        public String organizationName;
        public String profileId;
        public String roleId;
        public Integer sessionSecondsValid;
        public String userDefaultCurrencyIsoCode;
        public String userEmail;
        public String userFullName;
        public String userId;
        public String userLanguage;
        public String userLocale;
        public String userName;
        public String userTimeZone;
        public String userType;
        public String userUiSkin;
        private String[] accessibilityMode_type_info = new String[]{'accessibilityMode','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] currencySymbol_type_info = new String[]{'currencySymbol','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] orgAttachmentFileSizeLimit_type_info = new String[]{'orgAttachmentFileSizeLimit','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] orgDefaultCurrencyIsoCode_type_info = new String[]{'orgDefaultCurrencyIsoCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] orgDisallowHtmlAttachments_type_info = new String[]{'orgDisallowHtmlAttachments','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] orgHasPersonAccounts_type_info = new String[]{'orgHasPersonAccounts','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] organizationMultiCurrency_type_info = new String[]{'organizationMultiCurrency','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] organizationName_type_info = new String[]{'organizationName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] profileId_type_info = new String[]{'profileId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] roleId_type_info = new String[]{'roleId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] sessionSecondsValid_type_info = new String[]{'sessionSecondsValid','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] userDefaultCurrencyIsoCode_type_info = new String[]{'userDefaultCurrencyIsoCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] userEmail_type_info = new String[]{'userEmail','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userFullName_type_info = new String[]{'userFullName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] userLanguage_type_info = new String[]{'userLanguage','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userLocale_type_info = new String[]{'userLocale','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userName_type_info = new String[]{'userName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userTimeZone_type_info = new String[]{'userTimeZone','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userType_type_info = new String[]{'userType','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userUiSkin_type_info = new String[]{'userUiSkin','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessibilityMode','currencySymbol','orgAttachmentFileSizeLimit','orgDefaultCurrencyIsoCode','orgDisallowHtmlAttachments','orgHasPersonAccounts','organizationId','organizationMultiCurrency','organizationName','profileId','roleId','sessionSecondsValid','userDefaultCurrencyIsoCode','userEmail','userFullName','userId','userLanguage','userLocale','userName','userTimeZone','userType','userUiSkin'};
    }

    
    public class CallOptions_element {
        public String client;
        public String defaultNamespace;
        private String[] client_type_info = new String[]{'client','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] defaultNamespace_type_info = new String[]{'defaultNamespace','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'client','defaultNamespace'};
    }
    
    public class MruHeader_element {
        public Boolean updateMru;
        private String[] updateMru_type_info = new String[]{'updateMru','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'updateMru'};
    }
    public class Soap {
        public String endpoint_x = 'https://login.salesforce.com/services/Soap/u/25.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public partnerSoapSforceCom.StreamingEnabledHeader_element StreamingEnabledHeader;
        public partnerSoapSforceCom.MruHeader_element MruHeader;
        public partnerSoapSforceCom.CallOptions_element CallOptions;
        //public partnerSoapSforceCom.PackageVersionHeader_element PackageVersionHeader;
        public partnerSoapSforceCom.EmailHeader_element EmailHeader;
        public partnerSoapSforceCom.LocaleOptions_element LocaleOptions;
        public partnerSoapSforceCom.DebuggingInfo_element DebuggingInfo;
        public partnerSoapSforceCom.SessionHeader_element SessionHeader;
        public partnerSoapSforceCom.DebuggingHeader_element DebuggingHeader;
        public partnerSoapSforceCom.LoginScopeHeader_element LoginScopeHeader;
        public partnerSoapSforceCom.DisableFeedTrackingHeader_element DisableFeedTrackingHeader;
        public partnerSoapSforceCom.UserTerritoryDeleteHeader_element UserTerritoryDeleteHeader;
        public partnerSoapSforceCom.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        //public partnerSoapSforceCom.QueryOptions_element QueryOptions;
        public partnerSoapSforceCom.AssignmentRuleHeader_element AssignmentRuleHeader;
        public partnerSoapSforceCom.AllOrNoneHeader_element AllOrNoneHeader;
        private String StreamingEnabledHeader_hns = 'StreamingEnabledHeader=urn:partner.soap.sforce.com';
        private String MruHeader_hns = 'MruHeader=urn:partner.soap.sforce.com';
        private String CallOptions_hns = 'CallOptions=urn:partner.soap.sforce.com';
        //private String PackageVersionHeader_hns = 'PackageVersionHeader=urn:partner.soap.sforce.com';
        private String EmailHeader_hns = 'EmailHeader=urn:partner.soap.sforce.com';
        private String LocaleOptions_hns = 'LocaleOptions=urn:partner.soap.sforce.com';
        private String DebuggingInfo_hns = 'DebuggingInfo=urn:partner.soap.sforce.com';
        private String SessionHeader_hns = 'SessionHeader=urn:partner.soap.sforce.com';
        private String DebuggingHeader_hns = 'DebuggingHeader=urn:partner.soap.sforce.com';
        private String LoginScopeHeader_hns = 'LoginScopeHeader=urn:partner.soap.sforce.com';
        private String DisableFeedTrackingHeader_hns = 'DisableFeedTrackingHeader=urn:partner.soap.sforce.com';
        private String UserTerritoryDeleteHeader_hns = 'UserTerritoryDeleteHeader=urn:partner.soap.sforce.com';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=urn:partner.soap.sforce.com';
        //private String QueryOptions_hns = 'QueryOptions=urn:partner.soap.sforce.com';
        private String AssignmentRuleHeader_hns = 'AssignmentRuleHeader=urn:partner.soap.sforce.com';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=urn:partner.soap.sforce.com';
        private String[] ns_map_type_info = new String[]{'urn:sobject.partner.soap.sforce.com', 'sobjectPartnerSoapSforceCom', 'urn:fault.partner.soap.sforce.com', 'faultPartnerSoapSforceCom', 'urn:partner.soap.sforce.com', 'partnerSoapSforceCom'};
        
        public void logout() {
            partnerSoapSforceCom.logout_element request_x = new partnerSoapSforceCom.logout_element();
            partnerSoapSforceCom.logoutResponse_element response_x;
            Map<String, partnerSoapSforceCom.logoutResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.logoutResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest()){
	            WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'urn:partner.soap.sforce.com',
	              'logout',
	              'urn:partner.soap.sforce.com',
	              'logoutResponse',
	              'partnerSoapSforceCom.logoutResponse_element'}
	            );
           		response_x = response_map_x.get('response_x');
        	}else{
        		response_x = new partnerSoapSforceCom.logoutResponse_element();
        	}
        }

        public partnerSoapSforceCom.GetUserInfoResult getUserInfo() {
            partnerSoapSforceCom.getUserInfo_element request_x = new partnerSoapSforceCom.getUserInfo_element();
            partnerSoapSforceCom.getUserInfoResponse_element response_x;
            Map<String, partnerSoapSforceCom.getUserInfoResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.getUserInfoResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest()){
	            WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'urn:partner.soap.sforce.com',
	              'getUserInfo',
	              'urn:partner.soap.sforce.com',
	              'getUserInfoResponse',
	              'partnerSoapSforceCom.getUserInfoResponse_element'}
	            );
	            response_x = response_map_x.get('response_x');
	            return response_x.result;
        	}else{
        		response_x = new partnerSoapSforceCom.getUserInfoResponse_element();
	            return response_x.result;
        	}
        }
        public partnerSoapSforceCom.GetServerTimestampResult getServerTimestamp() {
            partnerSoapSforceCom.getServerTimestamp_element request_x = new partnerSoapSforceCom.getServerTimestamp_element();
            partnerSoapSforceCom.getServerTimestampResponse_element response_x;
            Map<String, partnerSoapSforceCom.getServerTimestampResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.getServerTimestampResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest()){
	            WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'urn:partner.soap.sforce.com',
	              'getServerTimestamp',
	              'urn:partner.soap.sforce.com',
	              'getServerTimestampResponse',
	              'partnerSoapSforceCom.getServerTimestampResponse_element'}
	            );
	            response_x = response_map_x.get('response_x');
	            return response_x.result;
        	}else{
        		response_x = new partnerSoapSforceCom.getServerTimestampResponse_element();
	            return response_x.result;
        	}
        }
      
        public partnerSoapSforceCom.LoginResult login(String username,String password) {
            partnerSoapSforceCom.login_element request_x = new partnerSoapSforceCom.login_element();
            partnerSoapSforceCom.loginResponse_element response_x;
            request_x.username = username;
            request_x.password = password;
            Map<String, partnerSoapSforceCom.loginResponse_element> response_map_x = new Map<String, partnerSoapSforceCom.loginResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest()){
	            WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'urn:partner.soap.sforce.com',
	              'login',
	              'urn:partner.soap.sforce.com',
	              'loginResponse',
	              'partnerSoapSforceCom.loginResponse_element'}
	            );
	            response_x = response_map_x.get('response_x');
	            return response_x.result;
        	}else{
        		response_x = new partnerSoapSforceCom.loginResponse_element();
	            return response_x.result;
        	}
        }
    }
    
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class AllOrNoneHeader_element {
        public Boolean allOrNone;
        private String[] allOrNone_type_info = new String[]{'allOrNone','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allOrNone'};
    }
    
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    
    public class DisableFeedTrackingHeader_element {
        public Boolean disableFeedTracking;
        private String[] disableFeedTracking_type_info = new String[]{'disableFeedTracking','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'disableFeedTracking'};
    }
  
    public class LoginScopeHeader_element {
        public String organizationId;
        public String portalId;
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] portalId_type_info = new String[]{'portalId','urn:partner.soap.sforce.com','ID','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'organizationId','portalId'};
    }
    
    public class GetServerTimestampResult {
        public DateTime timestamp;
        private String[] timestamp_type_info = new String[]{'timestamp','http://www.w3.org/2001/XMLSchema','dateTime','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'timestamp'};
    }
   
    public class getServerTimestampResponse_element {
        public partnerSoapSforceCom.GetServerTimestampResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com','GetServerTimestampResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
 
    public class LocaleOptions_element {
        public String language;
        private String[] language_type_info = new String[]{'language','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'language'};
    }
    
    
    public class StreamingEnabledHeader_element {
        public Boolean streamingEnabled;
        private String[] streamingEnabled_type_info = new String[]{'streamingEnabled','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'streamingEnabled'};
    }
   
    public class AssignmentRuleHeader_element {
        public String assignmentRuleId;
        public Boolean useDefaultRule;
        private String[] assignmentRuleId_type_info = new String[]{'assignmentRuleId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] useDefaultRule_type_info = new String[]{'useDefaultRule','http://www.w3.org/2001/XMLSchema','boolean','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'assignmentRuleId','useDefaultRule'};
    }
    
    public class login_element {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
    
    public class getUserInfoResponse_element {
        public partnerSoapSforceCom.GetUserInfoResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com','GetUserInfoResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
   
    public class setPasswordResponse_element {
        public partnerSoapSforceCom.SetPasswordResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com','SetPasswordResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class logoutResponse_element {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
  
    public class UserTerritoryDeleteHeader_element {
        public String transferToUserId;
        private String[] transferToUserId_type_info = new String[]{'transferToUserId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'transferToUserId'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
   
    public class EmailHeader_element {
        public Boolean triggerAutoResponseEmail;
        public Boolean triggerOtherEmail;
        public Boolean triggerUserEmail;
        private String[] triggerAutoResponseEmail_type_info = new String[]{'triggerAutoResponseEmail','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] triggerOtherEmail_type_info = new String[]{'triggerOtherEmail','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] triggerUserEmail_type_info = new String[]{'triggerUserEmail','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'triggerAutoResponseEmail','triggerOtherEmail','triggerUserEmail'};
    }
    
    public class setPassword_element {
        public String userId;
        public String password;
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'userId','password'};
    }
 
    public class Error {
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] fields_type_info = new String[]{'fields','http://www.w3.org/2001/XMLSchema','string','0','-1','true'};
        private String[] message_type_info = new String[]{'message','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','urn:partner.soap.sforce.com','StatusCode','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'fields','message','statusCode'};
    }
    public class SetPasswordResult {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class DebuggingHeader_element {
        public String debugLevel;
        private String[] debugLevel_type_info = new String[]{'debugLevel','urn:partner.soap.sforce.com','DebugLevel','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'debugLevel'};
    }

}