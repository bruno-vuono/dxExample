<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_Payment_Request_Approved_Email_Alert</fullName>
        <description>ASI_CRM_CN_Heavy_Payment_Request_Approved_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Payment_ApprovedEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_Payment_Request_Paid_Email_Alert</fullName>
        <description>ASI_CRM_CN_Heavy_Payment_Request_Paid_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Payment_PaidEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_Payment_Request_Rejected_Email_Alert</fullName>
        <description>ASI_CRM_CN_Heavy_Payment_Request_Rejected_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Payment_RejectedEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_Payment_Request_Rejected_Email_Alert_RBA</fullName>
        <description>ASI_CRM_CN_Heavy_Payment_Request_Rejected_Email_Alert_RBA</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_CN_Last_RBA_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Payment_RejectedEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Payment_Request_Approved_Email_Alert</fullName>
        <ccEmails>prc.tradepayment@pernod-ricard.com</ccEmails>
        <description>ASI_CRM_CN_Payment_Request_Approved_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Payment_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Payment_Request_Rejected_Email_Alert</fullName>
        <ccEmails>prc.tradepayment@pernod-ricard.com</ccEmails>
        <description>ASI_CRM_CN_Payment_Request_Rejected_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Payment_Rejected_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Group_Director_Approval_Email_Alert_for_Payment_Request_Approval</fullName>
        <description>ASI_CRM_SG_Group_Director_Approval_Email_Alert_for_Payment_Request_Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Managing_Director_Approval_Email_Alert_for_Payment_Request_Approval</fullName>
        <description>ASI_CRM_SG_Managing_Director_Approval_Email_Alert_for_Payment_Request_Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Payment_Request_Approval_To_Finance_Email_Alert</fullName>
        <description>ASI CRM SG - Payment Request Approval To Finance Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>darren.wong@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jaslynn.ong@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Approval_To_Finance_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Payment_Request_Finance_Reject_Email_Alert</fullName>
        <description>ASI CRM SG - Payment Request Finance Reject Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Finance_Reject_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Payment_Request_Rejection_Email_Alert</fullName>
        <description>ASI CRM SG - Payment Request Rejection Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Rejection_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Sales_Director_Approval_Email_Alert_for_Payment_Request_Approval</fullName>
        <description>ASI_CRM_SG_Sales_Director_Approval_Email_Alert_for_Payment_Request_Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Sales_Manager_Approval_Email_Alert_for_Payment_Request_Approval</fullName>
        <description>ASI_CRM_SG_Sales_Manager_Approval_Email_Alert_for_Payment Request_Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Payment_Request_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_TH_CRM_RejectPaymentRequest_CDP</fullName>
        <description>ASI TH CRM RejectPaymentRequest - CDP</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_TH_CRM_Email_Templates/ASI_TH_CRM_RejectPaymentRequest</template>
    </alerts>
    <alerts>
        <fullName>ASI_TH_CRM_RejectPaymentRequest_FD</fullName>
        <description>ASI TH CRM RejectPaymentRequest - FD</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_TH_CRM_Head_of_Finance_Operations__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_TH_CRM_Email_Templates/ASI_TH_CRM_RejectPaymentRequest</template>
    </alerts>
    <alerts>
        <fullName>ASI_TH_CRM_RejectPaymentRequest_MD</fullName>
        <description>ASI TH CRM RejectPaymentRequest - MD</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_TH_CRM_Managing_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_TH_CRM_Email_Templates/ASI_TH_CRM_RejectPaymentRequest</template>
    </alerts>
    <alerts>
        <fullName>ASI_TH_CRM_RejectPaymentRequest_RSM</fullName>
        <description>ASI TH CRM RejectPaymentRequest - RSM</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_TH_CRM_Regional_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_TH_CRM_Email_Templates/ASI_TH_CRM_RejectPaymentRequest</template>
    </alerts>
    <alerts>
        <fullName>ASI_TH_CRM_RejectPaymentRequest_SD</fullName>
        <description>ASI TH CRM RejectPaymentRequest - SD</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_TH_CRM_Head_of_National_On_Trade__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_TH_CRM_Email_Templates/ASI_TH_CRM_RejectPaymentRequest</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CN_CRM_Pmt_Req_Check_RVP_Reject</fullName>
        <field>ASI_CRM_CN_RVP_Flag__c</field>
        <literalValue>1</literalValue>
        <name>ASI CN CRM Pmt Req Check RVP Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Payment_Request_Copy_Division</fullName>
        <field>ASI_CRM_CN_Division_Code__c</field>
        <formula>ASI_CRM_CN_OutletWS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Division_Code__c</formula>
        <name>ASI CRM CN Payment Request Copy Division</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Approved</fullName>
        <description>(CN-CRM) Payment Request - Set Appr Status - Approved</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Payment Request-Set Appr Status-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Draft</fullName>
        <description>(CN-CRM) Payment Request - Set Appr Status - Draft</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Payment Request-Set Appr Status - Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Recall</fullName>
        <description>(CN-CRM) Payment Request - Set Appr Status - Recall</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Payment Request-Set Appr Status - Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Rejected</fullName>
        <description>(CN-CRM) Payment Request - Set Appr Status - Rejected</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Payment Request-Set Appr Status-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Submitted</fullName>
        <description>(CN-CRM)Payment Request - Set Appr Status - Submitted</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Payment Request-Set ApprStatus-Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Approved_By</fullName>
        <description>(CN-CRM) Payment Request - Set Last Approved By</description>
        <field>ASI_CRM_CN_Last_Approved_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Payment Request - Set Last Approved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Approved_Date</fullName>
        <field>ASI_CRM_CN_Last_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>Payment Request - Set Last Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Recall_By</fullName>
        <description>(CN-CRM) Contract - Set Last Recall By</description>
        <field>ASI_CRM_CN_Last_Recall_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Payment Request - Set Last Recall By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Recall_Date</fullName>
        <description>(CN-CRM) Payment Request - Set Last Recall Date</description>
        <field>ASI_CRM_CN_Last_Recall_Date__c</field>
        <formula>NOW()</formula>
        <name>Payment Request - Set Last Recall Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Rejected_By</fullName>
        <description>(CN-CRM) Payment Request - Set Last Rejected By</description>
        <field>ASI_CRM_CN_Last_Rejected_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Payment Request - Set Last Rejected By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Rejected_Date</fullName>
        <description>(CN-CRM) Payment Request - Set Last Rejected Date</description>
        <field>ASI_CRM_CN_Last_Rejected_Date__c</field>
        <formula>NOW()</formula>
        <name>Payment Request - Set Last Rejected Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Submitted_By</fullName>
        <description>(CN-CRM) Payment Request- Set Last Submitted By</description>
        <field>ASI_CRM_CN_Last_Submitted_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Payment Request - Set Last Submitted By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Submitted_Date</fullName>
        <description>(CN-CRM) Payment Request - Set Last Submitted Date</description>
        <field>ASI_CRM_CN_Last_Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>Payment Request-Set Last Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Status_Draft</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Status Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Status_Submitted</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Set Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Uncheck_RVP_Flag</fullName>
        <field>ASI_CRM_CN_RVP_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ASI CRM CN Uncheck RVP Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Uncheck_Return_Flag</fullName>
        <field>ASI_CRM_CN_Return_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Return Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_MY_Update_Region_PaymentRequest</fullName>
        <field>ASI_CRM_Branch__c</field>
        <formula>ASI_CRM_CN_OutletWS__r.ASI_CRM_MY_Branch__c</formula>
        <name>ASI_CRM_MY_Update_Region_PaymentRequest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Next_Approver_1</fullName>
        <field>ASI_CRM_Next_Approver__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>ASI CRM Next Approver 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Lock_Payment_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_SG_Payment_Request_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM SG - Lock Payment Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Payment_Allow_To_Submit_False</fullName>
        <field>ASI_CRM_Sys_Allow_Submit_Approval__c</field>
        <literalValue>0</literalValue>
        <name>ASI CRM SG Payment Allow To Submit False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Recall_Status</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Recall Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Unlock_Payment_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_SG_Payment_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM SG - Unlock Payment Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Update_G_L_Date</fullName>
        <field>ASI_TH_CRM_GL_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update G/L Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_Payment_Request_Status_Approved</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI SG - Payment Request Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_Payment_Request_Status_Rejected</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>ASI SG - Payment Request Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_Payment_Request_Status_Submitted</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI SG -Payment Request Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_CopyDeliveryAddress</fullName>
        <field>ASI_TH_CRM_DeliveryAddress__c</field>
        <formula>ASI_TH_CRM_Contract__r.ASI_TH_CRM_Outlet__r.ASI_HK_CRM_Address__c</formula>
        <name>ASI_TH_CRM_CopyDeliveryAddress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRApproved</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI_TH_CRM_PRApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRPendingFD</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Pending Head of Finance and Operations</literalValue>
        <name>ASI_TH_CRM_PRPendingFD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRPendingMD</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Pending Managing Director</literalValue>
        <name>ASI_TH_CRM_PRPendingMD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRPendingPRACHM</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Pending PRA Chairman</literalValue>
        <name>ASI_TH_CRM_PRPendingPRACHM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRPendingRSM</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Pending Regional Sales Manager</literalValue>
        <name>ASI_TH_CRM_PRPendingRSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRPendingSD</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Pending Head of National On Trade</literalValue>
        <name>ASI_TH_CRM_PRPendingSD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRReadyForApproval</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Ready for Approval</literalValue>
        <name>ASI_TH_CRM_PRReadyForApproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRRejected</fullName>
        <field>ASI_TH_CRM_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>ASI_TH_CRM_PRRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_TH_CRM_PRUncheckReady</fullName>
        <field>ASI_TH_CRM_Ready_for_Approval__c</field>
        <literalValue>0</literalValue>
        <name>ASI_TH_CRM_PRUncheckReady</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI CRM CN Pmt Req Send Reject Email to RBA</fullName>
        <actions>
            <name>ASI_CRM_CN_Heavy_Payment_Request_Rejected_Email_Alert_RBA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_CN_Uncheck_RVP_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>ASI_TH_CRM_PaymentRequest__c.ASI_CRM_CN_RVP_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>VP</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>Director</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM SG Payment Request Approved To Draft</fullName>
        <actions>
            <name>ASI_CRM_SG_Payment_Request_Finance_Reject_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_SG_Unlock_Payment_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>20170105 Wilken: Include Rejected status for Finance reject</description>
        <formula>AND (      RecordType.DeveloperName = &apos;ASI_CRM_SG_Payment_Request_Read_Only&apos;,      ISPICKVAL(PRIORVALUE( ASI_TH_CRM_Status__c ), &apos;Approved&apos;),      OR ( 		ISPICKVAL(ASI_TH_CRM_Status__c, &apos;Draft&apos;), 		ISPICKVAL(ASI_TH_CRM_Status__c, &apos;Rejected&apos;) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Send_Auto_Modi_Email</fullName>
        <actions>
            <name>ASI_CRM_CN_Heavy_Payment_Request_Paid_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>ASI CRM CN Send Auto Modi Email</description>
        <formula>ISPICKVAL(ASI_TH_CRM_Status__c , &quot;Paid&quot;) &amp;&amp; ISPICKVAL(PRIORVALUE( ASI_TH_CRM_Status__c ), &quot;Approved&quot;) &amp;&amp; ( CONTAINS(RecordType.DeveloperName, &quot;ASI_CRM_CN_Payment_Request&quot;))&amp;&amp; ASI_CRM_CN_Last_Payment__c &amp;&amp; ASI_CRM_CN_Promotion_Type__c ==&apos;Heavy Contract On&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_MY_Update_Region_PaymentRequest</fullName>
        <actions>
            <name>ASI_CRM_MY_Update_Region_PaymentRequest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_TH_CRM_PaymentRequest__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI CRM MY Payment Request</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_TH_CRM_AssignInitialValues</fullName>
        <actions>
            <name>ASI_TH_CRM_CopyDeliveryAddress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_TH_CRM_PaymentRequest__c.ASI_TH_CRM_Outlet__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_TH_CRM_PaymentRequest__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI TH CRM Payment Request</value>
        </criteriaItems>
        <description>Copy Delivery Address to Payment Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI_TH_CRM_PRReadyForApproval</fullName>
        <actions>
            <name>ASI_TH_CRM_PRReadyForApproval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_TH_CRM_PaymentRequest__c.ASI_TH_CRM_Ready_for_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_TH_CRM_PaymentRequest__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI TH CRM Payment Request</value>
        </criteriaItems>
        <description>Update Payment Request Status once user check Ready for Approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>