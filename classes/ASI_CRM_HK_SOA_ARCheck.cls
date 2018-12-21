//Generated by wsdl2apex

public class ASI_CRM_HK_SOA_ARCheck {
    public class process_element {
        public Integer accountNumber;
        public String accountId;
        public String salesOrderId;
        public String userNameAndDateStr;
        private String[] accountNumber_type_info = new String[]{'accountNumber','http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',null,'1','1','false'};
        private String[] accountId_type_info = new String[]{'accountId','http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',null,'1','1','false'};
        private String[] salesOrderId_type_info = new String[]{'salesOrderId','http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',null,'1','1','false'};
        private String[] userNameAndDateStr_type_info = new String[]{'userNameAndDateStr','http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck','true','false'};
        private String[] field_order_type_info = new String[]{'accountNumber','accountId','salesOrderId','userNameAndDateStr'};
    }
    public class processResponse_element {
        public String result;
        private String[] result_type_info = new String[]{'result','http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class HK_CRM_ARCheck_pt {
        public String endpoint_x = 'http://141.145.123.107:80/soa-infra/services/default/HK_CRM_ARCheck/hk_crm_archeck_client_ep';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck', 'ASI_CRM_HK_SOA_ARCheck', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd', 'ASI_CRM_HK_SOA_ARCheck_WSSecurity'};
        public String process(Integer accountNumber,String accountId,String salesOrderId,String userNameAndDateStr) {
            ASI_CRM_HK_SOA_ARCheck.process_element request_x = new ASI_CRM_HK_SOA_ARCheck.process_element();
            request_x.accountNumber = accountNumber;
            request_x.accountId = accountId;
            request_x.salesOrderId = salesOrderId;
            request_x.userNameAndDateStr = userNameAndDateStr;
            ASI_CRM_HK_SOA_ARCheck.processResponse_element response_x;
            Map<String, ASI_CRM_HK_SOA_ARCheck.processResponse_element> response_map_x = new Map<String, ASI_CRM_HK_SOA_ARCheck.processResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'process',
              'http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',
              'process',
              'http://xmlns.oracle.com/HK_CRM_SOIntegration/HK_CRM_ARCheck/HK_CRM_ARCheck',
              'processResponse',
              'ASI_CRM_HK_SOA_ARCheck.processResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}