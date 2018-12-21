/*********************************************************************************
 * Name: ASI_CRM_VN_CapsuleCS_addPaymentTime
 * Description: 
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    ----------------------------------------
 * 23/11/2017       Kevin Choi             Created          
***********************************************************************************/
public class ASI_CRM_VN_CapsuleCS_addPaymentTime{
    public ASI_CRM_VN_CapsuleCS_addPaymentTime(){

    }

    public void executeTrigger(List<sObject> newList, Map<Id, sObject> oldMap) {
        system.debug('Execute ASI_CRM_VN_CapsuleCS_addPaymentTime()');
        List<ASI_GiftBox_Request_Header__c> requestList = (List<ASI_GiftBox_Request_Header__c>) newList;
        Map<Id, ASI_GiftBox_Request_Header__c> requestOldMap = (Map<Id, ASI_GiftBox_Request_Header__c>)oldMap;

        Set<Id> contractIdSet = new Set<Id>();

        for (ASI_GiftBox_Request_Header__c request : requestList){
            contractIdSet.add(request.ASI_CRM_VN_Contract__c);
        }
        Map<Id,ASI_CRM_VN_Contract__c> contractIdMap = new Map<Id,ASI_CRM_VN_Contract__c>([select ASI_CRM_Outlet_WS__c, ASI_CRM_Outlet_Address__c,
                                                                                           ASI_CRM_Outlet_Type__c, ASI_CRM_Type__c, ASI_CRM_Start_Date__c,
                                                                                           ASI_CRM_End_Date__c, ASI_CRM_No_Of_Months__c, ASI_CRM_Outlet_Image__c,
                                                                                           ASI_CRM_Spirit_Volume_Potential__c, ASI_CRM_Wine_Volume_Potential__c, 
                                                                                           ASI_CRM_Outlet_Role__c ,ASI_CRM_Outlet_Region__c
                                                                                           from ASI_CRM_VN_Contract__c
                                                                                           where Id IN: contractIdSet]);

        Map<Id, AggregateResult> requestHeaderCountResult = new  Map<Id, AggregateResult>([select ASI_CRM_VN_Contract__c Id, count(Id) total 
                                                                                           from ASI_GiftBox_Request_Header__c
                                                                                           where ASI_CRM_VN_Contract__c IN: contractIdSet GROUP BY ASI_CRM_VN_Contract__c]);

        system.debug('requestHeaderCountResult:'+requestHeaderCountResult);

        for (ASI_GiftBox_Request_Header__c request : requestList){
            request = copyDataFromContract(request, contractIdMap.get(request.ASI_CRM_VN_Contract__c));

            if (requestHeaderCountResult.get(request.ASI_CRM_VN_Contract__c) != null){
                Decimal paymentTime = (Decimal) (requestHeaderCountResult.get(request.ASI_CRM_VN_Contract__c)).get('total');
                request.ASI_CRM_Payment_Time__c = paymentTime + 1; 
            }else {
                request.ASI_CRM_Payment_Time__c = 1; 
            }

            if (String.isBlank(String.Valueof(request.ASI_CRM_VN_Amount__c)))
                request.ASI_CRM_VN_Amount__c = 0;               
        }
    }

    private ASI_GiftBox_Request_Header__c copyDataFromContract(ASI_GiftBox_Request_Header__c request, ASI_CRM_VN_Contract__c contract) {
        request.ASI_CRM_Customer__c                   = contract.ASI_CRM_Outlet_WS__c;
        request.ASI_GiftBox_Delivery_Address__c       = contract.ASI_CRM_Outlet_Address__c;
        request.ASI_CRM_VN_Channel__c                 = contract.ASI_CRM_Outlet_Type__c;
        request.ASI_CRM_VN_Contract_Type__c           = contract.ASI_CRM_Type__c;
        request.ASI_CRM_VN_Contract_Start_Date__c     = contract.ASI_CRM_Start_Date__c;
        request.ASI_CRM_VN_Contract_Ending_Date__c    = contract.ASI_CRM_End_Date__c;
        request.ASI_CRM_VN_Contract_Duration__c       = contract.ASI_CRM_No_Of_Months__c;
        request.ASI_CRM_VN_Image_Level__c             = contract.ASI_CRM_Outlet_Image__c;
        request.ASI_CRM_VN_Spirit_Volume_Potential__c = contract.ASI_CRM_Spirit_Volume_Potential__c;
        request.ASI_CRM_VN_Wine_Volume_Potential__c   = contract.ASI_CRM_Wine_Volume_Potential__c;
        request.ASI_CRM_VN_Outlet_Role__c             = contract.ASI_CRM_Outlet_Role__c;
        request.ASI_GiftBox_Region__c                 = contract.ASI_CRM_Outlet_Region__c;
        return request;
    }
}