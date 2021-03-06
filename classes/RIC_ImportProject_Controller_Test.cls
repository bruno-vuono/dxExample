/*
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors 
    may be used to endorse or promote products derived from this software 
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
@isTest
private class RIC_ImportProject_Controller_Test {
    
    static testMethod void testImportController() {
        
        Milestone1_Project__c project = new Milestone1_Project__c();
        project.Name = 'TestProj';
            
        insert project;
        
        Document testDoc = new Document();
        testDoc.Name = 'EXPORT UNIT TEST XYZABC' + System.now();
        String body = '<?xml version="1.0"?><export><meta><exportPackage>Milestone1_Project_Export</exportPackage><exportAuthor>Nazim+Dabouz</exportAuthor><exportOrganization>Pernod+Ricard</exportOrganization><exportCreateDate>2015-02-10+09%3A20%3A28</exportCreateDate><exportVersion>1.0</exportVersion></meta><Milestone1_Project__c><Id>aGHc0000000000QGAQ</Id><Name>Ricard+s%C3%A9rie+limit%C3%A9e+fin+ann%C3%A9e+2014</Name><Milestone1_Milestone__c><Id>aGGc0000000000LGAQ</Id><Name>Phase+2</Name><Kickoff__c>2015-01-13+00%3A00%3A00</Kickoff__c><Deadline__c>2015-02-02+00%3A00%3A00</Deadline__c><Milestone1_Task__c><Id>aGJc0000000001DGAQ</Id><Name>Action+1</Name><Start_Date__c>2015-01-06+00%3A00%3A00</Start_Date__c><Due_Date__c>2015-01-09+00%3A00%3A00</Due_Date__c><Project_Milestone__c>aGGc0000000000LGAQ</Project_Milestone__c></Milestone1_Task__c><Milestone1_Task__c><Id>aGJc0000000004NGAQ</Id><Name>Action+1</Name><Start_Date__c>2015-01-06+00%3A00%3A00</Start_Date__c><Due_Date__c>2015-01-09+00%3A00%3A00</Due_Date__c><Project_Milestone__c>aGGc0000000000LGAQ</Project_Milestone__c></Milestone1_Task__c></Milestone1_Milestone__c><Milestone1_Milestone__c><Id>aGGc0000000000GGAQ</Id><Name>Phase+1</Name><Kickoff__c>2015-01-09+00%3A00%3A00</Kickoff__c><Deadline__c>2015-01-18+00%3A00%3A00</Deadline__c><Milestone1_Task__c><Id>aGJc0000000005GGAQ</Id><Name>Informations+co-gestionnaires+Planification</Name><Start_Date__c>2015-01-30+00%3A00%3A00</Start_Date__c><Due_Date__c>2015-02-13+00%3A00%3A00</Due_Date__c><Project_Milestone__c>aGGc0000000000GGAQ</Project_Milestone__c></Milestone1_Task__c><Milestone1_Task__c><Id>aGJc0000000005BGAQ</Id><Name>Email+Test</Name><Start_Date__c>2015-01-30+00%3A00%3A00</Start_Date__c><Due_Date__c>2015-01-30+00%3A00%3A00</Due_Date__c><Project_Milestone__c>aGGc0000000000GGAQ</Project_Milestone__c></Milestone1_Task__c></Milestone1_Milestone__c><Milestone1_Milestone__c><Id>aGGc0000000000QGAQ</Id><Name>Phase+3</Name><Kickoff__c>2015-01-20+00%3A00%3A00</Kickoff__c><Deadline__c>2015-02-11+00%3A00%3A00</Deadline__c><Milestone1_Task__c><Id>aGJc0000000001NGAQ</Id><Name>Action+1</Name><Start_Date__c>2015-01-09+00%3A00%3A00</Start_Date__c><Due_Date__c>2015-02-11+00%3A00%3A00</Due_Date__c><Project_Milestone__c>aGGc0000000000QGAQ</Project_Milestone__c></Milestone1_Task__c><Milestone1_Task__c><Id>aGJc0000000003iGAA</Id><Description__c>Bouge</Description__c><Name>Action+Man</Name><Start_Date__c>2015-01-20+00%3A00%3A00</Start_Date__c><Due_Date__c>2015-01-20+00%3A00%3A00</Due_Date__c><Project_Milestone__c>aGGc0000000000QGAQ</Project_Milestone__c></Milestone1_Task__c></Milestone1_Milestone__c></Milestone1_Project__c></export>';
        testDoc.body = Blob.valueOf(body);
        
        List<Document> docs = new List<Document>{testDoc};
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        RIC_ImportProject_Controller testController = new RIC_ImportProject_Controller(ssc);
        testController.fileBody = testDoc.body;
        testController.fileName = 'UNIT TEST.XML';
        testController.docId = testDoc.Id;
        testController.currentRecordId = project.Id;
        
        testController.importTemplateXML();
    }
    
    static testMethod void testImportControllerNoFileException() {
        
        //List<Document> docs = [Select Id from Document];
        //delete docs;
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        RIC_ImportProject_Controller testController = new RIC_ImportProject_Controller(ssc);
        testController.fileBody = null;
        testController.fileName = null;
        testController.docId = null;
        try
        {
            testController.importTemplateXML();
        }catch(Exception e)
        {
            System.assert(testController.project == null);
            Boolean expectedExceptionThrown =  e.getMessage().contains(Milestone1_Import_Exception.ERROR_NO_FILE_SELECTED) ? true : false;
            System.assertEquals(expectedExceptionThrown,true);
        }   
    }
    
    static testMethod void testImportControllerInvalidXML() {
        
        Document testDoc = new Document();
        testDoc.Name = 'EXPORT UNIT TEST XYZABC' + System.now();
        String body = 'This is not an XML file';
        testDoc.body = Blob.valueOf(body);
        testDoc.FolderId = UserInfo.getUserId();
        insert testDoc;
        
        List<Document> docs = new List<Document>{testDoc};
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        RIC_ImportProject_Controller testController = new RIC_ImportProject_Controller(ssc);
        testController.fileBody = testDoc.body;
        testController.fileName = 'UNIT TEST.XML';
        testController.docId = testDoc.Id;
        testController.importTemplateXML();
        
        System.assert(testController.project == null);
    }
    
    static testMethod void testImportControllerValidFromDocsFolder() {
        
        Milestone1_Project__c project = new Milestone1_Project__c();
        project.Name = 'TestProj';
            
        insert project;
        
        
        Document testDoc = new Document();
        testDoc.Name = 'EXPORT UNIT TEST XYZABC' + System.now();
        String body = '<?xml version="1.0"?><export><meta><exportPackage>Milestone1_Project_Export</exportPackage><exportAuthor>Admin+User</exportAuthor><exportOrganization>Force.com+Labs+PM</exportOrganization><exportCreateDate>2010-07-28+21%3A39%3A39</exportCreateDate><exportVersion>1.0</exportVersion></meta><Milestone1_Project__c><Id>a03A0000001PchPIAS</Id><Total_Expense_Estimate__c>1.00</Total_Expense_Estimate__c><Total_Expense_Budget__c>null</Total_Expense_Budget__c><Status__c>null</Status__c><Description__c>abc</Description__c><Description__c>null</Description__c><Milestone1_Milestone__c><Id>a02A0000002UR8YIAW</Id><Deadline__c>2010-07-29+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>15665.37</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>246.59</Hours_Budget__c><Milestone1_Milestone__c><Id>a02A0000002UR8aIAG</Id><Deadline__c>2010-07-25+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME3+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>32904.61</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>454.30</Hours_Budget__c><Name>UNIT+TEST+MILESTONE+NAME3+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Name>UNIT+TEST+MILESTONE+NAME+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Milestone1_Milestone__c><Id>a02A0000002UR8ZIAW</Id><Deadline__c>2010-08-03+00%3A00%3A00</Deadline__c><Description__c>Description+for+UNIT+TEST+MILESTONE+NAME2+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Description__c><Expense_Budget__c>823.57</Expense_Budget__c><Hour_Budget__c>null</Hour_Budget__c><Hours_Budget__c>352.72</Hours_Budget__c><Name>UNIT+TEST+MILESTONE+NAME2+ACB123XYZ+UNIQUE2010-07-28+21%3A39%3A39</Name></Milestone1_Milestone__c><Name>UNIT_TEST_NAME_XYZABC</Name></Milestone1_Project__c></export>';
        testDoc.body = Blob.valueOf(body);
        testDoc.FolderId = UserInfo.getUserId();
        insert testDoc;
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Milestone1_Project__c>());
        RIC_ImportProject_Controller testController = new RIC_ImportProject_Controller(ssc);
        testController.docId = testDoc.Id;
        testController.currentRecordId = project.Id;
        testController.importTemplateXML();
    }
}