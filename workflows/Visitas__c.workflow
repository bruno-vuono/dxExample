<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualizar_campo_Trigger_ON_visitas</fullName>
        <description>Desmarcar o Campo Trigger ON visitas</description>
        <field>trigger_on__c</field>
        <literalValue>0</literalValue>
        <name>Atualizar campo Trigger ON visitas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_VTS_UpdatesIsTriggerToFalse</fullName>
        <description>Updates LAT Is Trigger to false</description>
        <field>LAT_isTrigger__c</field>
        <literalValue>0</literalValue>
        <name>LAT_BR_VTS_UpdatesIsTriggerToFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesAddressNumber</fullName>
        <field>LAT_MX_AddressNumber__c</field>
        <formula>Conta__r.Revenue_Number__c</formula>
        <name>LAT_MX_VTS_UpdatesAddressNumber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesBetweenStreets</fullName>
        <description>Updates the field Between Streets</description>
        <field>LAT_MX_BetweenStreets__c</field>
        <formula>Conta__r.LAT_MX_BetweenStreets__c</formula>
        <name>LAT_MX_VTS_UpdatesBetweenStreets</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesCityMX</fullName>
        <description>Updates the field City MX</description>
        <field>LAT_MX_City__c</field>
        <formula>Conta__r.LAT_MX_City__c</formula>
        <name>LAT_MX_VTS_UpdatesCityMX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesCounty</fullName>
        <description>Updates the field County</description>
        <field>LAT_MX_County__c</field>
        <formula>Conta__r.LAT_MX_County__c</formula>
        <name>LAT_MX_VTS_UpdatesCounty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesNeighbourhoodMX</fullName>
        <description>Updates the field Neighbourhood MX</description>
        <field>LAT_MX_Neighbourhood__c</field>
        <formula>Conta__r.LAT_MX_Neighbourhood__c</formula>
        <name>LAT_MX_VTS_UpdatesNeighbourhoodMX</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesPostalCode</fullName>
        <description>Updates the field Postal Code</description>
        <field>LAT_MX_PostalCode__c</field>
        <formula>Conta__r.LAT_MX_PostalCode__r.Name</formula>
        <name>LAT_MX_VTS_UpdatesPostalCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LAT_MX_VTS_ClosedVisit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>LAT_MX_VTS_UpdatesRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesSreet</fullName>
        <description>Updates the field Street</description>
        <field>LAT_MX_Street__c</field>
        <formula>Conta__r.AddressLine1_AR__c</formula>
        <name>LAT_MX_VTS_UpdatesSreet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesState</fullName>
        <description>Updates the field State</description>
        <field>LAT_MX_State__c</field>
        <formula>Conta__r.LAT_MX_State__c</formula>
        <name>LAT_MX_VTS_UpdatesState</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_MX_VTS_UpdatesStatus</fullName>
        <field>Status__c</field>
        <literalValue>Visit not made</literalValue>
        <name>LAT_MX_VTS_UpdatesStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_SetCloseDate</fullName>
        <field>LAT_CloseDate__c</field>
        <formula>TODAY()</formula>
        <name>LAT Set CloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VTS_ChangeName_AR</fullName>
        <field>Name</field>
        <formula>$User.FirstName +&apos; &apos; +  $User.LastName   + &apos; - &apos; + TEXT(Planejamento__r.M_s_de_Ref_rencia__c) + &apos;/&apos; +   TEXT(Planejamento__r.Ano_de_Referencia__c)  + &apos; - &apos; +  Conta__r.Name + &apos; - &apos; +   Conta__r.AccountNumber</formula>
        <name>VTS_ChangeName_AR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LAT_BR_VTS_WF01_UpdatesIsTrigger</fullName>
        <actions>
            <name>LAT_BR_VTS_UpdatesIsTriggerToFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates LAT Is Trigger to false</description>
        <formula>$RecordType.DeveloperName=&apos;BRA_Standard&apos; &amp;&amp; LAT_isTrigger__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LAT_MX_VST_WF01_UpdatesVisitaFields</fullName>
        <actions>
            <name>LAT_MX_VTS_UpdatesAddressNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesBetweenStreets</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesCityMX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesCounty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesNeighbourhoodMX</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesPostalCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesSreet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesState</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Address fields when a new record is created.</description>
        <formula>$RecordType.DeveloperName = &apos;LAT_MX_VTS_PlannedVisit&apos; || $RecordType.DeveloperName = &apos;LAT_MX_VTS_PlannedVisitON&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LAT_MX_VST_WF02_UpdatesRTVisitaNoRealizada</fullName>
        <actions>
            <name>LAT_MX_VTS_UpdatesRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_MX_VTS_UpdatesStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Record Type of visita when &apos;Não será Realizada&apos; is true and &apos;Motivo&apos; is not blank.</description>
        <formula>($RecordType.DeveloperName = &apos;LAT_MX_VTS_PlannedVisit&apos; || $RecordType.DeveloperName = &apos;LAT_MX_VTS_PlannedVisitON&apos; ) &amp;&amp; Visita_n_o_realizada__c = true &amp;&amp; NOT(ISPICKVAL(Poss_veis_motivos__c,&apos;&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LAT_SetCloseDate</fullName>
        <actions>
            <name>LAT_SetCloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Status__c ,&apos;Encerrada&apos;)  ,ISNULL( LAT_CloseDate__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trigger on</fullName>
        <actions>
            <name>Atualizar_campo_Trigger_ON_visitas</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Visitas__c.trigger_on__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Desmarcar o campo trigger on.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VTS_WF01_ChangeName_AR</fullName>
        <actions>
            <name>VTS_ChangeName_AR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Change the name of the visit according to the following structure:
‘username that execute the process’ + ‘-’ + ‘Client name’ + &apos;-&apos; + ‘Sucursal’</description>
        <formula>$RecordType.DeveloperName == &apos;VTS_Standard_AR&apos; || $RecordType.DeveloperName == &apos;VTS_Standard_UY&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
