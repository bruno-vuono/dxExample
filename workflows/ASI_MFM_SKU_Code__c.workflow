<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_CN_SKUCreationEmail</fullName>
        <description>ASI_CRM_CN_SKUCreationEmail</description>
        <protected>false</protected>
        <recipients>
            <recipient>patrick.yan@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>philip.zhou@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sandy.yang@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_SKU_CreationEmail</template>
    </alerts>
    <rules>
        <fullName>ASI_CRM_CN_SKUcreationEmail</fullName>
        <actions>
            <name>ASI_CRM_CN_SKUCreationEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_MFM_SKU_Code__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CN FOC SKU</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
