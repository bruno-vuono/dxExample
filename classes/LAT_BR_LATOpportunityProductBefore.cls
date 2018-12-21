//LAT_OpportunityLineItem__c TRIGGER
/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 09/11/2016
*
********************************************************************************/

public with sharing class LAT_BR_LATOpportunityProductBefore {
	
	public static void execute(){
		
	    //Filtro por el RecordType de la oportunidad
	    Set<Id> setOppRt = Global_RecordTypeCache.getRtIdSet('LAT_Opportunity__c', new set<String>{'Bloqueia_alteracao', 'Bloqueia_alteracao_do_cabecalho', 'Nova_oportunidade'});
	    List<LAT_OpportunityLineItem__c> triggerNew_BR = new List<LAT_OpportunityLineItem__c>();
	    Set<Id> setOppIds = new Set<Id>();
	    
	    if(trigger.isUpdate || trigger.isInsert){
	        for(LAT_OpportunityLineItem__c oli : LAT_OpportunityLineItemTriggerHandler.triggerNew){
	            if(oli.LAT_Opportunity__c != null){
	                if(setOppRt.contains(oli.LAT_OpportunityRecordTypeId__c)){
	                    triggerNew_BR.add(oli);
	                    setOppIds.add(oli.LAT_Opportunity__c);
	                }
	            }
	        }
	    }
	    
	    //Llamadas a los metodos 
	    if(!triggerNew_BR.isEmpty()){
	        LAT_BR_AP01_OpportunityLineItem.decodeCompositionPrice(triggerNew_BR);
	        LAT_BR_AP01_OpportunityLineItem.calculateFreightPercent(triggerNew_BR, setOppIds);
	        
	    }
	    
	    
	}

}