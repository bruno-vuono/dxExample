/**
    About
    -----
    Description: test class for ESN_MB_MetadataService class of MyBrands Cockpit
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Jan 2015

    Details
    -------
    This class contains unit tests for ESN_MB_MetadataService class
    
    Update History
    --------------
    Jan 2015 / Created by Valentin PLITTA

    Issues / TODOs
    --------------
*/
@isTest
private class ESN_MB_MetadataService_Test { 

    static testMethod void SessionHeader_elementTest() {
        ESN_MB_MetadataService.SessionHeader_element metadataServiceObj = new ESN_MB_MetadataService.SessionHeader_element();
        ESN_MB_MetadataService.SaveResult metadataServiceObj2 = new ESN_MB_MetadataService.SaveResult();
        ESN_MB_MetadataService.Error metadataServiceObj3 = new ESN_MB_MetadataService.Error();
        ESN_MB_MetadataService.StaticResource metadataServiceObj4 = new ESN_MB_MetadataService.StaticResource();
        ESN_MB_MetadataService.DebuggingInfo_element metadataServiceObj5 = new ESN_MB_MetadataService.DebuggingInfo_element();
        ESN_MB_MetadataService.CallOptions_element metadataServiceObj6 = new ESN_MB_MetadataService.CallOptions_element();
        ESN_MB_MetadataService.DebuggingHeader_element metadataServiceObj7 = new ESN_MB_MetadataService.DebuggingHeader_element();
        ESN_MB_MetadataService.updateMetadata_element metadataServiceObj8 = new ESN_MB_MetadataService.updateMetadata_element();
        ESN_MB_MetadataService.updateMetadataResponse_element metadataServiceObj9 = new ESN_MB_MetadataService.updateMetadataResponse_element();
        ESN_MB_MetadataService.renameMetadata_element metadataServiceObj10 = new ESN_MB_MetadataService.renameMetadata_element();
        ESN_MB_MetadataService.renameMetadataResponse_element metadataServiceObj11 = new ESN_MB_MetadataService.renameMetadataResponse_element();
        ESN_MB_MetadataService.createMetadata_element metadataServiceObj12 = new ESN_MB_MetadataService.createMetadata_element();
        ESN_MB_MetadataService.createMetadataResponse_element metadataServiceObj13 = new ESN_MB_MetadataService.createMetadataResponse_element();
        ESN_MB_MetadataService.LogInfo metadataServiceObj14 = new ESN_MB_MetadataService.LogInfo();
        ESN_MB_MetadataService.MetadataPort metadataServiceObj15 = new ESN_MB_MetadataService.MetadataPort();
    }

}