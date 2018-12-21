<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_status_field</fullName>
        <field>ApprovedPayment__c</field>
        <literalValue>1</literalValue>
        <name>Update status field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>reject</fullName>
        <field>Status__c</field>
        <literalValue>R</literalValue>
        <name>reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>reject_status</fullName>
        <field>ApprovedPayment__c</field>
        <literalValue>0</literalValue>
        <name>reject status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
