public with sharing class ASI_eForm_ToolingAPI
{
        private String sessionId;
        
        public ASI_eForm_ToolingAPI(String sessionId)
        {
                this.sessionId = sessionId;
        }
        
        public ASI_eForm_ToolingAPI()
        {
                this.sessionId = UserInfo.getSessionId();        
        }

        public CustomObjectQueryResult queryCustomObject(String whereClause)
        {
                return (CustomObjectQueryResult) 
                        query('Select Id, DeveloperName, NamespacePrefix From CustomObject Where ' + whereClause, 
                                        CustomObjectQueryResult.class);
        }

        public CustomFieldQueryResult queryCustomField(String whereClause)
        {
                return (CustomFieldQueryResult) 
                        query('Select Id, DeveloperName, Metadata, NamespacePrefix, TableEnumOrId From CustomField Where ' + whereClause + ' ORDER BY TableEnumOrId ', 
                                        CustomFieldQueryResult.class);
        }
        
        public class CustomObject
        {
                public Id id {get;set;}
                public String DeveloperName {get;set;}
                public String NamespacePrefix {get;set;}
                public List<CustomField> customFields {get;set;}
        }
        
        public class CustomField
        {
                public Id id {get; set;}
                public String DeveloperName {get; set;}
                public String NamespacePrefix {get;set;}
                public String TableEnumOrId {get;set;}
        }
        
        public class ErrorResponse
        {
                public String errorCode;
                public String message;                
        }

        public abstract class QueryResult
        {
                public Integer size;
                public Integer totalSize;
                public Boolean done;
        }
        
        public class CustomObjectQueryResult extends QueryResult
        {
                public List<CustomObject> records;
        }
        
        public class CustomFieldQueryResult extends QueryResult
        {
                public List<CustomField> records;
        }
        
        public class ToolingAPIException extends Exception
        {
                public ToolingAPIException(List<ErrorResponse> errorResponses)
                {
                        this(errorResponses[0].errorCode + ' : ' + errorResponses[0].message);
                }
        }
        
        /*
        public Object query(String soql)
        {
            Http h = new Http();            
            HttpRequest queryReq = new HttpRequest();
            queryReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v29.0/tooling/query/?q=' + EncodingUtil.urlEncode(soql, 'UTF-8'));
            queryReq.setHeader('Authorization', 'OAuth ' + sessionId);
            queryReq.setHeader('Content-Type', 'application/json');
            queryReq.setMethod('GET');
            HttpResponse queryRes = h.send(queryReq);
            if(queryRes.getStatusCode() != 200)
                    throw new ToolingAPIException((List<ErrorResponse>) JSON.deserialize(queryRes.getBody(), List<ErrorResponse>.class));
            return queryRes.getBody();
        }*/
                
        private Object query(String soql, Type responseType)
        {
            Http h = new Http();            
            HttpRequest queryReq = new HttpRequest();
            queryReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v29.0/tooling/query/?q=' + EncodingUtil.urlEncode(soql, 'UTF-8'));
            queryReq.setHeader('Authorization', 'OAuth ' + sessionId);
            queryReq.setHeader('Content-Type', 'application/json');
            queryReq.setMethod('GET');
            
            String bodyResponse = '';
            
            if (!Test.isRunningTest())
            {
             HttpResponse queryRes = h.send(queryReq);
             if(queryRes.getStatusCode() != 200)
                    throw new ToolingAPIException((List<ErrorResponse>) JSON.deserialize(queryRes.getBody(), List<ErrorResponse>.class));
             bodyResponse =  queryRes.getBody();
            
            } else
            {
              bodyResponse =  ASI_eForm_ToolingAPITest.customObjectResponse; 
            
            }        
            System.debug('XXX httpbody: ' + bodyResponse); 
            return JSON.deserialize(bodyResponse, responseType);
        }        
}