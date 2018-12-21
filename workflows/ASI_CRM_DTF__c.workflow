<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_CN_DTF_ApprovedReject</fullName>
        <description>ASI CRM CN DTF Approved Reject</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_CN_DTF_Approver_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_DTF_ApprovedRejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_DTF_Approved</fullName>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CN DTF Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_DTF_Draft</fullName>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>CN DTF Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_DTF_RT_Standard</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_CN_DTF_Standard</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CN DTF RT Standard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_DTF_RT_readOnly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_CN_DTF_ReadOnly</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CN DTF RT readOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_DTF_Submitted</fullName>
        <description>Field Update: Status: Submitted</description>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>CN DTF Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_DTF_autoApprove</fullName>
        <description>Check for auto approve</description>
        <field>ASI_CRM_CN_autoApprove__c</field>
        <literalValue>1</literalValue>
        <name>CN DTF autoApprove</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_CN_DTF_Submitted3DaysCount</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ASI_CRM_DTF__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CRM CN DTF Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_DTF__c.ASI_CRM_CN_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_DTF__c.ASI_CRM_CN_autoApprove__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Count 3 days after submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_CRM_CN_DTF_autoApprove</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ASI_CRM_DTF__c.LastModifiedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
