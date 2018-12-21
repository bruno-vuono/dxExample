<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Alert_Type_A_Completed</fullName>
        <description>ASI CN NPL Item Master Alert Type A Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Alert_Type_A_Comp</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Alert_Type_B_Completed</fullName>
        <description>ASI CN NPL Item Master Alert Type B Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Alert_Type_B_Comp</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Alert_to_BA</fullName>
        <description>ASI CN NPL Item Master Alert to BA</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Alert_to_BA</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_BA_Notify_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Alert_to_LOG</fullName>
        <description>ASI CN NPL Item Master Alert to LOG</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Alert_to_LOG</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_LOG_Notify_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Alert_to_Sales_Planning</fullName>
        <description>ASI CN NPL Item Master Alert to Sales Planning</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_AlerttoSales_Plan</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_SP_Notify_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Complete_Alert_Existing</fullName>
        <description>ASI CN NPL Item Master Complete Alert - Existing</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Complete_Existing</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Complete_Alert_New_Brand</fullName>
        <description>ASI CN NPL Item Master Complete Alert - New Brand</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Complete_NewBrand</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Complete_Alert_New_Item</fullName>
        <description>ASI CN NPL Item Master Complete Alert - New Item</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Complete_New_Item</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_Complete_VF</template>
    </alerts>
    <alerts>
        <fullName>ASI_CN_NPL_Item_Master_Complete_Alert_New_Item_New_Brand</fullName>
        <description>ASI CN NPL Item Master Complete Alert - New Item New Brand</description>
        <protected>false</protected>
        <recipients>
            <recipient>ASI_CN_NPL_Item_Master_Complete_New_I_B</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ASI_CN_NPL_Email_Template/ASI_CN_NPL_Item_Master_Complete_VF</template>
    </alerts>
    <rules>
        <fullName>ASI CN NPL Item Master Existing Complete</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Complete_Alert_Existing</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Item_Group__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Brand_Sub_Brand__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master New Brand Complete</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Complete_Alert_New_Brand</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Item_Group__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Brand_Sub_Brand__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master New Item Complete</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Complete_Alert_New_Item</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Item_Group__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Brand_Sub_Brand__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master New Item New Brand Complete</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Complete_Alert_New_Item_New_Brand</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Item_Group__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_New_Brand_Sub_Brand__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master Notify BA</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Alert_to_BA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Waiting For BA Input Category Code</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master Notify LOG</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Alert_to_LOG</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Waiting For Logistics Input Item Code,Waiting For Logistics Finalize Chinese Name,Waiting For Logistics Final Confirmation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master Notify Sales Planning</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Alert_to_Sales_Planning</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Waiting For Sales Planning Input Item Group Description (GE &amp; CH)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master Notify Type A Completed</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Alert_Type_A_Completed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Type A</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ASI CN NPL Item Master Notify Type B Completed</fullName>
        <actions>
            <name>ASI_CN_NPL_Item_Master_Alert_Type_B_Completed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.ASI_CN_NPL_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>ASI_CN_NPL_Item_Master__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Type B</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>