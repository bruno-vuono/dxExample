<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Atualiza_limite_de_credito</fullName>
        <field>Credit_line__c</field>
        <formula>Sugestao_do_analista__c</formula>
        <name>Atualiza limite de credito</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Conta__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcula_sugest_o_parcial_de_limite</fullName>
        <field>Calculo_parcial_limite__c</field>
        <formula>Limite_necessario__c * ( Pts_obtidos__c / 100)</formula>
        <name>Calcula sugestão parcial de limite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_CleanNotes</fullName>
        <description>Clean Account Notes Fields</description>
        <field>Notes__c</field>
        <name>LAT_BR_AC_CleanNotes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>Conta__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_InitialApproverReset</fullName>
        <field>LAT_BR_Initial_Approval_Submiter__c</field>
        <name>LAT_BR_AC_InitialApproverReset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_InitialSubmiterUpdate</fullName>
        <field>Initial_Submiter__c</field>
        <formula>$User.Id</formula>
        <name>LAT_BR_AC_InitialSubmiterUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_UpdateStatusAtivo</fullName>
        <field>LAT_BR_Status__c</field>
        <literalValue>Ativo</literalValue>
        <name>LAT_BR_AC_UpdateStatusAtivo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_UpdateStatusEmAprovacao</fullName>
        <field>LAT_BR_Status__c</field>
        <literalValue>Em aprovação</literalValue>
        <name>LAT_BR_AC_UpdateStatusEmAprovação</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_UpdateStatusReprovado</fullName>
        <field>LAT_BR_Status__c</field>
        <literalValue>Reprovado</literalValue>
        <name>LAT_BR_AC_UpdateStatusReprovado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_UpdateStepToCC</fullName>
        <field>LAT_BR_CurrentStep__c</field>
        <formula>&apos;C&amp;C&apos;</formula>
        <name>LAT_BR_AC_UpdateStepToCC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_AC_UpdateStepToNull</fullName>
        <field>LAT_BR_CurrentStep__c</field>
        <formula>null</formula>
        <name>LAT_BR_AC_UpdateStepToNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LAT_BR_InitialSubmiterReset</fullName>
        <field>Initial_Submiter__c</field>
        <name>LAT_BR_InitialSubmiterReset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previs_o_m_s_c_lculo_at_junho</fullName>
        <field>Previsao_mes_ate_junho__c</field>
        <formula>Valor_total__c / Meses_at_junho__c</formula>
        <name>Previsão mês cálculo até junho</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Atualiza limite de crédito - sugestão analista</fullName>
        <actions>
            <name>Atualiza_limite_de_credito</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LAT_BR_AC_CleanNotes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calcula sugestão parcial de limite</fullName>
        <actions>
            <name>Calcula_sugest_o_parcial_de_limite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Limite_necessario__c &lt;&gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Previsão mês cálculo até junho</fullName>
        <actions>
            <name>Previs_o_m_s_c_lculo_at_junho</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Valor_total__c &lt;&gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
