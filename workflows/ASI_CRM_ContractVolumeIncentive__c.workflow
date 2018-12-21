<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_CRM_MY_Update_Region_Contract</fullName>
        <field>ASI_CRM_Branch__c</field>
        <formula>ASI_CRM_Contract__r.ASI_CRM_Branch__c</formula>
        <name>ASI_CRM_MY_Update_Region_ContractVolumeI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_MY_Update_Region_ContractVolumeIncentive</fullName>
        <actions>
            <name>ASI_CRM_MY_Update_Region_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ASI_CRM_ContractVolumeIncentive__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contract Volume Incentive (MY)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
