/**
General Trigger Handler for Objective/Promotion.
BEFORE Insert, Update
Functions:
 5/29/14 
 1. Automatically assign an EUR_CRM_ObjPromo_Action_List_Template__c, 
    following a pre-defined mapping between EUR_CRM_ObjPromo_Action_List_Template__c.EUR_CRM_External_ID__c 
    and the RecordType Developer Name of the EUR_CRM_ObjPromo__c  
 2. "Leaflet Campaign > Use the value in the Customer Taxonomy field EUR_CRM_Leaflet_Campaign_Lead_Time_Weeks__c to set default Date value for the EUR_CRM_Preparation_Start_Date__c for Leaflet Campaign O/P header.
    EUR_CRM_Preparation_Start_Date__c  must still be User Editable"
    EUR_CRM_Preparation_Start_Date__c   = Active Start Date - TAxonomy Preparation Date Weeks.
*/

public with sharing class EUR_CRM_DE_ObjectivePromoHandler extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_DE_ObjectivePromoHandler() {
        super('EUR_CRM_DE_ObjectivePromoHandler ');
    }

    private final static Set<String> promoObjectiveRecordTypeSet = new Set<String>{
            'EUR_DE_Off_Trade_Distribution_Drive',
            'EUR_DE_Off_Trade_Leaflet_Campaign',
            'EUR_DE_Off_Trade_Listing_Campaign',
            'EUR_DE_Off_Trade_Sales_Drive',
            'EUR_DE_Off_Trade_Secondary_Placement_Any',
            'EUR_DE_Off_Trade_Secondary_Placement_Carton',
            'EUR_DE_Off_Trade_Secondary_Placement_Gondelkopf',
            'EUR_DE_Off_Trade_Secondary_Placement_Razz_Fazz',
            'EUR_DE_Off_Trade_Secondary_Placement_Standard',
            'EUR_DE_Off_Trade_Secondary_Placement_Promo_Display',
            'EUR_DE_Off_Trade_Tasting_Campaign',
            'EUR_DE_Off_Trade_Trade_Fair',
            'EUR_DE_OnTrade_PROS_TMKT_Promo',
            'EUR_DE_Off_Trade_Secondary_Placement_Theme',
            'EUR_DE_Off_Trade_Sales_Drive_SKU_Bottles',
            'EUR_DE_Off_Trade_Sales_Drive_SKU_Displays',
            'EUR_DE_WS_Objective',
            'EUR_DE_WS_Promotion_with_Lead_Time',
            'EUR_DE_WS_Promotion_without_Lead_Time'

    };

    private final static Map<String, String> opActionMap = new Map<String, String>{
            'EUR_DE_Off_Trade_Distribution_Drive' => 'DE_OFF_ALT_Dist_Drive',
            'EUR_DE_Off_Trade_Leaflet_Campaign' => 'DE_OFF_ALT_Leaflet_Campaign',
            'EUR_DE_OnTrade_PROS_TMKT_Promo' => 'DE_ON_ALT_ON_PROS_TMKT_Promos',
            'EUR_DE_Off_Trade_Sales_Drive' => 'DE_OFF_ALT_Sales_Drive',
            'EUR_DE_Off_Trade_Secondary_Placement_Any' => 'DE_OFF_ALT_2nd_PL_Any',
            'EUR_DE_Off_Trade_Secondary_Placement_Carton' => 'DE_OFF_ALT_2nd_PL_Carton',
            'EUR_DE_Off_Trade_Secondary_Placement_Gondelkopf' => 'DE_OFF_ALT_2nd_PL_Gondelkopf',
            'EUR_DE_Off_Trade_Secondary_Placement_Razz_Fazz' => 'DE_OFF_ALT_2nd_PL_Razz_Fazz',
            'EUR_DE_Off_Trade_Secondary_Placement_Standard' => 'DE_OFF_ALT_2nd_PL_STD',
            'EUR_DE_Off_Trade_Secondary_Placement_Theme' => 'DE_OFF_ALT_2nd_PL_Theme',
            'EUR_DE_Off_Trade_Tasting_Campaign' => 'DE_OFF_ALT_Tasting',
            'EUR_DE_Off_Trade_Trade_Fair' => 'DE_OFF_ALT_Trade_Fair',
            'EUR_DE_Off_Trade_Secondary_Placement_Promo_Display' => 'DE_OFF_ALT_2nd_PL_Promo_Display',
            'EUR_DE_Off_Trade_Sales_Drive_SKU_Bottles' => 'DE_OFF_ALT_Sales_Drive_SKU_Bottles',
            'EUR_DE_Off_Trade_Sales_Drive_SKU_Displays' => 'DE_OFF_ALT_Sales_Drive_SKU_Displays',
            'EUR_DE_WS_Objective' => 'DE_WS_Objective',
            'EUR_DE_WS_Promotion_with_Lead_Time' => 'DE_WS_Promo_with_Lead_Time',
            'EUR_DE_WS_Promotion_without_Lead_Time' => 'DE_WS_Promo_without_Lead_Time'

    };

    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        System.Debug('Begin EUR_CRM_DE_ObjectivePromoHandler');
        Map<Id, RecordType> recordTypes = new Map<Id, RecordType>();
        Set<Id> recordTypesId = new Set<Id>();
        Set<String> externalIds = new Set<String>();
        Set<Id> objPromoIds = new Set<Id>();


        for (EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>) sObjList) {
            recordTypesId.add(promo.recordTypeId);
            objPromoIds.add(promo.Id);
        }
        System.Debug('>>>OPIds Dump>>>' + objPromoIds);

        if (recordTypesId.size() > 0) {
            for (RecordType rt : [select id, developername from RecordType where id in:recordTypesId]) {
                recordTypes.put(rt.id, rt);
                if (opActionMap.get(rt.developername) != null)
                    externalIds.add(opActionMap.get(rt.developername));
            }
        }

        Map<String, id> actionListTemplateMap = new Map<String, id>();

        if (externalIds.size() > 0) {
            for (EUR_CRM_OP_Action_List_Template__c actionListTemplate : [select id,EUR_CRM_External_ID__c from EUR_CRM_OP_Action_List_Template__c where EUR_CRM_External_ID__c in:externalIds]) {
                actionListTemplateMap.put(actionListTemplate.EUR_CRM_External_ID__c, actionListTemplate.id);
            }
        }

        List<EUR_CRM_OP_Customer_Taxonomy_Mapping__c> customerTaxonomyMap = new List<EUR_CRM_OP_Customer_Taxonomy_Mapping__c>();

        if (objPromoIds.size() > 0) {
            customerTaxonomyMap = new List<EUR_CRM_OP_Customer_Taxonomy_Mapping__c>([
                    SELECT Id,
                            Name,
                            EUR_CRM_Customer_Taxonomy__r.Id,
                            EUR_CRM_Customer_Taxonomy__r.EUR_CRM_Leaflet_Campaign_Lead_Time_Weeks__c,
                            EUR_CRM_ObjPromo__r.Id
                    FROM EUR_CRM_OP_Customer_Taxonomy_Mapping__c
                    WHERE EUR_CRM_ObjPromo__c in:objPromoIds
            ]);
        }

        for (EUR_CRM_ObjPromo__c promo : (List<EUR_CRM_ObjPromo__c>) sObjList) {
            String recordTypeDevName = recordTypes.get(promo.recordTypeId) != null ? recordTypes.get(promo.recordTypeId).developername : null;

            /**
                Function 1.
            */

            if (promoObjectiveRecordTypeSet.contains(recordTypeDevName)) {

                String key = opActionMap.get(recordTypeDevName);
                if (key != null && actionListTemplateMap.get(key) != null) {
                    promo.EUR_CRM_OP_Action_List_Template__c = actionListTemplateMap.get(key);
                } else {
                    promo.addError('No Action List Template found for this type of Objective / Promotion');
                }

                if (tAction == EUR_CRM_TriggerAbstract.TriggerAction.BEFORE_INSERT) {
                    promo.EUR_CRM_Status__c = 'Draft';
                }
            }

            /**
               Function 2. works both for before insert and before update.
            */
            System.Debug('Running Function 2');
            if (recordTypeDevName == 'EUR_DE_Off_Trade_Leaflet_Campaign' && promo.EUR_CRM_Override_CTax_PrepStartDate__c == false && promo.EUR_CRM_Active_Start_Date__c != null && (oldMap == null || (oldMap != null && oldMap.get(promo.id) != null))) {
                System.Debug('In:EUR_DE_Off_Trade_Leaflet_Campaign');
                //Decimal weeks = customerTaxonomyMap.get(promo.EUR_CRM_Customer_Taxonomy__c).EUR_CRM_Leaflet_Campaign_Lead_Time_Weeks__c;
                Decimal weeks = -1;
                for (EUR_CRM_OP_Customer_Taxonomy_Mapping__c CTMap : (List<EUR_CRM_OP_Customer_Taxonomy_Mapping__c>) customerTaxonomyMap) {
                    If (CTMap.EUR_CRM_ObjPromo__r.id == promo.id && CTMap.EUR_CRM_Customer_Taxonomy__r.EUR_CRM_Leaflet_Campaign_Lead_Time_Weeks__c > weeks) {
                        weeks = CTMap.EUR_CRM_Customer_Taxonomy__r.EUR_CRM_Leaflet_Campaign_Lead_Time_Weeks__c;
                    }//End If
                }//End For

                if (weeks != null && weeks != -1) {
                    Date d = promo.EUR_CRM_Active_Start_Date__c;
                    promo.EUR_CRM_Preparation_Start_Date__c = d.addDays((Integer) (weeks * (-7)));
                    System.Debug('Assign EUR_CRM_Preparation_Start_Date__c:' + promo.EUR_CRM_Preparation_Start_Date__c + '| On Trigger:' + tAction);
                } else {
                    promo.EUR_CRM_Preparation_Start_Date__c = null;
                }//End If..Else..
            }//End If
            /*
               End of Function 2
            */
        }

    }
}