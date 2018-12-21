<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RIC_NewProject</fullName>
        <description>RIC_NewProject</description>
        <protected>false</protected>
        <recipients>
            <field>RIC_Coordinateur__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RIC_Workflow_OPP/RIC_NotifCoordinateur_NewProject</template>
    </alerts>
    <alerts>
        <fullName>RIC_ProjetAnnule</fullName>
        <description>RIC_ProjetAnnule</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RIC_Workflow_OPP/RIC_ProjetAnnule_Notif_Demandeur</template>
    </alerts>
    <alerts>
        <fullName>RIC_ProjetCloture</fullName>
        <description>RIC_ProjetCloture</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RIC_Workflow_OPP/RIC_ProjetCloture_Notif_Demandeur</template>
    </alerts>
    <alerts>
        <fullName>RIC_ProjetRefus_NotifDemandeur</fullName>
        <description>RIC_ProjetRefus_NotifDemandeur</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>RIC_Coordinateur__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RIC_Workflow_OPP/RIC_ProjetRefus_Notif_Demandeur</template>
    </alerts>
    <alerts>
        <fullName>RIC_ProjetValide_NotifDemandeur</fullName>
        <description>RIC_ProjetValide_NotifDemandeur</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>RIC_Coordinateur__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RIC_Workflow_OPP/RIC_ProjetValide_Notif_Demandeur</template>
    </alerts>
    <fieldUpdates>
        <fullName>RIC_ACloturer</fullName>
        <field>RIC_Status__c</field>
        <literalValue>A clôturer</literalValue>
        <name>RIC_ACloturer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_CoordNicolas_Renault</fullName>
        <field>RIC_Coordinateur__c</field>
        <lookupValue>nicolas.renault@pernod-ricard.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RIC_CoordNicolas_Renault</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Coord_INT</fullName>
        <field>RIC_Coordinateur__c</field>
        <lookupValue>martin.bouclier@pernod-ricard.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RIC_Coord_INT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Coord_Nicolas_Renault</fullName>
        <field>RIC_Coordinateur__c</field>
        <lookupValue>nicolas.renault@pernod-ricard.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RIC_Coord_Nicolas_Renault</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Coord_OPP</fullName>
        <description>Jacques Lehoux</description>
        <field>RIC_Coordinateur__c</field>
        <lookupValue>jacques.lehoux@pernod-ricard.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RIC_Coord_Jacques_Lehoux</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Coord_OPP_PER</fullName>
        <description>Affecte Jacques Lehoux comme coordinateur</description>
        <field>RIC_Coordinateur__c</field>
        <lookupValue>jacques.lehoux@pernod-ricard.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>RIC_Coord_OPP_PER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_Validation_Dir_International</fullName>
        <field>RIC_Validation_Direction_International__c</field>
        <formula>Today()</formula>
        <name>Date de Validation Dir International</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_Validation_Marketing</fullName>
        <field>RIC_Marketing_Approval__c</field>
        <formula>Today()</formula>
        <name>Date de Validation Marketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_Validation_RD</fullName>
        <field>RIC_Validation_Resp_QRD__c</field>
        <formula>Today()</formula>
        <name>Date de Validation R&amp;D</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_Validation_Ventes</fullName>
        <field>RIC_DNV_Approval__c</field>
        <formula>Today()</formula>
        <name>Date de Validation Ventes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_diffusion_des_Actions</fullName>
        <field>RIC_Date_Diffusion__c</field>
        <formula>TODAY()</formula>
        <name>Date de diffusion des Actions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_validation_CDG_MKTG</fullName>
        <field>RIC_Validation_CDG_MKT__c</field>
        <formula>TODAY()</formula>
        <name>Date de validation CDG MKTG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Date_de_validation_DDO</fullName>
        <field>RIC_DDO_Approval__c</field>
        <formula>TODAY()</formula>
        <name>Date de validation DDO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Projet_DDO_Valide</fullName>
        <field>RIC_Status__c</field>
        <literalValue>Validé</literalValue>
        <name>RIC_Projet_DDO_Valide</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Statut_en_demande</fullName>
        <field>RIC_Status__c</field>
        <literalValue>En création</literalValue>
        <name>Statut - en création</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Statut_pending</fullName>
        <field>RIC_Status__c</field>
        <literalValue>En attente de validation</literalValue>
        <name>Statut - en attente de validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Statut_refuse</fullName>
        <field>RIC_Status__c</field>
        <literalValue>Refusé</literalValue>
        <name>Statut - refusé</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Statut_valide</fullName>
        <field>RIC_Status__c</field>
        <literalValue>Validé</literalValue>
        <name>Statut - validé</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Task_Status_Blank</fullName>
        <description>Returns hidden field RIC_Task_Status__c to blank.</description>
        <field>RIC_Task_Status__c</field>
        <name>RIC_Task_Status_Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Update_Tech_Project_Number</fullName>
        <field>RIC_TECH_Project_Number__c</field>
        <formula>RIC_Project_Number__c</formula>
        <name>RIC_Update_Tech_Project_Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RIC_Update_Timing_Week</fullName>
        <field>RIC_Semaine_du_Timing__c</field>
        <formula>TEXT(IF( 
  CEILING( ( RIC_Time__c- DATE( YEAR( RIC_Time__c), 1, 1) + 1) / 7) &gt; 52,
  52,
  CEILING( ( RIC_Time__c- DATE( YEAR( RIC_Time__c), 1, 1) + 1) / 7)
))</formula>
        <name>Update_Timing_Week</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RIC_Coordinateur_Projet_ALL</fullName>
        <actions>
            <name>RIC_Coord_Nicolas_Renault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10)</booleanFilter>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Coordinateur__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC - Produit fini standard fabriqué</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PER - Produit fini standard fabriqué</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC - Produit fini Brand Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PER - Produit fini Brand Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC - Promotion fabriquée</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PER - Promotion fabriquée</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC - Promotion d&apos;une marque BC avec reprise</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PER - Promotion d&apos;une marque BC avec reprise</value>
        </criteriaItems>
        <description>Affecte Nicolas Renault comme coordinateur selon le type de projet</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Coordinateur_Projet_INT</fullName>
        <actions>
            <name>RIC_Coord_INT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RIC_Coord_Nicolas_Renault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Coordinateur__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INT - Produit fini standard</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INT - Promotion</value>
        </criteriaItems>
        <description>Affecte Nicolas Renault comme coordinateur selon le type de projet</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Coordinateur_Projet_OPP</fullName>
        <actions>
            <name>RIC_Coord_OPP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Coordinateur__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC - OPP ou Kit OPP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>INT - OPP ou Kit OPP</value>
        </criteriaItems>
        <description>Affecte Jacques Lehoux comme coordinateur selon le type de projet</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Coordinateur_Projet_PER_OPP</fullName>
        <actions>
            <name>RIC_Coord_OPP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RIC_Coord_OPP_PER</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Coordinateur__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PER - OPP ou Kit OPP</value>
        </criteriaItems>
        <description>Affecte Jacques Lehoux comme coordinateur selon le type de projet</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Coordinateur_Projet_e_commerce</fullName>
        <actions>
            <name>RIC_CoordNicolas_Renault</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC e-commerce,PER - E-commerce</value>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Coordinateur__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Fill_Project_Number</fullName>
        <actions>
            <name>RIC_Update_Tech_Project_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the project number into the TECH field: RIC_TECH_Project_Number</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_ProjetACloturer</fullName>
        <actions>
            <name>RIC_ACloturer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_MAD_Date_Real__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Status__c</field>
            <operation>equals</operation>
            <value>En cours</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Bascule le statut du projet en &quot;A clôturer&quot; lorsque la MAD réelle est renseignée et que le projet est &quot;En cours&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RIC_ProjetAnnule</fullName>
        <actions>
            <name>RIC_ProjetAnnule</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Status__c</field>
            <operation>equals</operation>
            <value>Annulé</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifie le demandeur quand le projet est annulé</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RIC_ProjetCloture</fullName>
        <actions>
            <name>RIC_ProjetCloture</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Status__c</field>
            <operation>equals</operation>
            <value>Clôturé</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifie le demandeur quand le projet est clôturé</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RIC_ProjetNew</fullName>
        <actions>
            <name>RIC_NewProject</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Coordinateur__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifie le coordinateur à la création d&apos;un projet</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Projet_DDO_Valide</fullName>
        <actions>
            <name>RIC_Projet_DDO_Valide</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>RIC - DDO,PER - DDO</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Return_Task_Status_To_Blank</fullName>
        <actions>
            <name>RIC_Date_de_diffusion_des_Actions</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RIC_Task_Status_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Milestone1_Project__c.RIC_Task_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.BypassWF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Workflow OPP &amp; Produits Finis</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RIC_Update_Timing_Week</fullName>
        <actions>
            <name>RIC_Update_Timing_Week</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(RIC_Date_1er_Production__c), ISCHANGED(RIC_MAD_Date_Approved__c), ISCHANGED(RIC_MAD_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
