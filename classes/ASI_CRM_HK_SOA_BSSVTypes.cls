//Generated by wsdl2apex

public class ASI_CRM_HK_SOA_BSSVTypes {
    public class detail_element {
        public String Id;
        public String Name;
        public String Action_Type;
        public String ASI_HK_CRM_Quantity_xc;
        public String ASI_HK_CRM_SKU_xr_ASI_HK_CRM_UOM1_xc;
        public String ASI_HK_CRM_Doc_Line_Num_xc;
        public String ASI_HK_CRM_Sales_Order_xr_ASI_HK_CRM_Cust_PO_xc;
        public String ASI_HK_CRM_Sales_Order_xr_ASI_HK_CRM_User_D_O_xc;
        public String ASI_HK_CRM_SKU_xr_ASI_MFM_SKU_Code_xc;
        public String ASI_HK_CRM_SKU_xr_ASI_HK_CRM_External_Short_ID_xc;
        private String[] Id_type_info = new String[]{'Id','http://oracle.e1.bssv.JP420000/types/',null,'0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://oracle.e1.bssv.JP420000/types/',null,'0','1','false'};
        private String[] Action_Type_type_info = new String[]{'Action_Type','http://oracle.e1.bssv.JP420000/types/',null,'0','1','false'};
        private String[] ASI_HK_CRM_Quantity_xc_type_info = new String[]{'ASI_HK_CRM_Quantity__c','http://oracle.e1.bssv.JP420000/types/',null,'0','1','false'};
        private String[] ASI_HK_CRM_SKU_xr_ASI_HK_CRM_UOM1_xc_type_info = new String[]{'ASI_HK_CRM_SKU__r.ASI_HK_CRM_UOM1__c','http://oracle.e1.bssv.JP420000/types/',null,'0','1','false'};
        private String[] ASI_HK_CRM_Doc_Line_Num_xc_type_info = new String[]{'ASI_HK_CRM_Doc_Line_Num__c','http://oracle.e1.bssv.JP420000/types/',null,'0','1','false'};
        private String[] ASI_HK_CRM_Sales_Order_xr_ASI_HK_CRM_Cust_PO_xc_type_info = new String[]{'ASI_HK_CRM_Sales_Order__r.ASI_HK_CRM_Cust_PO__c','http://oracle.e1.bssv.JP420000/types/',null,'1','1','false'};
        private String[] ASI_HK_CRM_Sales_Order_xr_ASI_HK_CRM_User_D_O_xc_type_info = new String[]{'ASI_HK_CRM_Sales_Order__r.ASI_HK_CRM_User_D_O__c','http://oracle.e1.bssv.JP420000/types/',null,'1','1','false'};
        private String[] ASI_HK_CRM_SKU_xr_ASI_MFM_SKU_Code_xc_type_info = new String[]{'ASI_HK_CRM_SKU__r.ASI_MFM_SKU_Code__c','http://oracle.e1.bssv.JP420000/types/',null,'1','1','false'};
        private String[] ASI_HK_CRM_SKU_xr_ASI_HK_CRM_External_Short_ID_xc_type_info = new String[]{'ASI_HK_CRM_SKU__r.ASI_HK_CRM_External_Short_ID__c','http://oracle.e1.bssv.JP420000/types/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://oracle.e1.bssv.JP420000/types/','true','false'};
        private String[] field_order_type_info = new String[]{'Id','Name','Action_Type','ASI_HK_CRM_Quantity_xc','ASI_HK_CRM_SKU_xr_ASI_HK_CRM_UOM1_xc','ASI_HK_CRM_Doc_Line_Num_xc','ASI_HK_CRM_Sales_Order_xr_ASI_HK_CRM_Cust_PO_xc','ASI_HK_CRM_Sales_Order_xr_ASI_HK_CRM_User_D_O_xc','ASI_HK_CRM_SKU_xr_ASI_MFM_SKU_Code_xc','ASI_HK_CRM_SKU_xr_ASI_HK_CRM_External_Short_ID_xc'};
    }
    public class OrderDetail_element {
        public ASI_CRM_HK_SOA_BSSVTypes.header_element header;
        private String[] header_type_info = new String[]{'header','http://oracle.e1.bssv.JP420000/types/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://oracle.e1.bssv.JP420000/types/','true','false'};
        private String[] field_order_type_info = new String[]{'header'};
    }
    public class header_element {
        public ASI_CRM_HK_SOA_BSSVTypes.detail_element[] detail;
        private String[] detail_type_info = new String[]{'detail','http://oracle.e1.bssv.JP420000/types/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://oracle.e1.bssv.JP420000/types/','true','false'};
        private String[] field_order_type_info = new String[]{'detail'};
    }
}