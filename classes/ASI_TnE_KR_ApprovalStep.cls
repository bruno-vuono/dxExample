public without sharing class ASI_TnE_KR_ApprovalStep {
    
    public void approvalStep(list<ASI_TnE_ClaimHeader__c> TriggerNew){
        
        map<id,User> userManager = new map<id,User>([SELECT id,ManagerID From User Where ASI_KOR_Commission_Code__c != null]);
        
        for(ASI_TnE_ClaimHeader__c obj : TriggerNew){
            
            if(userManager.get(obj.ASI_TnE_KR_Payee__c).ManagerID!=null)
                obj.ASI_TnE_KR_Line_Manager__c=userManager.get(obj.ASI_TnE_KR_Payee__c).ManagerID;
            
        	if(obj.ASI_TnE_KR_Payee__c!=obj.OwnerID){
                
                obj.ASI_TnE_KR_Payee_Approver__c=obj.ASI_TnE_KR_Payee__c;
            }else{
                obj.ASI_TnE_KR_Payee_Approver__c=null;
            }
        }
/***********************************************************************************************************************************        
        list<String> coApprover = new list<string>();
        list<String> additionalApprover = new list<String>();
        list<String> sysApprover = new list<String>();
        list<object> approver = new list<object>();
        map<id,User> userManager = new map<id,User>([SELECT id,ManagerID From User Where Country =: 'Korea']);
        
        
        for(integer i = 1;i <= 10;i++){
            if(i<=5){
                coApprover.add('ASI_TnE_KR_CoApprover_'+i+'__c');
                additionalApprover.add('ASI_TnE_KR_Additional_Approver_'+i+'__c');                
            }
            sysApprover.add('ASI_TnE_Sys_Approver_'+i+'__c');
        }
        
        for(ASI_TnE_ClaimHeader__c obj : TriggerNew){
            
            for(integer i = 0;i < 5;i++){
                if(obj.get(coApprover[i])!=null){
                    approver.add(obj.get(coApprover[i]));
                }
            }
            
            for(integer i = 0;i < 5;i++){
                if(obj.get(additionalApprover[i])!=null){
                    approver.add(obj.get(additionalApprover[i]));
                }
            }
            
            if(userManager.get(obj.ASI_TnE_KR_Payee__c).ManagerID!=null)
            approver.add(userManager.get(obj.ASI_TnE_KR_Payee__c).ManagerID);
            
            system.debug('check111 ' + approver);
            
            if(obj.ASI_TnE_KR_Payee__c!=obj.OwnerID){
                
                obj.ASI_TnE_Sys_Approver_1__c=obj.ASI_TnE_KR_Payee__c;
                
                for(integer i = 1;i <= approver.size();i++){
 					obj.put(sysApprover[i],approver[i-1]);
                    }
                
                for(integer i = approver.size()+1;i<sysApprover.size();i++){
                	obj.put(sysApprover[i],null);
            }
                
            }else{
                for(integer i = 0;i < approver.size();i++){
					obj.put(sysApprover[i],approver[i]);  
                }
                
                for(integer i = approver.size();i<sysApprover.size();i++){
                obj.put(sysApprover[i],null);
            	}
            }
            
        }
*********************************************************************************************************************/
    }
}