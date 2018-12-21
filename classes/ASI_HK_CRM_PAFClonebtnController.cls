public without sharing class ASI_HK_CRM_PAFClonebtnController {
    
    public Id pafId { get; set; }

    public ASI_HK_CRM_PAFClonebtnController (ApexPages.StandardController stdCon) {
        
        ASI_HK_CRM_Pre_Approval_Form__c paf = new ASI_HK_CRM_Pre_Approval_Form__c();        
    
    }
    
    public PageReference clonePAF(){
        pafId = apexpages.currentPage().getParameters().get('id');        
        ASI_HK_CRM_Pre_Approval_Form__c newPaf = new ASI_HK_CRM_Pre_Approval_Form__c();
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> pafNewDetailList = new List<ASI_HK_CRM_Pre_Approval_Form_Item__c>();
        List<ASI_CRM_HK_Pre_Approval_Form_Customer__c> pafcNewDetailList = new List<ASI_CRM_HK_Pre_Approval_Form_Customer__c>();
        ASI_HK_CRM_Pre_Approval_Form_Item__c pafDetailTemp;
         
        ASI_HK_CRM_Pre_Approval_Form__c oldPaf = [select 
        ASI_HK_CRM_Adjusted_End_Date__c 
        , ASI_HK_CRM_Adjusted_Start_Date__c
        , ASI_HK_CRM_PAF_All_TC_Confirm_w_Cust__c
        , ASI_HK_CRM_External_ID__c
        , ASI_HK_CRM_Benchmark__c
        , ASI_HK_CRM_Benchmark_Investment_Amount__c
        , ASI_HK_CRM_PAF_Brand_Owner__c
        , ASI_HK_CRM_Conditions_of_Payment__c
        , ASI_HK_CRM_Contract_Details__c
        , ASI_HK_CRM_PAF_Contract_Requirement__c
        , ASI_HK_CRM_PAF_Customer__c
        , ASI_HK_CRM_PAF_End_Date__c
        , ASI_HK_CRM_Error_Message__c
        , ASI_HK_CRM_ExceedTshInvestmentPercent__c
        , ASI_HK_CRM_ExceedTshInvestmentAmt__c
        , ASI_HK_CRM_PAF_Nature_of_Promotion__c
        , ASI_HK_CRM_PAF_No_of_Months__c
        , ASI_HK_CRM_Other_Comments__c
        , ASI_HK_CRM_PAF_Raised_Date__c
        , ASI_HK_CRM_PAF_Start_Date__c
        , ASI_HK_CRM_PAF_Status__c
        , ASI_HK_CRM_SYS_Different_Duration__c
        , ASI_HK_CRM_SYS_Fiscal_Year__c
        , ASI_HK_CRM_SYS_Has_MKT_Investment_Type__c 
        , ASI_HK_CRM_SYS_Sales_Director_Approver__c
        , ASI_HK_CRM_SYS_Start_Date_Difference__c
        , ASI_HK_CRM_SYS_Supervisor__c
        , ASI_HK_CRM_Total_Investment__c
        , ASI_HK_CRM_Total_Investment_Value__c
        , ASI_HK_CRM_SYS_Total_SKU_Value_1__c
        , ASI_HK_CRM_PAF_Version_No__c
        , ASI_HK_CRM_All_Sub_Brand_VFI_Threshold__c
        , ASI_HK_CRM_PAF_Volume_Commitment__c
        , CurrencyIsoCode
        , ASI_CRM_Promotion_Category__c
        , ASI_CRM_HK_Is_Channel_PAF__c,
        recordTypeID
        //, ASI_HK_CRM_Pre_Approval_Form_Item__r
        from ASI_HK_CRM_Pre_Approval_Form__c where id =: pafId];
        
        //Assign values from oldPaf to new Paf
        //newPaf.ASI_HK_CRM_Adjusted_End_Date__c = oldPaf.ASI_HK_CRM_Adjusted_End_Date__c;
        //newPaf.ASI_HK_CRM_Adjusted_Start_Date__c = oldPaf.ASI_HK_CRM_Adjusted_Start_Date__c;
        //newPaf.ASI_HK_CRM_Adjusted_End_Date__c = oldPaf.ASI_HK_CRM_PAF_End_Date__c; //20160704, edited by Leo //20180220, edited by Arthur
        //newPaf.ASI_HK_CRM_Adjusted_Start_Date__c = oldPaf.ASI_HK_CRM_PAF_Start_Date__c; //20160704, edited by Leo //20180220, edited by Arthur
	
        newPaf.ASI_HK_CRM_PAF_All_TC_Confirm_w_Cust__c = oldPaf.ASI_HK_CRM_PAF_All_TC_Confirm_w_Cust__c;
        newPaf.ASI_HK_CRM_External_ID__c = oldPaf.ASI_HK_CRM_External_ID__c;
        newPaf.ASI_HK_CRM_Benchmark__c = oldPaf.ASI_HK_CRM_Benchmark__c;
        newPaf.ASI_HK_CRM_Benchmark_Investment_Amount__c = oldPaf.ASI_HK_CRM_Benchmark_Investment_Amount__c;
        newPaf.ASI_HK_CRM_PAF_Brand_Owner__c = oldPaf.ASI_HK_CRM_PAF_Brand_Owner__c;
        newPaf.ASI_HK_CRM_Conditions_of_Payment__c = oldPaf.ASI_HK_CRM_Conditions_of_Payment__c;
        newPaf.ASI_HK_CRM_Contract_Details__c = oldPaf.ASI_HK_CRM_Contract_Details__c;
        newPaf.ASI_HK_CRM_PAF_Contract_Requirement__c = oldPaf.ASI_HK_CRM_PAF_Contract_Requirement__c;
        newPaf.ASI_HK_CRM_PAF_Customer__c = oldPaf.ASI_HK_CRM_PAF_Customer__c;
        //newPaf.ASI_HK_CRM_PAF_End_Date__c = oldPaf.ASI_HK_CRM_PAF_End_Date__c; //20180220, edited by Arthur
        
        //20180220, edited by Arthur start
        if (oldPaf.ASI_HK_CRM_Adjusted_End_Date__c <> null)
        	newPaf.ASI_HK_CRM_PAF_End_Date__c = oldPaf.ASI_HK_CRM_Adjusted_End_Date__c; 
        else 
            newPaf.ASI_HK_CRM_PAF_End_Date__c = oldPaf.ASI_HK_CRM_PAF_End_Date__c;
        //20180220, edited by Arthur end
        
        //newPaf.ASI_HK_CRM_Error_Message__c = oldPaf.ASI_HK_CRM_Error_Message__c;
        //newPaf.ASI_HK_CRM_ExceedTshInvestmentPercent__c = oldPaf.ASI_HK_CRM_Error_Message__c;
        newPaf.ASI_HK_CRM_ExceedTshInvestmentAmt__c = oldPaf.ASI_HK_CRM_ExceedTshInvestmentAmt__c;
        newPaf.ASI_HK_CRM_PAF_Nature_of_Promotion__c = oldPaf.ASI_HK_CRM_PAF_Nature_of_Promotion__c;
        //newPaf.ASI_HK_CRM_PAF_No_of_Months__c = oldPaf.ASI_HK_CRM_PAF_No_of_Months__c;
        newPaf.ASI_HK_CRM_Other_Comments__c = oldPaf.ASI_HK_CRM_Other_Comments__c;
        newPaf.ASI_HK_CRM_PAF_Raised_Date__c = oldPaf.ASI_HK_CRM_PAF_Raised_Date__c;
        //newPaf.ASI_HK_CRM_PAF_Start_Date__c = oldPaf.ASI_HK_CRM_PAF_Start_Date__c; //20180220, edited by Arthur
        
        //20180220, edited by Arthur start
        if (oldPaf.ASI_HK_CRM_Adjusted_Start_Date__c <> null)
        	newPaf.ASI_HK_CRM_PAF_Start_Date__c = oldPaf.ASI_HK_CRM_Adjusted_Start_Date__c; 
        else 
            newPaf.ASI_HK_CRM_PAF_Start_Date__c = oldPaf.ASI_HK_CRM_PAF_Start_Date__c;
        //20180220, edited by Arthur end
        
        //newPaf.ASI_HK_CRM_PAF_Status__c = oldPaf.ASI_HK_CRM_PAF_Status__c; 
        newPaf.ASI_HK_CRM_PAF_Status__c = 'Draft'; 
        //newPaf.ASI_HK_CRM_SYS_Different_Duration__c = oldPaf.ASI_HK_CRM_SYS_Different_Duration__c;
        newPaf.ASI_HK_CRM_SYS_Fiscal_Year__c = oldPaf.ASI_HK_CRM_SYS_Fiscal_Year__c;
        //newPaf.ASI_HK_CRM_SYS_Has_MKT_Investment_Type__c = oldPaf.ASI_HK_CRM_SYS_Has_MKT_Investment_Type__c; 
        newPaf.ASI_HK_CRM_SYS_Sales_Director_Approver__c = oldPaf.ASI_HK_CRM_SYS_Sales_Director_Approver__c;
        //newPaf.ASI_HK_CRM_SYS_Start_Date_Difference__c = oldPaf.ASI_HK_CRM_SYS_Start_Date_Difference__c;
        newPaf.ASI_HK_CRM_SYS_Supervisor__c = oldPaf.ASI_HK_CRM_SYS_Supervisor__c;
        //newPaf.ASI_HK_CRM_Total_Investment__c = oldPaf.ASI_HK_CRM_Total_Investment__c;
        newPaf.ASI_HK_CRM_Total_Investment_Value__c = oldPaf.ASI_HK_CRM_Total_Investment_Value__c;
        newPaf.ASI_HK_CRM_SYS_Total_SKU_Value_1__c = oldPaf.ASI_HK_CRM_SYS_Total_SKU_Value_1__c;
        newPaf.ASI_HK_CRM_PAF_Version_No__c = oldPaf.ASI_HK_CRM_PAF_Version_No__c;
        newPaf.ASI_HK_CRM_All_Sub_Brand_VFI_Threshold__c = oldPaf.ASI_HK_CRM_All_Sub_Brand_VFI_Threshold__c;
        newPaf.ASI_HK_CRM_PAF_Volume_Commitment__c = oldPaf.ASI_HK_CRM_PAF_Volume_Commitment__c;
        newPaf.CurrencyIsoCode = oldPaf.CurrencyIsoCode;
        newPaf.ASI_CRM_Promotion_Category__c = oldPaf.ASI_CRM_Promotion_Category__c;
        // newPaf.recordTypeID = oldPaf.recordTypeId;
        System.debug('clk12 ' + newPaf);
        System.debug('clkrecordtype ' + newPaf.recordTypeID );

        insert newPaf;
        
        List<ASI_HK_CRM_Pre_Approval_Form_Item__c> oldPafDetailList = [select 
        ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c
        , ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c
        , ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c
        , ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c
        , ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_1__c
        , ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_2__c
        , ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_3__c
        , ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_4__c
        , ASI_HK_CRM_Conditions_for_Payment__c
        , ASI_HK_CRM_Contract_Details__c
        , ASI_HK_CRM_Fixed_Amount__c
        , ASI_HK_CRM_FOC_Free_Bottle_Option_1__c
        , ASI_HK_CRM_FOC_Free_Bottle_Option_2__c
        , ASI_HK_CRM_FOC_Free_Bottle_Option_3__c
        , ASI_HK_CRM_FOC_Free_Bottle_Option_4__c
        , ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_1__c
        , ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_2__c
        , ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_3__c
        , ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_4__c
        , ASI_HK_CRM_Investment_Value__c
        , ASI_HK_CRM_Mechanic__c
        , ASI_HK_CRM_Mechanic_Category__c
        , ASI_HK_CRM_MKT_Sales__c
        , ASI_HK_CRM_Other_Comments__c
        , ASI_HK_CRM_Pack_Factor__c
        , ASI_HK_CRM_Pouring__c
        , ASI_HK_CRM_Pre_Approval_Form_Lookup__c
        , ASI_HK_CRM_Price__c
        , ASI_HK_CRM_Rebate_Disc_Percent__c
        , ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c
        , ASI_HK_CRM_SKU_Lookup__c
        , ASI_HK_CRM_SKU_Value__c
        , ASI_HK_CRM_Sub_brand__c
        , ASI_HK_CRM_Target_Volume_Qty__c
        , ASI_HK_CRM_UOM__c
        , CurrencyIsoCode
        , recordTypeID
        , ASI_CRM_HK_All_Product__c //20160411, edited by Leo
        from ASI_HK_CRM_Pre_Approval_Form_Item__c where ASI_HK_CRM_Pre_Approval_Form_Lookup__c =: pafId];
                
        //Assign values from oldPafDetail to newPafDetail
        for(ASI_HK_CRM_Pre_Approval_Form_Item__c oldDetail: oldPafDetailList){
            pafDetailTemp = new ASI_HK_CRM_Pre_Approval_Form_Item__c();
            
            pafDetailTemp.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c = oldDetail.ASI_HK_CRM_FOC_Buy_Bottle_Option_1__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c = oldDetail.ASI_HK_CRM_FOC_Buy_Bottle_Option_2__c; 
            pafDetailTemp.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c = oldDetail.ASI_HK_CRM_FOC_Buy_Bottle_Option_3__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c = oldDetail.ASI_HK_CRM_FOC_Buy_Bottle_Option_4__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_1__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_1__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_2__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_2__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_3__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_3__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_4__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Buy_Bottle_Option_4__c;
            pafDetailTemp.ASI_HK_CRM_Conditions_for_Payment__c = oldDetail.ASI_HK_CRM_Conditions_for_Payment__c;
            pafDetailTemp.ASI_HK_CRM_Contract_Details__c = oldDetail.ASI_HK_CRM_Contract_Details__c;
            pafDetailTemp.ASI_HK_CRM_Fixed_Amount__c = oldDetail.ASI_HK_CRM_Fixed_Amount__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c = oldDetail.ASI_HK_CRM_FOC_Free_Bottle_Option_1__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c = oldDetail.ASI_HK_CRM_FOC_Free_Bottle_Option_2__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Free_Bottle_Option_3__c = oldDetail.ASI_HK_CRM_FOC_Free_Bottle_Option_3__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Free_Bottle_Option_4__c = oldDetail.ASI_HK_CRM_FOC_Free_Bottle_Option_4__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_1__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_1__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_2__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_2__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_3__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_3__c;
            pafDetailTemp.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_4__c = oldDetail.ASI_HK_CRM_FOC_Bulk_Free_Bottle_Option_4__c;
            pafDetailTemp.ASI_HK_CRM_Investment_Value__c = oldDetail.ASI_HK_CRM_Investment_Value__c;
            pafDetailTemp.ASI_HK_CRM_Mechanic__c = oldDetail.ASI_HK_CRM_Mechanic__c;
            //pafDetailTemp.ASI_HK_CRM_Mechanic_Category__c = oldDetail.ASI_HK_CRM_Mechanic_Category__c;
            pafDetailTemp.ASI_HK_CRM_MKT_Sales__c = oldDetail.ASI_HK_CRM_MKT_Sales__c;
            pafDetailTemp.ASI_HK_CRM_Other_Comments__c = oldDetail.ASI_HK_CRM_Other_Comments__c;
            //pafDetailTemp.ASI_HK_CRM_Pack_Factor__c = oldDetail.ASI_HK_CRM_Pack_Factor__c;
            if(!oldDetail.ASI_CRM_HK_All_Product__c) //20160411, edited by Leo
            	pafDetailTemp.ASI_HK_CRM_Pouring__c = oldDetail.ASI_HK_CRM_Pouring__c;
            pafDetailTemp.ASI_HK_CRM_Pre_Approval_Form_Lookup__c = newPaf.Id;
            pafDetailTemp.ASI_HK_CRM_Price__c = oldDetail.ASI_HK_CRM_Price__c;
            pafDetailTemp.ASI_HK_CRM_Rebate_Disc_Percent__c = oldDetail.ASI_HK_CRM_Rebate_Disc_Percent__c;
            pafDetailTemp.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c = oldDetail.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
            pafDetailTemp.ASI_HK_CRM_SKU_Lookup__c = oldDetail.ASI_HK_CRM_SKU_Lookup__c;
            pafDetailTemp.ASI_HK_CRM_SKU_Value__c = oldDetail.ASI_HK_CRM_SKU_Value__c;
            //pafDetailTemp.ASI_HK_CRM_Sub_brand__c = oldDetail.ASI_HK_CRM_Sub_brand__c;
            if(!oldDetail.ASI_CRM_HK_All_Product__c) //20160411, edited by Leo
            	pafDetailTemp.ASI_HK_CRM_Target_Volume_Qty__c = oldDetail.ASI_HK_CRM_Target_Volume_Qty__c;
            pafDetailTemp.ASI_HK_CRM_UOM__c = oldDetail.ASI_HK_CRM_UOM__c;
            pafDetailTemp.CurrencyIsoCode = oldDetail.CurrencyIsoCode;
            pafDetailTemp.ASI_CRM_HK_All_Product__c = oldDetail.ASI_CRM_HK_All_Product__c; //20160411, edited by Leo
            //pafDetailTemp.recordTypeID = oldDetail.recordTypeID;
            pafNewDetailList.add(pafDetailTemp);
        }

        insert pafNewDetailList;
        // Added by Alan Wong (Elufa) 20150924
        if (oldpaf.ASI_CRM_HK_Is_Channel_PAF__c){
            List<ASI_CRM_HK_Pre_Approval_Form_Customer__c> oldPAFCDetailList = [select ASI_CRM_HK_Customer__c FROM ASI_CRM_HK_Pre_Approval_Form_Customer__c WHERE ASI_CRM_HK_Pre_Approval_Form__c =: pafId];
            if (oldPAFCDetailList.size() > 0) {
                for (ASI_CRM_HK_Pre_Approval_Form_Customer__c oldPAFC :oldPAFCDetailList) {
                    ASI_CRM_HK_Pre_Approval_Form_Customer__c tmp = new ASI_CRM_HK_Pre_Approval_Form_Customer__c();
                    tmp.ASI_CRM_HK_Customer__c = oldPAFC.ASI_CRM_HK_Customer__c;
                    tmp.ASI_CRM_HK_Pre_Approval_Form__c = newPaf.Id;
                    pafcNewDetailList.add(tmp);
                }
            }                                                              
        }
        if (pafcNewDetailList.size() > 0){
            insert pafcNewDetailList;
        }
        // End //
        
        
        System.debug('aku2: ' + pafId);
        //return new PageReference('/' + this.pafId);
        return new PageReference('/' + newPaf.id + '/e?retURL=' + '%2F' + newPaf.id);
    }
}