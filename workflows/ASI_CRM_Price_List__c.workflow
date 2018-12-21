<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_JP_Price_List_Approval_Approved</fullName>
        <description>ASI CRM JP Price List Approval Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Price_List_App_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Price_List_Approval_Rejected</fullName>
        <description>ASI CRM JP Price List Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Price_List_App_Rejected_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Price_List_Approved</fullName>
        <field>ASI_CRM_JP_Approved__c</field>
        <literalValue>1</literalValue>
        <name>ASI CRM JP Price List Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Price_List_Update_App_Date</fullName>
        <field>ASI_CRM_JP_Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>ASI CRM JP Price List Update App Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
