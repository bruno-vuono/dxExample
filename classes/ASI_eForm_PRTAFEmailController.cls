public class ASI_eForm_PRTAFEmailController{
    public List<ASI_eForm_Pre_Trip_Approval_Item__c> items;
    public ASI_eForm_Pre_Trip_Approval__c request;
    public List<ApprovalHistory> approvalHistoryList;
    public String request_Id{get; set;}
    
    public ASI_eForm_PRTAFEmailController(){
    
    } 
    
    public List<ASI_eForm_Pre_Trip_Approval_Item__c> getItems(){
        if(this.items == null && request_Id!= null){
            system.debug('zz id: ' +request_Id);
            this.items = [select id, name,
            ASI_eForm_Date__c,
            ASI_eForm_From__c,
            ASI_eForm_To__c,
            ASI_eForm_Flight__c,
            ASI_eForm_Class__c,
            ASI_eForm_ETD__c,
            ASI_eForm_ETA__c,
            ASI_eForm_Round_Trip__c,
            ASI_eForm_Return_Date__c,
            ASI_eForm_Booking_Status__c
            from ASI_eForm_Pre_Trip_Approval_Item__c
            where ASI_eForm_Pre_Trip_Approval__c=: request_Id];
        
        }    
        return this.items;
    }
    
    public ASI_eForm_Pre_Trip_Approval__c getRequest(){
        if(this.request == null && request_Id != null){
            request = [select id, name, CreatedBy.name, owner.name, LastModifiedBy.name,recordtype.name,CreatedDate,LastModifiedDate,
                ASI_eForm_Approver__r.name,
                ASI_eForm_Preview_Approver__r.name,
                ASI_eForm_Attention__c,
                ASI_eForm_Company__c,
                ASI_eForm_Cost_Centre__c,
                ASI_eForm_Country__c,
                ASI_eForm_Currency__c,
                ASI_eForm_Department__c,
                ASI_eForm_Notify_Travel_Agent__c,
                ASI_eForm_Payment_Method__c,
                ASI_eForm_Position__c,
                ASI_eForm_Purpose__c,
                ASI_eForm_Recharge_To__c,
                ASI_eForm_Remarks__c,
                ASI_eForm_Status__c,
                ASI_eForm_Traveller__c,
                ASI_eForm_Traveller_Company__c,
                ASI_eForm_Total_Amount_Flight__c,
                ASI_eForm_Home_Leave__c,
                ASI_eForm_Total_Amount_Hotel__c,
                ASI_eForm_Hotel_Details__c,
                ASI_eForm_Employee_Traveller__c,
                ASI_eForm_Employee_Traveller__r.firstname,
                ASI_eForm_Employee_Traveller__r.lastname,
                ASI_eForm_Hotel_1_Name__c,
                ASI_eForm_Hotel_1_Rate__c,
                ASI_eForm_Hotel_1_To__c,
                ASI_eForm_Hotel_1_From__c,
                ASI_eForm_Hotel_2_Name__c,
                ASI_eForm_Hotel_2_Rate__c,
                ASI_eForm_Hotel_2_To__c,
                ASI_eForm_Hotel_2_From__c,
                ASI_eForm_Hotel_3_Name__c,
                ASI_eForm_Hotel_3_Rate__c,
                ASI_eForm_Hotel_3_To__c,
                ASI_eForm_Hotel_3_From__c,
                ASI_eForm_Owner_Full_Name__c,
             (Select Id, StepStatus, ActorId,OriginalActorId, Comments, CreatedDate From ProcessSteps order by CreatedDate DESC)
             from ASI_eForm_Pre_Trip_Approval__c
             where id =: request_Id];
        }
        
        return this.request;
        
    }
    
    
    public List<ApprovalHistory> getApprovalHistoryList(){    
        if(this.approvalHistoryList == null && request_Id!= null){
            approvalHistoryList = new List<ApprovalHistory>();
            Set<String> uId = new Set<String>();
            List<SoBject> tempList = getRequest().ProcessSteps;
            if(tempList != null && tempList.size() > 0){
                for(SObject o : tempList){
                    ProcessInstanceHistory p = (ProcessInstanceHistory) o;
                    ApprovalHistory history = new ApprovalHistory();
                    history.cDate = p.createdDate.format('MM/dd/yyyy hh:mm a');
                    history.status = p.StepStatus;
                    history.assignedTo= p.OriginalActorId;
                    history.actualApprover = p.ActorId;
                    history.comments = p.comments ;
                    uId.add(p.OriginalActorId);
                    uId.add(p.ActorId);
                    approvalHistoryList.add(history);
                }
                Map<Id,User> uMap = new Map<Id,User>([select id, name from User where id in: uId]);
                for(ApprovalHistory history : approvalHistoryList ){
                     history.assignedTo= (uMap.get(history.assignedTo)).name;
                     history.actualApprover = (uMap.get(history.actualApprover )).name;
                }
            }
        }
        return approvalHistoryList;
    }
    public class ApprovalHistory{
        public String status {get;set;}        
        public String assignedTo{get;set;}
        public String actualApprover {get;set;}
        public String comments {get;set;}
        public String cDate {get;set;}
    
    }
    
    public List<NoteAndAttachment> noteAndAttachments;
    
    public List<NoteAndAttachment> getNoteAndAttachments(){
    
        if(noteAndAttachments == null && request_Id!= null){
            noteAndAttachments = new List<NoteAndAttachment>();
            Set<String> uId = new Set<String>();
            List<Attachment> attachList = [Select Name,ownerid,Description from Attachment Where ParentID =:request_Id];
            
            if(attachList != null && attachList.size() > 0)
                for(Attachment a : attachList){
                    NoteAndAttachment temp = new NoteAndAttachment();
                    temp.type = 'Attachment';
                    temp.lastmodifiedby = a.ownerid;
                    temp.description = a.Description;
                    temp.filename = a.name;
                    uId.add(a.ownerid);
                    noteAndAttachments.add(temp);
                }
            List<Note> noteList = [Select Title,ownerid,body from Note Where ParentID =:request_Id];
            if(noteList != null && noteList.size() > 0)
                for(Note a : noteList ){
                    NoteAndAttachment temp = new NoteAndAttachment();
                    temp.type = 'Note';
                    temp.lastmodifiedby = a.ownerid;
                    temp.description = a.body;
                    temp.filename = a.Title;
                    uId.add(a.ownerid);
                    noteAndAttachments.add(temp);
                }            
            Map<Id,User> uMap = new Map<Id,User>([select id, name from User where id in: uId]);
            for(NoteAndAttachment temp: noteAndAttachments){
                     temp.lastmodifiedby =  (uMap.get(temp.lastmodifiedby)).name;
                   
            }       
        }
        return noteAndAttachments;
    }
    public class NoteAndAttachment{
        public String filename {get; set;}
        public String lastmodifiedby {get; set;}
        public String description {get; set;}
        public String type {get; set;} 
    }
}