/***********************************************************************************
 * Name: EUR_CRM_PRS_ListingTplAssignmentHdlrTest
 * Description: Test Class for EUR_CRM_PRS_ListingTplAssignmentHandler 
 *
 * Version History
 * Date         Developer   			Comments
 * ----------   -------------------  	--------------------------------------------    
 *  5-7-2017  	[Laputa] Kevin Choi  	Created. 
***********************************************************************************/

@isTest
public class EUR_CRM_PRS_ListingTplAssignmentHdlrTest {
    private static EUR_CRM_PRS_Group_Outlet_Type__c goutletType;
    private static EUR_CRM_PRS_Outlet_Type__c outletType;
    private static EUR_CRM_PRS_Seg_Aspect__c imgLevel;
    private static EUR_CRM_PRS_Seg_Aspect__c volPotential;
    
    
    static void createData(){
        
        //create Template
        Id seTemplateRt = Global_RecordTypeCache.getRtId('EUR_CRM_JB_Template__c' + 'EUR_BE_On_Trade_Template');
        EUR_CRM_JB_Template__c seTemplate = new EUR_CRM_JB_Template__c(Name = 'Test BE Template', recordTypeId = seTemplateRt);
        Insert seTemplate;
        
        //Create Template Criteria
        Id setempCriteriaRt = Global_RecordTypeCache.getRtId('EUR_CRM_JB_Template_Criteria__c' + 'EUR_BE_On_Trade_Template_Criteria');
        
        goutletType = new EUR_CRM_PRS_Group_Outlet_Type__c(EUR_CRM_Name__c='Restaurant');
        insert goutletType;
        
        outletType = new EUR_CRM_PRS_Outlet_Type__c(EUR_CRM_PRS_Outlet_Type_Name__c='Restaurant', EUR_CRM_PRS_Group_Outlet_Type__c=goutletType.Id);
        insert outletType;
        
        Id imageLevelRt = Global_RecordTypeCache.getRtId('EUR_CRM_PRS_Seg_Aspect__c' + 'EUR_BE_PRS_Segmentation_Aspect_Image_Level');
        imgLevel = new EUR_CRM_PRS_Seg_Aspect__c(recordTypeId = imageLevelRt,
                                                 EUR_CRM_Segmentation_IL_Aspect_Name__c='Iconic');
        insert imgLevel;
        
        Id volPotentialRt = Global_RecordTypeCache.getRtId('EUR_CRM_PRS_Seg_Aspect__c' + 'EUR_BE_PRS_Segmentation_Aspect_Volume_Potential');
        volPotential = new EUR_CRM_PRS_Seg_Aspect__c(recordTypeId = volPotentialRt,
                                                     EUR_CRM_Segmentation_VP_Aspect_Name__c='High');
        insert volPotential;        
        
        EUR_CRM_JB_Template_Criteria__c tempCriteria = new EUR_CRM_JB_Template_Criteria__c(EUR_JB_Active__c = true,
                                                                                           EUR_CRM_PRS_Group_Outlet_Type__c = goutletType.id,
                                                                                           EUR_CRM_PRS_Outlet_Type__c = outletType.id,
                                                                                           EUR_CRM_PRS_Seg_Aspect_IL__c = imgLevel.id,
                                                                                           EUR_CRM_PRS_Seg_Aspect_VP__c = volPotential.id,
                                                                                           EUR_JB_Template__c = seTemplate.Id,
                                                                                           recordTypeId = setempCriteriaRt);
        insert tempCriteria;
        
    }
    
    static testMethod void testBEOnTrade(){
        //Create Account
        createData();
        Test.startTest();
        
        Id seVisitRt = Global_RecordTypeCache.getRtId('EUR_CRM_Visit_Frequency__c' + 'EUR_BE_Visit_Frequency');
        EUR_CRM_Visit_Frequency__c seVisit = new EUR_CRM_Visit_Frequency__c(Name = 'Test Visit',
                                                                            EUR_CRM_No_of_Visits_Within_Interval__c = 2,
                                                                            EUR_CRM_Frequency_Span_Days__c = 2,
                                                                           recordTypeId = seVisitRt);
        
        insert seVisit;
        
        Id seAccountRt = Global_RecordTypeCache.getRtId('EUR_CRM_Account__c' + 'EUR_BE_On_Trade');
        EUR_CRM_Account__c seOnTrade = new EUR_CRM_Account__c(recordTypeId = seAccountRt,
                                                              Name = 'Test SE Account',
                                                              EUR_CRM_Company_Name__c = 'ABC',
                                                              EUR_CRM_Channel__c = 'Chain',
                                                              EUR_CRM_Business_Type__c = 'Outlet',
                                                              EUR_CRM_Status__c = 'Active',
                                                              EUR_CRM_Street__c = 'Street',
                                                              EUR_CRM_City__c = 'Ciry',
                                                              EUR_CRM_Postal_Code__c = 'Z1',
                                                              EUR_CRM_Delivery_Type__c = 'Direct', 
                                                              EUR_CRM_Visit_Frequency__c = seVisit.Id,
                                                              EUR_CRM_PRS_Group_Outlet_Type__c = goutletType.id,
                                                              EUR_CRM_PRS_Outlet_Type__c = outletType.id,
                                                              EUR_CRM_PRS_Image_Level__c = imgLevel.id,
                                                              EUR_CRM_PRS_Volume_Potential__c = volPotential.id
                                                              //EUR_CRM_Territory__c = 
                                                             );
        insert seOnTrade;
        
        Test.stopTest();
        
        
    }
}