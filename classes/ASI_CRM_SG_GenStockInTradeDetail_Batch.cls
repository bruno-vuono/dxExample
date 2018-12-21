/**********************************************************************************
 * Name : ASI_CRM_SG_GenStockInTradeDetail_Batch
 * Created : DC @03/18/2016 2:02 PM
 * Revision History:
 * 1. 03/18/2016 - [DC 1.0] Created
 * 2. 15 Apr 2016 - [VL 1.0] Also clone sub-brand
 * 2. 28 Apr 2016 - [VL 2.0] Correct the logic to get previous month records: selected by both previous month and year
 * 3. 25 May 2016 - [HC 1.0] Add constructor that allow user input the stock in trade detail date
 * 4. 26 May 2016 - [HC 2.0] Add record type condition of query 
 **********************************************************************************/

global class ASI_CRM_SG_GenStockInTradeDetail_Batch implements
    Database.Batchable<sObject>, Database.Stateful, Schedulable {

    private final static String JANUARY = 'Jan';
    private final static String FEBRUARY = 'Feb';
    private final static String MARCH = 'Mar';
    private final static String APRIL = 'Apr';
    private final static String MAY = 'May';
    private final static String JUNE = 'Jun';
    private final static String JULY = 'Jul';
    private final static String AUGUST = 'Aug';
    private final static String SEPTEMBER = 'Sep';
    private final static String OCTOBER = 'Oct';
    private final static String NOVEMBER = 'Nov';
    private final static String DECEMBER = 'Dec';
    public map<String,string> mapMonths=  new map<String, String>{
        JANUARY => DECEMBER,
        FEBRUARY => JANUARY,
        MARCH =>FEBRUARY,
        APRIL =>MARCH,
        MAY =>APRIL,
        JUNE  =>MAY,
        JULY  =>JUNE,
        AUGUST  =>JULY,
        SEPTEMBER  =>AUGUST,
        OCTOBER  =>SEPTEMBER,
        NOVEMBER  =>OCTOBER,
        DECEMBER =>NOVEMBER
    };
    

    //private String perviousMonth = DateTime.now().addMonths(-1).format('MMM').toUpperCase();
    private String perviousMonth = mapMonths.get(DateTime.now().format('MMM'));
    /* [VL 2.0] BEGIN */
    private String perviousYear = DateTime.now().addMonths(-1).format('YYYY');
    /* [VL 2.0] END */
    private Date recordDate = Date.today().toStartOfMonth();
    private Id detailRecordTypeId =
        Schema.SObjectType.ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c.getRecordTypeInfosByName()
                          .get('ASI_CRM_SG_WS_Depletion').getRecordTypeId();
    private List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> lstOfftakes_ToInsert =
        new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();
        
    private String query = 'SELECT Id'
                         + '     , ASI_CRM_Customer__c'
                         + '     , ASI_TH_CRM_Month__c'
                         + '     , ASI_CRM_SKU__c'
                         + '     , ASI_TH_CRM_Sub_brand__c'
                         + '     , ASI_TH_CRM_Ending_Stock_Final__c'
                         + '     , Name'
                         + '  FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c'
                         + ' WHERE ASI_TH_CRM_Month__c = \'' + perviousMonth + '\''
                        /* [VL 2.0] BEGIN */
                         + ' AND ASI_TH_CRM_Year__c = \'' + perviousYear + '\''
                        /* [VL 2.0] END */
                         + '   AND ASI_CRM_Customer__r.RecordType.DeveloperName = \'ASI_CRM_SG_Wholesaler\''
                         + ' AND RecordType.DeveloperName =\'ASI_CRM_SG_WS_Depletion\'';
    
    /* [HC 1.0] BEGIN */
    public ASI_CRM_SG_GenStockInTradeDetail_Batch() {
    }

    public ASI_CRM_SG_GenStockInTradeDetail_Batch(Integer month, Integer year) {
        recordDate = Date.newInstance(year, month, 01);
        
        Datetime recordDatetime = Datetime.newInstance(year, month, 01);
        
        perviousMonth = mapMonths.get(recordDatetime.format('MMM'));
        //perviousMonth = recordDatetime.addMonths(-1).format('MMM').toUpperCase();
        perviousYear = recordDatetime.addMonths(-1).format('YYYY');
        
        query = 'SELECT Id'
                         + '     , ASI_CRM_Customer__c'
                         + '     , ASI_TH_CRM_Month__c'
                         + '     , ASI_CRM_SKU__c'
                         + '     , ASI_TH_CRM_Sub_brand__c'
                         + '     , ASI_TH_CRM_Ending_Stock_Final__c'
                         + '     , Name'
                         + '  FROM ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c'
                         + ' WHERE ASI_TH_CRM_Month__c = \'' + perviousMonth + '\''
                        /* [VL 2.0] BEGIN */
                         + ' AND ASI_TH_CRM_Year__c = \'' + perviousYear + '\''
                        /* [VL 2.0] END */
                         + '   AND ASI_CRM_Customer__r.RecordType.DeveloperName = \'ASI_CRM_SG_Wholesaler\''
                         + ' AND RecordType.DeveloperName =\'ASI_CRM_SG_WS_Depletion\'';
    }
    /* [HC 1.0] END */

    global Database.QueryLocator start(Database.BatchableContext contextInstance) {
        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> lstStockDetails = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();
        lstStockDetails = (List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>) Database.query(query);
        system.debug(lstStockDetails.size());
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext contextInstance, list<Sobject> pLstFetchedOfftakes) {

        List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> lstFetchedOfftakes =
            (List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>)  pLstFetchedOfftakes;

        lstOfftakes_ToInsert = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();

        for(ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c detailIterator : lstFetchedOfftakes) {

            lstOfftakes_ToInsert.add( new ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c(
                ASI_TH_CRM_Date__c = recordDate,
                ASI_TH_CRM_Beginning_Stock__c = detailIterator.ASI_TH_CRM_Ending_Stock_Final__c,
                ASI_TH_CRM_Ending_Stock_Final__c = detailIterator.ASI_TH_CRM_Ending_Stock_Final__c,
                ASI_CRM_Customer__c = detailIterator.ASI_CRM_Customer__c,
                ASI_CRM_SKU__c = detailIterator.ASI_CRM_SKU__c,
                ASI_TH_CRM_Sub_brand__c = detailIterator.ASI_TH_CRM_Sub_brand__c,
                RecordTypeId = detailRecordTypeId
            ));

        }
            
        
        try {
            if( !lstOfftakes_ToInsert.isEmpty() ) {
                system.debug(lstOfftakes_ToInsert.size());
                insert lstOfftakes_ToInsert;
            }
        } catch(DmlException exceptionInstance) {
            
            System.debug('------ exceptionInstance ------ : ' + exceptionInstance.getMessage());
            System.debug('------ lstOfftakes_ToInsert ------ : ' + lstOfftakes_ToInsert);
        }

    }

    global void execute(SchedulableContext schedulableContextInstance) {}

    global void finish(Database.BatchableContext contextInstance) {
        /*
        try {
            if( !lstOfftakes_ToInsert.isEmpty() ) {
                //insert lstOfftakes_ToInsert;
                List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c> tempSITList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();
                
                Integer counter = 0;
                for (ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c t:lstOfftakes_ToInsert){
                    if (counter<100){
                        tempSITList.add(t);
                        counter++;
                    }
                    else {
                        insert tempSITList;
                        system.debug(tempSITList.size());
                        tempSITList = new List<ASI_TH_CRM_Offtake_Stock_In_Trade_Detail__c>();
                        tempSITList.add(t);
                        counter = 1;
                    }
                }
                system.debug(counter);
                system.debug(tempSITList.size());
                if (counter>0) insert tempSITList;
            }
        } catch(DmlException exceptionInstance) {
            
            System.debug('------ exceptionInstance ------ : ' + exceptionInstance.getMessage());
            System.debug('------ lstOfftakes_ToInsert ------ : ' + lstOfftakes_ToInsert);
        }
        */
    }
}