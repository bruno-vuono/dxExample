public with sharing class ASI_HK_CRM_PAFItemInvestValueCalculator extends ASI_HK_CRM_TriggerAbstract {
    
    private static String[] REQUIRED_FIELDS = new String[] {
        'ASI_HK_CRM_SKU_Lookup__c'
        , 'ASI_HK_CRM_Target_Volume_Qty__c'
        , 'ASI_HK_CRM_Price__c'
    };
    private static Map<String, Schema.SObjectField> FIELD_DESCRIBE_MAP;
    private static ID RTID_FOC = ASI_HK_CRM_PreApprovalFormItemGenerator.getRecordTypeByDevName(ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FOC).Id;
    private static ID RTID_FOC_BULK = ASI_HK_CRM_PreApprovalFormItemGenerator.getRecordTypeByDevName(ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FOC_BULK).Id;
    private static ID RTID_VARIABLE = ASI_HK_CRM_PreApprovalFormItemGenerator.getRecordTypeByDevName(ASI_HK_CRM_PreApprovalFormItemGenerator.RT_VARIABLE).Id;
    private static ID RTID_FIXED = ASI_HK_CRM_PreApprovalFormItemGenerator.getRecordTypeByDevName(ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FIXED).Id;
    private static final String FIELD_NAME_FOC_BUY = 'ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_{0}__c';
    private static final String FIELD_NAME_FOC_FREE = 'ASI_HK_CRM_FOC_Free_Bottle_Option_{0}__c';
    private static final ASI_HK_CRM_ThresholdValues__c thresholdValueSetting = ASI_HK_CRM_ThresholdValues__c.getOrgDefaults();
    private static Map<id,Boolean> skuCheckMap = new Map<id,Boolean>(); //20160317, added by Leo
    //private static Map<Id,ASI_HK_CRM_Pre_Approval_Form_Item__c> allPrdtMap = new Map<Id,ASI_HK_CRM_Pre_Approval_Form_Item__c>(); //20160321, added by Leo
    //private static Decimal totalQty = 0; //20160321, added by Leo
    //private static Decimal totalInvest = 0; //20160321, added by Leo
    //private static Set<Id> lineItemSet = new Set<Id>(); //20160331, added by Leo
    
    public ASI_HK_CRM_PAFItemInvestValueCalculator() {
        super('ASI_HK_CRM_PAFItemInvestValueCalculator');
    }
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        if ((tAction == TriggerAction.BEFORE_INSERT || tAction == TriggerAction.BEFORE_UPDATE)
            && !isBypassByCurrentUser()) {
                List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafItemList = (List<ASI_HK_CRM_Pre_Approval_Form_Item__c>)sObjList;
                //Map<Id,ASI_HK_CRM_Pre_Approval_Form_Item__c> updateLines = new Map<Id,ASI_HK_CRM_Pre_Approval_Form_Item__c>(); //20160322, added by Leo
                //Set<Id> existingSet = new Set<Id>();
                for (ASI_HK_CRM_Pre_Approval_Form_Item__c pafItem : pafItemList) {
                    try {
                        //existingSet.add(pafItem.Id);
                        validateLineItem(pafItem);
                        //if(tAction == TriggerAction.BEFORE_UPDATE) //20160322, added by Leo
                        //{
                        if(!pafItem.ASI_CRM_HK_All_Product__c)
                            calculateInvestmentValue(pafItem);
                            //lineItemSet.add(pafItem.ASI_HK_CRM_SKU_Lookup__c); //20160331, added by Leo
                        //}
                        /*//20160321, added by Leo
                        if(pafItem.ASI_CRM_HK_All_Product__c)
                        {
                            allPrdtMap.put(pafItem.Id, pafItem);
                        }
                        //20160321, added by Leo*/
                    } catch (ASI_HK_CRM_CustomException e) {
                        pafItem.addError(e.getMessage());
                    } catch (Exception e) {
                        pafItem.addError(e);
                    }
                }
                
                /*//20160321, added by Leo
                if(allPrdtMap.size() > 0)
                {
                    for(ASI_HK_CRM_Pre_Approval_Form_Item__c line: allPrdtMap.values())
                    {
                        if(line.ASI_HK_CRM_Rebate_Disc_Percent__c != null)
                        {
                            line.ASI_HK_CRM_Investment_Value__c = totalInvest * line.ASI_HK_CRM_Rebate_Disc_Percent__c /100;
                        }
                        else if(line.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c != null)
                        {
                            line.ASI_HK_CRM_Investment_Value__c = totalQty * line.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                        }
                        if(tAction == TriggerAction.BEFORE_UPDATE && !existingSet.contains(line.Id))
                        	updateLines.put(line.Id, line);
                    }
                }
                if(updateLines.size()>0)
                    update updateLines.values();*/
            }//end if
    }
    
    private static void calculateInvestmentValue(ASI_HK_CRM_Pre_Approval_Form_Item__c lineItem) {
        lineItem.ASI_HK_CRM_Investment_Value__c = null;
        if (lineItem.RecordTypeId != null && !lineItem.ASI_CRM_HK_All_Product__c) { //20160318, edited by Leo, add bypass all product
            ID rtId = lineItem.RecordTypeId;
            Decimal finalInvAmt = 0;
            if (RTID_FOC == rtId || RTID_FOC_BULK == rtId) {
                Decimal maxInvAmt = null;
                for (Integer i = 1; i <= ASI_HK_CRM_PreApprovalFormItemGenerator.MAX_NUM_OF_FOC_PAIR; i++) {
                    Decimal buyCount = (Decimal)lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.buyField(i));
                    Decimal freeCount = (Decimal)lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.freeField(i));
                    if (buyCount != null && freeCount != null) {                        
                        Decimal curInvAmt = intNearestToZero(lineItem.ASI_HK_CRM_Target_Volume_Qty__c / buyCount) * freeCount * lineItem.ASI_HK_CRM_Price__c;
                        if (maxInvAmt == null || curInvAmt > maxInvAmt)
                            maxInvAmt = curInvAmt;                        
                    }
                }
                //20160311, added by Leo
                if(lineItem.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c != null && lineItem.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c != null)
                {
                    Decimal temp1 = intNearestToZero(lineItem.ASI_HK_CRM_Target_Volume_Qty__c / lineItem.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c) * lineItem.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c * lineItem.ASI_HK_CRM_Price__c;
                    Integer temp2 = Math.mod(Integer.valueOf(lineItem.ASI_HK_CRM_Target_Volume_Qty__c),Integer.valueOf(lineItem.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c));
                    if(temp2 > 0)
                    {
                        Decimal temp3 = intNearestToZero(temp2 / lineItem.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c) * lineItem.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c * lineItem.ASI_HK_CRM_Price__c;
                        finalInvAmt = temp1 + temp3;
                        //if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c)) //20160331, added by Leo
                        //{
                        //    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c); //20160411, edited by Leo //20160321, added by Leo
                        //	totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160321, added by Leo
                        //}
                        	
                    }
                    else
                    {
                        finalInvAmt = maxInvAmt;
                        //if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c)) //20160331, added by Leo
                        //{
                        //    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c); //20160411, edited by Leo //20160321, added by Leo
                        //    totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160321, added by Leo
                        //}
                    }
                }//end if
                else //20160311, added by Leo
                {
                    finalInvAmt = maxInvAmt;
                    //if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c)) //20160331, added by Leo
                    //{
                    //    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c); //20160411, edited by Leo //20160321, added by Leo
                    //    totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160321, added by Leo
                    //}
                }
                Boolean isValid = true;
            } else if (RTID_VARIABLE == rtId) {
                if (lineItem.ASI_HK_CRM_Rebate_Disc_Percent__c != null) {
                    finalInvAmt = lineItem.ASI_HK_CRM_Target_Volume_Qty__c * lineItem.ASI_HK_CRM_Price__c * (lineItem.ASI_HK_CRM_Rebate_Disc_Percent__c / 100);
                    //if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c)) //20160331, added by Leo
                    //{
                    //    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c); //20160411, edited by Leo //20160321, added by Leo
                    //    totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160321, added by Leo
                    //}
                } else if (lineItem.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c != null) {
                    finalInvAmt = lineItem.ASI_HK_CRM_Target_Volume_Qty__c * lineItem.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
                    //if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c)) //20160331, added by Leo
                    //{
                    //    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c); //20160411, edited by Leo //20160321, added by Leo
                    //    totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160321, added by Leo
                    //}
                }
            } else if (RTID_FIXED == rtId) {
                if (lineItem.ASI_HK_CRM_Fixed_Amount__c != null) {
                    finalInvAmt = lineItem.ASI_HK_CRM_Fixed_Amount__c;
                    //if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c)) //20160331, added by Leo
                    //{
                    //    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c); //20160411, edited by Leo //20160321, added by Leo
                    //    totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160321, added by Leo
                    //}
                }
            }
            /*else //for no Mechanic item
            { //20160331, added by Leo
                if(!lineItemSet.contains(lineItem.ASI_HK_CRM_SKU_Lookup__c))
                {
                    totalQty += lineItem.ASI_HK_CRM_Target_Volume_Qty__c; //20160331, added by Leo
                    totalInvest += (lineItem.ASI_HK_CRM_Target_Volume_Qty__c*lineItem.ASI_HK_CRM_Price__c);
                }
            } //20160331, added by Leo*/
            lineItem.ASI_HK_CRM_Investment_Value__c = finalInvAmt;
        }
    }
    
    private static void validateLineItem(ASI_HK_CRM_Pre_Approval_Form_Item__c lineItem) {
        for (String requiredField : REQUIRED_FIELDS) {
            if (!isNotEmptyForField(lineItem, requiredField) && !lineItem.ASI_CRM_HK_All_Product__c) { //20160317, edited by Leo, add codition check sku
                if (FIELD_DESCRIBE_MAP == null)
                    FIELD_DESCRIBE_MAP = Schema.SObjectType.ASI_HK_CRM_Pre_Approval_Form_Item__c.fields.getMap();
                Schema.SObjectField f = FIELD_DESCRIBE_MAP.get(requiredField);
                String fieldLabel = f != null ? f.getDescribe().getLabel() : '[Unknown Field]';
                throw new ASI_HK_CRM_CustomException(String.format('{0} cannot be empty', new String[] {fieldLabel}));
            }
        }
        if (lineItem.RecordTypeId != null) {
            ID rtId = lineItem.RecordTypeId;
            if (RTID_FOC == rtId || RTID_FOC_BULK == rtId) {
                Boolean isValid = true;
                if (lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.buyField(1)) == null || lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.freeField(1)) == null)
                    isValid = false;
                else {
                    for (Integer i = 2; i <= ASI_HK_CRM_PreApprovalFormItemGenerator.MAX_NUM_OF_FOC_PAIR; i++) {
                        if ((lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.buyField(i)) == null) != (lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.freeField(i)) == null)) {
                            isValid = false;
                            break;
                        }
                    }
                }
                if (!isValid) {
                    throw new ASI_HK_CRM_CustomException('Invalid FOC inputs');
                }
                if (RTID_FOC_BULK == rtId) {
                    if (thresholdValueSetting != null && thresholdValueSetting.ASI_HK_CRM_PAF_FOC_Bulk_Min_Buy__c != null) {
                        for (Integer i = 1; i <= ASI_HK_CRM_PreApprovalFormItemGenerator.MAX_NUM_OF_FOC_PAIR; i++) {
                            Decimal buyValue = (Decimal)lineItem.get(ASI_HK_CRM_PreApprovalFormItemGenerator.buyField(i));
                            if (buyValue != null && buyValue < thresholdValueSetting.ASI_HK_CRM_PAF_FOC_Bulk_Min_Buy__c)
                                throw new ASI_HK_CRM_CustomException(String.format('FOC Bulk requires at least {0} buy bottles', new String[] {String.valueOf(thresholdValueSetting.ASI_HK_CRM_PAF_FOC_Bulk_Min_Buy__c)}));
                        }
                    }
                }
            } else if (RTID_VARIABLE == rtId) {
                if ((lineItem.ASI_HK_CRM_Rebate_Disc_Percent__c == null) == (lineItem.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c == null)) {
                    throw new ASI_HK_CRM_CustomException('Invalid variable amount inputs');
                }
            } else if (RTID_FIXED == rtId) {
                if (lineItem.ASI_HK_CRM_Fixed_Amount__c == null) {
                    throw new ASI_HK_CRM_CustomException('Fixed amount is missing');
                }
            }
        }
    }
    private static Boolean isNotEmptyForField(sObject sObj, String field) {
        Object val = sObj.get(field);
        return val != null
            && !(val instanceof String && ((String)val).trim() == '');
    }
    private static String buyField(Integer index) { return String.format(FIELD_NAME_FOC_BUY, new String[] {String.valueOf(index)}); }
    private static String freeField(Integer index) { return String.format(FIELD_NAME_FOC_FREE, new String[] {String.valueOf(index)}); }
    
    //Return the positive integer nearest to zero
    private static Integer intNearestToZero(Decimal dec) {
        if (dec == null) return null;
        Integer result = Math.floor(Math.abs(dec)).intValue();
        if (dec < 0) result *= -1;
        return result;
    }
    
    public static void setRequiredFields(){
        REQUIRED_FIELDS.add('Test1');
    }
    
    public static void setField(){
        String temp1 = buyField(1);
        String temp2 = freeField(1);
    }
    
}