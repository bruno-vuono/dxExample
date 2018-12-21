/**

Functions: 

(($RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Do_TMKT_Doc' || 
$RecordType.DeveloperName == 'DE_OFF_Ad_hoc_Agree_To_Buy' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_Tasting_Discussion'|| 
$RecordType.DeveloperName == 'EUR_DE_OFF_Leaflet_Campaign_Agree_To_Buy' ) 
&& ISPICKVAL(EUR_CRM_Status__c,'Yes')) || 
(($RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Carton' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Theme'|| 
$RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Promo_Display'|| 
$RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Gondelkopf'|| 
$RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Razz_Fazz' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Standard' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_Ad_Hoc_Sell_In_Qty' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_Leaflet_Campaign_Sell_In_Qty'|| 
$RecordType.DeveloperName == 'EUR_DE_OFF_Sales_Drive_Sell_In_Qty' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_Tasting_Sell_In_Qty' || 
$RecordType.DeveloperName == 'EUR_DE_OFF_Trade_Fair_Sell_In_Qty' || 
$RecordType.DeveloperName == 'EUR_DE_ON_TMKT_Promo_Enter_Sell_In_Qty') 
&& ISPICKVAL(EUR_CRM_Status__c,'Qty Confirmed')) || 
(($RecordType.DeveloperName == 'EUR_DE_OFF_Dist_Drive_Listing_Check' ) 
&& ISPICKVAL(EUR_CRM_Status__c,'Listed')) || 
(($RecordType.DeveloperName == 'EUR_DE_OFF_2nd_PL_Present_Theme' || 
$RecordType.DeveloperName == 'EUR_DE_ON_TMKT_Promo_Presentation' ) 
&& ISPICKVAL(EUR_CRM_Status__c,'Presented')) || 
(($RecordType.DeveloperName == 'EUR_DE_ON_TMKT_Promo_Confirm_Participation' ) 
&& ISPICKVAL(EUR_CRM_Status__c,'Participating'))

Is Successful?

EUR_CRM_Is_Successful__c

*/
public class EUR_CRM_DE_IsSucccessfulHandler  extends EUR_CRM_TriggerAbstract {

    public EUR_CRM_DE_IsSucccessfulHandler(){
        super('EUR_CRM_DE_VisitActionHandler');
    }
    private Set<String> YES_RecordTypes  = new Set<String>{
        'EUR_DE_OFF_2nd_PL_Do_TMKT_Doc',
        'DE_OFF_Ad_hoc_Agree_To_Buy',
        'EUR_DE_OFF_Leaflet_Campaign_Sell_In_Qty',
        'EUR_DE_OFF_Tasting_Discussion' 
    };
    private Set<String> LISTED_RecordTypes  = new Set<String>{
        'EUR_DE_OFF_Dist_Drive_Listing_Check'     
    };
    private Set<String> PARTICIPATING_RecordTypes  = new Set<String>{
        'EUR_DE_ON_TMKT_Promo_Confirm_Participation' 
    };
    private Set<String> PRESENTED_RecordTypes  = new Set<String>{
        'EUR_DE_ON_TMKT_Promo_Presentation'
    };
    private Set<String> QTY_CONFIRMED_RecordTypes  = new Set<String>{
        'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Carton',   
        'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Gondelkopf',
        'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Promo_Display',
        'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Razz_Fazz',
        'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Standard',
        'EUR_DE_OFF_2nd_PL_Sell_In_Qty_Theme',
        'EUR_DE_OFF_Ad_Hoc_Sell_In_Qty',
        'EUR_DE_OFF_Leaflet_Campaign_Sell_In_Qty',
        'EUR_DE_OFF_Sales_Drive_SKU_Bottles_Sell_In_Qty',  
        'EUR_DE_OFF_Sales_Drive_SKU_Displays_Sell_In_Qty',
        'EUR_DE_OFF_Sales_Drive_Sell_In_Qty', 
        'EUR_DE_OFF_Tasting_Sell_In_Qty',  
        'EUR_DE_OFF_Trade_Fair_Sell_In_Qty',
        'EUR_DE_ON_TMKT_Promo_Enter_Sell_In_Qty', 
        'EUR_DE_OFF_2nd_PL_Present_Theme' 
   };
    
    private final String LISTED = 'Listed';
    private final String PARTICIPATING = 'Participating';
    private final String PRESENTED = 'Presented';
    private final String YES = 'Yes';
    private final String QTY_CONFIRMED = 'Qty Confirmed'; 
    
    public override void executeTriggerAction(TriggerAction tAction, List<sObject> sObjList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        List<Recordtype> visitActionRecordTypes = Global_RecordTypeCache.getRtList('EUR_CRM_Visit_Action__c');
        Map<Id,Recordtype> visitActionRecordTypesMap = new Map<Id,Recordtype>();        
        
        for(Recordtype rt : visitActionRecordTypes ){
           visitActionRecordTypesMap.put(rt.id,rt);
        } 
        
        for(EUR_CRM_Visit_Action__c visitAction: (List<EUR_CRM_Visit_Action__c>) sObjList){
            String recordTypeName = visitActionRecordTypesMap.get(visitAction.recordtypeid).developername;
            
           // if(Trigger.isInsert || 
           //   (Trigger.IsUpdate && 
           //      visitAction.EUR_CRM_Status__c != ((EUR_CRM_Visit_Action__c) oldMap.get(visitAction.id)).EUR_CRM_Status__c)){          
           
                if(YES_RecordTypes.contains(recordTypeName) && visitAction.EUR_CRM_Status__c == YES){
                    visitAction.EUR_CRM_Is_Successful__c = true;
                }else  if(PRESENTED_RecordTypes.contains(recordTypeName) && visitAction.EUR_CRM_Status__c == PRESENTED ){
                    visitAction.EUR_CRM_Is_Successful__c = true;
                }else  if(LISTED_RecordTypes.contains(recordTypeName) && visitAction.EUR_CRM_Status__c == LISTED ){
                    visitAction.EUR_CRM_Is_Successful__c = true;
                }else  if(QTY_CONFIRMED_RecordTypes.contains(recordTypeName) && visitAction.EUR_CRM_Status__c == QTY_CONFIRMED ){
                    visitAction.EUR_CRM_Is_Successful__c = true;
                }else  if(PARTICIPATING_RecordTypes.contains(recordTypeName) && visitAction.EUR_CRM_Status__c == PARTICIPATING ){
                    visitAction.EUR_CRM_Is_Successful__c = true;
                }else{
                     visitAction.EUR_CRM_Is_Successful__c = false;
                }
          //  }
        }
    }

}