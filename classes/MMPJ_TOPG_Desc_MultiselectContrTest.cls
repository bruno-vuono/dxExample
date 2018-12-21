@isTest
private class MMPJ_TOPG_Desc_MultiselectContrTest{
    static testMethod void testMultiselectController() {
        MMPJ_TOPG_Desc_MultiselectController c = new MMPJ_TOPG_Desc_MultiselectController();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';
        
        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}