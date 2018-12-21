public class ASI_MFM_Payment_WrapperClass {

	public ASI_MFM_Plan__c plan{get;set;}
	public List<ASI_MFM_Payment_Line_Item__c> paylineList{get;set;}
	public List<ASI_MFM_PO__c> PoList{get;set;} 
	public decimal totalPoAmount{get;set;}
	public decimal totalActualAmount{get;set;} 
	
	public ASI_MFM_Payment_WrapperClass(ASI_MFM_Plan__c p)
	{	
		totalPoAmount = 0;
		plan = p;
		paylineList = new List<ASI_MFM_Payment_Line_Item__c>();
		PoList = new List<ASI_MFM_PO__c>();
		PoList = [select ASI_MFM_PO_Amount__c, Name,
		ASI_MFM_Status__c from ASI_MFM_PO__c where ASI_MFM_Plan__c =: plan.id];
		
		for(ASI_MFM_PO__c po1:PoList){
			//System.debug('PoListId' + Po1.id);
			//System.debug('PoListName ' + po1.Name);
			//System.debug('PoListASI_MFM_Status__c' + po1.ASI_MFM_Status__c);
			
			if(po1.ASI_MFM_PO_Amount__c != null){
				totalPoAmount += po1.ASI_MFM_PO_Amount__c;
			}
		
		}
	}
	
	//for(ASI_MFM_Payment_Line_Item__c)

}