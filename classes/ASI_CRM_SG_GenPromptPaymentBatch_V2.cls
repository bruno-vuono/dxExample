/*********************************************************************************
 * Name: ASI_CRM_SG_GenPromptPaymentBatch_V2
 * Description: Generation the contract margin credit / debit not and line item
 *
 * Version History
 * Date       Developer       Comments
 * --------------- -------------------- --------------------------------------------------------------------------------
 * 2017-05-09    Vincent Lam      Create
*/
global class ASI_CRM_SG_GenPromptPaymentBatch_V2 implements Database.Batchable<sobject>, Database.stateful {

  public static final Map<String, Schema.SObjectField> SUBBRAND_FIELD_MAP = Schema.SObjectType.ASI_MFM_Sub_brand__c.fields.getMap();

  public static final Id CREDITNOTE_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Prompt_Payment_Credit_Note');
  public static final Id CREDITNOTE_LINEITEM_RECORDTYPE_ID = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note_Line_Item__cASI_CRM_SG_Prompt_Payment_Credit_Note_Line_Item');
  
  
  public static final Id CREDITNOTE_RECORDTYPE_ID_READONLY = Global_RecordTypeCache.getRTId('ASI_CRM_Credit_Debit_Note__cASI_CRM_SG_Prompt_Payment_Credit_Note_Read_Only');
  
  public static final String WHOLESALER_RECORDTYPE = 'ASI_CRM_SG_Wholesaler';
  public static final String INVOICE_RECORDTYPE = 'ASI_CRM_SG_Invoice';
  public static final String RECEIPT_RECORDTYPE = 'ASI_CRM_SG_Receipt';
  
	public static final String REASON_PREFIX = 'PromPymt_';
  public static final String CREDITNOTE_TYPE = 'Prompt Payment';
	public static final String DEFAULT_CURRENCY = 'SGD';
	public static final Integer DEFAULT_EXCHANGERATE = 1;
	public static final Integer DEFAULT_PAYMENTDAY = 60;
	public static final String SG_TAX_RATE_AREA = 'SG3';
	public static final Decimal SG_TAX_RATE = 1.07;

  //Variable for init query
  global date receiptStartDate, receiptEndDate;
    global Map<string, ASI_MFM_Sub_brand__c> map_subBrandCode_ID;
    global Map<string, string> map_subBrandId_code;

  Map<string, invoiceWrapper> invoiceWrapperMap = new Map<string, invoiceWrapper>();

  global ASI_CRM_SG_GenPromptPaymentBatch_V2(String receiptStartDate, String receiptEndDate) {
    this.receiptStartDate = date.valueOf(receiptStartDate);
    this.receiptEndDate = date.valueOf(receiptEndDate);
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
      
        map_subBrandCode_ID = new Map<string, ASI_MFM_Sub_brand__c>();
        map_subBrandCode_ID = getSubbrandCodeMap();
		
        map_subBrandId_code = new Map<string, string>();
        map_subBrandId_code = getSubbrandIDMap();
		
        String query = '';
		query += 'SELECT ASI_CRM_Amount__c, ASI_CRM_Invoice__c, ';
		query += 'ASI_CRM_Receipt__r.ASI_CRM_Receipt_Date__c, ASI_CRM_Invoice__r.ASI_CRM_Invoice_Date__c, ';
		query += 'ASI_CRM_Receipt__r.ASI_CRM_Customer__c, ASI_CRM_Receipt__r.ASI_CRM_Customer__r.ASI_CRM_SG_Payment_Terms_A_R__c, ASI_CRM_Receipt__r.ASI_CRM_Customer__r.ASI_CRM_SG_Tax_Rate_Area__c ';
		query += 'FROM ASI_CRM_Receipt_Line_Item__c ';
		query += 'WHERE ASI_CRM_Receipt__r.recordtype.developername = :RECEIPT_RECORDTYPE ';
		query += 'AND ASI_CRM_Receipt__r.ASI_CRM_Customer__r.recordtype.developername = :WHOLESALER_RECORDTYPE ';
		query += 'AND ASI_CRM_Receipt__r.ASI_CRM_Receipt_Date__c >= :receiptStartDate AND ASI_CRM_Receipt__r.ASI_CRM_Receipt_Date__c <= :receiptEndDate ';
		query += 'AND ASI_CRM_Amount__c <> 0 ';
		query += 'AND ASI_CRM_Receipt__r.ASI_CRM_Customer__c <> null ';
		query += 'AND ASI_CRM_Invoice__r.ASI_CRM_Invoice_Date__c <> null ';
		query += 'AND ASI_CRM_Receipt__r.ASI_CRM_Receipt_Date__c <> null ';


      return Database.getQueryLocator(query);
    }

	global void execute(Database.BatchableContext BC, List<sObject> scope) {

		List<ASI_CRM_Receipt_Line_Item__c> receiptLineList = (List<ASI_CRM_Receipt_Line_Item__c>) scope;
		set<string> set_invoiceID = new set<string>();

		for(ASI_CRM_Receipt_Line_Item__c receiptLine : receiptLineList) {
			
			// get paymentDay for each wholesaler
			Integer paymentDay = receiptLine.ASI_CRM_Receipt__r.ASI_CRM_Customer__r.ASI_CRM_SG_Payment_Terms_A_R__c == null ? DEFAULT_PAYMENTDAY : integer.valueOf(receiptLine.ASI_CRM_Receipt__r.ASI_CRM_Customer__r.ASI_CRM_SG_Payment_Terms_A_R__c);
		
			// check if the payment is made within 60 days
			if (receiptLine.ASI_CRM_Invoice__r.ASI_CRM_Invoice_Date__c.daysBetween(receiptLine.ASI_CRM_Receipt__r.ASI_CRM_Receipt_Date__c)<=paymentDay){
				string wholesalerId = receiptLine.ASI_CRM_Receipt__r.ASI_CRM_Customer__c;
				invoiceWrapper invoiceWrapper;
				if(!invoiceWrapperMap.containsKey(wholesalerId)) {
					invoiceWrapper = new invoiceWrapper(wholesalerId);
				} else {
					invoiceWrapper = invoiceWrapperMap.get(wholesalerId);
				}
				invoiceWrapper.receiptLineMap.put(receiptLine.Id, receiptLine);
				
				list<Id> receiptLineListInWrapper = invoiceWrapper.invoiceReceiptLineMap.containsKey(receiptLine.ASI_CRM_Invoice__c) ? invoiceWrapper.invoiceReceiptLineMap.get(receiptLine.ASI_CRM_Invoice__c) : new list<Id>();
				receiptLineListInWrapper.add(receiptLine.Id);
				invoiceWrapper.invoiceReceiptLineMap.put(receiptLine.ASI_CRM_Invoice__c, receiptLineListInWrapper);
				
				invoiceWrapperMap.put(wholesalerId, invoiceWrapper);
				
				set_invoiceID.add(receiptLine.ASI_CRM_Invoice__c);
		
			}
		
		}
		
		if (set_invoiceID.size()>0){
			/*
			String query = '';
			query += 'SELECT id, ASI_CRM_Amount__c, ASI_CRM_Sub_brand_Code__c, ASI_CRM_Invoice__r.ASI_CRM_Customer__c, ASI_CRM_Invoice__c ';
			query += 'FROM ASI_CRM_Invoice_Line_Item__c ';
			query += 'WHERE ASI_CRM_Invoice__r.recordtype.developername = :INVOICE_RECORDTYPE ';
			query += 'AND ASI_CRM_Invoice__r.ASI_CRM_Customer__r.recordtype.developername = :WHOLESALER_RECORDTYPE ';
			query += 'AND ASI_CRM_Invoice__c in :set_invoiceID ';
			query += 'AND ASI_CRM_Sub_brand_Code__c <> \'\' ';
			query += 'AND ASI_CRM_Amount__c <> 0 ';
			
			List<ASI_CRM_Invoice_Line_Item__c> invoiceLineList = (List<ASI_CRM_Invoice_Line_Item__c>) Database.query(query);
			for (ASI_CRM_Invoice_Line_Item__c invoiceLine : invoiceLineList){
				
			}
			*/
			for (ASI_CRM_Invoice__c invoice : [
				SELECT id, ASI_CRM_Customer__c, 
				(select id, ASI_CRM_Amount__c, ASI_CRM_Sub_brand_Code__c 
					FROM Invoice_Line_Items__r
					where 
					ASI_CRM_Sub_brand_Code__c <> ''
					AND ASI_CRM_Amount__c <> 0 
				) 
				from ASI_CRM_Invoice__c
				WHERE recordtype.developername = :INVOICE_RECORDTYPE 
				AND ASI_CRM_Customer__r.recordtype.developername = :WHOLESALER_RECORDTYPE 
				AND id in :set_invoiceID 
			]) {
				string wholesalerId = invoice.ASI_CRM_Customer__c;
				invoiceWrapper invoiceWrapper = invoiceWrapperMap.get(wholesalerId);
				list<Id> receiptLineListInWrapper = invoiceWrapper.invoiceReceiptLineMap.get(invoice.Id);
				for (Id receiptLineId : receiptLineListInWrapper) {
					invoiceWrapper.receiptLineInvoiceLineMap.put(receiptLineId, invoice.Invoice_Line_Items__r);
				}
				
			}
		}

    }

    global void finish(Database.BatchableContext BC) {

        Datetime dateInstance = Datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day());

        Map<string, ASI_CRM_Credit_Debit_Note__c> map_creditNote = new Map<string, ASI_CRM_Credit_Debit_Note__c>();
        Map<string, List<ASI_CRM_Credit_Debit_Note_Line_Item__c>> map_creditNoteLine = new Map<string, List<ASI_CRM_Credit_Debit_Note_Line_Item__c>>();
		Map<string, List<ASI_CRM_Receipt_Line_Item__c>> map_creditNote_receiptLine = new Map<string, List<ASI_CRM_Receipt_Line_Item__c>>();
	  
        for(string wrapper_key : invoiceWrapperMap.keySet()) {
			Map<Id, Decimal> map_subBrandId_amount     = new Map<Id, Decimal>();

			invoiceWrapper invoiceWrapper = invoiceWrapperMap.get(wrapper_key);
			Set<ASI_CRM_Receipt_Line_Item__c> receiptLineToUpdate = new Set<ASI_CRM_Receipt_Line_Item__c>();
			
			// loop through each receipt line, calculate entitlement of each invoice line
			for (Id receiptLineId : invoiceWrapper.receiptLineInvoiceLineMap.keySet()){
				decimal totalInvoiceAmount = 0;
				list<ASI_CRM_Invoice_Line_Item__c> invoiceLineList = invoiceWrapper.receiptLineInvoiceLineMap.get(receiptLineId);
				ASI_CRM_Receipt_Line_Item__c receiptLine = invoiceWrapper.receiptLineMap.get(receiptLineId);
				
				// first loop to calculate the total invoice amount
				for (ASI_CRM_Invoice_Line_Item__c invoiceLine : invoiceLineList){
					// sum the amount for all sub-brand <> ''
					totalInvoiceAmount += Math.abs(invoiceLine.ASI_CRM_Amount__c);
				}
				// second loop to calculate the %
				for (ASI_CRM_Invoice_Line_Item__c invoiceLine : invoiceLineList){
					// check if this invoice line has an eligible sub-brand
					if (map_subBrandCode_ID != null && map_subBrandCode_ID.containsKey(invoiceLine.ASI_CRM_Sub_brand_Code__c)) {
						decimal weightedPercent = Math.abs(invoiceLine.ASI_CRM_Amount__c) / totalInvoiceAmount;
						decimal recepitAmount_withoutTax = receiptLine.ASI_CRM_Receipt__r.ASI_CRM_Customer__r.ASI_CRM_SG_Tax_Rate_Area__c == SG_TAX_RATE_AREA ? (receiptLine.ASI_CRM_Amount__c / SG_TAX_RATE) : receiptLine.ASI_CRM_Amount__c;
						string subBrandId = map_subBrandCode_ID.get(invoiceLine.ASI_CRM_Sub_brand_Code__c).id;
						Decimal totalAmount = map_subBrandId_amount.containsKey(subBrandId) ? map_subBrandId_amount.get(subBrandId) : 0;
						totalAmount += recepitAmount_withoutTax * weightedPercent * -1;
						map_subBrandId_amount.put(subBrandId, totalAmount);
						// add this receipt line to list that going to link them to credit note header
						receiptLineToUpdate.add(receiptLine);
					}
				}
			}
			

			ASI_CRM_Credit_Debit_Note__c creditNote = new ASI_CRM_Credit_Debit_Note__c();
			creditNote.ASI_CRM_Wholesaler__c = invoiceWrapper.wholesalerId;
			creditNote.ASI_CRM_Status__c = 'Draft';
			creditNote.ASI_CRM_Invoice_Date__c = Date.today();
			creditNote.ASI_CRM_Receipt_Start_Date__c = receiptStartDate;
			creditNote.ASI_CRM_Receipt_End_Date__c = receiptEndDate;
			creditNote.ASI_CRM_GL_Date__c = Date.today();
			creditNote.ASI_CRM_Reason__c = REASON_PREFIX + dateInstance.format('MMMyy', UserInfo.getTimeZone().getId());
			creditNote.ASI_CRM_SYS_System_Generated__c = true;
			creditNote.ASI_CRM_Currency__c = DEFAULT_CURRENCY;
			creditNote.ASI_CRM_Base_Currency__c = DEFAULT_CURRENCY;
			creditNote.ASI_CRM_Exchange_Rate__c = DEFAULT_EXCHANGERATE;
			creditNote.RecordTypeId = CREDITNOTE_RECORDTYPE_ID;

			List<ASI_CRM_Credit_Debit_Note_Line_Item__c> creditNoteLineItemList = new List<ASI_CRM_Credit_Debit_Note_Line_Item__c>();
			for(Id subBrandId : map_subBrandId_amount.keySet()) {
			    decimal ppRate = map_subBrandCode_ID.get(map_subBrandId_code.get(subBrandId)).ASI_CRM_Prompt_Payment_Rate__c;
				ppRate = ppRate == null ? 0 : (ppRate/100).setScale(2);
				decimal amount = map_subBrandId_amount.containsKey(subBrandId) ? map_subBrandId_amount.get(subBrandId)*ppRate : 0;
				if (amount.setScale(2)>0) {
					ASI_CRM_Credit_Debit_Note_Line_Item__c creditNoteLine = new ASI_CRM_Credit_Debit_Note_Line_Item__c();
					creditNoteLine.ASI_CRM_Sub_brand__c = subBrandId;
					creditNoteLine.ASI_CRM_Invoice_Amount__c = math.abs(map_subBrandId_amount.containsKey(subBrandId) ? map_subBrandId_amount.get(subBrandId) : 0);
					creditNoteLine.ASI_CRM_Amount__c = amount.setScale(2);
					creditNoteLine.ASI_CRM_Actual_Amount__c = amount.setScale(2);
					creditNoteLine.ASI_CRM_Type__c = CREDITNOTE_TYPE;
					creditNoteLine.ASI_CRM_Remark__c = REASON_PREFIX + map_subBrandId_code.get(subBrandId);
					creditNoteLine.RecordTypeId = CREDITNOTE_LINEITEM_RECORDTYPE_ID;
					creditNoteLineItemList.add(creditNoteLine);
				}
				
			}
		  
			if (creditNoteLineItemList.size()>0){
				string creditNote_key = invoiceWrapper.wholesalerId;
				map_creditNote.put(creditNote_key, creditNote);
				map_creditNoteLine.put(creditNote_key, creditNoteLineItemList);
				map_creditNote_receiptLine.put(creditNote_key, new List<ASI_CRM_Receipt_Line_Item__c> (receiptLineToUpdate));
			}
        
        }

        set<string> set_creditNoteID = new set<string>();
        
        if (map_creditNote!=null){
            insert map_creditNote.values();

            List<ASI_CRM_Credit_Debit_Note_Line_Item__c> creditNoteLineItemList = new List<ASI_CRM_Credit_Debit_Note_Line_Item__c>();
    
            for(string wrapper_key : map_creditNote.keySet()) {
                Id creditNoteId = map_creditNote.get(wrapper_key).Id;
                set_creditNoteID.add(creditNoteId);
                for(ASI_CRM_Credit_Debit_Note_Line_Item__c creditNoteLineItem : map_creditNoteLine.get(wrapper_key)) {
                    creditNoteLineItem.ASI_CRM_Credit_Debit_Note__c = creditNoteId;
                    creditNoteLineItemList.add(creditNoteLineItem);
                }
            }
    
            insert creditNoteLineItemList;
            
            List<ASI_CRM_Receipt_Line_Item__c> receiptLineItemList = new List<ASI_CRM_Receipt_Line_Item__c>();
    
			for(string wrapper_key : map_creditNote.keySet()) {
                Id creditNoteId = map_creditNote.get(wrapper_key).Id;
                set_creditNoteID.add(creditNoteId);
                for(ASI_CRM_Receipt_Line_Item__c receiptItem : map_creditNote_receiptLine.get(wrapper_key)) {
                    receiptItem.ASI_CRM_Credit_Debit_Note__c = creditNoteId;
                    receiptLineItemList.add(receiptItem);
                }
            }
			
            update receiptLineItemList;
            
        }
        
        if (set_creditNoteID.size()>0) {
			sendEMailNotification(BC.getJobId(), set_creditNoteID);
		}
      
    }

	//Wrapper Class
	public class invoiceWrapper {

		public Id wholesalerId {get; set;}

		public Map<Id, ASI_CRM_Receipt_Line_Item__c> receiptLineMap {get; set;}
		public Map<Id, List<Id>> invoiceReceiptLineMap {get; set;}
		public Map<Id, List<ASI_CRM_Invoice_Line_Item__c>> receiptLineInvoiceLineMap {get; set;}

		public invoiceWrapper(Id wholesalerId) {
		  receiptLineMap = new Map<Id, ASI_CRM_Receipt_Line_Item__c>();
		  invoiceReceiptLineMap = new Map<Id, List<Id>>();
		  receiptLineInvoiceLineMap = new Map<Id, List<ASI_CRM_Invoice_Line_Item__c>>();

		  this.wholesalerId = wholesalerId;
		}

    }

    public void sendEMailNotification(Id BC_ID, set<string> set_creditNoteID){
		 AsyncApexJob a = 
		   [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
			TotalJobItems, CreatedBy.Email
			FROM AsyncApexJob WHERE Id =
			:BC_ID];
						  
		   // Send an email to the Apex job's submitter 
		   //   notifying of job completion. 
		   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		   
		    list<string> list_email = new list<string>();
            list<string> list_user = new list<string>();
            
        	string ebody = '<p>The Prompt Payment Credit Note generation ' + 
				' is completed with '+ a.NumberOfErrors + ' errors.' +
				' (' + receiptStartDate.format() + ' - ' + receiptEndDate.format() + ')</p>';
			ebody += '<table width="100%" border="1">';
			ebody += '<tr><th>Credit Note</th><th>Wholesaler</th><th>Reason</th><th>Total Amount</th>';
        
            for (GroupMember u : [select userOrGroupId from GroupMember where group.developername = 'ASI_CRM_SG_Prompt_Payment_Admin']){
                list_user.add(u.userOrGroupId);
            }
            
			for (ASI_CRM_Credit_Debit_Note__c p : [
				select id, name, ASI_CRM_Wholesaler__r.name, ASI_CRM_Reason__c, ASI_CRM_Total_Amount__c, ownerid from ASI_CRM_Credit_Debit_Note__c
				where id in :set_creditNoteID
			]){
				ebody += '<tr><td>'+p.name+'</td><td>'+p.ASI_CRM_Wholesaler__r.name+'</td><td>'+p.ASI_CRM_Reason__c+'</td><td align="right">'+doFormatting(p.ASI_CRM_Total_Amount__c, 2, ',', '.')+'</td></tr>';
                list_user.add(p.ownerid);
			}
			ebody += '</table>';        
        	
            for (user u : [select email from user where id in :list_user]){
                list_email.add(u.email);
            }
		   
		   mail.setToAddresses(list_email);
		   mail.setSubject('Prompt Payment Credit Note Generation ' + a.Status + ' (' + receiptStartDate.format() + ' - ' + receiptEndDate.format() + ')');
			
			mail.setHtmlBody(ebody);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
       
    }
    
    /*********************************************************************************
     * Description: Get the mapping of sku
     *
     * Return: SKU Mapping contain the SKU Id and the newest SKU Id
    *********************************************************************************/
    private Map<string, ASI_MFM_Sub_brand__c> getSubbrandCodeMap() {
        Map<string, ASI_MFM_Sub_brand__c> sbMapping = new Map<string, ASI_MFM_Sub_brand__c>();

        Id rtID = Global_RecordTypeCache.getRTId('ASI_MFM_Sub_brand__cASI_CRM_SG_Sub_brand');

        for(ASI_MFM_Sub_brand__c sb : [SELECT id, ASI_MFM_Sub_brand_Code__c, ASI_CRM_Prompt_Payment_Rate__c 
                                                 FROM ASI_MFM_Sub_brand__c
                                                 WHERE RecordTypeId = :rtID
												 AND ASI_CRM_Allow_Prompt_Payment__c = true]) {
            sbMapping.put(sb.ASI_MFM_Sub_brand_Code__c, sb);
        }

        return sbMapping;
    }
	
    private Map<string, string> getSubbrandIDMap() {
        Map<string, string> sbMapping = new Map<string, string>();

        Id rtID = Global_RecordTypeCache.getRTId('ASI_MFM_Sub_brand__cASI_CRM_SG_Sub_brand');

        for(ASI_MFM_Sub_brand__c sb : [SELECT id, ASI_MFM_Sub_brand_Code__c 
                                                 FROM ASI_MFM_Sub_brand__c
                                                 WHERE RecordTypeId = :rtID
												 AND ASI_CRM_Allow_Prompt_Payment__c = true]) {
            sbMapping.put(sb.id, sb.ASI_MFM_Sub_brand_Code__c);
        }

        return sbMapping;
    }
	
	private void updateInvoice(set<string> set_invoiceID){
		list<ASI_CRM_Invoice__c> list_invoice = [select id from ASI_CRM_Invoice__c where id in :set_invoiceID];
		for (ASI_CRM_Invoice__c invoice : list_invoice){
			invoice.ASI_CRM_Generated_Prompt_Payment__c = true;
		}
		update list_invoice;
	}
    
	public static String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
		String s, tmp;
		Integer i = 4 + dec;
	 
		// If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
		if(dec==0){
			i--;
		}
	 
		s = val.setScale(dec).toPlainString().replace(tSep, dSep);
		while(s.length() > i) {
			tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
			s = tmp;
			i += 4;
		}
	 
		// If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
		if (s.substring(0,1) == '-') {
			if (s.substring(1,2) == tSep) {
				s = '-' + s.substring(2);
			}
		}
	 
		return s;
	}
}