/*******************************************************************************************
*        Company:Valuenet      Developers:Elena Schwarzböck        Date:17/10/2013         *
********************************************************************************************/
trigger LAT_MX_VisitaAfter on Visitas__c (after insert, after update) {
    
    //Filtrado de RecordTypes
    LAT_Trigger trigger_MX = new LAT_Trigger('Visitas__c', new set<String>{'LAT_MX_VTS_ClosedVisit','LAT_MX_VTS_PlannedVisit','LAT_MX_VTS_ClosedVisitON','LAT_MX_VTS_PlannedVisitON'});
        
    //Ejecucion de metodos especificos para MX
    if(!trigger_MX.getNew().IsEmpty()){
        if(trigger.isInsert){
            LAT_MX_AP01_Visita.createsEventForEachVisit(trigger_MX.getNew());
        }
        if(trigger.isUpdate) {
        		LAT_BR_AP01_Visita.updateEvent(trigger_MX.getNew(),new map<Id,Visitas__c>((List<Visitas__c>)trigger_MX.getOld()));
        }
    }
}