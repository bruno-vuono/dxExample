<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_eForm_HK_PTRAF_Final_Approval_Email_Alert</fullName>
        <description>ASI eForm PTRAF Final Approval Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>mag.yuen@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_PTRAF_AprvdEmail_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_PTRAF_Final_Cancel_Email_Alert</fullName>
        <description>ASI eForm PTRAF Final Cancellation Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_PTRAF_CnclEmail_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_eForm_HK_PTRAF_Final_Reject_Email_Alert</fullName>
        <description>ASI eForm PTRAF Final Reject Email Alert (HK)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.eform@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_eForm_Email_Templates/ASI_eForm_HK_PTRAF_RejectEmail_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_eForm_Clear_Notify_Travel_Agent</fullName>
        <field>ASI_eForm_Notify_Travel_Agent__c</field>
        <literalValue>0</literalValue>
        <name>ASI eForm Clear Notify Travel Agent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_HK_Set_Form_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_HK_Pre_Trip_Approval</lookupValue>
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
        <lookupValue>ASI_eForm_HK_Pre_Trip_Approval_Final</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Final (HK)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_Resubmit_Update</fullName>
        <field>ASI_eForm_sys_resubmit__c</field>
        <formula>&quot;(Resubmit)&quot;</formula>
        <name>ASI_eForm_Resubmit_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_SG_Set_Form_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_SG_Pre_Trip_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Draft (SG)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_eForm_SG_Set_Form_Final</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_eForm_SG_Pre_Trip_Approval_Final</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI eForm Set Form Final (SG)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
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
        <fullName>ASI_eForm_Set_Sys_Allow_Subt_Aprv_False</fullName>
        <field>ASI_eForm_Sys_Allow_Submit_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Set Sys Allow Submit Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_eForm_HK_PRTAF_Final_Approve_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_PTRAF_Final_Approval_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Trip Approval Final (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_PRTAF_Final_Cancellation_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_PTRAF_Final_Cancel_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Trip Approval Final (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_PRTAF_Final_Reject_Email_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_PTRAF_Final_Reject_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Trip Approval (HK)</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_sys_resubmit__c</field>
            <operation>equals</operation>
            <value>(Resubmit)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_PRTAF_Finalize_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_Set_Form_Final</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Final</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Trip Approval (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_HK_PRTAF_Free_Form</fullName>
        <actions>
            <name>ASI_eForm_HK_Set_Form_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_eForm_Set_Form_Status_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Pre-Trip Approval Final (HK)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_eForm_PRTAF_Individual_Payment</fullName>
        <actions>
            <name>ASI_eForm_Clear_Notify_Travel_Agent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_eForm_Pre_Trip_Approval__c.ASI_eForm_Payment_Method__c</field>
            <operation>equals</operation>
            <value>Individual Corp Card</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
