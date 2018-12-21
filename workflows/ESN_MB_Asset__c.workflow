<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ESN_MB_AddAssetTypeWebinarToAsset</fullName>
        <field>ESN_MB_isWebinar__c</field>
        <formula>IF( CONTAINS(ESN_MB_Taxonomy_AssetType__c , &quot;Webinar&quot;),&quot;Webinar&quot;, &quot;&quot;)</formula>
        <name>ESN_MB_AddAssetTypeWebinarToAsset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESN_MB_AddBrandNameToAsset</fullName>
        <field>ESN_MB_Brand_Scope_Text__c</field>
        <formula>LEFT(ESN_MB_Taxonomy_BrandVariant__c, 255)</formula>
        <name>ESN_MB_AddBrandNameToAsset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESN_MB_AddDescriptionToAsset</fullName>
        <field>ESN_MB_TECH_description__c</field>
        <formula>LEFT(ESN_MB_description__c, 255)</formula>
        <name>ESN_MB_AddDescriptionToAsset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESN_MB_AddKeywordsToAsset</fullName>
        <field>ESN_MB_TECH_keywords__c</field>
        <formula>LEFT(ESN_MB_keywords__c, 255)</formula>
        <name>ESN_MB_AddKeywordsToAsset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ESN_MB_AddBrandNameToAsset</fullName>
        <actions>
            <name>ESN_MB_AddBrandNameToAsset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ESN_MB_AssetUpdate</fullName>
        <actions>
            <name>ESN_MB_AddAssetTypeWebinarToAsset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ESN_MB_AddBrandNameToAsset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ESN_MB_AddDescriptionToAsset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ESN_MB_AddKeywordsToAsset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update DAM fields Rich Text to basic text fields to allow SOQL queries</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
