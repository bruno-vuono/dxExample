public with sharing class ASI_CRM_SG_PromotionCalendarYearCON extends ASI_CRM_SG_PromotionCalendarCommonClass {

    public static String SUBBRAND_FILTER_VALUE = 'Sub-Brand';
    public static String CHANNEL_FILTER_VALUE = 'Channel';
    public static String OUTLETSUBTYPE_FILTER_VALUE = 'Outlet Subtype';
    public static final String URL_PARAM_YEAR = 'year';
    public static final String URL_PARAM_MONTH = 'month'; 
    public static final String RECORTYPE_DEV_NAME = 'ASI_CRM_SG';
    static Id RectypeId { get{return [Select Id from Recordtype where developername=:RECORTYPE_DEV_NAME].Id;} set;}
    public String FilterPickListValue {get; set;}

    public Date filterFromDate { get; set; }
    public Date filterToDate { get; set; }
  
    // Calendar Settings
    public List<String> yearList { get; private set; }
    public Map<String, Integer> yearColSpan { get; private set; }
    public List<String> monthList { get; private set; }
    public List<ASI_CRM_SG_PromotionYearGroup> eventGroups { get; private set; }
  
    // Event Data
    public List<ASI_CRM_SG_PromotionYearEvent> eventList { get; private set; }
    public List<ASI_HK_CRM_HoverPopupInfoData> popupDataList { get; private set; }
  
    // Other Info
    public String prevYearLink { get; private set; }
    public String nextYearLink { get; private set; }
  
    private List<String> userMonthStrList;
    private String groupField;
    private String groupFieldObj;
    private Object groupFieldNullReplace;
    private String groupFieldObjWhereStatm;
    private Set<String> filterGroupValues;
    private String pmtLabel;
    private List<ASI_HK_CRM_HoverPopupInfoData.ASI_HK_CRM_HoverPopupInfoDataRow> popupTableRow; 

    private static final List<String> POPUP_DISPLAY_FIELDS_PMT = new String[] {
        'Name'
        , 'ASI_HK_CRM_Promotion_Name__c'
        , 'ASI_HK_CRM_Promotion_Start_Date__c'
        , 'ASI_HK_CRM_Promotion_End_Date__c'
        , 'ASI_HK_CRM_Record_Type_Name__c'
    };

    private static  String GROUP_FIELD_DEF='';
    private static  String GROUP_FIELD_OBJECT='';
    private static  String GROUP_FIELD_NULL_REPLACE = '';
    private static final String SUB_BRAND_GROUP_FIELD_OBJECT_WHERE_STATM = 'RecordType.DeveloperName = \'ASI_CRM_SG_Sub_brand\'';
    private static final String CUSTOMER_GROUP_FIELD_OBJECT_WHERE_STATM = 'RecordType.DeveloperName = \'ASI_CRM_SG_Customer\'';
    private static final Integer LAYOUT_MONTH_WIDTH = 80;
    private static final Integer LAYOUT_EVENT_HEIGHT = 26;
    private static final Integer LAYOUT_EVENT_DISTANCE_Y = 4;
    private static final Integer LAYOUT_EVENT_BORDER_BOTTOM = 1;
    private static final Integer LAYOUT_EVENT_SPACE_X_BEGIN = 2;
    private static final Integer LAYOUT_EVENT_SPACE_X_END = 2;

    // Outlet Types
    private Map<String,ASI_CRM_Outlet_Type__c> outletTypes;
    
    public Map<String,ASI_CRM_Outlet_Type__c> getOutletType()
    {
         return outletTypes;
    }

    public void setOutletType(){
        system.debug('@FilterPickListValue'+FilterPickListValue);
        outletTypes = new Map<String,ASI_CRM_Outlet_Type__c>([Select Id,ASI_CRM_SG_Name__c from ASI_CRM_Outlet_Type__c]);
    }

    public ASI_CRM_SG_PromotionCalendarYearCON() {
        super(CALENDAR_TYPE_YEAR);
        Map<String, String> urlParamsMap = ApexPages.currentPage().getParameters();
        String paramYear = null;
        String paramMonth = null;
        if (urlParamsMap != null) {
            paramYear = urlParamsMap.get(CALENDAR_TYPE_YEAR);
            paramMonth = urlParamsMap.get(URL_PARAM_MONTH);
        }
        Date requestDate = (isValidYear(paramYear) && isValidMonth(paramMonth))
            ? Date.newInstance(Integer.valueOf(paramYear), Integer.valueOf(paramMonth) + 1, 1)
            : Date.today();
        filterFromDate = Date.newInstance(requestDate.year(), requestDate.month(), 1);
        Date nextYear = filterFromDate.addYears(1).addMonths(-1);
        filterToDate = Date.newInstance(nextYear.year(), nextYear.month(), Date.daysInMonth(nextYear.year(), nextYear.month()));
        String yearBtnFormatStr = (ApexPages.currentPage().getUrl().split('\\?')[0]) + '?' + CALENDAR_TYPE_YEAR + '={0}&' + URL_PARAM_MONTH + '={1}';
        Date tempPrevDate = filterFromDate.addMonths(-11);
        prevYearLink = String.format(yearBtnFormatStr, new String[] {String.valueOf(tempPrevDate.year()), String.valueOf(tempPrevDate.month() - 1)});
        Date tempNextDate = filterToDate;
        nextYearLink = String.format(yearBtnFormatStr, new String[] {String.valueOf(tempNextDate.year()), String.valueOf(tempNextDate.month() - 1)});
        yearList = new List<String>();
        yearColSpan = new Map<String, Integer>();
        monthList = new List<String>();
        eventGroups = new List<ASI_CRM_SG_PromotionYearGroup>();
        eventList = new List<ASI_CRM_SG_PromotionYearEvent>();
        popupDataList = new List<ASI_HK_CRM_HoverPopupInfoData>();
        userMonthStrList = getUserMonthStringList();
        //initFieldAndObjectDefinition();
        //groupFieldObjWhereStatm = GROUP_FIELD_OBJECT_WHERE_STATM;
        filterGroupValues = null;
        pmtLabel = Schema.SObjectType.ASI_HK_CRM_Promotion__c.getLabel();
        popupTableRow = getPopupDisplayRowList();
    }
    
    public void initFieldAndObjectDefinition(){
        system.debug('@FilterPickListValue'+FilterPickListValue);
        system.debug('@OUTLETSUBTYPE_FILTER_VALUE'+OUTLETSUBTYPE_FILTER_VALUE);
        system.debug('@SUBBRAND_FILTER_VALUE'+SUBBRAND_FILTER_VALUE);
        system.debug('@CHANNEL_FILTER_VALUE'+CHANNEL_FILTER_VALUE);

         if(FilterPickListValue==CHANNEL_FILTER_VALUE){
            GROUP_FIELD_DEF = 'ASI_CRM_Channel__c'; 
            GROUP_FIELD_OBJECT = 'ASI_HK_CRM_Promotion__c';    
            GROUP_FIELD_NULL_REPLACE = 'National'; 

        }    
        else {
            if(FilterPickListValue==OUTLETSUBTYPE_FILTER_VALUE){
                GROUP_FIELD_DEF = 'ASI_CRM_SG_Customer__r.ASI_CRM_SG_Outlet_Type__c';
                GROUP_FIELD_OBJECT = 'ASI_HK_CRM_Promotion_Details__r'; 
                GROUP_FIELD_NULL_REPLACE = '';
                groupFieldObjWhereStatm = CUSTOMER_GROUP_FIELD_OBJECT_WHERE_STATM; 
            }
            if(FilterPickListValue==SUBBRAND_FILTER_VALUE || FilterPickListValue ==null){
                GROUP_FIELD_DEF = 'ASI_CRM_SG_Sub_brand__r.Name'; 
                GROUP_FIELD_OBJECT = 'ASI_HK_CRM_Promotion_Details__r';
                GROUP_FIELD_NULL_REPLACE = 'National';
                groupFieldObjWhereStatm = SUB_BRAND_GROUP_FIELD_OBJECT_WHERE_STATM; 
            }
        }    
        groupField = GROUP_FIELD_DEF;
        groupFieldObj = GROUP_FIELD_OBJECT;
        groupFieldNullReplace = GROUP_FIELD_NULL_REPLACE;
        system.debug('@groupField'+groupField);

    }

    public PageReference initPage() {
        System.debug('@initPage start...');
        eventList = new List<ASI_CRM_SG_PromotionYearEvent>();
        initFieldAndObjectDefinition();
        setOutletType();
        reloadData();
        return null;
    }
    
    public void reloadData() {
        system.debug('@FilterPickListValue'+FilterPickListValue);
        System.debug('@reloadData start...');
        reloadYearAndMonthDisplayList();
        List<ASI_HK_CRM_Promotion__c> promotionList = queryPromotions();
        system.debug('@promotionList'+promotionList);
        reloadEventDisplayData(promotionList);
    }
    
    private void reloadYearAndMonthDisplayList() {
        yearList = new List<String>();
        Integer finishYear = filterToDate.year();
        for (Integer y = filterFromDate.year(); y <= finishYear; y++) {
            yearList.add(String.valueOf(y));
        }
        
        monthList = new List<String>();
        yearColSpan = new Map<String, Integer>();
        Integer monthsBetween = filterFromDate.monthsBetween(filterToDate);
        Integer yearIndex = 0;
        Integer monthCount = 0;
        if (monthsBetween >= 0) {
            Integer fromMonth = filterFromDate.month();
            for (Integer i = 0; i <= monthsBetween; i++) {
                Integer monthIndex = Math.mod(fromMonth - 1 + i, 12);
                monthList.add(userMonthStrList.get(monthIndex));
                monthCount++;
                if (monthIndex == 11 || i == monthsBetween) {
                    yearColSpan.put(yearList.get(yearIndex), monthCount);
                    yearIndex++;
                    monthCount = 0;
                }
            }
        }
        system.debug('@monthList'+monthList);
    }
    
   private List<ASI_HK_CRM_Promotion__c> queryPromotions() {
        String groupFilterStatm = null;
        system.debug('filterGroupValues'+filterGroupValues);
        if (filterGroupValues != null && filterGroupValues.size() > 0)
            groupFilterStatm = groupField + ' IN :filterGroupValues';
        else
            groupFilterStatm = '';
        Set<String> fieldSet = new Set<String>(POPUP_DISPLAY_FIELDS_PMT);
        system.debug('@groupFilterStatm'+groupFilterStatm);
        system.debug('@fieldSet'+fieldSet);
        fieldSet.add('Id');
        fieldSet.add('Name');
        fieldSet.add('ASI_HK_CRM_Promotion_Name__c');
        fieldSet.add('ASI_HK_CRM_Promotion_Start_Date__c');
        fieldSet.add('ASI_HK_CRM_Promotion_End_Date__c');
        fieldSet.add('ASI_HK_CRM_Background_Color__c');
        fieldSet.add('ASI_HK_CRM_Text_Color__c');
        system.debug('@!isChildObjGroupField()'+!isChildObjGroupField());
        if (!isChildObjGroupField()) {
            fieldSet.add(groupField);
        } else {
            String childWhereStatm = '';
            system.debug('@groupFieldObjWhereStatm'+groupFieldObjWhereStatm);
            system.debug('@childWhereStatm'+childWhereStatm);
            if (groupFieldObjWhereStatm != null && groupFieldObjWhereStatm.trim() != '') {
                if (childWhereStatm != '') childWhereStatm += ' AND ';
                childWhereStatm += '(' + groupFieldObjWhereStatm + ')';
            }
            system.debug('@groupFilterStatm'+groupFilterStatm);
            if (groupFilterStatm != null && groupFilterStatm.trim() != '') {
                if (childWhereStatm != '') childWhereStatm += ' AND ';
                childWhereStatm += '(' + groupFilterStatm + ')';
            }
            system.debug('@childWhereStatm'+childWhereStatm);
            if (childWhereStatm != '')
                childWhereStatm = 'WHERE ' + childWhereStatm;
            fieldSet.add(String.format('(SELECT {0} FROM {1} {2})', new String[] {groupField, groupFieldObj, childWhereStatm}));
            system.debug('@fieldSet'+fieldSet);
        }
        String fieldsStr = String.join(new List<String>(fieldSet), ', ');
        String dateFilterStatm = '(ASI_HK_CRM_Promotion_Start_Date__c >= :filterFromDate AND ASI_HK_CRM_Promotion_Start_Date__c <= :filterToDate)'
            + ' OR (ASI_HK_CRM_Promotion_End_Date__c >= :filterFromDate AND ASI_HK_CRM_Promotion_End_Date__c <= :filterToDate)'
            + ' OR (ASI_HK_CRM_Promotion_Start_Date__c <= :filterFromDate AND ASI_HK_CRM_Promotion_End_Date__c >= :filterToDate)';
        
        String whereStatm = '';
        String recordtypeFilterStatm = 'AND RecordtypeId=:RectypeId';
        if(FilterPickListValue==CHANNEL_FILTER_VALUE){
            whereStatm = '(' + dateFilterStatm + ')' + ' AND (' + groupField + '!=null'+')';       
        }    
        else {

            whereStatm = '(' + dateFilterStatm + ')'
            + (isChildObjGroupField() || groupFilterStatm == null ? '' : ' AND (' + groupFilterStatm + ')');
        }
        system.debug('@isChildObjGroupField'+isChildObjGroupField());
        system.debug('@groupFilterStatm'+groupFilterStatm);
        //whereStatm +=   '(' + recordtypeFilterStatm + ')'; 
        whereStatm +=  recordtypeFilterStatm;
        system.debug('@whereStatm'+whereStatm);
        system.debug('@fieldsStr'+fieldsStr);
        String queryStr = 'SELECT ' + fieldsStr
            + ' FROM ASI_HK_CRM_Promotion__c'
            + ' WHERE ' + whereStatm
            + ' ORDER BY ASI_HK_CRM_Promotion_Start_Date__c';
        system.debug('@queryStr'+queryStr);    
        system.debug('@database.query(queryStr'+database.query(queryStr));  
        system.debug('@groupFilterStatm'+groupFilterStatm);  
        return database.query(queryStr);
    }
    
    // Display the Sub Brand with promotions in one table
    private void reloadEventDisplayData(List<ASI_HK_CRM_Promotion__c> pmtList) {
        Set<String> eventGroupStrSet = new Set<String>();
        Map<String, List<ASI_CRM_SG_PromotionYearEvent>> eventGroupToEventMap = new Map<String, List<ASI_CRM_SG_PromotionYearEvent>>();
        // Get the HoverPopupInfoData 
        popupDataList = new List<ASI_HK_CRM_HoverPopupInfoData>();
        for (ASI_HK_CRM_Promotion__c pmt : pmtList) {
            List<ASI_CRM_SG_PromotionYearEvent> pmtEventList = pmtToEvents(pmt);
            system.debug('@pmtEventList'+pmtEventList);
            system.debug('@FilterPickListValue'+FilterPickListValue);
            popupDataList.add(pmtToEventPopup(pmt));
           
            if(FilterPickListValue==OUTLETSUBTYPE_FILTER_VALUE){
                system.debug('@OUTLETSUBTYPE_FILTER_VALUE'+OUTLETSUBTYPE_FILTER_VALUE);
                system.debug('@FilterPickListValue'+FilterPickListValue);
                for (ASI_CRM_SG_PromotionYearEvent pmtEvent : pmtEventList) {
                    system.debug('@pmtEvent'+pmtEvent);

                    Object groupValue = pmtEvent.groupValue;
                    String groupValueStr = String.valueOf(groupValue);
                    this.eventList.add(pmtEvent);
                    String groupName='';
                    groupName = outletTypes.get(groupValueStr).ASI_CRM_SG_Name__c;
                    eventGroupStrSet.add(outletTypes.get(groupValueStr).ASI_CRM_SG_Name__c);
                    system.debug('@eventGroupStrSet'+eventGroupStrSet);
                    List<ASI_CRM_SG_PromotionYearEvent> tempEventList = eventGroupToEventMap.get(groupName);
                    if (tempEventList == null) {
                        tempEventList = new List<ASI_CRM_SG_PromotionYearEvent>();
                        if(groupValueStr.length()>0){
                            eventGroupToEventMap.put(groupName, tempEventList);
                        }
                        
                    }
                    tempEventList.add(pmtEvent);
                }
            }
            else{
                for (ASI_CRM_SG_PromotionYearEvent pmtEvent : pmtEventList) {
                    Object groupValue = pmtEvent.groupValue;
                    system.debug('@groupValue'+groupValue);
                    String groupValueStr = String.valueOf(groupValue);
                    system.debug('@groupValueStr'+groupValueStr);
                    eventList.add(pmtEvent);
                    eventGroupStrSet.add(groupValueStr);
                    system.debug('@eventGroupStrSet'+eventGroupStrSet);
                    List<ASI_CRM_SG_PromotionYearEvent> tempEventList = eventGroupToEventMap.get(groupValueStr);
                    if (tempEventList == null) {
                        tempEventList = new List<ASI_CRM_SG_PromotionYearEvent>();
                        eventGroupToEventMap.put(groupValueStr, tempEventList);
                    }
                    tempEventList.add(pmtEvent);
                }     
            }
           
            
        }
        //system.debug('@eventGroupToEventMap'+eventGroupToEventMap);
        List<String> eventGroupStrList = new List<String>(eventGroupStrSet);
        eventGroupStrList.sort();
        eventGroups = new List<ASI_CRM_SG_PromotionYearGroup>(); 
        system.debug('@eventGroupStrList'+eventGroupStrList);
        for (String groupName : eventGroupStrList) {
            system.debug('@@eventGroups'+eventGroups);
            eventGroups.add(new ASI_CRM_SG_PromotionYearGroup(groupName));
        }
        system.debug('@eventGroups'+eventGroups);
        Map<String, ASI_CRM_SG_PromotionYearQueue> queueMap = new Map<String, ASI_CRM_SG_PromotionYearQueue>();
        for (ASI_CRM_SG_PromotionYearGroup eventGroup : eventGroups) {
            if(eventGroupToEventMap.containsKey(eventGroup.groupName)){

                queueMap.put(eventGroup.groupName, new ASI_CRM_SG_PromotionYearQueue(eventGroup, eventGroupToEventMap.get(eventGroup.groupName)));
            }    
        }
        system.debug('@queueMap'+queueMap);
        if(queueMap.size()>0)
        calculateLayout(eventList, eventGroups, queueMap);
    }
    
    private void calculateLayout(List<ASI_CRM_SG_PromotionYearEvent> eventList, List<ASI_CRM_SG_PromotionYearGroup> sortedGroupList, Map<String, ASI_CRM_SG_PromotionYearQueue> queueMap) {
        for (ASI_CRM_SG_PromotionYearEvent theEvent : eventList) {
            theEvent.setLayout(filterFromDate, filterToDate, 0, LAYOUT_MONTH_WIDTH, LAYOUT_EVENT_HEIGHT, LAYOUT_EVENT_SPACE_X_BEGIN, LAYOUT_EVENT_SPACE_X_END);
        }
        Integer curTop = LAYOUT_EVENT_DISTANCE_Y / 2;
        Integer incrementY = LAYOUT_EVENT_HEIGHT + LAYOUT_EVENT_DISTANCE_Y + LAYOUT_EVENT_BORDER_BOTTOM;
        for (ASI_CRM_SG_PromotionYearGroup eventGroup : sortedGroupList) {
            ASI_CRM_SG_PromotionYearQueue queue = queueMap.get(eventGroup.groupName);
            Integer queueNextTop = queue.calculatePosition(curTop, incrementY);
            eventGroup.heightInt = queueNextTop - curTop;
            curTop = queueNextTop;
        }
    }
    // Returns a list of ASI_CRM_SG_PromotionYearEvent    
    private List<ASI_CRM_SG_PromotionYearEvent> pmtToEvents(ASI_HK_CRM_Promotion__c pmt) {
        List<ASI_CRM_SG_PromotionYearEvent> result = new List<ASI_CRM_SG_PromotionYearEvent>();
        List<Object> groupFieldValueList = getGroupFieldValues(pmt);
        system.debug('@groupFieldValueList'+groupFieldValueList);
        for (Object groupFieldValue : groupFieldValueList) {
            system.debug('@groupFieldValue'+groupFieldValue);
              system.debug('@FilterPickListValue'+FilterPickListValue);
            system.debug('@OUTLETSUBTYPE_FILTER_VALUE'+OUTLETSUBTYPE_FILTER_VALUE);
            if(FilterPickListValue==OUTLETSUBTYPE_FILTER_VALUE){
                String groupValueStr = String.valueOf(groupFieldValue);
                if(groupValueStr.length()>0){
                    ASI_CRM_SG_PromotionYearEvent theEvent = new ASI_CRM_SG_PromotionYearEvent();
                    theEvent.sObjId = pmt.Id;
                    theEvent.groupValue = groupFieldValue;
                    theEvent.title = pmt.ASI_HK_CRM_Promotion_Name__c;
                    theEvent.startDate = pmt.ASI_HK_CRM_Promotion_Start_Date__c;
                    theEvent.endDate = pmt.ASI_HK_CRM_Promotion_End_Date__c;
                    theEvent.popupId = pmt.Id;
                    theEvent.backgroundColor = pmt.ASI_HK_CRM_Background_Color__c;
                    theEvent.color = pmt.ASI_HK_CRM_Text_Color__c;
                    result.add(theEvent);
                }
            }
            else{
                ASI_CRM_SG_PromotionYearEvent theEvent = new ASI_CRM_SG_PromotionYearEvent();
                theEvent.sObjId = pmt.Id;
                theEvent.groupValue = groupFieldValue;
                theEvent.title = pmt.ASI_HK_CRM_Promotion_Name__c;
                theEvent.startDate = pmt.ASI_HK_CRM_Promotion_Start_Date__c;
                theEvent.endDate = pmt.ASI_HK_CRM_Promotion_End_Date__c;
                theEvent.popupId = pmt.Id;
                theEvent.backgroundColor = pmt.ASI_HK_CRM_Background_Color__c;
                theEvent.color = pmt.ASI_HK_CRM_Text_Color__c;
                result.add(theEvent);     
            }
         
        }
        return result;
    }
        
    private ASI_HK_CRM_HoverPopupInfoData pmtToEventPopup(ASI_HK_CRM_Promotion__c pmt) {
        Map<String, Object> popupValueMap = new Map<String, Object>();
        for (String f : POPUP_DISPLAY_FIELDS_PMT) {
            Object fValue = pmt.get(f);
            system.debug('@fValue'+fValue);
            system.debug('@@@f'+f);
            popupValueMap.put(f, objToStr(fValue));
            system.debug('@popupValueMap'+popupValueMap);
        }
        ASI_HK_CRM_HoverPopupInfoData result = new ASI_HK_CRM_HoverPopupInfoData(pmtLabel, popupTableRow, popupValueMap);
        result.dataId = pmt.Id;
        return result;
    }
    
    private String objToStr(Object theObj) {
        if (theObj == null) {
            return '';
        } else if (theObj instanceof Date) {
            return ((Date)theObj).format();
        } else if (theObj instanceof Datetime) {
            return ((Datetime)theObj).format();
        }
        return String.valueOf(theObj);
    }
    
    private List<String> getUserMonthStringList() {
        List<String> result = new List<String>();
        for (Integer i = 0; i < 12; i++) {
            result.add(Datetime.newInstance(2000, i + 1, 10).format('MMM'));
        }
        return result;
    }
    
    private List<ASI_HK_CRM_HoverPopupInfoData.ASI_HK_CRM_HoverPopupInfoDataRow> getPopupDisplayRowList() {
        List<ASI_HK_CRM_HoverPopupInfoData.ASI_HK_CRM_HoverPopupInfoDataRow> result = new List<ASI_HK_CRM_HoverPopupInfoData.ASI_HK_CRM_HoverPopupInfoDataRow>();
        Map<String, Schema.SObjectField> pmtFieldMap = Schema.SObjectType.ASI_HK_CRM_Promotion__c.fields.getMap();
        for (String f : POPUP_DISPLAY_FIELDS_PMT) {
            result.add(new ASI_HK_CRM_HoverPopupInfoData.ASI_HK_CRM_HoverPopupInfoDataRow(f, pmtFieldMap.get(f).getDescribe().getLabel()));
        }
        system.debug('@result'+result);
        return result;
    }
    
    private Boolean isChildObjGroupField() {
        system.debug('@groupFieldObj'+groupFieldObj);
        return groupFieldObj != null && groupFieldObj != 'ASI_HK_CRM_Promotion__c';
    }
    // Returns a list of Sub brand unique names
    private List<Object> getGroupFieldValues(ASI_HK_CRM_Promotion__c pmt) {
        Set<Object> result = new Set<Object>();
        if (isChildObjGroupField()) {
            List<sObject> childObjList = pmt.getSObjects(groupFieldObj);
            system.debug('@childObjList'+childObjList);
            if (childObjList == null || childObjList.size() == 0) {
                result.add(groupFieldNullReplace);
            } else {
                for (sObject childObj : childObjList) {
                    system.debug('@childObj'+childObj);
                    system.debug('@groupField'+groupField);
                    List<Object> theValue = getLookupValue(childObj, groupField);
                    system.debug('@theValue'+theValue);
                    result.addAll(theValue.size()>0 ? theValue : new List<Object>());
                }
            }
        } else {
            List<Object> theValue = getLookupValue(pmt, groupField);
            if (theValue.size()>0)
                result.addAll(theValue.size()>0 ? theValue : null);
        }
        return new List<Object>(result);
    }
    
    private List<Object> getLookupValue(sObject sObj, String theField) {
        List<String> fieldStrList = theField.split('\\.', 0);
        system.debug('@fieldStrList'+fieldStrList);
        if (fieldStrList.size() == 0) fieldStrList.add(theField);
        Integer size = fieldStrList.size();
        system.debug('@size'+size);
        sObject tempSObj = sObj;
        system.debug('@tempSObj'+tempSObj);
        for (Integer i = 0; i < size - 1; i++) {
            tempSObj = tempSObj.getSObject(fieldStrList.get(i));
            system.debug('@tempSObj'+tempSObj);
            if (tempSObj == null)
                return null;
        }
        List<Object> tempSObjList = new List<Object>();
        if(tempSObj.get(fieldStrList.get(size - 1))!=null){
            String channelsSTR = String.valueOf(tempSObj.get(fieldStrList.get(size - 1)));
            List<String> channelsSTRList = channelsSTR.split(';');
            tempSObjList = (List<Object>)channelsSTRList;
        }
        return tempSObjList;
    }

    // Filter Picklist values

    public List<SelectOption> getFilters() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(SUBBRAND_FILTER_VALUE,SUBBRAND_FILTER_VALUE));
        options.add(new SelectOption(CHANNEL_FILTER_VALUE,CHANNEL_FILTER_VALUE));
        options.add(new SelectOption(OUTLETSUBTYPE_FILTER_VALUE,OUTLETSUBTYPE_FILTER_VALUE));
        return options;
    }
   
}