<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MMPJ_Ext_Vign_Notification</fullName>
        <description>MMPJ_Ext_Vign_Notification</description>
        <protected>false</protected>
        <recipients>
            <field>MMPJ_Ext_Vign_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>partners-mmpj@pernod-ricard.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>MMPJ_Ext_Vign/MMPJ_Ext_Vign_Notification</template>
    </alerts>
    <alerts>
        <fullName>MMPJ_Ext_Vign_Notification_Message_Champ</fullName>
        <description>MMPJ_Ext_Vign_Notification_Message_Champ</description>
        <protected>false</protected>
        <recipients>
            <recipient>MMPJ_Ext_Vign_Admins_Fonctionnels_Champ</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MMPJ_Ext_Vign/MMPJ_Ext_Vign_Nouveau_Message</template>
    </alerts>
    <alerts>
        <fullName>MMPJ_Ext_Vign_Notification_Message_Cognac</fullName>
        <description>MMPJ_Ext_Vign_Notification_Message_Cognac</description>
        <protected>false</protected>
        <recipients>
            <recipient>MMPJ_Ext_Vign_Admins_Fonctionnels_Cognac</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MMPJ_Ext_Vign/MMPJ_Ext_Vign_Nouveau_Message</template>
    </alerts>
    <rules>
        <fullName>MMPJ_Ext_Vign_Notification</fullName>
        <actions>
            <name>MMPJ_Ext_Vign_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Gère l&apos;envoi des notification emails aux contacts</description>
        <formula>OR( 	AND(  		MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Nouvelle_facture__c,  		OR(  			ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Facture&quot;),  			ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Facture d&apos;approvisionnement&quot;),  			ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Facture d&apos;enlèvement&quot;),  			ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Facture de pressurage et vinification&quot;),  			ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Facture prestation de services&quot;)  		)  	), 	AND( 		MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Nouvel_Audit__c,  		ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Audit&quot;) 	), 	AND( 		MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Nouvelle_analyse__c,  		ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Analyse&quot;) 	), 	AND( 		MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Nouvelle_invitation__c,  		ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Invitation&quot;) 	), 	AND( 		MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Nouveau_Brouillon_Declarat__c,  		ISPICKVAL( MMPJ_Ext_Vign_Type__c ,&quot;Brouillon de déclaration de récolte&quot;) 	) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MMPJ_Ext_Vign_Notification_Message_Champ</fullName>
        <actions>
            <name>MMPJ_Ext_Vign_Notification_Message_Champ</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 	ISPICKVAL(MMPJ_Ext_Vign_Type__c,&apos;Message&apos;), 	ISPICKVAL(MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Contact_Segmentation__c,&quot;Champagne&quot;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MMPJ_Ext_Vign_Notification_Message_Cognac</fullName>
        <actions>
            <name>MMPJ_Ext_Vign_Notification_Message_Cognac</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 	ISPICKVAL(MMPJ_Ext_Vign_Type__c,&apos;Message&apos;), 	ISPICKVAL(MMPJ_Ext_Vign_Contact__r.MMPJ_Ext_Vign_Contact_Segmentation__c,&quot;Cognac&quot;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
