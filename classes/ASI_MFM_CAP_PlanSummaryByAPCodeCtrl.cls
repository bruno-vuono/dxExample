public with sharing class ASI_MFM_CAP_PlanSummaryByAPCodeCtrl{
    public ASI_MFM_Plan__c plan {get; set;}
    public Map<String,Double> acAmountMap {get; set;}
    public string currentHeaderId;
    
    public void setcurrentHeaderId (String s) {
            currentHeaderId = s;
            init();
        }

    public String getcurrentHeaderId() {
        return currentHeaderId;
    }
        
	public ASI_MFM_CAP_PlanSummaryByAPCodeCtrl(ApexPages.StandardController stdController){	
		this.plan = (ASI_MFM_Plan__c)stdController.getRecord();	
	}
	
	public ASI_MFM_CAP_PlanSummaryByAPCodeCtrl(){	
	}
	
    public void init(){
        acAmountMap = new Map<String,Double>();
        
        if (currentHeaderId != null){
             Map<String, Schema.SObjectField> planFieldMap = Schema.SObjectType.ASI_MFM_Plan__c.fields.getMap();
             String theQuery = 'Select ';
        
             for(String fields  : planFieldMap.keySet()){
                theQuery += fields + ' ,';
             }
         
             thequery = theQuery.subString(0,theQuery.length()-1);
             thequery += ', owner.name, createdby.name From ASI_MFM_Plan__c where  ID = ' + '\'' + currentHeaderId + '\' ';
             
             List<ASI_MFM_Plan__c> planList = (List<ASI_MFM_Plan__c>)Database.query(theQuery); 
             if (planList.size() > 0) {
                 plan = planList.get(0);
            }
        
            List<ASI_MFM_PO_Line_Item__c> polineList = [select id, ASI_MFM_A_C_Code__r.Name, ASI_MFM_Amount__c, ASI_MFM_Exchange_Rate__c from ASI_MFM_PO_Line_Item__c where ASI_MFM_PO__r.ASI_MFM_Plan__c = :plan.id];
            Double totalAmount = 0;
            
            for (ASI_MFM_PO_Line_Item__c poline:polineList){
                Double amt = 0;
                if (poline.ASI_MFM_Exchange_Rate__c != null && poline.ASI_MFM_Amount__c != null)
                    amt = poline.ASI_MFM_Exchange_Rate__c * poline.ASI_MFM_Amount__c;
                    
                if (acAmountMap.containsKey(poline.ASI_MFM_A_C_Code__r.Name)){
                    totalAmount = acAmountMap.get(poline.ASI_MFM_A_C_Code__r.Name) + amt;
                    acAmountMap.put(poline.ASI_MFM_A_C_Code__r.Name,totalAmount);
                    
                }
                else {
                    acAmountMap.put(poline.ASI_MFM_A_C_Code__r.Name,amt);
                }
            }

            system.debug('AC Description and PO Amount Map: ' + acAmountMap);
        }       
    }
}