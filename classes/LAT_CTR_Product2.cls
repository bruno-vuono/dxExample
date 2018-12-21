/**********************************************************************************
*                           Company: ValueNet
*----------------------------------------------------------------------------------
*        Clase que distribuye los registros por pais del objeto Product2
***********************************************************************************/
/********************************************************************************
* 
* MIGRACION LICENCIAS 
* AUTHOR: ZIMMIC                     DATE: 09/11/2016
*
********************************************************************************/

public with sharing class LAT_CTR_Product2{

    /*ALL TRIGGERS*/
    //MIGRATED 09/11/2016 
    public static void runTriggers(){
        if(!Utils.wasMigrationDone('12')){
            LAT_Trigger trigger_MX = new LAT_Trigger('Product2', new set<String>{'LAT_MX_PRD_Standard'});
            //triggersLAT(trigger_MX);
        }
        
        if(!Utils.wasMigrationDone('6')){
            LAT_Trigger trigger_AR = new LAT_Trigger('Product2', new set<String>{'Standard_AR'});
            triggersLAT(trigger_AR, '6');
        }

        if(!Utils.wasMigrationDone('5')){
            LAT_Trigger trigger_UY = new LAT_Trigger('Product2', new set<String>{'Standard_UY'});
            triggersLAT(trigger_UY, '5');
        }

        if(!Utils.wasMigrationDone('1')){
            LAT_Trigger trigger_BR = new LAT_Trigger('Product2', new set<String>{'BRA_Standard'});
            triggersLAT(trigger_BR, '1');    
            triggersBR(trigger_BR);
        }
       
        LAT_Trigger LAT_trigger_MX = new LAT_Trigger('LAT_Product__c', new set<String>{'LAT_MX_PRD_Standard'});
        if (LAT_trigger_MX.getNew().size() > 0) {
            triggersMX(LAT_trigger_MX);
        }    

    }
  
    /*TRIGGERS LAT*/
    private static void triggersLAT(LAT_Trigger trigger_LAT, String country){
        //After

        if(trigger.isAfter){
            if(trigger.isInsert){
                LAT_AP01_Product2.createsPriceBookEntry(trigger_LAT.getNew());
            }

        }
    }
    

    /*TRIGGERS BR*/
    private static void triggersBR(LAT_Trigger trigger_BR){
        //Before
        //After
        if(trigger.isAfter){
            if(trigger.isUpdate && !trigger_BR.getNew().IsEmpty()){
                LAT_AP01_Product2.updatesPPCKey(trigger_BR.getNew(),new map<Id,Product2>((List<Product2>)trigger_BR.getOld()));
            }
        }
    }

    /*TRIGGERS MX*/
    private static void triggersMX(LAT_Trigger trigger_MX){
        //Before
        
        if(trigger.isBefore){
            LAT_AP01_Product2.updateIndexMargin(trigger_MX.getNew(), 'LAT_MX_PRD_Standard');
            if (trigger.isUpdate) {
                LAT_AP01_Product2.updateRestriction(trigger_MX.getNew());
            }
        }
    }
}