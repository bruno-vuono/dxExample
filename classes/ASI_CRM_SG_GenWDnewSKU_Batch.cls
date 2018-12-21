/**********************************************************************************
 * Name : ASI_CRM_SG_GenWDnewSKU_Batch 
 * Created : Vincent Lam
 * Revision History:
 * 1. 14 Nov 2016 - [VL] Created; clone from ASI_CRM_SG_GenWholesalerDepletion_Batch, prevent governor limit
 **********************************************************************************/

global class ASI_CRM_SG_GenWDnewSKU_Batch 
    implements Database.Batchable<AggregateResult>, Database.Stateful, Schedulable {

    private List<ASI_CRM_AccountsAdditionalField__c> lstFetchedCustomers =
        [SELECT Id
           FROM ASI_CRM_AccountsAdditionalField__c
          WHERE RecordType.DeveloperName = 'ASI_CRM_SG_Wholesaler'];
    
    /* [VL 4.1] BEGIN */
    private Map<id, ASI_CRM_AccountsAdditionalField__c> map_wholesalerID_wholesaler = new Map<id, ASI_CRM_AccountsAdditionalField__c>(lstFetchedCustomers);
    /* [VL 4.1] END */
    
    private Id depletionRecordTypeId = Global_RecordTypeCache.getRTId('ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__cASI_CRM_SG_WS_Depletion');
        
    private date earliestDate = [SELECT ASI_TH_CRM_Date__c
                                           FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c
                                          WHERE RecordType.DeveloperName ='ASI_CRM_SG_WS_Depletion'                                         
                                       ORDER BY ASI_TH_CRM_Date__c ASC limit 1][0].ASI_TH_CRM_Date__c.toStartOfMonth();
                                       
    private date latestDate = [SELECT ASI_TH_CRM_Date__c
                                           FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c
                                          WHERE RecordType.DeveloperName ='ASI_CRM_SG_WS_Depletion'                                         
                                       ORDER BY ASI_TH_CRM_Date__c DESC limit 1][0].ASI_TH_CRM_Date__c.addMonths(1).toStartOfMonth().addDays(-1);
                                       
    private datetime startDate = date.today().adddays(-1);
    private datetime endDate = date.today().adddays(1);
    
    private string fromObject = 'offtake';
    
    public ASI_CRM_SG_GenWDnewSKU_Batch (string fromObject) {
        this.fromObject = fromObject;
    }                                            
    
    public ASI_CRM_SG_GenWDnewSKU_Batch (string fromObject, string startString, string endString) {
        this.fromObject = fromObject;
        this.startDate = Datetime.valueof(startString+' 00:00:00 GMT');
        this.endDate =Datetime.valueof(endString+' 00:00:00 GMT');
    }                                            
    
    global class AggregateResultIterable implements Iterable<AggregateResult> {
        public string fromObject;  
        public datetime startDate;  
        public datetime endDate;  
        public set<id> setWSid;  
        global AggregateResultIterable (string fromObject, datetime startDate, datetime endDate, set<id> setWSid){
             this.fromObject = fromObject;
             this.startDate = startDate;
             this.endDate= endDate;
             this.setWSid= setWSid;
         }
        global Iterator<AggregateResult> Iterator(){
            return new AggregateResultIterator(fromObject, startDate, endDate, setWSid);
       }
    }
 
    global class AggregateResultIterator implements Iterator<AggregateResult> {
        AggregateResult [] results {get;set;}
        Integer index {get; set;} 
 
        global AggregateResultIterator(string fromObject, datetime startDate, datetime endDate, set<id> setWSid) {
            index = 0;
            if (fromObject == 'offtake') {
                results = [select ASI_CRM_SKU__c sku, ASI_CRM_FromWS__c ws
                                from ASI_TH_CRM_Actual_Offtake__c WHERE  
                                RecordType.DeveloperName = 'ASI_CRM_SG_Actual_offtake' 
                                AND ASI_CRM_FromWS__c <> null 
                                AND ASI_CRM_SKU__c <> null 
                                AND ASI_CRM_FromWS__c in :setWSid 
                                AND (LastModifiedDate >= :startDate and LastModifiedDate <= :endDate) 
                                group by ASI_CRM_SKU__c, ASI_CRM_FromWS__c];       
            } else {
                results = [select ASI_HK_CRM_Product_SKU__c sku, ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c ws
                                from ASI_HK_CRM_Sales_Order_History_Detail__c WHERE  
                                RecordType.DeveloperName = 'ASI_CRM_SG_Sales_Order_History_Detail' 
                                AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c <> null 
                                AND ASI_HK_CRM_Product_SKU__c <> null 
                                AND ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c in :setWSid
                                AND ASI_HK_CRM_Sales_Order_History__r.ASI_HK_CRM_Order_Type__c in ('Singapore DF & DP Free Issue - F1','Singapore DF & DP Sales Order - SO') 
                                AND (LastModifiedDate >= :startDate and LastModifiedDate <= :endDate) 
                                group by ASI_HK_CRM_Product_SKU__c , ASI_HK_CRM_Sales_Order_History__r.ASI_CRM_Sold_To__c ];   
            }    
        } 
 
        global boolean hasNext(){ 
           return results != null && !results.isEmpty() && index < results.size(); 
        }    
 
        global AggregateResult next(){ 
            return results[index++];            
        }       
    }    
 
    global Iterable<AggregateResult> start(Database.batchableContext info){
        // just instantiate the new iterable here and return
        return new AggregateResultIterable(fromObject, startDate, endDate, map_wholesalerID_wholesaler.keySet());
    }
 
    global void execute(Database.BatchableContext contextInstance, list<AggregateResult> pLstFetchedRecords) {
        AggregateResult ar = pLstFetchedRecords[0];
        string arWS = String.valueOf(ar.get('ws'));
        string arSKU = String.valueOf(ar.get('sku'));
        list<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> lstWholesalerDepletions = new list<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();

        // DC - Fetched existing wholesaler depletion records.
        list<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> lstWDexist = [SELECT id
                       FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c
                      WHERE RecordType.DeveloperName ='ASI_CRM_SG_WS_Depletion'   
                      and ASI_CRM_Customer__c = :arWS
                      and ASI_CRM_SKU__c = :arSKU 
                   limit 1];
                                            
        if (lstWDexist.size()<=0) {
        
            string subBrandID = [select ASI_MFM_Sub_brand__c from ASI_MFM_SKU_Code__c where id = :arSKU limit 1][0].ASI_MFM_Sub_brand__c;
        
            Date earliestDatePlaceHolder = earliestDate;
            while(earliestDatePlaceHolder <= latestDate) { 
                lstWholesalerDepletions.add( new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c(                       
                            RecordTypeId = depletionRecordTypeId,
                            ASI_CRM_SKU__c = arSKU ,
                            ASI_TH_CRM_Date__c = earliestDatePlaceHolder,
                            ASI_CRM_Customer__c = arWS,
                            ASI_TH_CRM_Beginning_Stock__c = 0,
                            ASI_TH_CRM_FOC__c = 0,
                            ASI_TH_CRM_Total_Offtake_Final__c = 0,
                            ASI_TH_CRM_Sell_In__c = 0,
                            ASI_TH_CRM_Ending_Stock_Final__c = 0,
                            ASI_TH_CRM_Sub_brand__c = subBrandID 
                        ) );

                    earliestDatePlaceHolder = earliestDatePlaceHolder.addMonths(1);
            }
    
            try {
    
                system.debug('------------ lstWholesalerDepletions ------------'+lstWholesalerDepletions);
                
                if( !lstWholesalerDepletions.isEmpty() ) {
                    insert lstWholesalerDepletions;
                }
    
            } catch(DmlException exceptionInstance) {
                // DC - TODO : Nothing
            }
        }

    }
    

    /* [DC 3.1] BEGIN */
    public void execute(SchedulableContext contextInstance) {}
    /* [DC 3.1] END */

    global void finish(Database.BatchableContext contextInstance) {
        // DC - TODO : Nothing
    }
}