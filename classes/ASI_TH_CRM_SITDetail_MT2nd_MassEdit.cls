//Modified by William Yang 2014-04-16
//Avoid exception due to saving locked entries triggering validation rule

public without sharing class ASI_TH_CRM_SITDetail_MT2nd_MassEdit {
    private static integer MAX_MONTH_NUM = 6;

    public ID wholeSalerId { get; private set; }

    public ASI_TH_CRM_Offtake_Stock_In_Trade__c stockInTrade { get; set; }
    public ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c st_fromDate { get; set; }
    public ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c st_toDate{ get; set; }
    public String trustedOfftakeSIT {get; set;}
    public List<ASI_CRM_AccountsAdditionalField__c> customers {get;set;}
    
    String wholesaler = '';
    
    public List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> stockInTradeDetails{ get; private set;}
    
    //Modified by William Yang 2014-04-16
    public List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateStockInTradeDetails{ get; set;}
    
    public List<StockInTradeDetail> results{ get; set;}    
    
    public ASI_TH_CRM_SITDetail_MT2nd_MassEdit(ApexPages.StandardController controller) {
        this.wholeSalerId = ApexPages.currentPage().getParameters().get('id');
        stockInTrade = new ASI_TH_CRM_Offtake_Stock_In_Trade__c();
        stockInTrade.ASI_TH_CRM_Account__c = this.wholeSalerId;
        st_fromDate  = new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c();
        st_toDate = new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c();  

        //Added by William Yang(Introv) @2016-4-25
        trustedOfftakeSIT = 'Total Offtake'; //Default value
    }
    
    public void search(){
         if(stockInTrade.ASI_TH_CRM_Account__c == null){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select the Modern Trade.'));
             return;
         }else{
             wholesaler = stockInTrade.ASI_TH_CRM_Account__c;
         } 
                      
         //if(st_fromDate.ASI_TH_CRM_Date__c == null && st_toDate.ASI_TH_CRM_Date__c == null) return;
            
         Date fromDate = Date.newInstance(Date.today().year(),Date.today().month(),1);
         Date toDate = Date.newInstance(9999,12,31);
            
         if(st_fromDate.ASI_TH_CRM_Date__c != null){
             fromDate = Date.newInstance(st_fromDate.ASI_TH_CRM_Date__c.year(),st_fromDate.ASI_TH_CRM_Date__c.month(),1);
         }
            
         if(st_toDate.ASI_TH_CRM_Date__c != null){
             toDate = Date.newInstance(st_toDate.ASI_TH_CRM_Date__c.year(),st_toDate.ASI_TH_CRM_Date__c.month() + 1,1);
         }
         
        if((toDate.year() * 12 + toDate.month()) - (fromDate.year() *12 + fromDate.month()) > MAX_MONTH_NUM){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Maximum no. of month could not exceed 6! Please narrow down your search range.'));
            return;
        }      

        //Added by William Yang(Introv) @2016-4-25
        if(stockInTrade.ASI_TH_CRM_Account__c != null) {
            customers = [SELECT id, ASI_CRM_Trusted_Offtake_SIT__c FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_Account__c = :stockInTrade.ASI_TH_CRM_Account__c];
            if(customers != null & customers.size() > 0)    
                trustedOfftakeSIT = customers[0].ASI_CRM_Trusted_Offtake_SIT__c;
        }
            
        trustedOfftakeSIT = trustedOfftakeSIT != null && trustedOfftakeSIT != '' ? trustedOfftakeSIT : 'Total Offtake';
            
        stockInTradeDetails = [SELECT ASI_TH_CRM_Beginning_Stock__c, ASI_TH_CRM_Date__c, ASI_TH_CRM_Ending_Stock_Draft__c,ASI_TH_CRM_Ending_Stock_Final__c, Id, ASI_TH_CRM_Sell_In__c, ASI_TH_CRM_Sub_brand__c, ASI_TH_CRM_Total_Offtake_Draft__c, ASI_TH_CRM_Total_Offtake_Final__c, ASI_TH_CRM_SIT__c, ASI_TH_CRM_Others__c, ASI_TH_CRM_SIT__r.ASI_TH_CRM_Status__c FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c WHERE ASI_TH_CRM_Account__c = :wholesaler AND RecordType.DeveloperName = 'ASI_TH_CRM_MT_Stock_In_Trade_Detail' AND ASI_TH_CRM_Date__c >= :fromDate AND ASI_TH_CRM_Date__c < :toDate ORDER BY ASI_TH_CRM_Sub_brand__r.Name,ASI_TH_CRM_Date__c DESC]; 
         
         results = new List<StockInTradeDetail>();
         
         for (ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c offtakeStokeInTradeDetail : stockInTradeDetails){
             results.add(new StockInTradeDetail(offtakeStokeInTradeDetail));
         }   
    }
    
    public void save(){
         if(results == null || stockInTradeDetails == null) return;
         
         //Modified by William Yang 2014-04-16
         updateStockInTradeDetails = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();
         
         for (StockInTradeDetail stockInTradeDetail : results){
             for(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c offtakeStockInTradeDetail : stockInTradeDetails){
                 if(offtakeStockInTradeDetail.Id == stockInTradeDetail.detail.Id && offtakeStockInTradeDetail.ASI_TH_CRM_SIT__r.ASI_TH_CRM_Status__c != 'Locked'){
                    if(trustedOfftakeSIT == 'Total Offtake')
                        offtakeStockInTradeDetail.ASI_TH_CRM_Ending_Stock_Final__c = (stockInTradeDetail.detail.ASI_TH_CRM_Beginning_Stock__c != null? stockInTradeDetail.detail.ASI_TH_CRM_Beginning_Stock__c:0) + (stockInTradeDetail.detail.ASI_TH_CRM_Sell_In__c != null? stockInTradeDetail.detail.ASI_TH_CRM_Sell_In__c:0) + (stockInTradeDetail.detail.ASI_TH_CRM_Others__c != null? stockInTradeDetail.detail.ASI_TH_CRM_Others__c:0) - (stockInTradeDetail.detail.ASI_TH_CRM_Total_Offtake_Final__c!=null?stockInTradeDetail.detail.ASI_TH_CRM_Total_Offtake_Final__c:0);
                    else if(trustedOfftakeSIT == 'Ending Stock')
                        offtakeStockInTradeDetail.ASI_TH_CRM_Total_Offtake_Final__c = (stockInTradeDetail.detail.ASI_TH_CRM_Beginning_Stock__c != null? stockInTradeDetail.detail.ASI_TH_CRM_Beginning_Stock__c:0) + (stockInTradeDetail.detail.ASI_TH_CRM_Sell_In__c != null? stockInTradeDetail.detail.ASI_TH_CRM_Sell_In__c:0) + (stockInTradeDetail.detail.ASI_TH_CRM_Others__c != null? stockInTradeDetail.detail.ASI_TH_CRM_Others__c:0) - (stockInTradeDetail.detail.ASI_TH_CRM_Ending_Stock_Final__c!=null?stockInTradeDetail.detail.ASI_TH_CRM_Ending_Stock_Final__c:0);
                    
                    updateStockInTradeDetails.add(offtakeStockInTradeDetail);
                    break;
                 } 
             }
         }   
    
         System.Savepoint sp = database.setSavepoint();
          
          try {
              update updateStockInTradeDetails;

              search();
          } catch (DmlException dmle) {
              database.rollback(sp);
          } catch (Exception e) {
              database.rollback(sp);
          }
    }
    
    public class StockInTradeDetail{
    
        public ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c detail {get; set;}
        
        public String month{
            get{
                if (detail.ASI_TH_CRM_Date__c == null) return null;
                
                Datetime dt = datetime.newInstance(detail.ASI_TH_CRM_Date__c.year(), detail.ASI_TH_CRM_Date__c.month(),detail.ASI_TH_CRM_Date__c.day());
                return dt.format('MMM-yy');
            }
        }
        
        public StockInTradeDetail(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c detail){
            this.detail = detail;
        }
        
    }    
}