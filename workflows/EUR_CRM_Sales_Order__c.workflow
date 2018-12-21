<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EUR_AO_Send_Direct_Sales_Order_to_Customer_Service</fullName>
        <ccEmails>encomendas.angola@pernod-ricard.com; Katia.Santos@pernod-ricard.com</ccEmails>
        <description>EUR AO Send Direct Sales Order to Customer Service</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_AO_Direct_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_AO_Send_Indirect_Sales_Order_to_Distributor</fullName>
        <description>EUR AO Send Indirect Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_AO_Indirect_Sales_Order_to_Dist</template>
    </alerts>
    <alerts>
        <fullName>EUR_AO_Send_Order_Reminder_to_Account</fullName>
        <description>EUR AO Send Order Reminder to Account</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_AO_Order_Reminder_HTML</template>
    </alerts>
    <alerts>
        <fullName>EUR_BG_Marketing_Product_Sales_Order_Approval_Notification</fullName>
        <ccEmails>Lada.Atanasova@pernod-ricard.com</ccEmails>
        <ccEmails>ivayla.petrova@pernod-ricard.com</ccEmails>
        <description>EUR BG Marketing Product Sales Order Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_BG_Email_Templates/EUR_BG_MarketingSO_ApprovalNotification</template>
    </alerts>
    <alerts>
        <fullName>EUR_BG_Marketing_Product_Sales_Order_Reject_Notification</fullName>
        <ccEmails>Lada.Atanasova@pernod-ricard.com</ccEmails>
        <ccEmails>ivayla.petrova@pernod-ricard.com</ccEmails>
        <description>EUR BG Marketing Product Sales Order Reject Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_BG_Email_Templates/EUR_BG_MarketingSO_RejectNotification</template>
    </alerts>
    <alerts>
        <fullName>EUR_BG_Send_Direct_Sales_Order_to_CS</fullName>
        <ccEmails>Lada.Atanasova@pernod-ricard.com</ccEmails>
        <ccEmails>BulOrders@pernod-ricard.com</ccEmails>
        <ccEmails>ivayla.petrova@pernod-ricard.com</ccEmails>
        <description>EUR BG Send Direct Sales Order to CS</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Wholesaler_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_BG_North_West_Field_Sales_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_BG_Sales_Director</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_BG_South_East_Field_Sales_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_BG_Email_Templates/EUR_BG_Direct_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_BG_Send_Indirect_Sales_Order</fullName>
        <ccEmails>Lada.Atanasova@pernod-ricard.com</ccEmails>
        <ccEmails>ivayla.petrova@pernod-ricard.com</ccEmails>
        <description>EUR BG Send Indirect Sales Order</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Wholesaler_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_BG_Email_Templates/EUR_BG_Indirect_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_BG_Send_Marketing_Product_Sales_Order_to_CS</fullName>
        <ccEmails>Lada.Atanasova@pernod-ricard.com</ccEmails>
        <ccEmails>BulOrders@pernod-ricard.com</ccEmails>
        <ccEmails>ivayla.petrova@pernod-ricard.com</ccEmails>
        <description>EUR BG Send Marketing Product Sales Order to CS</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_BG_Email_Templates/EUR_BG_Marketing_Product_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_BG_Send_Order_Reminder_to_Contact</fullName>
        <ccEmails>Lada.Atanasova@pernod-ricard.com</ccEmails>
        <ccEmails>BulOrders@pernod-ricard.com</ccEmails>
        <ccEmails>ivayla.petrova@pernod-ricard.com</ccEmails>
        <description>EUR BG Send Order Reminder to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_BG_Email_Templates/EUR_BG_Order_Reminder</template>
    </alerts>
    <alerts>
        <fullName>EUR_CH_Sales_Order_Approval_Notification</fullName>
        <description>EUR CH Sales Order Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_CH_Email_Templates/EUR_CH_SalesOrderApprovalNotification_v2</template>
    </alerts>
    <alerts>
        <fullName>EUR_CH_Sales_Order_Reject_Notification</fullName>
        <description>EUR CH Sales Order Reject Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_CH_Email_Templates/EUR_CH_SalesOrderRejectNotification_v2</template>
    </alerts>
    <alerts>
        <fullName>EUR_CH_Send_Direct_Sales_Order_to_CS</fullName>
        <ccEmails>customerservice-swiss@pernod-ricard.com</ccEmails>
        <description>EUR CH Send Direct Sales Order to CS</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_CH_Email_Templates/EUR_CH_Direct_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_CH_Send_Indirect_Sales_Order_to_Distributor</fullName>
        <description>EUR CH Send Indirect Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_CH_Email_Templates/EUR_CH_Indirect_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_CH_Send_Reminder_to_Contact</fullName>
        <description>EUR CH Send Reminder to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_CH_Email_Templates/EUR_CH_Reminder</template>
    </alerts>
    <alerts>
        <fullName>EUR_CRM_Notify_Requester_for_Sales_Order_Approval_Result</fullName>
        <description>EUR CRM Notify Requester for Sales Order Approval Result</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DE_Email_Template/EUR_CRM_DE_Sales_Order_Approval_Result_Notice</template>
    </alerts>
    <alerts>
        <fullName>EUR_DK_Free_Goods_Order_to_Customer_Notification_to_CSandSM</fullName>
        <description>EUR DK - Free Goods Order to Customer - Notification to CS and SM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>EUR_DK_Customer_Services</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DK_Email_Templates/EUR_DK_FreeGoodsOrderCust_Notif_CSnSM</template>
    </alerts>
    <alerts>
        <fullName>EUR_DK_Free_Goods_Order_to_Customer_Status_Change_Notification_to_SR</fullName>
        <description>EUR DK - Free Goods Order to Customer - Status Change - Notification to SR</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DK_Email_Templates/EUR_DK_Free_Goods_Order_to_Customer_Change_Notification_to_SR</template>
    </alerts>
    <alerts>
        <fullName>EUR_DK_Send_Direct_Sales_Order_to_CS</fullName>
        <description>EUR DK Send Direct Sales Order to CS</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Wholesaler_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_DK_Customer_Services</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DK_Email_Templates/EUR_DK_Direct_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_DK_Sending_Sales_Order_Reminder_to_Contact</fullName>
        <description>EUR DK Sending Sales Order Reminder to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DK_Email_Templates/EUR_DK_Sales_Order_Reminder_to_Contact</template>
    </alerts>
    <alerts>
        <fullName>EUR_KE_Send_Direct_Sales_Order_to_Customer_Service</fullName>
        <ccEmails>sales.kenya@pernod-ricard.com</ccEmails>
        <description>EUR KE Send Direct Sales Order to Customer Service</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_KE_Direct_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_KE_Send_Indirect_Sales_Order_to_Distributor</fullName>
        <description>EUR KE Send Indirect Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_KE_Indirect_Sales_Order_to_Dist</template>
    </alerts>
    <alerts>
        <fullName>EUR_KE_Send_Order_Reminder_to_Account</fullName>
        <description>EUR KE Send Order Reminder to Account</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_KE_Order_Reminder_HTML</template>
    </alerts>
    <alerts>
        <fullName>EUR_MA_Indirect_Regional_WS_Sales_Order_to_Distributor</fullName>
        <description>EUR MA Indirect Regional WS Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_On_and_Off_Field_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_Sales_Director</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>bassam.amine@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marc.danon@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>saadia.tafakourt@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zineb.bellakhdar@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_MA_Email_Templates/EUR_MA_Indirect_Regional_WS_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_MA_Send_Direct_On_Trade_Reminder_to_Customer</fullName>
        <description>EUR MA Send Direct On Trade Reminder to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>zakaria.sidelkhir@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_MA_Email_Templates/EUR_MA_Direct_On_Trade_Reminder</template>
    </alerts>
    <alerts>
        <fullName>EUR_MA_Send_Direct_On_Trade_Sales_Order_to_CS</fullName>
        <description>EUR MA Send Direct On Trade Sales Order to CS</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_On_and_Off_Field_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_Sales_Director</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>bassam.amine@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marc.danon@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>saadia.tafakourt@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salwa.hssaine-ext@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zakaria.sidelkhir@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zineb.bellakhdar@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_MA_Email_Templates/EUR_MA_Direct_On_Trade_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_MA_Send_Indirect_Off_Trade_Sales_Order_to_Distributor</fullName>
        <description>EUR MA Send Indirect Off Trade Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_On_and_Off_Field_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_Sales_Director</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>yassir.elquarde@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_MA_Email_Templates/EUR_MA_Indirect_Off_Trade_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_MA_Send_Indirect_On_Trade_Reminder_to_Customer</fullName>
        <description>EUR MA Send Indirect On Trade Reminder to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>zakaria.sidelkhir@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_MA_Email_Templates/EUR_MA_Indirect_On_Trade_Reminder</template>
    </alerts>
    <alerts>
        <fullName>EUR_MA_Send_Indirect_On_Trade_Sales_Order_to_Distributor</fullName>
        <description>EUR MA Send Indirect On Trade Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_On_and_Off_Field_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>EUR_MA_Sales_Director</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>zakaria.sidelkhir@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_MA_Email_Templates/EUR_MA_Indirect_On_Trade_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_NG_Send_Sales_Order_to_KD</fullName>
        <ccEmails>verna.mugot@pernod-ricard.com</ccEmails>
        <description>EUR NG Send Sales Order to KD</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Key_Distributor_Sales_Rep_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_NG_Sales_Order_to_KD</template>
    </alerts>
    <alerts>
        <fullName>EUR_NG_Send_Sales_Order_to_KD_CS</fullName>
        <ccEmails>verna.mugot@pernod-ricard.com</ccEmails>
        <description>EUR NG Send Sales Order to KD CS</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_KD_CS_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_NG_KD_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_NG_Sales_Order_to_CS</template>
    </alerts>
    <alerts>
        <fullName>EUR_NG_Send_Sales_Order_to_NG_CS</fullName>
        <ccEmails>financenigeria@pernod-ricard.com</ccEmails>
        <ccEmails>verna.mugot@pernod-ricard.com</ccEmails>
        <description>EUR NG Send Sales Order to NG CS</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_SSA_Email_Template/EUR_NG_Sales_Order_to_CS</template>
    </alerts>
    <alerts>
        <fullName>EUR_PT_Send_Indirect_Sales_Order_to_Distributor</fullName>
        <ccEmails>raquel.faisca@pernod-ricard.com</ccEmails>
        <ccEmails>David.Pinto@pernod-ricard.com</ccEmails>
        <description>EUR PT Send Indirect Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>EUR_PT_On_Trade_Sales_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_PT_Email_Templates/EUR_PT_Indirect_On_Trade_Sales_Order</template>
    </alerts>
    <alerts>
        <fullName>EUR_RU_Send_Sales_Order_to_Distributor</fullName>
        <description>EUR RU Send Sales Order to Distributor</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>EUR_CRM_Distributor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_RU_Email_Templates/EUR_RU_SO_Notification_to_Distributor</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Free_Goods_Order_to_SR</fullName>
        <description>EUR ZA Send Free Goods Order to SR</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_CRM_ZA_Free_Good_Request_Change_Notification_to_SR</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Free_Goods_Order_to_TeleSales_Agent</fullName>
        <description>EUR ZA Send Free Goods Order to TeleSales Agent</description>
        <protected>false</protected>
        <recipients>
            <recipient>marcello.arendse@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_CRM_ZA_Free_Good_Request_Notification_to_Telesales_Agent</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Sales_Order_Creation_Notification_to_SR</fullName>
        <description>EUR ZA Send Sales Order Creation Notification to SR</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_ZA_Sales_Order_Notification_To_SR</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Sales_Order_to_SR</fullName>
        <description>EUR ZA Send Sales Order to SR</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_CRM_ZA_Sales_Order_Change_Notification_to_SR</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Sales_Order_to_TeleSales_Agent</fullName>
        <description>EUR ZA Send Sales Order to TeleSales Agent</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_TeleSales_Agent__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_CRM_ZA_Sales_Order_Notification_to_TeleSales_Agent</template>
    </alerts>
    <fieldUpdates>
        <fullName>EUR_BG_Approval_Status_To_Approved</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR BG Approval Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Approval_Status_To_Rejected</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR BG Approval Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Approval_Status_To_Submitted</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR BG Approval Status To Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Direct_SO_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR BG - Direct SO Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Indirect_SO_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR BG - Indirect SO Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Order_Reminder_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR BG - Order Reminder Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Order_Status_To_Draft</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>EUR BG Order Status To Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Order_Status_To_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR BG Order Status To Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_BG_Order_Status_To_In_Process</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>In Process</literalValue>
        <name>EUR BG Order Status To In Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Approval_Status_To_Approved</fullName>
        <description>When the request is approved, update the Approval Status = Approved</description>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR CH  Approval Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Approval_Status_To_Rejected</fullName>
        <description>When the request is rejected, update the Approval Status = Draft</description>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR CH Approval Status To Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Approval_Status_To_Submitted</fullName>
        <description>When the request is submitted, update the Approval Status = &quot;Submitted&quot;</description>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR CH Approval Status To Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Order_Status_To_Draft</fullName>
        <description>Updated on 20160329 (SFASWI-39 and SFASWI-89)

