@isTest
private class LAT_VFC07_ActionInsertAccountTest {

    private static LAT_VFC07_ActionInsertAccount.filterConditionsWrapper getNewFilterWrapper() {
        LAT_VFC07_ActionInsertAccount.filterConditionsWrapper  filterWrapper = new LAT_VFC07_ActionInsertAccount.filterConditionsWrapper('Test', 'Test', 'Test');
        return filterWrapper;

    }

    @isTest static void testBasicMethods() {
        Account acc = LAT_Account_TestFactory.getAccountOnTradeBraComplete();
    acc.LAT_BR_RegionalClientOnPremise__c = 'REG NE';
    insert acc;

        LAT_VFC07_ActionInsertAccount acia = new LAT_VFC07_ActionInsertAccount();
        acia.filterList.add(getNewFilterWrapper());
        acia.getFilterValues();
        acia.getFieldValues();
        acia.filterValues();
        acia.save();
        LAT_VFC07_ActionInsertAccount.filterConditionsWrapper fcw =
                new LAT_VFC07_ActionInsertAccount.filterConditionsWrapper('TEXT:CNPJ__c', '=', acc.CNPJ__c);
        fcw.hasFilter();
        fcw.formatValue();
        acia.addRow();
        acia.removeRow();
        acia.cancel();
    }

    @isTest static void testCsvUpload() {
        LAT_PromotionalAction__c ap = LAT_ClientByRegionHandlerTest.createAP();
        Account acc = LAT_Account_TestFactory.getAccountOnTradeBraComplete();
    acc.LAT_BR_RegionalClientOnPremise__c = 'REG NE';
    insert acc;

        String csv = 'AN8 o CNPJ\n' + acc.CNPJ__c + '\n';
        ApexPages.CurrentPage().getparameters().put('id', ap.id);
        LAT_VFC07_ActionInsertAccount acia = new LAT_VFC07_ActionInsertAccount();

        acia.toParse = Blob.valueOf(csv);
        acia.upload();

    }
    @isTest static void testBasicMethodsB() {
        Utils.setMigrationDoneTest(true); 

        Account acc = LAT_Account_TestFactory.getAccountOnTradeBraComplete();
    acc.LAT_BR_RegionalClientOnPremise__c = 'REG NE';
    insert acc;

        LAT_VFC07_ActionInsertAccount acia = new LAT_VFC07_ActionInsertAccount();
        acia.filterList.add(getNewFilterWrapper());
        acia.getFilterValues();
        acia.getFieldValues();
        acia.filterValues();
        acia.save();
        LAT_VFC07_ActionInsertAccount.filterConditionsWrapper fcw =
                new LAT_VFC07_ActionInsertAccount.filterConditionsWrapper('TEXT:CNPJ__c', '=', acc.CNPJ__c);
        fcw.hasFilter();
        fcw.formatValue();
        LAT_VFC07_ActionInsertAccount.filterConditionsWrapper fcw2 =
                new LAT_VFC07_ActionInsertAccount.filterConditionsWrapper('DATE:PersonBirthdate', '=', '2015-06-06');
        fcw2.filterValue2 = '2015/04/04';
        fcw2.hasFilter();

        fcw2.formatValue();
        acia.addRow();
        acia.removeRow();
        acia.cancel();
    }

    @isTest static void testCsvUploadB() {
        Utils.setMigrationDoneTest(true); 
        LAT_PromotionalAction__c ap = LAT_ClientByRegionHandlerTest.createAP();
        Account acc = LAT_Account_TestFactory.getAccountOnTradeBraComplete();
    acc.LAT_BR_RegionalClientOnPremise__c = 'REG NE';
    insert acc;

        String csv = 'AN8 o CNPJ\n' + acc.CNPJ__c + '\n';
        ApexPages.CurrentPage().getparameters().put('id', ap.id);
        LAT_VFC07_ActionInsertAccount acia = new LAT_VFC07_ActionInsertAccount();

        acia.toParse = Blob.valueOf(csv);
        acia.upload();

    }


}