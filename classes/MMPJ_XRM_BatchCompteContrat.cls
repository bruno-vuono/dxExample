global class MMPJ_XRM_BatchCompteContrat implements Database.Batchable<sObject> {
    
    public String querySegmentation = 'SELECT Id, Name, MMPJ_Ext_Vign_Statut__c FROM MMPJ_Ext_Vign_Societe__c WHERE MMPJ_Ext_Vign_Societe_Segmentation__c = \'Champagne\'';
   
   global Database.QueryLocator start(Database.BatchableContext bc){
       //String q2 = 'select count() from MMPJ_Ext_Vign_Societe__c WHERE MMPJ_Ext_Vign_Societe_Segmentation__c = \'Champagne\'';
       //System.debug('#### nb acc = ' + Database.countQuery(q2));  
       return Database.getQueryLocator(querySegmentation);
   }
   
   //global void execute(SchedulableContext SC){ Database.executeBatch(new MMPJ_XRM_BatchCompteContrat()); }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<MMPJ_Ext_Vign_Societe__c> ChampagneList = new List<MMPJ_Ext_Vign_Societe__c>();
       List<MMPJ_Ext_Vign_Contrat__c> ListContrat = new List<MMPJ_Ext_Vign_Contrat__c>();

       for(sObject aSObject : scope){
           ChampagneList.add((MMPJ_Ext_Vign_Societe__c)aSObject);
       }

       //Date maDate = Date.newInstance(Date.today().year(),Date.today().month(),Date.today().day());
       Set<Id> accountInCOntrat = new Set<Id>();
       Date startDate = (Date.today() < Date.newInstance(Date.today().year(), 8, 31)) ? Date.newInstance(Date.today().year() - 1, 8, 31) : Date.newInstance(Date.today().year(), 8, 31);

       for(MMPJ_Ext_Vign_Contrat__c con : [SELECT Id,MMPJ_Ext_Vign_Livreur__c FROM MMPJ_Ext_Vign_Contrat__c WHERE MMPJ_Ext_Vign_Livreur__c 
        IN:ChampagneList And (MMPJ_Ext_Vign_Date_de_fin_du_contrat__c > :startDate or MMPJ_Ext_Vign_Date_de_fin_du_contrat__c = null) and RecordType.DeveloperName  = 'MMPJ_Ext_Vign_Appro_Press']){
        accountInCOntrat.add(con.MMPJ_Ext_Vign_Livreur__c);
       }

for(MMPJ_Ext_Vign_Societe__c acc:ChampagneList) {
    if(accountInCOntrat.contains(acc.Id))
        acc.MMPJ_Ext_Vign_Statut__c = 'MMPJ_Ext_Vign_Partenaire';
    else if (!accountInCOntrat.contains(acc.Id) && acc.MMPJ_Ext_Vign_Statut__c != 'MMPJ_Ext_Vign_Prospect')
        acc.MMPJ_Ext_Vign_Statut__c = 'MMPJ_XRM_ExPartenaire';
    }

    Database.SaveResult[] results = Database.update(ChampagneList, false);
    for (Database.SaveResult sr : results) {
      if (!sr.isSuccess()) {         
        for(Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');                    
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
          System.debug('fields that affected this error: ' + err.getFields());
        }
      }
    }
    //update ChampagneList;
   }
   
   global void finish(Database.BatchableContext BC){
   }
}

/*public String querySegmentation = 'SELECT Id, Name, MMPJ_Ext_Vign_Statut__c FROM MMPJ_Ext_Vign_Societe__c WHERE (MMPJ_Ext_Vign_Societe_Segmentation__c = \'Champagne\' And RecordTypeId = \'0127E0000008tjM\')';
    
    global Database.QueryLocator start(Database.BatchableContext bc){   
        return Database.getQueryLocator(querySegmentation);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<MMPJ_Ext_Vign_Societe__c> ChampagneList = new List<MMPJ_Ext_Vign_Societe__c>();
        List<MMPJ_Ext_Vign_Contrat__c> ListContrat = new List<MMPJ_Ext_Vign_Contrat__c>();

        for(sObject aSObject : scope){
            ChampagneList.add((MMPJ_Ext_Vign_Societe__c)aSObject);
        }

        Set<Id> accountInCOntrat = new Set<Id>();
        Map<Id, MMPJ_Ext_Vign_Societe__c> mapSociete = new Map<Id, MMPJ_Ext_Vign_Societe__c>([SELECT Id, MMPJ_Ext_Vign_Statut__c FROM MMPJ_Ext_Vign_Societe__c WHERE (MMPJ_Ext_Vign_Societe_Segmentation__c = 'Champagne' And RecordTypeId = '0127E0000008tjM')]);


        if (Date.today() < Date.newInstance(Date.today().year(),9,1)) {
            Date maDate = Date.newInstance(Date.today().year(),Date.today().month(),Date.today().day());
            String Dquery = 'SELECT Id,MMPJ_Ext_Vign_Livreur__c FROM MMPJ_Ext_Vign_Contrat__c WHERE MMPJ_Ext_Vign_Livreur__c IN:ChampagneList And (MMPJ_Ext_Vign_Date_de_fin_du_contrat__c > :maDate or MMPJ_Ext_Vign_Date_de_fin_du_contrat__c = null)';

            for(MMPJ_Ext_Vign_Contrat__c con : Database.query(Dquery)){
               accountInCOntrat.add(con.MMPJ_Ext_Vign_Livreur__c);
            }
        }

        for(MMPJ_Ext_Vign_Societe__c acc:ChampagneList) {
            if(accountInCOntrat.contains(acc.Id))
                acc.MMPJ_Ext_Vign_Statut__c = 'MMPJ_Ext_Vign_Partenaire';
            else if (mapSociete.get(acc.Id).MMPJ_Ext_Vign_Statut__c != 'MMPJ_Ext_Vign_Prospect')
                acc.MMPJ_Ext_Vign_Statut__c = 'MMPJ_XRM_ExPartenaire';
            }
        update ChampagneList;

    }
    
    global void finish(Database.BatchableContext BC){
    }*/