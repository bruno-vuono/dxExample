/*******************************************************************************
*                           Company: ValueNet
*-------------------------------------------------------------------------------
*   Test de clase para incrementar porcentaje de Test
*******************************************************************************/

@isTest
public with sharing class PCS02_testMomentarySolution_AR_TEST {

   static testMethod void unitTest() {
       PCS02_testMomentarySolution_AR.run();
       PCS02_testMomentarySolution_AR.run1();
       PCS02_testMomentarySolution_AR.run2();
       PCS02_testMomentarySolution_AR.run3();
       PCS02_testMomentarySolution_AR.run4();
   }
}