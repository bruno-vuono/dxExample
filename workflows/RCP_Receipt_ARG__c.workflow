<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LAT_AR_RCP_SendsMail</fullName>
        <description>LAT_AR_RCP_SendsMail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LAT_AR_Templates/LAT_AR_ReceiptsRejectedTreasury</template>
    </alerts>
    <fieldUpdates>
        <fullName>LAT_AR_RCP_AmountUpdateWithRU</fullName>
        <field>AmountsControl_AR__c</field>
        <formula>IF(ISNULL(LAT_AR_DocumentsAmountWithRU__c),0,LAT_AR_DocumentsAmountWithRU__c) 
+ 
IF(ISNULL(Downpayments_AR__c),0,Downpayments_AR__c) 
- 
IF(ISNULL(Discount_AR__c),0,Discount_AR__c) 
- 
IF(ISNULL(Debit_AR__c),0,Debit_AR__c )</formula>
        <name>LAT_AR_RCP_AmountUpdateWithRU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_AR_RCP_UpdatesSendMailToFalse</fullName>
        <description>Sets to false the field LAT_AR_SendMail__c</description>
        <field>LAT_AR_SendMail__c</field>
        <literalValue>0</literalValue>
        <name>LAT_AR_RCP_UpdatesSendMailToFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RCP_AmountUpdate_AR</fullName>
        <field>AmountsControl_AR__c</field>
        <formula>IF(ValuesAmount_AR__c= 0, 
IF (ISNULL(DocumentsAmount_AR__c) , 0 , DocumentsAmount_AR__c) - IF (ISNULL(DepositsAmount_AR__c) , 0 , DepositsAmount_AR__c) - IF (ISNULL(WithholdingsAmount_AR__c) , 0 , WithholdingsAmount_AR__c) + 
IF (ISNULL(Downpayments_AR__c) , 0 , Downpayments_AR__c) - IF (ISNULL(Discount_AR__c) , 0 , Discount_AR__c) - IF (ISNULL(Debit_AR__c) , 0 , Debit_AR__c), 
IF( DepositsAmount_AR__c = 0, 
IF (ISNULL(DocumentsAmount_AR__c) , 0 , DocumentsAmount_AR__c) - IF (ISNULL(ValuesAmount_AR__c) , 0 , ValuesAmount_AR__c) - IF (ISNULL(WithholdingsAmount_AR__c) , 0 , WithholdingsAmount_AR__c) + IF (ISNULL(Downpayments_AR__c) , 0 , Downpayments_AR__c) - IF (ISNULL(Discount_AR__c) , 0 , Discount_AR__c) - IF (ISNULL(Debit_AR__c) , 0 , Debit_AR__c) , 
IF (ISNULL(DocumentsAmount_AR__c) , 0 , DocumentsAmount_AR__c) - IF (ISNULL(DepositsAmount_AR__c) , 0 , DepositsAmount_AR__c) - IF (ISNULL(WithholdingsAmount_AR__c) , 0 , WithholdingsAmount_AR__c) + IF (ISNULL(Downpayments_AR__c) , 0 , Downpayments_AR__c) - IF (ISNULL(Discount_AR__c) , 0 , Discount_AR__c) 
- IF (ISNULL(Debit_AR__c) , 0 , Debit_AR__c) + IF (ISNULL(ValuesAmount_AR__c) , 0 , ValuesAmount_AR__c) - IF (ISNULL(DepositsAmount_AR__c) , 0 , DepositsAmount_AR__c) ) )</formula>
        <name>RCP_AmountUpdate_AR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LAT_AR_RCP_WF01_SendEmail</fullName>
        <actions>
            <name>LAT_AR_RCP_SendsMail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LAT_AR_RCP_UpdatesSendMailToFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>LAT_AR_SendMail__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LAT_AR_RCP_WF02_AmountFormulaWithRU</fullName>
        <actions>
            <name>LAT_AR_RCP_AmountUpdateWithRU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RCP_Receipt_ARG__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>AR Receipt of Applying Documents</value>
        </criteriaItems>
        <description>Amount Formula With &quot;RU&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RCP_WF01_AmountFormula_AR</fullName>
        <actions>
            <name>RCP_AmountUpdate_AR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RCP_Receipt_ARG__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>AR Receipt of Applying Documents</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
