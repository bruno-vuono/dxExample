public class ASI_KOR_POSM_Order_Request_TriggerClass {
    
    
    private static boolean updatePOSMProductRun = true;
    private static boolean sendEmailtoSupplierRun = true;
    //Group by Product Owner in trade 
    
    public static void BeforeUpdateMethod(List<ASI_KOR_POSM_Order_Request__c> trigger_new, map<id, ASI_KOR_POSM_Order_Request__c> trigger_oldMap){
        set<id> approved_posm_set = new set<id>();
        
        for (ASI_KOR_POSM_Order_Request__c POSM : trigger_new){
            if(trigger_oldMap.get(POSM.Id).ASI_KOR_Status__c == 'Submitted' && POSM.ASI_KOR_Status__c == 'Approved'){
                approved_posm_set.add(POSM.Id);
                POSM.ASI_MFM_KR_Email_Sent__c=true;
                POSM.ASI_MFM_KR_EmailSentTime__c= system.now();
            }
            
        }
        
        //POSM to VENDOR  : Email/Detail Line List
        Map<String,List<ASI_KOR_POSM_Order_Detail__c>> DetailsLineMap = new Map<String,List<ASI_KOR_POSM_Order_Detail__c>>();
        
        Map<String,List<ASI_KOR_POSM_Order_Detail__c>> ProductOwnerMap = new Map<String,List<ASI_KOR_POSM_Order_Detail__c>>();
        
        if(approved_posm_set!= NULL &&  approved_posm_set.size()>0){
            for (ASI_KOR_POSM_Order_Detail__c line: [Select id,Name,ASI_KOR_POSM_Order_Request__r.ASI_KOR_POSM_TO_Venue__c,ASI_KOR_POSM_Order_Request__r.ASI_KOR_POSM_TO_Venue__r.Name,ASI_MFM_Venue__c,ASI_MFM_Venue__r.Name,ASI_KOR_Item_Name__r.ASI_KOR_Item_Name_Kor__c,ASI_KOR_Remarks__c,ASI_KOR_POSM_Order_Request__r.OwnerId,ASI_KOR_POSM_Order_Request__r.recordTypeId,ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__r.Email, ASI_KOR_Item_Name__c,ASI_KOR_POSM_Order_Request__r.Owner.Name,ASI_KOR_POSM_Order_Request__r.Name,ASI_KOR_Quantity__c,ASI_KOR_Item_Name__r.Name,ASI_KOR_Item_Name__r.ASI_MFM_Vender_Email_address__c,ASI_KOR_Item_Name__r.ASI_KOR_Item_Code__c,ASI_KOR_Ship_To_Address__c from ASI_KOR_POSM_Order_Detail__c where ASI_KOR_POSM_Order_Request__c in: approved_posm_set and ASI_KOR_Item_Name__c !=null ]){
                if(line.ASI_KOR_Item_Name__r.ASI_MFM_Vender_Email_address__c!=null){
                    string VendorEmail= string.valueOf(line.ASI_KOR_Item_Name__r.ASI_MFM_Vender_Email_address__c);
                    if(!DetailsLineMap.containsKey(VendorEmail)){
                        List<ASI_KOR_POSM_Order_Detail__c> tempList= new List<ASI_KOR_POSM_Order_Detail__c>();
                        tempList.add(line);
                        DetailsLineMap.put(VendorEmail, tempList);
                    }else{
                        DetailsLineMap.get(VendorEmail).add(line); 
                    }
                    
                    
                    if (Test.isRunningTest() || Global_RecordTypeCache.getRt(line.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_Locked_POSM_Request') || Global_RecordTypeCache.getRt(line.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_New_POSM_Request')){
                        string ProductOwnerEmail= string.valueOf(line.ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__r.Email);
                        if(!ProductOwnerMap.containsKey(ProductOwnerEmail)){
                            List<ASI_KOR_POSM_Order_Detail__c> tempList= new List<ASI_KOR_POSM_Order_Detail__c>();
                            tempList.add(line);
                            ProductOwnerMap.put(ProductOwnerEmail, tempList);
                        }else{
                            ProductOwnerMap.get(ProductOwnerEmail).add(line); 
                        }
                    }// end if 
                    
                }
            }//End of for loop
            sendEmailtoSupplierRun = false;
        }
        
        
        if(!ASI_MFM_ByPass_Setting.ByPassClass('ASI_MFM_KR_SendingEmailtoVendor','KR')){
            Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
                String BccAddresses='prkmfm@gmail.com'; 
            OrgWideEmailAddress owe = [SELECT ID FROM OrgWideEmailAddress WHERE DisplayName like 'IT Service Desk'];
            
            for(String key:ProductOwnerMap.keySet()){
                List <String> ToAddresses = new List <String>(); 
                ToAddresses.add(key);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(ToAddresses);
                message.setBccAddresses(new String[] {BccAddresses});//message.setTargetObjectId(ProductOwnerMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.OwnerId);
                message.setOrgWideEmailAddressId(owe.Id);
                message.setUseSignature(false); 
                message.setSaveAsActivity(false); 
                String subject = '아래 Item에 대한 요청이 승인되었습니다.'; 
                String body = '<span style="font-family: Century Gothic;font-size:10px;" > POSM Order number:'  +ProductOwnerMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.Name+ '<br/>Requester Name:'+ProductOwnerMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.owner.Name+'<br/>요청 내역 (Request Details)<br/> </span>'; 
                body+='<table style="font-family: Century Gothic;font-size:10px; border-collapse: collapse; " ><tr style="border: 1px solid black;"><th style="border: 1px solid black;">No</th><th style="border: 1px solid black;"> POSM Order Line No</th><th style="border: 1px solid black;">Venue Name</th><th style="border: 1px solid black;">Item name & Code </th><th style="border: 1px solid black;">Quantity</th><th style="border: 1px solid black;">Remark</th></tr>';
                integer num=1;
                for(ASI_KOR_POSM_Order_Detail__c items:ProductOwnerMap.get(key)){ 
                    body+='<tr  style="border: 1px solid black;" ><td style="border: 1px solid black;" >'+string.valueOf(num)+'</td><td style="border: 1px solid black;" >'+items.Name+' </td><td style="border: 1px solid black;" >';
                    if(Global_RecordTypeCache.getRt(items.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_New_High_Value_POSM_Request') || Global_RecordTypeCache.getRt(items.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_Locked_High_Value_POSM_Request') ){
                        if(items.ASI_MFM_Venue__c!=null){
                            body+=items.ASI_MFM_Venue__r.Name;
                        }
                    }else{
                        if(items.ASI_KOR_POSM_Order_Request__r.ASI_KOR_POSM_TO_Venue__c!=null){
                            body+=items.ASI_KOR_POSM_Order_Request__r.ASI_KOR_POSM_TO_Venue__r.Name;
                        } 
                    }
                    
                    body+='</td><td style="border: 1px solid black;" >'+items.ASI_KOR_Item_Name__r.Name;
                    
                    if(items.ASI_KOR_Item_Name__r.ASI_KOR_Item_Code__c!=null){
                        body+='('+items.ASI_KOR_Item_Name__r.ASI_KOR_Item_Code__c+')';
                    }
                    
                    body+='</td><td style="border: 1px solid black;" >'+items.ASI_KOR_Quantity__c+'</td><td style="border: 1px solid black;" >';
                     if(items.ASI_KOR_Remarks__c!=null){
                        body+=items.ASI_KOR_Remarks__c;
                    }
                   
                    body+='</td></tr>';
                    num++;
                }
                body+='</table>';
                message.setSubject(subject);
                message.setHtmlBody(body);///message.setBccSender(false); 
                mailList.add(message);
                
            }
            
            for(String key:DetailsLineMap.keySet()){
                List <String> ToAddresses = new List <String>(); 
                ToAddresses.add(key);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setToAddresses(ToAddresses);
                message.setBccAddresses(new String[] {BccAddresses});//message.setTargetObjectId(DetailsLineMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.OwnerId);
                message.setOrgWideEmailAddressId(owe.Id);
                message.setUseSignature(false); 
                message.setSaveAsActivity(false); 
                String subject = '아래 Item에 대한 요청이 승인되었습니다.'; 
                String body = '<span style="font-family: Century Gothic;font-size:10px;" > POSM Order number:'  +DetailsLineMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.Name+ '<br/>Requester Name:'+DetailsLineMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.owner.Name+'<br/>요청 내역 (Request Details)<br/> </span>'; 
                body+='<table style="font-family: Century Gothic;font-size:10px; border-collapse: collapse; " ><tr style="border: 1px solid black;"><th style="border: 1px solid black;">No</th><th style="border: 1px solid black;"> POSM Order Line No</th><th style="border: 1px solid black;">Venue Name</th><th style="border: 1px solid black;">Item name & Code </th><th style="border: 1px solid black;">Quantity</th><th style="border: 1px solid black;">Remark</th>';
                
                if(Global_RecordTypeCache.getRt(DetailsLineMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_New_High_Value_POSM_Request') || Global_RecordTypeCache.getRt(DetailsLineMap.get(key)[0].ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_Locked_High_Value_POSM_Request') ){
                    body+='<th style="border: 1px solid black;">Ship To</th>';
                }
                body+='</tr>';
                integer num=1;
                for(ASI_KOR_POSM_Order_Detail__c items:DetailsLineMap.get(key)){ 
                    body+='<tr  style="border: 1px solid black;" ><td style="border: 1px solid black;" >'+string.valueOf(num)+'</td><td style="border: 1px solid black;" >'+items.Name+' </td><td style="border: 1px solid black;" >';
                   
                    if(Global_RecordTypeCache.getRt(items.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_New_High_Value_POSM_Request') || Global_RecordTypeCache.getRt(items.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_Locked_High_Value_POSM_Request') ){
                        if(items.ASI_MFM_Venue__c!=null){
                            body+=items.ASI_MFM_Venue__r.Name;
                        }
                    }else{
                        if(items.ASI_KOR_POSM_Order_Request__r.ASI_KOR_POSM_TO_Venue__c!=null){
                            body+=items.ASI_KOR_POSM_Order_Request__r.ASI_KOR_POSM_TO_Venue__r.Name;
                        } 
                    }
                    
                    body+='</td><td style="border: 1px solid black;" >'+items.ASI_KOR_Item_Name__r.Name;
                    
                    if(items.ASI_KOR_Item_Name__r.ASI_KOR_Item_Code__c!=null){
                        body+='('+items.ASI_KOR_Item_Name__r.ASI_KOR_Item_Code__c+')';
                    }
                    
                    body+='</td><td style="border: 1px solid black;" >'+items.ASI_KOR_Quantity__c+'</td><td style="border: 1px solid black;" >';
                     if(items.ASI_KOR_Remarks__c!=null){
                        body+=items.ASI_KOR_Remarks__c;
                    }
                    
                    if(Global_RecordTypeCache.getRt(items.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_New_High_Value_POSM_Request') || Global_RecordTypeCache.getRt(items.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_Locked_High_Value_POSM_Request') ){
                        body+='</td><td style="border: 1px solid black;" >';                        
                        if(items.ASI_KOR_Ship_To_Address__c!=null){
                            body+=items.ASI_KOR_Ship_To_Address__c;
                        }
                    }
                    
                   
                    body+='</td></tr>';
                    num++;
                }
                body+='</table>';
                message.setSubject(subject);
                message.setHtmlBody(body);///message.setBccSender(false); 
                mailList.add(message);
                
            }
            Messaging.sendEmail(mailList);
            
        }
        
        
        
    } // end of BeforeUpdateMethod
    
    
    public static void routineAfterUpdate(list<ASI_KOR_POSM_Order_Request__c> trigger_new, map<Id, ASI_KOR_POSM_Order_Request__c> trigger_oldMap) {
        //Elufa PRA Support 2 Feb 2017  :  PRK MFM Phase 2    (Avaliable Qty & Already Used fields must be updated accordingly once the request is finally approved.)  Only for High Value POSM 
        set<id> approved_posm_set = new set<id>();
        Map<id, decimal> itemUsedQty = new Map<id, decimal> ();
        
        for (ASI_KOR_POSM_Order_Request__c POSM : trigger_new){
            if(trigger_oldMap.get(POSM.Id).ASI_KOR_Status__c == 'Submitted' && POSM.ASI_KOR_Status__c == 'Approved'){
                approved_posm_set.add(POSM.Id);
            }
            
        }
        
        if(approved_posm_set!= NULL &&  approved_posm_set.size()>0){
            for (ASI_KOR_POSM_Order_Detail__c line: [Select id,ASI_KOR_POSM_Order_Request__r.recordTypeId, ASI_KOR_Item_Name__c,ASI_KOR_POSM_Order_Request__r.Owner.Name,ASI_KOR_POSM_Order_Request__r.Name,ASI_KOR_Quantity__c,ASI_KOR_Item_Name__r.Name,ASI_KOR_Item_Name__r.ASI_MFM_Vender_Email_address__c,ASI_KOR_Item_Name__r.ASI_KOR_Item_Code__c,ASI_KOR_Ship_To_Address__c from ASI_KOR_POSM_Order_Detail__c where ASI_KOR_POSM_Order_Request__c in: approved_posm_set and ASI_KOR_Item_Name__c !=null ]){
                if(Global_RecordTypeCache.getRt(line.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_New_High_Value_POSM_Request') || Global_RecordTypeCache.getRt(line.ASI_KOR_POSM_Order_Request__r.recordTypeId).developerName.contains('ASI_KOR_Locked_High_Value_POSM_Request')){
                    if(!itemUsedQty.containsKey(line.ASI_KOR_Item_Name__c)){
                        itemUsedQty.put(line.ASI_KOR_Item_Name__c,line.ASI_KOR_Quantity__c);
                    }else{
                        decimal qty = itemUsedQty.get(line.ASI_KOR_Item_Name__c);
                        qty += (line.ASI_KOR_Quantity__c!=null?line.ASI_KOR_Quantity__c:0);
                        itemUsedQty.put(line.ASI_KOR_Item_Name__c, qty) ;
                    }
                }
                
            }//End of for loop
            sendEmailtoSupplierRun = false;
        }
        
        
        if(itemUsedQty!=null && itemUsedQty.size()>0){ // update POSM Product
            Map<Id, ASI_KOR_POSM_Product__c> updateProductList = new  Map<Id, ASI_KOR_POSM_Product__c> ();
            
            for(ASI_KOR_POSM_Product__c posmProduct: [Select id, ASI_MFM_Available_Qty__c, ASI_MFM_Already_Used__c from ASI_KOR_POSM_Product__c where RecordType.developerName='ASI_KOR_POSM_Product' and Id in: itemUsedQty.keySet() for update]){
                posmProduct.ASI_MFM_Available_Qty__c =  (posmProduct.ASI_MFM_Available_Qty__c !=null? posmProduct.ASI_MFM_Available_Qty__c:0) - itemUsedQty.get(posmProduct.Id);
                posmProduct.ASI_MFM_Already_Used__c = (posmProduct.ASI_MFM_Already_Used__c!=null? posmProduct.ASI_MFM_Already_Used__c:0) + itemUsedQty.get(posmProduct.Id);
                updateProductList.put(posmProduct.Id, posmProduct);
            }
            
            
            if(updatePOSMProductRun && updateProductList!=null){
                updatePOSMProductRun = false;
                update updateProductList.values();
            }
        }
    }
    
    
    
    
    public static void BeforeUpsertMethod(List<ASI_KOR_POSM_Order_Request__c> triggerNew, map<id, ASI_KOR_POSM_Order_Request__c> trigger_oldMap){
        set<id> posm_set = new set<id>();
        set<id> OwnerPOSMSet = new set<id>();
        for (ASI_KOR_POSM_Order_Request__c p:triggerNew) {
            posm_set.add(p.id); 
            if(trigger_oldMap==null){
                OwnerPOSMSet.add(p.OwnerId); 
            }else{
                if(trigger_oldMap.get(p.id).OwnerId != p.OwnerId){
                    OwnerPOSMSet.add(p.OwnerId); 
                }
            }
            
        }  
        Map<Id,set<Id>> ProductOwnerMap= New Map<Id,set<Id>> ();
        if (posm_set.size() > 0) {  
            Map<ID, User> mapUser= new Map<ID, User>();
            list<ASI_KOR_POSM_Order_Detail__c> POSM_list = [select Id,Name,ASI_KOR_POSM_Order_Request__c,ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__c   from ASI_KOR_POSM_Order_Detail__c where ASI_KOR_POSM_Order_Request__c in :posm_set for update];
            for(ASI_KOR_POSM_Order_Detail__c POSMLine:POSM_list){
                if(POSMLine.ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__c!=null){
                    if(!ProductOwnerMap.containsKey(POSMLine.ASI_KOR_POSM_Order_Request__c)){//New One 
                        set<Id> ProductOwnerIDSet =new set<Id>();
                        ProductOwnerIDSet.add(POSMLine.ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__c);
                        ProductOwnerMap.put(POSMLine.ASI_KOR_POSM_Order_Request__c,ProductOwnerIDSet);
                    }else{
                        ProductOwnerMap.get(POSMLine.ASI_KOR_POSM_Order_Request__c).add(POSMLine.ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__c);
                    }
                    //ProductOwnerIDSet.add(POSMLine.ASI_KOR_Item_Name__r.ASI_MFM_Product_Owner__c);
                }
            }//End of for Loop
            
            
            if(OwnerPOSMSet.size()>0){
                mapUser = new Map<ID,User>([SELECT ID, Name, ManagerID  FROM User WHERE id in : OwnerPOSMSet ]); //get all Korea User
                
            }
            for (ASI_KOR_POSM_Order_Request__c p:triggerNew) {
                setApproverToNull(p);
                if(mapUser.containsKey(p.OwnerId)){
                    p.ASI_MFM_Line_Manager__c=mapUser.get(p.OwnerId).ManagerID;
                }
                if(ProductOwnerMap.containsKey(p.Id)){
                    integer approver_count = 0;//  system.debug('Approver Id:  '+ProductOwnerMap.get(p.Id));
                    for(id owid:ProductOwnerMap.get(p.Id)){
                        if (approver_count == 0 && p.ASI_MFM_Line_Manager__c!=owid ) {
                            p.ASI_MFM_Approver_1__c = owid;
                        }else if (approver_count == 1 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_2__c =owid;
                        }else if (approver_count == 2 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_3__c =owid;
                        }else if (approver_count == 3 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_4__c =owid;
                        }else if (approver_count == 4 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_5__c =owid;
                        }else if (approver_count == 5 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_6__c = owid;
                        }else if (approver_count == 6 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_7__c = owid;
                        }else if (approver_count == 7 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_8__c = owid;
                        }else if (approver_count == 8 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_9__c = owid;
                        }else if (approver_count == 9 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_10__c =owid;
                        }else if (approver_count == 10 && p.ASI_MFM_Line_Manager__c!=owid ) {                                 
                            p.ASI_MFM_Approver_11__c =owid;
                        }      
                        
                        if(p.ASI_MFM_Line_Manager__c!=owid ){
                            approver_count++;
                        }
                        
                    }
                }
            } 
        }
        
    }// END OF BeforeUpsertMethod 
    
    
    
    public static void setApproverToNull(ASI_KOR_POSM_Order_Request__c posm)
    {
        String sysApprover;
        
        for(integer i = 1 ; i <=11 ; i++)
        {
            sysApprover = 'ASI_MFM_Approver_' + i + '__c';
            posm.put(sysApprover,null);
        }//end for
    }//end method: setApproverToNull
    
    
}