public class ASI_CRM_ADPasswordController {
    Public user UserDetail {get;set;} 
    public boolean SaveSuccess {get;set;}
    public boolean UpsertPermission {get;set;}
    public string msg  {get;set;}
    
    public string passwords  {get;set;}{passwords='';}
    
    public boolean havePassword {get;set;}
    
    public ASI_CRM_ADPasswordController() {
        init();
        
    }
    
    public void init() {
        SaveSuccess=false;
        
        UpsertPermission=true;
        msg='';
        UserDetail= [Select Title,Department,ADDomainUser__c,ASI_CRM_AD_Password__c,CompanyName,FirstName,LastName,SmallPhotoUrl, FullPhotoUrl From User where id=:Userinfo.getUserid()];
        if(UserDetail.ASI_CRM_AD_Password__c!=null){
            havePassword=true;
        }else{
            havePassword=false;
        }
        
    }
    
    
    public void save() {
        
        System.Savepoint pSavepoint = Database.setSavepoint();
        try
        {
            UserDetail.ASI_CRM_AD_Password__c=passwords;
            update UserDetail;
            SaveSuccess=true;
        }catch(Exception e){
            UpsertPermission=false;
            msg += 'Save Error : ' +e.getMessage() + '</br>';
            Database.rollback(pSavepoint);  
        } 
    }
    
    public void ResetPassword(){
        passwords=null;
        SaveSuccess=false;
        havePassword=false;
    }
    
  
    
}