//Generated by wsdl2apex
public class LAT_WS_GetBIReport {
    public class ClientInfoType {
        public String system_x;
        public String systemUserID;
        public String remoteHostIP;
        public String country;
        public DateTime time_x;
        private String[] system_x_type_info = new String[]{'system','http://www.pernod-ricard.com/soa/crm/commons/types',null,'1','1','false'};
        private String[] systemUserID_type_info = new String[]{'systemUserID','http://www.pernod-ricard.com/soa/crm/commons/types',null,'1','1','false'};
        private String[] remoteHostIP_type_info = new String[]{'remoteHostIP','http://www.pernod-ricard.com/soa/crm/commons/types',null,'1','1','false'};
        private String[] country_type_info = new String[]{'country','http://www.pernod-ricard.com/soa/crm/commons/types',null,'1','1','false'};
        private String[] time_x_type_info = new String[]{'time','http://www.pernod-ricard.com/soa/crm/commons/types',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/soa/crm/commons/types','true','false'};
        private String[] field_order_type_info = new String[]{'system_x','systemUserID','remoteHostIP','country','time_x'};
    }
    public class getReportResponse_element {
        public String errorCode;
        public String errorMessage;
        public LAT_WS_GetBIReport.ReportResponse getReportReturn;
        private String[] errorCode_type_info = new String[]{'errorCode','http://www.pernod-ricard.com/SFDC/GetReport',null,'0','1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage','http://www.pernod-ricard.com/SFDC/GetReport',null,'0','1','false'};
        private String[] getReportReturn_type_info = new String[]{'getReportReturn','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'errorCode','errorMessage','getReportReturn'};
    }
    public class InvalidParametersExcep {
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ParamNameValue {
        public String UIType;
        public String dataType;
        public String dateFormatString;
        public String dateFrom;
        public String dateTo;
        public String defaultValue;
        public String fieldSize;
        public String label;
        public LAT_WS_GetBIReport.ArrayOfString lovLabels;
        public Boolean multiValuesAllowed;
        public String name;
        public Boolean refreshParamOnChange;
        public Boolean selectAll;
        public Boolean templateParam;
        public Boolean useNullForAll;
        public LAT_WS_GetBIReport.ArrayOfString values;
        private String[] UIType_type_info = new String[]{'UIType','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] dataType_type_info = new String[]{'dataType','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] dateFormatString_type_info = new String[]{'dateFormatString','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] dateFrom_type_info = new String[]{'dateFrom','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] dateTo_type_info = new String[]{'dateTo','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] fieldSize_type_info = new String[]{'fieldSize','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] label_type_info = new String[]{'label','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] lovLabels_type_info = new String[]{'lovLabels','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] multiValuesAllowed_type_info = new String[]{'multiValuesAllowed','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] name_type_info = new String[]{'name','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] refreshParamOnChange_type_info = new String[]{'refreshParamOnChange','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] selectAll_type_info = new String[]{'selectAll','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] templateParam_type_info = new String[]{'templateParam','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] useNullForAll_type_info = new String[]{'useNullForAll','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] values_type_info = new String[]{'values','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'UIType','dataType','dateFormatString','dateFrom','dateTo','defaultValue','fieldSize','label','lovLabels','multiValuesAllowed','name','refreshParamOnChange','selectAll','templateParam','useNullForAll','values'};
    }
    public class ReportRequest {
        public LAT_WS_GetBIReport.ArrayOfParamNameValue parameterNameValues;
        public String reportAbsolutePath;
        private String[] parameterNameValues_type_info = new String[]{'parameterNameValues','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] reportAbsolutePath_type_info = new String[]{'reportAbsolutePath','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'parameterNameValues','reportAbsolutePath'};
    }
    public class ArrayOfString {
        public String[] item;
        private String[] item_type_info = new String[]{'item','http://www.pernod-ricard.com/SFDC/GetReport',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class ArrayOfParamNameValue {
        public LAT_WS_GetBIReport.ParamNameValue[] item;
        private String[] item_type_info = new String[]{'item','http://www.pernod-ricard.com/SFDC/GetReport',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'item'};
    }
    public class getReport_element {
        public LAT_WS_GetBIReport.ReportRequest reportRequest;
        public LAT_WS_GetBIReport.ClientInfoType ClientInfo;
        private String[] reportRequest_type_info = new String[]{'reportRequest','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] ClientInfo_type_info = new String[]{'ClientInfo','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'reportRequest','ClientInfo'};
    }
    public class ReportResponse {
        public String reportBytes;
        public String reportContentType;
        public String reportFileID;
        public String reportLocale;
        private String[] reportBytes_type_info = new String[]{'reportBytes','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] reportContentType_type_info = new String[]{'reportContentType','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] reportFileID_type_info = new String[]{'reportFileID','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] reportLocale_type_info = new String[]{'reportLocale','http://www.pernod-ricard.com/SFDC/GetReport',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{'reportBytes','reportContentType','reportFileID','reportLocale'};
    }
    public class AccessDeniedExcep {
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class OperationFailedExcep {
        private String[] apex_schema_type_info = new String[]{'http://www.pernod-ricard.com/SFDC/GetReport','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetReportSFDCService {
        public String endpoint_x = 'http://osbdev.pramericas.com/SFDC/Report/Proxy_Services/GetReportSFDCReq';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.pernod-ricard.com/soa/crm/commons/types', 'LAT_WS_GetBIReport', 'http://www.pernod-ricard.com/SFDC/GetReport', 'LAT_WS_GetBIReport'};
        public LAT_WS_GetBIReport.getReportResponse_element getReport(LAT_WS_GetBIReport.ReportRequest reportRequest,LAT_WS_GetBIReport.ClientInfoType ClientInfo) {
            LAT_WS_GetBIReport.getReport_element request_x = new LAT_WS_GetBIReport.getReport_element();
            request_x.reportRequest = reportRequest;
            request_x.ClientInfo = ClientInfo;

            String[] endpointURL = LAT_GeneralConfigDao.getValueAsStringArray('ADC_BI_REPORT_INTEGRATION_ENDPOINT',',');
            if (!endpointURL.isEmpty()) {
                endpoint_x = endpointURL[0];
            }
            // Always default to max timeout possible
			this.timeout_x = 120000; // 120 sec is max timeout possible

			// Add Basic Auth if required
			this.inputHttpHeaders_x = new Map <String, String>();
			this.inputHttpHeaders_x.put('Authorization', LAT_WS_Utils.getAuthorizationHeader());
			
            LAT_WS_GetBIReport.getReportResponse_element response_x;
            Map<String, LAT_WS_GetBIReport.getReportResponse_element> response_map_x = new Map<String, LAT_WS_GetBIReport.getReportResponse_element>();
            response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'operation',
              'http://www.pernod-ricard.com/SFDC/GetReport',
              'getReport',
              'http://www.pernod-ricard.com/SFDC/GetReport',
              'getReportResponse',
              'LAT_WS_GetBIReport.getReportResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}