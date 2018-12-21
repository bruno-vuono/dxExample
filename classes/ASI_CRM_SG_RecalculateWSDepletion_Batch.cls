/**********************************************************************************
 * Name : ASI_CRM_SG_RecalculateWSDepletion_Batch
 *
 * Description: Recalculate the offtake and closing stock when the actual offtake is updated
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2016/05/11       Laputa: Hugo            Created
 **********************************************************************************/

global class ASI_CRM_SG_RecalculateWSDepletion_Batch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    private final static String QUERY = 'SELECT ASI_TH_CRM_Date__c ' +  
                                        'FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c ' + 
                                        'WHERE RecordType.DeveloperName = \'ASI_CRM_SG_WS_Depletion\'' + 
                                        'AND ASI_TH_CRM_Sell_In__c != 0 ' + 
                                        'AND ASI_TH_CRM_Total_Offtake_Final__c != 0 ' + 
                                        'AND ASI_TH_CRM_FOC__c != 0 ' + 
                                        'Order By ASI_TH_CRM_Date__c DESC';

    private final static Set<String> OFFTAKE_STOCK_IN_TRADE_DETAIL_RECORD_TYPE = new Set<String> {
        'ASI_CRM_SG_WS_Depletion'
    };

    private final static Set<String> WHOLESALER_RECORD_TYPE = new Set<String> {
        'ASI_CRM_SG_Wholesaler'
    };

    private final static Set<String> ACTUAL_OFFTAKE_RECORD_TYPE = new Set<String> {
        'ASI_CRM_SG_Actual_Offtake'
    };

    private final static String[] monthArray = new String[]{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
    private final static Map<String, Integer> monthMap = new Map<String, Integer>{
        'Jan' => 1,
        'Feb' => 2,
        'Mar' => 3,
        'Apr' => 4,
        'May' => 5,
        'Jun' => 6,
        'Jul' => 7,
        'Aug' => 8,
        'Sep' => 9,
        'Oct' => 10,
        'Nov' => 11,
        'Dec' => 12
    };

    public ASI_CRM_SG_RecalculateWSDepletion_Batch() {
    }

    global Database.QueryLocator start(Database.BatchableContext contextInstance) {
        return Database.getQueryLocator(QUERY);
    }

    global void execute(Database.BatchableContext contextInstance, List<sObject> scope) {
        //Get all Wholesaler
        Map<Id, ASI_CRM_AccountsAdditionalField__c> allWholesalerMap = new Map<Id, ASI_CRM_AccountsAdditionalField__c>([SELECT Id
                                                                                                                           FROM ASI_CRM_AccountsAdditionalField__c
                                                                                                                              WHERE RecordType.DeveloperName in :WHOLESALER_RECORD_TYPE]);

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> latestOfftakeStockInTradeDetailList = (List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>) scope;
        
        //If update the actual offtake, the G/L date must within 3 months  
        Date startDepletionMonth = latestOfftakeStockInTradeDetailList[0].ASI_TH_CRM_Date__c.addMonths(-4);

        //Get the month that within 3 month of letest offtake stock in trade detail date 
        List<String> monthList = new List<String>();
        List<String> yearList = new List<String>();
        for(Integer i = 0 ; i < 3 ; i++) {

            monthList.add(monthArray[latestOfftakeStockInTradeDetailList[0].ASI_TH_CRM_Date__c.addMonths(-i).month() - 1]);
            yearList.add(String.valueOf(latestOfftakeStockInTradeDetailList[0].ASI_TH_CRM_Date__c.addMonths(-i).year()));

        }

        //Get all updated Actual Offtake
        List<ASI_TH_CRM_Actual_Offtake__c> updatedActualOfftakeList = [SELECT Id, ASI_CRM_FromWS__c, ASI_CRM_SKU__c, ASI_TH_CRM_Offtake_G_L_Date__c
                                                                          FROM ASI_TH_CRM_Actual_Offtake__c
                                                                             WHERE RecordType.DeveloperName in :ACTUAL_OFFTAKE_RECORD_TYPE
                                                                                AND ASI_CRM_FromWS__c <> Null
                                                                                AND ASI_CRM_SKU__c <> Null
                                                                                AND ASI_CRM_FromWS__c in :allWholesalerMap.keySet()
                                                                                AND ASI_TH_CRM_Offtake_G_L_Date__c >= :startDepletionMonth
                                                                                AND (LastModifiedDate = TODAY OR LastModifiedDate = YESTERDAY)];

        List<Id> skuIdList = new List<Id>();
        List<Id> wholersalerIdList = new List<Id>();
        List<ActualOfftakeWrapper> actualOfftakeWrapperList = new List<ActualOfftakeWrapper>();

        for(ASI_TH_CRM_Actual_Offtake__c updateActualOfftake : updatedActualOfftakeList) {

            skuIdList.add(updateActualOfftake.ASI_CRM_SKU__c);
            wholersalerIdList.add(updateActualOfftake.ASI_CRM_FromWS__c);

            actualOfftakeWrapperList.add(new ActualOfftakeWrapper(
                                                        updateActualOfftake.ASI_CRM_SKU__c,
                                                        updateActualOfftake.ASI_CRM_FromWS__c,
                                                        updateActualOfftake.ASI_TH_CRM_Offtake_G_L_Date__c.month(),
                                                        updateActualOfftake.ASI_TH_CRM_Offtake_G_L_Date__c.year()
                                                        ));
        }

        //Get all Actual Offtake that with in 3 month
        List<AggregateResult> allActualOfftakeList = [SELECT ASI_CRM_FromWS__c, ASI_CRM_SKU__c, SUM(ASI_TH_CRM_Quantity__c)Sum_Offtake, CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c)Offtake_Month, CALENDAR_YEAR(ASI_TH_CRM_Offtake_G_L_Date__c)Offtake_Year
                                                         FROM ASI_TH_CRM_Actual_Offtake__c
                                                            WHERE RecordType.DeveloperName in :ACTUAL_OFFTAKE_RECORD_TYPE
                                                               AND ASI_CRM_SKU__c <> Null
                                                               AND ASI_CRM_FromWS__c <> Null
                                                               AND ASI_CRM_SKU__c in :skuIdList
                                                               AND ASI_CRM_FromWS__c in :wholersalerIdList
                                                               AND ASI_TH_CRM_Offtake_G_L_Date__c >= :startDepletionMonth
                                                                   GROUP BY ASI_CRM_SKU__c, ASI_CRM_FromWS__c, CALENDAR_MONTH(ASI_TH_CRM_Offtake_G_L_Date__c), CALENDAR_YEAR(ASI_TH_CRM_Offtake_G_L_Date__c)];

        List<ActualOfftakeWrapper> relatedActualOfftakeWrapperList = new List<ActualOfftakeWrapper>();

        //Get the actual offtake which is updated
        for(AggregateResult actualOfftake : allActualOfftakeList) {

            Boolean isUpdatedActualOfftake = false;
            Integer index = 0;

            Id skuId = Id.valueOf(String.valueOf(actualOfftake.get('ASI_CRM_SKU__c')));
            Id wholesalerId = Id.valueOf(String.valueOf(actualOfftake.get('ASI_CRM_FromWS__c')));
            Integer month = Integer.valueOf(actualOfftake.get('Offtake_Month'));
            Integer year = Integer.valueOf(actualOfftake.get('Offtake_Year'));
            Decimal sumOfftake = Decimal.valueOf(String.valueOf(actualOfftake.get('Sum_Offtake')));

            while(!isUpdatedActualOfftake && index < actualOfftakeWrapperList.size()) {

                ActualOfftakeWrapper actualOfftakeWrapper = actualOfftakeWrapperList.get(index);

                //If the Actual offtake sku Id, wholesaler Id, month and year same with updated Actual Offtake
                if(actualOfftakeWrapper.validateActualOfftake(skuId, wholesalerId, month, year)) {

                    isUpdatedActualOfftake = true;

                }

                index++;

            }

            //Store the Actual offtake as ActualOfftakeWrapper for updating the offtake stock in trade detail
            if(isUpdatedActualOfftake) {
                relatedActualOfftakeWrapperList.add(new ActualOfftakeWrapper(skuId, wholesalerId, month, year, sumOfftake));
            }

        }

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> depletionList = [SELECT Id, 
                                                                           ASI_CRM_SKU__c, ASI_CRM_Customer__c, 
                                                                           ASI_TH_CRM_Total_Offtake_Final__c, 
                                                                           ASI_TH_CRM_Beginning_Stock__c, 
                                                                           ASI_TH_CRM_Sell_In__c,
                                                                           ASI_TH_CRM_FOC__c,
                                                                           ASI_CRM_Adjusted_Quantity__c,
                                                                           ASI_TH_CRM_Month__c, 
                                                                           ASI_TH_CRM_Year__c
                                                                              FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c
                                                                                 WHERE RecordType.DeveloperName in :OFFTAKE_STOCK_IN_TRADE_DETAIL_RECORD_TYPE 
                                                                                    AND ASI_CRM_SKU__c in :skuIdList
                                                                                    AND ASI_CRM_Customer__c in :wholersalerIdList
                                                                                    AND ASI_TH_CRM_Month__c in :monthList
                                                                                    AND ASI_TH_CRM_Year__c in :yearList];

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateDepletionList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();

        for(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c offtakeStockInTradeDetail : depletionList) {

            Boolean requestUpdate = false;
            Integer index = 0;

            while(!requestUpdate && index < relatedActualOfftakeWrapperList.size()) {

                ActualOfftakeWrapper actualOfftakeWrapper = relatedActualOfftakeWrapperList.get(index);

                //If the Actual offtake sku Id, wholesaler Id, month and year same with updated Actual Offtake
                if(actualOfftakeWrapper.validateActualOfftake(
                                                    offtakeStockInTradeDetail.ASI_CRM_SKU__c,
                                                    offtakeStockInTradeDetail.ASI_CRM_Customer__c,
                                                    monthMap.get(offtakeStockInTradeDetail.ASI_TH_CRM_Month__c),
                                                    Integer.valueOf(offtakeStockInTradeDetail.ASI_TH_CRM_Year__c)
                                                    )) {

                    requestUpdate = true;

                    offtakeStockInTradeDetail.ASI_TH_CRM_Total_Offtake_Final__c = actualOfftakeWrapper.sumOfftake;

                    Decimal endingStock = (offtakeStockInTradeDetail.ASI_TH_CRM_Beginning_Stock__c != null ? offtakeStockInTradeDetail.ASI_TH_CRM_Beginning_Stock__c : 0)
                                        + (offtakeStockInTradeDetail.ASI_TH_CRM_Sell_In__c != null ? offtakeStockInTradeDetail.ASI_TH_CRM_Sell_In__c : 0)
                                        + (offtakeStockInTradeDetail.ASI_TH_CRM_FOC__c != null ? offtakeStockInTradeDetail.ASI_TH_CRM_FOC__c : 0)
                                        - (offtakeStockInTradeDetail.ASI_TH_CRM_Total_Offtake_Final__c != null ? offtakeStockInTradeDetail.ASI_TH_CRM_Total_Offtake_Final__c : 0)
                                        + (offtakeStockInTradeDetail.ASI_CRM_Adjusted_Quantity__c != null ? offtakeStockInTradeDetail.ASI_CRM_Adjusted_Quantity__c : 0);

                    offtakeStockInTradeDetail.ASI_TH_CRM_Ending_Stock_Final__c = endingStock;             

                    updateDepletionList.add(offtakeStockInTradeDetail);
                }

                index++;

            }

        }

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> tempDepletionStockList = updateDepletionStock(depletionList, updateDepletionList);
        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateDepletionStockList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();

        //Remove the duplicate deplation
        for(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c tempDepletionStock : tempDepletionStockList) {

            Boolean isContain = false;

            for(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c updateDepletionStock : updateDepletionStockList) {

                if(updateDepletionStock.Id == tempDepletionStock.Id) {

                    isContain = true;

                }

            }

            if(!isContain) {
                updateDepletionStockList.add(tempDepletionStock);
            }

        }

        update updateDepletionStockList;                                                                         
    }

    global void execute(SchedulableContext contextInstance) {
    }

    global void finish(Database.BatchableContext contextInstance) {
    }

    private List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateDepletionStock(List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> allDepletionList, List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateDepletionList) {

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateBeginingStockDepletionList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();
        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> updateBothStockDepletionList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();

        for(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c updateDepletion : updateDepletionList) {

            Id skuId = updateDepletion.ASI_CRM_SKU__c;
            Id wholesalerId = updateDepletion.ASI_CRM_Customer__c;
            Integer month = monthMap.get(updateDepletion.ASI_TH_CRM_Month__c);
            Integer year = Integer.valueOf(updateDepletion.ASI_TH_CRM_Year__c);

            if(month == 12) {
                month = 1;
            } else {
                month++;
            }

            Boolean isUpdate = false;
            Integer index = 0;

            while(!isUpdate && index < allDepletionList.size()) {

                ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c depletion = allDepletionList.get(index);

                if(depletion.ASI_CRM_SKU__c == skuId && 
                   depletion.ASI_CRM_Customer__c == wholesalerId &&
                   depletion.ASI_TH_CRM_Month__c == monthArray[month - 1] &&
                   depletion.ASI_TH_CRM_Year__c == String.valueOf(year)) {

                    depletion.ASI_TH_CRM_Beginning_Stock__c = updateDepletion.ASI_TH_CRM_Ending_Stock_Final__c;

                    if(depletion.ASI_TH_CRM_Sell_In__c != 0 &&
                       depletion.ASI_TH_CRM_Total_Offtake_Final__c != 0 &&
                       depletion.ASI_TH_CRM_FOC__c != 0) {

                        depletion.ASI_TH_CRM_Ending_Stock_Final__c = (depletion.ASI_TH_CRM_Beginning_Stock__c != null ? depletion.ASI_TH_CRM_Beginning_Stock__c : 0)
                                                                   + (depletion.ASI_TH_CRM_Sell_In__c != null ? depletion.ASI_TH_CRM_Sell_In__c : 0)
                                                                   + (depletion.ASI_TH_CRM_FOC__c != null ? depletion.ASI_TH_CRM_FOC__c : 0)
                                                                   - (depletion.ASI_TH_CRM_Total_Offtake_Final__c != null ? depletion.ASI_TH_CRM_Total_Offtake_Final__c : 0)
                                                                   + (depletion.ASI_CRM_Adjusted_Quantity__c != null ? depletion.ASI_CRM_Adjusted_Quantity__c : 0);

                        updateBothStockDepletionList.add(depletion);

                    } else {

                        updateBeginingStockDepletionList.add(depletion);

                    }

                    isUpdate = true;

                }

                index++;

            }

        }

        updateDepletionList.addAll(updateBeginingStockDepletionList);

        if(updateBothStockDepletionList.size() > 0) {
            updateDepletionList.addAll(updateDepletionStock(allDepletionList, updateBothStockDepletionList));
        }

        return updateDepletionList;
    }

    private class ActualOfftakeWrapper {

        public Id skuId {get; set;}
        public Id wholersalerId {get; set;}
        public Integer month {get; set;}
        public Integer year {get; set;}
        public Decimal sumOfftake {get; set;}

        public ActualOfftakeWrapper(Id skuId, Id wholersalerId, Integer month, Integer year) {
            this.skuId = skuId;
            this.wholersalerId = wholersalerId;
            this.month = month;
            this.year = year;
        }

        public ActualOfftakeWrapper(Id skuId, Id wholersalerId, Integer month, Integer year, Decimal sumOfftake) {
            this(skuId, wholersalerId, month, year);
            this.sumOfftake = sumOfftake;
        }

        public Boolean validateActualOfftake(Id skuId, Id wholersalerId, Integer month, Integer year) {

            if(this.skuId != skuId) {
                return false;
            }

            if(this.wholersalerId != wholersalerId) {
                return false;
            }

            if(this.month != month) {
                return false;
            }

            if(this.year != year) {
                return false;
            }

            return true;
        }

    }
}