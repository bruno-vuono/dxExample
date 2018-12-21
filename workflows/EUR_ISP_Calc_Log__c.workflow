<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EUR_ISP_DE_Calculation_Log</fullName>
        <ccEmails>stefano.iannilli@parx.com</ccEmails>
        <ccEmails>therese.ordell@parx.com</ccEmails>
        <description>EUR_ISP_DE_Calculation_Log</description>
        <protected>false</protected>
        <recipients>
            <recipient>philipp.hoffmann@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.robinson@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EUR_ISP_Email_Templates/EUR_ISP_DE_Calculation_Log_Template</template>
    </alerts>
    <rules>
        <fullName>EUR_ISP_DE_Calculation_Log</fullName>
        <actions>
            <name>EUR_ISP_DE_Calculation_Log</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EUR_ISP_Calc_Log__c.EUR_ISP_Country_Code__c</field>
            <operation>equals</operation>
            <value>DE</value>
        </criteriaItems>
        <description>Will send an email to Stephen Robinson &amp; Philipp Hoffman if some &quot;calculation engine error&quot; appears</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
