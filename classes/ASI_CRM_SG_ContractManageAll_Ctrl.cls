/*
 *********************************************************************************
 * Name: ASI_CRM_SG_ContractManageAll_Ctrl
 * Description: Controller class for ASI_CRM_SG_ContractManageAll_Page
 * Related Test Class: ASI_CRM_SG_ContractManageAll_Test
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 10/11/2017       Hugo Cheung             Created
 * 27/11/2017       Wilken Lee              [WL 1.0] Add validation to prevent change Sales Case or delete target in simulation
 * 23/02/2018       Wilken Lee              [WL 2.0] Clone Contract attachment when creating cash sponsorship payment
 * 20/03/2018       Wilken Lee              [WL 3.0] P4.2 Generate remaining Back Rebate achivement upon completion
 * 2018-03-27       Vincent Lam             [VL 4.0] Fix: payment schedule can input decimal as achieved %
 */
global class ASI_CRM_SG_ContractManageAll_Ctrl {

    //Inner class for storing the exception
    private class ExceptionWrapper {
        private Integer lineNumber {
            get;
            set;
        }
        private String errorMessage {
            get;
            set;
        }
        private List < String > fieldAPINameList {
            get;
            set;
        }

        private ExceptionWrapper(Integer lineNumber, String errorMessage) {
            this.lineNumber = lineNumber;
            this.errorMessage = errorMessage;
        }

        private ExceptionWrapper(Integer lineNumber, String errorMessage, List < String > fieldAPINameList) {
            this(lineNumber, errorMessage);
            this.fieldAPINameList = fieldAPINameList;
        }
    }

    //Wrapper Class
    private class SKUPriceWrapper {
        private ASI_MFM_SKU_Code__c sku {
            get;
            set;
        }
        private Map < String, ASI_CRM_MY_SKUPriceCost__c > skuPriceRecordTypeMap {
            get;
            set;
        }

        private SKUPriceWrapper(ASI_MFM_SKU_Code__c sku) {
            this.sku = sku;
            this.skuPriceRecordTypeMap = new Map < String, ASI_CRM_MY_SKUPriceCost__c > ();
        }

        private void addSKUPrice(String recordTypeName, ASI_CRM_MY_SKUPriceCost__c skuPrice) {
            if (!skuPriceRecordTypeMap.containsKey(recordTypeName)) {
                skuPriceRecordTypeMap.put(recordTypeName, skuPrice);
            }
        }

        private Boolean checkIsValidRecord() {
            return skuPriceRecordTypeMap.size() == 7;
        }
    }

    //Field Map
    private final static Map < String, Schema.SObjectField > CONTRACT_FIELD_MAP = Schema.SObjectType.ASI_TH_CRM_Contract__c.fields.getMap();
    private final static Map < String, Schema.SObjectField > CONTRACT_TARGET_FIELD_MAP = Schema.SObjectType.ASI_CRM_ContractTarget__c.fields.getMap();
    private final static Map < String, Schema.SObjectField > CONTRACT_OUTLET_FIELD_MAP = Schema.SObjectType.ASI_CRM_Contract_Outlets__c.fields.getMap();
    private final static Map < String, Schema.SObjectField > PAYMENT_SCHEDULE_FIELD_MAP = Schema.SObjectType.ASI_CRM_Payment_Schedule__c.fields.getMap();

    //Record Type Developer Name
    private final static String CONTRACT_TARGET_SG_RECORD_TYPE = 'ASI_CRM_SG_Contract_Target';
    private final static String CONTRACT_TARGET_SG_SIMULATION_RECORD_TYPE = 'ASI_CRM_SG_Contract_Target_Simulation';
    private final static String PAYMENTSCHEDULE_RECORD_TYPE = 'ASI_CRM_SG_Payment_Schedule';
    private final static String PAYMENTSCHEDULE_SIMULATION_RECORD_TYPE = 'ASI_CRM_SG_Payment_Schedule_Simulation';
    private final static String CONTRACTOUTLET_RECORD_TYPE = 'ASI_CRM_SG_Contract_Outlet';
    private final static String CONTRACTOUTLET_SIMULATION_RECORD_TYPE = 'ASI_CRM_SG_Contract_Outlet_Simulation';
    private final static String SG_SKU_RECORD_TYPE = 'ASI_CRM_SG_SKU';
    private final static String CONTRACT_RECORD_TYPE_READ_ONLY = 'ASI_CRM_SG_Contract_Read_Only';

    //Clone Contract Record Type Mapping
    private final static Map < String, String > contractRecordTypeMapping = new Map < String, String > {
        'ASI_CRM_SG_Contract_Read_Only' => 'ASI_CRM_SG_Contract',
        'ASI_CRM_SG_Proposal_Read_Only' => 'ASI_CRM_SG_Proposal'
    };

    //Archived Contract Record Type Mapping
    private final static Map < String, String > contractArchivedRecordTypeMapping = new Map < String, String > {
        'ASI_CRM_SG_Contract_Read_Only' => 'ASI_CRM_SG_Contract_Archived',
        'ASI_CRM_SG_Proposal_Read_Only' => 'ASI_CRM_SG_Proposal_Archived'
    };

    private final static Set < String > SG_SKU_PRICE_RECORD_TYPE_SET = new Set < String > {
        'ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle',
        'ASI_CRM_SG_Open_Outlet_Price_Per_Bottle',
        'ASI_CRM_SG_IGC',
        'ASI_CRM_SG_CRM_Duty_Per_Bottle',
        'ASI_CRM_SG_CRM_FOB_Per_Bottle',
        'ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle',
        'ASI_CRM_SG_CRM_Incentive_Price_Per_Bottle'
    };
	
	private Map<String, ASI_CRM_Payment_Schedule__c> allPaymentScheduleCashMap = new Map<String, ASI_CRM_Payment_Schedule__c>();

    //Contract Status
    public static final String DRAFT_STATUS = 'Draft';
    public static final String APPROVED_STATUS = 'Contract Approved';

    //Page Parameters Key
    private final static String SKU_NAME = 'skuName';
    private final static String FILTER_OUT_SKU_ID_LIST_JSON = 'filterOutSKUIdListJson';
    private final static String IS_QUICK_SAVE = 'isQuickSave';
    private final static String CONTRACT_TARGET_LIST_JSON = 'contractTargetListJson';
    private final static String UPDATE_CONTRACT_TARGET_LIST_JSON = 'updateContractTargetListJson';
    private final static String DELETE_CONTRACT_TARGET_LIST_JSON = 'deleteContractTargetListJson';
    private final static String UPDATE_PAYMENT_SCHEDULE_LIST_JSON = 'updatePaymentScheduleListJson';
    private final static String DELETE_PAYMENT_SCHEDULE_LIST_JSON = 'deletePaymentScheduleListJson';
    private final static String UPDATE_CONTRACT_OUTLET_LIST_JSON = 'updateContractOutletListJson';
    private final static String DELETE_CONTRACT_OUTLET_LIST_JSON = 'deleteContractOutletListJson';

    //Data Storage
    public ASI_TH_CRM_Contract__c contract {
        get;
        set;
    }
    private List < ASI_CRM_ContractTarget__c > contractTargetList;
    private List < ASI_CRM_Payment_Schedule__c > cashPaymentScheduleList;
    private List < ASI_CRM_Contract_Outlets__c > contractOutletList;
    private List < ASI_CRM_AccountsAdditionalField__c > childOutletList;
    private List < SKUPriceWrapper > skuPriceWrapperList;

    //Page Varaible
    public Boolean isReadOnly {
        get;
        set;
    }
    public Boolean showHeader {
        get;
        set;
    }
    public Boolean isDraftContract {
        get;
        set;
    }
	/*[WL 3.0] BEGIN*/
	public Boolean isCompleteContract {
        get;
        set;
    }
	/*[WL 3.0] END*/
    public Boolean isSimulation {
        get;
        set;
    }
    public Boolean isAlreadySimulated {
        get;
        set;
    }
    public Boolean isSimulatingContract {
        get;
        set;
    }
    public Boolean isApprovedContract {
        get;
        set;
    }
    public Boolean isConfirmRevise {
        get;
        set;
    }
    public Boolean hasError {
        get;
        set;
    }
    public List < ExceptionWrapper > exceptionList {
        get;
        set;
    }
    private string REQUESTEDPAYMENTID = '';
    public String REQUESTEDPAYMENTID_VF          {get {return REQUESTEDPAYMENTID;}}
	
    // for generate payment
    public String paymentScheduleId {get; set;}
    public ASI_TH_CRM_PaymentRequest__c paymentRequestInstance {get; set;}
    Map<Id, Decimal> mapSubBrandId_CotractTargetCash = new Map<Id, Decimal>();
    private final static String REQUEST_LINE_TYPE = 'Cash - Target Achieved';
    private final static String REQUEST_LINE_TYPE_UPFRONT = 'Cash - Upfront';

    public Decimal getInflationRate() {
        return contract.ASI_CRM_Inflation_Rate__c == null ? 0 : contract.ASI_CRM_Inflation_Rate__c;
    }
    public Decimal getDistributionRate() {
        return contract.ASI_CRM_Distribution_Rate__c == null ? 0 : contract.ASI_CRM_Distribution_Rate__c;
    }

    public Decimal oldROI {
        get;
        set;
    }
    public Decimal newROI {
        get;
        set;
    }

    public String contractTargetRecordTypeId {
        get {
            return Global_RecordTypeCache.getRTId('ASI_CRM_ContractTarget__cASI_CRM_SG_Contract_Target');
        }
    }
    public String contractTargetSimulationRecordTypeId {
        get {
            return Global_RecordTypeCache.getRTId('ASI_CRM_ContractTarget__cASI_CRM_SG_Contract_Target_Simulation');
        }
    }
    public String paymentSponsorshipRecordTypeId {
        get {
            return Global_RecordTypeCache.getRTId('ASI_CRM_Payment_Schedule__cASI_CRM_SG_Payment_Schedule');
        }
    }
    public String paymentSponsorshipSimulationRecordTypeId {
        get {
            return Global_RecordTypeCache.getRTId('ASI_CRM_Payment_Schedule__cASI_CRM_SG_Payment_Schedule_Simulation');
        }
    }
    public String contractOutletRecordTypeId {
        get {
            return Global_RecordTypeCache.getRTId('ASI_CRM_Contract_Outlets__cASI_CRM_SG_Contract_Outlet');
        }
    }
    public String contractOutletSimulationRecordTypeId {
        get {
            return Global_RecordTypeCache.getRTId('ASI_CRM_Contract_Outlets__cASI_CRM_SG_Contract_Outlet_Simulation');
        }
    }

    //JSON String for VF Page
    public String contractTargetListJson {
        get {
            return toJsonString(contractTargetList);
        }
    }
    public String cashPaymentScheduleListJson {
        get {
            return toJsonString(cashPaymentScheduleList);
        }
    }
    public String contractContractOutletListJson {
        get {
            return toJsonString(contractOutletList);
        }
    }
    public String childOutletListJson {
        get {
            return toJsonString(childOutletList);
        }
    }
    public String skuPriceWrapperListJson {
        get {
            return toJsonString(skuPriceWrapperList);
        }
    }
    public String exceptionListJson {
        get {
            return toJsonString(exceptionList);
        }
    }
    public String backRebatesPaymentResult {
        get;
        set;
    }

    public ASI_CRM_SG_ContractManageAll_Ctrl(ApexPages.StandardController standardController) {
        String contractId = String.valueOf(standardController.getRecord().get('Id'));
        Map < String, String > pageParameters = ApexPages.currentPage().getParameters();
        isReadOnly = Boolean.valueOf(pageParameters.containsKey('isReadOnly') ? pageParameters.get('isReadOnly') : 'true');
        showHeader = Boolean.valueOf(pageParameters.containsKey('showHeader') ? pageParameters.get('showHeader') : 'false');
        isSimulation = Boolean.valueOf(pageParameters.containsKey('isSimulation') ? pageParameters.get('isSimulation') : 'false');
		isAlreadySimulated = false;
		isSimulatingContract = false;
		isApprovedContract = false;
        init(contractId);

        isDraftContract = contract.ASI_TH_CRM_Contract_Status__c == 'Draft';
		/*[WL 3.0] BEGIN*/
		isCompleteContract = contract.ASI_TH_CRM_Contract_Status__c == 'Completed';
		/*[WL 3.0] END*/
    }

    /***************
    Data Init Function
    ***************/
    private void init(String contractId) {
        contract = retrieveContract(contractId);
        if (isSimulation) {
            contractTargetList = retrieveContractTargetList(contractId, 'AND RecordType.DeveloperName = \'' + CONTRACT_TARGET_SG_SIMULATION_RECORD_TYPE + '\' ');
            cashPaymentScheduleList = retrievePaymentScheduleList(contractId, 'AND ASI_CRM_Type__c = \'Cash Sponsorship\' AND RecordType.DeveloperName = \'' + PAYMENTSCHEDULE_SIMULATION_RECORD_TYPE + '\' ');
            contractOutletList = retrieveContractOutletList(contractId, 'AND RecordType.DeveloperName = \'' + CONTRACTOUTLET_SIMULATION_RECORD_TYPE + '\' ');
        }

        if (!isSimulation || contractTargetList.size() == 0){
			system.debug('isSimulation: ' + isSimulation);
            contractTargetList = retrieveContractTargetList(contractId, 'AND RecordType.DeveloperName = \'' + CONTRACT_TARGET_SG_RECORD_TYPE + '\' ');
		}

        if (!isSimulation || cashPaymentScheduleList.size() == 0)
            cashPaymentScheduleList = retrievePaymentScheduleList(contractId, 'AND ASI_CRM_Type__c = \'Cash Sponsorship\' AND RecordType.DeveloperName = \'' + PAYMENTSCHEDULE_RECORD_TYPE + '\' ');

        if (!isSimulation || contractOutletList.size() == 0)
            contractOutletList = retrieveContractOutletList(contractId, 'AND RecordType.DeveloperName = \'' + CONTRACTOUTLET_RECORD_TYPE + '\' ');

        Set < Id > existingOutletIdSet = new Set < Id > ();
        for (ASI_CRM_Contract_Outlets__c contractOutlet: contractOutletList) {
            existingOutletIdSet.add(contractOutlet.ASI_CRM_SG_Customer__c);
        }

        childOutletList = new List < ASI_CRM_AccountsAdditionalField__c > ();
        for (ASI_CRM_AccountsAdditionalField__c outlet: retrieveChildOutlet(contract.ASI_CRM_CN_Outlet_WS__c)) {
            if (existingOutletIdSet.contains(outlet.Id) == false) childOutletList.add(outlet);
        }
		
		if(contractTargetList.size() > 0 &&
           contractTargetList.get(0).RecordType.DeveloperName == CONTRACT_TARGET_SG_SIMULATION_RECORD_TYPE) {
           isAlreadySimulated = true;
        }
		
		if(isSimulation &&
			contract.recordtype.developername == CONTRACT_RECORD_TYPE_READ_ONLY
		){
			isSimulatingContract = true;
		}
		
		if(contract.recordtype.developername == CONTRACT_RECORD_TYPE_READ_ONLY){
			isApprovedContract = true;
		}
		
		/*[WL 1.0] BEGIN*/
		if(contractTargetList.size() > 0 &&
           contractTargetList.get(0).RecordType.DeveloperName == CONTRACT_TARGET_SG_RECORD_TYPE
			&& !isAlreadySimulated
			&& isSimulatingContract) {
		   	
			for (ASI_CRM_ContractTarget__c target:contractTargetList){
				target.ASI_CRM_Block_Delete__c = true;
				target.ASI_CRM_Entitle_Back_Rebates_Original__c = target.ASI_CRM_Entitle_Back_Rebates__c;
			}
        }	
		/*[WL 1.0] END*/
		
		for (ASI_CRM_Payment_Schedule__c p : cashPaymentScheduleList){
			allPaymentScheduleCashMap.put(p.id, p);
		}
		
    }

    /***************
    Page Function
    ***************/

	/*[WL 3.0] BEGIN*/
	public void generateBackRebatesPaymentRemain() {
	
        backRebatesPaymentResult = '';

        List < ASI_CRM_ContractTarget__c > ctList = retrieveContractTargetList(contract.Id, 'AND RecordType.DeveloperName = \'' + CONTRACT_TARGET_SG_RECORD_TYPE + '\' ');
        String formattedDate = datetime.now().format('YYYYMMdd', UserInfo.getTimeZone().getID());

        String paymentRequestRT = Global_RecordTypeCache.getRtId('ASI_TH_CRM_PaymentRequest__cASI_CRM_SG_Payment_Request');
        String paymentRequestLineItemRT = Global_RecordTypeCache.getRtId('ASI_TH_CRM_PaymentRequestLineItem__cASI_CRM_SG_Payment_Request_Detail');

        ASI_TH_CRM_PaymentRequest__c paymentRequestInstance = new ASI_TH_CRM_PaymentRequest__c(
            RecordTypeId = paymentRequestRT,
            OwnerId = UserInfo.getUserId(),
            ASI_TH_CRM_Contract__c = contract.id,
            ASI_CRM_CN_OutletWS__c = contract.ASI_CRM_CN_Outlet_WS__c,
            ASI_TH_CRM_Status__c = 'Draft',
            ASI_CRM_SG_Invoice_No__c = contract.name + '-' + formattedDate,
            ASI_CRM_SG_Invoice_Date__c = date.today() - 1,
            ASI_CRM_System_Generated__c = true
        );

        List < ASI_CRM_ContractTarget__c > list_contractTargetToUpdate = new List < ASI_CRM_ContractTarget__c > ();

        List < ASI_TH_CRM_PaymentRequestLineItem__c > lineItems = new List < ASI_TH_CRM_PaymentRequestLineItem__c > ();
        for (ASI_CRM_ContractTarget__c ct: ctList) {
            if (ct.ASI_CRM_Entitle_Back_Rebates__c) {
				//Issue actual remaining achivement upon Contract Completion
                Decimal backRebatesAmount = ct.ASI_CRM_Bottle_Incentive_Total__c * (ct.ASI_CRM_Till_Date_Sales_Percent_Bottle__c - ct.ASI_CRM_Back_Rebates_Issued_Percent__c) / 100;
				
                if (backRebatesAmount > 0) {
                    ASI_TH_CRM_PaymentRequestLineItem__c lineItem = new ASI_TH_CRM_PaymentRequestLineItem__c(
                        RecordTypeId = paymentRequestLineItemRT,
                        ASI_CRM_SKU__c = ct.ASI_CRM_SKU__c,
                        ASI_CRM_SG_Sub_brand__c = ct.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
                        ASI_CRM_SG_Type__c = 'Back Rebates',
                        ASI_CRM_Contribution_To__c = backRebatesAmount * 100 / ct.ASI_CRM_Bottle_Incentive_Total__c + ct.ASI_CRM_Back_Rebates_Issued_Percent__c,
                        ASI_CRM_Contribution_From__c = ct.ASI_CRM_Back_Rebates_Issued_Percent__c,
                        ASI_TH_CRM_Amount__c = backRebatesAmount
                    );

                    lineItems.add(lineItem);

                    ct.ASI_CRM_Back_Rebates_Issued_Total__c = ct.ASI_CRM_Back_Rebates_Issued_Total__c == null ? backRebatesAmount : ct.ASI_CRM_Back_Rebates_Issued_Total__c + backRebatesAmount;
                    list_contractTargetToUpdate.add(ct);
                }
            }
        }

        if (lineItems.size() > 0) {
            insert paymentRequestInstance;
            for (ASI_TH_CRM_PaymentRequestLineItem__c l: lineItems) {
                l.ASI_TH_CRM_Payment_Request__c = paymentRequestInstance.id;
            }
            insert lineItems;
            update list_contractTargetToUpdate;
            backRebatesPaymentResult = paymentRequestInstance.Id;
        }
	
    }
	/*[WL 3.0] END*/
	
    public void generateBackRebatesPayment() {
        backRebatesPaymentResult = '';

        List < ASI_CRM_ContractTarget__c > ctList = retrieveContractTargetList(contract.Id, 'AND RecordType.DeveloperName = \'' + CONTRACT_TARGET_SG_RECORD_TYPE + '\' ');
        String formattedDate = datetime.now().format('YYYYMMdd', UserInfo.getTimeZone().getID());

        String paymentRequestRT = Global_RecordTypeCache.getRtId('ASI_TH_CRM_PaymentRequest__cASI_CRM_SG_Payment_Request');
        String paymentRequestLineItemRT = Global_RecordTypeCache.getRtId('ASI_TH_CRM_PaymentRequestLineItem__cASI_CRM_SG_Payment_Request_Detail');

        ASI_TH_CRM_PaymentRequest__c paymentRequestInstance = new ASI_TH_CRM_PaymentRequest__c(
            RecordTypeId = paymentRequestRT,
            OwnerId = UserInfo.getUserId(),
            ASI_TH_CRM_Contract__c = contract.id,
            ASI_CRM_CN_OutletWS__c = contract.ASI_CRM_CN_Outlet_WS__c,
            ASI_TH_CRM_Status__c = 'Draft',
            ASI_CRM_SG_Invoice_No__c = contract.name + '-' + formattedDate,
            ASI_CRM_SG_Invoice_Date__c = date.today() - 1,
            ASI_CRM_System_Generated__c = true
        );

        List < ASI_CRM_ContractTarget__c > list_contractTargetToUpdate = new List < ASI_CRM_ContractTarget__c > ();

        List < ASI_TH_CRM_PaymentRequestLineItem__c > lineItems = new List < ASI_TH_CRM_PaymentRequestLineItem__c > ();
        for (ASI_CRM_ContractTarget__c ct: ctList) {
            if (ct.ASI_CRM_Entitle_Back_Rebates__c) {
                Decimal backRebatesAmount = calculateBackRebatesAmount(ct.ASI_CRM_Bottle_Incentive_Total__c, ct.ASI_CRM_Till_Date_Sales_Percent_Bottle__c, ct.ASI_CRM_Back_Rebates_Issued_Percent__c);
                if (backRebatesAmount > 0) {
                    ASI_TH_CRM_PaymentRequestLineItem__c lineItem = new ASI_TH_CRM_PaymentRequestLineItem__c(
                        RecordTypeId = paymentRequestLineItemRT,
                        ASI_CRM_SKU__c = ct.ASI_CRM_SKU__c,
                        ASI_CRM_SG_Sub_brand__c = ct.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c,
                        ASI_CRM_SG_Type__c = 'Back Rebates',
                        ASI_CRM_Contribution_To__c = backRebatesAmount * 100 / ct.ASI_CRM_Bottle_Incentive_Total__c + ct.ASI_CRM_Back_Rebates_Issued_Percent__c,
                        ASI_CRM_Contribution_From__c = ct.ASI_CRM_Back_Rebates_Issued_Percent__c,
                        ASI_TH_CRM_Amount__c = backRebatesAmount
                    );

                    lineItems.add(lineItem);

                    ct.ASI_CRM_Back_Rebates_Issued_Total__c = ct.ASI_CRM_Back_Rebates_Issued_Total__c == null ? backRebatesAmount : ct.ASI_CRM_Back_Rebates_Issued_Total__c + backRebatesAmount;
                    list_contractTargetToUpdate.add(ct);
                }
            }
        }

        if (lineItems.size() > 0) {
            insert paymentRequestInstance;
            for (ASI_TH_CRM_PaymentRequestLineItem__c l: lineItems) {
                l.ASI_TH_CRM_Payment_Request__c = paymentRequestInstance.id;
            }
            insert lineItems;
            update list_contractTargetToUpdate;
            backRebatesPaymentResult = paymentRequestInstance.Id;
        }
    }

    public Decimal calculateBackRebatesAmount(Decimal amount, Decimal achieved, Decimal issued) {
        // if <100, find the smallest and closest in these values: 0, 25, 50, 75
        Decimal realAchieved = achieved < 100 ? achieved.divide(25, 0, System.RoundingMode.DOWN) * 25 : achieved;
        return amount * (realAchieved - issued) / 100;
    }

    public void searchSKU() {
        Map < String, String > params = ApexPages.currentPage().getParameters();
        String skuName = params.get(SKU_NAME);
        Set < String > filterOutSKUIdList = (Set < String > ) fromJsonString(params.get(FILTER_OUT_SKU_ID_LIST_JSON), Set < String > .class);

        Map < Id, ASI_MFM_SKU_Code__c > skuMap = new Map < Id, ASI_MFM_SKU_Code__c > (retrieveSKU(skuName));

        Map < Id, SKUPriceWrapper > skuPriceWrapperMap = new Map < Id, SKUPriceWrapper > ();

        for (Id skuId: skuMap.keySet()) {
            if (!filterOutSKUIdList.contains(String.valueOf(skuId))) {
                skuPriceWrapperMap.put(skuId, new SKUPriceWrapper(skuMap.get(skuId)));
            }
        }

        for (ASI_CRM_MY_SKUPriceCost__c skuPrice: retrieveSKUPrice(skuMap.keySet(), contract.ASI_TH_CRM_Start_Date__c)) {
            if (skuPriceWrapperMap.containsKey(skuPrice.ASI_CRM_SKU__c)) {
                SKUPriceWrapper tempSKUPriceWrapper = skuPriceWrapperMap.get(skuPrice.ASI_CRM_SKU__c);
                tempSKUPriceWrapper.addSKUPrice(skuPrice.RecordType.DeveloperName, skuPrice);
                skuPriceWrapperMap.put(skuPrice.ASI_CRM_SKU__c, tempSKUPriceWrapper);
            }
        }

        skuPriceWrapperList = new List < SKUPriceWrapper > ();
        for (SKUPriceWrapper skuPriceWrapper: skuPriceWrapperMap.values()) {
            if (skuPriceWrapper.checkIsValidRecord()) {
                skuPriceWrapperList.add(skuPriceWrapper);
            }
        }
    }

    public void calculateROI() {
        Map < String, String > params = ApexPages.currentPage().getParameters();
        String contractTargetListJson = params.get(CONTRACT_TARGET_LIST_JSON);

        List < ASI_CRM_ContractTarget__c > contractList;

        try {
            contractTargetList = (List < ASI_CRM_ContractTarget__c > ) fromJsonString(contractTargetListJson, List < ASI_CRM_ContractTarget__c > .class);
            if (contractTargetList != null && contractTargetList.size() > 0) {
                oldROI = contract.ASI_CRM_ROI__c.setScale(2);
                newROI = calculateROI(contractTargetList).setScale(2);
            }
        } catch (Exception e) {
            System.debug('Page (ASI_CRM_SG_ContractTargetSim_Controller) Error ' + e.getMessage());
        }
    }

    public PageReference saveRecord() {
        //Init current page error 
        hasError = false;
        exceptionList = new List < ExceptionWrapper > ();

        //Collect Json String from VisualForce Page
        Map < String, String > params = ApexPages.currentPage().getParameters();
        Boolean isQuickSave = String.isBlank(params.get('IS_QUICK_SAVE')) ? false : Boolean.valueOf(params.get('IS_QUICK_SAVE'));
        isConfirmRevise = String.isBlank(params.get('IS_CONFIRM_REVISE')) ? false : Boolean.valueOf(params.get('IS_CONFIRM_REVISE'));
        String upsertContractTargetDataJson = params.get(UPDATE_CONTRACT_TARGET_LIST_JSON); system.debug(upsertContractTargetDataJson);
        String removeContractTargetDataJson = params.get(DELETE_CONTRACT_TARGET_LIST_JSON);
        String upsertPaymentScheduleDataJson = params.get(UPDATE_PAYMENT_SCHEDULE_LIST_JSON);
        String removePaymentScheduleDataJson = params.get(DELETE_PAYMENT_SCHEDULE_LIST_JSON);
        String upsertContractOutletDataJson = params.get(UPDATE_CONTRACT_OUTLET_LIST_JSON);
        String removeContractOutletDataJson = params.get(DELETE_CONTRACT_OUTLET_LIST_JSON);

        List < ASI_CRM_ContractTarget__c > upsertContractTargetList;
        List < String > removeContractTargetIdList;

        List < ASI_CRM_Payment_Schedule__c > upsertPaymentScheduleList;
        List < String > removePaymentScheduleIdList;

        List < ASI_CRM_Contract_Outlets__c > upsertContractOutletList;
        List < String > removeContractOutletIdList;

        //Convert Json String -> List<SObject>
        try {
            upsertContractTargetList = (List < ASI_CRM_ContractTarget__c > ) fromJsonString(upsertContractTargetDataJson, List < ASI_CRM_ContractTarget__c > .class);
            removeContractTargetIdList = (List < String > ) fromJsonString(removeContractTargetDataJson, List < String > .class);

            upsertPaymentScheduleList = (List < ASI_CRM_Payment_Schedule__c > ) fromJsonString(upsertPaymentScheduleDataJson, List < ASI_CRM_Payment_Schedule__c > .class);
            removePaymentScheduleIdList = (List < String > ) fromJsonString(removePaymentScheduleDataJson, List < String > .class);

            upsertContractOutletList = (List < ASI_CRM_Contract_Outlets__c > ) fromJsonString(upsertContractOutletDataJson, List < ASI_CRM_Contract_Outlets__c > .class);
            removeContractOutletIdList = (List < String > ) fromJsonString(removeContractOutletDataJson, List < String > .class);
        } catch (Exception e) {
            hasError = true;
            ExceptionWrapper exceptionWrapper = new ExceptionWrapper(0, 'Convert Json String Error, Please contact support.' + e.getMessage());
            exceptionList.add(exceptionWrapper);
            return null;
        }

        //Upsert data / Delete data
        System.Savepoint databaseSavepoint = Database.setSavepoint();
        try {
            List < sObject > removeContractTragetList = convertIdToSObject(removeContractTargetIdList, 'ASI_CRM_ContractTarget__c');
            List < sObject > removePaymentScheduleList = convertIdToSObject(removePaymentScheduleIdList, 'ASI_CRM_Payment_Schedule__c');
            List < sObject > removeContractOutletList = convertIdToSObject(removeContractOutletIdList, 'ASI_CRM_Contract_Outlets__c');

            if (removeContractTragetList != null) Database.delete(removeContractTragetList);
            if (removePaymentScheduleList != null) Database.delete(removePaymentScheduleList);
            if (removeContractOutletList != null) Database.delete(removeContractOutletList);

            if (upsertContractTargetList != null && upsertContractTargetList.size() > 0) {
                //Clear relation field to prevent error occur
                for (ASI_CRM_ContractTarget__c contractTarget: upsertContractTargetList) {
                    contractTarget.ASI_CRM_SKU__r = null;
                	if(isSimulation && !isAlreadySimulated) {
						contractTarget.RecordTypeId = contractTargetSimulationRecordTypeId;
						contractTarget.id = null;
					}
                }
                Database.upsert(upsertContractTargetList);
            }

            if (upsertPaymentScheduleList != null && upsertPaymentScheduleList.size() > 0) {
                for(ASI_CRM_Payment_Schedule__c paymentSchedule : upsertPaymentScheduleList) {
                    if(isSimulation && !isAlreadySimulated) {
						paymentSchedule.RecordTypeId = paymentSponsorshipSimulationRecordTypeId;
						paymentSchedule.id = null;
					}
                }
                Database.upsert(upsertPaymentScheduleList);
            }

            if (upsertContractOutletList != null && upsertContractOutletList.size() > 0) {
                //Clear relation field to prevent error occur
                for (ASI_CRM_Contract_Outlets__c contractOutlet: upsertContractOutletList) {
                    contractOutlet.ASI_CRM_SG_Customer__r = null;
                   	if(isSimulation && !isAlreadySimulated) {
						contractOutlet.RecordTypeId = contractOutletSimulationRecordTypeId;
						contractOutlet.id = null;
					}
                }
                Database.upsert(upsertContractOutletList);
            }
			
			isAlreadySimulated = true;

        } catch (Exception e) {
            hasError = true;
            Database.rollback(databaseSavepoint);

            if (e.getTypeName() == 'System.DmlException') {
                DmlException dmlException = (DmlException) e;
                for (Integer i = 0; i < dmlException.getNumDml(); i++) {
                    ExceptionWrapper exceptionWrapper = new ExceptionWrapper(dmlException.getDmlIndex(i), dmlException.getDmlMessage(i), dmlException.getDmlFieldNames(i));
                    exceptionList.add(exceptionWrapper);
                }
            } else {
                ExceptionWrapper exceptionWrapper = new ExceptionWrapper(e.getLineNumber(), e.getMessage());
                exceptionList.add(exceptionWrapper);
            }

            return null;
        }

        //Refresh page / Back to contract page
        PageReference pageRef;
        if (isQuickSave) {
            init(contract.Id);
        } else {
            pageRef = new PageReference('/' + contract.Id);
            pageRef.setRedirect(true);
        }

        return pageRef;
    }

    public PageReference deleteSimulation() {
        if (contractTargetList.size() > 0 && contractTargetList.get(0).RecordTypeId == contractTargetSimulationRecordTypeId) delete contractTargetList;
        if (cashPaymentScheduleList.size() > 0 && cashPaymentScheduleList.get(0).RecordTypeId == paymentSponsorshipSimulationRecordTypeId) delete cashPaymentScheduleList;
        if (contractOutletList.size() > 0 && contractOutletList.get(0).RecordTypeId == contractOutletSimulationRecordTypeId) delete contractOutletList;

        PageReference pageRef = new PageReference('/' + contract.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference reviseContract() {
        Id originalContractId;
        String originalContractName;
        Decimal originalContractROI;

        //Clone a new contract for backup  
        ASI_TH_CRM_Contract__c tempContract = contract.clone(false, true, false, false);
        tempContract.ASI_CRM_Contract_Period_Req_To_Extend__c = false;

        Database.insert(tempContract);

        //Update current contract
        contract.ASI_TH_CRM_Contract_Status__c = DRAFT_STATUS;

        originalContractId = contract.ASI_CRM_Original_Version__c == null ? tempContract.Id : contract.ASI_CRM_Original_Version__c;
        originalContractName = contract.ASI_CRM_Original_Version__c == null ? tempContract.Name : contract.ASI_CRM_Original_Version__r.Name;
        originalContractROI = contract.ASI_CRM_Original_Version__c == null ? tempContract.ASI_CRM_ROI__c : contract.ASI_CRM_Original_Version__r.ASI_CRM_ROI__c;

        Integer version = retrievePreviousContractSize(contract.Id, originalContractName, contractArchivedRecordTypeMapping.get(contract.RecordType.DeveloperName));
        contract.ASI_CRM_Original_Version__c = contract.ASI_CRM_Original_Version__c == null ? tempContract.Id : contract.ASI_CRM_Original_Version__c;
        contract.Name = originalContractName + ' Rev. ' + version;
        contract.ASI_CRM_Version__c = String.valueOf(version);
        contract.ASI_CRM_ROI__c = originalContractROI;
        contract.RecordTypeId = contractRecordTypeMapping.containsKey(contract.RecordType.DeveloperName) ?
            Global_RecordTypeCache.getRTId('ASI_TH_CRM_Contract__c' + contractRecordTypeMapping.get(contract.RecordType.DeveloperName)) :
            contract.RecordTypeId;
        contract.ASI_CRM_Revising__c = true;
        contract.ASI_CRM_Alerted_30_Days_Before_End__c = false;
        contract.ASI_CRM_Alerted_60_Days_Before_End__c = false;

        Database.update(contract);

        contract.ASI_CRM_Revising__c = false;
        Database.update(contract);

        //Clone Child
        List < ASI_CRM_Contract_Outlets__c > originalContractOutletList = retrieveContractOutletList(contract.Id, 'AND RecordType.DeveloperName = \'' + CONTRACTOUTLET_RECORD_TYPE + '\' ');
        List < ASI_CRM_Contract_Outlets__c > clonedContractOutletList = new List < ASI_CRM_Contract_Outlets__c > ();
        for (ASI_CRM_Contract_Outlets__c contractOutlet: originalContractOutletList) {
            ASI_CRM_Contract_Outlets__c tempContractOutlet = contractOutlet.clone(false, true, false, false);
            tempContractOutlet.ASI_CRM_SG_Contract__c = tempContract.Id;
            clonedContractOutletList.add(tempContractOutlet);
        }

        List < ASI_CRM_Payment_Schedule__c > originalPaymentScheduleList = retrievePaymentScheduleList(contract.Id, 'AND ASI_CRM_Type__c = \'Cash Sponsorship\' AND RecordType.DeveloperName = \'' + PAYMENTSCHEDULE_RECORD_TYPE + '\' ');
        List < ASI_CRM_Payment_Schedule__c > clonedPaymentScheduleList = new List < ASI_CRM_Payment_Schedule__c > ();
        for (ASI_CRM_Payment_Schedule__c paymentSchedule: originalPaymentScheduleList) {
            ASI_CRM_Payment_Schedule__c tempPaymentSchedule = paymentSchedule.clone(false, true, false, false);
            tempPaymentSchedule.ASI_CRM_Contract__c = tempContract.Id;
            clonedPaymentScheduleList.add(tempPaymentSchedule);
        }

        List < ASI_CRM_ContractTarget__c > originalContractTargetList = retrieveContractTargetList(contract.Id, 'AND RecordType.DeveloperName = \'' + CONTRACT_TARGET_SG_RECORD_TYPE + '\' ');
        List < ASI_CRM_ContractTarget__c > clonedContractTargetList = new List < ASI_CRM_ContractTarget__c > ();
        for (ASI_CRM_ContractTarget__c contractTarget: originalContractTargetList) {
            ASI_CRM_ContractTarget__c tempContractTarget = contractTarget.clone(false, true, false, false);
            tempContractTarget.ASI_CRM_Contract__c = tempContract.Id;
            clonedContractTargetList.add(tempContractTarget);
        }

        Database.insert(clonedContractOutletList);
        Database.insert(clonedPaymentScheduleList);
        Database.insert(clonedContractTargetList);

        if (contractTargetList.size() > 0 && contractTargetList.get(0).RecordTypeId == contractTargetSimulationRecordTypeId) {
            Database.delete(originalContractTargetList);
            for (ASI_CRM_ContractTarget__c contractTarget: contractTargetList) {
                contractTarget.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_ContractTarget__c' + CONTRACT_TARGET_SG_RECORD_TYPE);
            }
            Database.update(contractTargetList);
        }

        if(cashPaymentScheduleList.size() > 0 && cashPaymentScheduleList.get(0).RecordTypeId == paymentSponsorshipSimulationRecordTypeId) {
            if (originalPaymentScheduleList.size() > 0) Database.delete(originalPaymentScheduleList);
            for (ASI_CRM_Payment_Schedule__c paymentSchedule: cashPaymentScheduleList) {
                paymentSchedule.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Payment_Schedule__c' + PAYMENTSCHEDULE_RECORD_TYPE);
            }
            Database.update(cashPaymentScheduleList);
        }

        if(contractOutletList.size() > 0 && contractOutletList.get(0).RecordTypeId == contractOutletSimulationRecordTypeId) {
            if (originalContractOutletList.size() > 0) Database.delete(originalContractOutletList);
            for (ASI_CRM_Contract_Outlets__c contractOutlet: contractOutletList) {
                contractOutlet.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Contract_Outlets__c' + CONTRACTOUTLET_RECORD_TYPE);
            }
            Database.update(contractOutletList);
        }

        List < ASI_TH_CRM_PaymentRequest__c > paymentHeaderList = retrievePaymentHeader(contract.Id);
        List < ASI_FOC_Free_Goods_Request__c > focHeaderList = retrieveFOCHeader(contract.Id);
        List < ASI_TH_CRM_Actual_Offtake__c > actualOfftakeList = retrieveActualOfftake(contract.Id);

        for (ASI_TH_CRM_PaymentRequest__c paymentHeader: paymentHeaderList) {
            if (paymentHeader.ASI_CRM_Contract_No_Original__c == null) {
                paymentHeader.ASI_CRM_Contract_No_Original__c = tempContract.Name;
            }
            paymentHeader.ASI_TH_CRM_Contract__c = tempContract.Id;
        }

        for (ASI_FOC_Free_Goods_Request__c focHeader: focHeaderList) {
            if (focHeader.ASI_CRM_Contract_No_Original__c == null) {
                focHeader.ASI_CRM_Contract_No_Original__c = tempContract.Name;
            }
            focHeader.ASI_CRM_Contract__c = tempContract.Id;
        }

        for (ASI_TH_CRM_Actual_Offtake__c actualOfftake: actualOfftakeList) {
            actualOfftake.ASI_CRM_Contract__c = tempContract.Id;
        }

        if (paymentHeaderList.size() > 0) update paymentHeaderList;
        if (focHeaderList.size() > 0) update focHeaderList;
        if (actualOfftakeList.size() > 0) update actualOfftakeList;

        PageReference pageRef = new PageReference('/' + contract.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference cancel() {
        PageReference pageRef = new PageReference('/' + contract.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
	
    public void requestPayment() {
        //Init current page error 
        hasError = false;
        exceptionList = new List < ExceptionWrapper > ();

        REQUESTEDPAYMENTID = '';
        
        List<ASI_TH_CRM_PaymentRequestLineItem__c> lstPaymentRequestLines =
            new List<ASI_TH_CRM_PaymentRequestLineItem__c>();

        paymentScheduleId = ApexPages.currentPage().getParameters().get('scheduleId');

        ASI_CRM_Payment_Schedule__c currentPaymentSchedule = allPaymentScheduleCashMap.get((Id)paymentScheduleId);
        
        Boolean isZeroAchieved = false;
        Decimal paymentScheduleAmount = currentPaymentSchedule.ASI_CRM_Sponsorship__c != null ? currentPaymentSchedule.ASI_CRM_Sponsorship__c : 0;

		if(String.isNotBlank(currentPaymentSchedule.ASI_CRM_Percentof_achieved_Sales_Target__c) && currentPaymentSchedule.ASI_CRM_Percentof_achieved_Sales_Target__c.equals('0')) {
            isZeroAchieved = true;
        } 
        Map<Id, Decimal> mapSubBrandId_CalculatedAmount = calculateAmountsBySubBrand(paymentScheduleAmount);
		
        System.Savepoint preRecordCreationState = Database.setSavepoint();
        try {
            // Formatting date
            Datetime dateInstance = Datetime.newInstance(
                Date.today().year(),
                Date.today().month(),
                Date.today().day());

            String formattedDate = dateInstance.format('YYYYMMdd', UserInfo.getTimeZone().getID());

            // Payment Request Record Creation
            paymentRequestInstance = new ASI_TH_CRM_PaymentRequest__c(
                RecordTypeId = Global_RecordTypeCache.getRTId('ASI_TH_CRM_PaymentRequest__cASI_CRM_SG_Payment_Request'),
                OwnerId = UserInfo.getUserId(),
                ASI_TH_CRM_Contract__c = contract.id,
                ASI_CRM_CN_OutletWS__c = contract.ASI_CRM_CN_Outlet_WS__c,
                ASI_TH_CRM_Status__c = 'Draft',
                ASI_TH_CRM_GL_Date__c = Date.today(),
                ASI_CRM_SG_Invoice_No__c = contract.name + '-' + formattedDate,
                ASI_CRM_CN_Description__c = currentPaymentSchedule.ASI_CRM_Schedule_Date__c != NULL ? 
                                        (
                                            'Pymt upon '
                                          + currentPaymentSchedule.ASI_CRM_Schedule_Date__c.format()
                                        ) : ( 
                                            currentPaymentSchedule.ASI_CRM_Percentof_achieved_Sales_Target__c == '0' ? 
                                            'Upfront Payment Upon Signing' : 
                                            (
												/* [VL 4.0] BEGIN */
												/*
                                                Integer.valueOf(currentPaymentSchedule.ASI_CRM_Percentof_achieved_Sales_Target__c) == 101 ? 
												*/
                                                Decimal.valueOf(currentPaymentSchedule.ASI_CRM_Percentof_achieved_Sales_Target__c) == 101 ? 
												/* [VL 4.0] END */
												'Pymt upon timely completion' :
												(
													'Pymt upon '
												  + currentPaymentSchedule.ASI_CRM_Percentof_achieved_Sales_Target__c
												  + '% sales achieved'
												)
                                            )
                                        ),
                ASI_CRM_System_Generated__c = true
            );

            Integer counter = 0;
			Decimal lineItemAmountTotal = 0;
            
            Map<ASI_TH_CRM_PaymentRequestLineItem__c, ID> map_line_contractID = new Map<ASI_TH_CRM_PaymentRequestLineItem__c, ID>();

            for(Id subBrandId : mapSubBrandId_CalculatedAmount.keySet()) {
                if(mapSubBrandId_CalculatedAmount.get(subBrandId) > 0.0) {
                    counter++;
                    ASI_TH_CRM_PaymentRequestLineItem__c paymentLine = new ASI_TH_CRM_PaymentRequestLineItem__c(
                            RecordTypeId = Global_RecordTypeCache.getRTId('ASI_TH_CRM_PaymentRequestLineItem__cASI_CRM_SG_Payment_Request_Detail'),
                            ASI_CRM_SG_Sub_brand__c = subBrandId,
                            ASI_CRM_SG_Type__c = isZeroAchieved ? REQUEST_LINE_TYPE_UPFRONT : REQUEST_LINE_TYPE,
                            ASI_TH_CRM_Amount__c = mapSubBrandId_CalculatedAmount.get(subBrandId).setScale(2),
                            ASI_TH_CRM_Payment_Request__c = paymentRequestInstance.id
                        );
					lineItemAmountTotal += mapSubBrandId_CalculatedAmount.get(subBrandId).setScale(2);
                    lstPaymentRequestLines.add(paymentLine);
                    map_line_contractID.put(paymentLine, contract.id);
                }
            }

			system.debug('Payment Schedule Amount: ' + paymentScheduleAmount + ' Payment Request Amount: ' + lineItemAmountTotal);
			if (paymentScheduleAmount <> lineItemAmountTotal && lstPaymentRequestLines.size() > 0){
				lstPaymentRequestLines.get(0).ASI_TH_CRM_Amount__c += paymentScheduleAmount - lineItemAmountTotal;
			}
			
            system.debug('paymentRequestInstance: '+paymentRequestInstance);
            system.debug('lstPaymentRequestLines: '+lstPaymentRequestLines);

            ASI_CRM_SG_Payment_ValidationHelper_V2 validator = 
                new ASI_CRM_SG_Payment_ValidationHelper_V2(true, paymentRequestInstance, lstPaymentRequestLines, map_line_contractID);

            String validateAmount = validator.validateAmountExceed();

            if(String.isNotBlank(validateAmount)) {
				hasError = true;
				ExceptionWrapper exceptionWrapper = new ExceptionWrapper(1, validateAmount);
				exceptionList.add(exceptionWrapper);
                REQUESTEDPAYMENTID = '';

				return ;
            }

            insert paymentRequestInstance;
            ApexPages.currentPage().getParameters().put('pymtReqId', paymentRequestInstance.Id);

            for(ASI_TH_CRM_PaymentRequestLineItem__c lineIterator : lstPaymentRequestLines) {
                lineIterator.ASI_TH_CRM_Payment_Request__c = paymentRequestInstance.Id;
            }

            insert lstPaymentRequestLines;

            ASI_CRM_Payment_Schedule__c scheduleInstance = new ASI_CRM_Payment_Schedule__c(
                Id = paymentScheduleId,
                ASI_CRM_Payment_Issued__c = true
            );

            update scheduleInstance;

			/*[WL 2.0] BEGIN*/
			Attachment[] attList = [select id, name, body from Attachment where ParentId = :contract.id];
			Attachment[] insertAttList = new Attachment[]{}; 

			for(Attachment a: attList){
               Attachment att = new Attachment(name = a.name, body = a.body, parentid = paymentRequestInstance.id);
               insertAttList.add(att);
			}
			
			if(insertAttList.size() > 0){
				insert insertAttList;
			}					
			/*[WL 2.0] BEGIN*/
			
            REQUESTEDPAYMENTID = paymentRequestInstance.Id;

        } catch(Exception e) {
            
            hasError = true;
            if(preRecordCreationState != NULL) {
                Database.rollback(preRecordCreationState);
            }

            if (e.getTypeName() == 'System.DmlException') {
                DmlException dmlException = (DmlException) e;
                for (Integer i = 0; i < dmlException.getNumDml(); i++) {
                    ExceptionWrapper exceptionWrapper = new ExceptionWrapper(dmlException.getDmlIndex(i), dmlException.getDmlMessage(i), dmlException.getDmlFieldNames(i));
                    exceptionList.add(exceptionWrapper);
                }
            } else {
                ExceptionWrapper exceptionWrapper = new ExceptionWrapper(e.getLineNumber(), e.getMessage());
                exceptionList.add(exceptionWrapper);
            }

            return ;
			
        }

    }

    private Map<Id, Decimal> calculateAmountsBySubBrand(Decimal pSponsorship) {
        
        List < ASI_CRM_ContractTarget__c > ctList = retrieveContractTargetList(contract.Id, 'AND RecordType.DeveloperName = \'' + CONTRACT_TARGET_SG_RECORD_TYPE + '\' ');
		
		Map<Id, Decimal> mapSubBrandId_WeightPercent = new Map<Id, Decimal>();
	
		Decimal ctCash = 0.0, weightedPercent = 0.0;
		for(ASI_CRM_ContractTarget__c c : ctList){ 
			ID finalSubBrandID = c.ASI_CRM_Subbrand__c != NULL ? c.ASI_CRM_Subbrand__c : c.ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c;
			ctCash = c.ASI_CRM_SG_Cash__c == NULL ? 0.0 : c.ASI_CRM_SG_Cash__c;
			mapSubBrandId_CotractTargetCash.put(finalSubBrandID, (mapSubBrandId_CotractTargetCash.containsKey(finalSubBrandID) ? (mapSubBrandId_CotractTargetCash.get(finalSubBrandID) + ctCash) : ctCash)); 
			
			weightedPercent = c.ASI_CRM_Weighted_percentof_Cash_Sponsor__c == NULL ? 0.0 : c.ASI_CRM_Weighted_percentof_Cash_Sponsor__c;
			mapSubBrandId_WeightPercent.put(finalSubBrandID, (mapSubBrandId_WeightPercent.containsKey(finalSubBrandID) ? (mapSubBrandId_WeightPercent.get(finalSubBrandID) + weightedPercent) : weightedPercent)); 
			
		}
		
        Map<Id, Decimal> mapSubBrandId_AmountWithDate = new Map<Id, Decimal>();

        for(Id subBrandId : mapSubBrandId_WeightPercent.keySet()) {
            mapSubBrandId_AmountWithDate.put(
                subBrandId,
                pSponsorship * mapSubBrandId_WeightPercent.get(subBrandId) / 100
            );
        }

        return mapSubBrandId_AmountWithDate;
    }

    /***************
      Business Logic Function
      ***************/
    public Decimal calculateROI(List < ASI_CRM_ContractTarget__c > contractTargetList) {
        Decimal totalReturnOnInvestment = 0;
        Decimal totalNetSales = 0;
        for (ASI_CRM_ContractTarget__c contractTarget: contractTargetList) {
            Decimal tradeAPTotalPRS = 0;
            Decimal totalManagementIncentives = 0;
            Decimal targetSalesCaseFOC = 0;
            Decimal distributionCost = 0;
            Decimal totalFreeGoodsCase = 0;
            Decimal costOfSales = 0;
            Decimal compensationForWSPriceDif = 0;
            Decimal wholesalerMarginTotal = 0;
            Decimal freeGoods = 0;
            Decimal totalAllowancesAndDiscounts = 0;
            Decimal grossSales = 0;
            Decimal netSales = 0;
            Decimal grossMargin = 0;
            Decimal returnOnInvestment = 0;

            tradeAPTotalPRS = (contractTarget.ASI_CRM_SG_Events__c == null ? 0 : contractTarget.ASI_CRM_SG_Events__c) +
                (contractTarget.ASI_CRM_SG_Signages_Advertising_Spot__c == null ? 0 : contractTarget.ASI_CRM_SG_Signages_Advertising_Spot__c) +
                (contractTarget.ASI_CRM_SG_Trade_Incentive_Trips__c == null ? 0 : contractTarget.ASI_CRM_SG_Trade_Incentive_Trips__c) +
                (contractTarget.ASI_CRM_SG_Product_Branding_Display__c == null ? 0 : contractTarget.ASI_CRM_SG_Product_Branding_Display__c) +
                (contractTarget.ASI_CRM_SG_Ad_hoc_Promotions__c == null ? 0 : contractTarget.ASI_CRM_SG_Ad_hoc_Promotions__c) +
                (contractTarget.ASI_CRM_SG_Ad_hoc_Others_Total__c == null ? 0 : contractTarget.ASI_CRM_SG_Ad_hoc_Others_Total__c) +
                ((contractTarget.ASI_CRM_SG_Events_Free_Bottles__c == null ? 0 : contractTarget.ASI_CRM_SG_Events_Free_Bottles__c) +
                    (contractTarget.ASI_CRM_SG_Signages_Ad_Spot_Free_Btl__c == null ? 0 : contractTarget.ASI_CRM_SG_Signages_Ad_Spot_Free_Btl__c) +
                    (contractTarget.ASI_CRM_SG_Anniversary_Free_Bottles__c == null ? 0 : contractTarget.ASI_CRM_SG_Anniversary_Free_Bottles__c) +
                    (contractTarget.ASI_CRM_Advertising_Spot_Free_Bottles__c == null ? 0 : contractTarget.ASI_CRM_Advertising_Spot_Free_Bottles__c)) *
                (contractTarget.ASI_CRM_SG_IGC_Cost_Per_case__c == null ? 0 : contractTarget.ASI_CRM_SG_IGC_Cost_Per_case__c) +
                (contractTarget.ASI_CRM_Advertising_Spot__c == null ? 0 : contractTarget.ASI_CRM_Advertising_Spot__c);

            Decimal contractPeriod = (contract.ASI_TH_CRM_Start_Date__c.daysBetween(contract.ASI_TH_CRM_End_Date__c)) / 30;
            totalManagementIncentives = (contractTarget.ASI_CRM_SG_Management_Incentives__c == null ? 0 : contractTarget.ASI_CRM_SG_Management_Incentives__c) *
                contractPeriod.round();

            if (contractTarget.ASI_CRM_SG_FOC_Calculation__c == 'By Sub-Brand') {
                targetSalesCaseFOC = (contractTarget.ASI_CRM_SG_Target_Sales_Sub_B_Wine_Cat__c == null ? 0 : contractTarget.ASI_CRM_SG_Target_Sales_Sub_B_Wine_Cat__c);
            } else {
                targetSalesCaseFOC = (contractTarget.ASI_CRM_TargetCase__c == null ? 0 : contractTarget.ASI_CRM_TargetCase__c);
            }

            totalFreeGoodsCase = (contractTarget.ASI_CRM_SG_Sales_Incentive__c == null ? 0 : contractTarget.ASI_CRM_SG_Sales_Incentive__c) *
                targetSalesCaseFOC /
                (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) +
                totalManagementIncentives +
                (contractTarget.ASI_CRM_SG_Others__c == null ? 0 : contractTarget.ASI_CRM_SG_Others__c) +
                (contractTarget.ASI_CRM_SG_Cont_Sponsor_Target_Incentive__c == null ? 0 : contractTarget.ASI_CRM_SG_Cont_Sponsor_Target_Incentive__c);

            grossSales = (totalFreeGoodsCase +
                    (contractTarget.ASI_CRM_TargetCase__c == null ? 0 : contractTarget.ASI_CRM_TargetCase__c)) *
                (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) *
                (contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c == null ? 0 : contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c);

            distributionCost = -(grossSales * (contract.ASI_CRM_Distribution_Rate__c == null ? 0 : contract.ASI_CRM_Distribution_Rate__c) / 100);

            costOfSales = -(((contractTarget.ASI_CRM_FOB_Per_Bottle__c == null ? 0 : contractTarget.ASI_CRM_FOB_Per_Bottle__c) +
                        (contractTarget.ASI_CRM_Handling_Cost_Per_Bottle__c == null ? 0 : contractTarget.ASI_CRM_Handling_Cost_Per_Bottle__c)) *
                    (1 + (contract.ASI_CRM_Inflation_Rate__c == null ? 0 : (contract.ASI_CRM_Inflation_Rate__c / 100))) +
                    (contractTarget.ASI_CRM_Duty_Per_Bottle__c == null ? 0 : contractTarget.ASI_CRM_Duty_Per_Bottle__c)) *
                ((contractTarget.ASI_CRM_TargetCase__c == null ? 0 : contractTarget.ASI_CRM_TargetCase__c) +
                    totalFreeGoodsCase) *
                (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) +
                distributionCost;

            if (contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c == null || contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c == 0 ||
                contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c > contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c) {
                compensationForWSPriceDif = 0;
            } else {
                compensationForWSPriceDif = (contractTarget.ASI_CRM_TargetCase__c == null ? 0 : contractTarget.ASI_CRM_TargetCase__c) *
                    (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) *
                    ((contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c == null ? 0 : contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c) -
                        (contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c == null ? 0 : contractTarget.ASI_CRM_SG_Consumer_Price_Offer__c));
            }

            wholesalerMarginTotal = (contractTarget.ASI_CRM_TargetCase__c == null ? 0 : contractTarget.ASI_CRM_TargetCase__c) *
                (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) *
                (contractTarget.ASI_CRM_SG_Wholesaler_Margin__c == null ? 0 : contractTarget.ASI_CRM_SG_Wholesaler_Margin__c);

            freeGoods = -(contractTarget.ASI_CRM_SG_Total_Free_Goods_Cases__c == null ? 0 : contractTarget.ASI_CRM_SG_Total_Free_Goods_Cases__c) *
                (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) *
                (contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c == null ? 0 : contractTarget.ASI_CRM_SG_Selling_Price_Btl_PRS_WS__c);

            totalAllowancesAndDiscounts = freeGoods -
                wholesalerMarginTotal -
                compensationForWSPriceDif -
                (contractTarget.ASI_CRM_SG_Good_in_Kinds__c == null ? 0 : contractTarget.ASI_CRM_SG_Good_in_Kinds__c) -
                (contractTarget.ASI_CRM_SG_Cash__c == null ? 0 : contractTarget.ASI_CRM_SG_Cash__c) -
                ((contractTarget.ASI_CRM_Bottle_Incentive__c == null ? 0 : contractTarget.ASI_CRM_Bottle_Incentive__c) *
                    (contractTarget.ASI_CRM_SG_Btls_Per_Case__c == null ? 0 : contractTarget.ASI_CRM_SG_Btls_Per_Case__c) *
                    (contractTarget.ASI_CRM_TargetCase__c == null ? 0 : contractTarget.ASI_CRM_TargetCase__c));

            netSales = grossSales + totalAllowancesAndDiscounts;

            grossMargin = netSales + costOfSales;

            returnOnInvestment = grossMargin - tradeAPTotalPRS;

            totalReturnOnInvestment += returnOnInvestment;
            totalNetSales += netSales;
        }

        return (totalNetSales == 0 || totalReturnOnInvestment == 0) ? 0 : (totalReturnOnInvestment / totalNetSales * 100);
    }
	
	@RemoteAction
    global static String validateAmountExceedRTMContract(Id headerId, boolean isSimulation){
		return ASI_CRM_SG_Payment_ValidationHelper_V2.validateAmountExceedRTMContract(headerId, isSimulation);
	}

    /***************
    Data Retrievement Function
    ***************/
    private ASI_TH_CRM_Contract__c retrieveContract(Id contractId) {
        String query = 'SELECT ' + genQueryField(CONTRACT_FIELD_MAP) +
            ', RecordType.DeveloperName, ASI_CRM_Original_Version__r.Name, ASI_CRM_Original_Version__r.ASI_CRM_ROI__c ' +
            'FROM ASI_TH_CRM_Contract__c ' +
            'WHERE Id = :contractId ';

        List < ASI_TH_CRM_Contract__c > contractList = (List < ASI_TH_CRM_Contract__c > ) Database.query(query);
        return contractList.size() > 0 ? contractList.get(0) : null;
    }

    private Integer retrievePreviousContractSize(Id contractId, String contractName, String contractRecordType) {
        String query = 'SELECT count() ' +
            'FROM ASI_TH_CRM_Contract__c ' +
            'WHERE Name like \'' + contractName + '%\' ' +
            'AND ASI_TH_CRM_Contract_Status__c = \'Archived\' ' +
            'AND RecordType.DeveloperName = :contractRecordType ' +
            'AND id <> :contractId';
        return Database.countQuery(query) + 1;
    }

    private List < ASI_CRM_ContractTarget__c > retrieveContractTargetList(Id contractId, String whereClause) {
        String query = 'SELECT ' + genQueryField(CONTRACT_TARGET_FIELD_MAP) +
            ', RecordType.DeveloperName, ASI_CRM_SKU__r.Name, ASI_CRM_SKU__r.ASI_MFM_Sub_brand__c, ASI_CRM_SKU__r.ASI_CRM_Preset__c , ASI_CRM_SKU__r.ASI_CRM_Allow_Back_Rebates__c ' +
            'FROM ASI_CRM_ContractTarget__c ' +
            'WHERE ASI_CRM_Contract__c = :contractId ' +
			whereClause +
            'ORDER BY ASI_CRM_Sequence_No__c ';
			
			List < ASI_CRM_ContractTarget__c > list_ct = Database.query(query);
			
        return list_ct;
    }

    private List < ASI_CRM_Payment_Schedule__c > retrievePaymentScheduleList(Id contractId, String whereClause) {
        String query = 'SELECT ' + genQueryField(PAYMENT_SCHEDULE_FIELD_MAP) +
            ', RecordType.DeveloperName ' +
            'FROM ASI_CRM_Payment_Schedule__c ' +
            'WHERE ASI_CRM_Contract__c = :contractId ';

        if (String.isNotBlank(whereClause)) query += whereClause;
		
		query += 'ORDER BY ASI_CRM_Schedule_Date__c asc NULLS FIRST, ASI_CRM_Percent_Achieved__c asc';
        return (List < ASI_CRM_Payment_Schedule__c > ) Database.query(query);
    }

    private List < ASI_CRM_Contract_Outlets__c > retrieveContractOutletList(Id contractId, String whereClause) {
        String query = 'SELECT ' + genQueryField(CONTRACT_OUTLET_FIELD_MAP) +
            ', RecordType.DeveloperName, ASI_CRM_SG_Customer__r.Name ' +
            'FROM ASI_CRM_Contract_Outlets__c ' +
            'WHERE ASI_CRM_SG_Contract__c = :contractId ' +
			whereClause;

        return (List < ASI_CRM_Contract_Outlets__c > ) Database.query(query);
    }

    private List < ASI_CRM_AccountsAdditionalField__c > retrieveChildOutlet(Id parentId) {
        if(parentId == null){
            return new List <ASI_CRM_AccountsAdditionalField__c>();
        }
            
        String query = 'SELECT Id, Name ' +
            'FROM ASI_CRM_AccountsAdditionalField__c ' +
            'WHERE ASI_CRM_CN_Parent_Outlet__c  = :parentId ';
        return (List < ASI_CRM_AccountsAdditionalField__c > ) Database.query(query);
    }

    private List < ASI_MFM_SKU_Code__c > retrieveSKU(String skuName) {
        String query = 'SELECT Id, Name, ASI_MFM_Sub_brand__c, ASI_HK_CRM_Packaging_Size__c, ASI_HK_CRM_Std_Bottle_Size__c, ASI_CRM_Minimum_Sales_Cases__c, ASI_CRM_Preset__c, ASI_CRM_Allow_Back_Rebates__c ' +
            ', ASI_CRM_SG_Selling_Price_Per_Btl_PRS_WS__c, ASI_CRM_SG_Selling_Price_Per_Btl_WS_On__c, ASI_CRM_SG_IGC_Cost_Per_case__c, ASI_CRM_SG_IGC_Cost_Per_9Lc__c ' +
            ', ASI_MFM_Sub_brand__r.Name ' +
            'FROM ASI_MFM_SKU_Code__c ' +
            'WHERE RecordType.DeveloperName = :SG_SKU_RECORD_TYPE ' +
            'AND ASI_HK_CRM_IsPOSProduct__c = false ';

        if (String.isNotBlank(skuName)) {
            query += 'AND Name like \'%' + skuName.trim() + '%\' ';
        }

        query += 'Order By Name LIMIT 100';

        return (List < ASI_MFM_SKU_Code__c > ) Database.query(query);
    }

    private List < ASI_CRM_MY_SKUPriceCost__c > retrieveSKUPrice(Set < Id > skuIdSet, Date contractStartDate) {
        String query = 'SELECT ASI_CRM_SKU__c, ASI_CRM_SG_IGC_Cost_Per_9Lc__c, ASI_CRM_Price__c, ASI_CRM_Cost__c, ASI_CRM_EffectiveDate__c' +
            ', RecordType.DeveloperName ' +
            'FROM ASI_CRM_MY_SKUPriceCost__c ' +
            'WHERE RecordType.DeveloperName in :SG_SKU_PRICE_RECORD_TYPE_SET ' +
            'AND ASI_CRM_EffectiveDate__c != NULL ' +
            'AND ASI_CRM_SKU__c in :skuIdSet ';
        if (contractStartDate != null) {
            query += 'AND ASI_CRM_EffectiveDate__c <= :contractStartDate ';
        }
        query += 'Order By ASI_CRM_EffectiveDate__c DESC';
        return (List < ASI_CRM_MY_SKUPriceCost__c > ) Database.query(query);
    }

    private List<ASI_TH_CRM_Actual_Offtake__c> retrieveActualOfftake(Id contractId) {
    	String query = 'SELECT Id, ASI_CRM_Contract__c ' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_TH_CRM_Actual_Offtake__c ' +
                       'WHERE ASI_CRM_Contract__c = :contractId ';
        return (List<ASI_TH_CRM_Actual_Offtake__c>) Database.query(query);
    }
    
    private List<ASI_TH_CRM_PaymentRequest__c> retrievePaymentHeader(Id contractId) {
    	String query = 'SELECT Id, ASI_CRM_Contract_No_Original__c' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_TH_CRM_PaymentRequest__c ' +
                       'WHERE ASI_TH_CRM_Contract__c = :contractId ';
        return (List<ASI_TH_CRM_PaymentRequest__c>) Database.query(query);
    }
    
    private List<ASI_FOC_Free_Goods_Request__c> retrieveFOCHeader(Id contractId) {
    	String query = 'SELECT Id, ASI_CRM_Contract_No_Original__c' + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_FOC_Free_Goods_Request__c ' +
                       'WHERE ASI_CRM_Contract__c = :contractId ';
        return (List<ASI_FOC_Free_Goods_Request__c>) Database.query(query);
    }
    
    /***************
    Tools Function
    ***************/
    private List < sObject > convertIdToSObject(List < String > sObjIdList, String sObjType) {
        if (sObjIdList == null || sObjIdList.size() == 0) return null;

        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(sObjType);

        List < sObject > removeDataList = new List < sObject > ();
        for (String sObjId: sObjIdList) {
            removeDataList.add(convertIdToSObject(sObjId, convertType));
        }
        return removeDataList;
    }

    private sObject convertIdToSObject(String sObjId, Schema.SObjectType convertType) {
        sObject sObj = convertType.newSObject();
        sObj.put('Id', sObjId);
        return sObj;
    }

    private String genQueryField(Map < String, Schema.SObjectField > fieldMap) {
        String queryField = '';
        for (String fields: fieldMap.keySet()) {
            queryField += fields + ',';
        }
        return queryField.subString(0, queryField.length() - 1);
    }

    private String toJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private Object fromJsonString(String jsonString, System.Type apexType) {
        if (String.isBlank(jsonString)) {
            return null;
        }
        return System.JSON.deserialize(jsonString, apexType);
    }
}