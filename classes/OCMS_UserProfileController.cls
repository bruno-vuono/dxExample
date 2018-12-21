/* OCMS_UserProfileController.cls
 *
 * @description Retrieves the user profile image url (thumbnail) and firstname
 *
*/

public with sharing class OCMS_UserProfileController {
    
    public string queryString{get; set;}
        
    public string response{get;set;}
    
    //Action passed via URL parameter to determine what the ajax call wants us to do
    public string action{get;set;}
    
    private Map<String, String> parameters; 
        
    public OCMS_UserProfileController() {
        // *** CONSTRUCTOR *** //
        this.parameters =  System.currentPageReference().getParameters();
    }
    
    public PageReference loadResponse() {
    
        //Get action from URL parameter
        this.action = this.parameters.get('action');   
        if (this.action == 'getprofileinfo') {
            //Ajax is requesting to build json string for getting logged in user info
            getUserProfileInfo();
        } else {
            this.response = '{"error":{"message":"Invalid Action"}}';
        }
        
        return null;
    }
    
    public static string getPageParametersString() {
        String resp = '\n';
        if (Apexpages.currentPage() != null) {
            Map<string,string> parameters = Apexpages.currentPage().getParameters();
            for (String key:parameters.keySet()) {
                resp += '  ' +key + ':' +parameters.get(key) + '\n';
            }
        }
        return(resp);
    } 
    
    public static void sendException (exception e, String Location, String ExtraInformation, String toEmail) {
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Strings to hold the email addresses to which you are sending the email. 
            
        String[] toAddresses;
        if (toEmail == null) {
          toAddresses= new String[] {'ps@stantive.com'};
        } else  {
          toAddresses= new String[] {toEmail};
        }
        // Assign the addresses for the To and CC lists to the mail object. 
        mail.setToAddresses(toAddresses);
        // Specify the address used when the recipients reply to the email.  
        mail.setReplyTo('ps@stantive.com');
        // Specify the name used as the display name. 
        mail.setSenderDisplayName('PS Exception');
          
        // Specify the subject line for your email address. 
        mail.setSubject('PS Exception From:' + UserInfo.getOrganizationName());
        
        // Set to True if you want to BCC yourself on the email. 
        mail.setBccSender(false);
        String Message= 'Exception caught in customer org '+UserInfo.getOrganizationName() + ' (OrgId: '+UserInfo.getOrganizationID() + ')\n';
        message += 'Running user:' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' (' + userInfo.getUserId()+ ')\n';
        if (Apexpages.currentPage() != null) {
            Message += 'Page Parameters:' +getPageParametersString() + '\n\n';
        }
        message += 'Exception location:' + Location + '\n';
        message += 'Line: ' + e.getLineNumber(); 
        if (ExtraInformation != null) {
            message+='\nExtra Information: ' + ExtraInformation;
        }
        message += '\nMessage:' + e.getMessage();
        message += '\nCause:' + e.getCause();
        message += '\nStack Trace:\n';
        message += e.getStackTraceString();
        
        mail.setPlainTextBody( message); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     
    }
    
    public class UserProfileObj {
        String firstname;
        String photourl; 
        public UserProfileObj() {}
    }
    
    public void getUserProfileInfo() {
        try {
            SObject[] userObj;
            queryString = 'SELECT FirstName, SmallPhotoUrl FROM User WHERE Id = \'' + UserInfo.getUserId() + '\' LIMIT 1';
            userObj = Database.query(queryString);
            if (userObj.size() > 0) {
                List<UserProfileObj> lUserInfo = new List<UserProfileObj>();
                for (SObject io : userObj) {
                    UserProfileObj uobj = new UserProfileObj();
                    uobj.firstname = (String)io.get('FirstName');
                    uobj.photourl = (String)io.get('SmallPhotoUrl');
                    lUserInfo.add(uobj);    
                }
                this.response = '{"success":true, "profileinfo":' + JSON.serialize(lUserInfo) + '}';
            } else {
                this.response = '{"success":false}';
            }
         } catch (exception e) {
           sendException(e, null, null, null);
        }  
    }
    
    @isTest(SeeAllData=true) 
    static void userProfileTest()   {
        User thisUser = [select Id from User where Id = '005D00000023p6O']; 
        System.runAs(thisUser){
            System.debug('********* Test getting logged in user information   ************');
            
            System.currentPageReference().getParameters().put('action', 'getprofileinfo');
            OCMS_UserProfileController cont = new OCMS_UserProfileController();
            cont.loadResponse();
            system.debug(cont.response);
        }
        
        getPageParametersString();
        String s;
        try {
            s.toLowerCase(); // Since s is null, this call causes 
        } catch (NullPointerException n) {
            sendException(n, null, null, null);
        }
    }
}