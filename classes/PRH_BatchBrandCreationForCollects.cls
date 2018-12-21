// Le Cercle application - evolution LCS-11 - January 2017
// Batch for creation of Le Cercle Brand et Competitor brands for active collects 
// that have been created using scheduler PRH_ManageCollectsForIconicAcc
global class PRH_BatchBrandCreationForCollects implements Database.Batchable<sObject>, Database.Stateful {

	public String query;
	public List<PRH_Brand_Luxury_Brand__c> iconicBrandList;
	public List<PRH_Competitor_Brands__c> listOfNewCompetitorBRs;
	public List<PRH_Brand_Criteria__c> listOfNewLeCercleBRs;

	global Database.QueryLocator start(Database.BatchableContext BC){
		
		// Retrieve current date
		System.debug('=> PRH_BatchBrandCreationForCollects, current date :' + system.today().format());
		
		// Define query for retrieving the list of collects that have been just created
		this.query = 'SELECT id, Name, PRH_Active__c, PRH_Iconic_Account__r.OwnerId FROM PRH_Collect__c WHERE PRH_Active__c=true';
		
		return Database.getQueryLocator(this.query);
	}
  
	global void execute(Database.BatchableContext BC, List<PRH_Collect__c> colList){
		this.listOfNewLeCercleBRs = new List<PRH_Brand_Criteria__c >();
        PRH_Brand_Criteria__c leCercleBrand;
        this.listOfNewCompetitorBRs = new List<PRH_Competitor_Brands__c >();
		PRH_Competitor_Brands__c compBrand;
		
		// Create Competitor Brand and Le Cercle Brand for each new collect
		if (colList.size() > 0) {
			System.debug('==> PRH_BatchBrandCreationForCollects, Creation of Competitor Brand and Le Cercle Brand for ' + colList.size() + ' collects');
			this.iconicBrandList = [SELECT id, Name, PRH_Competitor_Brand__c, PRH_Active__c FROM PRH_Brand_Luxury_Brand__c WHERE PRH_Active__c=true ORDER BY PRH_Sequence__c]; 
			for (PRH_Collect__c c:colList) {					
				// For each brand
				for (PRH_Brand_Luxury_Brand__c ib:this.iconicBrandList) {
					// If flag Competitor is equal to True
					if (ib.PRH_Competitor_Brand__c == true) {
						// Create a new Brand Competitor linked with to the new created collect
						compBrand = new PRH_Competitor_Brands__c(
							PRH_Collect__c = c.id,
							PRH_Iconic_Brand__c = ib.id,
							OwnerId = c.PRH_Iconic_Account__r.OwnerId
						);
						this.listOfNewCompetitorBRs.add(compBrand);
					} else {
						// Create a new Le Cercle Brand linked with to the new created collect
						leCercleBrand = new PRH_Brand_Criteria__c(
							PRH_Brand__c = ib.id,
							PRH_Collect__c = c.id,
							OwnerId = c.PRH_Iconic_Account__r.OwnerId
						);
						this.listOfNewLeCercleBRs.add(leCercleBrand);
					}
				}
			}

			if (this.listOfNewCompetitorBRs.size() > 0) {
				System.debug('==> PRH_BatchBrandCreationForCollects, ' + this.listOfNewCompetitorBRs.size() + ' Competitor Brands are going to be created');
				insert this.listOfNewCompetitorBRs;
			}
			if (this.listOfNewLeCercleBRs.size() > 0) {
				System.debug('==> PRH_BatchBrandCreationForCollects, ' + this.listOfNewLeCercleBRs.size() + ' Le Cercle Brands are going to be created');
				insert this.listOfNewLeCercleBRs;
			}
		}					
	}
  
	global void finish(Database.BatchableContext BC){
    
	}
}