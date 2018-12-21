/*********************************************************************************
 * Name: ASI_CRM_JP_SOAssignDate
 * Description: Assign the Order Date and Requested Date to Final Sales Order
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 20/04/2017       Hugo Cheung             Created          
*/
public class ASI_CRM_JP_SOAssignDate extends ASI_CRM_JP_TriggerAbstract {
    
    //Field Schema Map
    private final static Map<String, Schema.SObjectField> BUSINESS_DAY_CALENDAR_FIELD_MAP = Schema.SObjectType.ASI_JP_CRM_Business_Day_Calendar__c.fields.getMap();
    
    private final static String SALES_ORDER_STATUS = 'Final';
    
    private Map<String, ASI_JP_CRM_Business_Day_Calendar__c> businessDayMap = retrieveBusinessDayList();
    
    public ASI_CRM_JP_SOAssignDate() {
        super('ASI_CRM_JP_SOAssignDate');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
      List<ASI_CRM_JP_Sales_Order__c> salesOrderList = filterSalesOrder((List<ASI_CRM_JP_Sales_Order__c>) sObjList, (Map<Id, ASI_CRM_JP_Sales_Order__c>) oldMap);
        
        for(ASI_CRM_JP_Sales_Order__c salesOrder : salesOrderList) {
            if(salesOrder.ASI_CRM_Route_Code__c == null || 
               String.isBlank(salesOrder.ASI_CRM_Freight_Code__c)) {
                salesOrder.addError(Label.ASI_CRM_JP_SO_FreightCodeRouteCodeNotFound);
                continue;
            }

            //Calculate Order Date
            //Default Order Date = Requested Date - Ship To Lead Time
            Date orderDate = salesOrder.ASI_CRM_Requested_Date__c.addDays(- Integer.valueOf(salesOrder.ASI_CRM_Route_Code__c));
            orderDate = calculateOrderDateWithShippingCompany(salesOrder, salesOrder.ASI_CRM_Freight_Code__c, orderDate);
            if(orderDate == null) return;
            orderDate = calculateOrderDateWithPR(salesOrder, salesOrder.ASI_CRM_Freight_Code__c, orderDate);
            if(orderDate == null) return;
            orderDate = calculateOrderDateToday(salesOrder, salesOrder.ASI_CRM_Freight_Code__c, orderDate);
            if(orderDate == null) return;

            //Calculate Requested Date
            Date requestedDate = calculateRequestedDate(salesOrder, salesOrder.ASI_CRM_Freight_Code__c, orderDate, Integer.valueOf(salesOrder.ASI_CRM_Route_Code__c));
            if(requestedDate == null) return;
            requestedDate = compareRequestedDate(salesOrder, salesOrder.ASI_CRM_Freight_Code__c, salesOrder.ASI_CRM_Requested_Date__c, requestedDate);
            if(requestedDate == null) return;

            //Assign new Order Date and Requested Date
            salesOrder.ASI_CRM_Order_Date__c = orderDate;
            salesOrder.ASI_CRM_Requested_Date__c = requestedDate;
        }
    }
    
    private List<ASI_CRM_JP_Sales_Order__c> filterSalesOrder(List<ASI_CRM_JP_Sales_Order__c> salesOrderList, Map<Id, ASI_CRM_JP_Sales_Order__c> salesOrderMap) {
        List<ASI_CRM_JP_Sales_Order__c> filteredSalesOrderList = new List<ASI_CRM_JP_Sales_Order__c>();
        for(ASI_CRM_JP_Sales_Order__c salesOrder : salesOrderList) {
            if(salesOrder.ASI_CRM_Status__c == SALES_ORDER_STATUS && 
               salesOrder.ASI_CRM_Status__c != salesOrderMap.get(salesOrder.Id).ASI_CRM_Status__c) {
              filteredSalesOrderList.add(salesOrder);
            }
        }
        return filteredSalesOrderList;
    }
    
    /***************
    Logic 1
    1. Check order date is shipping company business day
    2. if order date is not shipping company business day
    3. order date - 1 and check again
    ***************/
    private Date calculateOrderDateWithShippingCompany(ASI_CRM_JP_Sales_Order__c salesOrder, String shippingCompany, Date orderDate) {    
        ASI_JP_CRM_Business_Day_Calendar__c tempBusinessDay = businessDayMap.get(orderDate + '_' + shippingCompany);
        if(businessDayMap.containsKey(orderDate + '_' + shippingCompany) == false) {
            showError(salesOrder, shippingCompany, orderDate);
            return null;
        }

        if(tempBusinessDay.ASI_WS_Working__c == false) {
          orderDate = calculateOrderDateWithShippingCompany(salesOrder, shippingCompany, orderDate.addDays(-1));
        } 
        return orderDate;
    }
    
