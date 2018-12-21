// Le Cercle application - evolution LCS-11 - January 2017
// Scheduler for creation of collects linked to Iconic Accounts
// There are 3 collects per year and one collect per iconic account. 
// These collects are created automatically in 2 steps in order to 
// avoid Salesforce limitation regarding 10000 max query rows in APEX class
// Step one : launch of schedulable class PRH_ManageCollectsForIconicAcc for deactivation of active collects and creation of new ones
// Step two : launch of schedulable class PRH_ScheduleBatchBRCreationForCollects that execute batch PRH_BatchBrandCreationForCollects
// for creation of Competitor brands and Le Cercle brands for each new collect
global with sharing class PRH_ManageCollectsForIconicAcc implements schedulable
{
	Public Integer PRH_NbOfNewCollects;
	
	global void execute(SchedulableContext sc)
    {
		ManageCreationOfCollectsForIconicAcc();
	}
	
    public void ManageCreationOfCollectsForIconicAcc()
    {
		// Retrieve current date
		System.debug('=> ManageCreationOfCollectsForIconicAcc, current date :' + system.today().format());
		Date todayDate = system.today();
		Integer currentDay = todayDate.day();
		Integer currentMonth = todayDate.month();
		Integer currentYear = todayDate.year();
		Date PRH_PeriodStartDate;
		Date PRH_PeriodEndDate;
		List<PRH_Luxury_Accounts__c> iconicAccList;
		List<PRH_Collect__c> activeCollect;
		List<PRH_Collect__c> listOfNewCollects = new List<PRH_Collect__c >();
		List<PRH_Collect__c> listOfCollectsToDeactivate = new List<PRH_Collect__c >();
		PRH_Collect__c newCollect;
		List<PRH_Collect__c> newAllCollects;

		System.debug('=> ManageCreationOfCollectsForIconicAcc, currentDay=' + currentDay + ', currentMonth=' + currentMonth + ', currentYear=' + currentYear);
		
		PRH_NbOfNewCollects = 0;
		// Define Start and End date for new collects to create regarding current date
		if ((currentMonth >= 3) && (currentMonth <= 6)) {
			PRH_PeriodStartDate = date.newInstance(currentYear, 03, 01); 
			PRH_PeriodEndDate = date.newInstance(currentYear, 06, 30);
		} else if ((currentMonth >= 7) && (currentMonth <= 10)) {
			PRH_PeriodStartDate = date.newInstance(currentYear, 07, 01); PRH_PeriodEndDate = date.newInstance(currentYear, 10, 31);
		} else if ((currentMonth == 11) || (currentMonth == 12)) {
			if (Date.isLeapYear(currentYear+1) == true) { // next year is a leap year
				PRH_PeriodEndDate = date.newInstance(currentYear+1, 02, 29);
			} else {
				PRH_PeriodEndDate = date.newInstance(currentYear+1, 02, 28);
			}
			PRH_PeriodStartDate = date.newInstance(currentYear, 11, 01);  // year, month, day
		} else if ((currentMonth == 1) || (currentMonth == 2)) {
			if (Date.isLeapYear(currentYear) == true) { // this is a leap year
				PRH_PeriodEndDate = date.newInstance(currentYear, 02, 29);
			} else {
				PRH_PeriodEndDate = date.newInstance(currentYear, 02, 28);
			}
			PRH_PeriodStartDate = date.newInstance(currentYear-1, 11, 01);  // year, month, day
		}
		System.debug('=> ManageCreationOfCollectsForIconicAcc, PRH_PeriodStartDate=' + PRH_PeriodStartDate + ', PRH_PeriodEndDate='  + PRH_PeriodEndDate);
		
		// Creation of new collects
		try {
			//iconicAccList = [SELECT id, Name FROM PRH_Luxury_Accounts__c WHERE PRH_Suppress_and_archive__c=false ORDER BY Name ASC LIMIT 100];  
			//activeCollect = [SELECT id, Name, PRH_Active__c, PRH_Iconic_Account__c, PRH_Period_End__c, PRH_Period_Start__c FROM PRH_Collect__c WHERE PRH_Active__c = true LIMIT 100];
            iconicAccList = [SELECT id, Name FROM PRH_Luxury_Accounts__c WHERE PRH_Suppress_and_archive__c=false ORDER BY Name ASC LIMIT 50000];  
			activeCollect = [SELECT id, Name, PRH_Active__c, PRH_Iconic_Account__c, PRH_Period_End__c, PRH_Period_Start__c FROM PRH_Collect__c WHERE PRH_Active__c = true LIMIT 50000];
			// For each Iconic account
			if (iconicAccList.size() > 0) {
				System.debug('==> ManageCreationOfCollectsForIconicAcc, ' + iconicAccList.size() + ' Iconic Account(s) retrieved');	
				if (activeCollect.size() > 0) {
					for (PRH_Collect__c c:activeCollect) {
						c.PRH_Active__c = false;
						listOfCollectsToDeactivate.add(c);
					}
				}
				for (PRH_Luxury_Accounts__c ic:iconicAccList) {
					// Create new active collect
					newCollect = new PRH_Collect__c( 
													PRH_Active__c=true, 
													PRH_Iconic_Account__c=ic.id, 
													PRH_Period_Start__c=PRH_PeriodStartDate, 
													PRH_Period_End__c=PRH_PeriodEndDate); 
					//System.debug('==> ManageCreationOfCollectsForIconicAcc, newCollect = ' + newCollect);	
					listOfNewCollects.add(newCollect);
				}
				if (listOfCollectsToDeactivate.size() > 0) {
					update listOfCollectsToDeactivate; 
					System.debug('==> ManageCreationOfCollectsForIconicAcc, ' + listOfCollectsToDeactivate.size() + ' collects have been deactivated');
				}
				if (listOfNewCollects.size() > 0) {
					insert listOfNewCollects; 
					PRH_NbOfNewCollects = listOfNewCollects.size();
					System.debug('==> ManageCreationOfCollectsForIconicAcc, ' + PRH_NbOfNewCollects + ' new collects have been created');
				}
			}			
		} catch (Exception e) {
            System.Debug('### error:'+ e.getMessage());
            System.Debug('### error:'+ e.getLineNumber());
            System.Debug('### error:'+ e.getStackTraceString());
        }	
    }
}