<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ESN_BP_News_Check_Active</fullName>
        <field>ESN_BP_News_Active__c</field>
        <literalValue>1</literalValue>
        <name>ESN_BP_News_Check_Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESN_BP_News_Uncheck_Active</fullName>
        <description>Uncheck Active checkbox</description>
        <field>ESN_BP_News_Active__c</field>
        <literalValue>0</literalValue>
        <name>ESN_BP_News_Uncheck_Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ESN_BP_News_Activate</fullName>
        <actions>
            <name>ESN_BP_News_Check_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ESN_BP_News_Starting_Date__c &lt;  NOW(),ESN_BP_News_Ending_Date__c &gt; NOW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ESN_BP_News_Deactivate</fullName>
        <actions>
            <name>ESN_BP_News_Uncheck_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ESN_BP_News_Ending_Date__c  &lt;  NOW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ESN_BP_News_Future_Activation</fullName>
        <active>true</active>
        <formula>ESN_BP_News_Starting_Date__c &gt;  NOW()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>ESN_BP_News__c.ESN_BP_News_Ending_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>ESN_BP_News_Check_Active</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ESN_BP_News__c.ESN_BP_News_Starting_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ESN_BP_News_Future_Deactivation</fullName>
        <active>true</active>
        <formula>ESN_BP_News_Ending_Date__c  &gt;  NOW()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ESN_BP_News_Uncheck_Active</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ESN_BP_News__c.ESN_BP_News_Ending_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>