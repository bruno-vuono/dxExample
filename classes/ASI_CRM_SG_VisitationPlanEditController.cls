public with sharing class ASI_CRM_SG_VisitationPlanEditController {
        public static final String VISIT_DAY_DELIM = ', ';
        public static final String POINT_KEY_TOTAL = 'total';
        public static final String ASI_SG_CRM_VISITATIONPLAN_RECORDTYPE = 'ASI_CRM_SG_Visitation_Plan';
        public static final String RT_SG_OUTLET = 'ASI_CRM_SG_Outlet';
        public static final String RT_SG_POTENTIAL_OUTLET = 'ASI_CRM_SG_Potential_Outlet';
        public static final String RT_SG_WHOLE_SALER = 'ASI_CRM_SG_Wholesaler';

        private static final List<String> POINT_KEY_LIST = new List<String> {
            RT_SG_OUTLET , RT_SG_POTENTIAL_OUTLET, RT_SG_WHOLE_SALER 
        };

        private static final Integer DEF_WORTH_POINT = 1;

        // Variables used in VF page
        public List<ASI_HK_CRM_VisitationPlanEditRow> visitTableRows { get; set; }
        public Map<String, ASI_HK_CRM_VisitationPlanPoint> keyToVisitPointMap { get; set; }
        public Map<Date, Integer> dateToVisitCountMap { get; set; }
        public final Date visitPlanBeginDate { get; private set; }
        public final Date visitPlanEndDate { get; private set; }
        public final ID visitPlanId { get; private set; }
        public String ptKeyTotal { get { return POINT_KEY_TOTAL; } private set; }
        public List<String> ptKeyList { get { return POINT_KEY_LIST; } private set; }
        public String visitDayDelim { get {return VISIT_DAY_DELIM;} private set; }
        public String isLocked { get; set; }
        public Boolean hasError { get; set; }

        private final ApexPages.StandardSetController stdSetController;
        private final ASI_HK_CRM_Visitation_Plan__c visitPlanHeader;
        private final List<ASI_HK_CRM_Visitation_Plan_Detail__c> visitDetailList;
        private final ASI_CRM_SG_VisitationPlanDetailGenerator visitDetailGen;
        private final Map<String, Integer> gradeToRequiredPointMap;
        private Integer theYearInt;
        
        private List<Account> accounts;
        private String sortDirection = 'ASC';
        private String sortExp = 'ASI_HK_CRM_Grade__c';
        
        public String searchAccountName { get; set; }            
        
        public String sortExpression {
            get{ return sortExp;}
            set{
                if (value == sortExp)
                    sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
                else
                    sortDirection = 'ASC';
                sortExp = value;
            }
        }
        
        public ASI_CRM_SG_VisitationPlanEditController(ApexPages.StandardSetController stdSetController) {
            this.hasError = false;
            this.stdSetController = stdSetcontroller;
            // Get the visitation information
            
            String parentId = null;                

            parentId = ApexPages.currentPage().getParameters().get('id');
            if (parentId == null) {
                this.hasError = true;
                showPageError(String.format('URL paramether is missing: {0}', new String[] {'id'}));
                return;
            }                
            system.debug('@parentId'+parentId);
            system.debug('@ASI_SG_CRM_VISITATIONPLAN_RECORDTYPE'+ASI_SG_CRM_VISITATIONPLAN_RECORDTYPE);
            this.visitDetailList = [SELECT Id, Name, ASI_HK_CRM_Visitation_Plan__c, ASI_HK_CRM_Account__c, ASI_CRM_MY_Customer__c,
            ASI_HK_CRM_Visit_Date__c FROM ASI_HK_CRM_Visitation_Plan_Detail__c 
            WHERE ASI_HK_CRM_Visitation_Plan__c = :parentId 
            AND ASI_HK_CRM_Visitation_Plan__r.recordtype.DeveloperName  = :ASI_SG_CRM_VISITATIONPLAN_RECORDTYPE ];
           
            this.visitPlanHeader = [SELECT Id, Name, ASI_HK_CRM_Year__c, ASI_HK_CRM_Month__c, ASI_HK_CRM_Confirmed__c, 
                OwnerId FROM ASI_HK_CRM_Visitation_Plan__c 
                WHERE Id = :parentId AND recordtype.DeveloperName = :ASI_SG_CRM_VISITATIONPLAN_RECORDTYPE ];
            this.visitPlanId = this.visitPlanHeader.Id;
            
            // Initialize data for display
            this.visitTableRows = new List<ASI_HK_CRM_VisitationPlanEditRow>();
            this.keyToVisitPointMap = new Map<String, ASI_HK_CRM_VisitationPlanPoint>();
            this.dateToVisitCountMap = new Map<Date, Integer>();
            
            // Initialize the settings
            Integer vpMonth = getVPMonthFromPicklistValue(visitPlanHeader.ASI_HK_CRM_Month__c);
            if (vpMonth == 0) {
                this.hasError = true;
                showPageError(String.format('Unknown Month of {0}: {1}', new String[] {Schema.SObjectType.ASI_HK_CRM_Visitation_Plan__c.getLabel(), visitPlanHeader.ASI_HK_CRM_Month__c}));
                return;
            }
            try {
                this.theYearInt = Integer.valueOf(visitPlanHeader.ASI_HK_CRM_Year__c);
            } catch (TypeException te) {
                this.hasError = true;
                showPageError(String.format('Unknown Year: {0}', new String[] {Schema.SObjectType.ASI_HK_CRM_Visitation_Plan__c.getLabel(), visitPlanHeader.ASI_HK_CRM_Month__c}));
                return;
            }
            this.visitPlanBeginDate = Date.newInstance(theYearInt, vpMonth, 1);
            this.visitPlanEndDate = Date.newInstance(theYearInt, vpMonth, Date.daysInMonth(theYearInt, vpMonth));
            this.isLocked = this.visitPlanHeader.ASI_HK_CRM_Confirmed__c == true ? 'true' : 'false';
            this.gradeToRequiredPointMap = initGradeToVisitCountMap();
            
            this.visitDetailGen = new ASI_CRM_SG_VisitationPlanDetailGenerator();        
        }
        
        public String getSortDirection()
        {
            if (sortExpression == null || sortExpression == '')
                return 'ASC';
            else
                return sortDirection;
        }
        
        public void setSortDirection(String value)
        {  
            sortDirection = value;
        }
        
        public void ResetNameSearch(){
            searchAccountName='';
            NameSearch(); 
        }
        
        public void NameSearch(){
            sortDirection = 'ASC';
            sortExp = 'name';  
            ViewData();     
            //sortExp = 'ASI_HK_CRM_Grade__c'; 
        }
        
        public PageReference ViewData() {
            string sortFullExp = sortExpression  + ' ' + sortDirection;
            if(!sortFullExp.contains('name'))
                sortFullExp +=',name'; 
                
            this.visitTableRows.clear();
            String parentId = ApexPages.currentPage().getParameters().get('id');
            
            List<ASI_HK_CRM_Visitation_Plan_Detail__c> visitDetailList2 = 
            [SELECT Id, Name, ASI_HK_CRM_Visitation_Plan__c, ASI_HK_CRM_Account__c, ASI_HK_CRM_Visit_Date__c ,ASI_CRM_MY_Customer__c
            FROM ASI_HK_CRM_Visitation_Plan_Detail__c 
            WHERE ASI_HK_CRM_Visitation_Plan__c = :parentId 
            AND ASI_HK_CRM_Visitation_Plan__r.recordtype.DeveloperName = :ASI_SG_CRM_VISITATIONPLAN_RECORDTYPE ];
            
            Map<ID, List<Integer>> acctIdToVisitDaysMap = new Map<ID, List<Integer>>();
            this.dateToVisitCountMap = new Map<Date, Integer>();
            for (ASI_HK_CRM_Visitation_Plan_Detail__c vd : visitDetailList2) {
                // List of visitation date of the account
                List<Integer> visitDays = acctIdToVisitDaysMap.get(vd.ASI_CRM_MY_Customer__c);
                if (visitDays == null) {
                    visitDays = new List<Integer>();
                    acctIdToVisitDaysMap.put(vd.ASI_CRM_MY_Customer__c, visitDays);
                }
                if(vd.ASI_HK_CRM_Visit_Date__c != null)
                    visitDays.add(vd.ASI_HK_CRM_Visit_Date__c.day());
                // Update the numbers of visitation of each date
                Integer visitCount = dateToVisitCountMap.get(vd.ASI_HK_CRM_Visit_Date__c);
                if (visitCount == null) {
                    visitCount = 0;
                }
                dateToVisitCountMap.put(vd.ASI_HK_CRM_Visit_Date__c, visitCount + 1);
            }
            
            ID headerOwnerId = this.visitPlanHeader.OwnerId;
            System.Debug('Debug headerOwnerId  :' + headerOwnerId );        
            
            List<ASI_CRM_AccountsAdditionalField__c> targetSObjList=Database.query('SELECT Id, Name, Owner.Name, RecordTypeId, RecordType.Name, RecordType.DeveloperName, ' +
            'ASI_CRM_CN_Address__c,ASI_TH_CRM_OutletType__c,ASI_TH_CRM_OutletSubType__c,ASI_TH_CRM_OutletImage__c,ASI_TH_CRM_LeadBrand__c  ' +
            'FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_CN_Inactive_Flag__c = false ' +
            //Wilken 20151203: Allow sales rep to visit all outlets regardless of owner
            //'AND OwnerId = :headerOwnerId '+
            (searchAccountName.equals('')?'':' and name like \'%'+searchAccountName+'%\' ') +
            'AND (RecordType.DeveloperName = \'' + RT_SG_OUTLET + '\' ' +
            'OR RecordType.DeveloperName = \'' + RT_SG_POTENTIAL_OUTLET + '\' ' +
            'OR RecordType.DeveloperName = \'' + RT_SG_WHOLE_SALER + '\') ' +
            'ORDER BY '+sortFullExp + ' Limit 1000');

            for (ASI_CRM_AccountsAdditionalField__c targetSObj: targetSObjList) {

                System.Debug('targetSObj.id:' + targetSObj.id); 
                System.Debug('targetSObj:' + targetSObj.Name);
                System.Debug('targetSObj.RecordType.DeveloperName:' + targetSObj.RecordType.DeveloperName);
                System.Debug('DEF_WORTH_POINT:' + DEF_WORTH_POINT);
                System.Debug('acctIdToVisitDaysMap.get(targetSObj.Id):' + acctIdToVisitDaysMap.get(targetSObj.Id));
                
                    this.visitTableRows.add(new ASI_HK_CRM_VisitationPlanEditRow(targetSObj, null,
                targetSObj.RecordType.DeveloperName, DEF_WORTH_POINT, acctIdToVisitDaysMap.get(targetSObj.Id)));
            }
            
            for (Date tempDate = this.visitPlanBeginDate; tempDate <= this.visitPlanEndDate; tempDate = tempDate.addDays(1)) {
                Integer visitCount = dateToVisitCountMap.get(tempDate);
                if (visitCount == null)
                    dateToVisitCountMap.put(tempDate, 0);
            }
            // Calculate the overall points
            initOverallPoints();

            return null;
        }
            
        public PageReference initPage() {
            if (hasError) return null;
            // Summarize the visitation details by Account
            Map<ID, List<Integer>> acctIdToVisitDaysMap = new Map<ID, List<Integer>>();
            this.dateToVisitCountMap = new Map<Date, Integer>();
            for (ASI_HK_CRM_Visitation_Plan_Detail__c vd : visitDetailList) {
                // List of visitation date of the account
                List<Integer> visitDays = acctIdToVisitDaysMap.get(vd.ASI_CRM_MY_Customer__c);
                if (visitDays == null) {
                    visitDays = new List<Integer>();
                    acctIdToVisitDaysMap.put(vd.ASI_CRM_MY_Customer__c, visitDays);
                }
                if(vd.ASI_HK_CRM_Visit_Date__c != null)
                    visitDays.add(vd.ASI_HK_CRM_Visit_Date__c.day());
                // Update the numbers of visitation of each date
                Integer visitCount = dateToVisitCountMap.get(vd.ASI_HK_CRM_Visit_Date__c);
                if (visitCount == null) {
                    visitCount = 0;
                }
                dateToVisitCountMap.put(vd.ASI_HK_CRM_Visit_Date__c, visitCount + 1);
            }

            // Create table row info for each Account
            ID headerOwnerId = this.visitPlanHeader.OwnerId;
            for (List<ASI_CRM_AccountsAdditionalField__c> targetSObjList : [SELECT Id, Name, Owner.Name, RecordTypeId, RecordType.Name, RecordType.DeveloperName, 
            ASI_CRM_CN_Address__c,ASI_TH_CRM_OutletType__c,ASI_TH_CRM_OutletSubType__c,ASI_TH_CRM_OutletImage__c,ASI_TH_CRM_LeadBrand__c
            FROM ASI_CRM_AccountsAdditionalField__c WHERE ASI_CRM_CN_Inactive_Flag__c = false  
            //Wilken 20151203: Allow sales rep to visit all outlets regardless of owner
            //AND OwnerId = :headerOwnerId 
            AND (RecordType.DeveloperName = :RT_SG_OUTLET OR RecordType.DeveloperName = :RT_SG_POTENTIAL_OUTLET OR RecordType.DeveloperName = :RT_SG_WHOLE_SALER)
            ORDER BY Name Limit 1000]) {
                for (ASI_CRM_AccountsAdditionalField__c targetSObj: targetSObjList) {     
                    
                    this.visitTableRows.add(new ASI_HK_CRM_VisitationPlanEditRow(targetSObj, null,
                    targetSObj.RecordType.DeveloperName, DEF_WORTH_POINT, acctIdToVisitDaysMap.get(targetSObj.Id)));
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
                redirectPage = Page.ASI_CRM_SG_VisitationPlanEditPage;
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
                redirectPage.setRedirect(true);
            }
            return redirectPage;
        }        
        
        public Boolean implSaveChanges() {
            List<ASI_HK_CRM_Visitation_Plan_Detail__c> visitDetailList = 
            [SELECT Id, ASI_HK_CRM_Visit_Date__c, ASI_HK_CRM_Account__c ,ASI_CRM_MY_Customer__c
            FROM ASI_HK_CRM_Visitation_Plan_Detail__c WHERE ASI_HK_CRM_Visitation_Plan__c = :visitPlanHeader.Id 
            ORDER BY ASI_HK_CRM_Visit_Date__c];
            Map<ID, List<ASI_HK_CRM_Visitation_Plan_Detail__c>> acctIdToVisitDetailMap = new Map<ID, List<ASI_HK_CRM_Visitation_Plan_Detail__c>>();
            for (ASI_HK_CRM_Visitation_Plan_Detail__c vDetail : visitDetailList) {
                List<ASI_HK_CRM_Visitation_Plan_Detail__c> tempVisitDetailList = acctIdToVisitDetailMap.get(vDetail.ASI_CRM_MY_Customer__c);
                if (tempVisitDetailList == null) {
                    tempVisitDetailList = new List<ASI_HK_CRM_Visitation_Plan_Detail__c>();
                    acctIdToVisitDetailMap.put(vDetail.ASI_CRM_MY_Customer__c, tempVisitDetailList);
                }
                tempVisitDetailList.add(vDetail);
            }
            List<ASI_HK_CRM_Visitation_Plan_Detail__c> deleteVisitDetailList = new List<ASI_HK_CRM_Visitation_Plan_Detail__c>();
            List<ASI_HK_CRM_Visitation_Plan_Detail__c> insertVisitDetailList = new List<ASI_HK_CRM_Visitation_Plan_Detail__c>();
            system.debug('@visitTableRows'+visitTableRows);
            for (ASI_HK_CRM_VisitationPlanEditRow row : visitTableRows) {
                ASI_CRM_AccountsAdditionalField__c acct = row.targetSObj;
                
                ID acctId = row.targetSObj.Id;
                List<ASI_HK_CRM_Visitation_Plan_Detail__c> vDetailList = acctIdToVisitDetailMap.get(acctId);
                if (vDetailList == null) vDetailList = new List<ASI_HK_CRM_Visitation_Plan_Detail__c>();
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
                    if (!reachEndOfOriginal) originalDay = vDetailList.get(j).ASI_HK_CRM_Visit_Date__c.day();
                    if (!reachEndOfUserInput && (reachEndOfOriginal || userInputDay < originalDay)) {
                        system.debug('@acct'+acct);
                        insertVisitDetailList.add(
                            this.visitDetailGen.generateVisitationPlanDetail(
                                this.visitPlanHeader
                                , acct
                                , Date.newInstance(this.theYearInt, getVPMonthFromPicklistValue(visitPlanHeader.ASI_HK_CRM_Month__c), userInputDay)
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
                    system.debug('@insertVisitDetailList'+insertVisitDetailList);
                    insert insertVisitDetailList;
                } catch (DmlException dmle) {
                    allSuccess = false;
                    database.rollback(sp);
                }
            }
            
            return allSuccess;
        }
        
        private Integer getVPMonthFromPicklistValue(String plValue) {
            Integer result = ASI_HK_CRM_VisitationPlanGenerator.convertMonthPLValueToInteger(plValue);
            if (result == null) return 0;
            return result;
        }
        private void initOverallPoints() {
            List<RecordType> rtList = [SELECT Id, Name, DeveloperName FROM RecordType 
            WHERE DeveloperName IN (:RT_SG_OUTLET , :RT_SG_POTENTIAL_OUTLET, :RT_SG_WHOLE_SALER )];
            this.keyToVisitPointMap = new Map<String, ASI_HK_CRM_VisitationPlanPoint>();
            for (RecordType rt : rtList) {
                System.Debug('Debug rt.DeveloperName:' + rt.DeveloperName);
                this.keyToVisitPointMap.put(
                    rt.DeveloperName
                    , new ASI_HK_CRM_VisitationPlanPoint(rt.Name, 0, 0)
                );
            }
            
            Integer totalRequiredPt = 0;
            Integer totalPlannedPt = 0;
            system.debug('@this.visitTableRows'+this.visitTableRows);
            for (ASI_HK_CRM_VisitationPlanEditRow visitRow : this.visitTableRows) {
                if (visitRow.customType == null) continue;
                ASI_HK_CRM_VisitationPlanPoint pt = keyToVisitPointMap.get(visitRow.customType);
                if (pt == null) continue;
                pt.plannedPt = pt.plannedPt + visitRow.plannedPt;
                totalPlannedPt += visitRow.plannedPt;
                system.debug('@pt.plannedPt'+pt.plannedPt);
                system.debug('@visitRow.plannedPt'+visitRow.plannedPt);
                system.debug('@totalPlannedPt'+totalPlannedPt);
            }
            keyToVisitPointMap.put(POINT_KEY_TOTAL, new ASI_HK_CRM_VisitationPlanPoint(Label.ASI_HK_CRM_VF_VISIT_TotalPoint, totalRequiredPt, totalPlannedPt));
            system.debug('@keyToVisitPointMap'+keyToVisitPointMap);
        }
        
        private Map<String, Integer> initGradeToVisitCountMap() {
            Map<String, Integer> result = new Map<String, Integer>();
            Map<String, ASI_HK_CRM_AcctGradeVisitCountMapping__c> settingMap = ASI_HK_CRM_AcctGradeVisitCountMapping__c.getAll();
            Set<String> gradeSet = settingMap.keySet();
            for (String gradeStr : gradeSet) {
                result.put(gradeStr, settingMap.get(gradeStr).ASI_HK_CRM_No_of_Required_Visitation__c.intValue());
            }
            return result;
        }
        
        private void showPageMessage(ApexPages.Severity severity, String msg) {
            ApexPages.addMessage(new ApexPages.Message(severity, msg));
        }
        private void showPageError(String msg) {
            showPageMessage(ApexPages.Severity.ERROR, msg);
        }
        
        public class ASI_HK_CRM_VisitationPlanEditRow {
            public ASI_CRM_AccountsAdditionalField__c targetSObj { get; set; }
            public ASI_CRM_AccountsAdditionalField__c additionalField { get; set; }
            public String customType { get; private set; }
            public Integer worthPt { get; set; }
            //public Integer requiredPt { get; set; }
            public Integer plannedPt { get; private set; }
            public String visitDayStr { get; set; }
            
            public ASI_HK_CRM_VisitationPlanEditRow(ASI_CRM_AccountsAdditionalField__c targetSObj, ASI_CRM_AccountsAdditionalField__c additionalField, String customType, 
            Integer worthPt, List<Integer> visitDayIntList) {
                this.targetSObj = targetSObj;
                this.additionalField = additionalField;
                this.customType = customType;
                this.worthPt = worthPt;
                this.visitDayStr = intListToSeparatedStr(visitDayIntList, VISIT_DAY_DELIM);
                this.plannedPt = calculatePlannedPoint(visitDayIntList);
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
        
        public class ASI_HK_CRM_VisitationPlanPoint {
            public String label { get; private set; }
            public Integer requiredPt { get; private set; }
            public Integer plannedPt { get; private set; }
            public Integer balancePt { get {return this.requiredPt - this.plannedPt;} private set; }
            
            public ASI_HK_CRM_VisitationPlanPoint(String label, Integer requiredPt, Integer plannedPt) {
                this.label = label;
                this.requiredPt = requiredPt;
                this.plannedPt = plannedPt;
            }
        }

    }