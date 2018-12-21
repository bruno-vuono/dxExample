public with sharing class ASI_KOR_VisitationPlanEditController {

    public static final String VISIT_DAY_DELIM = ', ';
    public static final String POINT_KEY_TOTAL = 'total';
    public static final String POINT_KEY_WHOLESALER = 'ws';
    public static final String POINT_KEY_VENUE = 'venue';
    private static final Integer DEF_WORTH_POINT = 1;

    // Variables used in VF page
    public List<ASI_KOR_VisitationPlanEditRow> visitTableRows { get; set; }
    public Map<String, ASI_KOR_VisitationPlanPoint> keyToVisitPointMap { get; set; }
    public Map<Date, Integer> dateToVisitCountMap { get; set; }
    public final Date visitPlanBeginDate { get; private set; }
    public final Date visitPlanEndDate { get; private set; }
    public final ID visitPlanId { get; private set; }
    public String ptKeyTotal { get { return POINT_KEY_TOTAL; } private set; }
    public String ptKeyWholesaler { get { return POINT_KEY_WHOLESALER; } private set; }
    public String ptKeyVenue { get { return POINT_KEY_VENUE; } private set; }
    public String visitDayDelim { get {return VISIT_DAY_DELIM;} private set; }
    public String isLocked { get; set; }
    public Boolean hasError { get; set; }

    private final ApexPages.StandardSetController stdSetController;
    private final ASI_KOR_Visitation_Plan__c visitPlanHeader;
    private final List<ASI_KOR_Visitation_Plan_Detail__c> visitDetailList;
    private final ASI_KOR_VisitationPlanDetailGenerator visitDetailGen;
    private final Map<String, Integer> gradeToRequiredPointMap;
    private Integer theYearInt;

    public ASI_KOR_VisitationPlanEditController(ApexPages.StandardSetController stdSetController) {
        this.hasError = false;
        this.stdSetController = stdSetcontroller;
        // Get the visitation information
        /*if (!Test.isRunningTest()) // addFields() is not supported when testing
            this.stdSetController.addFields(new String[] {'Id', 'Name', 'ASI_KOR_Visitation_Plan__c', 'ASI_KOR_Wholesaler__c', 'ASI_KOR_Visit_Date__c'});
        this.visitDetailList =  (List<ASI_KOR_Visitation_Plan_Detail__c>)stdSetcontroller.getRecords();*/
        String parentId = null;
        //if (this.visitDetailList.size() == 0) {
            parentId = ApexPages.currentPage().getParameters().get('id');
            if (parentId == null) {
                this.hasError = true;
                showPageError(String.format('URL paramether is missing: {0}', new String[] {'id'}));
                return;
            }
            this.visitDetailList = [SELECT Id, Name, ASI_KOR_Visitation_Plan__c, ASI_KOR_Wholesaler__c, ASI_KOR_Visit_Date__c FROM ASI_KOR_Visitation_Plan_Detail__c WHERE ASI_KOR_Visitation_Plan__c = :parentId];
        //} else
        //  parentId = this.visitDetailList.get(0).ASI_KOR_Visitation_Plan__c;
        this.visitPlanHeader = [SELECT Id, Name, ASI_KOR_Year__c, ASI_KOR_Month__c, ASI_KOR_Confirmed__c, OwnerId FROM ASI_KOR_Visitation_Plan__c WHERE Id = :parentId];
        this.visitPlanId = this.visitPlanHeader.Id;
        
        // Initialize data for display
        this.visitTableRows = new List<ASI_KOR_VisitationPlanEditRow>();
        this.keyToVisitPointMap = new Map<String, ASI_KOR_VisitationPlanPoint>();
        this.dateToVisitCountMap = new Map<Date, Integer>();
        
        // Initialize the settings
        Integer vpMonth = getVPMonthFromPicklistValue(visitPlanHeader.ASI_KOR_Month__c);
        if (vpMonth == 0) {
            this.hasError = true;
            showPageError(String.format('Unknown Month of {0}: {1}', new String[] {Schema.SObjectType.ASI_KOR_Visitation_Plan__c.getLabel(), visitPlanHeader.ASI_KOR_Month__c}));
            return;
        }
        try {
            this.theYearInt = Integer.valueOf(visitPlanHeader.ASI_KOR_Year__c);
        } catch (TypeException te) {
            this.hasError = true;
            showPageError(String.format('Unknown Year: {0}', new String[] {Schema.SObjectType.ASI_KOR_Visitation_Plan__c.getLabel(), visitPlanHeader.ASI_KOR_Month__c}));
            return;
        }
        this.visitPlanBeginDate = Date.newInstance(theYearInt, vpMonth, 1);
        this.visitPlanEndDate = Date.newInstance(theYearInt, vpMonth, Date.daysInMonth(theYearInt, vpMonth));
        this.isLocked = this.visitPlanHeader.ASI_KOR_Confirmed__c == true ? 'true' : 'false';
        this.gradeToRequiredPointMap = initGradeToVisitCountMap();
        
        this.visitDetailGen = new ASI_KOR_VisitationPlanDetailGenerator();
    }
    
    public PageReference initPage() {
        if (hasError) return null;
        // Summarize the visitation details by Account
        Map<ID, List<Integer>> acctIdToVisitDaysMap = new Map<ID, List<Integer>>();
        this.dateToVisitCountMap = new Map<Date, Integer>();
        for (ASI_KOR_Visitation_Plan_Detail__c vd : visitDetailList) {
            // List of visitation date of the account
            List<Integer> visitDays = acctIdToVisitDaysMap.get(vd.ASI_KOR_Wholesaler__c);
            if (visitDays == null) {
                visitDays = new List<Integer>();
                acctIdToVisitDaysMap.put(vd.ASI_KOR_Wholesaler__c, visitDays);
            }
            visitDays.add(vd.ASI_KOR_Visit_Date__c.day());
            // Update the numbers of visitation of each date
            Integer visitCount = dateToVisitCountMap.get(vd.ASI_KOR_Visit_Date__c);
            if (visitCount == null) {
                visitCount = 0;
            }
            dateToVisitCountMap.put(vd.ASI_KOR_Visit_Date__c, visitCount + 1);
        }
        // Create table row info for each Account
        ID headerOwnerId = this.visitPlanHeader.OwnerId;
        for (List<Account> targetSObjList : [SELECT Id, Name, RecordTypeId, RecordType.Name, RecordType.DeveloperName, ASI_KOR_Grade__c, ASI_KOR_Customer_Code__c, ASI_KOR_Address__c FROM Account WHERE ASI_KOR_Venue_Status__c ='Active' and OwnerId = :headerOwnerId ORDER BY ASI_KOR_Address__c]) {
            for (Account targetSObj: targetSObjList) {
                Integer requiredPoint = this.gradeToRequiredPointMap.get(targetSObj.ASI_KOR_Grade__c);
                if (requiredPoint == null) {
                    this.hasError = true;
                    showPageError(String.format('Invalid Grade: {1}. Please update Custom Setting {0}', new String[] {'ASI_KOR_AcctGradeVisitCountMapping__c', targetSObj.ASI_KOR_Grade__c}));
                    return null;
                }
                this.visitTableRows.add(new ASI_KOR_VisitationPlanEditRow(targetSObj, DEF_WORTH_POINT, requiredPoint, acctIdToVisitDaysMap.get(targetSObj.Id)));
            }
        }
        // Fill in zero visitation count for missing date
        for (Date tempDate = this.visitPlanBeginDate; tempDate <= this.visitPlanEndDate; tempDate = tempDate.addDays(1)) {
            Integer visitCount = dateToVisitCountMap.get(tempDate);
            if (visitCount == null)
                dateToVisitCountMap.put(tempDate, 0);
        }
        // Calculate the overall points
        initOverallPoints();
        
        return null;
    }
    
    public PageReference quickSaveChanges() {
        Boolean saveSuccess = implSaveChanges();
        PageReference redirectPage = null;
        if (saveSuccess) {
            redirectPage = Page.ASI_KOR_VisitationPlanEditPage;
            redirectPage.setRedirect(true);
            redirectPage.getParameters().put('id', visitPlanHeader.Id);
        }
        return redirectPage;
    }
    public PageReference saveChanges() {
        Boolean saveSuccess = implSaveChanges();
        PageReference redirectPage = null;
        if (saveSuccess) {
            redirectPage = new PageReference('/' + visitPlanId);
        }
        return redirectPage;
    }
    public Boolean implSaveChanges() {
        List<ASI_KOR_Visitation_Plan_Detail__c> visitDetailList = [SELECT Id, ASI_KOR_Visit_Date__c, ASI_KOR_Wholesaler__c FROM ASI_KOR_Visitation_Plan_Detail__c WHERE ASI_KOR_Visitation_Plan__c = :visitPlanHeader.Id ORDER BY ASI_KOR_Visit_Date__c];
        Map<ID, List<ASI_KOR_Visitation_Plan_Detail__c>> acctIdToVisitDetailMap = new Map<ID, List<ASI_KOR_Visitation_Plan_Detail__c>>();
        for (ASI_KOR_Visitation_Plan_Detail__c vDetail : visitDetailList) {
            List<ASI_KOR_Visitation_Plan_Detail__c> tempVisitDetailList = acctIdToVisitDetailMap.get(vDetail.ASI_KOR_Wholesaler__c);
            if (tempVisitDetailList == null) {
                tempVisitDetailList = new List<ASI_KOR_Visitation_Plan_Detail__c>();
                acctIdToVisitDetailMap.put(vDetail.ASI_KOR_Wholesaler__c, tempVisitDetailList);
            }
            tempVisitDetailList.add(vDetail);
        }
        List<ASI_KOR_Visitation_Plan_Detail__c> deleteVisitDetailList = new List<ASI_KOR_Visitation_Plan_Detail__c>();
        List<ASI_KOR_Visitation_Plan_Detail__c> insertVisitDetailList = new List<ASI_KOR_Visitation_Plan_Detail__c>();
        for (ASI_KOR_VisitationPlanEditRow row : visitTableRows) {
            Account acct = row.targetSObj;
            ID acctId = row.targetSObj.Id;
            List<ASI_KOR_Visitation_Plan_Detail__c> vDetailList = acctIdToVisitDetailMap.get(acctId);
            if (vDetailList == null) vDetailList = new List<ASI_KOR_Visitation_Plan_Detail__c>();
            List<String> visitDayStrList = (row.visitDayStr != null && row.visitDayStr.length() > 0) ? row.visitDayStr.split(VISIT_DAY_DELIM, 0) : new List<String>();
            List<Integer> visitDayIntList = new List<Integer>();
            for (String visitDayStr : visitDayStrList) visitDayIntList.add(Integer.valueOf(visitDayStr.trim()));
            visitDayIntList.sort();
            Integer i = 0, j = 0;
            Boolean reachEndOfUserInput = false;
            Boolean reachEndOfOriginal = false;
            while (i < visitDayIntList.size() || j < vDetailList.size()) {
                if (!reachEndOfUserInput && i >=visitDayIntList.size()) reachEndOfUserInput = true;
                if (!reachEndOfOriginal && j >=vDetailList.size()) reachEndOfOriginal = true;
                Integer userInputDay = 0;
                Integer originalDay = 0;
                if (!reachEndOfUserInput) userInputDay = visitDayIntList.get(i);
                if (!reachEndOfOriginal) originalDay = vDetailList.get(j).ASI_KOR_Visit_Date__c.day();
                if (!reachEndOfUserInput && (reachEndOfOriginal || userInputDay < originalDay)) {
                    insertVisitDetailList.add(
                        this.visitDetailGen.generateVisitationPlanDetail(
                            this.visitPlanHeader
                            , acct
                            , Date.newInstance(this.theYearInt, getVPMonthFromPicklistValue(visitPlanHeader.ASI_KOR_Month__c), userInputDay)
                        )
                    );
                    i++;
                } else if (!reachEndOfOriginal && (reachEndOfUserInput || userInputDay > originalDay)) {
                    deleteVisitDetailList.add(vDetailList.get(j));
                    j++;
                } else {
                    i++;
                    j++;
                }
            }
        }
        
        Boolean allSuccess = true;
        System.Savepoint sp = database.setSavepoint();
        if (allSuccess && deleteVisitDetailList.size() > 0) {
            try {
                delete deleteVisitDetailList;
            } catch (DmlException dmle) {
                allSuccess = false;
                database.rollback(sp);
            }
        }
        if (allSuccess && insertVisitDetailList.size() > 0) {
            try {
                insert insertVisitDetailList;
            } catch (DmlException dmle) {
                allSuccess = false;
                database.rollback(sp);
            }
        }
        
        return allSuccess;
    }
    
    private Integer getVPMonthFromPicklistValue(String plValue) {
        Integer result = ASI_KOR_VisitationPlanGenerator.convertMonthPLValueToInteger(plValue);
        if (result == null) return 0;
        return result;
    }
    
    private void initOverallPoints() {
        this.keyToVisitPointMap = new Map<String, ASI_KOR_VisitationPlanPoint>{
            POINT_KEY_WHOLESALER => new ASI_KOR_VisitationPlanPoint(0, 0)
            , POINT_KEY_VENUE => new ASI_KOR_VisitationPlanPoint(0, 0)
        };
        Integer totalRequiredPt = 0;
        Integer totalPlannedPt = 0;
        for (ASI_KOR_VisitationPlanEditRow visitRow : this.visitTableRows) {
            ASI_KOR_VisitationPlanPoint pt = keyToVisitPointMap.get(visitRow.customType);
            if (pt == null) {
                pt = new ASI_KOR_VisitationPlanPoint(0, 0);
                keyToVisitPointMap.put(visitRow.customType, pt);
            }
            pt.requiredPt = pt.requiredPt + visitRow.requiredPt;
            pt.plannedPt = pt.plannedPt + visitRow.plannedPt;
            totalRequiredPt += visitRow.requiredPt;
            totalPlannedPt += visitRow.plannedPt;
        }
        keyToVisitPointMap.put(POINT_KEY_TOTAL, new ASI_KOR_VisitationPlanPoint(totalRequiredPt, totalPlannedPt));
    }
    
    private Map<String, Integer> initGradeToVisitCountMap() {
        Map<String, Integer> result = new Map<String, Integer>();
        Map<String, ASI_KOR_AcctGradeVisitCountMapping__c> settingMap = ASI_KOR_AcctGradeVisitCountMapping__c.getAll();
        Set<String> gradeSet = settingMap.keySet();
        for (String gradeStr : gradeSet) {
            result.put(gradeStr, settingMap.get(gradeStr).ASI_KOR_No_of_Required_Visitation__c.intValue());
        }
        return result;
    }
    
    private void showPageMessage(ApexPages.Severity severity, String msg) {
        ApexPages.addMessage(new ApexPages.Message(severity, msg));
    }
    private void showPageError(String msg) {
        showPageMessage(ApexPages.Severity.ERROR, msg);
    }
    
    public class ASI_KOR_VisitationPlanEditRow {
        public Account targetSObj { get; set; }
        public String customType { get; private set; }
        public Integer worthPt { get; set; }
        public Integer requiredPt { get; set; }
        public Integer plannedPt { get; private set; }
        public String visitDayStr { get; set; }
        
        public ASI_KOR_VisitationPlanEditRow(Account targetSObj, Integer worthPt, Integer requiredPt, List<Integer> visitDayIntList) {
            this.targetSObj = targetSObj;
            this.customType = getCustomTypeByRTDevName(targetSObj.RecordType.DeveloperName);
            this.worthPt = worthPt;
            this.requiredPt = requiredPt;
            this.visitDayStr = intListToSeparatedStr(visitDayIntList, VISIT_DAY_DELIM);
            this.plannedPt = calculatePlannedPoint(visitDayIntList);
        }
        
        private String getCustomTypeByRTDevName(String rtDevName) {
            if (rtDevName == 'ASI_KOR_Venue') return POINT_KEY_VENUE;
            else if (rtDevName == 'ASI_KOR_Wholesaler') return POINT_KEY_WHOLESALER;
            return null;
        }
        
        private String intListToSeparatedStr(List<Integer> intList, String delim) {
            if (intList == null || delim == null) return '';
            intList.sort();
            return String.join(intList, delim);
        }
        
        private Integer calculatePlannedPoint(List<Integer> visitDayIntList) {
            return visitDayIntList == null ? 0 : this.worthPt * visitDayIntList.size();
        }
    }
    
    public class ASI_KOR_VisitationPlanPoint {
        public Integer requiredPt { get; private set; }
        public Integer plannedPt { get; private set; }
        public Integer balancePt { get {return this.requiredPt - this.plannedPt;} private set; }
        
        public ASI_KOR_VisitationPlanPoint(Integer requiredPt, Integer plannedPt) {
            this.requiredPt = requiredPt;
            this.plannedPt = plannedPt;
        }
    }
}