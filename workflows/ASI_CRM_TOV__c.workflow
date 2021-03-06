<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CRM_CN_TOV_Relased_Noti</fullName>
        <description>CN TOV Relased Noti</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CRM_CN_TOVNotification_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>patrick.yan@pernod-ricard.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>ASI_CRM_SF_SO_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CRM_CN_Email_Templates/ASI_CRM_CN_TOV_Relased_Noti</template>
    </alerts>
    <rules>
        <fullName>ASI_CRM_CN_TOV_Hold_Noti</fullName>
        <actions>
            <name>ASI_CRM_CN_TOV_Relased_Noti</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_TOV__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CN TOV</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_TOV__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Hold,Held</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_TOV__c.ASI_CRM_Total_Number_of_Line__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_CRM_CN_TOV_Released_Noti</fullName>
        <actions>
            <name>ASI_CRM_CN_TOV_Relased_Noti</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CRM_TOV__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CN TOV</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_TOV__c.ASI_CRM_Status__c</field>
            <operation>equals</operation>
            <value>Released</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CRM_TOV__c.ASI_CRM_Total_Number_of_Line__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
