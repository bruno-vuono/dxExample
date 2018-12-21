<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_CN_Issues_Admin_to_Creater_Email_Alert</fullName>
        <description>ASI CRM CN Issues Admin  to Creater Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>prc.sfdc.notification@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Issues_Admin_To_Creater_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Issues_Admin_to_Modifier_Email_Alert</fullName>
        <description>ASI CRM CN Issues Admin to Modifier Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>prc.sfdc.notification@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Issues_Ad_To_Modifier_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Issues_Close_Admin_to_Creater_Email_Alert</fullName>
        <description>ASI CRM CN Issues Close Admin to Creater Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>prc.sfdc.notification@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Issues_Close_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Issues_Close_Creater_to_Admin_Email_Alert</fullName>
        <description>ASI CRM CN Issues Close Creater to Admin Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>prc.sfdc.notification@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Issues_Auto_close_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Issues_Creater_to_Admin_Email_Alert</fullName>
        <description>ASI CRM CN Issues Creater to Admin Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>prc.sfdc.notification@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Issues_Creater_to_Admin_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Issues_Modifier_to_Admin_Email_Alert</fullName>
        <description>ASI CRM CN Issues Modifier to Admin Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Issues_Modifier_to_Ad_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Auto_Close_Status</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Automatically Closed</literalValue>
        <name>ASI_CRM_CN_Auto_Close_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Issue_Set_Closed_Date</fullName>
        <field>ASI_CRM_Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>Issue - Set Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Issue_Set_Investigating_Date</fullName>
        <field>ASI_CRM_Investigating_Date__c</field>
        <formula>NOW()</formula>
        <name>Issue - Set Investigating Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Issue_Set_Pic_Uploaded_Date</fullName>
        <field>ASI_CRM_Open_Picture_Uploaded_Date__c</field>
        <formula>NOW()</formula>
        <name>Issue - Set Pic Uploaded Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_CN_60_days_Close_Issue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal GMA,External GMA,Counterfeit,Traceability,Others,Look-alike,Service Complaint,QR Code Sticker,QR Code Sticker (SV),QR Code Stiker (PRQR)</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>notEqual</operation>
            <value>Closed,Automatically Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_CRM_CN_Auto_Close_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ASI_CRM_Issue_Zone__c.CreatedDate</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Auto_Close_Issue</fullName>
        <actions>
            <name>ASI_CRM_CN_Issues_Close_Creater_to_Admin_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Automatically Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal GMA,External GMA,Counterfeit,Consumer Complaint,Traceability,Others,Look-alike,Trade Complaint,Service Complaint,QR Code Sticker,QR Code Sticker (SV),QR Code Stiker (PRQR)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Changed_Email_Alert</fullName>
        <actions>
            <name>ASI_CRM_CN_Issues_Modifier_to_Admin_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(ASI_CRM_CN_Reclassification__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Close_Email_Alert</fullName>
        <actions>
            <name>ASI_CRM_CN_Issues_Close_Admin_to_Creater_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Open_Email_Alert</fullName>
        <actions>
            <name>ASI_CRM_CN_Issues_Admin_to_Creater_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_CN_Issues_Creater_to_Admin_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Set_Closed_Date_WF</fullName>
        <actions>
            <name>ASI_CRM_CN_Issue_Set_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Set_Investigating_Date_WF</fullName>
        <actions>
            <name>ASI_CRM_CN_Issue_Set_Investigating_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Investigating</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Issue_Set_Pic_Uploaded_Date_WF</fullName>
        <actions>
            <name>ASI_CRM_CN_Issue_Set_Pic_Uploaded_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Issue_Zone__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Open-Picture Uploaded</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
