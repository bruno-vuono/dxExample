@isTest
public class EUR_CRM_NG_AssignAcctOwnerHandlerTest {

    public static EUR_CRM_Account__c euaccount = new EUR_CRM_Account__c();
    public static EUR_CRM_Region__c region = new EUR_CRM_Region__c();
    public static EUR_CRM_Territory__c territory = new EUR_CRM_Territory__c();
    public static EUR_CRM_Image_Level__c  imageLevel = new EUR_CRM_Image_Level__c ();
    public static EUR_CRM_Group_Outlet_Type__c  grpOutletType = new EUR_CRM_Group_Outlet_Type__c ();

    public static Id euAccountNGId = [SELECT Id, Name FROM RecordType where SobjectType='EUR_CRM_Account__c' AND DeveloperName = 'EUR_NG_On_Trade'].Id;
    public static Id regionNGId = [SELECT Id, Name FROM RecordType where SobjectType='EUR_CRM_Region__c' AND DeveloperName = 'EUR_NG_Region'].Id;
    public static Id territoryNGId = [SELECT Id, Name FROM RecordType where SobjectType='EUR_CRM_Territory__c' AND DeveloperName = 'EUR_CRM_NG_Territory'].Id;
    public static Id grpOutletNGId = [SELECT Id, Name FROM RecordType where SobjectType='EUR_CRM_Group_Outlet_Type__c' AND DeveloperName = 'EUR_NG_Group_Outlet_Type'].Id;
    public static Id imageLevelNGId = [SELECT Id, Name FROM RecordType where SobjectType='EUR_CRM_Image_Level__c' AND DeveloperName = 'EUR_NG_Image_Level'].Id;
    

    public static User eurSysUser;
    public static void setUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name ='EUR System Admin']; 
        UserRole r = [select id from UserRole where Developername ='EMEA'];
        eurSysUser = new User(Alias = 'standt', Email='userEmail1234aoke@test.com', userroleid=r.id,
        EmailEncodingKey='UTF-8', LastName='userEmail1234aokelastName', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='userEmail1234aoke@test.com');
        insert eurSysUser;

    }

    public static void dataInsert1(){

        region = new EUR_CRM_Region__c();
        region.Name = 'Test Region';
        region.recordtypeId = regionNGId;
        region.EUR_CRM_Channel__c = 'ON TRADE';
        region.EUR_CRM_Region_Owner__c = eurSysUser.Id;
        insert region;
        system.assertNotEquals(region, null);

        territory = new EUR_CRM_Territory__c();
        territory.Name = 'Test Territory';
        territory.recordtypeId = territoryNGId;
        territory.EUR_CRM_KD_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_Off_Trade_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_On_Trade_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_Territory_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_Region__c = region.Id;
        insert territory;
        system.assertNotEquals(territory, null);

        grpOutletType = new EUR_CRM_Group_Outlet_Type__c();
        grpOutletType.recordtypeId = grpOutletNGId;
        grpOutletType.EUR_CRM_Name__c = 'Restaurant';
        insert grpOutletType;
        system.assertNotEquals(grpOutletType, null);

        imageLevel = new EUR_CRM_Image_Level__c();
        imageLevel.recordtypeId = imageLevelNGId;
        imageLevel.EUR_CRM_Name__c = 'Mainstream';
        imageLevel.EUR_CRM_Group_Outlet_Type__c = grpOutletType.Id;
        insert imageLevel;
        system.assertNotEquals(imageLevel, null);

    }

    public static void dataInsert2(){

        region = new EUR_CRM_Region__c();
        region.Name = 'Test Region';
        region.recordtypeId = regionNGId;
        region.EUR_CRM_Channel__c = 'ON TRADE';
        region.EUR_CRM_Region_Owner__c = eurSysUser.Id;
        insert region;
        system.assertNotEquals(region, null);

        territory = new EUR_CRM_Territory__c();
        territory.Name = 'Test Territory';
        territory.recordtypeId = territoryNGId;
        territory.EUR_CRM_KD_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_Off_Trade_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_On_Trade_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_Territory_Owner__c = eurSysUser.Id;
        territory.EUR_CRM_Region__c = region.Id;
        insert territory;
        system.assertNotEquals(territory, null);

        grpOutletType = new EUR_CRM_Group_Outlet_Type__c();
        grpOutletType.recordtypeId = grpOutletNGId;
        grpOutletType.EUR_CRM_Name__c = 'Restaurant';
        insert grpOutletType;
        system.assertNotEquals(grpOutletType, null);

        imageLevel = new EUR_CRM_Image_Level__c();
        imageLevel.recordtypeId = imageLevelNGId;
        imageLevel.EUR_CRM_Name__c = 'Iconic';
        imageLevel.EUR_CRM_Group_Outlet_Type__c = grpOutletType.Id;
        insert imageLevel;
        system.assertNotEquals(imageLevel, null);

    }
    
    
    static testMethod void test1(){
        setUser();
        System.runAs(eurSysUser){
            dataInsert1();
            Test.startTest();
                euaccount = new EUR_CRM_Account__c();
                euaccount.RecordtypeId = euAccountNGId;
                euaccount.Name = 'Test Name';
                euaccount.EUR_CRM_Channel__c = 'ON TRADE';
                euaccount.EUR_CRM_Group_Outlet_Type__c = grpOutletType.Id;
                euaccount.EUR_CRM_Image_Level__c = imageLevel.Id;
                euaccount.EUR_CRM_Territory__c = territory.Id;
                insert euaccount;
                system.assertNotEquals(euaccount, null);
            Test.stopTest();
        }
    }

    static testMethod void test2(){
        setUser();
        System.runAs(eurSysUser){
            dataInsert1();
            euaccount = new EUR_CRM_Account__c();
            euaccount.RecordtypeId = euAccountNGId;
            euaccount.Name = 'Test Name';
            euaccount.EUR_CRM_Channel__c = 'ON TRADE';
            euaccount.EUR_CRM_Group_Outlet_Type__c = grpOutletType.Id;
            euaccount.EUR_CRM_Image_Level__c = imageLevel.Id;
            insert euaccount;
            system.assertNotEquals(euaccount, null);

            Test.startTest();
                
                euaccount.EUR_CRM_Territory__c = territory.Id;
                update euaccount;
                
            Test.stopTest();
        }
    }
    
    static testMethod void test3(){
        setUser();
        System.runAs(eurSysUser){
            dataInsert2();
            Test.startTest();
                euaccount = new EUR_CRM_Account__c();
                euaccount.RecordtypeId = euAccountNGId;
                euaccount.Name = 'Test Name';
                euaccount.EUR_CRM_Channel__c = 'ON TRADE';
                euaccount.EUR_CRM_Group_Outlet_Type__c = grpOutletType.Id;
                euaccount.EUR_CRM_Image_Level__c = imageLevel.Id;
                euaccount.EUR_CRM_Territory__c = territory.Id;
                insert euaccount;
                system.assertNotEquals(euaccount, null);
            Test.stopTest();
        }
        
        EUR_CRM_NG_ShareEUAccountHandler NGShare = New EUR_CRM_NG_ShareEUAccountHandler();
        NGShare.createEUAcctShare(euaccount.id,eurSysUser.id);
        NGShare.createAcctShare(euaccount.id,eurSysUser.id);
            
    }

}