// LCS-133 01/06/2017 : Supprimer le bouton Reset Branded Events
public class PRH_Reset_Activation implements Database.Batchable<sObject>{

   final String Query;

   public PRH_Reset_Activation(String q){
      Query=q; 
   }

   public Database.QueryLocator start(Database.BatchableContext BC){

      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, List<sObject> scope){
      /* LCS-133
        List<PRH_Brand_Criteria__c> bcriteria =
             (List<PRH_Brand_Criteria__c>) scope;
        for(PRH_Brand_Criteria__c brandCriteria : bcriteria){
            brandCriteria.PRH_Branded_Event__c = false;
            brandCriteria.PRH_Number_of_Branded_Events__c = 0;
        }
             
        
        
        update bcriteria;
      */
   }

   public void finish(Database.BatchableContext BC){
      /* LCS-133
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     
      List<String> toAddresses = new List<String>();
      User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId()] ;
      toAddresses.add(current_user.Email );

      mail.setToAddresses(toAddresses);
      //Mailing Subject
      String mailingSubject = 'Reset Brand Criteria';
      mail.setSubject(mailingSubject);
      
      //Mailing Message
        
      String mailingMessage  = 'Brand Criteria has been reset.' +'\r\n\r\n'; 
      mailingMessage  += 'Thanks.'+  '\r\n';
      mail.setPlainTextBody(mailingMessage);
      mail.setEmailPriority('High');
      Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail}); 
      */
   }
}