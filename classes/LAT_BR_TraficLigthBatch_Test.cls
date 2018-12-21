@isTest
public with sharing class LAT_BR_TraficLigthBatch_Test {
    
    
  Profile perfil                        = null;
  User usuario                          = null;
  List<RecordType> listRecType          = null;
  List<String> developerName            = null;
  Map<String, String> mapRecType        = null;
  String idAccount                      = null;
  Account acc                                                   = null;
    public LAT_BR_TraficLigthBatch_Test() {
        
    }

    private static void loadData() {
      //Recupera os IDS de tipo de registro.
      
      String idAccount = RecordTypeForTest.getRecType('Account','Off_Trade');
     
          User usuario = new User();
      usuario = LAT_TestUserAdmin.userWithAdminPorf ('Nome2','Sobrenome2','NSobre2','nome2@sobrenome.com','PriceCalculationInterface@mail.com','123jjjuuu2','ISO-8859-1','GMT','en_Us','en_Us','234','BR'); 
      insert usuario; 
      
     

      User usuario2 = new User();
      usuario2.FirstName       = 'Nome3';
      usuario2.LastName      = 'Sobrenome3';
      usuario2.Alias       = 'NSobre3';
      usuario2.Email         = 'nome3@sobrenome.com';
      usuario2.Username      = 'zimmicTestingUser2@pernod-ricard3.com.latsb5conf';
      usuario2.CommunityNickname   = '123jjjuuu3';
      usuario2.EmailEncodingKey  = 'ISO-8859-1';
      usuario2.TimeZoneSidKey    = 'GMT';
      usuario2.LocaleSidKey    = 'en_Us';
      usuario2.LanguageLocaleKey = 'en_Us';
      usuario2.C_digo_JDE__c   = '235';
      usuario2.ProfileId       = usuario.ProfileId;
      usuario2.ManagerId      = usuario.Id;
      usuario2.Regional_de_vendas__c = usuario.Id;
      usuario2.Gerente_regional__c = usuario.Id;
      usuario2.Country = 'BR';
      insert usuario2; 


      

      return;
    }

    private static Planejamento__c  nuevoPlanejamiento(String nombre, String mes) { 
        Planejamento__c planejamento = new Planejamento__c (
      Name = 'test ' + nombre ,
      M_s_de_Ref_rencia__c = mes,
      Ano_de_Referencia__c = '2015'
    );
    return planejamento;
  }      
  
  private static Visitas__c nuevaVisita (Planejamento__c p, String nombre, Account acc) {
    Visitas__c visita = new Visitas__c(
        Name = 'test ' + nombre,
        Tipo_de_Visita__c = 'Vendas',
        Hora_da_Visita__c = '10:00',
        Resumo_da_Visita__c = 'This is a test',
        Conta__c = acc.Id,
        Planejamento__c = p.Id,
        Data_da_Visita__c = Date.today().addDays(-2)
    );
    return visita;
  }

  static testMethod void test1() {
    LAT_BR_TL_CamposPreenchidos__c cs = new LAT_BR_TL_CamposPreenchidos__c(Name = 'Agencia', LAT_BR_Conditions__c = 'Type:Outros', LAT_BR_Field__c = 'Agency__c', LAT_BR_Type__c = 'Text'); 
    insert cs;
    
    loadData();
    User u = [SELECT Id FROM User LIMIT 1];
    Account acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc.Price_Group__c = '602037025';
    acc.Client_country_AN8__c = '1-8899';
    acc.Client_code_AN8__c = '8899';
    acc.Status__c = 'Cliente cadastrado no JDE';
    acc.OwnerId = u.Id;
    
    insert acc;  
    Test.startTest();
    Planejamento__c p = nuevoPlanejamiento('1', 'Janeiro');
    insert p;
    Visitas__c v = nuevaVisita(p, 'a', acc);
    insert v;
    Planejamento__c p2 = nuevoPlanejamiento('2', 'Fevereiro');
    insert p2;
    Visitas__c v2 = nuevaVisita(p2, 'b', acc);
    insert v2;
    LAT_BR_TraficLightBatch tlb = new LAT_BR_TraficLightBatch(1,6,8,2015);
    if(runBatchs())Database.executeBatch(tlb, 10);
    Test.stopTest();
  } 

  static testMethod void test2() {
    LAT_BR_TL_CamposPreenchidos__c cs = new LAT_BR_TL_CamposPreenchidos__c(Name = 'Agencia', LAT_BR_Conditions__c = 'Type:Outros', LAT_BR_Field__c = 'Agency__c', LAT_BR_Type__c = 'Text'); 
    insert cs;
    
    loadData();
    User u = [SELECT Id, FirstName FROM User WHERE FirstName = 'Nome2' LIMIT 1];
    User u2 = [SELECT Id, FirstName FROM User WHERE FirstName = 'Nome3' LIMIT 1];
    System.debug('aaaaaaaaaaaa  u : ' + u + ' u2 : ' + u2);
    Account acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc.Price_Group__c = '602037025';
    acc.Client_country_AN8__c = '1-8899';
    acc.Client_code_AN8__c = '8899';
    acc.Status__c = 'Cliente cadastrado no JDE';
    acc.OwnerId = u.Id;
    acc.Revenue_Neighbourhood__c = 'Teste teste';
    acc.Frequency_of_Visits__c = 'Mensal';

    Contact cont = new Contact();
    cont.LastName = 'Test Contact';
    cont.AccountId = acc.Id;
    cont.OwnerId = u.Id;
    insert cont;
    
    insert acc;  
    Test.startTest();

    Account acc2 = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc2.Price_Group__c = '602037025';
    acc2.Client_country_AN8__c = '1-8833';
    acc2.CNPJ__c = '73909400000783';
    acc2.Client_code_AN8__c = '8833';
    acc2.Status__c = 'Novo Cadastro';
    acc2.OwnerId = u2.Id;
    acc2.Revenue_Neighbourhood__c = 'Teste teste';
    acc2.Frequency_of_Visits__c = 'Mensal';
    insert acc2;

    Contact cont2 = new Contact();
    cont2.LastName = 'Test Contact';
    cont2.AccountId = acc2.Id;
    cont2.OwnerId = u2.Id;
    insert cont2;

    Planejamento__c p = nuevoPlanejamiento('1', 'Março');
    insert p;
    
    LAT_BR_CPO_ClientPortfolio__c port = new LAT_BR_CPO_ClientPortfolio__c();
    port.LAT_BR_City__c = acc.Revenue_City__r.Name;
    port.LAT_BR_Client__c = acc.Id;
    port.LAT_BR_ClientCodeAN8__c = acc.Client_code_AN8__c;
    port.LAT_BR_Neighbourhood__c = acc.Revenue_Neighbourhood__c;
    port.LAT_BR_VisitsFrequency__c = acc.Frequency_of_Visits__c;
    port.LAT_BR_VisitPlanning__c = p.Id;
    insert port;

    Visitas__c v = nuevaVisita(p, 'a', acc);
    insert v;
    Planejamento__c p2 = nuevoPlanejamiento('2','Abril');
    insert p2;
    Visitas__c v2 = nuevaVisita(p2, 'b', acc);
    insert v2;

    LAT_BR_CPO_ClientPortfolio__c port2 = new LAT_BR_CPO_ClientPortfolio__c();
    port2.LAT_BR_City__c = acc2.Revenue_City__r.Name;
    port2.LAT_BR_Client__c = acc2.Id;
    port2.LAT_BR_ClientCodeAN8__c = acc2.Client_code_AN8__c;
    port2.LAT_BR_Neighbourhood__c = acc2.Revenue_Neighbourhood__c;
    port2.LAT_BR_VisitsFrequency__c = acc2.Frequency_of_Visits__c;
    port2.LAT_BR_VisitPlanning__c = p2.Id;
    insert port2;
    LAT_BR_TraficLightBatch tlb = new LAT_BR_TraficLightBatch(1,6,8,2015);
    if(runBatchs())Database.executeBatch(tlb, 100);
    LAT_BR_TraficLightBatch tlb2 = new LAT_BR_TraficLightBatch(6,6,8,2015);
    if(runBatchs())Database.executeBatch(tlb2, 100);
    Test.stopTest();
  } 

  static testMethod void test3() {
    LAT_BR_TL_CamposPreenchidos__c cs = new LAT_BR_TL_CamposPreenchidos__c(Name = 'Agencia', LAT_BR_Conditions__c = 'Type:Outros', LAT_BR_Field__c = 'Agency__c', LAT_BR_Type__c = 'Text'); 
    insert cs;
    
    loadData();
    User u = [SELECT Id FROM User LIMIT 1];
    Account acc = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc.Price_Group__c = '602037025';
    acc.Client_country_AN8__c = '1-8899';
    acc.Client_code_AN8__c = '8899';
    acc.Status__c = 'Cliente cadastrado no JDE';
    acc.OwnerId = u.Id;
    
    insert acc;  
    Test.startTest();

    Account acc2 = LAT_Account_TestFactory.getBRAAccountBase('Off_Trade');
    acc2.Price_Group__c = '602037025';
    acc2.Client_country_AN8__c = '1-8833';
    acc2.CNPJ__c = '73909400000783';
    acc2.Client_code_AN8__c = '8833';
    acc2.Status__c = 'Novo Cadastro';
    acc2.OwnerId = u.Id;
    acc2.Revenue_Neighbourhood__c = 'Teste teste';
    acc2.Frequency_of_Visits__c = 'Mensal';
    insert acc2;

    Planejamento__c p = nuevoPlanejamiento('1', 'Junho');
    insert p;
    Visitas__c v = nuevaVisita(p, 'a', acc);
    insert v;
    Planejamento__c p2 = nuevoPlanejamiento('2', 'Julho');
    insert p2;
    Visitas__c v2 = nuevaVisita(p2, 'b', acc2);
    insert v2;
    LAT_BR_TraficLightBatch tlb = new LAT_BR_TraficLightBatch(3,3,8,2015);
    if(runBatchs())Database.executeBatch(tlb, 10);
    Test.stopTest();
  } 

  public static Boolean runBatchs(){
    List<AsyncApexJob> listAsyncApexJob = [SELECT id FROM AsyncApexJob 
                                                   WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')];
        //se chequea el limite de Salesforce, si hay cupo disponible se ejecuta el batch, sino se vuelve a hacer el schedule            
        if (listAsyncApexJob == null || listAsyncApexJob != null && listAsyncApexJob.size() < 5){
          return true;
        }
        return false;
  }

}