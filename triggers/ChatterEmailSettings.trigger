/**********************************************************************************/
/* Triggered when a new user is inserted and configure the Chatter Email Settings */
/**********************************************************************************/
trigger ChatterEmailSettings on User (before insert) {
    // Receive Chatter emails                        = false
    // Follows me                                    = true
    // Posts on my profile                           = true
    // Comments on my status or a change I made      = true
    // Comments after me                             = true
    // Comments on a post on my profile              = true
    // USERPREFERENCESCONTENTNOEMAIL                 = true
    // USERPREFERENCESCONTENTEMAILASANDWHEN          = true
    // Mentions me in a post                         = false
    // Mentions me in a comment                      = false
    // Comments on an item I like                    = true
    // Likes a post or a comment I made              = true
    // Sends me a message                            = false
    // Comments on an item I bookmarked              = true
    // Shares a post I made                          = true
        
    String triggerName = 'ChatterEmailSettings';
 
     /* Get User profile for bypassing execution by System Administrator GDT - Jef 01/10/2013 */
    if((UserInfo.getProfileId()!='00eD0000001ApvPIAS') && (UserInfo.getProfileId()!= '00eL0000000DkgiIAC'))
{   
    /* Get context User */
    User thisUser = [ SELECT Id,BypassTriggers__c FROM User WHERE Id = :UserInfo.getUserId() ];
    String bypass = ''+thisUser.BypassTriggers__c;
    
    /* Check if this trigger is bypassed or not */
    if(!bypass.contains(triggerName)){
        for (User u : Trigger.New) {
            // Receive Chatter emails
            u.USERPREFERENCESDISABLEALLFEEDSEMAIL = false;
            // Follows me
            u.USERPREFERENCESDISABLEFOLLOWERSEMAIL = true;
            // Posts on my profile
            u.USERPREFERENCESDISABLEPROFILEPOSTEMAIL = true;
            // Comments on my status or a change I made
            u.USERPREFERENCESDISABLECHANGECOMMENTEMAIL = true;
            // Comments after me
            u.USERPREFERENCESDISABLELATERCOMMENTEMAIL = true;
            // Comments on a post on my profile
            u.USERPREFERENCESDISPROFPOSTCOMMENTEMAIL = true;
            // XX
            u.USERPREFERENCESCONTENTNOEMAIL = true;
            // XX
            u.USERPREFERENCESCONTENTEMAILASANDWHEN = true;
            // Mentions me in a post
            u.USERPREFERENCESDISABLEMENTIONSPOSTEMAIL = false;
            // Mentions me in a comment
            u.USERPREFERENCESDISMENTIONSCOMMENTEMAIL = false;
            // Comments on an item I like
            u.USERPREFERENCESDISCOMMENTAFTERLIKEEMAIL = true;
            // Likes a post or a comment I made
            u.USERPREFERENCESDISABLELIKEEMAIL = true;
            // Sends me a message
            u.USERPREFERENCESDISABLEMESSAGEEMAIL = false;
            // Comments on an item I bookmarked
            u.USERPREFERENCESDISABLEBOOKMARKEMAIL = true;
            // Shares a post I made 
            u.USERPREFERENCESDISABLESHAREPOSTEMAIL= true; 
        }
    }
} }