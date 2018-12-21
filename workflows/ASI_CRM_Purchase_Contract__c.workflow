<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Rebate_Contract_Approved_Notification_Email_Alert</fullName>
        <description>CRM JP Direct Rebate Contract Approved Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_Direct_Rebate_Contract_Approved_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Rebate_Contract_Recalled_Notification_Email_Alert</fullName>
        <description>CRM JP Direct Rebate Contract Recalled Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_Direct_Rebate_Contract_Recalled_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Rebate_Contract_Rejected_Notification_Email_Alert</fullName>
        <description>CRM JP Direct Rebate Contract Rejected Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_Direct_Rebate_Contract_Rejected_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Indirect_Contract_Approved_Notification_Email_Alert</fullName>
        <description>CRM JP Indirect Contract Approved Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_Indirect_Contract_Approved_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Indirect_Contract_Recalled_Notification_Email_Alert</fullName>
        <description>CRM JP Indirect Contract Recalled Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_Indirect_Contract_Recalled_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Indirect_Contract_Rejected_Notification_Email_Alert</fullName>
        <description>CRM JP Indirect Contract Rejected Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_Indirect_Contract_Rejected_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_SPTD_Contract_Approved_Notification_Email_Alert</fullName>
        <description>CRM JP SPTD Contract Approved Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_SPTD_Contract_Approved_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_SPTD_Contract_Complete_Notification_Email_Alert</fullName>
        <description>CRM JP SPTD Contract Complete Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_SPTD_Contract_Complete_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_SPTD_Contract_Recalled_Notification_Email_Alert</fullName>
        <description>CRM JP SPTD Contract Recalled Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_SPTD_Contract_Recalled_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_SPTD_Contract_Rejected_Notification_Email_Alert</fullName>
        <description>CRM JP SPTD Contract Rejected Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_JP_Email_Templates/ASI_CRM_JP_SPTD_Contract_Rejected_Notification_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Clear_End_Date</fullName>
        <field>ASI_CRM_End_Date__c</field>
        <name>ASI CRM JP Clear End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_Contract_Status_Approved</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Contract Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_Current_Approver</fullName>
        <field>ASI_CRM_Sys_Current_Approver__c</field>
        <formula>$User.Id</formula>
        <name>Set Current Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_Default_Fiscal_Year</fullName>
        <field>ASI_CRM_Fiscal_Year__c</field>
        <formula>IF( 
MONTH(ASI_CRM_Start_Date__c) &gt;= 7 , 
&quot;FY&quot; &amp; RIGHT(TEXT(YEAR(ASI_CRM_Start_Date__c)), 2) &amp; RIGHT(TEXT(YEAR(ASI_CRM_Start_Date__c) + 1), 2), 
&quot;FY&quot; &amp; RIGHT(TEXT(YEAR(ASI_CRM_Start_Date__c) - 1), 2) &amp; RIGHT(TEXT(YEAR(ASI_CRM_Start_Date__c)), 2) 
)</formula>
        <name>Set Default Fiscal Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_DirectRebateContract_Free</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Direct_Rebate_Contract</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Direct Rebate Contract Free</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_DirectRebateContract_Read</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Direct_Rebate_Contract_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Direct Rebate Contract Read-Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_IndirRebateContr_Read</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Indirect_Rebate_Contract_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Indirect Rebate Contract Read-Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_IndirRebateContract_Free</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Indirect_Rebate_Contract</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Indirect Rebate Contract Free</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_SPTD_Contract_Free</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_SPTD_Contract</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set SPTD Contract Free</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Set_SPTD_Contract_Read_Only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_SPTD_Contract_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set SPTD Contract Read-Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Set_Contract_Status_to_Activated</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Activated</literalValue>
        <name>Set Contract Status to Activated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Set_Contract_Status_to_Draft</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Contract Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Set_Contract_Status_to_Submitted</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Set Contract Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Set_Sys_Allow_Submit_Aprv_False</fullName>
        <field>ASI_CRM_Sys_Allow_Submit_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Set Sys Allow Submit Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI_CRM_JP_Default_SPTD_Fiscal_Year</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_Default_Fiscal_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &apos;ASI_CRM_JP_SPTD_Contract&apos; &amp;&amp; OR( ISNEW(), ISPICKVAL(ASI_CRM_Status__c, &apos;Draft&apos;) &amp;&amp;  ISCHANGED( ASI_CRM_Start_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Fix_Rebate_Contract_Clear_End_Date</fullName>
        <actions>
            <name>ASI_CRM_JP_Clear_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   OR(CONTAINS(RecordType.DeveloperName, &quot;ASI_CRM_JP_Indirect_Rebate_Contract&quot;), CONTAINS(RecordType.DeveloperName, &quot;ASI_CRM_JP_Direct_Rebate_Contract&quot;)),   ISPICKVAL(ASI_CRM_Fixed_Spot__c, &quot;Fixed&quot;),   NOT(ISBLANK(ASI_CRM_End_Date__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Free_Direct_Rebate_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_DirectRebateContract_Free</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP Direct Rebate Contract Read-Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>ASI_CRM_JP_Free_Direct_Rebate_Contract</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Free_Indirect_Rebate_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_IndirRebateContract_Free</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP Indirect Rebate Contract Read-Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>ASI_CRM_JP_Free_Indirect_Rebate_Contract</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Free_SPTD_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_SPTD_Contract_Free</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP SPTD Contract Read-Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>ASI_CRM_JP_Free_SPTD_Contract</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Lock_Direct_Rebate_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_DirectRebateContract_Read</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP Direct Rebate Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>ASI_CRM_JP_Lock_Direct_Rebate_Contract</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Lock_Indirect_Rebate_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_IndirRebateContr_Read</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP Indirect Rebate Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>ASI_CRM_JP_Lock_Indirect_Rebate_Contract</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Lock_SPTD_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Set_SPTD_Contract_Read_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP SPTD Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>ASI_CRM_JP_Lock_SPTD_Contract</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_Reject_DirRebate_Contract</fullName>
        <actions>
            <name>ASI_CRM_JP_Direct_Rebate_Contract_Rejected_Notification_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_JP_Set_DirectRebateContract_Free</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP Direct Rebate Contract Read-Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_Purchase_Contract__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_JP_SPTD_Contract_has_been_Closed</fullName>
        <actions>
            <name>ASI_CRM_JP_SPTD_Contract_Complete_Notification_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &apos;ASI_CRM_JP_SPTD_Contract_Read_Only&apos; &amp;&amp;   ISPICKVAL(ASI_CRM_Status__c, &apos;Complete&apos;) &amp;&amp;  OwnerId &lt;&gt;  LastModifiedById</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>