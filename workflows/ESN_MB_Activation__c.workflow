<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ESN_MB_AddBrandNameToActivation</fullName>
        <field>ESN_MB_Brand_Scope_Text__c</field>
        <formula>ESN_MB_Product__r.ESN_MB_Brand_Scope__c</formula>
        <name>ESN_MB_AddBrandNameToActivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ESN_MB_AddBrandNameToActivation</fullName>
        <actions>
            <name>ESN_MB_AddBrandNameToActivation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Stores the brand name into an activation</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
