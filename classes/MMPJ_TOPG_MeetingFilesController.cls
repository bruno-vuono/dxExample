/*
* TOPGUN APP
* Classe used in a public Site.com to download meeting files (pdf and ics)
* @date		08/12/2015
* @author EL MOUSSAOUI Mohamed
* @ClassTest  MMPJ_TOPG_MeetingFilesController_TEST
* @CodeCoverage %
*/
public with sharing class MMPJ_TOPG_MeetingFilesController
{
	public MMPJ_TOPG_MeetingFilesController()
	{
		pdfId= '';
	}
	public String pdfId {get; set;}

	public PageReference downloadFile()
	{
		// if related id is missing --> ERROR
		if(!ApexPages.currentPage().getParameters().containsKey('what') || !ApexPages.currentPage().getParameters().containsKey('relatedId'))
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error : meeting Id is missing'));
			return null;
		}
		else
		{
			String what = ApexPages.currentPage().getParameters().get('what');
			String relatedId = ApexPages.currentPage().getParameters().get('relatedId');
			if(what == 'pdfAgenda' || what == 'pdfMinute')
			{

				for(MMPJ_TOPG_Meeting__c m : [SELECT Name from MMPJ_TOPG_Meeting__c WHERE Id =: relatedId LIMIT 1])
				{
					String pdfFileName = m.Name;
					if(what == 'pdfAgenda')
						pdfFileName +='-Agenda.pdf';
					else
						pdfFileName +='-Minute.pdf';
					for(Attachment relatedPDF : [SELECT Id, Name FROM Attachment WHERE ParentId=:relatedId AND Name =: pdfFileName  ORDER BY CreatedDate DESC LIMIT 1])
					{
						pdfId = relatedPDF.id;
					}
				}
				if(pdfId != null)
				{
					PageReference pdfLink = new PageReference(Label.MMPJ_TOPG_MeetingAttachmentsURL+'/servlet/servlet.FileDownload?file='+pdfId);
					pdfLink.setRedirect(true);
					return null;
				}
				else
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error : meeting PDF is missing'));
					return null;
				}
			}
			else
			{
				PageReference icsLink = Page.MMPJ_TOPG_MeetingFilesICS;
				for(Event evt : [SELECT Id, Description, Location, StartDateTime, EndDateTime, WhatId, Subject FROM Event WHERE WhatId =:relatedId ORDER BY CreatedDate DESC LIMIT 1])
				{
					icsLink.getParameters().put('start',evt.StartDateTime.format('yyyyMMdd\'T\'HHmmssZ'));
					icsLink.getParameters().put('end',evt.EndDateTime.format('yyyyMMdd\'T\'HHmmssZ'));
					icsLink.getParameters().put('subject',EncodingUtil.urlEncode(evt.Subject,'UTF-8'));
					icsLink.getParameters().put('description',evt.Description != null ? EncodingUtil.urlEncode(evt.Description,'UTF-8'): '');
					icsLink.getParameters().put('location',evt.Location != null ? EncodingUtil.urlEncode(evt.Location,'UTF-8'): '');
				}
				icsLink.setRedirect(true);
				return icsLink;
			}
		}
	}
}