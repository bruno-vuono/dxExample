<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ASI_BRD_Copy_Acquisition_Campaign</fullName>
        <field>ASI_BRD_Acquisition_Campaign__c</field>
        <formula>mkto71_Acquisition_Program__c</formula>
        <name>Copy Acquisition Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_BRD_SG_GHM_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_BRD_SG_GHM_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI_BRD_SG_GHM_Lead_RecordType_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_BRD_SG_TGL_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_BRD_SG_TGL_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI_BRD_SG_TGL_Lead_RecordType_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_BRD_Update_Lead_Convert_flag_to_True</fullName>
        <field>ASI_BRD_Sys_Lead_Auto_Convert__c</field>
        <literalValue>1</literalValue>
        <name>Update Lead Convert flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_BRD_Update_Lead_RT_Generic_Brand_CRM</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_BRD_Generic_CRM_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Lead RT to Generic Brand CRM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_LUX_JP_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_LUX_JP_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI LUX JP Lead RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_LUX_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_LUX_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI LUX Lead RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_LUX_MY_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_LUX_MY_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI LUX MY Lead RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_LUX_SG_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_LUX_SG_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI LUX SG Lead RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_LUX_TW_Lead_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ASI_LUX_TW_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ASI LUX TW Lead RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ASI_LUX_Update_Profile_To_FirstContact</fullName>
        <field>ASI_LUX_Profile__c</field>
        <literalValue>First Contact</literalValue>
        <name>ASI_LUX_Update_Profile_To_FirstContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ASI BRD SG GHM Lead RecordType Conversion</fullName>
        <actions>
            <name>ASI_BRD_SG_GHM_Lead_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>startsWith</operation>
            <value>SGN_GHM_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI LUX (SG) Lead,ASI Brand TGL (SG) Lead,ASI Brand GHM (SG) Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI BRD SG TGL Lead RecordType Conversion</fullName>
        <actions>
            <name>ASI_BRD_SG_TGL_Lead_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>startsWith</operation>
            <value>SGN_TGL_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI LUX (SG) Lead,ASI Brand TGL (SG) Lead,ASI Brand GHM (SG) Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI LUX Lead RecordType Conversion</fullName>
        <actions>
            <name>ASI_LUX_Lead_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RIGHT(RecordType.DeveloperName,7)=&apos;ASI_LUX&apos; &amp;&amp;  RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;ASI_&apos; &amp;&amp; RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;ASI_&apos; &amp;&amp;   RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;HKG_&apos; &amp;&amp;  RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;MYA_&apos; &amp;&amp;  RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;TWN_&apos; &amp;&amp;  RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;JPN_&apos; &amp;&amp; RIGHT(mkto71_Acquisition_Program__c , 4)&lt;&gt; &apos;SGN_&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI LUX MY Lead RecordType Conversion</fullName>
        <actions>
            <name>ASI_LUX_MY_Lead_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>startsWith</operation>
            <value>MYA_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>ASI LUX</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>_BRD_</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI LUX SG Lead RecordType Conversion</fullName>
        <actions>
            <name>ASI_LUX_SG_Lead_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 OR 7) AND 5 AND 6 AND 8) AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>startsWith</operation>
            <value>SGN_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>ASI LUX</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>ASI Brand</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>TGL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>GHM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>startsWith</operation>
            <value>SGP_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>_BRD_</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI LUX TW Lead RecordType Conversion</fullName>
        <actions>
            <name>ASI_LUX_TW_Lead_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>startsWith</operation>
            <value>TWN_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>ASI LUX</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>_BRD_</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ASI_BRD_Generic_CRM_Lead_RecordType_Update</fullName>
        <actions>
            <name>ASI_BRD_Update_Lead_RT_Generic_Brand_CRM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>contains</operation>
            <value>_BRD_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>ASI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>SGN_TGL_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notContain</operation>
            <value>SGN_GHM_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.ASI_BRD_Primary_Market__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI_BRD_Generic_Ready_for_AutoLeadConversion</fullName>
        <actions>
            <name>ASI_BRD_Copy_Acquisition_Campaign</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_BRD_Update_Lead_Convert_flag_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ASI_LUX_Update_Profile_To_FirstContact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 5) OR (4 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI Generic Brand CRM Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI LUX (HK) Lead,ASI LUX (Regional) Lead,ASI LUX (MY) Lead,ASI LUX (TW) Lead,ASI Brand (JP) Lead,ASI LUX Lead,ASI LUX (SG) Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>ASI Brand TGL (SG) Lead,ASI Brand GHM (SG) Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.mkto71_Acquisition_Program__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.ASI_BRD_Primary_Market__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule updates the field that trigger Auto Lead Conversion.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
