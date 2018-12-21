<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_CN_Contract_Approved_Email_Alert</fullName>
        <ccEmails>prc.tradecontract@pernod-ricard.com</ccEmails>
        <description>ASI_CRM_CN_Contract_Approved_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Contract_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Contract_Rejected_Email_Alert</fullName>
        <ccEmails>prc.tradecontract@pernod-ricard.com</ccEmails>
        <description>ASI_CRM_CN_Contract_Rejected_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Contract_Rejected_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_HeavyContract_Approved_Email_Alert</fullName>
        <ccEmails>prc.tradecontract@pernod-ricard.com</ccEmails>
        <description>ASI_CRM_CN_HeavyContract_Approved_Email_Alert﻿</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Contract_ApprovedEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_HeavyContract_Rejected_Email_Alert</fullName>
        <description>ASI_CRM_CN_HeavyContract_Rejected_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Contract_RejectedEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_HeavyContract_Rejected_RBA_Email_Alert</fullName>
        <description>ASI_CRM_CN_HeavyContract_Rejected_RBA_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Last_RBA_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Contract_RejectedEmail</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_Final_Email_Alert</fullName>
        <description>ASI_CRM_CN_Heavy_Final_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Contract_Final_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_LGC_Approved_Email_Alert</fullName>
        <ccEmails>prc.tradecontract@pernod-ricard.com</ccEmails>
        <description>ASI CRM CN Heavy Local Group Contract Approved Email Alert﻿</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_LGC_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Heavy_Local_Group_Contract_Rejected_Email_Alert</fullName>
        <description>ASI CRM CN Heavy Local Group Contract Rejected Email Alert﻿</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_LGC_Rejected_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Uncheck_Upload_Completion_Email_Alert</fullName>
        <description>ASI_CRM_CN_Uncheck_Upload_Completion_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_Heavy_Contract_UUC_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_CN_Upload_Completion_Email_Alert</fullName>
        <description>ASI_CRM_CN_Upload_Completion_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_Last_RBA_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_HeavyContractUploadComplete</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_MO_Contract_Approval_Email_Alert</fullName>
        <description>ASI_CRM_MO_Contract_Approval_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_11__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_CN_Return_Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_MO_Email_Template/ASI_CRM_MO_Contracts_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_MO_Contract_Approved_Email_Alert</fullName>
        <ccEmails>axel.leung@introv.com</ccEmails>
        <ccEmails>daniel.wong@introv.com</ccEmails>
        <description>ASI_CRM_MO_Contract_Approved_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_MO_Email_Template/ASI_CRM_MO_Contracts_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_MO_Contract_Rejected_Email_Alert</fullName>
        <ccEmails>axel.leung@introv.com</ccEmails>
        <ccEmails>daniel.wong@introv.com</ccEmails>
        <description>ASI_CRM_MO_Contract_Rejected_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_MO_Email_Template/ASI_CRM_MO_Contracts_Rejected_Email</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Contract_End_Alert_30</fullName>
        <description>ASI CRM SG Contract End Alert (30)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_End_Alert_30_HTML_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Contract_End_Alert_60</fullName>
        <description>ASI CRM SG Contract End Alert (60)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pra.sfdcitsupport@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_End_Alert_60_HTML_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Contract_Rejection_Notification_Email</fullName>
        <description>Contract Rejection Notification Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_Rejection_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Group_Director_Approval_Email_Alert</fullName>
        <description>ASI_CRM_SG_Group_Director_Approval_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Managing_Director_Approval_Email_Alert</fullName>
        <description>ASI_CRM_SG_Managing_Director_Approval_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Marketing_Approval_Email_Alert</fullName>
        <description>Marketing Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Sales_Director_Approval_Email_Alert</fullName>
        <description>ASI_CRM_SG_Sales_Director_Approval_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_Approval_Notification_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_CRM_SG_Sales_Manager_Approval_Email_Alert</fullName>
        <description>ASI_CRM_SG_Sales_Manager_Approval_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_SG_Template/ASI_CRM_SG_Contract_Approval_Notification_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_CN_Contract_Status_Approved</fullName>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ASI CN - Contract Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Contract_Copy_Division_Code</fullName>
        <field>ASI_CRM_CN_Division_Code__c</field>
        <formula>ASI_CRM_CN_Outlet_WS__r.ASI_CRM_CN_CCity__r.ASI_CRM_CN_Area__r.ASI_CRM_Division__r.ASI_CRM_Division_Code__c</formula>
        <name>ASI CRM CN Contract Copy Division Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Contract_Set_RVP_Flag</fullName>
        <field>ASI_CRM_CN_RVP_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Contract - Set RVP Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Contract_Uncheck_RVP_Flag</fullName>
        <field>ASI_CRM_CN_RVP_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Contract - Uncheck RVP Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Heavy_LGC_set_RT_to_Approved</fullName>
        <description>ASI CRM CN Heavy Local Group Contract set Record Type to ASI_CRM_CN_Local_Group_Contract_Approved</description>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_CN_Local_Group_Contract_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM CN Heavy LGC set RT to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Approved</fullName>
        <description>(CN-CRM) Contract - Set Appr Status - Approved</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Contract - Set Appr Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Draft</fullName>
        <description>(CN-CRM) Contract - Set Appr Status - Draft</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Contract - Set Appr Status - Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Recall</fullName>
        <description>(CN-CRM) Contract - Set Appr Status - Recall</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Contract - Set Appr Status - Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Rejected</fullName>
        <description>(CN-CRM) Contract - Set Appr Status - Rejected</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Contract - Set Appr Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_AP_Status_Submitted</fullName>
        <description>(CN-CRM) Contract - Set Appr Status - Submitted</description>
        <field>ASI_CRM_CN_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Contract - Set Appr Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Approved_By</fullName>
        <description>(CN-CRM) Contract - Set Last Approved By</description>
        <field>ASI_CRM_CN_Last_Approved_By__c</field>
        <formula>$User.FirstName + &quot; &quot; +  $User.LastName</formula>
        <name>Contract - Set Last Approved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Approved_Date</fullName>
        <field>ASI_CRM_CN_Last_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>Contract - Set Last Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Recall_By</fullName>
        <description>(CN-CRM) Contract - Set Last Recall By</description>
        <field>ASI_CRM_CN_Last_Recall_By__c</field>
        <formula>$User.FirstName + &quot; &quot; +  $User.LastName</formula>
        <name>Contract - Set Last Recall By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Recall_Date</fullName>
        <description>(CN-CRM) Contract - Set Last Recall Date</description>
        <field>ASI_CRM_CN_Last_Recall_Date__c</field>
        <formula>NOW()</formula>
        <name>Contract - Set Last Recall Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Rejected_By</fullName>
        <description>(CN-CRM) Contract - Set Last Rejected By</description>
        <field>ASI_CRM_CN_Last_Rejected_By__c</field>
        <formula>$User.FirstName + &quot; &quot; +  $User.LastName</formula>
        <name>Contract - Set Last Rejected By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Rejected_Date</fullName>
        <description>(CN-CRM) Contract - Set Last Rejected Date</description>
        <field>ASI_CRM_CN_Last_Rejected_Date__c</field>
        <formula>NOW()</formula>
        <name>Contract - Set Last Rejected Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Submitted_By</fullName>
        <description>(CN-CRM) Contract - Set Last Submitted By</description>
        <field>ASI_CRM_CN_Last_Submitted_By__c</field>
        <formula>$User.FirstName + &quot; &quot; +  $User.LastName</formula>
        <name>Contract - Set Last Submitted By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Last_Submitted_Date</fullName>
        <description>(CN-CRM) Contract - Set Last Submitted Date</description>
        <field>ASI_CRM_CN_Last_Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>Contract - Set Last Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Status_Draft</fullName>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Status Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Status_Final</fullName>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Final</literalValue>
        <name>Set Status Final</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Set_Status_Submitted</fullName>
        <field>ASI_CRM_CN_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Set Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_CN_Uncheck_PO_Modification</fullName>
        <field>ASI_CRM_CN_PO_Modification__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck PO Modification</name>
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
        <fullName>ASI_CRM_CN_Uncheck_Upload_Completion</fullName>
        <field>ASI_CRM_CN_Contract_Upload__c</field>
        <literalValue>0</literalValue>
        <name>CN Uncheck Upload Completion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_MY_Update_Region_Contract</fullName>
        <field>ASI_CRM_Branch__c</field>
        <formula>ASI_CRM_CN_Outlet_WS__r.ASI_CRM_MY_Branch__c</formula>
        <name>ASI_CRM_MY_Update_Region_Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Alerted_30_Days_True</fullName>
        <field>ASI_CRM_Alerted_30_Days_Before_End__c</field>
        <literalValue>1</literalValue>
        <name>ASI CRM SG Alerted (30 Days) True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Alerted_60_Days_True</fullName>
        <field>ASI_CRM_Alerted_60_Days_Before_End__c</field>
        <literalValue>1</literalValue>
        <name>ASI CRM SG Alerted (60 Days) True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Contract_AllowToSubmit_False</fullName>
        <field>ASI_CRM_Sys_Allow_Submit_Approval__c</field>
        <literalValue>0</literalValue>
        <name>ASI CRM SG Contract AllowToSubmit False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Contract_Editable</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_SG_Contract</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM SG Contract Editable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Editable_Proposal</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_SG_Proposal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM SG Editable Proposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Proposal_Status_Approved</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Proposal Approved</literalValue>
        <name>ASI CRM SG Proposal Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Proposal_Status_Rejected</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Proposal Rejected</literalValue>
        <name>ASI CRM SG Proposal Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Read_Only_Contract</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_SG_Contract_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM SG Read Only Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Read_Only_Proposal</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_CRM_SG_Proposal_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI CRM SG Read Only Proposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Early_Completed</fullName>
        <field>ASI_CRM_Early_Contract_Completed__c</field>
        <literalValue>1</literalValue>
        <name>ASI_CRM_SG_Set_Early_Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Extended</fullName>
        <field>ASI_CRM_Contract_Period_Extended__c</field>
        <literalValue>1</literalValue>
        <name>ASI CRM SG Set Extended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Original_End_Date</fullName>
        <field>ASI_TH_CRM_End_Date__c</field>
        <formula>ASI_CRM_End_Date_Original__c</formula>
        <name>ASI CRM SG Set Original End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Recall_Status</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Recall Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Req_To_Complete_False</fullName>
        <field>ASI_CRM_Requesting_To_Complete__c</field>
        <literalValue>0</literalValue>
        <name>ASI CRM SG Set Req To Complete False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Set_Req_To_Extend_False</fullName>
        <field>ASI_CRM_Contract_Period_Req_To_Extend__c</field>
        <literalValue>0</literalValue>
        <name>ASI CRM SG Set Req To Extend False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_SG_Update_Contract_Status_Field</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI CRM SG Update Contract Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Set_Contract_Status_Draft</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>ASI CRM Set Contract Status Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Set_Contract_Status_Final</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Final</literalValue>
        <name>ASI CRM Set Contract Status Final</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_CRM_Update_Contract_Status_Submitted</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>ASI_CRM_Update_Contract_Status_Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_CRM_Increment_Version_Number</fullName>
        <field>ASI_CRM_Version__c</field>
        <formula>IF(
    ISBLANK(ASI_CRM_Version__c ), &quot;1&quot;, 
    TEXT(VALUE( ASI_CRM_Version__c ) + 1)
)</formula>
        <name>ASI SG CRM Increment Version Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_Contract_Status_Approved</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Contract Approved</literalValue>
        <name>ASI SG - Contract Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_Contract_Status_Completed</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>ASI SG - Contract Status Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_SG_Contract_Status_Rejected</fullName>
        <field>ASI_TH_CRM_Contract_Status__c</field>
        <literalValue>Contract Rejected</literalValue>
        <name>ASI SG - Contract Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI CRM CN Send Reject Email to RBA</fullName>
        <actions>
            <name>ASI_CRM_CN_HeavyContract_Rejected_RBA_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_CRM_CN_Contract_Uncheck_RVP_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 2) OR (2 AND 3) ) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>VP</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_TH_CRM_Contract__c.ASI_CRM_CN_RVP_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>contains</operation>
            <value>Director</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_TH_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CN Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_TH_CRM_Contract__c.ASI_TH_CRM_Promotion_Type__c</field>
            <operation>equals</operation>
            <value>Heavy Contract On</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CRM SG Contract End Alert %2830 Days%29</fullName>
        <active>true</active>
        <formula>AND (   RecordType.DeveloperName = &apos;ASI_CRM_SG_Contract_Read_Only&apos;,    ISPICKVAL(ASI_TH_CRM_Contract_Status__c, &apos;Contract Approved&apos;),   NOT(ASI_CRM_Alerted_30_Days_Before_End__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_CRM_SG_Contract_End_Alert_30</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>ASI_CRM_SG_Alerted_30_Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ASI_TH_CRM_Contract__c.ASI_TH_CRM_End_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI CRM SG Contract End Alert %2860 Days%29</fullName>
        <active>true</active>
        <formula>AND (   RecordType.DeveloperName = &apos;ASI_CRM_SG_Contract_Read_Only&apos;,    ISPICKVAL(ASI_TH_CRM_Contract_Status__c, &apos;Contract Approved&apos;),   NOT(ASI_CRM_Alerted_60_Days_Before_End__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_CRM_SG_Contract_End_Alert_60</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>ASI_CRM_SG_Alerted_60_Days_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ASI_TH_CRM_Contract__c.ASI_TH_CRM_End_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI CRM SG Editable Contract</fullName>
        <actions>
            <name>ASI_CRM_SG_Contract_Editable</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_SG_CRM_Increment_Version_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  ISCHANGED(ASI_TH_CRM_Contract_Status__c), NOT(ISNULL(PRIORVALUE(ASI_TH_CRM_Contract_Status__c))),  ISPICKVAL(ASI_TH_CRM_Contract_Status__c, &apos;Draft&apos;) , CONTAINS(RecordType.DeveloperName,&apos;ASI_CRM_SG&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Heavy_Final_Email_Workflow</fullName>
        <actions>
            <name>ASI_CRM_CN_Heavy_Final_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(ASI_CRM_CN_Status__c , &apos;Final&apos;), ISPICKVAL(PRIORVALUE( ASI_CRM_CN_Status__c ), &apos;Approved&apos;),RecordType.DeveloperName=&apos;ASI_CRM_CN_Contract&apos;,TEXT(ASI_TH_CRM_Promotion_Type__c) = &quot;Heavy Contract On&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Uncheck_Upload_Completion_Email_Workflow</fullName>
        <actions>
            <name>ASI_CRM_CN_Uncheck_Upload_Completion_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( !ASI_CRM_CN_Contract_Upload__c ,PRIORVALUE(ASI_CRM_CN_Contract_Upload__c),RecordType.DeveloperName=&apos;ASI_CRM_CN_Contract&apos;,  TEXT(ASI_TH_CRM_Promotion_Type__c) = &quot;Heavy Contract On&quot;,ASI_CRM_CN_PO_Version__c==&apos;0.0&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_Upload_Completion_Email_Workflow</fullName>
        <actions>
            <name>ASI_CRM_CN_Upload_Completion_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ASI_CRM_CN_Contract_Upload__c ,!PRIORVALUE(ASI_CRM_CN_Contract_Upload__c),RecordType.DeveloperName=&apos;ASI_CRM_CN_Contract&apos;,  TEXT(ASI_TH_CRM_Promotion_Type__c) = &quot;Heavy Contract On&quot;,ASI_CRM_CN_PO_Version__c==&apos;0.0&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_MY_Update_Region_Contract</fullName>
        <actions>
            <name>ASI_CRM_MY_Update_Region_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_TH_CRM_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI CRM MY Contract</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AS_CRM_SG_Early_Complete_Contract_Checkbox</fullName>
        <actions>
            <name>ASI_CRM_SG_Set_Early_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( 	CONTAINS(RecordType.DeveloperName , &quot;ASI_CRM_SG&quot;), 	ISPICKVAL(PRIORVALUE(ASI_TH_CRM_Contract_Status__c), &quot;Submitted&quot;), 	ISPICKVAL(ASI_TH_CRM_Contract_Status__c, &quot;Contract Approved&quot;), 	PRIORVALUE(ASI_CRM_Contract_Period_Req_To_Extend__c) = true, 	ASI_TH_CRM_End_Date__c &lt;  ASI_CRM_End_Date_Original__c    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AS_CRM_SG_Extend_Contract_Checkbox</fullName>
        <actions>
            <name>ASI_CRM_SG_Set_Extended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( 	CONTAINS(RecordType.DeveloperName , &quot;ASI_CRM_SG&quot;), 	ISPICKVAL(PRIORVALUE(ASI_TH_CRM_Contract_Status__c), &quot;Submitted&quot;), 	ISPICKVAL(ASI_TH_CRM_Contract_Status__c, &quot;Contract Approved&quot;), 	PRIORVALUE(ASI_CRM_Contract_Period_Req_To_Extend__c) = true, 	ASI_TH_CRM_End_Date__c &gt;  ASI_CRM_End_Date_Original__c    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
