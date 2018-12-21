/*********************************************************************************
 * Name:ASI_CRM_SG_CheckSKUPriceCost_Batch
 * Description: Check if each type of price/cost exist in SKU, and send email
 * Test Class: ASI_CRM_SG_CheckSKUPriceCost_Test
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2017-01-25       Laputa: Vincent		     Created
 * 2017-11-29		Laputa: Vincent			[VL 1.0] Handle new price/cost
 * 2018-03-12		Laputa: Vincent			[VL 2.0] P4.2, check special incentive price
 * 2018-04-04		Wilken					[WL 3.0] Requested by Darren Wong to remove checking for PRS-WS and WS-OT price
 * 2018-04-28		Laputa: Vincent			[VL 4.0] P4.2, indicate if SKU has enough prices for WS back rebates
*********************************************************************************/
global class ASI_CRM_SG_CheckSKUPriceCost_Batch implements Database.Batchable<sObject>, Database.stateful {

    private static final String SKU_RECORD_TYPE = 'ASI_CRM_SG_SKU';
    /* [VL 4.0] BEGIN */
    private static final String OPENOUTLETPRICE_RTDEVELOPERNAME = 'ASI_CRM_SG_Open_Outlet_Price_Per_Bottle';
    private static final String INCENTIVEPRICE_RTDEVELOPERNAME = 'ASI_CRM_SG_CRM_Incentive_Price_Per_Bottle';
    /* [VL 4.0] END */

    public static final map<String, String> SKU_PC_RECORD_TYPE = new map<String, String>{
		/*[WL 3.0] BEGIN*/
        //'ASI_CRM_SG_Selling_Price_Per_Bottle_PRS_Wholesaler'=>'PRS-WS Price',
        //'ASI_CRM_SG_Selling_Price_Per_Bottle_Wholesaler_On_Trade'=>'WS-OT Price',
		/*[WL 3.0] END*/
		
        /*
		'ASI_CRM_SG_IGC'=>'IGC Cost',
		*/
        'ASI_CRM_SG_CRM_Duty_Per_Bottle'=>'Duty Cost',
        'ASI_CRM_SG_CRM_FOB_Per_Bottle'=>'FOB Cost',
        'ASI_CRM_SG_CRM_Handling_Cost_Per_Bottle'=>'Handling Cost',
        'ASI_CRM_SG_CRM_Standard_Cost_Per_Bottle'=>'Standard Cost'     
    /* [VL 1.0] BEGIN */
        ,'ASI_CRM_SG_RTM_Wholesaler_Price_Per_Bottle'=>'PRS-WS Price (RTM)'
        ,'ASI_CRM_SG_Open_Outlet_Price_Per_Bottle'=>'WS-OT Price (RTM)'
        ,'ASI_CRM_SG_CRM_Incentive_Price_Per_Bottle'=>'Incentive Price (RTM)'
    /* [VL 1.0] END */         
    /* [VL 2.0] BEGIN */
	//  ,'ASI_CRM_SG_Quarterly_Promo_Price'=>'Quarterly Promo Price'
    /* [VL 2.0] END */       
    };

    global map<string, map<string, boolean>> map_sku_price_exist;
    global map<string, ASI_MFM_SKU_Code__c> map_sku;
    
    private static final String SUBJECT = 'Missing JDE SKU Price/Cost';
    private static final String TABLE_START = '<table border="1">';
    private static final String TABLE_END = '</table>';
	/*
    private static final String TABLE_THEAD = '<thead><tr><th>SKU</th><th>PRS-WS Price</th><th>WS-OT Price</th><th>IGC Cost</th><th>Duty Cost</th><th>FOB Cost</th><th>Handling Cost</th><th>Standard Cost</th></tr></thead>';
    */ 
	
    private static final String TABLE_THEAD = '<thead><tr><th>SKU</th><th>PRS-WS Price</th><th>WS-OT Price</th><th>Duty Cost</th><th>FOB Cost</th><th>Handling Cost</th><th>Standard Cost</th></tr></thead>';
    
	private static final String TABLE_TBODY_START = '<tbody>';
    private static final String TABLE_TBODY_END = '</tbody>';
    private static final String TABLE_ROW_START = '<tr>';
    private static final String TABLE_ROW_END = '</tr>';
    private static final String TABLE_CELL_START = '<td>';
    private static final String TABLE_CELL_END = '</td>';
    private static final String TICK_SYMBOL = '&#10004;';
    
	/*
    private static final String EXCEL_HEADER = 'SKU Code,Description,PRS-WS Price,WS-OT Price,IGC Cost,Duty Cost,FOB Cost,Handling Cost,Standard Cost\n';
	*/
    /* [VL 1.0] BEGIN */
	/*
    private static final String EXCEL_HEADER = 'SKU Code,Description,PRS-WS Price,WS-OT Price,Duty Cost,FOB Cost,Handling Cost,Standard Cost\n';
	*/
    /* [VL 2.0] BEGIN */
	/*
	private static final String EXCEL_HEADER = 'SKU Code,Description,PRS-WS Price,WS-OT Price,Duty Cost,FOB Cost,Handling Cost,Standard Cost,PRS-WS Price (RTM),WS-OT Price (RTM),Incentive Price (RTM)\n';
    */
	
	/*[WL 3.0] BEGIN*/
	//private static final String EXCEL_HEADER = 'SKU Code,Description,PRS-WS Price,WS-OT Price,Duty Cost,FOB Cost,Handling Cost,Standard Cost,PRS-WS Price (RTM),WS-OT Price (RTM),Incentive Price (RTM),Quarterly Promo Price\n';
	private static final String EXCEL_HEADER = 'SKU Code,Description,Duty Cost,FOB Cost,Handling Cost,Standard Cost,PRS-WS Price (RTM),WS-OT Price (RTM),Incentive Price (RTM)\n';
	/*[WL 3.0] END*/
	
	/* [VL 2.0] END */
	/* [VL 1.0] END */  
    private static final String EXCEL_COMMA = ',';
    private static final String EXCEL_EOL = '\n';
    private static final String EXCEL_EMAIL_BODY = 'Please refer to excel of the missing price / cost.';
    private static final String EXCEL_TICK_SYMBOL = 'v';
    private static final String EXCEL_ESCAPE = '\uFEFF';

    global Database.QueryLocator start(Database.BatchableContext contextInstance) {
        set<string> rtList = SKU_PC_RECORD_TYPE.keySet();
        this.map_sku_price_exist = new map<string, map<string, boolean>>();
        this.map_sku = new map<string, ASI_MFM_SKU_Code__c>();
        string query = 
            'select name, ASI_MFM_SKU_Code__c, ASI_MFM_SKU_Description__c, ' +
            '(select recordtype.developername ' +
            ' from ASI_CRM_IGCs__r ' +
            ' where ASI_CRM_EffectiveDate__c <= today ' +
            ' and recordtype.developername in :rtList) ' +
            'from ASI_MFM_SKU_Code__c ' +
            'where ASI_HK_CRM_Active__c = true and ASI_HK_CRM_IsPOSProduct__c = false and recordtype.developername = :SKU_RECORD_TYPE and ASI_HK_CRM_Available_Quantity__c > 0 ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext contextInstance, List<Sobject> sObjectList) { 

        List<ASI_MFM_SKU_Code__c> list_sku = (List<ASI_MFM_SKU_Code__c>) sObjectList;

        for (ASI_MFM_SKU_Code__c sku : list_sku){
            map<string, boolean> map_price_exist = new map<string, boolean>();
            if (this.map_sku_price_exist.containsKey(sku.id)){
                map_price_exist = this.map_sku_price_exist.get(sku.id);
            } else {
                for (string rt : SKU_PC_RECORD_TYPE.keySet()){
                    map_price_exist.put(SKU_PC_RECORD_TYPE.get(rt), false);
                }
            }            
            /* [VL 4.0] BEGIN */
            boolean missingOpenOutletPrice = true;
            boolean missingIncentivePrice = true;
            /* [VL 4.0] BEGIN */
            for (ASI_CRM_MY_SKUPriceCost__c pc: sku.ASI_CRM_IGCs__r){
                map_price_exist.put(SKU_PC_RECORD_TYPE.get(pc.recordtype.developername), true);
                if(pc.recordtype.developername == OPENOUTLETPRICE_RTDEVELOPERNAME){
                    missingOpenOutletPrice = false;
                }else
                if(pc.recordtype.developername == INCENTIVEPRICE_RTDEVELOPERNAME){
                    missingIncentivePrice = false;
                }
            }
            /* [VL 4.0] BEGIN */
            sku.ASI_CRM_Missing_PricesForWSBackRebate__c = (missingOpenOutletPrice || missingIncentivePrice);
            /* [VL 4.0] BEGIN */
            this.map_sku_price_exist.put(sku.id,map_price_exist);
            this.map_sku.put(sku.id,sku);
        }
        /* [VL 4.0] BEGIN */
        update list_sku;
        /* [VL 4.0] BEGIN */
    }

    global void finish(Database.BatchableContext contextInstance) {
        system.debug(this.map_sku_price_exist);
        String table_content = '';
        for (string sku_id : this.map_sku_price_exist.keySet()){
            map<string, boolean> map_price_exist = this.map_sku_price_exist.get(sku_id);
            integer count = 0;
            string row = TABLE_ROW_START;
            row += TABLE_CELL_START + sku_id + TABLE_CELL_END;
            String rowExcel = '\''+this.map_sku.get(sku_id).ASI_MFM_SKU_Code__c + EXCEL_COMMA + this.map_sku.get(sku_id).ASI_MFM_SKU_Description__c + EXCEL_COMMA;
            for (string rt : map_price_exist.keyset()){
                row += TABLE_CELL_START;
                if (map_price_exist.get(rt)){
                    row += TICK_SYMBOL;
                	rowExcel += EXCEL_TICK_SYMBOL;
                } else {
                    count++;
                }
                row += TABLE_CELL_END;
                rowExcel += EXCEL_COMMA;
            }
            row += TABLE_ROW_END;
            rowExcel += EXCEL_EOL;
            
            //table_content += count > 0 ? row : '';
            table_content += count > 0 ? rowExcel : '';
        }
        
        if (table_content<>''){
            sendEmail(table_content);
        }
    }
    
    public void sendEmail(string content){
        try {
            Messaging.SingleEmailMessage emailPlaceHolder = new Messaging.SingleEmailMessage();
            
            list<string> list_email = new list<string>();
            list<string> list_user = new list<string>();
            
            for (GroupMember u : [select userOrGroupId from GroupMember where group.developername = 'ASI_CRM_SG_SKU_Price_Cost_Admin']){
                list_user.add(u.userOrGroupId);
            }
            
            for (user u : [select email from user where id in :list_user]){
                list_email.add(u.email);
            }
            
            Messaging.EmailFileAttachment excelReport = new Messaging.EmailFileAttachment();
            blob excel = blob.valueOf(EXCEL_ESCAPE + EXCEL_HEADER + content);
            excelReport.setBody(excel);
            DateTime d = Date.Today();
            excelReport.setFileName('MissingJDEPriceCost'+d.format('yyyyMMdd')+'.csv');
            emailPlaceHolder.setFileAttachments(new Messaging.EmailFileAttachment[]{excelReport});
            
            emailPlaceHolder.setToAddresses(list_email);
            emailPlaceHolder.setSubject(SUBJECT);
            emailPlaceHolder.setHtmlBody(
                //TABLE_START + TABLE_THEAD + TABLE_TBODY_START + content + TABLE_TBODY_END + TABLE_END
                EXCEL_EMAIL_BODY 
            );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailPlaceHolder });
        } catch(Exception exceptionInstance) {
            System.debug('------ exceptionInstance ------ : ' + exceptionInstance.getMessage());
        }
    }
    
}