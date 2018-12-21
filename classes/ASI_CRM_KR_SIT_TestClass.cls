/*
Test:
1. ASI_CRM_KR_ListViewInput	   <ListViewInput_Test_1>
*/

@istest
public class ASI_CRM_KR_SIT_TestClass {
    static testMethod void ListViewInput_Test_1() {
        
        
        //Update User Information 
        user TestingUser = [select ASI_MFM_Country__c,CompanyName from user where id = :userInfo.getUserId() limit 1]; 
        TestingUser.ASI_MFM_Country__c = 'KR';
        TestingUser.CompanyName = 'Pernod Ricard Korea';
        update TestingUser;
        
        System.runAs(TestingUser){
            
            //Insert Account: Venue recordtype
            Account WS = new Account(recordTypeId=Global_RecordTypeCache.getRtId('AccountASI_KOR_Wholesaler'),
                                        Name='WS Testing Account',
                                        ASI_KOR_Wholesaler_Channel__c = 'TOT',
                                        ASI_KOR_Customer_Code__c = '012344567890'
                                       );       
            insert WS;
        }
    }
}