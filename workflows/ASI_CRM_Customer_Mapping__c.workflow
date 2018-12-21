<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_CRM_SG_CustMappingExtID_Update</fullName>
        <field>ASI_CRM_External_ID__c</field>
        <formula>ASI_CRM_Wholesaler__r.ASI_CRM_MY_CustomerCode__c + &quot;_&quot; +  ASI_CRM_Offtake_Customer_No__c</formula>
        <name>ASI_CRM_SG_CustMappingExtID_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_SG_CustomerMappingExtID</fullName>
        <actions>
            <name>ASI_CRM_SG_CustMappingExtID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Customer_Mapping__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SG Customer Mapping</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
