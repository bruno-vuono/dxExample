<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_eForm_CN_ITCRF_Completed_Email_Alert</fullName>
        <description>ASI eForm ITCRF Completed Email Alert (CN)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>ASI_eForm_CN_Requested_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_CN_ITCRF_Completed_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_CN_ITCRF_Final_Approval_Email_Alert</fullName>
        <description>ASI eForm ITCRF Final Approval Email Alert (CN)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>ASI_eForm_Project_Implementer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_CN_ITCRF_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_CN_ITCRF_Final_Reject_Email_Alert</fullName>
        <description>ASI eForm ITCRF Final Reject Email Alert (CN)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_CN_ITCRF_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_CN_ITCRF_Invalid_Submission_Email_Alert</fullName>
        <description>ASI eForm ITCRF Invalid Submission Email Alert (CN)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_CN_ITCRF_Invalid_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_ITCRF_Completed_Email_Alert</fullName>
        <description>ASI eForm ITCRF Completed Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_ITCRF_Completed_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_ITCRF_Final_Approval_Email_Alert</fullName>
        <description>ASI eForm ITCRF Final Approval Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>ASI_eForm_Project_Implementer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_ITCRF_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_ITCRF_Final_Reject_Email_Alert</fullName>
        <description>ASI eForm ITCRF Final Reject Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_ITCRF_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_ITCRF_Invalid_Submission_Email_Alert</fullName>
        <description>ASI eForm ITCRF Invalid Submission Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_ITCRF_Invalid_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_Submitted_IT_Change_Request</fullName>
        <description>ASI eForm Submitted IT Change Request (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_ITCRF_ApvEmail_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_eForm_CN_Set_Form_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_CN_IT_Change_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Draft (CN)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_CN_Set_Form_Final</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_CN_IT_Change_Request_Final</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Final (CN)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_CN_Set_Form_Submitted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_CN_IT_Change_Request_Submitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Submitted (CN)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Clear_Further_Authorizer</fullName>
        <field>ASI_eForm_Further_Authorizer__c</field>
        <name>ASI eForm Clear Further Authorizer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Clear_High_Authorizer</fullName>
        <field>ASI_eForm_High_Level_Authorizer__c</field>
        <name>ASI eForm Clear High Authorizer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_HK_Set_Form_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_HK_IT_Change_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Draft (HK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_HK_Set_Form_Final</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_HK_IT_Change_Request_Final</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Final (HK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_HK_Set_Form_Submitted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_HK_IT_Change_Request_Submitted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Submitted (HK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Resubmit_Update</fullName>
        <field>ASI_eForm_sys_resubmit__c</field>
        <formula>&quot;(Resubmit)&quot;</formula>
        <name>ASI eForm Resubmit Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Set_Form_Status_Draft</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>ASI eForm Set Form Status Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Set_Form_Status_Final</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Final</literalValue>
        <name>ASI eForm Set Form Status Final</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Set_Form_Status_Submitted</fullName>
        <field>ASI_eForm_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI eForm Set Form Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Set_IT_Action_Acknowledged</fullName>
        <field>ASI_eForm_IT_Action__c</field>
        <literalValue>IT Acknowledged</literalValue>
        <name>ASI eForm Set IT Action Acknowledged</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Set_Sys_Allow_Subt_Aprv_False</fullName>
        <field>ASI_eForm_Sys_Allow_Submit_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Set Sys Allow Submit Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_eForm_CN_ITCRF_Final_Approve_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_CN_ITCRF_Final_Approval_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request Final (CN)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_CN_ITCRF_Final_Reject_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_CN_ITCRF_Final_Reject_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request (CN)</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_sys_resubmit__c</field>
            <operation>equals</operation>
            <value>(Resubmit)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_CN_ITCRF_Finalize_Form</fullName>
        <actions>
            <name>ASI_eForm_CN_Set_Form_Final</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request (CN)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_CN_ITCRF_Free_Form</fullName>
        <actions>
            <name>ASI_eForm_CN_ITCRF_Invalid_Submission_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_eForm_CN_Set_Form_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_eForm_Resubmit_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_eForm_Set_Form_Status_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_IT_Action__c</field>
            <operation>equals</operation>
            <value>Invalid Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request (CN)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_CN_ITCRF_Notification_Complete</fullName>
        <actions>
            <name>ASI_eForm_CN_ITCRF_Completed_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_IT_Action__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request Final (CN)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_ITCRF_Final_Approve_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_ITCRF_Final_Approval_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request Final (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_ITCRF_Final_Reject_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_ITCRF_Final_Reject_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request (HK)</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_sys_resubmit__c</field>
            <operation>equals</operation>
            <value>(Resubmit)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_ITCRF_Finalize_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_Set_Form_Final</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_ITCRF_Free_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_ITCRF_Invalid_Submission_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_eForm_HK_Set_Form_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_eForm_Resubmit_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_eForm_Set_Form_Status_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request (HK)</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_IT_Action__c</field>
            <operation>equals</operation>
            <value>Invalid Submission</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_ITCRF_Notification_Complete</fullName>
        <actions>
            <name>ASI_eForm_HK_ITCRF_Completed_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_IT_Action__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Change Request Final (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_ITCRF_Low_Category</fullName>
        <actions>
            <name>ASI_eForm_Clear_Further_Authorizer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_eForm_Clear_High_Authorizer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Change_Category__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Change_Type__c</field>
            <operation>notEqual</operation>
            <value>Emergency</value>
        </criteriaItems>
        <description>Change Category is Low</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_ITCRF_Medium_Category</fullName>
        <actions>
            <name>ASI_eForm_Clear_Further_Authorizer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Change_Category__c</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Change_Type__c</field>
            <operation>notEqual</operation>
            <value>Emergency</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Change_Category__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_IT_Change_Request__c.ASI_eForm_Change_Type__c</field>
            <operation>equals</operation>
            <value>Emergency</value>
        </criteriaItems>
        <description>(Change Category is Medium) OR (Change Category is Low but Change Type is Emergency)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
