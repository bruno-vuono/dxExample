<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_eForm_Approved</fullName>
        <description>Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_eForm_KR/ASI_eForm_KR_Leave_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_Approved_Email_Alert1</fullName>
        <description>Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_eForm_KR/ASI_eForm_KR_Leave_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_Rejected</fullName>
        <description>Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_eForm_KR/ASI_eForm_KR_Leave_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_Rejected_Email_Alert1</fullName>
        <description>Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_eForm_KR/ASI_eForm_KR_Leave_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_eForm_Approved</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Approved_Status1</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Draft</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Drafted Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Rejected</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Rejected_Status1</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Submitted</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Submitted1</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>