<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EUR_CRM_DE_Send_Contract_Approved_Notice</fullName>
        <description>Send Contract Approved Notice</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DE_Email_Template/EUR_CRM_DE_Contract_Approved_Notice</template>
    </alerts>
    <alerts>
        <fullName>EUR_CRM_DE_Send_Contract_Rejected_Notice</fullName>
        <description>Send Contract Rejected Notice</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_DE_Email_Template/EUR_CRM_DE_Contract_Rejected_Notice</template>
    </alerts>
    <alerts>
        <fullName>EUR_CRM_FI_Send_Contract_Approved_Notice</fullName>
        <description>Send Contract Approved Notice</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_FI_Email_Template/EUR_CRM_FI_Contract_Approved_Notice</template>
    </alerts>
    <alerts>
        <fullName>EUR_GB_Email_Reminder_of_Contract_End</fullName>
        <description>EUR GB Email Reminder of Contract End</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_GB_Email_Template/EUR_GB_Deactivate_Contract_Reminder</template>
    </alerts>
    <alerts>
        <fullName>EUR_PT_Contract_Approval_Notification</fullName>
        <ccEmails>raquel.faisca@pernod-ricard.com</ccEmails>
        <ccEmails>David.Pinto@pernod-ricard.com</ccEmails>
        <description>EUR PT Contract Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_PT_Email_Templates/EUR_PT_Contract_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>EUR_PT_Contract_Reject_Notification</fullName>
        <ccEmails>raquel.faisca@pernod-ricard.com</ccEmails>
        <ccEmails>David.Pinto@pernod-ricard.com</ccEmails>
        <description>EUR PT Contract Reject Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_PT_Email_Templates/EUR_PT_Contract_Reject_Notification</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Activated_Contract_to_Event_Manager</fullName>
        <description>EUR ZA Send Activated Contract to Event Manager</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Event_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_ZA_Contract_Notify_Event_Mgr</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Activated_Contract_to_National_Training_Manager</fullName>
        <description>EUR ZA Send Activated Contract to National Training Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.backhouse@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_ZA_Contract_Notify_Training_Mgr</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Activated_POSM_Contract_to_Warehouse_Manager</fullName>
        <description>EUR ZA Send Activated POSM Contract to Warehouse Manager</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Warehouse_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_ZA_Contract_Notify_WarehouseMgr_POS</template>
    </alerts>
    <alerts>
        <fullName>EUR_ZA_Send_Activated_Uniforms_Contract_to_Warehouse_Manager</fullName>
        <description>EUR ZA Send Activated Uniforms Contract to Warehouse Manager</description>
        <protected>false</protected>
        <recipients>
            <field>EUR_CRM_Warehouse_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_CRM_ZA_Email_Templates/EUR_ZA_Contract_Notify_WhS_Mgr_Uniform</template>
    </alerts>
    <fieldUpdates>
        <fullName>EUR_CRM_DE_AutoActivateContract</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Activated</literalValue>
        <name>EUR_CRM_DE_AutoActivateContract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_DE_SetContractActiveFlag</fullName>
        <field>EUR_CRM_Active__c</field>
        <literalValue>1</literalValue>
        <name>EUR_CRM_DE_SetContractActiveFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_DE_Update_Customer_Approved_Date</fullName>
        <field>EUR_CRM_Customer_Approved_Date__c</field>
        <formula>today()</formula>
        <name>EUR CRM DE Update Customer Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_FI_Set_Contract_Active_to_False</fullName>
        <field>EUR_CRM_Active__c</field>
        <literalValue>0</literalValue>
        <name>EUR CRM FI Set Contract Active to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_FI_Set_Status_To_Approved</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR CRM FI Set Status To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_FI_Set_Status_to_Deactivated</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Deactivated</literalValue>
        <name>EUR CRM FI Set Status to Deactivated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_FU_Generate_Subtype_Basic</fullName>
        <field>EUR_CRM_Contract_Sub_Type__c</field>
        <literalValue>Basic Contract</literalValue>
        <name>EUR_CRM_FU_Generate_Subtype_Basic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_FU_Generate_Subtype_Concept</fullName>
        <field>EUR_CRM_Contract_Sub_Type__c</field>
        <literalValue>Concept Contract</literalValue>
        <name>EUR_CRM_FU_Generate_Subtype_Concept</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Set_Contract_Approved_Date</fullName>
        <field>EUR_CRM_Contract_Approved_Date__c</field>
        <formula>Today()</formula>
        <name>EUR CRM Set Contract Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Set_Contract_to_Inactive</fullName>
        <field>EUR_CRM_Active__c</field>
        <literalValue>0</literalValue>
        <name>EUR CRM Set Contract to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Set_Status_to_Approved</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR CRM Set Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Set_Status_to_Contract_Approved</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Contract Approved</literalValue>
        <name>EUR CRM Set Status to Contract Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_CRM_Set_Status_to_Submitted</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR CRM Set Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_FI_Set_Status_to_Draft</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>EUR FI Set Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_GB_Set_Max_Contract_Value</fullName>
        <field>EUR_CRM_Manager_Approved_TCV__c</field>
        <formula>IF(ISBLANK( EUR_CRM_Manager_Approved_TCV__c ),  EUR_CRM_Total_Contract_Value__c, EUR_CRM_Manager_Approved_TCV__c)</formula>
        <name>EUR GB Set Max Contract Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_GB_Set_Proposal_Approved_Date</fullName>
        <field>EUR_CRM_Proposal_Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>EUR GB Set Proposal Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_GB_Set_Status_to_Proposal_Approved</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Proposal Approved</literalValue>
        <name>EUR GB Set Status to Proposal Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_GB_Set_Status_to_Rejected</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR GB Set Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Approval_Status_to_Approved</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR PT Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Approval_Status_to_Rejected</fullName>
        <field>EUR_CRM_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR PT Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_ContractStatus_to_APA</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Approved-Pending Activation</literalValue>
        <name>EUR PT ContractStatus to APA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Contract_Status_to_Activated</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Activated</literalValue>
        <name>EUR PT Contract Status to Activated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Contract_Status_to_Approved</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>EUR PT Contract Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Contract_Status_to_Deactivated</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Deactivated</literalValue>
        <name>EUR PT Contract Status to Deactivated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Contract_Status_to_Draft</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>EUR PT Contract Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Contract_Status_to_Rejected</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>EUR PT Contract Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUR_PT_Contract_Status_to_Submitted</fullName>
        <field>EUR_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>EUR PT Contract Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>EUR CRM FI Deactivate Contract</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR FI Chain Contract,EUR FI Independent Contract</value>
        </criteriaItems>
        <description>Time-based work flow kicks off when a FI contract is activated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EUR_CRM_FI_Set_Contract_Active_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>EUR_CRM_FI_Set_Status_to_Deactivated</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>EUR_CRM_Contract__c.EUR_CRM_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EUR GB Deactivate Contract Process</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>GB Contract</value>
        </criteriaItems>
        <description>Time-based work flow kicks off when contract is activated by user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EUR_GB_Email_Reminder_of_Contract_End</name>
                <type>Alert</type>
            </actions>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>EUR_CRM_Set_Contract_to_Inactive</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>EUR_CRM_Contract__c.EUR_CRM_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EUR PT Contract Approval Notification Workflow</fullName>
        <actions>
            <name>EUR_PT_Contract_Approval_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR PT Outlet Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This is a workflow in order to capture the correct field update values in VF email template.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR PT Contract Reject Notification Workflow</fullName>
        <actions>
            <name>EUR_PT_Contract_Reject_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR PT Outlet Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>This is a workflow in order to capture the correct field update values in VF email template.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA Activated Contract Notification to Event Manager</fullName>
        <actions>
            <name>EUR_ZA_Send_Activated_Contract_to_Event_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR ZA Outlet Contract,EUR ZA Head Office Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_No_of_Events__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Workflow to send an email notification to the Event Manager of the Account whose contract has been activated. The contract must have at least one Event.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA Activated Contract to National Training Manager</fullName>
        <actions>
            <name>EUR_ZA_Send_Activated_Contract_to_National_Training_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR ZA Outlet Contract,EUR ZA Head Office Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_No_of_Trainings__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Notify the National Training Manager, through email, that a Contract, containing at least 1 Training, has been Activated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA Activated POSM Contract to Warehouse Manager</fullName>
        <actions>
            <name>EUR_ZA_Send_Activated_POSM_Contract_to_Warehouse_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR ZA Outlet Contract,EUR ZA Head Office Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_No_of_POS_Materials__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Notify the Warehouse Manager, through email, that a Contract, containing at least 1 POSM, has been Activated in his/ her region.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR ZA Activated Uniforms Contract to Warehouse Manager</fullName>
        <actions>
            <name>EUR_ZA_Send_Activated_Uniforms_Contract_to_Warehouse_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EUR ZA Outlet Contract,EUR ZA Head Office Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>EUR_CRM_Contract__c.EUR_CRM_No_of_Uniforms__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Notify the Warehouse Manager, through email, that a Contract, containing at least 1 Uniform, has been Activated in his/ her region.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUR_CRM_DE_AutoActivateContract</fullName>
        <actions>
            <name>EUR_CRM_DE_AutoActivateContract</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EUR_CRM_DE_SetContractActiveFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EUR_CRM_DE_Update_Customer_Approved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( EUR_CRM_Contract_Uploaded__c)   &amp;&amp; EUR_CRM_DE_Actual_Contract_Total__c &lt;= 3500 &amp;&amp; TEXT(EUR_CRM_Status__c ) == &apos;Approved&apos; &amp;&amp; TEXT(EUR_CRM_Contract_Type__c) == &apos;Standard Contract&apos;&amp;&amp; EUR_CRM_Contract_Uploaded__c &amp;&amp; $RecordType.DeveloperName == &apos;EUR_DE_Contract&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR_CRM_WF_Generate_Subtype_Basic</fullName>
        <actions>
            <name>EUR_CRM_FU_Generate_Subtype_Basic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName == &apos;EUR_DE_Contract&apos;,ISPICKVAL(EUR_CRM_Contract_Type__c, &apos;Standard Contract&apos;),  NOT(AND(EUR_CRM_DE_Actual_Contract_Total__c&gt;3500, EUR_CRM_Number_of_Mechanics__c &gt;=3)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EUR_CRM_WF_Generate_Subtype_Concept</fullName>
        <actions>
            <name>EUR_CRM_FU_Generate_Subtype_Concept</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.DeveloperName == &apos;EUR_DE_Contract&apos;,ISPICKVAL(EUR_CRM_Contract_Type__c, &apos;Standard Contract&apos;), EUR_CRM_DE_Actual_Contract_Total__c&gt;3500,EUR_CRM_Number_of_Mechanics__c &gt;=3)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
