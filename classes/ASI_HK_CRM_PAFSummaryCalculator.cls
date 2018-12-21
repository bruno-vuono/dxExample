public without sharing class ASI_HK_CRM_PAFSummaryCalculator {
    
    private static final Set<String> RELEVANT_PAF_FIELDS = new Set<String>{
        'ASI_HK_CRM_Total_Investment_Value__c'
        , 'ASI_HK_CRM_Total_Investment__c'
        , 'ASI_HK_CRM_All_Sub_Brand_VFI_Threshold__c'
        , 'ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Local_Channel__c'
        , 'ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Channel__c'
    };
    private static final Set<String> RELEVANT_PAF_DETAIL_FIELDS = new Set<String>{
        'ASI_HK_CRM_Investment_Value__c'
        , 'RecordType.DeveloperName'
        , 'ASI_HK_CRM_SKU_Lookup__c'
        , 'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c'
        , 'ASI_HK_CRM_Target_Volume_Qty__c'
        , 'ASI_HK_CRM_Price__c'
        , 'ASI_CRM_HK_All_Product__c' //20160317, added by Leo
        , 'ASI_HK_CRM_Rebate_Disc_Percent__c' //20160318, added by Leo
        , 'ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c' //20160318, added by Leo
    };
    private static final Set<String> PAF_DETAIL_RT_FOC_SET = new Set<String> {
        ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FOC
        , ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FOC_BULK
    };
    private static final Set<String> PAF_DETAIL_RT_VARIABLE_SET = new Set<String>{
        ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FOC
        , ASI_HK_CRM_PreApprovalFormItemGenerator.RT_FOC_BULK
        , ASI_HK_CRM_PreApprovalFormItemGenerator.RT_VARIABLE
    };
    private static final String PAF_DETAIL_RT_NO_MECHANIC = ASI_HK_CRM_PreApprovalFormItemGenerator.RT_NO_MECHANIC;
    private static final Integer PAF_INV_AMT_DECIMAL_PLACE = 2;
    private static final Integer PAF_INV_PERCENT_DECIMAL_PLACE = 2;
    private static final Integer SB_BENCHMARK_DECIMAL_PLACE = 1;
    private static final String RTDEVNAME_SB = ASI_HK_CRM_SubBrandGenerator.RT_Default;
    private static Map<ID, Decimal> sbIdToBMMap;
    
    public ASI_HK_CRM_PAFSummaryCalculator() {
        
    }
    
    public List<ASI_HK_CRM_Pre_Approval_Form__c> getRefreshedPAF(Set<ID> pafIdSet) {
        List<ASI_HK_CRM_Pre_Approval_Form__c> updatedPafList = new List<ASI_HK_CRM_Pre_Approval_Form__c>();
        if (pafIdSet != null && pafIdSet.size() > 0) {
            String childQueryStr = ASI_HK_CRM_CommonUtils.genQueryString(RELEVANT_PAF_DETAIL_FIELDS, 'Pre_Approval_Form_Items_Link_To_PAF_Form__r');
            Set<String> queryFields = RELEVANT_PAF_FIELDS.clone();
            queryFields.add('(' + childQueryStr + ')');
            String queryStr = ASI_HK_CRM_CommonUtils.genQueryString(queryFields, 'ASI_HK_CRM_Pre_Approval_Form__c', 'Id IN :pafIdSet');
            List<ASI_HK_CRM_Pre_Approval_Form__c> pafList = (List<ASI_HK_CRM_Pre_Approval_Form__c>)database.query(queryStr);
            initCheckExceedInvestAmtSB(pafList);
            for (ASI_HK_CRM_Pre_Approval_Form__c paf : pafList) {
                Boolean hasUpdate = false;
                if (calculateTotalInvestmentAmount(paf)) hasUpdate = true;
                if (calculateTotalSkuInvestmentValue(paf)) hasUpdate = true;
                //if (calculateTotalInvestmentPercent(paf)) hasUpdate = true;
                if (checkExceedInvestmentAmountSubBrand(paf)) hasUpdate = true;
                if (hasUpdate)
                    updatedPafList.add(paf);
            }
        }
        return updatedPafList;
    }
    
    private static Boolean calculateTotalInvestmentAmount(ASI_HK_CRM_Pre_Approval_Form__c paf) {
        Decimal pafTotInvAmt = 0;
        //Decimal totalQty = 0; //20160318, added by Leo
        //Map<Id, Decimal> allPrdtPercentMap = new Map<Id, Decimal>(); //20160318, added by Leo
        //Map<Id, Decimal> allPrdtPerBtMap = new Map<Id, Decimal>(); //20160318, added by Leo
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafDetails = paf.Pre_Approval_Form_Items_Link_To_PAF_Form__r;
        if (pafDetails != null && pafDetails.size() > 0) {
            Map<String, Decimal> skuIdAndRTToMaxFOCInvAmt = new Map<String, Decimal>();
            for (ASI_HK_CRM_Pre_Approval_Form_Item__c pafDetail : pafDetails) {
                Decimal invAmt = pafDetail.ASI_HK_CRM_Investment_Value__c;
                if (invAmt != null) {
                    //if(!pafDetail.ASI_CRM_HK_All_Product__c) //20160321, added by Leo
                    	//totalQty += pafDetail.ASI_HK_CRM_Target_Volume_Qty__c; //20160318, added by Leo
                    if (PAF_DETAIL_RT_FOC_SET.contains(pafDetail.RecordType.DeveloperName)) {
                        ID skuId = pafDetail.ASI_HK_CRM_SKU_Lookup__c;
                        String key = skuId + '_' + pafDetail.RecordType.DeveloperName;
                        Decimal maxInvAmt = skuIdAndRTToMaxFOCInvAmt.get(key);
                        if (maxInvAmt == null || invAmt > maxInvAmt) {
                            skuIdAndRTToMaxFOCInvAmt.put(key, invAmt);
                        }
                    } else {
                        pafTotInvAmt += invAmt;
                    }//end else
                }//end if: invAmt !=null
                //20160318, added by Leo
                /*else
                {
                    if(pafDetail.ASI_HK_CRM_Rebate_Disc_Percent__c != null)
                    {
                        allPrdtPercentMap.put(pafDetail.Id, pafDetail.ASI_HK_CRM_Rebate_Disc_Percent__c/100);
                    }//end if
                    else if(pafDetail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c != null)
                    {
                        allPrdtPerBtMap.put(pafDetail.Id, pafDetail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c);
                    }//end if
                }//end else*/
                //20160318, added by Leo
            }
            if (skuIdAndRTToMaxFOCInvAmt.size() > 0) {
                for (Decimal focMaxInvAmt : skuIdAndRTToMaxFOCInvAmt.values()) {
                    pafTotInvAmt += focMaxInvAmt;
                }
            }
        }//end for
        
        //20160318, added by Leo
        /*Decimal total = pafTotInvAmt;
        if (allPrdtPercentMap.size() > 0)
        {
            for (Decimal percent : allPrdtPercentMap.values()) {
                pafTotInvAmt = pafTotInvAmt + (total*percent);
            }//end for
        }//end if
        if (allPrdtPerBtMap.size() > 0) {
            for (Decimal perBt : allPrdtPerBtMap.values()) {
                pafTotInvAmt = pafTotInvAmt + (totalQty*perBt);
            }//end for
        }//end if*/
        //20160318, added by Leo
        
        pafTotInvAmt = pafTotInvAmt.setScale(PAF_INV_AMT_DECIMAL_PLACE);
        if (pafTotInvAmt != paf.ASI_HK_CRM_Total_Investment_Value__c) {
            paf.ASI_HK_CRM_Total_Investment_Value__c = pafTotInvAmt;
            return true;
        }
        return false;
    }
    
    private static Boolean calculateTotalSkuInvestmentValue(ASI_HK_CRM_Pre_Approval_Form__c paf) {
        //Decimal sumOfRelevantValue = 0;
        Decimal sumOfRelevantVolume = 0;
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafDetails = paf.Pre_Approval_Form_Items_Link_To_PAF_Form__r;
        if (pafDetails != null && pafDetails.size() > 0) {
            Map<String, Decimal> skuIdAndRTToMaxVolume = new Map<String, Decimal>();
System.debug('detail item size()='+pafDetails.size());            
            
            for (ASI_HK_CRM_Pre_Approval_Form_Item__c pafDetail : pafDetails) {
//                if (pafDetail.RecordType.DeveloperName != PAF_DETAIL_RT_NO_MECHANIC) {
                if(!pafDetail.ASI_CRM_HK_All_Product__c){ //20160317,added by Leo
                    Decimal volume = pafDetail.ASI_HK_CRM_Target_Volume_Qty__c * pafDetail.ASI_HK_CRM_Price__c;
                    ID skuId = pafDetail.ASI_HK_CRM_SKU_Lookup__c;
                    String key = skuId;
                    Decimal maxVolume = skuIdAndRTToMaxVolume.get(key);
                    if (maxVolume == null || volume > maxVolume) {
                        skuIdAndRTToMaxVolume.put(key, volume);
System.debug('detail item ='+pafDetail.ASI_HK_CRM_SKU_Lookup__c);
                    }
 //               }
                }//end if //20160317,added by Leo
            }
            if (skuIdAndRTToMaxVolume.size() > 0) {
                for (Decimal maxVolume : skuIdAndRTToMaxVolume.values()) {
                    sumOfRelevantVolume += maxVolume;                    
                }
            }
        }
        paf.ASI_HK_CRM_SYS_Total_SKU_Value_1__c = sumOfRelevantVolume;
        return true;
    }
    
    /*private static Boolean calculateTotalInvestmentPercent(ASI_HK_CRM_Pre_Approval_Form__c paf) {
        Decimal sumOfRelevantVolume = 0;
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafDetails = paf.Pre_Approval_Form_Items_Link_To_PAF_Form__r;
        if (pafDetails != null && pafDetails.size() > 0) {
            Map<String, Decimal> skuIdAndRTToMaxVolume = new Map<String, Decimal>();
            for (ASI_HK_CRM_Pre_Approval_Form_Item__c pafDetail : pafDetails) {
                if (pafDetail.RecordType.DeveloperName != PAF_DETAIL_RT_NO_MECHANIC) {
                    Decimal volume = pafDetail.ASI_HK_CRM_Target_Volume_Qty__c * pafDetail.ASI_HK_CRM_Price__c;
                    if (PAF_DETAIL_RT_FOC_SET.contains(pafDetail.RecordType.DeveloperName)) {
                        ID skuId = pafDetail.ASI_HK_CRM_SKU_Lookup__c;
                        String key = skuId + '_' + pafDetail.RecordType.DeveloperName;
                        Decimal maxVolume = skuIdAndRTToMaxVolume.get(key);
                        if (maxVolume == null || volume > maxVolume) {
                            skuIdAndRTToMaxVolume.put(key, volume);
                        }
                    } else {
                        sumOfRelevantVolume += volume;
                    }
                }
            }
            if (skuIdAndRTToMaxVolume.size() > 0) {
                for (Decimal maxVolume : skuIdAndRTToMaxVolume.values()) {
                    sumOfRelevantVolume += maxVolume;
                }
            }
        }
        Decimal percent = sumOfRelevantVolume == 0 ? 0 : paf.ASI_HK_CRM_Total_Investment_Value__c / sumOfRelevantVolume * 100;
        percent = percent.setScale(PAF_INV_PERCENT_DECIMAL_PLACE);
        if (percent != paf.ASI_HK_CRM_Total_Investment__c) {
            paf.ASI_HK_CRM_Total_Investment__c = percent;
            return true;
        }
        return false;
    }*/
    
    private static void initCheckExceedInvestAmtSB(List<ASI_HK_CRM_Pre_Approval_Form__c> pafList) {
        sbIdToBMMap = new Map<ID, Decimal>();
        Set<String> localChannelSet = new Set<String>();
        // Find out all relevant channels
        Set<String> channelSet = new Set<String>();
        for (ASI_HK_CRM_Pre_Approval_Form__c paf : pafList) {
            if (String.isBlank(paf.ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Local_Channel__c)) {
                if (!String.isBlank(paf.ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Channel__c))
                    channelSet.add(paf.ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Channel__c);
            } else {
                localChannelSet.add(paf.ASI_HK_CRM_PAF_Customer__r.ASI_HK_CRM_Local_Channel__c);
            }
        }
        // Query the local channels of those channels
        List<ASI_HK_CRM_Channel_Local_Channel_Map__c> channelMapObjList = 
            channelSet.size() == 0
            ? new List<ASI_HK_CRM_Channel_Local_Channel_Map__c>()
            : [SELECT Id, ASI_HK_CRM_Local_Channel__c FROM ASI_HK_CRM_Channel_Local_Channel_Map__c WHERE ASI_HK_CRM_Channel__c IN :channelSet];
        
        for (ASI_HK_CRM_Channel_Local_Channel_Map__c channelMapObj : channelMapObjList) {
            if (!String.isBlank(channelMapObj.ASI_HK_CRM_Local_Channel__c))
                localChannelSet.add(channelMapObj.ASI_HK_CRM_Local_Channel__c);
        }
        // Find out the banchmark of those local channels
        List<ASI_HK_CRM_SubBrand_Investment_Benchmark__c> sbInvestBMs = localChannelSet.size() == 0
            ? new List<ASI_HK_CRM_SubBrand_Investment_Benchmark__c>()
            : [SELECT Id, ASI_HK_CRM_Sub_Brand__c, ASI_HK_CRM_Benchmark_Percent__c, ASI_HK_CRM_Local_Channel__c
                FROM ASI_HK_CRM_SubBrand_Investment_Benchmark__c
                WHERE ASI_HK_CRM_Local_Channel__c IN :localChannelSet
            ];
        for (ASI_HK_CRM_SubBrand_Investment_Benchmark__c sbInvestBM : sbInvestBMs) {
            if (sbInvestBM.ASI_HK_CRM_Sub_Brand__c == null) {
                throw new ASI_HK_CRM_CustomException(String.format(
                    'No Sub-Brand in PAF Sub-Brand Investment Benchmark record. (ID: {0}; Local Channel: {1})'
                    , new String[] {sbInvestBM.Id, sbInvestBM.ASI_HK_CRM_Local_Channel__c}
                ));
            }
            sbIdToBMMap.put(sbInvestBM.ASI_HK_CRM_Sub_Brand__c, sbInvestBM.ASI_HK_CRM_Benchmark_Percent__c);
        }
    }
    
    private static Boolean checkExceedInvestmentAmountSubBrand(ASI_HK_CRM_Pre_Approval_Form__c paf) {
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafDetails = paf.Pre_Approval_Form_Items_Link_To_PAF_Form__r;
        if (pafDetails != null && pafDetails.size() > 0) {
            Map<ID, List<Decimal>> sbIdToAmtsMap = new Map<ID, List<Decimal>>();
            for (ASI_HK_CRM_Pre_Approval_Form_Item__c pafDetail : pafDetails) {
                if (PAF_DETAIL_RT_VARIABLE_SET.contains(pafDetail.RecordType.DeveloperName) && pafDetail.ASI_HK_CRM_Investment_Value__c != null
                    && pafDetail.ASI_HK_CRM_SKU_Lookup__c != null && pafDetail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c != null 
                    && !pafDetail.ASI_CRM_HK_All_Product__c) { //20160321, added by Leo
                    ID sbId = pafDetail.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c;
                    List<Decimal> amts = sbIdToAmtsMap.get(sbId);
                    if (amts == null) {
                        amts = new Decimal[] {0, 0};
                        sbIdToAmtsMap.put(sbId, amts);
                    }
                    amts[0] += pafDetail.ASI_HK_CRM_Investment_Value__c;
                    amts[1] += pafDetail.ASI_HK_CRM_Target_Volume_Qty__c * pafDetail.ASI_HK_CRM_Price__c;
                }
            }
            Boolean hasExceed = false;
            if (sbIdToAmtsMap.size() > 0) {
                Set<ID> sbIds = sbIdToAmtsMap.keySet();
                for (ID sbId : sbIds) {
                    List<Decimal> amts = sbIdToAmtsMap.get(sbId);
                    Decimal bm = sbIdToBMMap.get(sbId);
                    if (bm != null) {
                        Decimal invPercent = amts[1] == 0 ? 0 : amts[0] / amts[1] * 100;
                        invPercent = invPercent.setScale(SB_BENCHMARK_DECIMAL_PLACE);
                        if (invPercent > bm) {
                            hasExceed = true;
                            break;
                        }
                    }
                }
            }
            if (hasExceed != paf.ASI_HK_CRM_All_Sub_Brand_VFI_Threshold__c) {
                paf.ASI_HK_CRM_All_Sub_Brand_VFI_Threshold__c = hasExceed;
                return true;
            }
        }
        return false;
    }
}