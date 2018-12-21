<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_JP_DirectSales_ProdPrice_Approval_Approved</fullName>
        <description>ASI_CRM_JP_DirectSales_ProdPrice_Approval_Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Direct_Sales_Product_Price_Approved_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_DirectSales_ProdPrice_Approval_Rejected</fullName>
        <description>ASI_CRM_JP_DirectSales_ProdPrice_Approval_Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_DirectSalesProductPrice_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_DirectSalesProdPrice_Activate</fullName>
        <field>ASI_CRM_JP_Active__c</field>
        <literalValue>1</literalValue>
        <name>ASI_CRM_JP_DirectSalesProdPrice_Activate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
