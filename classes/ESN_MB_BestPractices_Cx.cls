public class ESN_MB_BestPractices_Cx {
	public static final String URL_DAM_ASSET = 'https://api-brandcloud.pernod-ricard.com';
	public static final String URL_INTERNAL_ASSET = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='; 

	public static final String RECORD_TYPE_BRAND_ACTIVATION = 'Brand Activation';
	public static final String RECORD_TYPE_MARKET_ACTIVATION = 'Market Activation';

	public static final String PAGE = '/apex/ESN_MB_NOP_Brand?brandId=';
	public static final String PAGE_BRAND_ACTIVATION = '#?page=article-global-activation&content=';
	public static final String PAGE_MARKET_ACTIVATION = '#?page=article-local-activation&content=';

	public static final String COORDINATOR_PARAMETER_NAME = 'Coordinator';

	//public String coordinator { get; set; }
	public List<BestPractices> listBestPractices = new List<BestPractices>();

	public ESN_MB_BestPractices_Cx() {

	}

	public String getListBestPractices() {
		//List<BestPractices> ret = new List<BestPractices>();
		List<ESN_MB_Entry__c> listBestPracticesEntries = [SELECT Id, ESN_MB_Activation__r.RecordType.Name, ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c, ESN_MB_Asset__r.ESN_MB_DocumentId__c, ESN_MB_Activation__r.Id, ESN_MB_Activation__r.Name, ESN_MB_Activation__r.Current_Brand_Name__c, ESN_MB_Activation__r.ESN_MB_BrandId__c, ESN_MB_Activation__r.CreatedDate, ESN_MB_Activation__r.ESN_MB_Activation_Type__c, ESN_MB_Activation__r.ESN_MB_Affiliate__c, ESN_MB_Activation__r.ESN_MB_Market__c, ESN_MB_Activation__r.ESN_MB_Region__c, ESN_MB_Activation__r.ESN_MB_BusinessPriority__c, ESN_MB_Activation__r.ESN_MB_Best_Practices_Status__c FROM ESN_MB_Entry__c WHERE ESN_MB_Activation__r.ESN_MB_Stage__c = 'Published' AND ESN_MB_RoleAsset__c = 'MainAsset' AND ESN_MB_Activation__r.Current_Brand_Name__c <> null AND(ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c <> null OR ESN_MB_Asset__r.ESN_MB_DocumentId__c <> null) ORDER BY ESN_MB_Activation__r.ESN_MB_Best_Practices_Status__c DESC, ESN_MB_Activation__r.CreatedDate DESC];
		BestPractices bestPractices;

		for (ESN_MB_Entry__c e : listBestPracticesEntries) {
			bestPractices = new BestPractices();
			bestPractices.id = e.ESN_MB_Activation__r.Id;
			bestPractices.name = e.ESN_MB_Activation__r.Name;
			if (String.isNotBlank(e.ESN_MB_Activation__r.ESN_MB_Best_Practices_Status__c)) {
				bestPractices.status = e.ESN_MB_Activation__r.ESN_MB_Best_Practices_Status__c;
			} else {
				bestPractices.status = 'None';
			}
			bestPractices.brandId = e.ESN_MB_Activation__r.ESN_MB_BrandId__c;
			bestPractices.brandName = e.ESN_MB_Activation__r.Current_Brand_Name__c.replaceAll('_', ' ');
			if (e.ESN_MB_Activation__r.RecordType.Name.equals(RECORD_TYPE_BRAND_ACTIVATION)) {
				bestPractices.sourcePage = PAGE + e.ESN_MB_Activation__r.ESN_MB_BrandId__c + PAGE_BRAND_ACTIVATION + e.ESN_MB_Activation__r.Id;
			} else if (e.ESN_MB_Activation__r.RecordType.Name.equals(RECORD_TYPE_MARKET_ACTIVATION)) {
				bestPractices.sourcePage = PAGE + e.ESN_MB_Activation__r.ESN_MB_BrandId__c + PAGE_MARKET_ACTIVATION + e.ESN_MB_Activation__r.Id;
			}
			if (String.isNotBlank(e.ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c)) {
				bestPractices.urlThumbnail = URL_DAM_ASSET + e.ESN_MB_Asset__r.ESN_MB_URL_thumbnail__c;
			} else if (String.isNotBlank(e.ESN_MB_Asset__r.ESN_MB_DocumentId__c)) {
				bestPractices.urlThumbnail = URL_INTERNAL_ASSET + e.ESN_MB_Asset__r.ESN_MB_DocumentId__c;
			}
			bestPractices.createdDate = e.ESN_MB_Activation__r.CreatedDate.day() + '/' + e.ESN_MB_Activation__r.CreatedDate.month() + '/' + e.ESN_MB_Activation__r.CreatedDate.year();
			bestPractices.affiliate = e.ESN_MB_Activation__r.ESN_MB_Affiliate__c;
			bestPractices.market = e.ESN_MB_Activation__r.ESN_MB_Market__c;
			bestPractices.region = e.ESN_MB_Activation__r.ESN_MB_Region__c;
			bestPractices.businessPriority = e.ESN_MB_Activation__r.ESN_MB_BusinessPriority__c;
			if (e.ESN_MB_Activation__r.Current_Brand_Name__c == 'Pernod_Ricard') {
				bestPractices.function = e.ESN_MB_Activation__r.ESN_MB_Activation_Type__c;	
			}
			bestPractices.year = e.ESN_MB_Activation__r.CreatedDate.year();
			listBestPractices.add(bestPractices);
		}
		return JSON.serialize(listBestPractices);
	}

	public String getListBusinessPriorities() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_BusinessPriority__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}

	public String getListRegions() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_Region__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}

	public String getListAffiliates() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_Affiliate__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}

	public String getListBrands() {
		List<ESN_MB_NodePage__c> result = new List<ESN_MB_NodePage__c>();
		List<ESN_MB_NodePage__c> listBrands = [SELECT Id, Name FROM ESN_MB_NodePage__c WHERE RecordType.Name = 'Brand' AND ESN_MB_Deployment_Status__c = 'Enable' AND(NOT Name LIKE '%LeCercle') ORDER BY Name];
		for(ESN_MB_NodePage__c brand : listBrands) {
			brand.Name = brand.Name.replaceAll('_', ' ');
			result.add(brand);
		}
		return JSON.serialize(result);
	}

	public String getListMarkets() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_Market__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}

	public String getListFunctions() {
		List<ESN_MB_NodePage__c> result = new List<ESN_MB_NodePage__c>();
		List<ESN_MB_NodePage__c> listFunctions = [SELECT Id, Name FROM ESN_MB_NodePage__c WHERE RecordType.Name='Rubric' AND ESN_MB_Section__c='Business Activation Library' ORDER BY Name];
		
		for(ESN_MB_NodePage__c function : listFunctions) {
			function.Name = function.Name.replaceAll('_', ' ');
			result.add(function);
		}
		return JSON.serialize(result);
	}

	public String getListStatus() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_Best_Practices_Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}

	public String getListYears() {
		Set<Integer> myset = new Set<Integer>();
		List<Integer> result = new List<Integer>();

		for (BestPractices bp : listBestPractices) {
			myset.add(bp.year);
		}
		result.addAll(myset);
		result.sort();
		return JSON.serialize(result);
	}

	public String getListCoordinators() {
		Schema.DescribeFieldResult fieldResult = ESN_MB_Activation__c.ESN_MB_Coordinator__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return JSON.serialize(ple);
	}

	public String getCoordinator() {
		return System.currentPageReference().getParameters().get(COORDINATOR_PARAMETER_NAME);
	}


	public class BestPractices {
		public String id;
		public String name;
		public String status;
		public String brandId;
		public String brandName;
		public String sourcePage;
		public String urlThumbnail;
		public String createdDate;
		public String affiliate;
		public String market;
		public String region;
		public String businessPriority;
		public String function;
		public Integer year;
	}

	@remoteAction 
	public static ESN_MB_Activation__c getBestPracticesData (String bestPracticesId) {
		ESN_MB_Activation__c bp = [SELECT Id, ESN_MB_Best_Practices_Status__c, ESN_MB_BusinessPriority__c, ESN_MB_Step1_Comment__c, ESN_MB_Step2_Comment__c FROM ESN_MB_Activation__c WHERE Id =: bestPracticesId LIMIT 1];
		return bp;
    }

	@remoteAction 
	public static Boolean saveBestPracticesStep1 (String bestPracticesId, String status, String businessPriority, String comment) {
		Boolean result = false;
		try {
			ESN_MB_Activation__c bp = [SELECT Id, ESN_MB_Best_Practices_Status__c, ESN_MB_BusinessPriority__c, ESN_MB_Step1_Comment__c, ESN_MB_Step1_ModifedBy__c, ESN_MB_Step1_ModifedDate__c FROM ESN_MB_Activation__c WHERE Id =: bestPracticesId LIMIT 1];
			bp.ESN_MB_Best_Practices_Status__c = status;
			bp.ESN_MB_BusinessPriority__c = businessPriority;
			bp.ESN_MB_Step1_Comment__c = comment;
			bp.ESN_MB_Step1_ModifedBy__c = UserInfo.getUserId();
			bp.ESN_MB_Step1_ModifedDate__c = System.now();
			update bp;
			result = true;
		} catch(DmlException e) {
			System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
		return result;
    }
  
	@remoteAction 
	public static Boolean saveBestPracticesStep2 (String bestPracticesId, String status, String businessPriority, String comment) {
		Boolean result = false;
		try {
			ESN_MB_Activation__c bp = [SELECT Id, ESN_MB_Best_Practices_Status__c, ESN_MB_BusinessPriority__c, ESN_MB_Step2_Comment__c, ESN_MB_Step2_ModifedBy__c, ESN_MB_Step2_ModifedDate__c FROM ESN_MB_Activation__c WHERE Id =: bestPracticesId LIMIT 1];
			bp.ESN_MB_Best_Practices_Status__c = status;
			bp.ESN_MB_BusinessPriority__c = businessPriority;
			bp.ESN_MB_Step2_Comment__c = comment;
			bp.ESN_MB_Step2_ModifedBy__c = UserInfo.getUserId();
			bp.ESN_MB_Step2_ModifedDate__c = System.now();
			update bp;
			result = true;
		} catch(DmlException e) {
			System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
		return result;
    }

}