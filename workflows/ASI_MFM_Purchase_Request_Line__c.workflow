<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_MFM_KR_Set_PR_Line_External_ID</fullName>
        <field>ASI_MFM_PurchaseRequests_Line_ExternalID__c</field>
        <formula>Name</formula>
        <name>ASI MFM KR Set PR Line External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_MFM_KR_PRLine_External_ID</fullName>
        <actions>
            <name>ASI_MFM_KR_Set_PR_Line_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_MFM_Purchase_Request_Line__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>KR Purchase Request Line</value>
        </criteriaItems>
        <description>ASI_MFM_KR_PRLine_External_ID</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
