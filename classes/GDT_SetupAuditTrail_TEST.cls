/********************************************************************************
 *  This class contains unit tests for validating the behavior of Apex classes
 *  and triggers.
 *
 *  Unit tests are class methods that verify whether a particular piece
 *  of code is working properly. Unit test methods take no arguments,
 *  commit no data to the database, and are flagged with the testMethod
 *  keyword in the method definition.
 *
 *  All test methods in an organization are executed whenever Apex code is
 *  deployed to a production organization to confirm correctness, ensure code
 *  coverage, and prevent regressions. All Apex classes are required to have at
 *  least 75% code coverage in order to be deployed to a production organization.
 *  In addition, all triggers must have some code coverage.
 *
 *  The @isTest class annotation indicates this class only contains test
 *  methods. Classes defined with the @isTest annotation do not count against
 *  the organization size limit for all Apex scripts.
 *
 *  See the Apex Language Reference for more information about Testing
 *  and Code Coverage.
 *
 * Name     :   GDT_SetupAuditTrail_TEST.cls
 * 
 * Author   :   Simon GAZIN
 * Date     :   12.11.2015
 *********************************************************/
@isTest(SeeAllData=false)
private class GDT_SetupAuditTrail_TEST {

	@isTest static void test_method_one() {
		Test.startTest();
			//Page Reference
			PageReference pageRef = Page.GDT_Setup_Audit_Trail;
			Test.setCurrentPage(pageRef);

			//Instantiate a new controller with all parametres in the page
			GDT_Setup_Audit_Trail__c cObj = new GDT_Setup_Audit_Trail__c();
			ApexPages.StandardController sc = new ApexPages.StandardController(cObj);
			GDT_SetupAuditTrail_Controller satc = new GDT_SetupAuditTrail_Controller(sc);

			/* Batch  */
			satc.runBatch();
			System.debug('Custom Object: ' + satc.cSetupAuditTrail);

			/* TEST From .. To .. (filter) */
			Date myDateTime = Date.newInstance(2015, 01, 01);
			//Start Date
			satc.dt_StartDateForList_SetupAuditTrail = myDateTime;
			System.debug('LIST OF RECORDS: ' + satc.cSetupAuditTrail);
			satc.changeStartDate();

			//Start & End Date
			satc.dt_EndDateForList_SetupAuditTrail = date.today();
			System.debug('LIST OF RECORDS: ' + satc.cSetupAuditTrail);
			satc.changeStartDate();

			//End Date
			satc.dt_StartDateForList_SetupAuditTrail = null;
			System.debug('LIST OF RECORDS: ' + satc.cSetupAuditTrail);
			satc.changeStartDate();

			/* Scheduler */
			GDT_SetupAuditTrail_Scheduler scheduledTest = new GDT_SetupAuditTrail_Scheduler();
			String strScheduler = '0 0 9 * * ?';
			system.schedule('Test GDT_SetupAuditTrail_Scheduler', strScheduler, scheduledTest);

		Test.stopTest();
	}



}