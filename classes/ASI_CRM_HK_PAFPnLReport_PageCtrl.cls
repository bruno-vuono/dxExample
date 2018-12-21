/*********************************************************************************
 * Name: ASI_CRM_HK_PAFPnLReport_PageCtrl
 * Description: Controller class for ASI_CRM_HK_PAFPnLReport_Page
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-05-02       Vincent Lam             Created       
*/
public class ASI_CRM_HK_PAFPnLReport_PageCtrl {
   
    public Id headerId {get; set;}
	public String pafId {get; set;}
    public String fileId;
    public String parentFileId;
    public String returnFileId {get{return fileId;}}
	public String resultHTML {get; set;}


    public ASI_CRM_HK_PAFPnLReport_PageCtrl() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        pafId = params.get('id');
        fileId = params.get('fileId');
		if(pafId != null){
			init();
		} else {
			buildResult();
		}
        
    }
    
	private class SKUWrapper{
		private string pafId {get;set;}
		private string skuId {get;set;}
		private decimal totalBottle {get;set;}
		private decimal price {get;set;}
		private decimal bottleSize {get;set;}
		private decimal volume9L {get;set;}
        private String SubBrandId  {get;set;}
        private String BrandId  {get;set;}
        
		private SKUWrapper(string pafId, string skuId, decimal totalBottle, decimal price, decimal bottleSize, String SubBrandId,String BrandId){
			this.pafId = pafId;
			this.skuId = skuId;
			this.totalBottle = totalBottle;
			this.price = price;
			this.bottleSize = bottleSize;
            this.SubBrandId = SubBrandId;
            this.BrandId = BrandId;
			this.volume9L = 0;
		}
	}
	
	private class DetailWrapper{
		
		private List<ASI_HK_CRM_Pre_Approval_Form_Item__c> list_pafl {get;set;}
        private List<AggregateResult> PnL_Cost_List {get;set;} {PnL_Cost_List= new List<AggregateResult> ();}
        
		private Map<string, SKUWrapper> map_sku_skuW {get;set;}
		private Map<string, boolean> map_paf_includeVolume {get;set;}
		private String key {get;set;}
		private Date EndDate {get;set;}
		private decimal A01 {get;set;}
		private decimal A02 {get;set;}
		private decimal A03 {get;set;}
		private decimal A04 {get;set;}
		private decimal A05 {get;set;}
		private decimal A06 {get;set;}
		private decimal A07 {get;set;}
		private decimal A08 {get;set;}
		private decimal A09 {get;set;}
		private decimal A10 {get;set;}
		private decimal A11 {get;set;}
		private decimal A12 {get;set;}
		private decimal A13 {get;set;}
		private decimal A14 {get;set;}
		private decimal A15 {get;set;}
		private decimal A16 {get;set;}
		private decimal B01 {get;set;}
		private decimal B02 {get;set;}
		private decimal B03 {get;set;}
		private decimal B04 {get;set;}
		private decimal B05 {get;set;}
		private decimal B06 {get;set;}
		private decimal B07 {get;set;}
		private decimal B08 {get;set;}
		private decimal B09 {get;set;}
		private decimal B10 {get;set;}
		private decimal B11 {get;set;}
		private decimal B12 {get;set;}
		private decimal B13 {get;set;}
		private decimal SalesValue {get;set;}
		private decimal TotalInvestmentBeforeNetSales {get;set;}
		private decimal NetSales {get;set;}
		private decimal Cost {get;set;}
		private decimal CM {get;set;}
		private decimal TotalInvestmentAfterNetSales {get;set;}
		private decimal CAAP {get;set;}
		private decimal TotalInvestment {get;set;}
		private decimal TotalInvestmentPercentOfSalesValues {get;set;}
		private decimal ROIPercent {get;set;}
		private decimal VariableInvestment {get;set;}
		private decimal FixedInvestment {get;set;}
		private decimal Volume9L {get;set;}
		private decimal NNPper9L {get;set;}
		private Map<string, list<ASI_HK_CRM_Pre_Approval_Form_Item__c>> map_pafId_paflAllProduct {get;set;}
		private set<string> MechanicsNotSKU = new set<string>{'A01','A08'};
		
		private DetailWrapper(string key){
			this(key, null);
		}
		
		private DetailWrapper(string key, Map<string, boolean> map_paf_includeVolume){
			this.key = key;
			this.map_paf_includeVolume = map_paf_includeVolume;
			this.list_pafl = new List<ASI_HK_CRM_Pre_Approval_Form_Item__c>();
			this.map_sku_skuW = new map<string, SKUWrapper>();
			resetNumbers();
		}
		
        
        public void addPnLCostLine(AggregateResult PnLCostLine){
            this.PnL_Cost_List.add(PnLCostLine);
        }
        
		public void addLine(ASI_HK_CRM_Pre_Approval_Form_Item__c pafl){
            this.list_pafl.add(pafl);
            
			/*
            date inputDate = pafl.ASI_HK_CRM_Pre_Approval_Form_Lookup__r.ASI_HK_CRM_Adjusted_End_Date__c!=null?pafl.ASI_HK_CRM_Pre_Approval_Form_Lookup__r.ASI_HK_CRM_Adjusted_End_Date__c:date.today() ;
            
            Date LastDateOfThisFY = Date.newinstance(inputDate.year(), 6,30);
            if(inputDate.month() > 7){
                LastDateOfThisFY = LastDateOfThisFY.addYears(1);
            }
            this.EndDate=LastDateOfThisFY;
			*/
		}
		private void resetNumbers(){
			A01 = 0;
			A02 = 0;
			A03 = 0;
			A04 = 0;
			A05 = 0;
			A06 = 0;
			A07 = 0;
			A08 = 0;
			A09 = 0;
			A10 = 0;
			A11 = 0;
			A12 = 0;
			A13 = 0;
			A14 = 0;
			A15 = 0;
			A16 = 0;
			B01 = 0;
			B02 = 0;
			B03 = 0;
			B04 = 0;
			B05 = 0;
			B06 = 0;
			B07 = 0;
			B08 = 0;
			B09 = 0;
			B10 = 0;
			B11 = 0;
			B12 = 0;
			B13 = 0;
			SalesValue = 0;
			TotalInvestmentBeforeNetSales = 0;
			NetSales = 0;
			Cost = 0;
			CM = 0;
			TotalInvestmentAfterNetSales = 0;
			CAAP = 0;
			TotalInvestment = 0;
			TotalInvestmentPercentOfSalesValues = 0;
			ROIPercent = 0;
			VariableInvestment = 0;
			FixedInvestment = 0;
			Volume9L = 0;
			NNPper9L = 0;
			
		}
		public void addAllProductLine(Map<string, list<ASI_HK_CRM_Pre_Approval_Form_Item__c>> map_pafId_paflAllProduct){
			this.map_pafId_paflAllProduct = map_pafId_paflAllProduct;
		}
		public void getSalesTarget(){
			for(ASI_HK_CRM_Pre_Approval_Form_Item__c pafl : list_pafl){
				string skuId = pafl.ASI_HK_CRM_SKU_Lookup__c;
				string subBrandId = pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c;
				string pafId = pafl.ASI_HK_CRM_Pre_Approval_Form_Lookup__c;
				string key = pafId + '_' + subBrandId;
				if(!map_sku_skuW.containsKey(key) && !MechanicsNotSKU.contains(pafl.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Code__c)){
					SKUWrapper w = new SKUWrapper(pafId, skuId, pafl.ASI_HK_CRM_Target_Volume_Qty__c,
                                                  pafl.ASI_HK_CRM_Price__c, 
                                                  pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_HK_CRM_Std_Bottle_Size__c,pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c,
                                                 pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__c);
					map_sku_skuW.put(key, w);
				}
			}
		}
		public void getSalesTargetActual(){
			for(AggregateResult pnl :PnL_Cost_List){
				string subBrandId = String.valueOf(pnl.get('subBrandId'));
				string brandId = String.valueOf(pnl.get('brandId'));
				string key = subBrandId;
				if(!map_sku_skuW.containsKey(key)){
					SKUWrapper w = new SKUWrapper(null, null, 0,
                                                  0, 
                                                  0, subBrandId,
                                                 brandId);
					map_sku_skuW.put(key, w);
				}
			}
		}
        
        public void calculationGroupByTypeActual(Map<String,ASI_CRM_PnL_Cost__c> PnLCostMap, date LastDateOfThisFY){
            for(AggregateResult PnLCost:PnL_Cost_List){
				string subBrandId = String.valueOf(PnLCost.get('subBrandId'));
                String ObjectKey = String.valueOf(PnLCost.get('ObjectKey'));
                String lineType = String.valueOf(PnLCost.get('lineType'));
                Decimal volume9LFromPnl = 0;
                Decimal value = 0;
                if(lineType =='V'){
                    SKUWrapper w = map_sku_skuW.get(subBrandId);
					
					volume9LFromPnl = -(Decimal)PnLCost.get('volume9L'); // the volume 9L in data source is -ve...
					w.volume9L += volume9LFromPnl;
					Volume9L += volume9LFromPnl;
					
					/*
					Date LastDateOfLastFY = LastDateOfThisFY.addYears(-1);
					Decimal CostPer9L=0;
					if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfThisFY) )){
						CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfThisFY)  ).ASI_CRM_Cost_per_9L_YTD__c;
					}else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfLastFY) )){
						CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfLastFY) ).ASI_CRM_Cost_per_9L_YTD__c;
					}else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Budget_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfThisFY) )){
						CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Budget_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfThisFY) ).ASI_CRM_Cost_per_9L_YTD__c;
					}else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfThisFY) )){
						CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfThisFY)  ).ASI_CRM_Cost_per_9L_YTD__c;
					}else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfLastFY) )){
						CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfLastFY) ).ASI_CRM_Cost_per_9L_YTD__c;
					}else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Budget_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfThisFY) )){
						CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Budget_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfThisFY) ).ASI_CRM_Cost_per_9L_YTD__c;
					}
					
					Cost += volume9LFromPnl * CostPer9L;
					*/
                }
                if(lineType =='A' || lineType =='T'){
                    value = (Decimal)PnLCost.get('value'); 
					
					if(ObjectKey=='3010.000000' || ObjectKey=='3020.000000' || ObjectKey=='3030.000000' || ObjectKey=='3100.000000'){
						SalesValue -= value;// the value in data source is -ve...
					}else
					if(ObjectKey=='5245.010000' || ObjectKey=='5282.000000'){
						A01+=value;
					}else if(ObjectKey=='5210.SO1000' || ObjectKey=='5290.FG1000'){
						A02+=value;
					}else if(ObjectKey=='5275.000000'){
						A03+=value;
					}else if(ObjectKey=='5281.000000'){
						A04+=value;
					}else if(ObjectKey=='5245.000000'){
						A05+=value;
					}else if(ObjectKey=='5282.010000'){
						A06+=value;
					}else if(ObjectKey=='5282.020000'){
						A07+=value;
					}else if(ObjectKey=='5283.000000'){
						A08+=value;
					}else if(ObjectKey=='5282.030000'){
						A09+=value;
					}else if(ObjectKey=='5282.040000'){
						A16+=value;
					}else if(ObjectKey=='5265.020000' || ObjectKey=='5265.010000'){
						A10+=value;
					}else if(ObjectKey=='5275.000000'){
						A11+=value;
					}else if(ObjectKey=='5275.050000'){
						A12+=value;
					}else if(ObjectKey=='5275.010000'){
						A13+=value;
					}else if(ObjectKey=='5265.000000' || ObjectKey=='5260.000000'){
						A14+=value;
					}else if(ObjectKey=='5265.030000'){
						A15+=value;
					}else if(ObjectKey=='5280.000000'){
						A16+=value;
					}else if(ObjectKey=='5582.000000' || ObjectKey=='5582.010000'){
						B01+=value;
					}else if(ObjectKey=='5558.000000'){
						B02+=value;
					}else if(ObjectKey=='5556.010000' || ObjectKey=='5245.020000'){
						B03+=value;
					}else if(ObjectKey=='5551.000000'){
						B04+=value;
					}else if(ObjectKey=='5556.000000' || ObjectKey=='5559.020000'){
						B05+=value;
					}else if(ObjectKey=='5556.070000'){
						B06+=value;
					}else if(ObjectKey=='5559.010000' || ObjectKey=='5559.000000'){
						B07+=value;
					}else if(ObjectKey=='5581.000000'){
						B08+=value;
					}else if(ObjectKey=='5559.040000'){
						B09+=value;
					}else if(ObjectKey=='5651.000000'){
						B10+=value;
					}else if(ObjectKey=='5115.000000'){
						B11+=value;
					}else if(ObjectKey.startsWith('5111') || ObjectKey.startsWith('5112') || ObjectKey.startsWith('5113') || ObjectKey.startsWith('5114') || ObjectKey.startsWith('5116') || ObjectKey.startsWith('5117') || ObjectKey.startsWith('5118')){
						B12+=value;
					}else if(ObjectKey.startsWith('5171') || ObjectKey.startsWith('5172') || ObjectKey.startsWith('5173') || ObjectKey.startsWith('5174')){
						B13+=value;
					}
					// cost
					else if(ObjectKey.startsWith('4011') || ObjectKey.startsWith('4019') || ObjectKey.startsWith('5310') || ObjectKey.startsWith('5320') || ObjectKey.startsWith('5330')){
						Cost+=value;
					}

                }
                
            }
            
            
        }
        
        
        public void calculationGroupByType(){
			for(ASI_HK_CRM_Pre_Approval_Form_Item__c pafl : list_pafl){
				string skuId = pafl.ASI_HK_CRM_SKU_Lookup__c;
				string subBrandId = pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c;
				string pafId = pafl.ASI_HK_CRM_Pre_Approval_Form_Lookup__c;
				String key_map = pafId + '_' + subBrandId;
				decimal investedAmount = pafl.ASI_HK_CRM_Investment_Value__c;
				string mechanicCode = pafl.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Code__c;
				if(mechanicCode == 'A01'){
					
				} else if(mechanicCode == 'A02'){
					A02 += investedAmount;
					Decimal qty = pafl.ASI_HK_CRM_Investment_Value__c / pafl.ASI_HK_CRM_Price__c;
					map_sku_skuW.get(key_map).totalBottle += qty;
				} else
				if(mechanicCode == 'A03'){
					A03 += investedAmount;
				} else
				if(mechanicCode == 'A04'){
					A04 += investedAmount;
				} else
				if(mechanicCode == 'A05'){
					A05 += investedAmount;
				} else
				if(mechanicCode == 'A06'){
					A06 += investedAmount;
				} else
				if(mechanicCode == 'A07'){
					A07 += investedAmount;
				} else
				if(mechanicCode == 'A08'){
					
				} else
				if(mechanicCode == 'A09'){
					A09 += investedAmount;
				} else
				if(mechanicCode == 'A10'){
					A10 += investedAmount;
				} else
				if(mechanicCode == 'A11'){
					A11 += investedAmount;
					Decimal qty = pafl.ASI_HK_CRM_Investment_Value__c / pafl.ASI_HK_CRM_Price__c;
					map_sku_skuW.get(key_map).totalBottle += qty;
				} else
				if(mechanicCode == 'A12'){
					A12 += investedAmount;
				} else
				if(mechanicCode == 'A13'){
					A13 += investedAmount;
				} else
				if(mechanicCode == 'A14'){
					A14 += investedAmount;
				} else
				if(mechanicCode == 'A15'){
					A15 += investedAmount;
				} else
				if(mechanicCode == 'A16'){
					A16 += investedAmount;
				} else
				if(mechanicCode == 'B01'){
					B01 += investedAmount;
				} else
				if(mechanicCode == 'B02'){
					B02 += investedAmount;
				} else
				if(mechanicCode == 'B03'){
					B03 += investedAmount;
				} else
				if(mechanicCode == 'B04'){
					B04 += investedAmount;
				} else
				if(mechanicCode == 'B05'){
					B05 += investedAmount;
				} else
				if(mechanicCode == 'B06'){
					B06 += investedAmount;
				} else
				if(mechanicCode == 'B07'){
					B07 += investedAmount;
				} else
				if(mechanicCode == 'B08'){
					B08 += investedAmount;
				} else
				if(mechanicCode == 'B09'){
					B09 += investedAmount;
				} else
				if(mechanicCode == 'B10'){
					B10 += investedAmount;
				} else
				if(mechanicCode == 'B11'){
					B11 += investedAmount;
				} 
			}
		}
		public void calculationFinalize(Map<String,ASI_CRM_PnL_Cost__c> PnLCostMap, date LastDateOfThisFY){
            this.EndDate = LastDateOfThisFY;
			system.debug('** calculationFinalize **'+ this.EndDate);
            
			for(SKUWrapper w : map_sku_skuW.values()){
                system.debug(w.BrandId+'SubBrandId :  '+w.SubBrandId);
               	string PnLCostKey='';
                Date LastDateOfLastFY = this.EndDate.addYears(-1);
				Decimal CostPer9L=0;
                
                if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(this.EndDate) )){
                    CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(this.EndDate)  ).ASI_CRM_Cost_per_9L_YTD__c;
                }else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfLastFY) )){
                    CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(LastDateOfLastFY) ).ASI_CRM_Cost_per_9L_YTD__c;
                }else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Budget_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(this.EndDate) )){
                    CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Budget_Cost_Sub_Brand' + w.SubBrandId + string.valueOf(this.EndDate) ).ASI_CRM_Cost_per_9L_YTD__c;
                }else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(this.EndDate) )){
                    CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(this.EndDate)  ).ASI_CRM_Cost_per_9L_YTD__c;
                }else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfLastFY) )){
                    CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Actual_Cost_Brand' + w.BrandId + string.valueOf(LastDateOfLastFY) ).ASI_CRM_Cost_per_9L_YTD__c;
                }else if(PnLCostMap.containsKey( 'ASI_CRM_HK_Budget_Cost_Brand' + w.BrandId + string.valueOf(this.EndDate) )){
                    CostPer9L = PnLCostMap.get( 'ASI_CRM_HK_Budget_Cost_Brand' + w.BrandId + string.valueOf(this.EndDate) ).ASI_CRM_Cost_per_9L_YTD__c;
                }
                
				string pafId = w.pafId;
				if(map_paf_includeVolume.containsKey(pafId) && map_paf_includeVolume.get(pafId)){
					SalesValue += (w.totalBottle * w.price);
					Volume9L += (w.totalBottle * w.bottleSize / 900);
					Cost += (w.totalBottle * w.bottleSize / 900) * CostPer9L;
				}
				if(map_pafId_paflAllProduct.containsKey(pafId)){
					List<ASI_HK_CRM_Pre_Approval_Form_Item__c> list_pafl = map_pafId_paflAllProduct.get(pafId);
					for(ASI_HK_CRM_Pre_Approval_Form_Item__c pafl : list_pafl){
						string mechanicCode = pafl.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Code__c;
						if(mechanicCode == 'A01'){
							decimal convertedAmount = 0;
							if(pafl.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c != null){
								convertedAmount += w.totalBottle * pafl.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
							} else
							if(pafl.ASI_HK_CRM_Rebate_Disc_Percent__c != null){
								convertedAmount += w.totalBottle * w.price * pafl.ASI_HK_CRM_Rebate_Disc_Percent__c / 100;
							}
							A01 += convertedAmount;
						} else
						if(mechanicCode == 'A08'){
							decimal convertedAmount = 0;
							if(pafl.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c != null){
								convertedAmount += w.totalBottle * pafl.ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c;
							} else
							if(pafl.ASI_HK_CRM_Rebate_Disc_Percent__c != null){
								convertedAmount += w.totalBottle * w.price * pafl.ASI_HK_CRM_Rebate_Disc_Percent__c / 100;
							}
							A08 += convertedAmount;
						}
					}
				}
			}
			
			TotalInvestmentBeforeNetSales = A01 + A02 + A03 + A04 + A05 + A06 + A07 + A08 + A09 + A10 + A11 + A12 + A13 + A14 + A15 + A16;
			NetSales = SalesValue - TotalInvestmentBeforeNetSales;
			NNPper9L = NetSales / (Volume9L == 0 ? 1 : Volume9L);
			//Cost = CostTemp;
			CM = NetSales + Cost;
			TotalInvestmentAfterNetSales = B01 + B02 + B03 + B04 + B05 + B06 + B07 + B08 + B09 + B10 + B11;
			CAAP = CM - TotalInvestmentAfterNetSales;
			TotalInvestment = TotalInvestmentBeforeNetSales + TotalInvestmentAfterNetSales;
			TotalInvestmentPercentOfSalesValues = TotalInvestment / (SalesValue == 0 ? 1 : SalesValue);
			ROIPercent = CAAP / (TotalInvestment == 0 ? 1 : TotalInvestment);
			VariableInvestment = A01 + A02 + A03 + A04 + A05 + A06 + A07 + A08 + A16;
			FixedInvestment = A09 + A10 + A11 + A12 + A13 + A14 + A15 + B01 + B02 + B03 + B04 + B05 + B06 + B07 + B08 + B09 + B10 + B11 + B12 + B13;
		}
		public void calculationFinalizeActual(){
			
			TotalInvestmentBeforeNetSales = A01 + A02 + A03 + A04 + A05 + A06 + A07 + A08 + A09 + A10 + A11 + A12 + A13 + A14 + A15 + A16;
			NetSales = SalesValue - TotalInvestmentBeforeNetSales;
			NNPper9L = NetSales / (Volume9L == 0 ? 1 : Volume9L);
			//Cost = CostTemp;
			CM = NetSales - Cost;
			TotalInvestmentAfterNetSales = B01 + B02 + B03 + B04 + B05 + B06 + B07 + B08 + B09 + B10 + B11;
			CAAP = CM - TotalInvestmentAfterNetSales;
			TotalInvestment = TotalInvestmentBeforeNetSales + TotalInvestmentAfterNetSales;
			TotalInvestmentPercentOfSalesValues = TotalInvestment / (SalesValue == 0 ? 1 : SalesValue);
			ROIPercent = CAAP / (TotalInvestment == 0 ? 1 : TotalInvestment);
			VariableInvestment = A01 + A02 + A03 + A04 + A05 + A06 + A07 + A08 + A16;
			FixedInvestment = A09 + A10 + A11 + A12 + A13 + A14 + A15 + B01 + B02 + B03 + B04 + B05 + B06 + B07 + B08 + B09 + B10 + B11 + B12 + B13;
		}
		private void unitInThousandField() {
			SalesValue = SalesValue/1000;
			A01 = A01/1000;
			A02 = A02/1000;
			A03 = A03/1000;
			A04 = A04/1000;
			A05 = A05/1000;
			A06 = A06/1000;
			A07 = A07/1000;
			A08 = A08/1000;
			A09 = A09/1000;
			A10 = A10/1000;
			A11 = A11/1000;
			A12 = A12/1000;
			A13 = A13/1000;
			A14 = A14/1000;
			A15 = A15/1000;
			A16 = A16/1000;
			B01 = B01/1000;
			B02 = B02/1000;
			B03 = B03/1000;
			B04 = B04/1000;
			B05 = B05/1000;
			B06 = B06/1000;
			B07 = B07/1000;
			B08 = B08/1000;
			B09 = B09/1000;
			B10 = B10/1000;
			B11 = B11/1000;
			B12 = B12/1000;
			B13 = B13/1000;
			TotalInvestmentBeforeNetSales = TotalInvestmentBeforeNetSales/1000;
			NetSales = NetSales/1000;
			Cost = Cost/1000;
			CM = CM/1000;
			TotalInvestmentAfterNetSales = TotalInvestmentAfterNetSales/1000;
			CAAP = CAAP/1000;
			TotalInvestment = TotalInvestment/1000;
			VariableInvestment = VariableInvestment/1000;
			FixedInvestment = FixedInvestment/1000;
			TotalInvestmentPercentOfSalesValues = TotalInvestmentPercentOfSalesValues*100;
			ROIPercent = ROIPercent*100;
		}
		private void roundUpField() {
			SalesValue = SalesValue.setScale(0);
			A01 = A01.setScale(0);
			A02 = A02.setScale(0);
			A03 = A03.setScale(0);
			A04 = A04.setScale(0);
			A05 = A05.setScale(0);
			A06 = A06.setScale(0);
			A07 = A07.setScale(0);
			A08 = A08.setScale(0);
			A09 = A09.setScale(0);
			A10 = A10.setScale(0);
			A11 = A11.setScale(0);
			A12 = A12.setScale(0);
			A13 = A13.setScale(0);
			A14 = A14.setScale(0);
			A15 = A15.setScale(0);
			A16 = A16.setScale(0);
			B01 = B01.setScale(0);
			B02 = B02.setScale(0);
			B03 = B03.setScale(0);
			B04 = B04.setScale(0);
			B05 = B05.setScale(0);
			B06 = B06.setScale(0);
			B07 = B07.setScale(0);
			B08 = B08.setScale(0);
			B09 = B09.setScale(0);
			B10 = B10.setScale(0);
			B11 = B11.setScale(0);
			B12 = B12.setScale(0);
			B13 = B13.setScale(0);
			TotalInvestmentBeforeNetSales = TotalInvestmentBeforeNetSales.setScale(0);
			NetSales = NetSales.setScale(0);
			Cost = Cost.setScale(0);
			CM = CM.setScale(0);
			TotalInvestmentAfterNetSales = TotalInvestmentAfterNetSales.setScale(0);
			CAAP = CAAP.setScale(0);
			TotalInvestment = TotalInvestment.setScale(0);
			VariableInvestment = VariableInvestment.setScale(0);
			FixedInvestment = FixedInvestment.setScale(0);
			TotalInvestmentPercentOfSalesValues = TotalInvestmentPercentOfSalesValues.setScale(2);
			ROIPercent = ROIPercent.setScale(2);
			Volume9L = Volume9L.setScale(1);
			NNPper9L = NNPper9L.setScale(2);
		}
		private void roundUpFieldToZero() {
			SalesValue = SalesValue.setScale(0);
			A01 = A01.setScale(0);
			A02 = A02.setScale(0);
			A03 = A03.setScale(0);
			A04 = A04.setScale(0);
			A05 = A05.setScale(0);
			A06 = A06.setScale(0);
			A07 = A07.setScale(0);
			A08 = A08.setScale(0);
			A09 = A09.setScale(0);
			A10 = A10.setScale(0);
			A11 = A11.setScale(0);
			A12 = A12.setScale(0);
			A13 = A13.setScale(0);
			A14 = A14.setScale(0);
			A15 = A15.setScale(0);
			A16 = A16.setScale(0);
			B01 = B01.setScale(0);
			B02 = B02.setScale(0);
			B03 = B03.setScale(0);
			B04 = B04.setScale(0);
			B05 = B05.setScale(0);
			B06 = B06.setScale(0);
			B07 = B07.setScale(0);
			B08 = B08.setScale(0);
			B09 = B09.setScale(0);
			B10 = B10.setScale(0);
			B11 = B11.setScale(0);
			B12 = B12.setScale(0);
			B13 = B13.setScale(0);
			TotalInvestmentBeforeNetSales = TotalInvestmentBeforeNetSales.setScale(0);
			NetSales = NetSales.setScale(0);
			Cost = Cost.setScale(0);
			CM = CM.setScale(0);
			TotalInvestmentAfterNetSales = TotalInvestmentAfterNetSales.setScale(0);
			CAAP = CAAP.setScale(0);
			TotalInvestment = TotalInvestment.setScale(0);
			VariableInvestment = VariableInvestment.setScale(0);
			FixedInvestment = FixedInvestment.setScale(0);
			TotalInvestmentPercentOfSalesValues = TotalInvestmentPercentOfSalesValues.setScale(0);
			ROIPercent = ROIPercent.setScale(0);
			Volume9L = Volume9L.setScale(0);
			NNPper9L = NNPper9L.setScale(0);
		}

	}
	
    //Inner class for storing contract comparison result
    private class ContractComparisonResultWrapper {
		
		private boolean isCompare {get;set;}
		private string volumeDisplay {get;set;}
		private string financeDisplay {get;set;}
		private string nnpDisplay {get;set;}
		private integer numberOfMonthToDisplay {get;set;}
		private string startDateToDisplay {get;set;}
		private string endDateToDisplay {get;set;}
		private string customerName {get;set;}
		private string nameOfPAF {get;set;}
		private date LastDateOfThisFY {get;set;}
		private map<string, ASI_CRM_PnL_Cost__c> map_PnLCost {get;set;}
		private ASI_HK_CRM_Pre_Approval_Form__c proposedPAF {get;set;}
        private String sectionName {get;set;}
        private Map<decimal, SectionWrapper> subBrandSectionMap {get;set;}
		private map<string, DetailWrapper> map_type_dW {get;set;}
		private Map<string, boolean> map_paf_includeVolume {get;set;}
		private Map<string, list<ASI_HK_CRM_Pre_Approval_Form_Item__c>> map_pafId_paflAllProduct {get;set;}
		private set<string> MechanicsNotSKU = new set<string>{'A01','A08'};
		
		private Boolean isBaseContract {get; set;}
        
        private ContractComparisonResultWrapper(String sectionName, Boolean isBaseContract, ASI_HK_CRM_Pre_Approval_Form__c proposedPAF, Map<decimal, SectionWrapper> subBrandSectionMap, List<AggregateResult> PnLCostList, map<string, ASI_CRM_PnL_Cost__c> map_PnLCost ){
            this.sectionName = sectionName;
			this.isCompare = false;
			this.proposedPAF = proposedPAF;
			this.isBaseContract = isBaseContract;
			this.subBrandSectionMap = subBrandSectionMap;
            this.map_type_dW = new map<string, DetailWrapper>();
			//this.map_pafId_paflAllProduct = new Map<string, list<ASI_HK_CRM_Pre_Approval_Form_Item__c>>();
			
			//getCost(proposedPAF.ASI_CRM_Ref_Start_Date__c);
			this.map_PnLCost = map_PnLCost;
			setHeader();
            setActualValue(PnLCostList, subBrandSectionMap);
        }
            
        private ContractComparisonResultWrapper(String sectionName, Boolean isBaseContract, ASI_HK_CRM_Pre_Approval_Form__c proposedPAF, list<ASI_HK_CRM_Pre_Approval_Form__c> list_paf, Map<decimal, SectionWrapper> subBrandSectionMap, Map<string, boolean> map_paf_includeVolume, map<string, ASI_CRM_PnL_Cost__c> map_PnLCost) {
            this.sectionName = sectionName;
			this.isCompare = false;
			this.proposedPAF = proposedPAF;
			this.isBaseContract = isBaseContract;
			this.subBrandSectionMap = subBrandSectionMap;
			this.map_paf_includeVolume = map_paf_includeVolume;
			this.map_type_dW = new map<string, DetailWrapper>();
			this.map_pafId_paflAllProduct = new Map<string, list<ASI_HK_CRM_Pre_Approval_Form_Item__c>>();
            
			//getCost(proposedPAF.ASI_HK_CRM_Adjusted_Start_Date__c);
			this.map_PnLCost = map_PnLCost;
			setHeader();
            setValue(list_paf, subBrandSectionMap);
        }
		
        private ContractComparisonResultWrapper(String sectionName, ContractComparisonResultWrapper wrapperToCompare, ContractComparisonResultWrapper wrapperToBeCompared) {
			this.sectionName = sectionName;
            this.isCompare = true;
			this.map_type_dW = new map<string, DetailWrapper>();
            
            setValueCompare(wrapperToCompare, wrapperToBeCompared);
        }
		
		private void setHeader(){
			this.volumeDisplay = 'Volume';
			this.financeDisplay = 'HKD (\'000)';
			this.nnpDisplay = 'Per 9L Net Selling Price';
			
			Date inputDate = proposedPAF.ASI_HK_CRM_Adjusted_Start_Date__c;
			this.LastDateOfThisFY = Date.newinstance(inputDate.year(), 6,30);
			if(inputDate.month() >= 7){
				this.LastDateOfThisFY = LastDateOfThisFY.addYears(1);
			}
			
			ASI_HK_CRM_Pre_Approval_Form__c paf = this.proposedPAF;
			
			this.nameOfPAF = '';
			if(this.sectionName == 'Proposed'){
				this.nameOfPAF = paf.Name;
				this.startDateToDisplay = formatDate(paf.ASI_HK_CRM_Adjusted_Start_Date__c);
				this.endDateToDisplay = formatDate(paf.ASI_HK_CRM_Adjusted_End_Date__c);
				this.numberOfMonthToDisplay = paf.ASI_HK_CRM_Adjusted_Start_Date__c.monthsBetween(paf.ASI_HK_CRM_Adjusted_End_Date__c) + 1;
				this.customerName = paf.ASI_HK_CRM_PAF_Customer__r.Name;
			}else
			if(this.sectionName == 'Current'){
				date minStartDate;
				date maxEndDate;
				if(paf.ASI_CRM_HK_PAF_no__c != null){
					this.nameOfPAF += paf.ASI_CRM_HK_PAF_no__r.Name + ', ';
					if(minStartDate == null || paf.ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_Adjusted_Start_Date__c < minStartDate) minStartDate = paf.ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_Adjusted_Start_Date__c;
					if(maxEndDate == null || paf.ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_Adjusted_End_Date__c > maxEndDate) maxEndDate = paf.ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_Adjusted_End_Date__c;
					this.customerName = paf.ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_PAF_Customer__r.Name;
				}
				if(paf.ASI_CRM_HK_PAF_no_2__c != null){
					this.nameOfPAF += paf.ASI_CRM_HK_PAF_no_2__r.Name + ', ';
					if(minStartDate == null || paf.ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_Adjusted_Start_Date__c < minStartDate) minStartDate = paf.ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_Adjusted_Start_Date__c;
					if(maxEndDate == null || paf.ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_Adjusted_End_Date__c > maxEndDate) maxEndDate = paf.ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_Adjusted_End_Date__c;
				}
				if(paf.ASI_CRM_HK_PAF_no_3__c != null){
					this.nameOfPAF += paf.ASI_CRM_HK_PAF_no_3__r.Name + ', ';
					if(minStartDate == null || paf.ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_Adjusted_Start_Date__c < minStartDate) minStartDate = paf.ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_Adjusted_Start_Date__c;
					if(maxEndDate == null || paf.ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_Adjusted_End_Date__c > maxEndDate) maxEndDate = paf.ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_Adjusted_End_Date__c;
				}
				if(paf.ASI_CRM_HK_PAF_no_4__c != null){
					this.nameOfPAF += paf.ASI_CRM_HK_PAF_no_4__r.Name + ', ';
					if(minStartDate == null || paf.ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_Adjusted_Start_Date__c < minStartDate) minStartDate = paf.ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_Adjusted_Start_Date__c;
					if(maxEndDate == null || paf.ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_Adjusted_End_Date__c > maxEndDate) maxEndDate = paf.ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_Adjusted_End_Date__c;
				}
				if(paf.ASI_CRM_HK_PAF_no_5__c != null){
					this.nameOfPAF += paf.ASI_CRM_HK_PAF_no_5__r.Name + ', ';
					if(minStartDate == null || paf.ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_Adjusted_Start_Date__c < minStartDate) minStartDate = paf.ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_Adjusted_Start_Date__c;
					if(maxEndDate == null || paf.ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_Adjusted_End_Date__c > maxEndDate) maxEndDate = paf.ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_Adjusted_End_Date__c;
				}
				this.nameOfPAF = this.nameOfPAF.subString(0,this.nameOfPAF.length()-2);
				
				this.startDateToDisplay = formatDate(minStartDate);
				this.endDateToDisplay = formatDate(maxEndDate);
				this.numberOfMonthToDisplay = paf.ASI_HK_CRM_Adjusted_Start_Date__c.monthsBetween(paf.ASI_HK_CRM_Adjusted_End_Date__c) + 1;
			}else
			if(this.sectionName == 'Actual'){
				this.startDateToDisplay = formatDate(paf.ASI_CRM_Ref_Start_Date__c);
				this.endDateToDisplay = formatDate(paf.ASI_CRM_Ref_End_Date__c);
				this.numberOfMonthToDisplay = paf.ASI_CRM_Ref_Start_Date__c.monthsBetween(paf.ASI_CRM_Ref_End_Date__c) + 1;
				this.customerName = paf.ASI_HK_CRM_PAF_Customer__r.Name;
			}else{
				this.startDateToDisplay = '';
				this.endDateToDisplay = '';
			}
		}
		
		private void setValueCompare(ContractComparisonResultWrapper wrapperToCompare, ContractComparisonResultWrapper wrapperToBeCompared){			
			for(string key : wrapperToCompare.map_type_dW.keySet()){
				DetailWrapper w = new DetailWrapper(key);
				DetailWrapper wToCompare = wrapperToCompare.map_type_dW.get(key);
				DetailWrapper wToBeCompared = wrapperToBeCompared.map_type_dW.get(key);
				w.A01 = (wToCompare.A01 - wToBeCompared.A01) * 100 / (wToBeCompared.A01 != 0 ? wToBeCompared.A01 : 1);
				w.A02 = (wToCompare.A02 - wToBeCompared.A02) * 100 / (wToBeCompared.A02 != 0 ? wToBeCompared.A02 : 1);
				w.A03 = (wToCompare.A03 - wToBeCompared.A03) * 100 / (wToBeCompared.A03 != 0 ? wToBeCompared.A03 : 1);
				w.A04 = (wToCompare.A04 - wToBeCompared.A04) * 100 / (wToBeCompared.A04 != 0 ? wToBeCompared.A04 : 1);
				w.A05 = (wToCompare.A05 - wToBeCompared.A05) * 100 / (wToBeCompared.A05 != 0 ? wToBeCompared.A05 : 1);
				w.A06 = (wToCompare.A06 - wToBeCompared.A06) * 100 / (wToBeCompared.A06 != 0 ? wToBeCompared.A06 : 1);
				w.A07 = (wToCompare.A07 - wToBeCompared.A07) * 100 / (wToBeCompared.A07 != 0 ? wToBeCompared.A07 : 1);
				w.A08 = (wToCompare.A08 - wToBeCompared.A08) * 100 / (wToBeCompared.A08 != 0 ? wToBeCompared.A08 : 1);
				w.A09 = (wToCompare.A09 - wToBeCompared.A09) * 100 / (wToBeCompared.A09 != 0 ? wToBeCompared.A09 : 1);
				w.A10 = (wToCompare.A10 - wToBeCompared.A10) * 100 / (wToBeCompared.A10 != 0 ? wToBeCompared.A10 : 1);
				w.A11 = (wToCompare.A11 - wToBeCompared.A11) * 100 / (wToBeCompared.A11 != 0 ? wToBeCompared.A11 : 1);
				w.A12 = (wToCompare.A12 - wToBeCompared.A12) * 100 / (wToBeCompared.A12 != 0 ? wToBeCompared.A12 : 1);
				w.A13 = (wToCompare.A13 - wToBeCompared.A13) * 100 / (wToBeCompared.A13 != 0 ? wToBeCompared.A13 : 1);
				w.A14 = (wToCompare.A14 - wToBeCompared.A14) * 100 / (wToBeCompared.A14 != 0 ? wToBeCompared.A14 : 1);
				w.A15 = (wToCompare.A15 - wToBeCompared.A15) * 100 / (wToBeCompared.A15 != 0 ? wToBeCompared.A15 : 1);
				w.A16 = (wToCompare.A16 - wToBeCompared.A16) * 100 / (wToBeCompared.A16 != 0 ? wToBeCompared.A16 : 1);
				w.B01 = (wToCompare.B01 - wToBeCompared.B01) * 100 / (wToBeCompared.B01 != 0 ? wToBeCompared.B01 : 1);
				w.B02 = (wToCompare.B02 - wToBeCompared.B02) * 100 / (wToBeCompared.B02 != 0 ? wToBeCompared.B02 : 1);
				w.B03 = (wToCompare.B03 - wToBeCompared.B03) * 100 / (wToBeCompared.B03 != 0 ? wToBeCompared.B03 : 1);
				w.B04 = (wToCompare.B04 - wToBeCompared.B04) * 100 / (wToBeCompared.B04 != 0 ? wToBeCompared.B04 : 1);
				w.B05 = (wToCompare.B05 - wToBeCompared.B05) * 100 / (wToBeCompared.B05 != 0 ? wToBeCompared.B05 : 1);
				w.B06 = (wToCompare.B06 - wToBeCompared.B06) * 100 / (wToBeCompared.B06 != 0 ? wToBeCompared.B06 : 1);
				w.B07 = (wToCompare.B07 - wToBeCompared.B07) * 100 / (wToBeCompared.B07 != 0 ? wToBeCompared.B07 : 1);
				w.B08 = (wToCompare.B08 - wToBeCompared.B08) * 100 / (wToBeCompared.B08 != 0 ? wToBeCompared.B08 : 1);
				w.B09 = (wToCompare.B09 - wToBeCompared.B09) * 100 / (wToBeCompared.B09 != 0 ? wToBeCompared.B09 : 1);
				w.B10 = (wToCompare.B10 - wToBeCompared.B10) * 100 / (wToBeCompared.B10 != 0 ? wToBeCompared.B10 : 1);
				w.B11 = (wToCompare.B11 - wToBeCompared.B11) * 100 / (wToBeCompared.B11 != 0 ? wToBeCompared.B11 : 1);
				w.B12 = (wToCompare.B12 - wToBeCompared.B12) * 100 / (wToBeCompared.B12 != 0 ? wToBeCompared.B12 : 1);
				w.B13 = (wToCompare.B13 - wToBeCompared.B13) * 100 / (wToBeCompared.B13 != 0 ? wToBeCompared.B13 : 1);
				w.SalesValue = (wToCompare.SalesValue - wToBeCompared.SalesValue) * 100 / (wToBeCompared.SalesValue != 0 ? wToBeCompared.SalesValue : 1);
				w.TotalInvestmentBeforeNetSales = (wToCompare.TotalInvestmentBeforeNetSales - wToBeCompared.TotalInvestmentBeforeNetSales) * 100 / (wToBeCompared.TotalInvestmentBeforeNetSales != 0 ? wToBeCompared.TotalInvestmentBeforeNetSales : 1);
				w.NetSales = (wToCompare.NetSales - wToBeCompared.NetSales) * 100 / (wToBeCompared.NetSales != 0 ? wToBeCompared.NetSales : 1);
				w.Cost = (wToCompare.Cost - wToBeCompared.Cost) * 100 / (wToBeCompared.Cost != 0 ? wToBeCompared.Cost : 1);
				w.CM = (wToCompare.CM - wToBeCompared.CM) * 100 / (wToBeCompared.CM != 0 ? wToBeCompared.CM : 1);
				w.TotalInvestmentAfterNetSales = (wToCompare.TotalInvestmentAfterNetSales - wToBeCompared.TotalInvestmentAfterNetSales) * 100 / (wToBeCompared.TotalInvestmentAfterNetSales != 0 ? wToBeCompared.TotalInvestmentAfterNetSales : 1);
				w.CAAP = (wToCompare.CAAP - wToBeCompared.CAAP) * 100 / (wToBeCompared.CAAP != 0 ? wToBeCompared.CAAP : 1);
				w.TotalInvestment = (wToCompare.TotalInvestment - wToBeCompared.TotalInvestment) * 100 / (wToBeCompared.TotalInvestment != 0 ? wToBeCompared.TotalInvestment : 1);
				w.TotalInvestmentPercentOfSalesValues = (wToCompare.TotalInvestmentPercentOfSalesValues - wToBeCompared.TotalInvestmentPercentOfSalesValues) * 100 / (wToBeCompared.TotalInvestmentPercentOfSalesValues != 0 ? wToBeCompared.TotalInvestmentPercentOfSalesValues : 1);
				w.ROIPercent = (wToCompare.ROIPercent - wToBeCompared.ROIPercent) * 100 / (wToBeCompared.ROIPercent != 0 ? wToBeCompared.ROIPercent : 1);
				w.VariableInvestment = (wToCompare.VariableInvestment - wToBeCompared.VariableInvestment) * 100 / (wToBeCompared.VariableInvestment != 0 ? wToBeCompared.VariableInvestment : 1);
				w.FixedInvestment = (wToCompare.FixedInvestment - wToBeCompared.FixedInvestment) * 100 / (wToBeCompared.FixedInvestment != 0 ? wToBeCompared.FixedInvestment : 1);
				w.Volume9L = (wToCompare.Volume9L - wToBeCompared.Volume9L) * 100 / (wToBeCompared.Volume9L != 0 ? wToBeCompared.Volume9L : 1);
				w.NNPper9L = (wToCompare.NNPper9L - wToBeCompared.NNPper9L) * 100 / (wToBeCompared.NNPper9L != 0 ? wToBeCompared.NNPper9L : 1);

				this.map_type_dW.put(key, w);
			}
			
			for(DetailWrapper dw : this.map_type_dW.values()){
				dw.roundUpFieldToZero();
            }
		}
		
		private void setActualValue(list<AggregateResult> PnLCostList, Map<decimal, SectionWrapper> subBrandSectionMap){
            system.debug('hi');
			map<string, string> map_subBrandName = new map<string, string>();
			for(SectionWrapper w : subBrandSectionMap.values()){
				for(string brandId : w.set_recordId){
					map_subBrandName.put(brandId, w.displayName);
				}
				DetailWrapper dwB = new DetailWrapper(w.displayName, map_paf_includeVolume);
				map_type_dW.put(w.displayName, dwB);
				DetailWrapper dwBOthers = new DetailWrapper(w.displayName+'_others', map_paf_includeVolume);
				map_type_dW.put(w.displayName+'_others', dwBOthers);
				if(w.hasSubSection){
					for(SectionWrapper sw : w.subSectionMap.values()){
						for(string subBrandId : sw.set_recordId){
							map_subBrandName.put(subBrandId, sw.displayName);
						}
						DetailWrapper dwSB = new DetailWrapper(sw.displayName, map_paf_includeVolume);
						map_type_dW.put(sw.displayName, dwSB);
					}
				}
			}
			DetailWrapper dwOthers = new DetailWrapper('Others', map_paf_includeVolume);
			map_type_dW.put('Others', dwOthers);
			DetailWrapper dwTotal = new DetailWrapper('total', map_paf_includeVolume);
			map_type_dW.put('total', dwTotal);
			
			for(AggregateResult PnlCost : PnLCostList){
                string brandId = String.valueOf(PnlCost.get('brandId'));
                string subBrandId = String.valueOf(PnlCost.get('subBrandId'));
                
                string brandName = map_subBrandName.containsKey(brandId) ? map_subBrandName.get(brandId) : '';
                string subBrandName = map_subBrandName.containsKey(subBrandId) ? map_subBrandName.get(subBrandId) : '';
				/*
                for(SectionWrapper w : subBrandSectionMap.values()){
                    if(w.set_recordId.contains(brandId)){
                        brandName = w.displayName;
                    }
                    if(w.hasSubSection){
                        for(SectionWrapper sw : w.subSectionMap.values()){
                            if(sw.set_recordId.contains(subBrandId)){
                                subBrandName = sw.displayName;
                            }
                        }
                    }
                }
				*/
                
                if(brandName != ''){
                    DetailWrapper dw = map_type_dW.containsKey(brandName) ? map_type_dW.get(brandName) : new DetailWrapper(brandName);
                    dw.addPnLCostLine(PnlCost);
                    map_type_dW.put(brandName, dw);
                }
                if(subBrandName != ''){
                    DetailWrapper dw = map_type_dW.containsKey(subBrandName) ? map_type_dW.get(subBrandName) : new DetailWrapper(subBrandName);
                    dw.addPnLCostLine(PnlCost);
                    map_type_dW.put(subBrandName, dw);
                }
                if(brandName != '' && subBrandName == ''){
                    string keyOthers = brandName + '_others';
                    DetailWrapper dw = map_type_dW.containsKey(keyOthers) ? map_type_dW.get(keyOthers) : new DetailWrapper(keyOthers);
                    dw.addPnLCostLine(PnlCost);
                    map_type_dW.put(keyOthers, dw);
                }
                if(brandName == '' && subBrandName == ''){
                    string keyOthers = 'Others';
                    DetailWrapper dw = map_type_dW.containsKey(keyOthers) ? map_type_dW.get(keyOthers) : new DetailWrapper(keyOthers);
                    dw.addPnLCostLine(PnlCost);
                    map_type_dW.put(keyOthers, dw);
                }
                
                string keyTotal = 'total';
                DetailWrapper dw = map_type_dW.containsKey(keyTotal) ? map_type_dW.get(keyTotal) : new DetailWrapper(keyTotal);
                dw.addPnLCostLine(PnlCost);
                map_type_dW.put(keyTotal, dw);
                
            }
            system.debug('hi2');
            
            for(DetailWrapper dw : map_type_dW.values()){
            system.debug('hi3');
				dw.getSalesTargetActual();
				dw.calculationGroupByTypeActual(this.map_PnLCost, this.LastDateOfThisFY);
				dw.calculationFinalizeActual();
				dw.unitInThousandField();
				dw.roundUpField();
            system.debug('hi4');
            }
            
            
        }
        
        
        
        
        
        
        private void setValue(list<ASI_HK_CRM_Pre_Approval_Form__c> list_paf, Map<decimal, SectionWrapper> subBrandSectionMap) {
			map<string, string> map_subBrandName = new map<string, string>();
			for(SectionWrapper w : subBrandSectionMap.values()){
				for(string brandId : w.set_recordId){
					map_subBrandName.put(brandId, w.displayName);
				}
				DetailWrapper dwB = new DetailWrapper(w.displayName, map_paf_includeVolume);
				map_type_dW.put(w.displayName, dwB);
				DetailWrapper dwBOthers = new DetailWrapper(w.displayName+'_others', map_paf_includeVolume);
				map_type_dW.put(w.displayName+'_others', dwBOthers);
				if(w.hasSubSection){
					for(SectionWrapper sw : w.subSectionMap.values()){
						for(string subBrandId : sw.set_recordId){
							map_subBrandName.put(subBrandId, sw.displayName);
						}
						DetailWrapper dwSB = new DetailWrapper(sw.displayName, map_paf_includeVolume);
						map_type_dW.put(sw.displayName, dwSB);
					}
				}
			}
			DetailWrapper dwOthers = new DetailWrapper('Others', map_paf_includeVolume);
			map_type_dW.put('Others', dwOthers);
			DetailWrapper dwTotal = new DetailWrapper('total', map_paf_includeVolume);
			map_type_dW.put('total', dwTotal);
            
            for(ASI_HK_CRM_Pre_Approval_Form__c paf : list_paf){
                
                //ASI_HK_CRM_Adjusted_Start_Date__c
                for(ASI_HK_CRM_Pre_Approval_Form_Item__c pafl : paf.Pre_Approval_Form_Items_Link_To_PAF_Form__r){
                    string mechanicCode = pafl.ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Code__c;
					/*
                    if(pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c!=null){
                        SubBrandIdSet.add(pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c);
                    }
					*/
					if(!MechanicsNotSKU.contains(mechanicCode)){
						string brandId = pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__c;
						string subBrandId = pafl.ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c;
                        
						string brandName = map_subBrandName.containsKey(brandId) ? map_subBrandName.get(brandId) : '';
						string subBrandName = map_subBrandName.containsKey(subBrandId) ? map_subBrandName.get(subBrandId) : '';
						
						if(brandName != ''){
							DetailWrapper dw = map_type_dW.containsKey(brandName) ? map_type_dW.get(brandName) : new DetailWrapper(brandName, map_paf_includeVolume);
							dw.addLine(pafl);
							map_type_dW.put(brandName, dw);
						}
						if(subBrandName != ''){
							DetailWrapper dw = map_type_dW.containsKey(subBrandName) ? map_type_dW.get(subBrandName) : new DetailWrapper(subBrandName, map_paf_includeVolume);
							dw.addLine(pafl);
							map_type_dW.put(subBrandName, dw);
						}
						if(brandName != '' && subBrandName == ''){
							string keyOthers = brandName + '_others';
							DetailWrapper dw = map_type_dW.containsKey(keyOthers) ? map_type_dW.get(keyOthers) : new DetailWrapper(keyOthers, map_paf_includeVolume);
							dw.addLine(pafl);
							map_type_dW.put(keyOthers, dw);
						}
						if(brandName == '' && subBrandName == ''){
							string keyOthers = 'Others';
							DetailWrapper dw = map_type_dW.containsKey(keyOthers) ? map_type_dW.get(keyOthers) : new DetailWrapper(keyOthers, map_paf_includeVolume);
							dw.addLine(pafl);
							map_type_dW.put(keyOthers, dw);
						}
						string keyTotal = 'total';
						DetailWrapper dw = map_type_dW.containsKey(keyTotal) ? map_type_dW.get(keyTotal) : new DetailWrapper(keyTotal, map_paf_includeVolume);
						dw.addLine(pafl);
						map_type_dW.put(keyTotal, dw);
					} else {
						string pafId = pafl.ASI_HK_CRM_Pre_Approval_Form_Lookup__c;
						list<ASI_HK_CRM_Pre_Approval_Form_Item__c> list_pafl = map_pafId_paflAllProduct.containsKey(pafId) ? map_pafId_paflAllProduct.get(pafId) : new list<ASI_HK_CRM_Pre_Approval_Form_Item__c>();
						list_pafl.add(pafl);
						map_pafId_paflAllProduct.put(pafId, list_pafl);
					}
                }
            }
            
            
			for(DetailWrapper dw : map_type_dW.values()){
				dw.addAllProductLine(map_pafId_paflAllProduct);
				dw.getSalesTarget();
				dw.calculationGroupByType();
				dw.calculationFinalize(this.map_PnLCost, this.LastDateOfThisFY);
				dw.unitInThousandField();
				dw.roundUpField();
				//system.debug(dw);
			}

        }
        

    }

    private final static Map<String, Schema.SObjectField> CONTRACT_FIELD_MAP = Schema.SObjectType.ASI_HK_CRM_Pre_Approval_Form__c.fields.getMap();
    
    private final static list<string> CONTRACT_FIELD_LIST_SIMPLE = new list<string>{
        'Name',
		'ASI_HK_CRM_Adjusted_Start_Date__c',
		'ASI_HK_CRM_Adjusted_End_Date__c',
		'ASI_CRM_Ref_Start_Date__c',
		'ASI_CRM_Ref_End_Date__c',
		'ASI_HK_CRM_PAF_Start_Date__c',
		'ASI_HK_CRM_PAF_End_Date__c',
		'ASI_HK_CRM_PAF_No_of_Months__c',
		'ASI_CRM_Short_Term_Promotion__c',
		'ASI_CRM_HK_PAF_no__c',
		'ASI_CRM_HK_PAF_no_2__c',
		'ASI_CRM_HK_PAF_no_3__c',
		'ASI_CRM_HK_PAF_no_4__c',
		'ASI_CRM_HK_PAF_no_5__c',
		'ASI_CRM_HK_PAF_no__r.Name',
		'ASI_CRM_HK_PAF_no_2__r.Name',
		'ASI_CRM_HK_PAF_no_3__r.Name',
		'ASI_CRM_HK_PAF_no_4__r.Name',
		'ASI_CRM_HK_PAF_no_5__r.Name',
		'ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_Adjusted_Start_Date__c',
		'ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_Adjusted_Start_Date__c',
		'ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_Adjusted_Start_Date__c',
		'ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_Adjusted_Start_Date__c',
		'ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_Adjusted_Start_Date__c',
		'ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_Adjusted_End_Date__c',
		'ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_Adjusted_End_Date__c',
		'ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_Adjusted_End_Date__c',
		'ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_Adjusted_End_Date__c',
		'ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_Adjusted_End_Date__c',
		'ASI_CRM_HK_PAF_no__r.ASI_HK_CRM_PAF_Customer__r.Name',
		'ASI_CRM_HK_PAF_no_2__r.ASI_HK_CRM_PAF_Customer__r.Name',
		'ASI_CRM_HK_PAF_no_3__r.ASI_HK_CRM_PAF_Customer__r.Name',
		'ASI_CRM_HK_PAF_no_4__r.ASI_HK_CRM_PAF_Customer__r.Name',
		'ASI_CRM_HK_PAF_no_5__r.ASI_HK_CRM_PAF_Customer__r.Name',
		'ASI_CRM_HK_Pl_volume1__c',
		'ASI_CRM_HK_Pl_volume2__c',
		'ASI_CRM_HK_Pl_volume3__c',
		'ASI_CRM_HK_Pl_volume4__c',
		'ASI_CRM_HK_Pl_volume5__c',
		'ASI_HK_CRM_PAF_Customer__c',
		'ASI_HK_CRM_PAF_Customer2__c',
		'ASI_HK_CRM_PAF_Customer3__c',
		'ASI_HK_CRM_PAF_Customer4__c',
		'ASI_HK_CRM_PAF_Customer__r.Name',
		'ASI_HK_CRM_PAF_Customer2__r.Name',
		'ASI_HK_CRM_PAF_Customer3__r.Name',
		'ASI_HK_CRM_PAF_Customer4__r.Name'
    };
                
	private final static List<String> MECHANICS_FIELD_LIST = new List<string>{
		'Id'
		, 'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__c' 
		, 'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_Sub_brand__r.ASI_MFM_Brand__c' 
		, 'ASI_HK_CRM_SKU_Lookup__c'
		, 'ASI_HK_CRM_SKU_Lookup__r.ASI_FOC_Packing_Description__c'
		, 'ASI_HK_CRM_SKU_Lookup__r.ASI_MFM_SKU_Code__c'
		, 'ASI_HK_CRM_SKU_Lookup__r.ASI_HK_CRM_Std_Bottle_Size__c'
		, 'ASI_CRM_HK_Pricing_Item__c' 
		, 'ASI_CRM_HK_Free_SKU__r.Name' 
		, 'ASI_HK_CRM_Target_Volume_Qty__c'
		, 'ASI_HK_CRM_Price__c'
		, 'ASI_HK_CRM_Investment_Value__c '
		, 'ASI_HK_CRM_Rebate_Disc_Percent__c'
		, 'ASI_HK_CRM_Rebate_Disc_Amt_Per_BT__c'
		, 'ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Mechanic_Type__c'
        , 'ASI_HK_CRM_Mechanic__r.ASI_HK_CRM_Code__c'
		, 'ASI_HK_CRM_Pre_Approval_Form_Lookup__c',
            'ASI_HK_CRM_Pre_Approval_Form_Lookup__r.ASI_HK_CRM_Adjusted_End_Date__c'
    };
	    
    private String baseContractId;
    private List<String> contractIdList = new List<String>();
    private Set<String> currentPAFIdList = new Set<String>();
    
    //JSON String for VF Page
    public String contractListJson                        {get {return toJsonString(contractList);}}
    public String contractComparisonResultWrapperListJson {get {return toJsonString(contractComparisonResultWrapperList);}}
	public String subBrandSectionMapJson                  {get {return toJsonString(subBrandSectionMap);}}
    public Boolean getShowComparison(){
        return Boolean.valueOf(ApexPages.currentPage().getParameters().containsKey('showComparison') ? ApexPages.currentPage().getParameters().get('showComparison') : 'false');
    }

    //All contract records
    public List<ASI_HK_CRM_Pre_Approval_Form__c> contractList { get; set; }
    public List<ContractComparisonResultWrapper> contractComparisonResultWrapperList;
	public Map<string, boolean> map_paf_includeVolume = new Map<string, boolean>();
	public Map<decimal, SectionWrapper> subBrandSectionMap = new Map<decimal, SectionWrapper>();
	//public Boolean isPageInit { get { if(isPageInit != true) {isPageInit = init();} return isPageInit;} set;}
  
    public PageReference pageRef = ApexPages.currentPage();
    
	//Execute the logic when contract id is setted by component
	public Boolean init(){
		loadStaticResource();
		
		contractList = retrieveContractList(pafId);
		Set<String> CustomerIdSet = new Set<String>();
        
        
        //Just One record 
		for(ASI_HK_CRM_Pre_Approval_Form__c paf : contractList){
            if(paf.ASI_HK_CRM_PAF_Customer2__c!=null)
                CustomerIdSet.add(paf.ASI_HK_CRM_PAF_Customer2__c);
            if(paf.ASI_HK_CRM_PAF_Customer3__c!=null)
                CustomerIdSet.add(paf.ASI_HK_CRM_PAF_Customer3__c);
            if(paf.ASI_HK_CRM_PAF_Customer4__c!=null)
                CustomerIdSet.add(paf.ASI_HK_CRM_PAF_Customer4__c);
            
			contractIdList.add(paf.Id);
			map_paf_includeVolume.put(paf.Id, true);
			if(paf.ASI_CRM_HK_PAF_no__c != null){
				contractIdList.add(paf.ASI_CRM_HK_PAF_no__c);
				currentPAFIdList.add(paf.ASI_CRM_HK_PAF_no__c);
				map_paf_includeVolume.put(paf.ASI_CRM_HK_PAF_no__c, paf.ASI_CRM_HK_Pl_volume1__c);
			}
			if(paf.ASI_CRM_HK_PAF_no_2__c != null){
				contractIdList.add(paf.ASI_CRM_HK_PAF_no_2__c);
				currentPAFIdList.add(paf.ASI_CRM_HK_PAF_no_2__c);
				map_paf_includeVolume.put(paf.ASI_CRM_HK_PAF_no_2__c, paf.ASI_CRM_HK_Pl_volume2__c);
			}
			if(paf.ASI_CRM_HK_PAF_no_3__c != null){
				contractIdList.add(paf.ASI_CRM_HK_PAF_no_3__c);
				currentPAFIdList.add(paf.ASI_CRM_HK_PAF_no_3__c);
				map_paf_includeVolume.put(paf.ASI_CRM_HK_PAF_no_3__c, paf.ASI_CRM_HK_Pl_volume3__c);
			}
			if(paf.ASI_CRM_HK_PAF_no_4__c != null){
				contractIdList.add(paf.ASI_CRM_HK_PAF_no_4__c);
				currentPAFIdList.add(paf.ASI_CRM_HK_PAF_no_4__c);
				map_paf_includeVolume.put(paf.ASI_CRM_HK_PAF_no_4__c, paf.ASI_CRM_HK_Pl_volume4__c);
			}
			if(paf.ASI_CRM_HK_PAF_no_5__c != null){
				contractIdList.add(paf.ASI_CRM_HK_PAF_no_5__c);
				currentPAFIdList.add(paf.ASI_CRM_HK_PAF_no_5__c);
				map_paf_includeVolume.put(paf.ASI_CRM_HK_PAF_no_5__c, paf.ASI_CRM_HK_Pl_volume5__c);
			}
		}
        
        if(contractList[0].ASI_CRM_Short_Term_Promotion__c){
            for(ASI_CRM_HK_Pre_Approval_Form_Customer__c PAFCustomer:[
				select id,ASI_CRM_HK_Customer__c 
				from ASI_CRM_HK_Pre_Approval_Form_Customer__c 
				where ASI_CRM_HK_Customer__c!=null 
				and ASI_CRM_HK_Pre_Approval_Form__c = :contractList[0].id
			]){
                CustomerIdSet.add(PAFCustomer.ASI_CRM_HK_Customer__c);
            }
        }  else {
			if(contractList[0].ASI_HK_CRM_PAF_Customer__c!=null)
				CustomerIdSet.add(contractList[0].ASI_HK_CRM_PAF_Customer__c);
		}
        
        
		compareContract(pafId, currentPAFIdList, contractIdList,CustomerIdSet);
		return true;
	}
	
	public void compareContractFromVF(){
		init();
		//compareContract(pafId, currentPAFIdList, contractIdList);
	}

    public void compareContract(String baseContractId, Set<String> currentPAFIdList, List<String> contractIdList,Set<String> ActualCustomerIdSet ) {
        //Init wrapperList
        contractComparisonResultWrapperList = new List<ContractComparisonResultWrapper>();
		
        //Get the base contract and remove it in the map
        List<ASI_HK_CRM_Pre_Approval_Form__c> baseContract = new List<ASI_HK_CRM_Pre_Approval_Form__c>();
        List<ASI_HK_CRM_Pre_Approval_Form__c> currentContract = new List<ASI_HK_CRM_Pre_Approval_Form__c>();
        ASI_HK_CRM_Pre_Approval_Form__c proposedPAF;

        //Retrieve the contract records that need to be compared
        for(ASI_HK_CRM_Pre_Approval_Form__c paf : retrieveContractWithChildList(contractIdList)){
			if(paf.Id == baseContractId){ // this PAF itself
				baseContract.add(paf);
				proposedPAF = paf;
			} else if(currentPAFIdList.contains(paf.Id)){ // other P&L - Reference PAF, no need to check contains
				currentContract.add(paf);
			}
		}
        
        map<string, ASI_CRM_PnL_Cost__c> map_PnLCost = retrievePnLCostList(proposedPAF);
		
		ContractComparisonResultWrapper currentComparisonResultWrapper = new ContractComparisonResultWrapper('Current', false, proposedPAF, currentContract, subBrandSectionMap, map_paf_includeVolume, map_PnLCost);
        contractComparisonResultWrapperList.add(currentComparisonResultWrapper);
      
	    ContractComparisonResultWrapper actualComparisonResultWrapper;
	    if(proposedPAF.ASI_CRM_Ref_Start_Date__c != null && proposedPAF.ASI_CRM_Ref_End_Date__c != null && ActualCustomerIdSet.size() > 0){
			List<AggregateResult> list_actualPnL = retrieveActualPnLList(proposedPAF, ActualCustomerIdSet);
			actualComparisonResultWrapper = new ContractComparisonResultWrapper('Actual', false, proposedPAF, subBrandSectionMap, list_actualPnL, map_PnLCost);
			contractComparisonResultWrapperList.add(actualComparisonResultWrapper);
		}
        
        ContractComparisonResultWrapper proposedComparisonResultWrapper = new ContractComparisonResultWrapper('Proposed', true, proposedPAF, baseContract, subBrandSectionMap, map_paf_includeVolume, map_PnLCost);
        contractComparisonResultWrapperList.add(proposedComparisonResultWrapper);

	    if(proposedPAF.ASI_CRM_Ref_Start_Date__c != null && proposedPAF.ASI_CRM_Ref_End_Date__c != null && ActualCustomerIdSet.size() > 0){
			ContractComparisonResultWrapper acContractComparisonResultWrapper = new ContractComparisonResultWrapper('Act vs Current', actualComparisonResultWrapper, currentComparisonResultWrapper);
			contractComparisonResultWrapperList.add(acContractComparisonResultWrapper);

			ContractComparisonResultWrapper paContractComparisonResultWrapper = new ContractComparisonResultWrapper('Proposed vs Act', proposedComparisonResultWrapper, acContractComparisonResultWrapper);
			contractComparisonResultWrapperList.add(paContractComparisonResultWrapper);
		} else {
			ContractComparisonResultWrapper pcContractComparisonResultWrapper = new ContractComparisonResultWrapper('Proposed vs Current', proposedComparisonResultWrapper, currentComparisonResultWrapper);
			contractComparisonResultWrapperList.add(pcContractComparisonResultWrapper);
		}
        

    }
    
    /***************
    XML Static Resource Function
    ***************/
	//Wrapper Class for storing all section
    public class SectionWrapper {
        public String name                                {get; set;}
        public String code                               {get; set;}
        public String recordId                               {get; set;}
        public Set<string> set_recordId                               {get; set;}
        public String displayName                               {get; set;}
        public Integer sortingNumber                               {get; set;}
        public boolean hasOthers                             {get; set;}
        public boolean isSubBrand                    {get; set;}
        public Map<decimal, SectionWrapper> subSectionMap {get; set;}
        public Boolean hasSubSection                      {get; set;}
        
        public SectionWrapper(String name, String code, /*String recordId,*/set<String> set_recordId, Boolean hasOthers, boolean isSubBrand, String displayName, Integer sortingNumber,
                              Map<decimal, SectionWrapper> subSectionMap) {
            this.name          = name;
            //this.recordId         = recordId;
            //this.set_recordId         = new Set<String>(recordId.split(';'));
			this.set_recordId = set_recordId;
            this.displayName         = displayName;
            this.hasOthers = hasOthers;
            this.isSubBrand = isSubBrand;
            this.sortingNumber = sortingNumber;
            this.subSectionMap = subSectionMap;
			this.code = code;
            
            if(subSectionMap == null || subSectionMap.size() == 0) {
                hasSubSection = false; 
            } else {
              hasSubSection = true;
            }
            
        }
    }
	
	private void loadStaticResource() {
        String xmlStr ='';
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'ASI_CRM_HK_PAFPnLReport_Structure' LIMIT 1];
        xmlStr = sr.Body.toString(); 
        
        
        Dom.Document doc = new Dom.Document();
        doc.load(xmlStr);
        
        Dom.XMLNode docRootNode  = doc.getRootElement();
    
        subBrandSectionMap = parseXML(docRootNode);
    }
	
	private Map<decimal, SectionWrapper> parseXML(Dom.XMLNode sectionNode) {
        Map<decimal, SectionWrapper> sectionWrapperMap = new Map<decimal, SectionWrapper>();
		List<ASI_MFM_Sub_brand__c> list_sb = retrieveSubBrandList();
		
		map<string, string> map_subBrandCode = new map<string, string>();
		map<string, string> map_brandCode = new map<string, string>();
		for(ASI_MFM_Sub_brand__c sb : list_sb){
			map_subBrandCode.put(sb.ASI_MFM_Sub_brand_Code__c, sb.id);
			map_brandCode.put(sb.ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c, sb.ASI_MFM_Brand__c);
		}
        
        for(Dom.XMLNode childNode : sectionNode.getChildElements()) {
            String name                                = childNode.getAttribute('name', null);
            //String recordId                               = childNode.getChildElement('recordId', null).getText();
            String displayName                               = childNode.getChildElement('displayName', null).getText();
            Boolean hasOthers                      = Boolean.valueOf(childNode.getChildElement('hasOthers', null).getText());
            Boolean isSubBrand                      = Boolean.valueOf(childNode.getChildElement('isSubBrand', null).getText());
            Integer sortingNumber                       = Integer.valueOf(childNode.getChildElement('sortingNumber', null).getText());
            String code                                = childNode.getChildElement('code', null).getText();
            Map<decimal, SectionWrapper> subSectionMap = null;
			
			Set<string> set_codeId = new set<string>();
			Set<String> set_code = new Set<String>(code.split(';'));
			for(string c : set_code){
				if(isSubBrand){
					if(map_subBrandCode.containsKey(c)) set_codeId.add(map_subBrandCode.get(c));
				}else {
					if(map_brandCode.containsKey(c)) set_codeId.add(map_brandCode.get(c));
				}
			}
            
            Dom.XMLNode subSectionNode = childNode.getChildElement('subSection', null);
            if(subSectionNode != null) {
                subSectionMap = parseXML(subSectionNode);
            }

            SectionWrapper sectionWrapper = new SectionWrapper(name, code, /*recordId,*/set_codeId, hasOthers, isSubBrand, displayName, sortingNumber, subSectionMap);
            sectionWrapperMap.put(sortingNumber, sectionWrapper);
        }
        
        return sectionWrapperMap;
    }
	
    /***************
    Data Retrievement Function
    ***************/
    private List<ASI_MFM_Sub_brand__c> retrieveSubBrandList() {
        return [SELECT id, ASI_MFM_Sub_brand_Code__c, ASI_MFM_Brand__c, ASI_MFM_Brand__r.ASI_MFM_Brand_Code__c 
                       FROM ASI_MFM_Sub_brand__c 
                       WHERE RecordType.DeveloperName = 'ASI_HK_CRM_Sub_brand'];

        //return (List<ASI_MFM_Sub_brand__c>) Database.query(query);
    }
  
    private List<ASI_HK_CRM_Pre_Approval_Form__c> retrieveContractList(string paf) {
        String query = 'SELECT ' + genQueryFieldFromList(CONTRACT_FIELD_LIST_SIMPLE) + ', ' +
            'RecordType.DeveloperName ' +
                       'FROM ASI_HK_CRM_Pre_Approval_Form__c ' +
                       'WHERE id = : pafId';

        List<ASI_HK_CRM_Pre_Approval_Form__c> contractList = (List<ASI_HK_CRM_Pre_Approval_Form__c>) Database.query(query);
        return contractList.size() > 0 ? contractList : new List<ASI_HK_CRM_Pre_Approval_Form__c>();
    }
  
    private List<ASI_HK_CRM_Pre_Approval_Form__c> retrieveContractWithChildList(List<string> contractIdList) {
        String query = 'SELECT ' + genQueryFieldFromList(CONTRACT_FIELD_LIST_SIMPLE) +
                       ', RecordType.DeveloperName, ' +
                       //Retrieve Actual Offtake
                       '(SELECT ' + genQueryFieldFromList(MECHANICS_FIELD_LIST) + ' FROM Pre_Approval_Form_Items_Link_To_PAF_Form__r) ' + 
                       'FROM ASI_HK_CRM_Pre_Approval_Form__c ' +
                       'WHERE Id in : contractIdList';

        List<ASI_HK_CRM_Pre_Approval_Form__c> contractList = (List<ASI_HK_CRM_Pre_Approval_Form__c>) Database.query(query);
        return contractList.size() > 0 ? contractList : new List<ASI_HK_CRM_Pre_Approval_Form__c>();
    }

    private List<AggregateResult> retrieveActualPnLList(ASI_HK_CRM_Pre_Approval_Form__c proposedPAF, Set<string> ActualCustomerIdSet) {
        Date startDate = Date.newinstance(proposedPAF.ASI_CRM_Ref_Start_Date__c.year(), proposedPAF.ASI_CRM_Ref_Start_Date__c.month(),1);
        Date endDate = Date.newinstance(proposedPAF.ASI_CRM_Ref_End_Date__c.year(), proposedPAF.ASI_CRM_Ref_End_Date__c.month(),1).addMonths(1);
		system.debug(startDate);
		system.debug(endDate);
		system.debug(ActualCustomerIdSet);
		List<AggregateResult> contractList = [
			select 
				ASI_CRM_Sub_Brand__c subBrandId,
				ASI_CRM_Sub_Brand__r.ASI_MFM_Brand__c brandId,
				ASI_CRM_Object_Key__c objectKey,
				ASI_CRM_Line_Type__c lineType,
				sum(ASI_CRM_Volume_9L_MTD__c) volume9L,
				sum(ASI_CRM_Total_Cost_MTD__c) value 
			from ASI_CRM_PnL_Cost__c
            where 
				recordtype.developername = 'ASI_CRM_HK_Customer_Actual' and
				(ASI_CRM_Customer_Number_PA__c in : ActualCustomerIdSet  or ASI_CRM_Customer_Number_DA__c in :ActualCustomerIdSet ) and
				ASI_CRM_Period_Begin_Date__c >= :startDate and
				ASI_CRM_Period_End_Date__c < :endDate 
			group by 
				ASI_CRM_Sub_Brand__c,
				ASI_CRM_Sub_Brand__r.ASI_MFM_Brand__c,
				ASI_CRM_Object_Key__c,
				ASI_CRM_Line_Type__c
		];
        return contractList.size() > 0 ? contractList : new List<AggregateResult>();
    }

    private map<string, ASI_CRM_PnL_Cost__c> retrievePnLCostList(ASI_HK_CRM_Pre_Approval_Form__c proposedPAF) {
        Map<String,ASI_CRM_PnL_Cost__c> PnLCostMap= new Map<String,ASI_CRM_PnL_Cost__c>();
		
        Date inputDate = proposedPAF.ASI_HK_CRM_Adjusted_Start_Date__c;
		Date LastDateOfThisFY = Date.newinstance(inputDate.year(), 6,30);
		if(inputDate.month() >= 7){
			LastDateOfThisFY = LastDateOfThisFY.addYears(1);
		}
		Date LastDateOfLastFY = LastDateOfThisFY.addYears(-1);
		
		for(ASI_CRM_PnL_Cost__c pnlcost : [
			select Id, 
				ASI_CRM_Sub_Brand__c,
				ASI_CRM_Cost_per_9L_YTD__c, 
				ASI_CRM_Sub_Brand__r.ASI_MFM_Brand__c, 
				ASI_CRM_Period_End_Date__c,
				RecordType.DeveloperName  
			from ASI_CRM_PnL_Cost__c
            where 
				recordtype.developername in ('ASI_CRM_HK_Actual_Cost_Brand','ASI_CRM_HK_Actual_Cost_Sub_Brand','ASI_CRM_HK_Budget_Cost_Brand','ASI_CRM_HK_Budget_Cost_Sub_Brand') and
				ASI_CRM_Cost_per_9L_YTD__c != 0 and
				(ASI_CRM_Period_End_Date__c = :LastDateOfThisFY or ASI_CRM_Period_End_Date__c = :LastDateOfLastFY)
				
		]){
			String PnLKey ='';
			if(pnlcost.ASI_CRM_Sub_Brand__c!=null){
				//Record type+Sub-Brand + Period End Date
				PnLKey=pnlcost.RecordType.DeveloperName + pnlcost.ASI_CRM_Sub_Brand__c +string.valueOf(pnlcost.ASI_CRM_Period_End_Date__c);
				
				PnLCostMap.put(PnLKey, pnlcost);
			}
			
			if(pnlcost.ASI_CRM_Sub_Brand__r.ASI_MFM_Brand__c!=null){
				PnLKey = pnlcost.RecordType.DeveloperName + pnlcost.ASI_CRM_Sub_Brand__r.ASI_MFM_Brand__c +string.valueOf(pnlcost.ASI_CRM_Period_End_Date__c);
				PnLCostMap.put(PnLKey, pnlcost);
			} 
		}
        return PnLCostMap;
    }

    /***************
    Tools Function
    ***************/
    private String genQueryField(Map<String, Schema.SObjectField> fieldMap) {
        String queryField = '';
        for(String fields : fieldMap.keySet()) {
          queryField += fields + ',';
        }
        return queryField.subString(0, queryField.length() - 1);
    }

    private String genQueryFieldFromList(list<string> fieldList) {
        return String.join(fieldList, ',');
    }

    private String toJsonString(Object obj) {
        return System.JSON.serialize(obj);
    }

    private List<Object> fromJsonString(String jsonString, System.Type apexType) {
        if(String.isBlank(jsonString)) {
            return null;
        }
        return (List<Object>) System.JSON.deserialize(jsonString, apexType);
    }

    public string inputEndDate{
        get{
      Datetime dt = System.now();            
            return dt.format('YYYY-MM-dd');
        }
        set;
    }
  
    public string inputStartDate{
        get{
      Datetime dt = System.now().addYears(-2);            
            return dt.format('YYYY-MM-dd');
        }
        set;
    }
  
    public void printPDF(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
		
		ASI_MFM_Mass_Upload_Log__c uploadLog = new ASI_MFM_Mass_Upload_Log__c();
		insert uploadLog;
		Attachment tempAttached = new Attachment();
		tempAttached.ParentId = uploadLog.Id;
		tempAttached.Name = 'HK PnL PDF';
		tempAttached.Body = Blob.valueOf(params.get('resultHTML'));
		insert tempAttached;
		
		system.debug(tempAttached);
		
		fileId = tempAttached.Id;
		system.debug(returnFileId);
    }
	
    public void buildResult(){
        Attachment tempAttachment = [SELECT Body, ParentId FROM Attachment WHERE Id = :fileId];
        resultHTML = tempAttachment.Body.toString();
		parentFileId = tempAttachment.ParentId;
		
    }
	
	public void deleteParentFile(){
		Delete [select id from ASI_MFM_Mass_Upload_Log__c where Id = :parentFileId];
	}
	
	private static String formatDate(date d){
		Datetime dt = d;
		return dt.format('yyyy-MM-dd');
	}
	
}