@isTest
public class ASI_TnE_KR_TestClassHelper
{
    public static List<User> createTestUser()
    {
        Profile tempProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; //profile
        List<User> tempUsers = new List<User>(); //user list

        User tempUser1 = new User(Alias = '666', Email='standarduser666@testorg.com', EmailEncodingKey='UTF-8', 
                                  FirstName='Test1', LastName='666', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = tempProfile.Id, ASI_KOR_User_Branch_Code__c='311',
                                  TimeZoneSidKey='Asia/Hong_Kong', UserName='standarduser666@testorg.com', 
                                  ASI_KOR_Commission_Code__c='1234567', CompanyName = 'testUserCompany', ASI_GnH_Department__c = 'Kyunggi WS-TL', Country = 'Korea');
        insert tempUser1;
        User tempUser2 = new User(Alias = '777', Email='standarduser777@testorg.com', EmailEncodingKey='UTF-8', 
                                  FirstName='Test2', LastName='777', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = tempProfile.Id, 
                                  TimeZoneSidKey='Asia/Hong_Kong', UserName='standarduser777@testorg.com', 
                                  ASI_KOR_Commission_Code__c='1112223', ManagerId = tempUser1.id,
                                  CompanyName = 'testUserCompany', Country = 'Korea', ASI_GnH_Department__c = 'Kyunggi WS', ASI_KOR_User_Branch_Code__c='506');
        insert tempUser2;
        User tempUser3 = new User(Alias = '888', Email='standarduser888@testorg.com', EmailEncodingKey='UTF-8', 
                                  FirstName='Test3', LastName='888', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = tempProfile.Id, 
                                  TimeZoneSidKey='Asia/Hong_Kong', UserName='standarduser888@testorg.com', 
                                  ASI_KOR_Commission_Code__c='2223334', ManagerId = tempUser2.id, 
                                  CompanyName = 'testUserCompany', Country = 'Korea', ASI_GnH_Department__c = 'Purchasing', ASI_KOR_User_Branch_Code__c='523');
        insert tempUser3;
        User tempUser4 = new User(Alias = '999', Email='standarduser999@testorg.com', EmailEncodingKey='UTF-8', 
                                  FirstName='Test4', LastName='999', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = tempProfile.Id, 
                                  TimeZoneSidKey='Asia/Hong_Kong', UserName='standarduser999@testorg.com', 
                                  ASI_KOR_Commission_Code__c='3334445', ManagerId = tempUser2.id, 
                                  CompanyName = 'testUserCompany', Country = 'Korea', ASI_GnH_Department__c = 'Logistics', ASI_KOR_User_Branch_Code__c='523');
        insert tempUser4;

        User tempUser5 = [select id, Name, ASI_KOR_Commission_Code__c, ProfileId from user where id = :userInfo.getUserId()];
        tempUsers.add(tempUser1); //add to user list
        tempUsers.add(tempUser2); //add to user list
        tempUsers.add(tempUser3); //add to user list
        tempUsers.add(tempUser4); //add to user list
        tempUsers.add(tempUser5); //add to user list
        //insert tempUsers;
        return tempUsers;
    }

