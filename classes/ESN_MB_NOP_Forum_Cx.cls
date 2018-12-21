/**
    About
    -----
    Description: Controler Class for MyBrands Application project
    Created for salesforce PS SOW : Pernod Ricard
    Create date: Sept 2014

    Details
    -------
    This class contains methods for controlling forum screen
    
    Update History
    --------------
    Sept 2014 / Created by Xavier Défossez

    Issues / TODOs
    --------------
    
*/

global class ESN_MB_NOP_Forum_Cx {
    
    public ESN_MB_NOP_Forum_Cx () {
        
    }
    
    /*
     * retrieve chatter group id for forum scree
     * 
     */
    @RemoteAction
    global static String getForumId (String brandId)
    {
       // String forumId { get {return [SELECT ESN_MB_ChatterGroup_Id__c FROM ESN_MB_NodePage__c WHERE id= :brandId Limit 1].ESN_MB_ChatterGroup_Id__c; } set; }
        return 'forumId';
    }
}