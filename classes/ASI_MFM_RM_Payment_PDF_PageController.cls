public with sharing class ASI_MFM_RM_Payment_PDF_PageController {

//Versino: 0.0.11
//Modified at: 2013/7/17
//1.Do not handle the multiple plan situation
//2.Change the value of vat finished
//3.Fix the looping of different plan
//4.Fix the null value problem of PoAmt line 113
//5.Fix the PaymentTotalAmount at the part under remark
//6.Change the percentage to non-calculated value
//7.Fix the missing sub_brand
    private final ASI_MFM_Payment__c Payment;
    public List<ASI_MFM_Payment_Line_Item__c> PaymentList_start{get;set;}
    public List<ASI_MFM_PO__c> PoList{get;set;} 
    public List<ASI_MFM_Plan__c> PlanList{get;set;} 
    public List<Payment_WrapperClass> WrapList{get;set;}
    public List<PaymentLineItem_WrapperClass>WrapItemList{get;set;}
    
    public Set<Id> PayeeNameSet;
    
    public decimal wpSubTotal{get;set;}
    public decimal subTotal{get;set;}
    public decimal vatPercentage{get;set;}
    public decimal wtPercentage{get;set;}
    public decimal insurPercentage{get;set;}
    public decimal total{get;set;}
    
    public boolean isOnePlan;
    public boolean isShowVat{get;set;}
    public boolean isShowWt{get;set;}
    public boolean isShowInsur{get;set;}
    
    public string planNumber{get;set;}
    public string planStatus{get;set;}
    public decimal totalPlanAmount{get;set;}
    public decimal totalActualAmount{get;set;}
    public decimal totalPOAmount{get;set;}
    
    public string poStatus{get;set;}
    public string payeeNameConcat{get;set;}   
   
    public string labelPlanStatus{get;set;}
    public string labeltotalPlanAmount{get;set;}
    public string labeltotalActualAmount{get;set;}
    public string labeltotalPOAmount{get;set;}
    public string labelPOStatus{get;set;}
    
    
    
    
    public ASI_MFM_RM_Payment_PDF_PageController(ApexPages.StandardController stdController){ 
        this.Payment = (ASI_MFM_Payment__c)stdController.getRecord();
        
        ASI_MFM_Payment__c Payment2 = [select ASI_MFM_VAT_Percentage__c,ASI_MFM_One_Off_Payee__c
        , ASI_MFM_Supplier_Name__r.Name,ASI_MFM_WT_Percentage__c
        , ASI_MFM_Insurance_Percentage__c,ASI_MFM_VAT_Amount__c
        , ASI_MFM_WT_Amount__c, ASI_MFM_Insurance_Amount__c from ASI_MFM_Payment__c
        where id =: Payment.id
        ];
        
        //System.debug('Vat Percentage ' + vatPercentage);
        //try{
        //System.debug('Vat Percentage string' + Payment2.ASI_MFM_VAT_Percentage__c);
        //}
        //catch(exception e){
        //  e.getMessage();
        //}
        
        System.debug('lga');
        isShowVat = true;
        isShowWt = true;
        isShowInsur = true;
        labelPlanStatus = 'Plan Status:';
        labeltotalPlanAmount = 'Total Plan Amount:';
        labeltotalActualAmount = 'Total Actual Amount';
        labeltotalPOAmount = 'Total PO amount';
        labelPOStatus = 'PO status';
        payeeNameConcat = null;
        
        if(Payment2.ASI_MFM_Supplier_Name__r.Name != null ){
            payeeNameConcat = Payment2.ASI_MFM_Supplier_Name__r.Name;
            
            if(Payment2.ASI_MFM_One_Off_Payee__c != null){
                payeeNameConcat = payeeNameConcat + ', ' + Payment2.ASI_MFM_One_Off_Payee__c;
            }
        }
        else{
            if(Payment2.ASI_MFM_One_Off_Payee__c != null){
                payeeNameConcat = Payment2.ASI_MFM_One_Off_Payee__c;
            }
        }
        
        //Percentage 
        if(Payment2.ASI_MFM_Insurance_Percentage__c == null){
            insurPercentage = 0;
            isShowInsur = false;
        }
        else{
            Integer startIndex_insur = Payment2.ASI_MFM_Insurance_Percentage__c.indexOf('(',0) + 1;
            Integer endIndex_insur = Payment2.ASI_MFM_Insurance_Percentage__c.indexOf('%',0);
            insurPercentage = decimal.valueOf(Payment2.ASI_MFM_Insurance_Percentage__c.subString(startIndex_insur,endIndex_insur));
            //System.debug('vatPercentage967 ' + vatPercentage);
            //vatPercentage = 9;
        }  
        
        
        if(Payment2.ASI_MFM_WT_Percentage__c == null){
            wtPercentage = 0;
            isShowWt = false;
        }
        else{
            Integer startIndex_wt = Payment2.ASI_MFM_WT_Percentage__c.indexOf('(',0) + 1;
            Integer endIndex_wt = Payment2.ASI_MFM_WT_Percentage__c.indexOf('%',0);
            wtPercentage = decimal.valueOf(Payment2.ASI_MFM_WT_Percentage__c.subString(startIndex_wt,endIndex_wt));
            //System.debug('vatPercentage967 ' + vatPercentage);
            //vatPercentage = 9;
        }        
        
        if(Payment2.ASI_MFM_VAT_Percentage__c == null){
            vatPercentage = 0;
            isShowVat = false;
        }
        else{
            Integer startIndex = Payment2.ASI_MFM_VAT_Percentage__c.indexOf('(',0) + 1;
            Integer endIndex = Payment2.ASI_MFM_VAT_Percentage__c.indexOf('%',0);
            vatPercentage = decimal.valueOf(Payment2.ASI_MFM_VAT_Percentage__c.subString(startIndex,endIndex));
            System.debug('vatPercentage967 ' + vatPercentage);
            //vatPercentage = 9;
        }
        
        
        //isOnePlan = true;
        wpSubTotal = 0;
        subTotal = 0;
        total = 0;
        totalActualAmount = 0;
        totalPoAmount = 0;
        
        
        
        PaymentList_start =[
        select 
        ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.ASI_MFM_Plan__r.Name,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.Name,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.id,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_List_Item_Description__c,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_A_C_Code__r.Name,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_A_C_Code__r.ASI_MFM_A_C_Code__c,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_Customer_Name__r.ASI_MFM_Customer_Supplier_Number__c,
        ASI_MFM_Payment_Amount__c,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.ASI_MFM_Plan__r.ASI_MFM_Status__c,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.ASI_MFM_Plan__r.ASI_MFM_Plan_Amount__c,   //Total Plan Amount    
        ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.ASI_MFM_Plan__r.id,
        ASI_MFM_SKU_Code__c,
        ASI_MFM_Invoice_Number__c,
        ASI_MFM_Payee__c,
        ASI_MFM_Payee__r.Name,
        ASI_MFM_Invoice_Date__c,
        ASI_MFM_PO_Line_Item__r.ASI_MFM_Sub_brand_Code__r.ASI_MFM_Sub_brand_Code__c,
        ASI_MFM_Payment_List_Item_Description__c
        from ASI_MFM_Payment_Line_Item__c where ASI_MFM_Payment__c =: this.Payment.id
        order by ASI_MFM_Print_Sequence__c, name];

        for (ASI_MFM_Payment_Line_Item__c i:PaymentList_start) {
            if (i.ASI_MFM_Payment_List_Item_Description__c != null) {
                i.ASI_MFM_Payment_List_Item_Description__c = i.ASI_MFM_Payment_List_Item_Description__c.left(100);
            }
        }            
        
        //Instantiate the value of payment line item
        if(PaymentList_start.size() != 0){   //bracket 9
            ASI_MFM_Payment_Line_Item__c payLineItem = PaymentList_start[0]; 
            
            
            //PlanSetId (Used to save the number of plan)
            Set<Id> planId = new Set<Id>();
            
            //Return the subTotal
            for(ASI_MFM_Payment_Line_Item__c eachPay:PaymentList_start){
                
                //Add the id to planId
                planId.add(eachPay.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.ASI_MFM_Plan__r.id);
                
                if(eachPay.ASI_MFM_Payment_Amount__c != null){
                    subTotal += eachPay.ASI_MFM_Payment_Amount__c;
                }
                //Set the PoAmt = 0 for null value
                if(eachPay.ASI_MFM_Payment_Amount__c == null){
                    eachPay.ASI_MFM_Payment_Amount__c = 0;
                }
            }
            
           
            //Retrun total
            total = subTotal;
            if(isShowVat && payment2.ASI_MFM_VAT_Amount__c != null){total += payment2.ASI_MFM_VAT_Amount__c;}
            if(isShowWt && payment2.ASI_MFM_WT_Amount__c != null){total += payment2.ASI_MFM_WT_Amount__c;}
            if(isShowInsur && payment2.ASI_MFM_Insurance_Amount__c != null){total += payment2.ASI_MFM_Insurance_Amount__c;}

            //PaymentItemList GroupBy Payee            
            PayeeNameSet = new Set<Id>();
            WrapItemList = new List<PaymentLineItem_WrapperClass>();
            for(ASI_MFM_Payment_Line_Item__c payline12: PaymentList_start){
                PayeeNameSet.add(payline12.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.id);
            } 
            
            for(Id payeeName : PayeeNameSet){
            
                PaymentLineItem_WrapperClass wp = new PaymentLineItem_WrapperClass(payeeName);
                for(ASI_MFM_Payment_Line_Item__c payline13: PaymentList_start){
                   
                    if(payline13.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.id == payeeName){
                        if(payline13.ASI_MFM_Payment_Amount__c != null){
                            wpSubTotal += payline13.ASI_MFM_Payment_Amount__c;
                        }
                        wp.paylineList_wrap.add(payline13); 
                    }
                    
                }
                wp.subTotal = wpSubTotal;              
                wrapItemList.add(wp);
                wpSubTotal = 0;
            }
            
            //re-arrange items in the wrapitemlist according to printSEQ
            Set<PaymentLineItem_WrapperClass> tempWrapItemSet = new Set<PaymentLineItem_WrapperClass>();
            List<PaymentLineItem_WrapperClass> tempWrapItemList = new List<PaymentLineItem_WrapperClass>();
            System.debug('Hell :' +  PaymentList_start);
            for(ASI_MFM_Payment_Line_Item__c tempPLItem: PaymentList_start){
                 
                for(PaymentLineItem_WrapperClass tempwrap : wrapItemList){
                    if(tempPLItem.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.id ==tempwrap.payeeName)
                      if(!tempWrapItemSet.contains(tempwrap)){
                          tempWrapItemSet.add(tempwrap);
                          tempWrapItemList.add(tempwrap);
                      }
                     
                      //tempWrapItemList.add(tempwrap);
                    
                }   
             
            }
            
            WrapItemList = tempWrapItemList;
            
            
            //Many Plan Situation
            //Retrieve all the plans from the payment line item list
            wrapList = new List<Payment_WrapperClass>();
            
            planList = new List<ASI_MFM_Plan__c>();
            planList = [select id,name,ASI_MFM_Status__c,ASI_MFM_Actual_Amount__c,
            ASI_MFM_Plan_Amount__c from ASI_MFM_Plan__c where id in : planId];
            
            //System.debug('plan List size ' + planList.size());
            
            for(ASI_MFM_Plan__c plan1 : planList){
                //System.debug('lgv plan name' + plan1.Name);
                
                Payment_WrapperClass wc = new Payment_WrapperClass(plan1);
                
                for(ASI_MFM_Payment_Line_Item__c payline7: PaymentList_start){
                    if(payline7.ASI_MFM_PO_Line_Item__r.ASI_MFM_PO__r.ASI_MFM_Plan__r.id == plan1.id){
                        if(payline7.ASI_MFM_Payment_Amount__c != null){
                            totalActualAmount += payline7.ASI_MFM_Payment_Amount__c; 
                        }
                        //wc.paylineList.add(payline7);
                    }
                }
                /*
                if(paylineList.size() != 0){
                    wc.planline_firstItem = wc.paylineList[0];
                    wc.paylineList.remove(0);
                }
                */
                wc.totalActualAmount = totalActualAmount;
                wrapList.add(wc);
                totalActualAmount = 0;     //Initialize the paymentActualAmount to 0
            }
            


            
        }//bracket 9    
            
                       
    }   
    
    public class PaymentLineItem_WrapperClass {
        public decimal subTotal{get;set;}
        public List<ASI_MFM_Payment_Line_Item__c> paylineList_wrap{get;set;}
        public string payeeName{get;set;}

        public PaymentLineItem_WrapperClass(String p)
        {   
            this.payeeName = p;
            this.subTotal = 0;
            this.paylineList_wrap = new List<ASI_MFM_Payment_Line_Item__c>();
    
        }   
    }
    
    //The bottom table
    public class Payment_WrapperClass {
        public ASI_MFM_Plan__c plan{get;set;}
        public ASI_MFM_PO__c poline_firstItem{get;set;}
        public List<ASI_MFM_Payment_Line_Item__c> paylineList{get;set;}
        public List<ASI_MFM_PO__c> PoList{get;set;} 
        public decimal totalPoAmount{get;set;}
        public decimal totalActualAmount{get;set;}    
        // Base currency  
        public decimal poActualBaseTotalAmount{get;set;}
        
        public Payment_WrapperClass(ASI_MFM_Plan__c p)
        {   
            //totalPoAmount = 0;
            poActualBaseTotalAmount = 0;
            plan = p;
            //paylineList = new List<ASI_MFM_Payment_Line_Item__c>();
            poline_firstItem = new ASI_MFM_PO__c();
            PoList = new List<ASI_MFM_PO__c>();
            PoList = [select ASI_MFM_PO_Amount__c, Name, ASI_MFM_Base_Currency_Amount__c,
            ASI_MFM_Status__c from ASI_MFM_PO__c where ASI_MFM_Plan__c =: plan.id];
            
            //Calculate the total PO Amt
            for(ASI_MFM_PO__c po1:PoList){      
                /*if(po1.ASI_MFM_PO_Amount__c != null){
                    totalPoAmount += po1.ASI_MFM_PO_Amount__c;
                }*/
                if (po1.ASI_MFM_Base_Currency_Amount__c != null)
                {
                    poActualBaseTotalAmount += po1.ASI_MFM_Base_Currency_Amount__c;
                }
            }
            poline_firstItem = PoList[0];
            PoList.remove(0);   
            ////////////////////
    }
    


}
    
}