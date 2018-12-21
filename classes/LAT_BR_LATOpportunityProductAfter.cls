//LAT_OpportunityLineItem__c TRIGGER
/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 09/11/2016
*
********************************************************************************/

public with sharing class LAT_BR_LATOpportunityProductAfter {
	
	public static void execute(){
		//Filtro por el RecordType de la oportunidad
	    Set<Id> setOppRt = Global_RecordTypeCache.getRtIdSet('LAT_Opportunity__c', new set<String>{'Bloqueia_alteracao', 'Bloqueia_alteracao_do_cabecalho', 'Nova_oportunidade'});
	    
	    List<LAT_OpportunityLineItem__c> triggerNew_BR = new List<LAT_OpportunityLineItem__c>();
	    List<LAT_OpportunityLineItem__c> triggerOld_BR = new List<LAT_OpportunityLineItem__c>();
	    
	    if(trigger.isDelete){
	        for(LAT_OpportunityLineItem__c oli :LAT_OpportunityLineItemTriggerHandler.triggerOld){
	            if(setOppRt.contains(oli.LAT_OpportunityRecordTypeId__c)){
	                triggerOld_BR.add(oli);
	            }
	        }
	    }
	    if(trigger.isUpdate || trigger.isInsert){
	        for(LAT_OpportunityLineItem__c oli :LAT_OpportunityLineItemTriggerHandler.triggerNew){
	            if(setOppRt.contains(oli.LAT_OpportunityRecordTypeId__c)){
	                triggerNew_BR.add(oli);
	            }
	        }
	    }
	    
	    
	}

}