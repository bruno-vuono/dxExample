<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_CRM_CN_PnD_RollUp_GrossSalesImapct</fullName>
        <field>ASI_CRM_CN_Gross_Sales_Impact_RollUp__c</field>
        <formula>ASI_CRM_Gross_Sales_Impact__c</formula>
        <name>CN PnD RollUp GrossSalesImapct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_CN_PnD_RollUpGSI</fullName>
        <actions>
            <name>ASI_CRM_CN_PnD_RollUp_GrossSalesImapct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Price_And_Discount__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CN Customer Price and Discount Request,CN Customer Price and Discount Request RO</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
