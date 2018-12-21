<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CN_NPL_Change_Request_Notify_Approved</fullName>
        <description>ASI CN NPL Change Request Notify Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>annie.he@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>braeden.zhang@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>helen.wu@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>henry.law@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>philip.zhou@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sandy.yang@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Change_Request_Complete_VF</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CN_NPL_Change_Request_Status_Approve</fullName>
        <field>ASI_CN_NPL_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI CN NPL Change Request Status Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CN_NPL_Change_Request_Status_Open</fullName>
        <field>ASI_CN_NPL_Status__c</field>
        <literalValue>Open</literalValue>
        <name>ASI CN NPL Change Request Status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CN_NPL_Change_Request_Status_Waiting</fullName>
        <field>ASI_CN_NPL_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI CN NPL Change Request Status Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
