public with sharing class ASI_FOC_Request_Item_TriggerClass {
	Static Integer afterUpdateCount = 0;
	public static void routineAfterUpsert(list<ASI_FOC_Request_Item__c> trigger_new, map<id, ASI_FOC_Request_Item__c> trigger_oldMap) {
        if(afterUpdateCount == 0){
            afterUpdateCount++;
// Set ASI_FOC_SYS_Request_Line_Information__c for the related request order
		set<id> rq_set = new set<id>();
		for (ASI_FOC_Request_Item__c i:trigger_new) {
			rq_set.add(i.ASI_FOC_Request_Order__c);
		}
        // Modified by Alan Wong (Elufa) 20150803
		list<ASI_FOC_Free_Goods_Request__c> rq_list = [select (select ASI_FOC_SKU__r.name, ASI_FOC_SKU__r.ASI_FOC_SKU_Chinese_Description__c, ASI_FOC_Request_Quantity_Bottle__c,ASI_FOC_Original_Request_Quantity_PC_BT__c, ASI_FOC_Packing_Description__c, ASI_FOC_Brand_Director_Approval_Status__c 
			from ASI_FOC_Request_Items__r /*where ASI_FOC_Brand_Director_Approval_Status__c != 'Rejected' and ASI_FOC_Brand_Director_Approval_Status__c != 'Cancelled'*/ order by ASI_FOC_SKU__r.name)
			from ASI_FOC_Free_Goods_Request__c where id in :rq_set for update];
        // -- End -- //
		string sku_x = 'SKU';
		string pkg_x = 'Packaging';
		string qty_x = 'Qty.';
        String ChiDes_x = 'Chinese Description';		// 20151028 Ben @ Elufa
        String approvalStatus = 'Approval Status';
		string hdr = sku_x.rightPad(31) + pkg_x.rightPad(11) + qty_x.rightPad(6) + ChiDes_x.rightPad(31) + approvalStatus.rightPad(10) + '<br/>';	
		for (ASI_FOC_Free_Goods_Request__c rq:rq_list) {
			rq.ASI_FOC_SYS_Request_Line_Information__c = '<pre>' + hdr;
//			integer line_no = 0;
			for (ASI_FOC_Request_Item__c i:rq.ASI_FOC_Request_Items__r) {
//				line_no++;
//				rq.ASI_FOC_SYS_Request_Line_Information__c += string.valueOf(line_no).trim().rightPad(4);
				string sku_name = i.ASI_FOC_SKU__r.name == null ? '' : i.ASI_FOC_SKU__r.name;
				rq.ASI_FOC_SYS_Request_Line_Information__c += sku_name.trim().left(30).rightPad(31);
				string sku_pkg = i.ASI_FOC_Packing_Description__c == null ? '' : i.ASI_FOC_Packing_Description__c;
				rq.ASI_FOC_SYS_Request_Line_Information__c += sku_pkg.trim().left(10).rightPad(11);				
				//string sku_qty = i.ASI_FOC_Request_Quantity_Bottle__c == null ? '' : string.valueOf(i.ASI_FOC_Request_Quantity_Bottle__c);
				string sku_qty = i.ASI_FOC_Original_Request_Quantity_PC_BT__c == null ? '' : string.valueOf(i.ASI_FOC_Original_Request_Quantity_PC_BT__c); // Modified by Alan Wong (Elufa) 20150803
				rq.ASI_FOC_SYS_Request_Line_Information__c += sku_qty.trim().right(5).rightPad(6);
                string sku_ChiDes = i.ASI_FOC_SKU__r.ASI_FOC_SKU_Chinese_Description__c == null ? '' : i.ASI_FOC_SKU__r.ASI_FOC_SKU_Chinese_Description__c;
                rq.ASI_FOC_SYS_Request_Line_Information__c += sku_ChiDes.trim().right(30).rightPad(31);
                string approvalStatus_Str = i.ASI_FOC_Brand_Director_Approval_Status__c == null ? '' : i.ASI_FOC_Brand_Director_Approval_Status__c;
                rq.ASI_FOC_SYS_Request_Line_Information__c += approvalStatus_Str.trim().right(9).rightPad(10) + '<br/>';
			}
			rq.ASI_FOC_SYS_Request_Line_Information__c += '</pre>';										  
		}
        update rq_list;	
        }
	}
	
	public static void routineBeforeUpsert(list<ASI_FOC_Request_Item__c> trigger_new, map<id, ASI_FOC_Request_Item__c> trigger_oldMap) {
		set<id> sku_set = new set<id>();
        set<id> FOC_set = new set<id>();
		for (ASI_FOC_Request_Item__c i:trigger_new) {
			sku_set.add(i.ASI_FOC_SKU__c);
            FOC_set.add(i.ASI_FOC_Request_Order__c);
			if (i.ASI_FOC_Sys_Clone_Flag__c) {
				i.ASI_FOC_Sys_Clone_Flag__c = false;
			}
		}
        Map<string, id> rt_map = ASI_MFM_Function.getRecordTypeId('ASI_FOC_Request_Item__c'); // Added By Alan Wong (Elufa) 20150616
		map<id, ASI_FOC_Free_Goods_Request__c> foc_map = new map<id, ASI_FOC_Free_Goods_Request__c>([SELECT id, ASI_FOC_Description__c, OwnerID FROM ASI_FOC_Free_Goods_Request__c WHERE id IN:FOC_set]);
// Set Brand Approval Required Flag and Brand Approver
		map<id, ASI_MFM_SKU_Code__c> sku_map = new map<id, ASI_MFM_SKU_Code__c>([select ASI_FOC_Location_Item_Owner__c, ASI_FOC_Location_Item_Owner__r.ManagerID, ASI_FOC_Brand_Director_Approval_Required__c, ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ownerId from ASI_MFM_SKU_Code__c where id in :sku_set]);
		
        //20171113 Introv
        
        Map<id, ASI_CRM_SKU_Photo__c> mapSKUPhoto = new Map<id, ASI_CRM_SKU_Photo__c>();
        for(ASI_CRM_SKU_Photo__c obj : [SELECT Id
                                        , ASI_CRM_Attachment__r.ASI_Image_URL__c
                                        , ASI_CRM_SKU__c
                                        FROM ASI_CRM_SKU_Photo__c
                                        WHERE ASI_CRM_SKU__c IN : sku_set
                                        ORDER BY ASI_CRM_Attachment__r.ASI_CRM_Photo_Category__c ASC
                                        , ASI_CRM_Photo_Version__c DESC
                                        , ASI_CRM_Attachment__r.ASI_Name__c ASC
                                       ]){
                                           mapSKUPhoto.put(obj.ASI_CRM_SKU__c, obj);
                                       }
        
        //20171113 End
        
        List<ASI_FOC_Free_Goods_Request__Share> sharingList = new List<ASI_FOC_Free_Goods_Request__Share>();//20151230 Ben @ Elufa System
        
        for (ASI_FOC_Request_Item__c i:trigger_new) {
            
            //20171113 Introv
            if(mapSKUPhoto.containsKey(i.ASI_FOC_SKU__c))
                i.ASI_FOC_SKU_Image_URL__c = mapSKUPhoto.get(i.ASI_FOC_SKU__c).ASI_CRM_Attachment__r.ASI_Image_URL__c;
            //20171113 End
            
			if (sku_map.containsKey(i.ASI_FOC_SKU__c)) {
                //20151211 Ben @ Elufa System
                if(i.recordTypeId == rt_map.get('ASI_FOC_CN_Request_Item')){
                    i.ASI_FOC_Brand_Director_Approval_Required__c = sku_map.get(i.ASI_FOC_SKU__c).ASI_FOC_Brand_Director_Approval_Required__c;
                    if (i.ASI_FOC_Brand_Director_Approval_Required__c) {
                        i.ASI_FOC_Brand_Approver__c = sku_map.get(i.ASI_FOC_SKU__c).ASI_MFM_Sub_brand__r.ASI_MFM_Brand__r.ownerId;
                    }
                    else {
                        i.ASI_FOC_Brand_Approver__c = null;
                    }
                }else if(i.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Request_Item')){
                    if(foc_map.get(i.ASI_FOC_Request_Order__c).OwnerID != sku_map.get(i.ASI_FOC_SKU__c).ASI_FOC_Location_Item_Owner__c && sku_map.get(i.ASI_FOC_SKU__c).ASI_FOC_Location_Item_Owner__c != NULL){
                        
                        i.ASI_FOC_Brand_Director_Approval_Required__c = TRUE;
                        i.ASI_FOC_Brand_Approver__c = sku_map.get(i.ASI_FOC_SKU__c).ASI_FOC_Location_Item_Owner__c;//20160119 Ben @ Elufa Systems removed ManagerID
                        
                        //20151230 Ben @ Elufa System
                        if(trigger.isInsert){
                            ASI_FOC_Free_Goods_Request__Share shareRecord = new ASI_FOC_Free_Goods_Request__Share();
                            shareRecord.ParentId = i.ASI_FOC_Request_Order__c;
                            shareRecord.UserOrGroupId = sku_map.get(i.ASI_FOC_SKU__c).ASI_FOC_Location_Item_Owner__c;//20160119 Ben @ Elufa Systems removed ManagerID
                            shareRecord.AccessLevel = 'edit';
                            if(shareRecord.UserOrGroupId != NULL)
                                sharingList.add(shareRecord);
                        }
                        //20151230 End
                    }else{
                        i.ASI_FOC_Brand_Director_Approval_Required__c = FALSE;
                        i.ASI_FOC_Brand_Approver__c = NULL;
                    }
                }
                //20151211 End
			}
            if (foc_map.containsKey(i.ASI_FOC_Request_Order__c)) {
				i.ASI_FOC_Reason__c = foc_map.get(i.ASI_FOC_Request_Order__c).ASI_FOC_Description__c;
			}
            if (i.recordTypeId == rt_map.get('ASI_FOC_CN_Request_Item')){
                if (i.ASI_FOC_Cancel_Quantity_PC_BT__c == i.ASI_FOC_Original_Request_Quantity_PC_BT__c && i.ASI_FOC_Original_Request_Quantity_PC_BT__c > 0 &&
                    (i.ASI_FOC_Brand_Director_Approval_Status__c == null || i.ASI_FOC_Brand_Director_Approval_Status__c == '')) {
                        i.ASI_FOC_Brand_Director_Approval_Status__c = 'Cancelled';
                }
            }
            //20160203 Ben @ Elufa
            else if (i.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Request_Item')){
                if (i.ASI_FOC_Cancel_Quantity_PC_BT__c == i.ASI_FOC_Original_Request_Quantity_PC_BT__c && i.ASI_FOC_Original_Request_Quantity_PC_BT__c > 0) {
                        i.ASI_FOC_Brand_Director_Approval_Status__c = 'Cancelled';
                }
            }
            //20160203 End
            if (trigger_oldMap != null){
                if (i.recordTypeId == rt_map.get('ASI_FOC_CN_Request_Item') && i.ASI_FOC_Original_Request_Quantity_PC_BT__c != trigger_oldMap.get(i.Id).ASI_FOC_Original_Request_Quantity_PC_BT__c)
                {
                    i.ASI_FOC_Request_Quantity_Bottle__c = i.ASI_FOC_Original_Request_Quantity_PC_BT__c;
                }
                if (i.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Request_Item') && i.ASI_FOC_Original_Request_Quantity_PC_BT__c != trigger_oldMap.get(i.Id).ASI_FOC_Original_Request_Quantity_PC_BT__c)
                {
                    i.ASI_FOC_Request_Quantity_PC__c = i.ASI_FOC_Original_Request_Quantity_PC_BT__c;
                }
            }
            else{
                 if (i.recordTypeId == rt_map.get('ASI_FOC_CN_Request_Item'))
                {
                    i.ASI_FOC_Request_Quantity_Bottle__c = i.ASI_FOC_Original_Request_Quantity_PC_BT__c;
                }
                if (i.recordTypeId == rt_map.get('ASI_FOC_CN_POSM_Request_Item'))
                {
                    i.ASI_FOC_Request_Quantity_PC__c = i.ASI_FOC_Original_Request_Quantity_PC_BT__c;
                }
            }
        }
        //20151230 Ben @ Elufa System
        if(sharingList.size()>0)
            Database.insert(sharingList, false);
        //20151230 End
	}
    
    Public Static void routineBeforeDelete(List<ASI_FOC_Request_Item__c> trigger_old){
        
        Set<ID> headerID = new Set<ID>();
        
        for(ASI_FOC_Request_Item__c obj : trigger_old){
            headerID.add(obj.ASI_FOC_Request_Order__c);
        }
        
        Map<ID, ASI_FOC_Free_Goods_Request__c> headerMap = new Map<ID, ASI_FOC_Free_Goods_Request__c>([SELECT id, ASI_FOC_Request_Status__c FROM ASI_FOC_Free_Goods_Request__c WHERE id IN : headerID]);
        
        for(ASI_FOC_Request_Item__c obj : trigger_old){
            if(headerMap.containsKey(obj.ASI_FOC_Request_Order__c)){
                if(headerMap.get(obj.ASI_FOC_Request_Order__c).ASI_FOC_Request_Status__c != 'Open'){
                    obj.addError('Not allowed to delete record in current status');
                }
            }
        }
    }
}