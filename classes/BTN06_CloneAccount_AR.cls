/******************************************************************************************************************************************************************************
*   Company:Valuenet    Developers:   Tomás Etchegaray                                                                                                                                                     *
*   Date:22/03/2013     Descripcion: Clona una cuenta exeptuando algunos campos que se los paso por custom setting                                                    *
********************************************************************************************************************************************************************************/


global with sharing class BTN06_CloneAccount_AR {
    
     webService static String AccountClone(String idAccount){
           
            try{ 
                    /*CONSULTO EL RT DEL ACCOUNT*/
                    
                    Account acc = [SELECT Id, Segmentation_Type_on_trade__c,Name,ParentId FROM Account WHERE id=:idAccount];
        
        
                    //Redireccionar a una pagina standard
                    String prefixObj = SRV_Survey_ARG__c.SObjectType.getDescribe().getKeyPrefix();
                    
                   
                    String accName = acc.Name;
                    String accId = acc.id;
                    String Perent;
                    String PerentName;
                    
                 
               
               /* String idCampo =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='AccountName_AR__c' AND ObjectApiName__c='SRV_Survey_ARG__c'].FieldId__c;
                    idCampo = 'CF'+idCampo;
                    String idAcc = '&'+idCampo+'_lkid=';
                    String urlReturn = prefixObj+'/e?RecordType='+Rt.id+'&nooverride=1&ent=Account&retURL=%2F'+idAccount+'&'+idCampo+'
                    ='+EncodingUtil.urlEncode(accName, 'UTF-8')+idAcc+EncodingUtil.urlEncode(accId, 'UTF-8') ;*/
                    
                    String idCampo_01 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Client_code_AN8__c' AND ObjectApiName__c='Account'].FieldId__c;
                    String idCampo_02 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Credit_line__c' AND ObjectApiName__c='Account'].FieldId__c;
                    String idCampo_03 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Rating_segmentation_targert_market__c' AND ObjectApiName__c='Account'].FieldId__c;
                    String idCampo_04 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Status__c' AND ObjectApiName__c='Account'].FieldId__c;
                    /* modificacion por bug*/
                    
                   
                    String idCampo_05 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='ParentId' AND ObjectApiName__c='Account'].FieldId__c;
                    String idCampo_06 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='ParentName' AND ObjectApiName__c='Account'].FieldId__c;
                    
                    String idCampo_07 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Overdue__c' AND ObjectApiName__c='Account'].FieldId__c;
                    String idCampo_08 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Credit_line_USD_AR__c' AND ObjectApiName__c='Account'].FieldId__c;
                     String idCampo_09 =[SELECT Id, FieldId__c FROM CS002_FIeldsIds__c WHERE FieldApiName__c='Sub_Channel__c' AND ObjectApiName__c='Account'].FieldId__c;
                    
                    
                    
                    if ( acc.ParentId == null){
                        Perent = acc.id;
                        PerentName = acc.Name;
                    }else{
                        Perent = acc.ParentId;
                        Account accPAdre = [SELECT Id, Name FROM Account WHERE id =: Perent] ;
                        PerentName = accPAdre.Name;
                    }
                    
                    String val = 'false';
                    system.debug('asdtestNAME'+PerentName);
               
              
                    String urlReturn = '/'+accId+'/e?clone=1&'+idCampo_01+'=+'+'&'+idCampo_02+'=+'+'&'+idCampo_03+'=+'+'&'+idCampo_04+'=Novo Cadastro'+'&'+idCampo_05+'='+Perent+'&'+idCampo_06+'='+PerentName+'&'+idCampo_07+'='+val+'&'+idCampo_08+'='+''+'&'+idCampo_09+'='+'';
                    
                    //{!Account.Id}/e?clone=1&acc3={!Account.Name}
                    // LINEA QUE FUNCIONA   String urlReturn = prefixObj+'/e?RecordType='+Rt.id+'&nooverride=1&ent=Account&retURL=%2F'+idAccount;
        
                    
                    return urlReturn;
             }catch(Exception e){return '';}
     }
}