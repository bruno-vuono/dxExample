@isTest
public class ASI_CRM_Function_Test {

    static testMethod void ASI_CRM_Function_TEST() {
        
        test.startTest();
        
        ASI_CRM_Function.getCreatableFieldsSOQL('Account', 'NOT ISNULL(Id)', 'Name');
        
        test.stopTest();
    }
}