    /***************
    Logic 2
    1. Check order date is PR business day
    2. if order date is not PR business day
    3. order date - 1 and check again
    ***************/
    private Date calculateOrderDateWithPR(ASI_CRM_JP_Sales_Order__c salesOrder, String shippingCompany, Date orderDate) {
        ASI_JP_CRM_Business_Day_Calendar__c tempBusinessDay = businessDayMap.get(orderDate + '_' + shippingCompany);

        if(businessDayMap.containsKey(orderDate + '_' + shippingCompany) == false) {
            showError(salesOrder, shippingCompany, orderDate);
            return null;
        }

        if(tempBusinessDay.ASI_PR_Working__c == false) {
          orderDate = calculateOrderDateWithPR(salesOrder, shippingCompany, orderDate.addDays(-1));
        } 
        return orderDate;
    }
    
    /***************
    Logic 3
    1. Check order date is greater than today
    2. if order date is not greater than today
    3. order date + 1 and check again
    ***************/
    private Date calculateOrderDateToday(ASI_CRM_JP_Sales_Order__c salesOrder, String shippingCompany, Date orderDate) {
        if(orderDate < Date.today()) {
            orderDate = Date.today();
        }
        
        ASI_JP_CRM_Business_Day_Calendar__c tempBusinessDay = businessDayMap.get(orderDate + '_' + shippingCompany);

        if(businessDayMap.containsKey(orderDate + '_' + shippingCompany) == false) {
            showError(salesOrder, shippingCompany, orderDate);
            return null;
        }

        if(tempBusinessDay.ASI_PR_Working__c == false) {
          orderDate = calculateOrderDateToday(salesOrder, shippingCompany, orderDate.addDays(+1));
        } 
        return orderDate;
    }
    
    /***************
    Logic 4
    1. requested date =  order date + number of shipping lead time business day (by pass non business day) 
    ***************/
    private Date calculateRequestedDate(ASI_CRM_JP_Sales_Order__c salesOrder, String shippingCompany, Date orderDate, Integer leadTime) {
        while(leadTime != 0) {
            orderDate = orderDate.addDays(1);
            ASI_JP_CRM_Business_Day_Calendar__c tempBusinessDay = businessDayMap.get(orderDate + '_' + shippingCompany);

            if(businessDayMap.containsKey(orderDate + '_' + shippingCompany) == false) {
                showError(salesOrder, shippingCompany, orderDate);
                return null;
            }

            if(tempBusinessDay.ASI_WS_Working__c == true) {
                leadTime -= 1;
            }
        }
        return orderDate;
    }
    
    /***************
    Logic 5
    ***************/
    private Date compareRequestedDate(ASI_CRM_JP_Sales_Order__c salesOrder, String shippingCompany, Date originalRequestedDate, Date newRequestedDate) {
        if(originalRequestedDate > newRequestedDate) {
          ASI_JP_CRM_Business_Day_Calendar__c tempBusinessDay = businessDayMap.get(originalRequestedDate + '_' + shippingCompany);
            if(businessDayMap.containsKey(originalRequestedDate + '_' + shippingCompany) == false) {
                showError(salesOrder, shippingCompany, originalRequestedDate);
                return null;
            }
            if(tempBusinessDay.ASI_WS_Working__c == true) {
                return originalRequestedDate;
            }
        }
        return newRequestedDate;
    }
    
    private void showError(ASI_CRM_JP_Sales_Order__c salesOrder, String shippingCompany, Date currentDate) {
        String errorMsg = String.format(Label.ASI_CRM_JP_SO_BusinessDayNotFound, new String[] {currentDate.format(), shippingCompany});
        salesOrder.addError(errorMsg);
    }

    /***************
    Data Retrievement Function
    ***************/
    private Map<String, ASI_JP_CRM_Business_Day_Calendar__c> retrieveBusinessDayList() {
      String query = 'SELECT ' + genQueryField(BUSINESS_DAY_CALENDAR_FIELD_MAP) + 
                       ', RecordType.DeveloperName ' + 
                       'FROM ASI_JP_CRM_Business_Day_Calendar__c';
        
        Map<String, ASI_JP_CRM_Business_Day_Calendar__c> businessDayMap = new Map<String, ASI_JP_CRM_Business_Day_Calendar__c>();
        for(ASI_JP_CRM_Business_Day_Calendar__c businessDay : Database.query(query)) {
          businessDayMap.put(businessDay.ASI_Business_Day__c + '_' + businessDay.ASI_Shipping_Company__c, businessDay);
        }
        
        return businessDayMap;
    }
    
    /***************
    Tools Function
    ***************/
    public String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
      String queryField = '';
      for(String fields : fieldMap.keySet()) {
        queryField += fields + ',';
      }
      return queryField.subString(0, queryField.length() - 1);
    }
}