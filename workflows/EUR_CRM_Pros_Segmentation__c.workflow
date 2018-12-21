<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>EUR_CRM_UpdateAccountGroupOutletType</fullName>
        <active>false</active>
        <formula>OR( ISNEW() ,   ISCHANGED(EUR_CRM_Group_Outlet_Type_ToDELETE__c),  ISCHANGED( EUR_CRM_Outlet_Type_ToDELETE__c),  ISCHANGED( EUR_CRM_Image_Level_ToDELETE__c),  ISCHANGED( EUR_CRM_Volume_Potential_ToDELETE__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
