<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_NPP_Approval_Approved_To_Owner</fullName>
        <description>ASI_NPP_Approval_Approved_To_Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approved_Template_PO</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Approval_Approved_to_Finance</fullName>
        <description>ASI_NPP_Approval_Approved_To_Finance</description>
        <protected>false</protected>
        <recipients>
            <recipient>eddie.lee@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Approval_Approved_to_Logistic</fullName>
        <description>ASI_NPP_Approval_Approved_To_Logistic</description>
        <protected>false</protected>
        <recipients>
            <recipient>winnie.chong@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approved_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Approval_Rejected</fullName>
        <description>ASI_NPP_Approval_Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Rejected_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Approval_Request</fullName>
        <description>ASI_NPP_Approval_Request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Notify_Ops_BA_Complete</fullName>
        <description>ASI_NPP_Notify_Ops_BA_Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>lionel.hoh@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.son@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>winnie.chong@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>ASI_NPP_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Completed_Ops</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Send_Approval_Reminider1</fullName>
        <description>ASI_NPP_Send_Approval_Reminider1</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_NPP_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Send_Approval_Reminider2</fullName>
        <description>ASI_NPP_Send_Approval_Reminider2</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_NPP_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Send_Approval_Reminider3</fullName>
        <description>ASI_NPP_Send_Approval_Reminider3</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Send_Approval_Reminider4</fullName>
        <description>ASI_NPP_Send_Approval_Reminider4</description>
        <protected>false</protected>
        <recipients>
            <field>ASI_NPP_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approval_Template</template>
    </alerts>
    <alerts>
        <fullName>ASI_NPP_Send_Approval_Reminider5</fullName>
        <description>ASI_NPP_Send_Approval_Reminider5</description>
        <protected>false</protected>
        <recipients>
            <recipient>wilken.lee@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_NPP_Email_Folder/ASI_NPP_SG_Approval_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASI_NPP_Draft</fullName>
        <field>ASI_NPP_status__c</field>
        <literalValue>Draft</literalValue>
        <name>ASI_NPP_Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Finaled</fullName>
        <field>ASI_NPP_status__c</field>
        <literalValue>Final</literalValue>
        <name>ASI_NPP_Finaled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Reset_Approved_Level</fullName>
        <field>ASI_NPP_Approved_Level__c</field>
        <formula>0</formula>
        <name>ASI_NPP_Reset_Approved_Level</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_SG_Status_Complete</fullName>
        <field>ASI_NPP_status__c</field>
        <literalValue>Complete</literalValue>
        <name>ASI_NPP_SG_Status_Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder1_Start</fullName>
        <description>Trigger the workflow to send reminder email</description>
        <field>ASI_NPP_Approval_Step_1__c</field>
        <formula>1</formula>
        <name>ASI_NPP_Send_Approval_Reminder1_Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder1_Stop</fullName>
        <field>ASI_NPP_Approval_Step_1__c</field>
        <formula>0</formula>
        <name>ASI_NPP_Send_Approval_Reminder1_Stop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder2_Start</fullName>
        <description>Trigger the workflow rule to send reminder email</description>
        <field>ASI_NPP_Approval_Step_2__c</field>
        <formula>1</formula>
        <name>ASI_NPP_Send_Approval_Reminder2_Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder2_Stop</fullName>
        <field>ASI_NPP_Approval_Step_2__c</field>
        <formula>0</formula>
        <name>ASI_NPP_Send_Approval_Reminder2_Stop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder3_Start</fullName>
        <description>Send approval reminder to Approval 3</description>
        <field>ASI_NPP_Approval_Step_3__c</field>
        <formula>1</formula>
        <name>ASI_NPP_Send_Approval_Reminder3_Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder3_Stop</fullName>
        <description>Stop the approval reminder for approver 3</description>
        <field>ASI_NPP_Approval_Step_3__c</field>
        <formula>0</formula>
        <name>ASI_NPP_Send_Approval_Reminder3_Stop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder4_Start</fullName>
        <field>ASI_NPP_Approval_Step_4__c</field>
        <formula>1</formula>
        <name>ASI_NPP_Send_Approval_Reminder4_Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder4_Stop</fullName>
        <field>ASI_NPP_Approval_Step_4__c</field>
        <formula>0</formula>
        <name>ASI_NPP_Send_Approval_Reminder4_Stop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder5_Start</fullName>
        <field>ASI_NPP_Approval_Step_5__c</field>
        <formula>1</formula>
        <name>ASI_NPP_Send_Approval_Reminder5_Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Send_Approval_Reminder5_Stop</fullName>
        <field>ASI_NPP_Approval_Step_5__c</field>
        <formula>0</formula>
        <name>ASI_NPP_Send_Approval_Reminder5_Stop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Set_Approved_Level_1</fullName>
        <field>ASI_NPP_Approved_Level__c</field>
        <formula>1</formula>
        <name>ASI_NPP_Set_Approved_Level_1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Set_Approved_Level_2</fullName>
        <field>ASI_NPP_Approved_Level__c</field>
        <formula>2</formula>
        <name>ASI_NPP_Set_Approved_Level_2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Set_Approved_Level_3</fullName>
        <field>ASI_NPP_Approved_Level__c</field>
        <formula>3</formula>
        <name>ASI_NPP_Set_Approved_Level_3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_NPP_Submited</fullName>
        <field>ASI_NPP_status__c</field>
        <literalValue>Submitted</literalValue>
        <name>ASI_NPP_Submited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ASI_NPP_CompleteNotifyAndUpdate</fullName>
        <actions>
            <name>ASI_NPP_Notify_Ops_BA_Complete</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ASI_NPP_SG_Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( 	CONTAINS( RecordType.DeveloperName , &quot;ASI_NPP_SG&quot;),   	OR ( 		NOT(ISBLANK( ASI_NPP_PO_Number__c )),  		NOT(ISBLANK(  ASI_NPP_MCF_PO__c )) 	),  	NOT(ISBLANK( ASI_NPP_Brand_Company_VAP__c )),  	OR ( 		ISCHANGED(ASI_NPP_PO_Number__c ), 		ISCHANGED(ASI_NPP_MCF_PO__c ) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ASI_NPP_Send_Approval_Reminder1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SG New Product or Promotion</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Approved_Level__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider1</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider1</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider1</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI_NPP_Send_Approval_Reminder2</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SG New Product or Promotion</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Approved_Level__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Send Approval Reminder to Approver 2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider2</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider2</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider2</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI_NPP_Send_Approval_Reminder3</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SG New Product or Promotion</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Approved_Level__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Market__c</field>
            <operation>equals</operation>
            <value>Singapore</value>
        </criteriaItems>
        <description>For Singapore Market: Send reminder to NPA Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider3</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider3</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider3</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI_NPP_Send_Approval_Reminder4</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SG New Product or Promotion</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Approved_Level__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Market__c</field>
            <operation>notEqual</operation>
            <value>Singapore</value>
        </criteriaItems>
        <description>Non-Singapore Market: Reminder send to Approver 3</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider4</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider4</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider4</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ASI_NPP_Send_Approval_Reminder5</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ASI_NPP_New_Product_Promotion__c.ASI_NPP_Approval_Step_5__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Obsolete Workflow Rule: NPA only have 3 levels approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider5</name>
                <type>Alert</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider5</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminider5</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>ASI_NPP_Send_Approval_Reminder5_Stop</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
