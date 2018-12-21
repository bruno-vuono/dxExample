/**
 * @name GDT_InitUser_Class
 * @description
 * Automatically add a Role to new PR user, assign default permision sets
 * and add the user into Chatter group
 * 
 * @author Simon GAZIN
 */
public with sharing class GDT_InitUser_Class {

    /* Variable Declaration */
    public String userAffiliateGroup {get;set;}
    public String userCompanyName {get;set;}
    

    /**
     * Substring AD Domain
     * @param  u User
     * @return Valued of the AD Domain cleaned
     */
    public String SubstringADDomaineUser(User u) {

        try {
            return (u.ADDomainUser__c).substring(0, ((u.ADDomainUser__c).indexOf('\\',0)));
        } catch(Exception e) {
            System.debug(e.getMessage());
            return u.ADDomainUser__c;
        }
    }

    /**
     * Before insert, assign a role
     * @param newUser User
     */
     public void InitUserBefore(User newUser) {

        // If Pernod Ricard ESN user
        if(PernodRicardUser(newUser) == true && newUser.isActive == true ){

            //If the user does not have a Role
            if (newUser.UserRoleId == null){
            
                //Assign a role to a user
                AssignRole(newUser);
            }

            /* SETUP for My Brands */
            // Role not null & Salesforce CRM Content User is true
            newUser.UserPermissionsSFContentUser = true;
            
        }
    }

    /**
     * After insert, assign PermissionSet, Chatter Group
     * @param newUser User
     */
     public void InitUserAfter(User newUser) {

        // If Pernod Ricard ESN user
        if(PernodRicardUser(newUser) == true && newUser.isActive == true ){

            // Get Affiliate Group's user
            try {
                userAffiliateGroup = [SELECT AffiliateGroup__c FROM GDT_CustomSettings_ADDomaine__c WHERE ADDomaine__c = :SubstringADDomaineUser(newUser) LIMIT 1].AffiliateGroup__c;
            } catch(Exception e) {
                userAffiliateGroup = null;
                System.debug(e.getMessage());
            }
            // Get Company Name's user
            try {
                userCompanyName = [SELECT CompanyName__c FROM GDT_CustomSettings_CompanyName__c WHERE CompanyNameUser__c = :newUser.CompanyName LIMIT 1].CompanyName__c;    
            } catch(Exception e) {
                userCompanyName = null;
                System.debug(e.getMessage());
            }

            // Assign Permission Set
            AssignPermissionSet(newUser);

            // Assign Chatter Group
            AssignChatterGroup(newUser);
        }
    }
    
    /**
     * Check if the user is Pernod Ricard employee
     * @param  user User
     * @return      True = PR Employee | False = No PR Employee
     */
     public Boolean PernodRicardUser(User user){
        Boolean returnValue = false;

        for(GDT_InitUser_PernodRicardUser__c cs : [SELECT Contains_UserName__c FROM GDT_InitUser_PernodRicardUser__c]) {
            if(user.UserName.contains(cs.Contains_UserName__c) && user.email.contains(cs.Contains_UserName__c)&& user.ADDomainUser__c != null)
                returnValue = true;
        }

        return returnValue;
    }
    
    /**
     * Assign a Role depends on the CompanyName, "ESN" by default
     * @param userN User
     */
     public void AssignRole(User newUser){

        /* Variable Declaration */
        String sRoleToAssign;
        Id idRoleToAssign;
        Id idESN;

        /* ID Role ESN */
        try { 
            idESN = [SELECT Id FROM UserRole WHERE DeveloperName = 'ESN' LIMIT 1].Id;
        } catch(Exception e) {
            idESN = null;
            System.debug(e.getMessage());
        }

        /* Get ID Role */
        try {
            sRoleToAssign = [SELECT DefaultRoleToAssign__c FROM GDT_CustomSettings_CompanyName__c WHERE CompanyNameUser__c = :newUser.CompanyName LIMIT 1].DefaultRoleToAssign__c;
        } catch(Exception e) {
            sRoleToAssign = null;
            System.debug(e.getMessage());
        }

        if(sRoleToAssign == null || sRoleToAssign == '') {
            idRoleToAssign = idESN;
        }
        else {
            try {
                idRoleToAssign = [SELECT Id FROM UserRole WHERE DeveloperName = :sRoleToAssign].Id; 
            } catch(Exception e) {
                idRoleToAssign = idESN;
                System.debug(e.getMessage());
            }       
        }

        /* Assign Role */
        try {
            newUser.UserRoleId = idRoleToAssign;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    

    /**
     * Assign Permission Sets depend on the CustomSettings GDT_InitUser_ListPermissionSet__c
     * @param newUser User
     */
    public void AssignPermissionSet(User newUser) {

        /* Variable Declaration */
        String querySOQL = '';
        Integer assignVerification = 0;

        // PermissionSet Listing
        Map<String, GDT_InitUser_ListPermissionSet__c> mapPermissionSetName = GDT_InitUser_ListPermissionSet__c.getAll();
        List<String> listPermissionSetName = new List<String>();
        listPermissionSetName.addAll(mapPermissionSetName.keySet());

        // Permission Set Id Listing
        List<String> listPermissionSetId = new List<String>();
        
        if(listPermissionSetName != null) {

            for(String name : listPermissionSetName) {
                GDT_InitUser_ListPermissionSet__c permissionSetName = mapPermissionSetName.get(name);

                if( (permissionSetName.GDT_InitUser_Affiliate_Group__c == 'ALL' && permissionSetName.GDT_InitUser_Company_Name__c == 'ALL') || (permissionSetName.GDT_InitUser_Affiliate_Group__c == userAffiliateGroup && permissionSetName.GDT_InitUser_Company_Name__c == 'ALL') || (permissionSetName.GDT_InitUser_Affiliate_Group__c == userAffiliateGroup && permissionSetName.GDT_InitUser_Company_Name__c == userCompanyName && userCompanyName != null) ) {

                    try {
                        listPermissionSetId.add([SELECT Id FROM PermissionSet WHERE Name=:permissionSetName.GDT_InitUser_PermissionSetAPIName__c].Id); 
                    } catch(Exception e) {
                        System.debug(e.getMessage());
                    }
                }
            }   

            for(String id : listPermissionSetId) {

                // Verification Assignment + Assignment
                querySOQL = 'SELECT count() FROM PermissionSetAssignment WHERE AssigneeId=\''+ newUser.Id +'\' AND PermissionSetId=\''+ id +'\'';
                assignVerification = Database.countQuery(querySOQL);

                if(assignVerification == 0) {
                    PermissionSetAssignment newPSA = new PermissionSetAssignment(AssigneeId=newUser.Id, PermissionSetId=id);
                    insert newPSA;
                    System.debug('Permission Set is assigned'); 
                }
                else {
                    System.debug('The user already has this PermissionSet'); 
                }
            }
        }
    }

    /**
     * Assign Chatter Group
     * @param newUser User
     */
    public void AssignChatterGroup(User newUser) {

        /* Variable Declaration */
        String sCompanyName;
        List<GDT_InitUser_ListChatterGroup__c> listAssign_ChatterGroup;
        Id chatterGroupId;


        // Get CompanyName in CustomSettings
        try {
            sCompanyName = [SELECT CompanyName__c FROM GDT_CustomSettings_CompanyName__c WHERE CompanyNameUser__c = :newUser.CompanyName LIMIT 1].CompanyName__c;
        } catch(Exception e) {
            sCompanyName = null;
            System.debug(e.getMessage());
        }

        if(sCompanyName != null) {
            listAssign_ChatterGroup = [SELECT GDT_InitUser_ChatterGroup__c FROM GDT_InitUser_ListChatterGroup__c WHERE GDT_InitUser_CompanyName__c = :sCompanyName OR GDT_InitUser_CompanyName__c = 'ALL'];

            for(GDT_InitUser_ListChatterGroup__c nameChatterGroup : listAssign_ChatterGroup) {
                try {
                    chatterGroupId = [SELECT Id FROM CollaborationGroup WHERE Name = :nameChatterGroup.GDT_InitUser_ChatterGroup__c].Id;

                    if(chatterGroupId != null) {
                        CollaborationGroupMember cgm = new CollaborationGroupMember();
                        cgm.MemberId = newUser.Id;
                        cgm.CollaborationGroupId = chatterGroupId;

                        try {
                            insert cgm;
                            System.debug('Chatter Group is assigned'); 
                        } catch(Exception e) {
                            System.debug(e.getMessage());
                        }
                    }

                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            
            }
        }
        else {
            System.debug('The user\'s CompanyName isn\'t completed.');          
        }
        
    }

}