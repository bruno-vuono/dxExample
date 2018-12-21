<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Get_Value_From_Qty_9L</fullName>
        <field>ASI_CRM_CN_Qty_9L_FRU__c</field>
        <formula>ASI_CRM_CN_Qty_9L__c</formula>
        <name>Get Value From Qty (9L)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Sum_QtyAndFreeQty</fullName>
        <field>ASI_CRM_CN_Sum_of_QtyNFree_Qty_RollUp__c</field>
        <formula>ASI_CRM_CN_Sum_of_Order_Qty_And_Free_Qty__c</formula>
        <name>CN Sum QtyAndFreeQty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_TotalAmountBT</fullName>
        <field>ASI_CRM_CN_Total_Amount_BT_RU__c</field>
        <formula>ASI_CRM_CN_Total_Amount_BT__c</formula>
        <name>CN TotalAmountBT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_SOItem_UpdateInitialQty</fullName>
        <field>ASI_CRM_Initial_Qty_CT__c</field>
        <formula>ASI_CRM_SG_Request_Quantity_Carton__c</formula>
        <name>ASI_CRM_SG_SOItem_UpdateInitialQty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_CN_SO_Qty %289L%29</fullName>
        <actions>
            <name>ASI_CRM_CN_Get_Value_From_Qty_9L</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_CRM_CN_Sum_QtyAndFreeQty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_CRM_CN_TotalAmountBT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_KOR_Sales_Order_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CN SalesOrder Item</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_SG_SOItem_InitialQty</fullName>
        <actions>
            <name>ASI_CRM_SG_SOItem_UpdateInitialQty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_KOR_Sales_Order_Transaction__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI CRM SG LA,ASI CRM SG CA,ASI CRM SG MY,ASI CRM SG MM,ASI CRM SG PH,ASI CRM SG VI,ASI CRM SG VIDF,ASI CRM SG IN</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_KOR_Sales_Order_Transaction__c.ASI_CRM_SG_Request_Quantity_Carton__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Default Initial Quantity Carton as Request Quantity Carton when item is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
