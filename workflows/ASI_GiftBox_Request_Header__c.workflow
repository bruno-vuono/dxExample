<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_VN_CS_Request_Approved_Email</fullName>
        <description>ASI CRM VN CS Request Approved Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_VN_Contract_Approver</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_CS_Approved_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_CS_Request_Rejected_Email</fullName>
        <description>ASI CRM VN CS Request Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_CS_Rejected_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Capsule_CS_Approved_Email</fullName>
        <description>ASI CRM VN Capsule CS Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_Capsule_CS_Approved_Email_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Capsule_CS_Completed_Email</fullName>
        <description>ASI CRM VN Capsule CS Completed Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_Capsule_CS_Complete_Email_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Capsule_CS_Confirm_Email</fullName>
        <description>ASI CRM VN Capsule CS Confirm Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_VN_Contract_Approver</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_Capsule_CS_Confirm_Email_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Capsule_CS_Rejected_Email</fullName>
        <description>ASI CRM VN Capsule CS Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_Capsule_CS_Rejected_Email_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_DisplayListing_Request_Approved_Email</fullName>
        <description>ASI CRM VN Display Listing Request Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_DisplayListing_Approved_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_DisplayListing_Request_Rejected_Email</fullName>
        <description>ASI CRM VN Display Listing Request Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_DisplayListing_Rejected_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_FOC_Request_Approved_Email</fullName>
        <description>ASI CRM VN FOC Request Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_FOC_Approved_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_FOC_Request_Rejected_Email</fullName>
        <description>ASI CRM VN FOC Request Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_FOC_Rejected_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Approved_HR_Email_Alert</fullName>
        <description>ASI CRM VN POSM Approved HR Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_VN_HR_Manager</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Approved_HR_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Request_Accepted_Notify_Marketing</fullName>
        <description>ASI CRM VN POSM Request Accepted Notify Marketing</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_GiftBox_Marketing_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Request_Ntfy_Marketing</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Request_Accepted_Notify_Requester</fullName>
        <description>ASI CRM VN POSM Request Accepted Notify Requester</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Request_Accepted_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Request_Approved_Email</fullName>
        <description>ASI CRM VN POSM Request Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Approved_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Request_Approved_Notify_HR_Email</fullName>
        <description>ASI CRM VN POSM Request Approved Notify HR Email</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_GiftBox_HR_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Request_Notify_HR_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Request_Complete_Notify_Requester</fullName>
        <description>ASI CRM VN POSM Request Complete Notify Requester</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Request_Completed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Request_Rejected_Email</fullName>
        <description>ASI CRM VN POSM Request Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Rejected_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_POSM_Status_to_Waiting_Delivery_Alert</fullName>
        <description>ASI CRM VN POSM Status to Waiting Delivery Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_VN_Marketing_Dept</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Wait_Delivery_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Promotion_Request_Approved_Email</fullName>
        <description>ASI CRM VN Promotion Request Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_Promotion_Approved_Email_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Promotion_Request_Rejected_Email</fullName>
        <description>ASI CRM VN Promotion Request Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_Promotion_Rejected_Email_Tmp</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_VN_Status_to_Pending_Finance_Alert</fullName>
        <description>ASI CRM VN Status to Pending Finance Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>itservicedesk@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_VN_Email_Templates/ASI_CRM_VN_POSM_Finance_Email_Temp</template>
    </alerts>
    <alerts>
        <fullName>ASI_GiftBox_Request_Notify_Accept</fullName>
        <description>ASI GiftBox Request Notify Accept</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_GiftBox_Email_Template/ASI_GiftBox_Request_Accept</template>
    </alerts>
    <alerts>
        <fullName>ASI_GiftBox_Request_Notify_Finance_Delivery</fullName>
        <description>ASI GiftBox Request Notify Finance Delivery</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>ASI_GiftBox_Finance_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_GiftBox_Email_Template/ASI_GiftBox_Notify_Finace_Delivery</template>
    </alerts>
    <alerts>
        <fullName>ASI_GiftBox_Request_Notify_HR_Handler</fullName>
        <description>ASI GiftBox Request Notify HR Handler</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_GiftBox_HR_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_GiftBox_Email_Template/ASI_GiftBox_Request_Notify_HR</template>
    </alerts>
    <alerts>
        <fullName>ASI_GiftBox_Request_Notify_Marketing_Delivery</fullName>
        <description>ASI GiftBox Request Notify Marketing Delivery</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_GiftBox_Marketing_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_GiftBox_Email_Template/ASI_GiftBox_Notify_Marketing_Delivery</template>
    </alerts>
    <alerts>
        <fullName>ASI_GiftBox_Request_Notify_Reject</fullName>
        <description>ASI GiftBox Request Notify Reject</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_GiftBox_Email_Template/ASI_GiftBox_Request_Reject</template>
    </alerts>
    <alerts>
        <fullName>ASI_GiftBox_Request_Notify_Requester_Complete</fullName>
        <description>ASI GiftBox Request Notify Requester Complete</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_GiftBox_Email_Template/ASI_GiftBox_Request_Notify_Requester_Complete</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Promotion_Request_Read_Only</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_VN_Promotion_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Promotion Request Read Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Revert_Over_Balance</fullName>
        <field>ASI_CRM_Over_Balance__c</field>
        <literalValue>0</literalValue>
        <name>ASI CRM VN Revert Over Balance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_CS_Req_ReadOnly_RecType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_VN_CS_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Set CS Req ReadOnly RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_Capsule_CS_ReadOnly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_VN_Capsule_CS_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Set Capsule CS ReadOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_DisplayListing_ReadOnly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_VN_Display_Listing_Fee_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Set DisplayListing ReadOnly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_FOC_Req_ReadOnly_RecType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_VN_FOC_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Set FOC Req ReadOnly RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_POSM_Req_ReadOnly_RecType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_POSM_VN_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Set POSM Req ReadOnly RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_POSM_Request_RecType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_POSM_VN_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM VN Set POSM Request RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_Status_Approved</fullName>
        <field>ASI_GiftBox_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI CRM VN Set Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_Status_Open</fullName>
        <field>ASI_GiftBox_Status__c</field>
        <literalValue>Open</literalValue>
        <name>ASI CRM VN Set Status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_Status_Submitted</fullName>
        <field>ASI_GiftBox_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI CRM VN Set Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_Status_Wait_for_HR_Review</fullName>
        <field>ASI_GiftBox_Status__c</field>
        <literalValue>Waiting for HR Review</literalValue>
        <name>ASI CRM VN Set Status Wait for HR Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_VN_Set_Sys_Pending_Apprval_False</fullName>
        <field>ASI_CRM_Sys_Pending_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Set Sys Pending Approval False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_GiftBox_UpdateStatus_Complete</fullName>
        <field>ASI_GiftBox_Status__c</field>
        <literalValue>Complete</literalValue>
        <name>ASI_GiftBox_UpdateStatus_Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_Gift_Box_Request_RecType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_GiftBox_VN_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI Gift Box Request RecType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI GiftBox Request Notify Requester Complete</fullName>
        <actions>
            <name>ASI_GiftBox_Request_Notify_Requester_Complete</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(     CONTAINS(RecordType.DeveloperName, &quot;ASI_GiftBox_VN_Request&quot;),     ISPICKVAL(PRIORVALUE(ASI_GiftBox_Status__c), &quot;Waiting for Delivery&quot;),     ISPICKVAL( ASI_GiftBox_Status__c , &quot;Complete&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI GiftBox Request Reject</fullName>
        <actions>
            <name>ASI_GiftBox_Request_Notify_Reject</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL( PRIORVALUE(ASI_GiftBox_Status__c ) , &quot;Waiting for HR Review&quot;) , ISPICKVAL( ASI_GiftBox_Status__c , &quot;Reject&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI GiftBox Request Submit</fullName>
        <actions>
            <name>ASI_GiftBox_Request_Notify_HR_Handler</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_Gift_Box_Request_RecType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND ( ISPICKVAL(  PRIORVALUE(ASI_GiftBox_Status__c ) , &quot;Open&quot;) , ISPICKVAL( ASI_GiftBox_Status__c , &quot;Waiting for HR Review&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI GiftBox Request Waiting for Delivery</fullName>
        <actions>
            <name>ASI_GiftBox_Request_Notify_Accept</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_GiftBox_Request_Notify_Finance_Delivery</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_GiftBox_Request_Notify_Marketing_Delivery</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(     CONTAINS(RecordType.DeveloperName, &quot;ASI_GiftBox_VN_Request&quot;),     ISPICKVAL(PRIORVALUE(ASI_GiftBox_Status__c), &quot;Waiting for HR Review&quot;),     ISPICKVAL(ASI_GiftBox_Status__c , &quot;Waiting for Delivery&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_VN_Capsule_CS_Completed</fullName>
        <actions>
            <name>ASI_CRM_VN_Capsule_CS_Completed_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_GiftBox_Request_Header__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI CRM VN Capsule CS Request,ASI CRM VN Capsule CS Request Read Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_GiftBox_Request_Header__c.ASI_GiftBox_Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_VN_POSM_Request_Notify_Requester_Complete</fullName>
        <actions>
            <name>ASI_CRM_VN_POSM_Request_Complete_Notify_Requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(     CONTAINS(RecordType.DeveloperName, &quot;ASI_CRM_POSM_VN_Request&quot;),     ISPICKVAL(PRIORVALUE(ASI_GiftBox_Status__c), &quot;Waiting for Delivery&quot;),     ISPICKVAL( ASI_GiftBox_Status__c , &quot;Complete&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_VN_POSM_Request_Waiting_for_Delivery</fullName>
        <actions>
            <name>ASI_CRM_VN_POSM_Request_Accepted_Notify_Marketing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_VN_POSM_Request_Accepted_Notify_Requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(     CONTAINS(RecordType.DeveloperName, &quot;ASI_CRM_POSM_VN_Request&quot;),     ISPICKVAL(PRIORVALUE(ASI_GiftBox_Status__c), &quot;Waiting for HR Review&quot;),     ISPICKVAL(ASI_GiftBox_Status__c , &quot;Waiting for Delivery&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_VN_POSM_Status_to_Pending_Finance</fullName>
        <actions>
            <name>ASI_CRM_VN_Status_to_Pending_Finance_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_GiftBox_Request_Header__c.ASI_GiftBox_Status__c</field>
            <operation>equals</operation>
            <value>Pending Finance Processing</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_GiftBox_Request_Header__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI POSM VN Request,ASI POSM VN Request Read-Only</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_VN_POSM_Status_to_Wait_Delivery</fullName>
        <actions>
            <name>ASI_CRM_VN_POSM_Status_to_Waiting_Delivery_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_GiftBox_Request_Header__c.ASI_GiftBox_Status__c</field>
            <operation>equals</operation>
            <value>Waiting for Delivery</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_GiftBox_Request_Header__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI POSM VN Request,ASI POSM VN Request Read-Only</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
