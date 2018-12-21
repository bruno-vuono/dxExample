@isTest
private class MMPJ_TOPG_MeetingFilesController_TEST
{
	@isTest static void test_MeetingFilesController()
	{
		MMPJ_TOPG_Meeting__c meeting = new MMPJ_TOPG_Meeting__c(Name='test meeting');
		insert meeting;

		Attachment agendaPdf=new Attachment();
        agendaPdf.Name='test meeting-Agenda.pdf';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        agendaPdf.body=bodyBlob;
        agendaPdf.parentId=meeting.id;
        insert agendaPdf;
		Attachment minutesPdf=new Attachment();
		minutesPdf.Name='test meeting-Minute.pdf';
		minutesPdf.body=bodyBlob;
		minutesPdf.parentId=meeting.id;
		insert minutesPdf;

		insert new Event(Description='test meeting files',  Location='EOF', StartDateTime=System.today(), EndDateTime=System.today().addDays(7), Subject='meeting', WhatId=meeting.id);

		MMPJ_TOPG_MeetingFilesController meetingFilesCtrl = new MMPJ_TOPG_MeetingFilesController();

		PageReference meetingFilesPage = page.MMPJ_TOPG_MeetingFiles;

		ApexPages.currentPage().getParameters().put('what', 'pdfAgenda');
		ApexPages.currentPage().getParameters().put('relatedId', meeting.Id);

		Test.startTest();
			Test.setCurrentPage(meetingFilesPage);

			System.currentPageReference().getParameters().put('relatedId', meeting.Id);
			System.currentPageReference().getParameters().put('what', 'pdfAgenda');
			meetingFilesCtrl.downloadFile();

			System.currentPageReference().getParameters().clear();
			System.currentPageReference().getParameters().put('relatedId', meeting.Id);
			System.currentPageReference().getParameters().put('what', 'pdfMinute');
			meetingFilesCtrl.downloadFile();

			delete minutesPdf;
			meetingFilesCtrl.downloadFile();

			System.currentPageReference().getParameters().clear();
			System.currentPageReference().getParameters().put('relatedId', meeting.Id);
			System.currentPageReference().getParameters().put('what', 'ICS');
			meetingFilesCtrl.downloadFile();

			System.currentPageReference().getParameters().clear();
			System.currentPageReference().getParameters().put('relatedId', meeting.Id);
			System.currentPageReference().getParameters().put('what', 'pdfMinute');
			meetingFilesCtrl.downloadFile();

			System.currentPageReference().getParameters().clear();
			meetingFilesCtrl.downloadFile();
		Test.stopTest();
	}
}