    public static List<ASI_eForm_HR_MDM__c> createMDMRecords()
    {
        List<ASI_eForm_HR_MDM__c> tempMDMs = new List<ASI_eForm_HR_MDM__c>(); //MDM list
        //adding test MDM record
        ASI_eForm_HR_MDM__c tempMDM1 = new ASI_eForm_HR_MDM__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM'), Name='1234567', ASI_eForm_MDM_Department__c='tempHR', ASI_eForm_Employee_Korean_Name__c='Test',
                                                               ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='CFO', ASI_eForm_Employee_Bank_Account_Code__c='none', 
                                                               ASI_eForm_Employee_Bank_Name__c='none', ASI_eForm_Employee_Branch_Code__c='311-Finance', ASI_eForm_Employee_Is_Salesman__c=False, ASI_eForm_Employee_Gender__c='M', 
                                                               ASI_eForm_Employee_Work_Email__c='123.345@email.com', ASI_eForm_Employee_Company_Code__c='222', ASI_eForm_Employee_Eligible_PD__c = true);
        ASI_eForm_HR_MDM__c tempMDM2 = new ASI_eForm_HR_MDM__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM'), Name='1112223', ASI_eForm_MDM_Department__c='tempHR', ASI_eForm_Employee_Korean_Name__c='Test',
                                                               ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='Channel Sales Director', ASI_eForm_Employee_Bank_Account_Code__c='none', 
                                                               ASI_eForm_Employee_Bank_Name__c='none', ASI_eForm_Employee_Branch_Code__c='506-Central/Youngnam WS Director', ASI_eForm_Employee_Is_Salesman__c=True, ASI_eForm_Employee_Gender__c='M', 
                                                               ASI_eForm_Employee_Work_Email__c='123.345@email.com', ASI_eForm_Employee_Company_Code__c='286', ASI_eForm_Employee_Eligible_PD__c = true);
        ASI_eForm_HR_MDM__c tempMDM3 = new ASI_eForm_HR_MDM__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM'), Name='2223334', ASI_eForm_MDM_Department__c='tempHR', ASI_eForm_Employee_Korean_Name__c='Test',
                                                               ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='Sales Representative', ASI_eForm_Employee_Bank_Account_Code__c='none', 
                                                               ASI_eForm_Employee_Bank_Name__c='none', ASI_eForm_Employee_Branch_Code__c='523-MOT-Whisky', ASI_eForm_Employee_Is_Salesman__c=False, ASI_eForm_Employee_Gender__c='M', 
                                                               ASI_eForm_Employee_Work_Email__c='123.345@email.com', ASI_eForm_Employee_Company_Code__c='286', ASI_eForm_Employee_Eligible_PD__c = true);
        ASI_eForm_HR_MDM__c tempMDM4 = new ASI_eForm_HR_MDM__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_eForm_HR_MDM__cASI_eForm_KR_HR_MDM'), Name='3334445', ASI_eForm_MDM_Department__c='tempHR', ASI_eForm_Employee_Korean_Name__c='Test',
                                                               ASI_eForm_Employee_First_Name__c='ab', ASI_eForm_Employee_Last_Name__c='cd', ASI_eForm_Employee_Job_Title__c='Sales Representative', ASI_eForm_Employee_Bank_Account_Code__c='none', 
                                                               ASI_eForm_Employee_Bank_Name__c='none', ASI_eForm_Employee_Branch_Code__c='523-MOT-Whisky', ASI_eForm_Employee_Is_Salesman__c=True, ASI_eForm_Employee_Gender__c='M', 
                                                               ASI_eForm_Employee_Work_Email__c='123.345@email.com', ASI_eForm_Employee_Company_Code__c='286', ASI_eForm_Employee_Eligible_PD__c = true);
        tempMDMs.add(tempMDM1); //add to MDM list
        tempMDMs.add(tempMDM2); //add to MDM list
        tempMDMs.add(tempMDM3); //add to MDM list
        tempMDMs.add(tempMDM4); //add to MDM list
        insert tempMDMs;
        return tempMDMs;
    }

    public static List<ASI_TnE_Account_Mapping__c> createAcMapRecords()
    {   
        List<ASI_TnE_Account_Mapping__c> tempACMaps = new List<ASI_TnE_Account_Mapping__c>(); //accounting mapping list
        //adding accounting record
        ASI_TnE_Account_Mapping__c tempACMap1 = new ASI_TnE_Account_Mapping__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Account_Mapping__cASI_TnE_KR_Account_Mapping'),
                                                                               ASI_TnE_Account_Number__c='6130.100000',
                                                                               ASI_TnE_Country__c='KR',
                                                                               ASI_JP_TnE_Account_Name__c='Domestic Travel',
                                                                               ASI_JP_TnE_Account_Mapping_Order__c=70,
                                                                               ASI_TnE_KR_BS_Account__c = FALSE,
                                                                               ASI_TnE_KR_TnE_Budget__c = TRUE);
        ASI_TnE_Account_Mapping__c tempACMap2 = new ASI_TnE_Account_Mapping__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Account_Mapping__cASI_TnE_KR_Account_Mapping'),
                                                                               ASI_TnE_Account_Number__c='6130.400000',
                                                                               ASI_TnE_Country__c='KR',
                                                                               ASI_JP_TnE_Account_Name__c='Overseas Travel',
                                                                               ASI_JP_TnE_Account_Mapping_Order__c=110,
                                                                               ASI_TnE_KR_BS_Account__c = FALSE,
                                                                               ASI_TnE_KR_TnE_Budget__c = TRUE);
        ASI_TnE_Account_Mapping__c tempACMap3 = new ASI_TnE_Account_Mapping__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Account_Mapping__cASI_TnE_KR_Account_Mapping'),
                                                                               ASI_TnE_Account_Number__c='6160.500000',
                                                                               ASI_TnE_Country__c='KR',
                                                                               ASI_JP_TnE_Account_Name__c='Trade Relationship',
                                                                               ASI_JP_TnE_Account_Mapping_Order__c=130,
                                                                               ASI_TnE_KR_BS_Account__c = FALSE,
                                                                               ASI_TnE_KR_TnE_Budget__c = TRUE);
        ASI_TnE_Account_Mapping__c tempACMap4 = new ASI_TnE_Account_Mapping__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Account_Mapping__cASI_TnE_KR_Account_Mapping'),
                                                                               ASI_TnE_Account_Number__c='6160.900000',
                                                                               ASI_TnE_Country__c='KR',
                                                                               ASI_JP_TnE_Account_Name__c='Entertainment Suspense A&P',
                                                                               ASI_JP_TnE_Account_Mapping_Order__c=350,
                                                                               ASI_TnE_KR_BS_Account__c = FALSE,
                                                                               ASI_TnE_KR_TnE_Budget__c = FALSE);
        tempACMaps.add(tempACMap1); //add to ac map list
        tempACMaps.add(tempACMap2); //add to ac map list
        tempACMaps.add(tempACMap3); //add to ac map list
        tempACMaps.add(tempACMap4); //add to ac map list
        insert tempACMaps;
        return tempACMaps;
    }

    public static List<ASI_JP_TnE_Expense_Category__c> createExCatRecords()
    {
        List<ASI_JP_TnE_Expense_Category__c> tempCats = new List<ASI_JP_TnE_Expense_Category__c>(); //expense category list
        //adding temp expense category record
        ASI_JP_TnE_Expense_Category__c tempCat1 =
            new ASI_JP_TnE_Expense_Category__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Category__cASI_TnE_KR_Expense_Category'), 
                                               Name='T&E Domestic Travel', ASI_JP_TnE_Expense_Category_Order__c=10, 
                                               Name_en_US__c='T&E Domestic Travel', ASI_TnE_KR_Name__c='국내출장비');
        ASI_JP_TnE_Expense_Category__c tempCat2 = 
            new ASI_JP_TnE_Expense_Category__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Category__cASI_TnE_KR_Expense_Category'), 
                                               NAME='T&E Overseas Travel', ASI_JP_TnE_Expense_Category_Order__c=20, Name_en_US__c='T&E Overseas Travel', 
                                               ASI_TnE_KR_Name__c='해외출장비');
        ASI_JP_TnE_Expense_Category__c tempCat3 = 
            new ASI_JP_TnE_Expense_Category__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Category__cASI_TnE_KR_Expense_Category'), 
                                               NAME='T&E Entertainment', ASI_JP_TnE_Expense_Category_Order__c=30, NAME_EN_US__C='T&E Entertainment', 
                                               ASI_TnE_KR_Name__c='접대비');
        ASI_JP_TnE_Expense_Category__c tempCat4 = 
            new ASI_JP_TnE_Expense_Category__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Category__cASI_TnE_KR_Expense_Category'), 
                                               NAME='Wrong use', ASI_JP_TnE_Expense_Category_Order__c=30, NAME_EN_US__C='Wrong use', 
                                               ASI_TnE_KR_Name__c='카드 사용용도 오류');
        tempCats.add(tempCat1); //add to ex cat list
        tempCats.add(tempCat2); //add to ex cat list
        tempCats.add(tempCat3); //add to ex cat list
        tempCats.add(tempCat4); //add to ex cat list
        insert tempCats;
        return tempCats;
    }

    public static List<ASI_JP_TnE_Expense_Classification__c> createExClassRecords(List<ASI_JP_TnE_Expense_Category__c > tempCats, List<ASI_TnE_Account_Mapping__c> tempACMaps)
    {
        List<ASI_JP_TnE_Expense_Classification__c> tempClasses = new List<ASI_JP_TnE_Expense_Classification__c>(); //expense classficiation list
        //adding temp expense classficiation record
        ASI_JP_TnE_Expense_Classification__c tempClass1 = 
            new ASI_JP_TnE_Expense_Classification__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Classification__cASI_TnE_KR_Expense_Classification'),
                                                     Name='Fuel for non sales or NSD',
                                                     Name_en_US__c='Fuel for non sales or NSD', 
                                                     ASI_TnE_KR_Class_name__c='유류비_ 비영업 & 영업 (NSD)',
                                                     ASI_JP_TnE_Account_Mapping__c=tempACMaps[0].id,
                                                     ASI_JP_TNE_EXPENSE_CATEGORY__C=tempCats[0].Id);
        ASI_JP_TnE_Expense_Classification__c tempClass2 = 
            new ASI_JP_TnE_Expense_Classification__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Classification__cASI_TnE_KR_Expense_Classification'),
                                                     Name='Public Transportation (Airfare, bus, taxi, train….) for overseas business trip',
                                                     Name_en_US__c='Public Transportation (Airfare, bus, taxi, train….) for overseas business trip', 
                                                     ASI_TnE_KR_Class_name__c='해외출장시 교통비',
                                                     ASI_JP_TnE_Account_Mapping__c=tempACMaps[1].id,
                                                     ASI_JP_TNE_EXPENSE_CATEGORY__C=tempCats[1].Id);
        ASI_JP_TnE_Expense_Classification__c tempClass3 = 
            new ASI_JP_TnE_Expense_Classification__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Classification__cASI_TnE_KR_Expense_Classification'),
                                                     Name='Entertainment for WS & Venue',
                                                     Name_en_US__c='Entertainment for WS & Venue', 
                                                     ASI_TnE_KR_Class_name__c='접대비 (접대 상대방이 WS&Venue인 경우)',
                                                     ASI_JP_TnE_Account_Mapping__c=tempACMaps[2].id,
                                                     ASI_JP_TNE_EXPENSE_CATEGORY__C=tempCats[2].Id);
        ASI_JP_TnE_Expense_Classification__c tempClass4 = 
            new ASI_JP_TnE_Expense_Classification__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_JP_TnE_Expense_Classification__cASI_TnE_KR_Expense_Classification'),
                                                     Name='If A&P is used by T&E card',
                                                     Name_en_US__c='If A&P is used by T&E card', 
                                                     ASI_TnE_KR_Class_name__c='T&E카드 용도 오류_T&E 카드로 A&P 집행시',
                                                     ASI_JP_TnE_Account_Mapping__c=tempACMaps[3].id,
                                                     ASI_JP_TNE_EXPENSE_CATEGORY__C=tempCats[3].Id);
        tempClasses.add(tempClass1); //add to ex class list
        tempClasses.add(tempClass2); //add to ex class list
        tempClasses.add(tempClass3); //add to ex class list
        tempClasses.add(tempClass4); //add to ex class list
        insert tempClasses;
        return tempClasses;
    }

    public static List<ASI_KOR_Brand__c> createBrandRecords()
    {
        List<ASI_KOR_Brand__c> tempBrands = new List<ASI_KOR_Brand__c>(); //brand list
        //adding brand record
        ASI_KOR_Brand__c tempBrand1 = new ASI_KOR_Brand__c(Name='Ballantine 17YO', ASI_KOR_Brand_Code__c='BA4',
                                                           ASI_KOR_Sequence__c=200, ASI_KOR_Company__c='222');
        ASI_KOR_Brand__c tempBrand2 = new ASI_KOR_Brand__c(Name='BIS Imperial 17', ASI_KOR_Brand_Code__c='IM4',
                                                           ASI_KOR_Sequence__c=100, ASI_KOR_Company__c='286');
        tempBrands.add(tempBrand1); //add to brand list
        tempBrands.add(tempBrand2); //add to brand list
        insert tempBrands;
        return tempBrands;
    }

    public static List<ASI_KOR_Sub_Brand__c> createSubBrandRecords(List<ASI_KOR_Brand__c> tempBrands)
    {
        List<ASI_KOR_Sub_Brand__c> tempSubBrands = new List<ASI_KOR_Sub_Brand__c>(); //brand list
        //adding sub-brand record
        ASI_KOR_Sub_Brand__c tempSubBrand1 = new ASI_KOR_Sub_Brand__c(Name='Ballantine 17YO', ASI_KOR_Name_Kor__c='Ballantine 17YO',
                                                                      ASI_KOR_Sub_Brand_Code__c='BA4', ASI_KOR_KPI_Point__c=6,
                                                                      ASI_KOR_Brand__c=tempBrands[0].id, ASI_KOR_Brand_Code__c='BA4',
                                                                      ASI_KOR_Manufacturer__c='222', ASI_KOR_Active_for_A_P__c=True);
        ASI_KOR_Sub_Brand__c tempSubBrand2 = new ASI_KOR_Sub_Brand__c(Name='BIS IPC 17YO', ASI_KOR_Name_Kor__c='BIS IPC 17YO',
                                                                      ASI_KOR_Sub_Brand_Code__c='IM4', ASI_KOR_KPI_Point__c=2,
                                                                      ASI_KOR_Brand__c=tempBrands[1].id, ASI_KOR_Brand_Code__c='IM4',
                                                                      ASI_KOR_Manufacturer__c='286', ASI_KOR_Active_for_A_P__c=True);
        tempSubBrands.add(tempSubBrand1); //add to sub brand list
        tempSubBrands.add(tempSubBrand2); //add to sub brand list
        insert tempSubBrands;
        return tempSubBrands;
    }

    public static String createFY()
    {
        String fiscalYear;
        if(date.today().month()>7){
            fiscalYear = 'FY' + String.valueOf(date.today().year()-2000) + String.valueOf(date.today().year()-1999);
        }else if(date.today().month()<=7){
            fiscalYear = 'FY' + String.valueOf(date.today().year()-2001) + String.valueOf(date.today().year()-2000);
        }
        return fiscalYear;
    }

    public static List<ASI_TnE_Employee_Budget__c> createBudgetRecords(List<User> tempUsers, String fiscalYear)
    {
        List<ASI_TnE_Employee_Budget__c> tempBudgets = new List<ASI_TnE_Employee_Budget__c>(); //budget list
        //adding budget record
        ASI_TnE_Employee_Budget__c tempBudget1 = 
            new ASI_TnE_Employee_Budget__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Employee_Budget__cASI_TnE_KR_Employee_Budget'),
                                           OwnerID = tempUsers[0].id,
                                           ASI_TnE_Employee_No__c = '1234567',
                                           ASI_TnE_Entity__c = '222', ASI_TnE_Dept__c = '311',
                                           ASI_TnE_Fiscal_Year__c = fiscalYear,
                                           ASI_TnE_P1_Amount__c = 0, ASI_TnE_P2_Amount__c = 0,
                                           ASI_TnE_P3_Amount__c = 0, ASI_TnE_P4_Amount__c = 0,
                                           ASI_TnE_P5_Amount__c = 0, ASI_TnE_P6_Amount__c = 0,
                                           ASI_TnE_P7_Amount__c = 0, ASI_TnE_P8_Amount__c = 0,
                                           ASI_TnE_P9_Amount__c = 0, ASI_TnE_P10_Amount__c = 0,
                                           ASI_TnE_P11_Amount__c = 0, ASI_TnE_P12_Amount__c = 0);
        ASI_TnE_Employee_Budget__c tempBudget2 = 
            new ASI_TnE_Employee_Budget__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Employee_Budget__cASI_TnE_KR_Employee_Budget'),
                                           OwnerID = tempUsers[0].id,
                                           ASI_TnE_Employee_No__c = '1112223',
                                           ASI_TnE_Entity__c = '286', ASI_TnE_Dept__c = '506',
                                           ASI_TnE_Fiscal_Year__c = fiscalYear,
                                           ASI_TnE_P1_Amount__c = 0, ASI_TnE_P2_Amount__c = 0,
                                           ASI_TnE_P3_Amount__c = 0, ASI_TnE_P4_Amount__c = 0,
                                           ASI_TnE_P5_Amount__c = 0, ASI_TnE_P6_Amount__c = 0,
                                           ASI_TnE_P7_Amount__c = 0, ASI_TnE_P8_Amount__c = 0,
                                           ASI_TnE_P9_Amount__c = 0, ASI_TnE_P10_Amount__c = 0,
                                           ASI_TnE_P11_Amount__c = 0, ASI_TnE_P12_Amount__c = 0);
        ASI_TnE_Employee_Budget__c tempBudget3 = 
            new ASI_TnE_Employee_Budget__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Employee_Budget__cASI_TnE_KR_Employee_Budget'),
                                           OwnerID = tempUsers[0].id,
                                           ASI_TnE_Employee_No__c = '2223334',
                                           ASI_TnE_Entity__c = '286', ASI_TnE_Dept__c = '523',
                                           ASI_TnE_Fiscal_Year__c = fiscalYear,
                                           ASI_TnE_P1_Amount__c = 0, ASI_TnE_P2_Amount__c = 0,
                                           ASI_TnE_P3_Amount__c = 0, ASI_TnE_P4_Amount__c = 0,
                                           ASI_TnE_P5_Amount__c = 0, ASI_TnE_P6_Amount__c = 0,
                                           ASI_TnE_P7_Amount__c = 0, ASI_TnE_P8_Amount__c = 0,
                                           ASI_TnE_P9_Amount__c = 0, ASI_TnE_P10_Amount__c = 0,
                                           ASI_TnE_P11_Amount__c = 0, ASI_TnE_P12_Amount__c = 0);
        ASI_TnE_Employee_Budget__c tempBudget4 = 
            new ASI_TnE_Employee_Budget__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Employee_Budget__cASI_TnE_KR_Employee_Budget'),
                                           OwnerID = tempUsers[0].id,
                                           ASI_TnE_Employee_No__c = '3334445',
                                           ASI_TnE_Entity__c = '286', ASI_TnE_Dept__c = '523',
                                           ASI_TnE_Fiscal_Year__c = fiscalYear,
                                           ASI_TnE_P1_Amount__c = 0, ASI_TnE_P2_Amount__c = 0,
                                           ASI_TnE_P3_Amount__c = 0, ASI_TnE_P4_Amount__c = 0,
                                           ASI_TnE_P5_Amount__c = 0, ASI_TnE_P6_Amount__c = 0,
                                           ASI_TnE_P7_Amount__c = 0, ASI_TnE_P8_Amount__c = 0,
                                           ASI_TnE_P9_Amount__c = 0, ASI_TnE_P10_Amount__c = 0,
                                           ASI_TnE_P11_Amount__c = 0, ASI_TnE_P12_Amount__c = 0);
        tempBudgets.add(tempBudget1); //add to budget list
        tempBudgets.add(tempBudget2); //add to budget list
        tempBudgets.add(tempBudget3); //add to budget list
        tempBudgets.add(tempBudget4); //add to budget list
        insert tempBudgets;
        return tempBudgets;
    }

    public static List<ASI_MFM_Exchange_Rate__c> createExRateRecords(String fiscalYear)
    {
        List<ASI_MFM_Exchange_Rate__c> tempExRates = new List<ASI_MFM_Exchange_Rate__c>(); //exchange rate list
        //adding exchange rate record
        ASI_MFM_Exchange_Rate__c tempExRate1 = new ASI_MFM_Exchange_Rate__c(ASI_MFM_Base_Currency__c = 'KRW',
                                                                            ASI_MFM_Counter_Currency__c = 'JPY',
                                                                            ASI_MFM_Country__c = 'KR',
                                                                            ASI_MFM_Effective_Date__c = date.today()-90,
                                                                            ASI_MFM_Exchange_Rate__c = 19.099700,
                                                                            ASI_NPP_Fiscal_Year__c = fiscalYear,
                                                                            ASI_MFM_Application__c = 'T&E');
        ASI_MFM_Exchange_Rate__c tempExRate2 = new ASI_MFM_Exchange_Rate__c(ASI_MFM_Base_Currency__c = 'KRW',
                                                                            ASI_MFM_Counter_Currency__c = 'SGD',
                                                                            ASI_MFM_Country__c = 'KR',
                                                                            ASI_MFM_Effective_Date__c = date.today()-90,
                                                                            ASI_MFM_Exchange_Rate__c = 804.564000,
                                                                            ASI_NPP_Fiscal_Year__c = fiscalYear,
                                                                            ASI_MFM_Application__c = 'T&E');
        tempExRates.add(tempExRate1); //add to exchange rate list
        tempExRates.add(tempExRate2); //add to exchange rate list
        insert tempExRates;
        return tempExRates;
    }

    public static List<ASI_TnE_Branch_Channel__c> createBraChannelRecords()
    {
        List<ASI_TnE_Branch_Channel__c> tempBraChas = new List<ASI_TnE_Branch_Channel__c>(); //branch channel list
        //adding branch channel record
        ASI_TnE_Branch_Channel__c tempBraCha1 = new ASI_TnE_Branch_Channel__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Branch_Channel__cASI_TnE_KR_Branch_Channel'),
                                                                              Name = '1311000',
                                                                              ASI_TnE_Branch_Default__c = true);
        ASI_TnE_Branch_Channel__c tempBraCha2 = new ASI_TnE_Branch_Channel__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Branch_Channel__cASI_TnE_KR_Branch_Channel'),
                                                                              Name = '1506000',
                                                                              ASI_TnE_Branch_Default__c = true);
        ASI_TnE_Branch_Channel__c tempBraCha3 = new ASI_TnE_Branch_Channel__c(RecordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Branch_Channel__cASI_TnE_KR_Branch_Channel'),
                                                                              Name = '1523000',
                                                                              ASI_TnE_Branch_Default__c = true);
        tempBraChas.add(tempBraCha1); //add to branch channel list
        tempBraChas.add(tempBraCha2); //add to branch channel list
        tempBraChas.add(tempBraCha3); //add to branch channel list
        insert tempBraChas;
        return tempBraChas;
    }

    public static List<ASI_CRM_AccountsAdditionalField__c> createCustomerRecords(List<User> tempUsers)
    {
        List<ASI_CRM_AccountsAdditionalField__c> tempCustomers = new List<ASI_CRM_AccountsAdditionalField__c>(); //customer list
        //adding customer record
        ASI_CRM_AccountsAdditionalField__c tempCustomer1 = 
            new ASI_CRM_AccountsAdditionalField__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_KR_Wholesaler'),
                                                   Name='SeJu', OwnerID=tempUsers[1].id);
        ASI_CRM_AccountsAdditionalField__c tempCustomer2 = 
            new ASI_CRM_AccountsAdditionalField__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_CRM_AccountsAdditionalField__cASI_CRM_KR_Venue'),
                                                   Name='JOO BAR', OwnerID=tempUsers[3].id);
        tempCustomers.add(tempCustomer1); //add to customer list
        tempCustomers.add(tempCustomer2); //add to customer list
        insert tempCustomers;
        return tempCustomers;
    }

    public static List<ASI_TnE_Corp_Card_Employee_Mapping__c> createCardMapRecords(List<User> tempUsers)
    {
        List<ASI_TnE_Corp_Card_Employee_Mapping__c> tempCardMaps = new List<ASI_TnE_Corp_Card_Employee_Mapping__c>();

        ASI_TnE_Corp_Card_Employee_Mapping__c tempCardMap1 = 
            new ASI_TnE_Corp_Card_Employee_Mapping__c(ASI_TnE_Assistant_Name__c = tempUsers[3].id,
                                                      ASI_TnE_Card_Number_1__c = '1111-1111-1111-1111',
                                                      ASI_TnE_Employee_Name__c = tempUsers[3].id,
                                                      ASI_TnE_KR_Card_Type__c = 'T&E Card',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Employee_Mapping__cTnE_KR_Corp_Card_Employee_Mapping'));
        ASI_TnE_Corp_Card_Employee_Mapping__c tempCardMap2 = 
            new ASI_TnE_Corp_Card_Employee_Mapping__c(ASI_TnE_Assistant_Name__c = tempUsers[1].id,
                                                      ASI_TnE_Card_Number_1__c = '2222-2222-2222-2222',
                                                      ASI_TnE_Employee_Name__c = tempUsers[3].id,
                                                      ASI_TnE_KR_Card_Type__c = 'T&E Card',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Employee_Mapping__cTnE_KR_Corp_Card_Employee_Mapping'));
        ASI_TnE_Corp_Card_Employee_Mapping__c tempCardMap3 = 
            new ASI_TnE_Corp_Card_Employee_Mapping__c(ASI_TnE_Assistant_Name__c = tempUsers[3].id,
                                                      ASI_TnE_Card_Number_1__c = '3333-3333-3333-3333',
                                                      ASI_TnE_Employee_Name__c = tempUsers[3].id,
                                                      ASI_TnE_KR_Card_Type__c = 'A&P Card',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Employee_Mapping__cTnE_KR_Corp_Card_Employee_Mapping'));
        ASI_TnE_Corp_Card_Employee_Mapping__c tempCardMap4 = 
            new ASI_TnE_Corp_Card_Employee_Mapping__c(ASI_TnE_Assistant_Name__c = tempUsers[1].id,
                                                      ASI_TnE_Card_Number_1__c = '4444-4444-4444-4444',
                                                      ASI_TnE_Employee_Name__c = tempUsers[3].id,
                                                      ASI_TnE_KR_Card_Type__c = 'A&P Card',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Employee_Mapping__cTnE_KR_Corp_Card_Employee_Mapping'));
        tempCardMaps.add(tempCardMap1);
        tempCardMaps.add(tempCardMap2);
        tempCardMaps.add(tempCardMap3);
        tempCardMaps.add(tempCardMap4);
        insert tempCardMaps;
        return tempCardMaps;
    }

    public static List<ASI_TnE_Corp_Card_Statement_Upload__c> createInTrayRecords(Date d, List<User> tempUsers)
    {
        List<ASI_TnE_Corp_Card_Statement_Upload__c> tempInTrays = new List<ASI_TnE_Corp_Card_Statement_Upload__c>(); 

        ASI_TnE_Corp_Card_Statement_Upload__c tempInTray1 = 
            new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempUsers[4].Id,
                                                      ASI_TnE_Card_Number__c = '1111-1111-1111-1111',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                      ASI_TnE_KR_Year__c = String.valueOf(d.year()),
                                                      ASI_TnE_KR_Month__c = String.valueOf(d.month()-1),
                                                      ASI_TnE_Charge_Date__c = d,
                                                      ASI_TnE_Charge_Time__c = '15:01:49',
                                                      ASI_TnE_KR_Approval_Number__c = '11223344',
                                                      ASI_TnE_Full_Name__c = 'Name 1',
                                                      ASI_TnE_Business_Address__c = 'Address 1',
                                                      ASI_TnE_Amount__c = 100);
        ASI_TnE_Corp_Card_Statement_Upload__c tempInTray2 = 
            new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempUsers[4].Id,
                                                      ASI_TnE_Card_Number__c = '3333-3333-3333-3333',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                      ASI_TnE_KR_Year__c = String.valueOf(d.year()),
                                                      ASI_TnE_KR_Month__c = String.valueOf(d.month()-1),
                                                      ASI_TnE_Charge_Date__c = d,
                                                      ASI_TnE_Charge_Time__c = '15:02:51',
                                                      ASI_TnE_KR_Approval_Number__c = '22114433',
                                                      ASI_TnE_Full_Name__c = 'Name 2',
                                                      ASI_TnE_Business_Address__c = 'Address 2',
                                                      ASI_TnE_Amount__c = 200);
        ASI_TnE_Corp_Card_Statement_Upload__c tempInTray3 = 
            new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempUsers[4].Id,
                                                      ASI_TnE_Card_Number__c = '9999-9999-9999-9999',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                      ASI_TnE_KR_Year__c = String.valueOf(d.year()),
                                                      ASI_TnE_KR_Month__c = String.valueOf(d.month()-1),
                                                      ASI_TnE_Charge_Date__c = d,
                                                      ASI_TnE_Charge_Time__c = '15:02:51',
                                                      ASI_TnE_KR_Approval_Number__c = '88994466',
                                                      ASI_TnE_Full_Name__c = 'Name 3',
                                                      ASI_TnE_Business_Address__c = 'Address 3',
                                                      ASI_TnE_Amount__c = 200);
        ASI_TnE_Corp_Card_Statement_Upload__c tempInTray4 = 
            new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempUsers[4].Id,
                                                      ASI_TnE_Card_Number__c = '2222-2222-2222-2222',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                      ASI_TnE_KR_Year__c = String.valueOf(d.year()),
                                                      ASI_TnE_KR_Month__c = String.valueOf(d.month()-1),
                                                      ASI_TnE_Charge_Date__c = d,
                                                      ASI_TnE_Charge_Time__c = '15:02:51',
                                                      ASI_TnE_KR_Approval_Number__c = '66993355',
                                                      ASI_TnE_Full_Name__c = 'Name 4',
                                                      ASI_TnE_Business_Address__c = 'Address 4',
                                                      ASI_TnE_Amount__c = 200);
        ASI_TnE_Corp_Card_Statement_Upload__c tempInTray5 = 
            new ASI_TnE_Corp_Card_Statement_Upload__c(OwnerId = tempUsers[4].Id,
                                                      ASI_TnE_Card_Number__c = '4444-4444-4444-4444',
                                                      recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_Corp_Card_Statement_Upload__cTnE_KR_Corp_Card_Upload'),
                                                      ASI_TnE_KR_Year__c = String.valueOf(d.year()),
                                                      ASI_TnE_KR_Month__c = String.valueOf(d.month()-1),
                                                      ASI_TnE_Charge_Date__c = d,
                                                      ASI_TnE_Charge_Time__c = '15:02:51',
                                                      ASI_TnE_KR_Approval_Number__c = '77221188',
                                                      ASI_TnE_Full_Name__c = 'Name 5',
                                                      ASI_TnE_Business_Address__c = 'Address 5',
                                                      ASI_TnE_Amount__c = 200);
        tempInTrays.add(tempInTray1);
        tempInTrays.add(tempInTray2);
        tempInTrays.add(tempInTray3);
        tempInTrays.add(tempInTray4);
        tempInTrays.add(tempInTray5);
        insert tempInTrays;
        return tempInTrays;
    }

    public static List<ASI_TnE_ClaimHeader__c> createMassCreateNUpdateHeaderTestRecord(List<User> tempUsers)
    {
        List<ASI_TnE_ClaimHeader__c> tempHeaders = new List<ASI_TnE_ClaimHeader__c>(); //claim header list
        //adding header claim record
        ASI_TnE_ClaimHeader__c tempHeader1 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Additional_Approver_1__c = tempUsers[2].id,
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111');
        ASI_TnE_ClaimHeader__c tempHeader2 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Additional_Approver_1__c = tempUsers[2].id,
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111');
        ASI_TnE_ClaimHeader__c tempHeader3 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '2222-2222-2222-2222');
        ASI_TnE_ClaimHeader__c tempHeader4 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE_Finance_View'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '2222-2222-2222-2222');
        tempHeaders.add(tempHeader1); //add to header claim list
        tempHeaders.add(tempHeader2); //add to header claim list
        tempHeaders.add(tempHeader3); //add to header claim list
        tempHeaders.add(tempHeader4); //add to header claim list
        insert tempHeaders;
        return tempHeaders;
    }

    public static List<ASI_TnE_ClaimDetail__c> createMassCreateNUpdateDetailTestRecord(List<ASI_TnE_ClaimHeader__c> tempHeaders,
                                                                                       List<ASI_KOR_Sub_Brand__c> tempSubBrands,
                                                                                       List<ASI_JP_TnE_Expense_Category__c> tempCats,
                                                                                       List<ASI_JP_TnE_Expense_Classification__c> tempClasses,
                                                                                       List<ASI_CRM_AccountsAdditionalField__c> tempCustomers)
    {
        List<ASI_TnE_ClaimDetail__c> tempDetails = new List<ASI_TnE_ClaimDetail__c>();
        //adding claim detail record
        ASI_TnE_ClaimDetail__c tempDetail1 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[0].id,
                                       ASI_TnE_Dept_in_Charge__c = 'Brand MKT',
                                       ASI_TnE_KR_Sub_Brand__c = tempSubBrands[1].id,
                                       ASI_TnE_Promotion_Code__c = '11111111',
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 10);
        ASI_TnE_ClaimDetail__c tempDetail2 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[1].id,
                                       ASI_TnE_Dept_in_Charge__c = 'Brand MKT',
                                       ASI_TnE_KR_Sub_Brand__c = tempSubBrands[1].id,
                                       ASI_TnE_Promotion_Code__c = '22222222',
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 15);
        ASI_TnE_ClaimDetail__c tempDetail3 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[2].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 20,
                                       ASI_TnE_Expense_Category__c = tempCats[0].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[0].id,
                                       ASI_TnE_KR_Customer__c=tempCustomers[0].id);
        ASI_TnE_ClaimDetail__c tempDetail4 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[3].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25,
                                       ASI_TnE_Expense_Category__c = tempCats[1].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[1].id,
                                       ASI_TnE_KR_Customer__c=tempCustomers[1].id);
        tempDetails.add(tempDetail1); //add to claim detail list
        tempDetails.add(tempDetail2); //add to claim detail list
        tempDetails.add(tempDetail3); //add to claim detail list
        tempDetails.add(tempDetail4); //add to claim detail list
        insert tempDetails;
        return tempDetails;
    }

    public static List<ASI_TnE_ClaimHeader__c> createHeaderTriggerTestRecord(List<User> tempUsers)
    {
        List<ASI_TnE_ClaimHeader__c> tempHeaders = new List<ASI_TnE_ClaimHeader__c>(); //claim header list
        //adding header claim record
        ASI_TnE_ClaimHeader__c tempHeader1 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_Cash'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1));
        ASI_TnE_ClaimHeader__c tempHeader2 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111');
        ASI_TnE_ClaimHeader__c tempHeader3 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[1].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '2222-2222-2222-2222',
                                       ASI_TnE_KR_Additional_Approver_1__c = tempUsers[2].id,
                                       ASI_TnE_KR_Additional_Approver_2__c = tempUsers[2].id,
                                       ASI_TnE_KR_Additional_Approver_3__c = tempUsers[2].id,
                                       ASI_TnE_KR_Additional_Approver_4__c = tempUsers[2].id,
                                       ASI_TnE_KR_Additional_Approver_5__c = tempUsers[2].id,
                                       ASI_TnE_KR_Budget_Owner_1__c = tempUsers[2].id,
                                       ASI_TnE_KR_Budget_Owner_2__c = tempUsers[2].id,
                                       ASI_TnE_KR_Budget_Owner_3__c = tempUsers[2].id,
                                       ASI_TnE_KR_Budget_Owner_4__c = tempUsers[2].id,
                                       ASI_TnE_KR_Budget_Owner_5__c = tempUsers[2].id,
                                       ASI_TnE_KR_CoApprover_1__c = tempUsers[2].id,
                                       ASI_TnE_KR_CoApprover_2__c = tempUsers[2].id,
                                       ASI_TnE_KR_CoApprover_3__c = tempUsers[2].id,
                                       ASI_TnE_KR_CoApprover_4__c = tempUsers[2].id,
                                       ASI_TnE_KR_CoApprover_5__c = tempUsers[2].id);
        ASI_TnE_ClaimHeader__c tempHeader4 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '2222-2222-2222-2222');
        tempHeaders.add(tempHeader1); //add to header claim list
        tempHeaders.add(tempHeader2); //add to header claim list
        tempHeaders.add(tempHeader3); //add to header claim list
        tempHeaders.add(tempHeader4); //add to header claim list
        insert tempHeaders;
        return tempHeaders;
    }

    public static List<ASI_TnE_ClaimDetail__c> createDetailTriggerTestRecord(List<ASI_TnE_ClaimHeader__c> tempHeaders,
                                                                             List<ASI_KOR_Sub_Brand__c> tempSubBrands,
                                                                             List<ASI_JP_TnE_Expense_Category__c> tempCats,
                                                                             List<ASI_JP_TnE_Expense_Classification__c> tempClasses,
                                                                             List<ASI_CRM_AccountsAdditionalField__c> tempCustomers,
                                                                             List<User> tempUsers)
    {
        List<ASI_TnE_ClaimDetail__c> tempDetails = new List<ASI_TnE_ClaimDetail__c>();
        //adding claim detail record
        ASI_TnE_ClaimDetail__c tempDetail1 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[0].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25
                                      );
        ASI_TnE_ClaimDetail__c tempDetail2 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[1].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 10);
        ASI_TnE_ClaimDetail__c tempDetail3 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[1].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Promotion_Code__c = '1111111',
                                       ASI_TnE_KR_Sub_Brand__c = tempSubBrands[0].Id,
                                       ASI_TnE_Receipt_Amount__c = 10);
        ASI_TnE_ClaimDetail__c tempDetail4 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[1].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Promotion_Code__c = '1111111',
                                       ASI_TnE_KR_Sub_Brand__c = tempSubBrands[1].Id,
                                       ASI_TnE_Receipt_Amount__c = 10);
        ASI_TnE_ClaimDetail__c tempDetail5 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[2].id,
                                       ASI_TnE_Receipt_Amount__c = 20
                                      );
        ASI_TnE_ClaimDetail__c tempDetail6 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_Currency__c = 'JPY',
                                       ASI_TnE_KR_Owner__c = tempUsers[2].Id,
                                       ASI_TnE_ClaimHeader__c = tempHeaders[3].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25,
                                       ASI_TnE_Expense_Category__c = tempCats[3].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[3].id);
        ASI_TnE_ClaimDetail__c tempDetail7 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[3].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25,
                                       ASI_TnE_Expense_Category__c = tempCats[0].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[0].id);
        tempDetails.add(tempDetail1); //add to claim detail list
        tempDetails.add(tempDetail2); //add to claim detail list
        tempDetails.add(tempDetail3); //add to claim detail list
        tempDetails.add(tempDetail4); //add to claim detail list
        tempDetails.add(tempDetail5); //add to claim detail list
        tempDetails.add(tempDetail6); //add to claim detail list
        tempDetails.add(tempDetail7); //add to claim detail list
        insert tempDetails;
        return tempDetails;
    }

    public static List<ASI_TnE_ClaimHeader__c> createGeneralHeaderRecord(List<User> tempUsers)
    {
        List<ASI_TnE_ClaimHeader__c> tempHeaders = new List<ASI_TnE_ClaimHeader__c>(); //claim header list
        //adding header claim record
        ASI_TnE_ClaimHeader__c tempHeader1 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_Cash'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1));
        ASI_TnE_ClaimHeader__c tempHeader2 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_AnP'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Draft', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '3333-3333-3333-3333',
                                       ASI_TnE_KR_External_ID__c = '3333-3333-3333-3333~'+String.valueOf(date.today().month()-1)+'/'+String.valueOf(date.today().year()));
        ASI_TnE_ClaimHeader__c tempHeader3 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Submitted', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '1111-1111-1111-1111',
                                       ASI_TnE_KR_External_ID__c = '1111-1111-1111-1111~'+String.valueOf(date.today().month()-1)+'/'+String.valueOf(date.today().year()));
         ASI_TnE_ClaimHeader__c tempHeader4 = 
            new ASI_TnE_ClaimHeader__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimHeader__cASI_TnE_KR_TnE'),
                                       OwnerID = tempUsers[3].id, ASI_TnE_KR_Payee__c = tempUsers[3].id,
                                       ASI_TnE_Status__c = 'Submitted', ASI_TnE_Date__c = date.today(),
                                       ASI_TnE_KR_Year__c = String.valueOf(date.today().year()),
                                       ASI_TnE_KR_Month__c = String.valueOf(date.today().month()-1),
                                       ASI_TnE_KR_Credit_Card_No__c = '2222-2222-2222-2222',
                                       ASI_TnE_KR_External_ID__c = '2222-2222-2222-2222~'+String.valueOf(date.today().month()-1)+'/'+String.valueOf(date.today().year()));
        tempHeaders.add(tempHeader1); //add to header claim list
        tempHeaders.add(tempHeader2); //add to header claim list
        tempHeaders.add(tempHeader3); //add to header claim list
        tempHeaders.add(tempHeader4); //add to header claim list
        insert tempHeaders;
        return tempHeaders;
    }

    public static List<ASI_TnE_ClaimDetail__c> createGeneralDetailRecord(List<ASI_TnE_ClaimHeader__c> tempHeaders,
                                                                         List<ASI_KOR_Sub_Brand__c> tempSubBrands,
                                                                         List<ASI_JP_TnE_Expense_Category__c> tempCats,
                                                                         List<ASI_JP_TnE_Expense_Classification__c> tempClasses,
                                                                         List<ASI_CRM_AccountsAdditionalField__c> tempCustomers,
                                                                         List<User> tempUsers,
                                                                         List<ASI_GnH_Request__c> gnhRequestList)
    {
        List<ASI_TnE_ClaimDetail__c> tempDetails = new List<ASI_TnE_ClaimDetail__c>();
        //adding claim detail record
        ASI_TnE_ClaimDetail__c tempDetail1 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[0].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25,
                                       ASI_TnE_Expense_Category__c = tempCats[0].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[0].id,
                                       ASI_TnE_GnH_Request__c = gnhRequestList[0].Id);
        ASI_TnE_ClaimDetail__c tempDetail2 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[1].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 10,
                                       ASI_TnE_GnH_Request__c = gnhRequestList[0].Id);
        ASI_TnE_ClaimDetail__c tempDetail3 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[1].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Promotion_Code__c = '1111111',
                                       ASI_TnE_KR_Sub_Brand__c = tempSubBrands[0].Id,
                                       ASI_TnE_Receipt_Amount__c = 10,
                                       ASI_TnE_GnH_Request__c = gnhRequestList[1].Id);
        ASI_TnE_ClaimDetail__c tempDetail4 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[2].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25,
                                       ASI_TnE_Expense_Category__c = tempCats[1].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[1].id,
                                       ASI_TnE_GnH_Request__c = gnhRequestList[2].Id);
        ASI_TnE_ClaimDetail__c tempDetail5 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[2].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25,
                                       ASI_TnE_Expense_Category__c = tempCats[0].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[0].id,
                                       ASI_TnE_GnH_Request__c = gnhRequestList[2].Id);
        ASI_TnE_ClaimDetail__c tempDetail6 = 
            new ASI_TnE_ClaimDetail__c(recordTypeId = Global_RecordTypeCache.getRtId('ASI_TnE_ClaimDetail__cASI_TnE_KR_Claim_Detail'),
                                       ASI_TnE_ClaimHeader__c = tempHeaders[3].id,
                                       ASI_TnE_Receipt_Date__c = date.today()-60,
                                       ASI_TnE_Receipt_Amount__c = 25000,
                                       ASI_TnE_Expense_Category__c = tempCats[1].id,
                                       ASI_TnE_Expense_Classification__c = tempClasses[0].id,
                                       ASI_TnE_GnH_Request__c = gnhRequestList[2].Id);
        tempDetails.add(tempDetail1); //add to claim detail list
        tempDetails.add(tempDetail2); //add to claim detail list
        tempDetails.add(tempDetail3); //add to claim detail list
        tempDetails.add(tempDetail4); //add to claim detail list
        tempDetails.add(tempDetail5); //add to claim detail list
        tempDetails.add(tempDetail6); //add to claim detail list
        insert tempDetails;
        return tempDetails;
    }

    /**********************
        updated 20/06/2017
        By:[Laputa] Kevin Choi
        ***********************/
    public static List<ASI_GnH_Recipient_Master__c>  createRecipientMasterData(){
        List<ASI_GnH_Recipient_Master__c> recipientMasterList = new List<ASI_GnH_Recipient_Master__c>();
        ASI_GnH_Recipient_Master__c master1 = new ASI_GnH_Recipient_Master__c(Name='test1',
                                                                              RecordTypeId= Global_RecordTypeCache.getRtId('ASI_GnH_Recipient_Master__cASI_GnH_KR_Recipient_Master'),
                                                                              ASI_GnH_Title__c='title1',
                                                                              ASI_GnH_Organization__c='organisation1',
                                                                              ASI_GnH_Mobile__c='12345678',
                                                                              ASI_GnH_Email__c='test1@test.com' 
                                                                             );

        ASI_GnH_Recipient_Master__c master2 = new ASI_GnH_Recipient_Master__c(Name='test2',
                                                                              RecordTypeId= Global_RecordTypeCache.getRtId('ASI_GnH_Recipient_Master__cASI_GnH_KR_Recipient_Master'),
                                                                              ASI_GnH_Title__c='title2',
                                                                              ASI_GnH_Organization__c='organisation2',
                                                                              ASI_GnH_Mobile__c='12345678',
                                                                              ASI_GnH_Email__c='test2@test.com' 
                                                                             );

        ASI_GnH_Recipient_Master__c master3 = new ASI_GnH_Recipient_Master__c(Name='test3',
                                                                              RecordTypeId= Global_RecordTypeCache.getRtId('ASI_GnH_Recipient_Master__cASI_GnH_KR_Recipient_Master'),
                                                                              ASI_GnH_Title__c='title3',
                                                                              ASI_GnH_Organization__c='organisation3',
                                                                              ASI_GnH_Mobile__c='12345678',
                                                                              ASI_GnH_Email__c='test3@test.com' 
                                                                             );

        ASI_GnH_Recipient_Master__c master4 = new ASI_GnH_Recipient_Master__c(Name='test4',
                                                                              RecordTypeId= Global_RecordTypeCache.getRtId('ASI_GnH_Recipient_Master__cASI_GnH_KR_Recipient_Master'),
                                                                              ASI_GnH_Title__c='title4',
                                                                              ASI_GnH_Organization__c='organisation4',
                                                                              ASI_GnH_Mobile__c='12345678',
                                                                              ASI_GnH_Email__c='test4@test.com' 
                                                                             );

        ASI_GnH_Recipient_Master__c master5 = new ASI_GnH_Recipient_Master__c(Name='test5',
                                                                              RecordTypeId= Global_RecordTypeCache.getRtId('ASI_GnH_Recipient_Master__cASI_GnH_KR_Recipient_Master'),
                                                                              ASI_GnH_Title__c='title5',
                                                                              ASI_GnH_Organization__c='organisation5',
                                                                              ASI_GnH_Mobile__c='12345678',
                                                                              ASI_GnH_Email__c='test5@test.com' 
                                                                             );

        ASI_GnH_Recipient_Master__c master6 = new ASI_GnH_Recipient_Master__c(Name='test6',
                                                                              RecordTypeId= Global_RecordTypeCache.getRtId('ASI_GnH_Recipient_Master__cASI_GnH_KR_Recipient_Master'),
                                                                              ASI_GnH_Title__c='title6',
                                                                              ASI_GnH_Organization__c='organisation6',
                                                                              ASI_GnH_Mobile__c='12345678',
                                                                              ASI_GnH_Email__c='test6@test.com' 
                                                                             );
        recipientMasterList.add(master1);
        recipientMasterList.add(master2);
        recipientMasterList.add(master3);
        recipientMasterList.add(master4);
        recipientMasterList.add(master5);
        recipientMasterList.add(master6);
        insert recipientMasterList;
        return recipientMasterList;
    }

    public static List<ASI_GnH_Actual_Recipient__c> createActualrecipientData (List<ASI_TnE_ClaimDetail__c> tempDetails, List<ASI_GnH_Recipient_Master__c> tempRecipientMaster){
        List<ASI_GnH_Actual_Recipient__c> actualRecipientList = new List<ASI_GnH_Actual_Recipient__c>();

        ASI_GnH_Actual_Recipient__c recipient1 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[0].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[0].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient2 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[1].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[1].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient3 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[2].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[2].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient4 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[3].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[3].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient5 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[4].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[4].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient6 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[0].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[1].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient7 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[3].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[2].Id
                                                                                );
        ASI_GnH_Actual_Recipient__c recipient8 = new ASI_GnH_Actual_Recipient__c(ASI_TnE_Details__c = tempDetails[5].Id,
                                                                                 ASI_GnH_Recipient__c = tempRecipientMaster[0].Id
                                                                                );
        actualRecipientList.add(recipient1);
        actualRecipientList.add(recipient2);
        actualRecipientList.add(recipient3);
        actualRecipientList.add(recipient4);
        actualRecipientList.add(recipient5);
        actualRecipientList.add(recipient6);
        actualRecipientList.add(recipient7);
        actualRecipientList.add(recipient8);
        insert actualRecipientList;
        return actualRecipientList;
    }

    public static List<ASI_GnH_Request__c> createGnHRequest(List<User> tempUser){
        List<ASI_GnH_Request__c> gnhRequestList = new List<ASI_GnH_Request__c>();
        
        Id krRequestRt = Global_RecordTypeCache.getRtId('ASI_GnH_Request__cASI_GnH_KR_Offer_Request_Read_Only');

        ASI_GnH_Request__c gnhRequest1 = new ASI_GnH_Request__c(recordTypeId = krRequestRt,
                                                                ASI_GnH_Applicant__c = tempUser[0].Id,
                                                                ASI_GnH_Recipient_Type__c ='Others',
                                                                ASI_GnH_Type__c ='Gifts',
                                                                ASI_GnH_Amount_per_Recipient__c = 300000 ,
                                                                ASI_GnH_PAX__c = 1,
                                                                ASI_GnH_Purpose__c = 'test purpose',
                                                                ASI_GnH_Status__c = 'Approved',
                                                                ASI_GnH_Nature_of_Report__c = 'Pre-approval',
                                                                ASI_GnH_Benefit_Date__c = date.today()
                                                               );
        ASI_GnH_Request__c gnhRequest2 = new ASI_GnH_Request__c(recordTypeId = krRequestRt,
                                                                ASI_GnH_Applicant__c = tempUser[0].Id,
                                                                ASI_GnH_Recipient_Type__c = 'Others',
                                                                ASI_GnH_Type__c ='Hospitality',
                                                                ASI_GnH_Amount_per_Recipient__c = 400000 ,
                                                                ASI_GnH_PAX__c = 2,
                                                                ASI_GnH_Purpose__c = 'test purpose1',
                                                                ASI_GnH_Status__c = 'Approved',
                                                                ASI_GnH_Nature_of_Report__c = 'Pre-approval',
                                                                ASI_GnH_Benefit_Date__c = date.today()
                                                               );
        ASI_GnH_Request__c gnhRequest3 = new ASI_GnH_Request__c(recordTypeId = krRequestRt,
                                                                ASI_GnH_Applicant__c = tempUser[1].Id,
                                                                ASI_GnH_Recipient_Type__c = 'Others',
                                                                ASI_GnH_Type__c = 'Gifts',
                                                                ASI_GnH_Amount_per_Recipient__c = 300000 ,
                                                                ASI_GnH_PAX__c = 4,
                                                                ASI_GnH_Purpose__c = 'test purpose',
                                                                ASI_GnH_Status__c = 'Approved',
                                                                ASI_GnH_Nature_of_Report__c = 'Pre-approval',
                                                                ASI_GnH_Benefit_Date__c = date.today()
                                                               );
        ASI_GnH_Request__c gnhRequest4 = new ASI_GnH_Request__c(recordTypeId = krRequestRt,
                                                                ASI_GnH_Applicant__c = tempUser[1].Id,
                                                                ASI_GnH_Recipient_Type__c ='Others',
                                                                ASI_GnH_Type__c ='C&C',
                                                                ASI_GnH_Amount_per_Recipient__c = 3000000 ,
                                                                ASI_GnH_PAX__c = 2,
                                                                ASI_GnH_Purpose__c = 'test purpose',
                                                                ASI_GnH_Status__c = 'Approved',
                                                                ASI_GnH_Nature_of_Report__c = 'Pre-approval',
                                                                ASI_GnH_Benefit_Date__c = date.today()
                                                               );
        ASI_GnH_Request__c gnhRequest5 = new ASI_GnH_Request__c(recordTypeId = krRequestRt,
                                                                ASI_GnH_Applicant__c = tempUser[2].Id,
                                                                ASI_GnH_Recipient_Type__c = 'Others',
                                                                ASI_GnH_Type__c = 'Gifts',
                                                                ASI_GnH_Amount_per_Recipient__c = 400000 ,
                                                                ASI_GnH_PAX__c = 3,
                                                                ASI_GnH_Purpose__c ='test purpose',
                                                                ASI_GnH_Status__c ='Approved',
                                                                ASI_GnH_Nature_of_Report__c ='Pre-approval',
                                                                ASI_GnH_Benefit_Date__c = date.today()
                                                               );

        gnhRequestList.add(gnhRequest1);
        gnhRequestList.add(gnhRequest2);
        gnhRequestList.add(gnhRequest3);
        gnhRequestList.add(gnhRequest4);
        gnhRequestList.add(gnhRequest5);
        insert gnhRequestList;
        return gnhRequestList;
    }

    public static List<ASI_GnH_Request_Recipient__c> createRequestrecipient(List<ASI_GnH_Request__c> gnhRequests, List<ASI_GnH_Recipient_Master__c> tempRecipientMaster){
        List<ASI_GnH_Request_Recipient__c> requestRecipientList = new List<ASI_GnH_Request_Recipient__c>();
        
        Id krRequestRecipientRt = Global_RecordTypeCache.getRtId('ASI_GnH_Request_Recipient__cASI_GnH_KR_Request_Recipient');

        ASI_GnH_Request_Recipient__c recipient1 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[0].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[0].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient2 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[1].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[0].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient3 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[2].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[0].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient4 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[3].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[0].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient5 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[0].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[1].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient6 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[0].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[2].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient7 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[1].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[2].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );

        ASI_GnH_Request_Recipient__c recipient8 = new ASI_GnH_Request_Recipient__c(ASI_GnH_Recipient__c = tempRecipientMaster[3].Id,
                                                                                   ASI_GnH_Request__c = gnhRequests[3].Id,
                                                                                   recordTypeId = krRequestRecipientRt
                                                                                  );


        requestRecipientList.add(recipient1);
        requestRecipientList.add(recipient2);
        requestRecipientList.add(recipient3);
        requestRecipientList.add(recipient4);
        requestRecipientList.add(recipient5);
        requestRecipientList.add(recipient6);
        requestRecipientList.add(recipient7);
        requestRecipientList.add(recipient8);
        insert requestRecipientList;
        return requestRecipientList;
    }

    public static List<ASI_GnH_KR_Default_Setting__c> createCustomSetting(){
        List<ASI_GnH_KR_Default_Setting__c> customSettingList = new List<ASI_GnH_KR_Default_Setting__c>();
        
		Decimal percentage10 = 10;
        Decimal percentage20 = 20;
        ASI_GnH_KR_Default_Setting__c setting1 = new ASI_GnH_KR_Default_Setting__c(Name = 'ASI_GnH_TnE_Threshold_Tolerance',
                                                                                   ASI_GnH_Percent__c = percentage10,
                                                                                   ASI_GnH_Record_Type__c = 'ASI_TnE_KR_Claim_Detail',
                                                                                   ASI_GnH_Object__c = 'ASI_TnE_ClaimDetail__c'    
                                                                                  );

        ASI_GnH_KR_Default_Setting__c setting2 = new ASI_GnH_KR_Default_Setting__c(Name = 'ASI_GnH_TnE_Threshold_Tolerance2',
                                                                                   ASI_GnH_Percent__c = percentage20,
                                                                                   ASI_GnH_Record_Type__c = 'ASI_TnE_KR_Claim_Detail',
                                                                                   ASI_GnH_Object__c = 'ASI_TnE_ClaimDetail__c'    
                                                                                  );
        
        ASI_GnH_KR_Default_Setting__c setting3 = new ASI_GnH_KR_Default_Setting__c(Name = 'ASI_GnH_AnP_Supported_Item',
                                                                                   ASI_GnH_Text__c = 'percentage20',
                                                                                   ASI_GnH_Record_Type__c = 'ASI_TnE_KR_Claim_Detail',
                                                                                   ASI_GnH_Object__c = 'ASI_TnE_ClaimDetail__c'    
                                                                                  );
        customSettingList.add(setting1);
        customSettingList.add(setting2);
        customSettingList.add(setting3);
        insert customSettingList;
        return customSettingList;
    }
}