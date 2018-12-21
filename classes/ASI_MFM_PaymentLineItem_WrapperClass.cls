public with sharing class ASI_MFM_PaymentLineItem_WrapperClass {

	public decimal subTotal{get;set;}
	public List<ASI_MFM_Payment_Line_Item__c> paylineList{get;set;}
	public string payeeName{get;set;}

	public ASI_MFM_PaymentLineItem_WrapperClass(String p)
	{	
		payeeName = p;
		subTotal = 0;
		paylineList = new List<ASI_MFM_Payment_Line_Item__c>();

	}	
	
}