<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_HK_PriceSet_Completed</fullName>
        <description>ASI_CRM_HK_PriceSet_Completed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>catherine.chung@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>olivia.chung@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wingi.li@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yetta.lam@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_HK_CRM_PAF/ASI_CRM_HK_PriceSet_Completed1</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_Approved_Date</fullName>
        <field>ASI_CRM_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>ASI_CRM_HK Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_Completed_Date</fullName>
        <field>ASI_CRM_Completed_Date__c</field>
        <formula>NOW()</formula>
        <name>ASI_CRM_HK_Completed_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_PriceSet_Approved</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI CRM HK PriceSet Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_PriceSet_Completed</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>ASI_CRM_HK_PriceSet_Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_PriceSet_Hub_Rejected</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Hub Rejected</literalValue>
        <name>ASI_CRM_HK_PriceSet_Hub_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_PriceSet_Rejected</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>SA Rejected</literalValue>
        <name>ASI_CRM_HK_PriceSet_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_PriceSet_Submitted</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI_CRM_HK_PriceSet_Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_HK_Submission_Date</fullName>
        <field>ASI_CRM_Submission_Date__c</field>
        <formula>today()</formula>
        <name>ASI_CRM_HK_Submission_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
