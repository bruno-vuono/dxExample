<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Sales_Account_Approved_Email_Template</fullName>
        <description>ASI CRM JP Direct Sales Account Approved Email Template</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_DirectSales_Account_Approved_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Sales_Account_Reject_Email_Alert</fullName>
        <description>ASI CRM JP Direct Sales Account Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_DirectSales_Account_Rejected_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Sales_Approval_Approved_Email_Alert</fullName>
        <description>ASI CRM JP Direct Sales Approval Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_DirectSales_Approved_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Sales_Approval_Rejected_Email_Alert</fullName>
        <description>ASI CRM JP Direct Sales Approval Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_DirectSales_Rejected_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Direct_Sales_Approved_Adv_Payment_Email_Alert</fullName>
        <description>ASI CRM JP Direct Sales Approved Adv Payment Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_JP_Accounting</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_DirSOAdvPay_ApprovedEmailTemp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Entertainment_SO_Approval_Approved_Email_Alert</fullName>
        <description>ASI CRM JP Entertainment SO Approval Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Entertainment_Approved_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Entertainment_SO_Approval_Rejected_Email_Alert</fullName>
        <description>ASI CRM JP Entertainment SO Approval Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_JP_Entertainment_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Entertainment_Rejected_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Marketing_FOC_Approval_Approved_Email_Alert</fullName>
        <description>ASI CRM JP Marketing FOC Approval Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_MarketingFOC_ApprovalApproved</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Marketing_FOC_Approval_Rejected_Email_Alert</fullName>
        <description>ASI CRM JP Marketing FOC Approval Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_MarketingFOC_ApprovalRejected</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Sales_Order_COT_Approved_Email_Alert</fullName>
        <description>ASI CRM JP Sales Order COT Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Sales_Order_COT_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Sales_Order_COT_Rejected_Email_Alert</fullName>
        <description>ASI CRM JP Sales Order COT Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Sales_Order_COT_Rejected_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Sample_Sales_Approval_Approved_Email_Alert</fullName>
        <description>ASI CRM JP Sample Sales Approval Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_SampleSO_ApprovalApproved_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Sample_Sales_Approval_Rejected_Email_Alert</fullName>
        <description>ASI CRM JP Sample Sales Approval Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_SampleSO_ApprovalRejected_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_JP_Zero_SO_Line_Reject_Email_Alert</fullName>
        <description>ASI CRM JP Zero SO Line Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_JP_Email_Templates/CRM_JP_Zero_SO_Line_Rejected_Notification_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Direct_Sales_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Direct_Sales_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Direct Sales Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Direct_Sales_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Direct_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Direct Sales Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Duty_Free_SO_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Duty_Free_SO_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Duty Free SO Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Duty_Free_SO_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Duty_Free_SO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Duty Free SO Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Employee_Sales_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Employee_Sales_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Employee Sales Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Employee_Sales_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Employee_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Employee Sales Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Entertainment_Sales_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Entertainment_Sales_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Entertainment Sales Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Entertainment_Sales_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Entertainment_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Entertainment Sales Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Fill_Sale_Code_Owner_s_code</fullName>
        <field>ASI_CRM_Salesman_Code__c</field>
        <formula>Owner:User.EmployeeNumber</formula>
        <name>ASI CRM JP Fill Sale Code (Owner&apos;s code)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Marketing_FOC_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Marketing_FOC_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Marketing FOC Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Marketing_FOC_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Marketing_FOC</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Marketing FOC Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Normal_SO_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Normal_SO_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Normal SO Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Normal_SO_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Normal_SO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Normal SO Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_SO_Update_Status_Approved</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI CRM JP SO Update Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_SO_Update_Status_Rejected</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>ASI CRM JP SO Update Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_SO_Update_Status_to_Open</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Open</literalValue>
        <name>ASI CRM JP SO Update Status to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_SO_Update_Status_to_Submitted</fullName>
        <field>ASI_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI CRM JP SO Update Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Sample_Sales_Locked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Sample_Sales_Locked</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Sample Sales Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Sample_Sales_Unlocked</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_JP_Sample_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM JP Sample Sales Unlocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_JP_Update_EDI_Code_to_SHANAI</fullName>
        <field>ASI_CRM_Business_Reason__c</field>
        <literalValue>SHANAI</literalValue>
        <name>ASI CRM JP Update EDI Code to SHANAI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI CRM JP Direct Sales Account Approved Email Alert</fullName>
        <actions>
            <name>ASI_CRM_JP_Direct_Sales_Account_Approved_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(   OR(RecordType.DeveloperName = &apos;ASI_CRM_JP_Direct_Sales&apos;,      RecordType.DeveloperName = &apos;ASI_CRM_JP_Direct_Sales_Locked&apos;),   ISCHANGED( ASI_CRM_Status__c ) ,  ISPICKVAL(PRIORVALUE(ASI_CRM_Status__c), &apos;Approved&apos;),    ISPICKVAL(ASI_CRM_Status__c, &apos;AC Verified&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Direct Sales Account Rejected Email Alert</fullName>
        <actions>
            <name>ASI_CRM_JP_Direct_Sales_Account_Reject_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_JP_Direct_Sales_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(RecordType.DeveloperName = &apos;ASI_CRM_JP_Direct_Sales&apos;,          RecordType.DeveloperName = &apos;ASI_CRM_JP_Direct_Sales_Locked&apos;),      ISCHANGED( ASI_CRM_Status__c ) ,      ISPICKVAL(PRIORVALUE(ASI_CRM_Status__c), &apos;Approved&apos;),      ISPICKVAL(ASI_CRM_Status__c, &apos;Rejected&apos;),      ISPICKVAL( ASI_CRM_Payment_Option__c , &apos;Advanced Payment&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Direct Sales Approved</fullName>
        <actions>
            <name>ASI_CRM_JP_Direct_Sales_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Direct Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Direct Sales Rejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Direct_Sales_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Direct Sales - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Duty Free SO Open%2FRejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Duty_Free_SO_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Duty Free SO - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Duty Free SO Requested</fullName>
        <actions>
            <name>ASI_CRM_JP_Duty_Free_SO_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Duty Free SO</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Employee Sales Open%2FRejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Employee_Sales_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee Sales - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Employee Sales Requested</fullName>
        <actions>
            <name>ASI_CRM_JP_Employee_Sales_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Employee Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Entertainment Sales Approved</fullName>
        <actions>
            <name>ASI_CRM_JP_Entertainment_Sales_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Entertainment Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Entertainment Sales Rejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Entertainment_Sales_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Entertainment Sales - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Fill A%26P Code Marketing FOC</fullName>
        <actions>
            <name>ASI_CRM_JP_Update_EDI_Code_to_SHANAI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing FOC,Marketing FOC - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Business_Reason__c</field>
            <operation>notEqual</operation>
            <value>SHANAI</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_AP_Code__c</field>
            <operation>equals</operation>
            <value>9019</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Fill Salesman Code %28Marketing FOC%29</fullName>
        <actions>
            <name>ASI_CRM_JP_Fill_Sale_Code_Owner_s_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing FOC</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Salesman_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Fill Salesman Code %28Sample SO%29</fullName>
        <actions>
            <name>ASI_CRM_JP_Fill_Sale_Code_Owner_s_code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sample Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Salesman_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Marketing FOC Approved</fullName>
        <actions>
            <name>ASI_CRM_JP_Marketing_FOC_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing FOC</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Marketing FOC Rejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Marketing_FOC_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing FOC - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Normal SO Open%2FRejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Normal_SO_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Normal SO - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Normal SO Requested</fullName>
        <actions>
            <name>ASI_CRM_JP_Normal_SO_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Normal SO</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Sales Order COT Approved Email Alert</fullName>
        <actions>
            <name>ASI_CRM_JP_Sales_Order_COT_Approved_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName &lt;&gt; &apos;ASI_CRM_JP_Manual_JDE_SO&apos;  &amp;&amp; ISPICKVAL(ASI_CRM_Status__c , &apos;Final&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Sales Order COT Rejected Email Alert</fullName>
        <actions>
            <name>ASI_CRM_JP_Sales_Order_COT_Rejected_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName &lt;&gt; &apos;ASI_CRM_JP_Manual_JDE_SO&apos;  &amp;&amp; ISPICKVAL(ASI_CRM_Status__c , &apos;Rejected&apos;) &amp;&amp; (  (RecordType.DeveloperName = &apos;ASI_CRM_JP_Direct_Sales_Locked&apos; &amp;&amp;   ISPICKVAL(PRIORVALUE(ASI_CRM_Status__c), &apos;AC Verified&apos;) &amp;&amp;   ISPICKVAL( ASI_CRM_Payment_Option__c , &apos;Advanced Payment&apos;)   )  ||  (RecordType.DeveloperName = &apos;ASI_CRM_JP_Direct_Sales_Locked&apos; &amp;&amp;   ISPICKVAL(PRIORVALUE(ASI_CRM_Status__c), &apos;Approved&apos;) &amp;&amp;   (ISPICKVAL( ASI_CRM_Payment_Option__c , &apos;COD&apos;) || ISPICKVAL( ASI_CRM_Payment_Option__c , &apos;Invoice&apos;))   )  ||   (RecordType.DeveloperName &lt;&gt; &apos;ASI_CRM_JP_Direct_Sales_Locked&apos; &amp;&amp;   (ISPICKVAL(PRIORVALUE(ASI_CRM_Status__c), &apos;Approved&apos;) || ISPICKVAL(PRIORVALUE(ASI_CRM_Status__c), &apos;Requested&apos;))   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Sample Sales Approved</fullName>
        <actions>
            <name>ASI_CRM_JP_Sample_Sales_Locked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sample Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM JP Sample Sales Rejected</fullName>
        <actions>
            <name>ASI_CRM_JP_Sample_Sales_Unlocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sample Sales - Locked</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_JP_Sales_Order__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
