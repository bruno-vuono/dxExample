public with sharing class ASI_CRM_KR_ItemUploadCtrl {
    
    public Id BatchId {set;get;}
    PUBLIC ASI_MFM_Mass_Upload_Log__c MFMlog {set;get;}
    
    public String Msg {get;set;}{Msg='';}
    public String Msg1 {get;set;}
    public boolean DeletePermission {get;set;} {DeletePermission = false;}
    public boolean GenerateMsg {get;set;} {GenerateMsg = false;}
    public boolean DeleteMsg {get;set;} {DeleteMsg = false;}
    
    public string[] statusMsgs{get;set;} 
    
    public string[] GenStatusMsgs{
       
        get{
            string s = Msg1 ==null? '': Msg1;
            if(BatchId!=null && DeletePermission == false){
                list<AsyncApexJob> aajs = [SELECT Id, Status, ExtendedStatus FROM AsyncApexJob WHERE ID =: BatchId  ];
                if(aajs.size()>0){
                    s = aajs[0].Status ;
                    }
                    //system.assertEquals(aajs[0].Status,null);
                if(aajs[0].Status=='Completed' && MFMlog.id != null){
                    ASI_MFM_Mass_Upload_Log__c uploadLog = [SELECT ASI_MFM_Configuration__c,ASI_MFM_Status__c,ASI_MFM_Error_Message__c FROM ASI_MFM_Mass_Upload_Log__c WHERE Id =: MFMlog.id];
                        //system.assertEquals(MFMlog.id,null);
                        if(uploadLog.ASI_MFM_Status__c == 'Success' && uploadLog.ASI_MFM_Error_Message__c == null)
                        {    
                            if( uploadLog.ASI_MFM_Configuration__c != null){
                            uploadLog.ASI_MFM_Configuration__c = uploadLog.ASI_MFM_Configuration__c.remove('null');
                            } 
                            //s = '<div style="height: 25px;"><img src="/img/msg_icons/confirm16.png" style="vertical-align: middle;"/> <span style="color:green; font-weight: bold; vertical-align: middle;"> Successfully generated Stock-in Trade records. '  + '</span></div>' ;
                            s = '<div style="height: 25px;"><img src="/img/msg_icons/confirm16.png" style="vertical-align: middle;"/> <span style="color:green; font-weight: bold; vertical-align: middle;"> Successfully generated Stock-in Trade records. ' +  uploadLog.ASI_MFM_Configuration__c + '</span></div>' ;
                        }
                        if(uploadLog.ASI_MFM_Status__c == 'Failed')
                        {  
                            s = 'Failed' +  uploadLog.ASI_MFM_Error_Message__c ;
                        }
                        
                        if(uploadLog.ASI_MFM_Error_Message__c != null  &&  uploadLog.ASI_MFM_Error_Message__c !=''){
                            
                            s =  uploadLog.ASI_MFM_Error_Message__c;
                        } 
                       
                        
                        
                } 
            }
            
            if(GenerateMsg == true){
                s = 'There is no Temp Data can be used to create Stock-in Trade Header and Line.';
            }
            
            if(DeleteMsg == true){
                
                s = 'There is no Temp record can be deleted.';
            }

            return s.split('\n');
        }
        //private set;

    }
    
    
    public String report_SITItem {get;set;} //For Report generation
    public String report_TempDataReport {get;set;} //For Report generation
    
    public class interimData {   
        ASI_KOR_Stock_In_Trade__c create_Header {set;get;}    
        ASI_KOR_WS_Stock_In_Trade_Detail__c create_Line {set;get;}   
    }
    
    public ASI_CRM_KR_ItemUploadCtrl(){
        report_SITItem = retrieveSITItemReport('ASI_KR_CRM_Item_Group_SIT');
        report_TempDataReport = retrieveSITItemReport('ASI_CRM_KR_Temp_StockInTrade'); 
    }
    
    private String retrieveSITItemReport(String repRecType){
        String reportType = '#';
        List<Report> report = [Select Id, Name, DeveloperName From Report Where DeveloperName =: repRecType];
        
        
        if(report.size() > 0){
            
            if(repRecType == 'ASI_KR_CRM_Item_Group_SIT'){
                reportType = '/' + report[0].Id + '?export=1&enc=UTF-8&xf=xls';
            }
            else{
                 reportType = '/' + report[0].Id;
            }
        }
        return reportType;
    }
    
    public void generateHeader(){
        
        DeleteMsg = false;
        DeletePermission = false; 
       
        MFMlog= new ASI_MFM_Mass_Upload_Log__c();
    
        list<ASI_CRM_KR_Temp_SIT__c> templine  = [select id from ASI_CRM_KR_Temp_SIT__c where ASI_CRM_KR_AccountOwnerChecking__c = true limit 1];
      
        if(templine.size() > 0 && templine != null){
            
            insert MFMlog;  
            BatchId= Database.executeBatch(new ASI_CRM_KR_ItemUploadBatch(MFMlog),500);    
            
        }
            
        if(templine.size() == 0){
            DeletePermission = true;
            
            GenerateMsg = true;
          
        }
      
        
    
    }
    
    public void deleteUploads(){
        
       
        GenerateMsg = false;
        DeletePermission = true;
       
        List<ASI_CRM_KR_Temp_SIT__c> DeleteTempList =new List<ASI_CRM_KR_Temp_SIT__c> ();
        
        
        for(ASI_CRM_KR_Temp_SIT__c templine : [select id,
                                               ASI_CRM_KR_SIT_Created__c,
                                               createdby.id
                                               from ASI_CRM_KR_Temp_SIT__c 
                                               where ASI_CRM_KR_AccountOwnerChecking__c = true]){
                                                 
                                                   DeleteTempList.add(templine);                                      
                                               }
        if(DeleteTempList.size() == 0){
           
           DeleteMsg = true;
          
        }
        
        if(DeleteTempList.size()>0){
            try{  
                delete DeleteTempList;
           
                Msg1 = '<div style="height: 25px;"><img src="/img/msg_icons/confirm16.png" style="vertical-align: middle;"/> <span style="color:green; font-weight: bold; vertical-align: middle;"> Successfully deleted ' + DeleteTempList.size() + ' Temp Records </span></div>';
               
                
            }
              
            catch (DmlException dmle) {
               
                Msg1 =  dmle.getMessage();
            }
            catch (Exception e){
             
                Msg1 =e.getMessage();
            }
        }
 
    }




}