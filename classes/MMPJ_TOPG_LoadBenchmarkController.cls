public class MMPJ_TOPG_LoadBenchmarkController {

    public Date StatementDate { get; set; }
    public String statementDateString { get; set; }
    public list<MMPJ_TOPG_VolumeBench__c> ListProductBench {get{
                                                                list<MMPJ_TOPG_VolumeBench__c> listDum = [select MMPJ_TOPG_Related_Brand__r.name,MMPJ_TOPG_Price__c,MMPJ_TOPG_AlcoholType__c 
                                                                                                          from MMPJ_TOPG_VolumeBench__c
                                                                                                          Where MMPJ_TOPG_IsCompetitor__c = false  And MMPJ_TOPG_Visit__c =: Visit];
                                                                return listDum ;
                                                               }
                                                            set;}
    public list<MMPJ_TOPG_VolumeBench__c> ListCompetitorBench {get{
                                                                list<MMPJ_TOPG_VolumeBench__c> listDum = [select MMPJ_TOPG_Competitor_Brand_Name__c,MMPJ_TOPG_Price__c,MMPJ_TOPG_AlcoholType__c 
                                                                                                          from MMPJ_TOPG_VolumeBench__c
                                                                                                          Where MMPJ_TOPG_IsCompetitor__c = true And MMPJ_TOPG_Visit__c =: Visit];
                                                                return listDum ;
                                                               }
                                                            set;}
    Map<String,string> MapBrandId {get;set;}
    public String BenchmarkBlob{get;set;}
    public string Visit{get;set;}
    
    public MMPJ_TOPG_LoadBenchmarkController()
    {
        system.debug('constructor');
        BenchmarkBlob='';
        MapBrandId = new Map<String,string>();
        for(MMPJ_TOPG_BRAND__c Brand : [Select Id,Name from MMPJ_TOPG_BRAND__c])
            MapBrandId.put(Brand.name,Brand.id);
        
    }
    
    public pagereference LoadStatement()
    {
        try{
        system.debug('in LoadStatement===');
            String[] line = new String[]{};
            Line= BenchmarkBlob.split('\n');
           //StatementDate  just for testing
            StatementDate =system.today();
            statementDateString =StatementDate.format(); 
            List<MMPJ_TOPG_VolumeBench__c> ListBenchToInsert = new List<MMPJ_TOPG_VolumeBench__c>();
            for(integer i =1;i<Line.size();i++)
            {
                String[] Fields = new String[]{};
                Fields = Line[i].split(';');
                if(Fields.size() == 4){
                    MMPJ_TOPG_VolumeBench__c VolumBench= new MMPJ_TOPG_VolumeBench__c();
                    if(MapBrandId.containsKey(Fields[1]))
                    {
                        VolumBench.MMPJ_TOPG_Related_Brand__c= MapBrandId.get(Fields[1]);
                        VolumBench.MMPJ_TOPG_IsCompetitor__c = false;
                    }
                    else
                    {
                        VolumBench.MMPJ_TOPG_Competitor_Brand_Name__c = Fields[1];
                        VolumBench.MMPJ_TOPG_IsCompetitor__c = true;
                    }
                    VolumBench.MMPJ_TOPG_MarqueBenchmark__c = Fields[0];
                    VolumBench.MMPJ_TOPG_AlcoholType__c = Fields[2];
                    if(!string.isBlank(Fields[3]))
                        VolumBench.MMPJ_TOPG_Price__c =  Integer.valueof(Fields[3].trim());
                    else
                        VolumBench.MMPJ_TOPG_Price__c = 0;
                    VolumBench.MMPJ_TOPG_Visit__c = Visit;
                    VolumBench.MMPJ_TOPG_StatementDate__c = system.today();
                    ListBenchToInsert.add(VolumBench);
                }
            }
             system.debug('in ListBenchToInsert==='+ListBenchToInsert.size());
            if(ListBenchToInsert.size() > 0)
            {
                try
                {
                    Database.delete(ListProductBench,true);
                    Database.delete(ListCompetitorBench,true);
                    Database.insert(ListBenchToInsert,true);
                }
                catch (exception ex )
                {
                    HandleException(ex);
                }
            }
        }
        catch (exception ex )
        {
            HandleException(ex);
        }
        return null;
    }
    public string errortitle{get;set;}
    public string errordetail{get;set;}
    public void  HandleException(Exception ex){
        System.Debug('### UploadPicture ' );
        errortitle= ex.getMessage() + '\n' + ex.getLineNumber(); 
        errordetail = ex.getStackTraceString();
    } 
   
    public map<string,set<string>> mapBrenchmarkSetMark {get;set;}
    public map<string,map<string,map<string,decimal>>> mapMarqueTypeAlcoholPrix{get{
                                                                                    list<MMPJ_TOPG_VolumeBench__c> listDum = [select MMPJ_TOPG_Related_Brand__r.name,MMPJ_TOPG_Price__c,MMPJ_TOPG_AlcoholType__c,MMPJ_TOPG_MarqueBenchmark__c,MMPJ_TOPG_IsCompetitor__c ,MMPJ_TOPG_Competitor_Brand_Name__c  
                                                                                                                              from MMPJ_TOPG_VolumeBench__c
                                                                                                                              Where MMPJ_TOPG_Visit__c =: Visit];
                                                                                    map<string,map<string,map<string,decimal>>> mapReturnValue = new map<string,map<string,map<string,decimal>>>();
                                                                                    mapBrenchmarkSetMark = new map<string,set<string>>();
                                                                                    if(listDum.size() < 1)
                                                                                        return null;
                                                                                    for(MMPJ_TOPG_VolumeBench__c VLBench : listDum)
                                                                                    {
                                                                                        //system.debug('VLBench ' + VLBench);
                                                                                        if(mapReturnValue.containskey(VLBench.MMPJ_TOPG_MarqueBenchmark__c))
                                                                                        {
                                                                                            if(mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).containskey(VLBench.MMPJ_TOPG_AlcoholType__c))
                                                                                            {
                                                                                                if(VLBench.MMPJ_TOPG_IsCompetitor__c)
                                                                                                    mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).get(VLBench.MMPJ_TOPG_AlcoholType__c).put(VLBench.MMPJ_TOPG_Competitor_Brand_Name__c ,VLBench.MMPJ_TOPG_Price__c);
                                                                                                else
                                                                                                    mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).get(VLBench.MMPJ_TOPG_AlcoholType__c).put(VLBench.MMPJ_TOPG_Related_Brand__r.name,VLBench.MMPJ_TOPG_Price__c);
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).put(VLBench.MMPJ_TOPG_AlcoholType__c, new map<string, decimal>());
                                                                                                if(VLBench.MMPJ_TOPG_IsCompetitor__c)
                                                                                                    mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).get(VLBench.MMPJ_TOPG_AlcoholType__c).put(VLBench.MMPJ_TOPG_Competitor_Brand_Name__c ,VLBench.MMPJ_TOPG_Price__c);
                                                                                                else
                                                                                                    mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).get(VLBench.MMPJ_TOPG_AlcoholType__c).put(VLBench.MMPJ_TOPG_Related_Brand__r.name,VLBench.MMPJ_TOPG_Price__c);
                                                                                            }
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            mapReturnValue.put(VLBench.MMPJ_TOPG_MarqueBenchmark__c , new map<string,map<string,decimal>>());
                                                                                            mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).put(VLBench.MMPJ_TOPG_AlcoholType__c, new map<string, decimal>());
                                                                                            if(VLBench.MMPJ_TOPG_IsCompetitor__c)
                                                                                                mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).get(VLBench.MMPJ_TOPG_AlcoholType__c).put(VLBench.MMPJ_TOPG_Competitor_Brand_Name__c ,VLBench.MMPJ_TOPG_Price__c);
                                                                                            else
                                                                                                mapReturnValue.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).get(VLBench.MMPJ_TOPG_AlcoholType__c).put(VLBench.MMPJ_TOPG_Related_Brand__r.name,VLBench.MMPJ_TOPG_Price__c);
                                                                                        }
                                                                                        if(mapBrenchmarkSetMark.containskey(VLBench.MMPJ_TOPG_MarqueBenchmark__c))
                                                                                        {
                                                                                            if(VLBench.MMPJ_TOPG_IsCompetitor__c)
                                                                                                mapBrenchmarkSetMark.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).add(VLBench.MMPJ_TOPG_Competitor_Brand_Name__c);
                                                                                            else
                                                                                                mapBrenchmarkSetMark.get(VLBench.MMPJ_TOPG_MarqueBenchmark__c).add(VLBench.MMPJ_TOPG_Related_Brand__r.name);
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            if(VLBench.MMPJ_TOPG_IsCompetitor__c)
                                                                                                mapBrenchmarkSetMark.put(VLBench.MMPJ_TOPG_MarqueBenchmark__c,new set<string>{VLBench.MMPJ_TOPG_Competitor_Brand_Name__c});
                                                                                            else
                                                                                                mapBrenchmarkSetMark.put(VLBench.MMPJ_TOPG_MarqueBenchmark__c,new set<string>{VLBench.MMPJ_TOPG_Related_Brand__r.name});
                                                                                        }
                                                                                    }
                                                                                    system.debug('mapMarqueTypeAlcoholPrix ' + mapReturnValue);
                                                                                    return mapReturnValue ;
                                                                                   }
                                                                                set;}
    
}