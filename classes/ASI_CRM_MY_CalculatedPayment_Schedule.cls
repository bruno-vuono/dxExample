/*********************************************************************************
 * Name: ASI_CRM_MY_CalculatedFOCPayment_Schedule 
 * Description: Schedule job --> call the genFOC method to snap the result to “Calculated FOC” as previous month FOC
 *
        ASI_CRM_MY_CalculatedFOCPayment_Schedule p = new ASI_CRM_MY_CalculatedFOCPayment_Schedule();
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------
 * 2018-02-06       Hugo                    Initial
 *********************************************************************************/
 

Public class ASI_CRM_MY_CalculatedPayment_Schedule implements Schedulable{
	private ASI_CRM_MY_Settings__c my_cs = ASI_CRM_MY_Settings__c.getInstance();
    public Date today{get; private set;}{today =my_cs!=null && my_cs.ASI_CRM_MY_Temp_Today__c!=null ? my_cs.ASI_CRM_MY_Temp_Today__c: Date.today();}
    public Integer intCutOffDay {get; private set;}{intCutOffDay = my_cs!=null && my_cs.ASI_CRM_MY_Offtake_Cutoff_Day__c!=null ? Integer.valueOf(ASI_CRM_MY_Settings__c.getInstance().ASI_CRM_MY_Offtake_Cutoff_Day__c) : null;}
    
    public void execute(SchedulableContext ctx){
        genCalculatedPayment();
    }

    public void genCalculatedPayment(){
        //Date dteDate = System.today(); //.addDays(-1);
       
        //check if there are 5 active batch jobs 
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
            genCalculatedPayment(today);
        } 
        else {
            //schedule this same schedulable class again in 2 mins
            ASI_CRM_MY_CalculatedPayment_Schedule scRetry = new ASI_CRM_MY_CalculatedPayment_Schedule(); 
            Datetime dt = Datetime.now();
            dt = dt.addMinutes(2);
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy'); 
            Id schedId = System.Schedule('ASI_CRM_MY_CalculatedPayment_Schedule'+timeForScheduler,timeForScheduler,scRetry);
        } 
    }

    /// To run a single month FOC, by passing a parameter to the method
    public void genCalculatedPayment(Date dteRunDate){
        // Declaration
        id idRT_AOHeader = Global_RecordTypeCache.getRTId('ASI_CRM_ActualOfftakeHeader__cASI_CRM_MY_ActualOfftakeHeader');
                
        //integer intCutOffDay;
        integer intBatchLimit = 2500;
        //integer intBatchLimit = 100;
        boolean blnTodayCutoff = false;
        integer intOfftakeCount = 0;
        integer intBatch = 1;
        boolean haveData = false;
        
        set<id> setCustomer = new set<id>();
        set<id> setOTHeader = new set<id>();
        
        date dteStart;
        date dteEnd;
        
        map<id, integer> mapIDBatch = new map<id, integer>();
        
        List<ASI_CRM_ActualOfftakeHeader__c> lstAOHeader = new List<ASI_CRM_ActualOfftakeHeader__c>();
        List<ASI_TH_CRM_Actual_Offtake__c> lstAO = new List<ASI_TH_CRM_Actual_Offtake__c>();
        // Declaration - End
        /*
        List<ASI_CRM_MY_Settings__c> lstMYSetting = [SELECT ASI_CRM_MY_Offtake_Cutoff_Day__c FROM ASI_CRM_MY_Settings__c WHERE ASI_CRM_MY_Offtake_Cutoff_Day__c != NULL LIMIT 1];
        if(lstMYSetting != NULL && lstMYSetting.size() > 0){
            intCutOffDay = integer.valueOf(lstMYSetting[0].ASI_CRM_MY_Offtake_Cutoff_Day__c);
        }
        */
        if(Test.isRunningTest()){
            intCutOffDay = today.day();
            blnTodayCutoff = true;
        }

        // Run 
        if(dteRunDate.Day() >= intCutOffDay) {
            dteStart = date.newinstance(dteRunDate.Year(), dteRunDate.Month(), intCutOffDay);
            // To include one more day if this is the start the offtake month
            // To cater the case the the job run at 21:00 on the last cutoff but missed the 2100-2359 offtake
            if (dteRunDate.Day() == intCutOffDay) {
                dteStart.addDays(-1);
            }
            dteEnd = date.newinstance(dteRunDate.addMonths(1).Year(), dteRunDate.addMonths(1).Month(), intCutOffDay);
            dteEnd = dteEnd.addDays(-1);
        }else{
            dteStart = date.newinstance(dteRunDate.addMonths(-1).Year(), dteRunDate.addMonths(-1).Month(), intCutOffDay);
            dteEnd = date.newinstance(dteRunDate.Year(), dteRunDate.Month(), intCutOffDay);
            dteEnd = dteEnd.addDays(-1);
        }
        if (dteRunDate.addDays(1).Day() == intCutoffDay) {
            blnTodayCutoff = true;
        }
        
        system.debug('------------------------ASI_CRM_MY_CalculatedFOCPayment_Schedule dteStart : ' + dteStart + ' dteEnd : ' + dteEnd);
        
        lstAO = [
            SELECT ASI_CRM_ActualOfftakeHeader__r.id, ASI_CRM_ActualOfftakeHeader__c, ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_ToOutlet__c, ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_ToOutlet__r.ASI_CRM_MY_CustomerCode__c, ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_Calculated_Payment_Status__c
            FROM ASI_TH_CRM_Actual_Offtake__c
            WHERE ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_OfftakeDate__c >= :dteStart 
            AND ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_OfftakeDate__c <= :dteEnd 
            AND ASI_CRM_ActualOfftakeHeader__r.RecordTypeid = :idRT_AOHeader
            AND ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_Calculated_Payment_Status__c = 'Draft'
            ORDER BY ASI_CRM_ActualOfftakeHeader__c, ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_ToOutlet__c, ASI_CRM_ActualOfftakeHeader__r.ASI_CRM_OfftakeDate__c
        ];
        system.debug('@@@lstAO@@@ '+lstAO);
        for(ASI_TH_CRM_Actual_Offtake__c i : lstAO) {
            intOfftakeCount++;
            setOTHeader.add(i.ASI_CRM_ActualOfftakeHeader__r.id);
            if (intOfftakeCount < intBatchLimit) {
                mapIDBatch.put(i.ASI_CRM_ActualOfftakeHeader__r.id, intBatch);
            } else {
                intOfftakeCount = 0;
                intBatch++;
                mapIDBatch.put(i.ASI_CRM_ActualOfftakeHeader__r.id, intBatch);
            }
        }
        
        lstAOHeader = [
            SELECT id, ASI_CRM_ToOutlet__c, ASI_CRM_ToOutlet__r.ASI_CRM_MY_CustomerCode__c, ASI_CRM_Calculated_Payment_Status__c
            FROM ASI_CRM_ActualOfftakeHeader__c
            WHERE id IN :setOTHeader AND ASI_CRM_Calculated_Payment_Status__c = 'Draft'
        ];
        //system.debug('@@@lstAOHeader@@@ '+lstAOHeader);
		
        
        // Clean the previous generated data
        String strPY = String.valueOf(dteEnd.year());
        String strPM = String.valueOf(dteEnd.month());
        strPM = strPM.length() == 1 ? '0' + strPM : strPM;
        list<ASI_CRM_Calculated_Payment__c> FOCPaymentListToDelete = new list<ASI_CRM_Calculated_Payment__c>();
        FOCPaymentListToDelete = 
            [SELECT id FROM ASI_CRM_Calculated_Payment__c 
             WHERE ASI_CRM_Year__c = :strPY 
             AND ASI_CRM_Month__c = :strPM 
             LIMIT 1500];
        if (FOCPaymentListToDelete != null && FOCPaymentListToDelete.size() > 0) {
            delete FOCPaymentListToDelete;
        }
        // Clean the previous generated data
        
        
        haveData = lstAOHeader.size() > 0 ? true : false;
        for(ASI_CRM_ActualOfftakeHeader__c i : lstAOHeader) {
            //if (!blnTodayCutoff) {
            i.ASI_CRM_Calculated_Payment_Status__c = 'Draft-Processing' + String.valueOf(mapIDBatch.get(i.id));
            //}
        }
        update lstAOHeader;
        integer i = 1;
        //for (integer i = 1; i <= intBatch; i++) {
            //system.debug('@@@dteRunDate@@@ '+dteRunDate); 
            Database.executeBatch(new ASI_CRM_MY_CalculatedPayment_Batch(dteRunDate, i, haveData, intBatch, new Set<String>()), 10000);
        //}
    }
}