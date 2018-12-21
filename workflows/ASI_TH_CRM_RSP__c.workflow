<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_CRM_MY_Update_Region_RSP</fullName>
        <field>ASI_CRM_Branch__c</field>
        <formula>ASI_CRM_CN_Customer__r.ASI_CRM_MY_Branch__c</formula>
        <name>ASI_CRM_MY_Update_Region_RSP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Update_Region_in_RSP</fullName>
        <field>ASI_CRM_Region__c</field>
        <formula>text(ASI_CRM_CN_Customer__r.ASI_CRM_VN_Region__c)</formula>
        <name>ASI CRM VN Update Region in RSP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI CRM VN Update Region from Customer to RSP</fullName>
        <actions>
            <name>ASI_CRM_VN_Update_Region_in_RSP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_TH_CRM_RSP__c.ASI_CRM_Region__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update region field from Customer to RSP when creating RSP</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_MY_Update_Region_RSP</fullName>
        <actions>
            <name>ASI_CRM_MY_Update_Region_RSP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_TH_CRM_RSP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI CRM MY RSP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
