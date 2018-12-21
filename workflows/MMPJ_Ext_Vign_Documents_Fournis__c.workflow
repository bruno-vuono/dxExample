<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MMPJ_Ext_Vign_Document</fullName>
        <description>MMPJ_Ext_Vign_Document</description>
        <protected>false</protected>
        <recipients>
            <recipient>MMPJ_Ext_Vign_Admins_Fonctionnels_Cognac</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MMPJ_Ext_Vign/MMPJ_Ext_Vign_Nouveau_Document</template>
    </alerts>
    <alerts>
        <fullName>MMPJ_Ext_Vign_Document_upload_Champagne</fullName>
        <description>MMPJ_Ext_Vign_Document_upload_Champagne</description>
        <protected>false</protected>
        <recipients>
            <recipient>MMPJ_Ext_Vign_Admins_Fonctionnels_Champ</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MMPJ_Ext_Vign/MMPJ_Ext_Vign_Nouveau_Document</template>
    </alerts>
    <rules>
        <fullName>MMPJ_Ext_Vign_Document_upload_Champagne</fullName>
        <actions>
            <name>MMPJ_Ext_Vign_Document_upload_Champagne</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 	OR( 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;RIB&quot;), 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;KBIS&quot;), 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;Récépissé ODG&quot;), 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;Memento fiscal&quot;) 	), 	ISPICKVAL(MMPJ_Ext_Vign_Livreur__r.MMPJ_Ext_Vign_Societe_Segmentation__c,&quot;Champagne&quot; )   )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MMPJ_Ext_Vign_Document_upload_Cognac</fullName>
        <actions>
            <name>MMPJ_Ext_Vign_Document</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 	OR( 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;RIB&quot;), 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;KBIS&quot;), 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;Récépissé ODG&quot;), 		ISPICKVAL(MMPJ_Ext_Vign_Type__c,&quot;Memento fiscal&quot;) 	), 	ISPICKVAL(MMPJ_Ext_Vign_Livreur__r.MMPJ_Ext_Vign_Societe_Segmentation__c,&quot;Cognac&quot; )   )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