After Rejected 
Order Status = In Process --&gt; Draft
Approval Status = Draft --&gt; Rejected</description>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>EUR CH Order Status To Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Order_Status_To_Finished</fullName>
        <description>When Approval Status = &quot;Approved&quot;, update Order Status = &quot;Finished&quot;</description>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR CH Order Status To Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Order_Status_To_In_Process</fullName>
        <description>After Rejected, 
- Order Status = In Process
- Approval Status = Draft</description>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>In Process</literalValue>
        <name>EUR CH Order Status To In Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CH_Order_Status_To_Submitted</fullName>
        <description>This is a new Field Update action in the Approval Process to update the value to &quot;Submitted&quot; of &quot;Order Status&quot; once the Sales Order is Submitted for Approval. Created for CH on 20160301.</description>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR CH Order Status To Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Change_Order_Status_To_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR CRM Change Order Status To Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_ChngApprvStatToRejected</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR CRM ChngApprvStatToRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_ChngApprvStatToSubmitted</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR CRM ChngApprvStatToSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_ChngApprvStatusToApproved</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR CRM ChngApprvStatusToApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_ChngOrderStatToDraft</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>EUR CRM ChngOrderStatToDraft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_ChngOrderStatToInProcess</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>In Process</literalValue>
        <name>EUR CRM ChngOrderStatToInProcess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Chng_Apprvl_Status_to_Approved</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR CRM Chng Apprvl Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Chng_Apprvl_Status_to_Rejected</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR CRM Chng Apprvl Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Chng_Apprvl_Status_to_Submitted</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR CRM Chng Apprvl Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_DE_FGO_SR_St_In_Process_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR DE - FGO SR St In Process - Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_DK_Direct_SO_In_Process_Finished_2</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR DK - Direct SO In Process Finished 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_DK_FGO_SR_St_In_Process_Finished</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR DK - FGO SR St In Process - Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_DK_Reminder_In_Process_Finished_2</fullName>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR DK - Reminder In Process Finished 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_MA_Update_Sales_Order_Delivery_Date</fullName>
        <description>Delivery Date = Create Date + 2 Working days</description>
        <field>EUR_CRM_Delivery_Date__c</field>
        <formula>CASE( 
  MOD(DATEVALUE(CreatedDate) - DATE( 1900, 1, 7 ), 7 ),
  4, DATEVALUE(CreatedDate) + 2 + 2,
  5, DATEVALUE(CreatedDate) + 2 + 2,
  6, DATEVALUE(CreatedDate) + 1 + 2,
  DATEVALUE(CreatedDate) + 2
)</formula>
        <name>EUR MA Update Sales Order Delivery Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Status_In_Process_to_Finished</fullName>
        <description>Field update to change the Sales Order(EU) Status from &apos;In Process&apos; to &apos;Finished&apos;</description>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Finished</literalValue>
        <name>EUR PT - Status In Process to Finished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_ZA_Change_the_Order_Status_FreeGoods</fullName>
        <description>Change the Order Status from &apos;In Process&apos; to &apos;Accepted&apos; once the Sales Manager approves the Free Goods Request</description>
        <field>EUR_CRM_Order_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>EUR ZA Change the Order Status_FreeGoods</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EUR AO Direct Sales Order</fullName>
        <actions>
            <name>EUR_AO_Send_Direct_Sales_Order_to_Customer_Service</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR AO Direct Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR AO Indirect Sales Order</fullName>
        <actions>
            <name>EUR_AO_Send_Indirect_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR AO Indirect Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR AO Order Reminder</fullName>
        <actions>
            <name>EUR_AO_Send_Order_Reminder_to_Account</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR AO Order Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR BG Direct Sales Order to CS</fullName>
        <actions>
            <name>EUR_BG_Send_Direct_Sales_Order_to_CS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_BG_Direct_SO_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR BG Direct Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Cost_Center_Type__c</field>
            <operation>notEqual</operation>
            <value>A&amp;D</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR BG Indirect Sales Order</fullName>
        <actions>
            <name>EUR_BG_Send_Indirect_Sales_Order</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_BG_Indirect_SO_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR BG Indirect Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Cost_Center_Type__c</field>
            <operation>notEqual</operation>
            <value>A&amp;D</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR BG Marketing Product Sales Order Approval Notification Workflow</fullName>
        <actions>
            <name>EUR_BG_Marketing_Product_Sales_Order_Approval_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR BG Marketing Product Sales Order</value>
        </criteriaItems>
        <description>This is a workflow in order to capture the correct field update values in VF email template.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR BG Marketing Product Sales Order Reject Notification Workflow</fullName>
        <actions>
            <name>EUR_BG_Marketing_Product_Sales_Order_Reject_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR BG Marketing Product Sales Order</value>
        </criteriaItems>
        <description>This is a workflow in order to capture the correct field update values in VF email template.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR BG Marketing Product Sales Order to CS</fullName>
        <actions>
            <name>EUR_BG_Send_Marketing_Product_Sales_Order_to_CS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR BG Marketing Product Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR BG Order Reminder to Contact</fullName>
        <actions>
            <name>EUR_BG_Send_Order_Reminder_to_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_BG_Order_Reminder_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR BG Order Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR CH Direct SO to CS</fullName>
        <actions>
            <name>EUR_CH_Send_Direct_Sales_Order_to_CS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR CH Direct Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR CH Indirect SO to Distributor</fullName>
        <actions>
            <name>EUR_CH_Send_Indirect_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR CH Indirect Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR CH Reminder to Contact</fullName>
        <actions>
            <name>EUR_CH_Send_Reminder_to_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR CH Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR CH Sales Order Approval Notification Workflow</fullName>
        <actions>
            <name>EUR_CH_Sales_Order_Approval_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR CH Direct Sales Order,EUR CH Indirect Sales Order</value>
        </criteriaItems>
        <description>This is a workflow to replace the email alert (EUR CH Sales Order Approval Notification)  in order to capture the correct field update values in VF email template.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR CH Sales Order Reject Notification Workflow</fullName>
        <actions>
            <name>EUR_CH_Sales_Order_Reject_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR CH Direct Sales Order</value>
        </criteriaItems>
        <description>This is a workflow to replace the email alert (EUR CH Sales Order Reject Notification)  in order to capture the correct field update values in VF email template.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR DE - FGO from SR Stock - Status change from In Process to Finished</fullName>
        <actions>
            <name>EUR_DE_FGO_SR_St_In_Process_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DE OFF Free Goods from SR Stock to Customer Sales Order,DE ON Free Goods from SR Stock to Customer Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <description>This workflow has been created in order to change status of a FGO from SR Stock from In Process to Finished. When created in the Mobile app, it has the status In Process, SFDC should set it automatically to Finished since DE does not have any approval.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR DK - FGO from SR Stock - Status change from In Process to Finished</fullName>
        <actions>
            <name>EUR_DK_FGO_SR_St_In_Process_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR DK Free Goods Order from SR Stock</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <description>This workflow has been created in order to change status of a FGO from SR Stock from In Process to Finished. When created in the Mobile app, it has the status In Process, SFDC should set it automatically to Finished since DK does not have any approval.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR DK - Free Goods Order to Customer - Notification to CS and SM</fullName>
        <actions>
            <name>EUR_DK_Free_Goods_Order_to_Customer_Notification_to_CSandSM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR DK Free Goods Order to Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <description>Notify the Customer Service and Sales Manager  that a new Free Good Order to Customer has been created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR DK - Free Goods Order to Customer- Status Change - Notification to SR</fullName>
        <actions>
            <name>EUR_DK_Free_Goods_Order_to_Customer_Status_Change_Notification_to_SR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR DK Free Goods Order to Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished,Cancelled</value>
        </criteriaItems>
        <description>Notify the Sales Rep that the Free Good Order Details (Status) have been modified (Free Goods Order to Customer)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR DK Direct SO to CS</fullName>
        <actions>
            <name>EUR_DK_Send_Direct_Sales_Order_to_CS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_DK_Direct_SO_In_Process_Finished_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR DK Direct Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <description>Notify the Customer Service that a new Sales Order has been created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR DK Order Reminder to Contact</fullName>
        <actions>
            <name>EUR_DK_Sending_Sales_Order_Reminder_to_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_DK_Reminder_In_Process_Finished_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR DK Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR KE Direct Sales Order</fullName>
        <actions>
            <name>EUR_KE_Send_Direct_Sales_Order_to_Customer_Service</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR KE Direct Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR KE Indirect Sales Order</fullName>
        <actions>
            <name>EUR_KE_Send_Indirect_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR KE Indirect Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR KE Order Reminder</fullName>
        <actions>
            <name>EUR_KE_Send_Order_Reminder_to_Account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR KE Order Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR MA Direct ON Reminder to Customer</fullName>
        <actions>
            <name>EUR_MA_Send_Direct_On_Trade_Reminder_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Direct On Trade Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR MA Direct ON SO to CS</fullName>
        <actions>
            <name>EUR_MA_Send_Direct_On_Trade_Sales_Order_to_CS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Direct On Trade Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR MA Indirect OFF SO to Distributor</fullName>
        <actions>
            <name>EUR_MA_Send_Indirect_Off_Trade_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Indirect Off Trade Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR MA Indirect ON Reminder to Customer</fullName>
        <actions>
            <name>EUR_MA_Send_Indirect_On_Trade_Reminder_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Indirect On Trade Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR MA Indirect ON SO to Distributor</fullName>
        <actions>
            <name>EUR_MA_Send_Indirect_On_Trade_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Indirect On Trade Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR MA Indirect RWS SO to Distributor</fullName>
        <actions>
            <name>EUR_MA_Indirect_Regional_WS_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Indirect Regional WS Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR NG Sales Order KD to CS</fullName>
        <actions>
            <name>EUR_NG_Send_Sales_Order_to_KD_CS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR NG On Trade Sales Order,EUR NG Off Trade Traditional Sales Order,EUR NG Off Trade Bulk Breaker Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR NG Sales Order NG to CS</fullName>
        <actions>
            <name>EUR_NG_Send_Sales_Order_to_NG_CS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR NG Off Trade Modern Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR NG Sales Order NG to KD</fullName>
        <actions>
            <name>EUR_NG_Send_Sales_Order_to_KD</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR NG On Trade Reminder</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR PT Indirect Sales Order to Distributor</fullName>
        <actions>
            <name>EUR_PT_Send_Indirect_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_PT_Status_In_Process_to_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR PT Indirect On Trade Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR RU New Sales Order Notification to Distributor</fullName>
        <actions>
            <name>EUR_RU_Send_Sales_Order_to_Distributor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EUR_CRM_Change_Order_Status_To_Finished</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR RU On Trade Sales Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <description>Notify the Distributor that a new Sales Order (Recommended) has been created by SR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR Set Delivery Date</fullName>
        <actions>
            <name>EUR_MA_Update_Sales_Order_Delivery_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR MA Indirect Off Trade Sales Order,EUR MA Indirect Regional WS Sales Order</value>
        </criteriaItems>
        <description>For MA, Delivery Date = Create date + 2 working days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA - New Sales Order Notification to Sales Rep</fullName>
        <actions>
            <name>EUR_ZA_Send_Sales_Order_Creation_Notification_to_SR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the Sales Rep that a new Sales order ( both Direct Sales Order and Free Goods Order records)  has been created to JDE.</description>
        <formula>AND(  OR(RecordType.DeveloperName = &apos;EUR_ZA_Direct_Sales_Order&apos;, RecordType.DeveloperName =&apos;EUR_ZA_Free_Goods_Order&apos;), ISPICKVAL(EUR_CRM_Order_Status__c, &apos;In process&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA - New Sales Order Notification to TeleSales Agent</fullName>
        <actions>
            <name>EUR_ZA_Send_Sales_Order_to_TeleSales_Agent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the TeleSales Agent that a new Sales order has been created to JDE</description>
        <formula>AND ( ISPICKVAL(EUR_CRM_Order_Status__c, &apos;In process&apos;), RecordType.DeveloperName = &apos;EUR_ZA_Direct_Sales_Order&apos;, OR ( NOT(ISPICKVAL(PRIORVALUE(EUR_CRM_Order_Status__c),&apos;In process&apos;)), ISCHANGED(  EUR_CRM_TeleSales_Agent__c ), ISNEW() ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA - Sales Order Status Change Notification to SR</fullName>
        <actions>
            <name>EUR_ZA_Send_Sales_Order_to_SR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the Sales Rep that the Direct Sales Order Details (Status) have been modified</description>
        <formula>AND (  OR  (  AND (  ISPICKVAL(PRIORVALUE(EUR_CRM_Order_Status__c),&quot;Draft&quot;),  NOT(ISPICKVAL(EUR_CRM_Order_Status__c,&quot;Draft&quot;))  ),  AND (  ISPICKVAL(PRIORVALUE(EUR_CRM_Order_Status__c),&quot;Partially processed&quot;),  NOT(ISPICKVAL(EUR_CRM_Order_Status__c,&quot;Partially processed&quot;))  ),  AND (  ISPICKVAL(PRIORVALUE(EUR_CRM_Order_Status__c),&quot;In Process&quot;),  NOT(ISPICKVAL(EUR_CRM_Order_Status__c,&quot;In Process&quot;))  ),  AND (  ISPICKVAL(PRIORVALUE(EUR_CRM_Order_Status__c),&quot;Finished&quot;),  NOT(ISPICKVAL(EUR_CRM_Order_Status__c,&quot;Finished&quot;))  ),  AND (  ISPICKVAL(PRIORVALUE(EUR_CRM_Order_Status__c),&quot;Cancelled&quot;),  NOT(ISPICKVAL(EUR_CRM_Order_Status__c,&quot;Cancelled&quot;))  )  ),  RecordType.Name =&quot;EUR ZA Direct Sales Order&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA Free Goods Order to SR</fullName>
        <actions>
            <name>EUR_ZA_Send_Free_Goods_Order_to_SR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.EUR_CRM_Order_Status__c</field>
            <operation>equals</operation>
            <value>Finished,Cancelled,Partially processed</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR ZA Free Goods Order</value>
        </criteriaItems>
        <description>Notify the Sales Rep, through email, that a Free Goods Order has been modified.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
