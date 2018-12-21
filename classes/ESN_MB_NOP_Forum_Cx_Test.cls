/**
    About
    -----
    Description: test class for ESN_MB_NOP_Forum_Cx class of MyBrands
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sep 2014

    Details
    -------
    This class contains unit tests for ESN_MB_NOP_Forum_Cx class
    
    Update History
    --------------
    Sep 2014 / Created by 

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_NOP_Forum_Cx_Test {

    static testMethod void getForumIdTest() {
        ESN_MB_NOP_Forum_Cx forum = new ESN_MB_NOP_Forum_Cx();

        ESN_MB_NodePage__c brand = ESN_MB_NOP_Homepage_Cx_Test_Utils.createBrand('brand1', null); // ESN_MB_ChatterGroup_Id__c

        System.assert(String.isNotBlank(ESN_MB_NOP_Forum_Cx.getForumId(brand.Id)));
    }
}