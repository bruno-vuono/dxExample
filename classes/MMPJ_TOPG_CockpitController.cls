public with sharing class MMPJ_TOPG_CockpitController
{
   
    public String defaultSelectedBrand{get; set;} //toufic
    public String defaultSelectedMarket{get; set;}//toufic
    public date InteractionSelectedDate { get; set; }//toufic
    public MMPJ_TOPG_RAID__c filterRAID{get;set;}//toufic

    // Power BI integration
    public String prismaUrl{get; set;} //BTOU TGS-51 : variable no more used
    public String iwsrUrl{get; set;} //BTOU TGS-51 : variable no more used
    public String MMPJ_apptokenPerf {get;set;}
    public String MMPJ_apptokenIwsr {get;set;}
    public String MMPJ_perfReportID {get;set;}
    public String MMPJ_iwsrReportID {get;set;}

    //Global visualforce vars
    public Boolean showResSections {get; set;}
    /*public Boolean showVLSection {get; set;}
    public Boolean showPLSection {get; set;}
    public Boolean showEffectSection {get; set;}
    public Boolean showIWSRSection {get; set;}
    public Decimal yearVFP {get; set;}
    public String monthVFP {get; set;}
    public String currentYearTotal {get; set;}*/

    // Brand & Market filters
    String selectedBrand;
    String selectedMarket;
    public String selectedMarketVFP {get; set;}
    public String selectedBrandVFP {get; set;}    
     
    /** 
     * Validates the callback code and generates the access and refresh tokens 
     * 
     * @return null to refresh the page 
    */ 
    //public PageReference redirectOnCallback() { 
    //    return super.redirectOnCallback(null); 
    //} 
          
    //public PageReference refreshAccessToken() { 
    //    return super.refreshAccessToken(ApexPages.currentPage()); 
    //} 
    /*************** TGS-51 Integration Power BI ******************/
    /**************************************************************/

    public String accesskey = 'eR0VwYBe981n6dWpZluV8CBwQNAjEL09g9V53GIbsY0fAhwJrosNbDIx1TwjVxGeX3sRGdornE8l8TTU4G4EFg==';

    // input values
    public String dateNbf = '';  
    public String dateExp = '';  
    public String token1 = '';
    public String tokenPerfReport; 
    public String tokenIwsrReport;
    public String inputval;

    // encoded signature value
    public String pbiHash;
    public String sig;

    // helper functions
    public String replaceChar(String arg){
        String res = arg;
        res = res.replace('/', '_');
        res = res.replace('+', '-');
        //if (res.endsWith('=') == true) {
        //    System.debug('==> rfc4648_base64_encode(), res.endsWith = is true');
        //}
        // Supprime les caractères '=' de fin de chaîne
        while (res.endsWith('=') == true) {
            res = res.removeEnd('=');
        }
        System.debug('==> replaceChar(), return res=' + res);
        return res;
    }

    public String rfc4648_base64_encode(String arg) {
        System.debug('==> rfc4648_base64_encode(), arg=' + arg);
        String res = arg;

        res = EncodingUtil.base64Encode(Blob.valueOf(res));
        System.debug('==> rfc4648_base64_encode(), après EncodingUtil.base64Encode() res=' + res);
        
        return replaceChar(res);
    } 

  

    public MMPJ_TOPG_CockpitController()
    {
        /*************** TGS-51 Integration Power BI ******************/
        MMPJ_TOPG_Param__c param = [select id, MMPJ_TOPG_IWSR_ReportID__c, MMPJ_TOPG_Prisma_ReportID__c from MMPJ_TOPG_Param__c where Name like 'PowerBI' limit 1];
        if (param != null) {
            MMPJ_perfReportID = param.MMPJ_TOPG_Prisma_ReportID__c;
            MMPJ_iwsrReportID = param.MMPJ_TOPG_IWSR_ReportID__c;
        }        

        token1 = '{"typ":"JWT","alg":"HS256"}';

        Datetime GMTDate = Datetime.now();
        System.debug('==> MMPJ_TOPG_CockpitController(), GMTDate=' + GMTDate);
        Long longGMTTime = GMTDate.getTime()/1000L;
        Long longGMTTimePlus1 = longGMTTime + 3600L;
        
        dateNbf = String.valueOf(longGMTTime);
        dateExp = String.valueOf(longGMTTimePlus1);
        System.debug('==> MMPJ_TOPG_CockpitController(), dateNbf=' + dateNbf);
        System.debug('==> MMPJ_TOPG_CockpitController(), dateExp=' + dateExp);
        System.debug('==> MMPJ_TOPG_CockpitController(), token1=' + token1);

        tokenPerfReport = '{' +
              '"wid":"3bc56811-085a-47f0-8a88-2b8fe1c7d18a",' + // workspace id
              '"rid":"' + MMPJ_perfReportID + '",' +            // report id
              '"wcn":"pbeprhbisharedprod",' +                   // workspace collection name
              '"iss":"PowerBISDK",' +
              '"ver":"0.2.0",' +
              '"aud":"https://analysis.windows.net/powerbi/api",' +
              '"nbf":' + dateNbf + ',' +
              '"exp":' + dateExp +
              '}';

        System.debug('==> MMPJ_TOPG_CockpitController(), tokenPerfReport=' + tokenPerfReport);
        inputval = rfc4648_base64_encode(token1) + '.' + rfc4648_base64_encode(tokenPerfReport);
        System.debug('==> MMPJ_TOPG_CockpitController(), inputval=' + inputval);

        String algorithmName = 'HmacSHA256';
        //Blob hmacDataPerf = Crypto.generateMac(algorithmName, Blob.valueOf(inputval), EncodingUtil.base64Decode(accesskey));
        Blob hmacDataPerf = Crypto.generateMac(algorithmName, Blob.valueOf(inputval), Blob.valueOf(accesskey));
        pbiHash = EncodingUtil.base64encode(hmacDataPerf); 
        sig = replaceChar(pbiHash);
        MMPJ_apptokenPerf = inputval + '.' + sig;
        System.debug('==> MMPJ_TOPG_CockpitController(), MMPJ_apptokenPerf=' + MMPJ_apptokenPerf);

        tokenIwsrReport = '{' +
              '"wid":"3bc56811-085a-47f0-8a88-2b8fe1c7d18a",' + // workspace id
              '"rid":"' + MMPJ_iwsrReportID + '",' +            // report id
              '"wcn":"pbeprhbisharedprod",' +                   // workspace collection name
              '"iss":"PowerBISDK",' +
              '"ver":"0.2.0",' +
              '"aud":"https://analysis.windows.net/powerbi/api",' +
              '"nbf":' + dateNbf + ',' +
              '"exp":' + dateExp +
              '}';

        System.debug('==> MMPJ_TOPG_CockpitController(), tokenIwsrReport=' + tokenIwsrReport);
        inputval = rfc4648_base64_encode(token1) + '.' + rfc4648_base64_encode(tokenIwsrReport);
        System.debug('==> MMPJ_TOPG_CockpitController(), inputval=' + inputval);

        //Blob hmacData = Crypto.generateMac(algorithmName, Blob.valueOf(inputval), EncodingUtil.base64Decode(accesskey));
        Blob hmacDataIwsr = Crypto.generateMac(algorithmName, Blob.valueOf(inputval), Blob.valueOf(accesskey));
        pbiHash = EncodingUtil.base64encode(hmacDataIwsr); 
        sig = replaceChar(pbiHash);
        MMPJ_apptokenIwsr = inputval + '.' + sig;
        System.debug('==> MMPJ_TOPG_CockpitController(), MMPJ_apptokenIwsr=' + MMPJ_apptokenIwsr);

        /*************** TGS-51 Integration Power BI ******************/

        filterRAID = new MMPJ_TOPG_RAID__c();//toufic
        showResSections = false;  
    }
    
    public List<SelectOption> allBrands
    {
        get
        {
            Map<ID, String> m1 = new Map<ID, String>();
            if(allBrands == null)
            {
                //==========BTO : search values from table MMPJ_TOPG_BRAND__c And put "All Brands and All Markets" first in the list=============//
               /* allBrands = new List<SelectOption>();
                allBrands.add(new SelectOption('Martell', 'Martell'));
                allBrands.add(new SelectOption('Mumm', 'Mumm'));
                allBrands.add(new SelectOption('PJ', 'Perrier-Jouet'));
                allBrands.add(new SelectOption('AUGIER', 'Augier'));
                allBrands.add(new SelectOption('MONTESQUIOU', 'Montesquiou'));*/ 
                allBrands = new List<SelectOption>();
                //BTO: Begin ====Put "All Brands" first===//
                MMPJ_TOPG_BRAND__c br = [select id ,name from MMPJ_TOPG_BRAND__c where Name like 'All%Brands' limit 1];
                allBrands.add(new SelectOption(br.Id, br.Name));
                for(MMPJ_TOPG_BRAND__c B : [select id ,name from MMPJ_TOPG_BRAND__c where not Name like 'All%Brands' Order by Name])
                allBrands.add(new SelectOption(B.Id, B.Name));
                //===End 
                              
            }           
            return allBrands;
        }
        set;
    }
    public List<SelectOption> selectedBrands
    {
        get
        {
            if(selectedBrands == null)
            {
                selectedBrands = new List<SelectOption>();
            }
            //=========Added by toufic====================
            else
            {
                defaultSelectedBrand='';
                    for (selectOption sel :selectedBrands)
                defaultSelectedBrand+=sel.getValue()+';';
            }
            //===========================================
            return selectedBrands;
        }
        set;
    }
    public List<SelectOption> allMarkets
    {
        get
        {
            if(allMarkets == null)
            {
                allMarkets = new List<SelectOption>();
                for(AggregateResult market : [select MMPJ_TOPG_Market__c from MMPJ_TOPG_PRISMADataPL__c group by MMPJ_TOPG_Market__c])
                    allMarkets.add(new SelectOption(String.valueOf(market.get('MMPJ_TOPG_Market__c')), String.valueOf(market.get('MMPJ_TOPG_Market__c')).replaceAll('_', ' ')));
            }
        return allMarkets;
        }
        set;
    }
    public List<SelectOption> selectedMarkets
    {
        get
        {
            if(selectedMarkets == null)
            {
                    selectedMarkets = new List<SelectOption>();
            }
             //=========Added by toufic=============================
            else
            {
                defaultSelectedMarket='';
                for (selectOption sel :selectedMarkets)
                    defaultSelectedMarket+=sel.getValue()+';';
            }
            //=====================================================
            return selectedMarkets;
        }
        set;
    }

    // Class to store Prisma Data to use in all the calculation for Volumes, P&L and Effects --> please refere to csv files and the objects in Salesforce
    
   /************ Begin BTO : now we use Power BI ******************
     public class PrismaData
    {
        public String label{get;set;}
        public Decimal col1{get;set;}
        public Decimal col2{get;set;}
        public Decimal col3{get;set;}
        public Decimal col4{get;set;}
        public Decimal col5{get;set;}
        public Decimal col6{get;set;}
        public Decimal col7{get;set;}
        public Decimal col8{get;set;}
        public Decimal col9{get;set;}
        public Decimal col10{get;set;}
        public Decimal col11{get;set;}
        public Decimal col12{get;set;}
        public Decimal col13{get;set;}
        public Decimal col14{get;set;}
        public Decimal col15{get;set;}
        public Decimal col16{get;set;}
        public Decimal col17{get;set;}
        public Decimal col18{get;set;}
        // for unkowen reasons in visualforce the current user local doesn't apply for decimals so the solution is to format it using Decimal.format() method
        public String sCol1{get;set;}
        public String sCol2{get;set;}
        public String sCol3{get;set;}
        public String sCol4{get;set;}
        public String sCol5{get;set;}
        public String sCol6{get;set;}
        public String sCol7{get;set;}
        public String sCol8{get;set;}
        public String sCol9{get;set;}
        public String sCol10{get;set;}
        public String sCol11{get;set;}
        public String sCol12{get;set;}
        public String sCol13{get;set;}
        public String sCol14{get;set;}
        public String sCol15{get;set;}
        public String sCol16{get;set;}
        public String sCol17{get;set;}
        public String sCol18{get;set;}

        public PrismaData(){}
        public PrismaData(String label, Decimal col1, Decimal col2, Decimal col4, Decimal col5, Decimal col7, Decimal col8, Decimal col9, Decimal col11, Decimal col12, Decimal col13)
        {
            this.label = label;
            this.col1 = col1;
            this.col2 = col2;
            this.col4 = col4;
            this.col5 = col5;
            this.col7 = col7;
            this.col8 = col8;
            this.col9 = col9;
            this.col11 = col11;
            this.col12 = col12;
            this.col13 = col13;
        }
    }
    // Volumes table vars & data structur
    public List<PrismaData> myVols
    {
        get
        {
            if(myVols == null)
            {
                myVols = new List<PrismaData>();
                myVols.add(new PrismaData('TOTAL', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
            }
            return myVols;
        }
        set;
    }
    public List<PrismaData> myVolsPL
    {
        get
        {
            if(myVolsPL == null)
            {
                myVolsPL = new List<PrismaData>();
            }
            return myVolsPL;
        }
        set;
    }
    public List<PrismaData> queryPrismaVols()
    {
        myVols = null;
        Map<String, PrismaData> myVolsMap = new Map<String, PrismaData>();
        for(AggregateResult prismaVol : [SELECT MMPJ_TOPG_Brand__c, MMPJ_TOPG_Type__c, MMPJ_TOPG_Month__c, MMPJ_TOPG_Year__c, SUM(MMPJ_TOPG_MonthValue__c) MValue, SUM(MMPJ_TOPG_PerMonthValue__c) PerMValue
                                        FROM MMPJ_TOPG_PRISMADataVol__c
                                        WHERE MMPJ_TOPG_Brand__c LIKE :'%'+selectedBrand+'%' AND MMPJ_TOPG_Market__c =:selectedMarket
                                        GROUP By MMPJ_TOPG_Type__c, MMPJ_TOPG_Brand__c,MMPJ_TOPG_Year__c, MMPJ_TOPG_Month__c
                                        ORDER BY MMPJ_TOPG_Type__c, MMPJ_TOPG_Brand__c ASC])
        {
            String subBrand = String.valueOf(prismaVol.get('MMPJ_TOPG_Brand__c'));
            String type = String.valueOf(prismaVol.get('MMPJ_TOPG_Type__c'));
            Decimal year = System.today().year();//2016;
            PrismaData vol = new PrismaData();
            vol.label = subBrand.replace('_', ' ');
            String key = subBrand;

            if(type == 'V_REPORTING')
            {
                yearVFP = year;
                monthVFP = String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c'));
                if(Decimal.valueOf(String.valueOf(prismaVol.get('MMPJ_TOPG_Year__c'))) == year-1)
                {
                    vol.col1 = prismaVol.get('PerMValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('PerMValue'))) : null;
                    vol.col4 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                }
                if(Decimal.valueOf(String.valueOf(prismaVol.get('MMPJ_TOPG_Year__c'))) == year)
                {
                    vol.col2 = prismaVol.get('PerMValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('PerMValue'))) : null;
                    vol.col5 = prismaVol.get('MValue') != null ?  Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                }

                if(myVolsMap.containsKey(key))
                {
                    if(Decimal.valueOf(String.valueOf(prismaVol.get('MMPJ_TOPG_Year__c'))) == year-1) //2015
                    {
                        myVolsMap.get(key).col1 = vol.col1;
                        myVolsMap.get(key).col4 = vol.col4;
                    }
                    else
                    {
                        myVolsMap.get(key).col2 = vol.col2;
                        myVolsMap.get(key).col5 = vol.col5;
                    }
                }
                else
                    myVolsMap.put(key, vol);
            }
            if(type == 'V_FINA_BUD')
            {
                if(String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c')) != 'JUN')
                    vol.col7 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                else
                    vol.col9 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                if(myVolsMap.containsKey(key))
                {
                    if(String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c')) != 'JUN')
                        myVolsMap.get(key).col7 = vol.col7;
                    else
                        myVolsMap.get(key).col9 = vol.col9;
                }
                else
                    myVolsMap.put(key, vol);
            }
            if(type == 'V_ACTUAL')
            {
                vol.col8 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                if(myVolsMap.containsKey(key))
                    myVolsMap.get(key).col8 = vol.col8;
                else
                    myVolsMap.put(key, vol);
            }
            if(type == 'V_ESTIMATE')
            {
                if(String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c')) == 'OCT')
                        vol.col11 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                else if(String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c')) == 'FEB')
                        vol.col12 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                else
                        vol.col13 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;

                if(myVolsMap.containsKey(key))
                {
                    if(String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c')) == 'OCT')
                        myVolsMap.get(key).col11 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                    else if(String.valueOf(prismaVol.get('MMPJ_TOPG_Month__c')) == 'FEB')
                        myVolsMap.get(key).col12 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                    else
                        myVolsMap.get(key).col13 = prismaVol.get('MValue') != null ? Decimal.valueOf(String.valueOf(prismaVol.get('MValue'))) : null;
                }
                else
                    myVolsMap.put(key, vol);
            }
        }
        if(myVolsMap.size()>0)
        {
            myVols.addAll(myVolsMap.values());
            updateTotal(myVols);
            showVLSection = true;
        }
        return myVols;
    }
    // do all the calculation and updating other info
    public void updateTotal(List<PrismaData> myVols)
    {
        for(integer i=1; i< myVols.size(); i++)
        {
            myVols[0].col1 += myVols[i].col1 == null ? 0 : myVols[i].col1;
            myVols[0].col2 += myVols[i].col2 == null ? 0 : myVols[i].col2;
            myVols[0].col4 += myVols[i].col4 == null ? 0 : myVols[i].col4;
            myVols[0].col5 += myVols[i].col5 == null ? 0 : myVols[i].col5;
            myVols[0].col7 += myVols[i].col7 == null ? 0 : myVols[i].col7;
            myVols[0].col8 += myVols[i].col8 == null ? 0 : myVols[i].col8;
            myVols[0].col9 += myVols[i].col9 == null ? 0 : myVols[i].col9;
            myVols[0].col11 += myVols[i].col11 == null ? 0 : myVols[i].col11;
            myVols[0].col12 += myVols[i].col12 == null ? 0 : myVols[i].col12;
            myVols[0].col13 += myVols[i].col13 == null ? 0 : myVols[i].col13;

        }
        for(PrismaData v : myVols)
        {
            v.col3 = calVar(v.col1, v.col2);
            v.col6 = calVar(v.col4, v.col5);
            v.col10 = calVar(v.col8, v.col9);
        }
        for(PrismaData v : myVols)
        {
            v.sCol1 = v.col1 == null ? null : v.col1.setScale(1).format();
            v.sCol2 = v.col2 == null ? null : v.col2.setScale(1).format();

            v.sCol3 = v.col3 == null ? null : v.col3.setScale(1).format();

            v.sCol4 = v.col4 == null ? null : v.col4.setScale(1).format();
            v.sCol5 = v.col5 == null ? null : v.col5.setScale(1).format();

            v.sCol6 = v.col6 == null ? null : v.col6.setScale(1).format();

            v.sCol7 = v.col7 == null ? null : v.col7.setScale(1).format();
            v.sCol8 = v.col8 == null ? null : v.col8.setScale(1).format();
            v.sCol9 = v.col9 == null ? null : v.col9.setScale(1).format();

            v.sCol10 = v.col10 == null ? null : v.col10.setScale(1).format();

            v.sCol11 = v.col11 == null ? null : v.col11.setScale(1).format();
            v.sCol12 = v.col12 == null ? null : v.col12.setScale(1).format();
            v.sCol13 = v.col13 == null ? null : v.col13.setScale(1).format();
        }
        currentYearTotal = myVols[0].col5.setScale(1).format();
    }

    // P&L table vars & data structur
    public Map<String, MMPJ_TOPG_PL_Correspondence__c> plCodeLabel = new Map<String,MMPJ_TOPG_PL_Correspondence__c>();
    public List<PrismaData> queryPrismaPLs()
    {
        myVolsPL = null;
        Map<String, PrismaData> myVolPLsMap = new Map<String, PrismaData>();
        for(AggregateResult pl : [SELECT MMPJ_TOPG_Indicator__c, SUM(MMPJ_TOPG_MonthValue__c) MValue, SUM(MMPJ_TOPG_PerMonthValue__c) PerMValue, MMPJ_TOPG_Month__c, MMPJ_TOPG_Type__c, MMPJ_TOPG_Year__c
                                  FROM MMPJ_TOPG_PRISMADataPL__c
                                  WHERE MMPJ_TOPG_Market__c  =:selectedMarket AND MMPJ_TOPG_Brand__c =:selectedBrand
                                  GROUP By MMPJ_TOPG_Type__c,MMPJ_TOPG_Indicator__c, MMPJ_TOPG_Brand__c,MMPJ_TOPG_Year__c, MMPJ_TOPG_Month__c
                                  ORDER BY MMPJ_TOPG_Type__c, MMPJ_TOPG_Brand__c ASC])
        {
            String indicator = String.valueOf(pl.get('MMPJ_TOPG_Indicator__c'));
            String type = String.valueOf(pl.get('MMPJ_TOPG_Type__c'));
            Decimal year = System.today().year();
            PrismaData vol = new PrismaData();
            vol.label = indicator;
            String key = indicator;

            if(type == 'F_ACTUAL')
            {
                if(String.valueOf(pl.get('MMPJ_TOPG_Month__c')) == 'JUN')
                {
                    vol.col7 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;
                }
                else
                {
                    vol.col1 = pl.get('PerMValue') != null ? Decimal.valueOf(String.valueOf(pl.get('PerMValue'))) : null;
                    vol.col4 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;
                }
                if(myVolPLsMap.containsKey(key))
                {
                    if(String.valueOf(pl.get('MMPJ_TOPG_Month__c')) == 'JUN')
                    {
                        myVolPLsMap.get(key).col7 = vol.col7;
                    }
                    else
                    {
                        myVolPLsMap.get(key).col1 = vol.col1;
                        myVolPLsMap.get(key).col4 = vol.col4;
                    }
                }
                else
                    myVolPLsMap.put(key, vol);
            }
            if(type == 'F_REPORTING')
            {
                vol.col2 = pl.get('PerMValue') != null ? Decimal.valueOf(String.valueOf(pl.get('PerMValue'))) : null;
                vol.col5 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;

                if(myVolPLsMap.containsKey(key))
                {
                    myVolPLsMap.get(key).col2 = vol.col2;
                    myVolPLsMap.get(key).col5 = vol.col5;
                }
                else
                    myVolPLsMap.put(key, vol);
            }
            if(type == 'F_REPORTING_RRP_X')
            {
                vol.col3 = pl.get('PerMValue') != null ? Decimal.valueOf(String.valueOf(pl.get('PerMValue'))) : null;
                vol.col6 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;

                if(myVolPLsMap.containsKey(key))
                {
                    myVolPLsMap.get(key).col3 = vol.col3;
                    myVolPLsMap.get(key).col6 = vol.col6;
                }
                else
                    myVolPLsMap.put(key, vol);
            }
            if(type == 'F_ESTIMATE')
            {
                vol.col8 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;
                if(myVolPLsMap.containsKey(key))
                    myVolPLsMap.get(key).col8 = vol.col8;
                else
                    myVolPLsMap.put(key, vol);
            }
            if(type == 'F_FINA_BUD')
            {
                vol.col9 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;
                if(myVolPLsMap.containsKey(key))
                    myVolPLsMap.get(key).col9 = vol.col9;
                else
                    myVolPLsMap.put(key, vol);
            }
            if(type == 'F_FINA_BUD_RRP_X')
            {
                vol.col10 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;
                if(myVolPLsMap.containsKey(key))
                    myVolPLsMap.get(key).col10 = vol.col10;
                else
                    myVolPLsMap.put(key, vol);
            }
            if(type == 'F_ESTIMATE_RAP_X')
            {
                vol.col11 = pl.get('MValue') != null ? Decimal.valueOf(String.valueOf(pl.get('MValue'))) : null;
                if(myVolPLsMap.containsKey(key))
                    myVolPLsMap.get(key).col11 = vol.col11;
                else
                    myVolPLsMap.put(key, vol);
            }
        }
        if(myVolPLsMap.size()>0)
        {
            for(MMPJ_TOPG_PL_Correspondence__c pl : [SELECT MMPJ_TOPG_Order__c ,  MMPJ_TOPG_Label__c , name from MMPJ_TOPG_PL_Correspondence__c order by MMPJ_TOPG_Order__c ASC])
            {
                if(myVolPLsMap.get(pl.Name) != null)
                {
                    myVolsPL.add(myVolPLsMap.get(pl.Name));
                    plCodeLabel.put(pl.Name, pl);
                }
            }
            updatePLVals(myVolsPL);
            showPLSection = true;
        }
        return myVolsPL;
    }
    public void updatePLVals(List<PrismaData> myVolsPL)
    {
        for(PrismaData pl : myVolsPL)
        {
            pl.label = plCodeLabel.get(pl.label).MMPJ_TOPG_Label__c;
            pl.col12 = pl.col3 == null || pl.col1 == null || pl.col3 == 0 || pl.col1 == 0 ? null : (((pl.col3/pl.col1) -1)*100).setScale(2);
            pl.col13 = pl.col6 == null || pl.col4 == null || pl.col6 == 0 || pl.col4 == 0 ? null : (((pl.col6/pl.col4) -1)*100).setScale(2);
            pl.col14 = pl.col4 == null || pl.col7 == null || pl.col4 == 0 || pl.col7 == 0 ? null : ((1 - (pl.col4/pl.col7))*100).setScale(2);
            pl.col15 = pl.col6 == null || pl.col11 == null || pl.col6 == 0 || pl.col11 == 0 ? null : ((1 - (pl.col6/pl.col11))*100);//.setScale(2);
            pl.col16 = pl.col11 == null || pl.col10 == null || pl.col11 == 0 || pl.col10 == 0 ? null : (((pl.col11/pl.col10) -1)*100).setScale(2);
            pl.col17 = pl.col10 == null || pl.col7 == null || pl.col10 == 0 || pl.col7 == 0 ? null : (((pl.col10/pl.col7) -1)*100).setScale(2);
        }
        for(PrismaData pl : myVolsPL)
        {
            pl.sCol1 = pl.col1 == null ? null : pl.col1.setScale(1).format();
            pl.sCol2 = pl.col2 == null ? null : pl.col2.setScale(1).format();
            pl.sCol3 = pl.col3 == null ? null : pl.col3.setScale(1).format();
            pl.sCol4 = pl.col4 == null ? null : pl.col4.setScale(1).format();
            pl.sCol5 = pl.col5 == null ? null : pl.col5.setScale(1).format();
            pl.sCol6 = pl.col6 == null ? null : pl.col6.setScale(1).format();
            pl.sCol7 = pl.col7 == null ? null : pl.col7.setScale(1).format();
            pl.sCol8 = pl.col8 == null ? null : pl.col8.setScale(1).format();
            pl.sCol9 = pl.col9 == null ? null : pl.col9.setScale(1).format();
            pl.sCol10 = pl.col10 == null ? null : pl.col10.setScale(1).format();
            pl.sCol11 = pl.col11 == null ? null : pl.col11.setScale(1).format();
            pl.sCol12 = pl.col12 == null ? null : pl.col12.setScale(1).format();
            pl.sCol13 = pl.col13 == null ? null : pl.col13.setScale(1).format();
            pl.sCol14 = pl.col14 == null ? null : pl.col14.setScale(1).format();
            pl.sCol15 = pl.col15 == null ? null : pl.col15.setScale(1).format();
            pl.sCol16 = pl.col16 == null ? null : pl.col16.setScale(1).format();
            pl.sCol17 = pl.col17 == null ? null : pl.col17.setScale(1).format();
        }
    }

    // Effect Chart data structur and vars
    public String effectChartData { get; set; }
    public class DataEffect
    {
        public String name;
        public Decimal y;
        public String color;
        public Boolean isIntermediateSum;

        public DataEffect() {}
        public DataEffect(String name, Decimal y)
        {
            this.name = name;
            this.y = y;
        }
        public DataEffect(String name, Decimal y, String color)
        {
            this.name = name;
            this.y = y;
            this.color = color;
        }
        public DataEffect(String name, Boolean isIntermediateSum, String color)
        {
            this.name = name;
            this.isIntermediateSum = isIntermediateSum;
            this.color = color;
        }
    }
    public String queryPrismaEffects()
    {
        String effectsChartData = '';
        String exceptionBrand =  '';
        if(selectedBrand == 'AUGIER' || selectedBrand == 'MONTESQUIOU')
            exceptionBrand = 'xx'+selectedBrand;
        else
            exceptionBrand = selectedBrand;
        Map<String, PrismaData> myEffectMap = new Map<String, PrismaData>(); //Brand Name, Vols (table line)
        for(MMPJ_TOPG_PRISMADataEffect__c ef : [SELECT MMPJ_TOPG_Indicator__c, MMPJ_TOPG_Brand__c, MMPJ_TOPG_Value__c, MMPJ_TOPG_Type__c, MMPJ_TOPG_Year__c
                                  FROM MMPJ_TOPG_PRISMADataEffect__c
                                  WHERE MMPJ_TOPG_Brand__c != :exceptionBrand AND MMPJ_TOPG_Brand__c LIKE:'%'+selectedBrand+'%' AND  MMPJ_TOPG_Market__c=:selectedMarket
                                  ])
        {
            PrismaData effect = new PrismaData();
            effect.label = ef.MMPJ_TOPG_Brand__c;
            String key = ef.MMPJ_TOPG_Brand__c;
            Decimal year = System.today().year();//2016;

            if(ef.MMPJ_TOPG_Type__c == 'F_ACTUAL')
            {
                yearVFP = year;
                if(ef.MMPJ_TOPG_Indicator__c == 'VOLT')
                    effect.col1 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RT02')
                    effect.col2 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RT043')
                    effect.col3 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT04')
                    effect.col4 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'R061')
                    effect.col5 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT06')
                    effect.col6 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT78')
                    effect.col7 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT09')
                    effect.col8 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;

                if(myEffectMap.containsKey(key))
                {
                    if(ef.MMPJ_TOPG_Indicator__c == 'VOLT')
                        myEffectMap.get(key).col1 = myEffectMap.get(key).col1 == null ?  effect.col1 : myEffectMap.get(key).col1 + (effect.col1 == null ? 0 : effect.col1);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RT02')
                        myEffectMap.get(key).col2 = myEffectMap.get(key).col2 == null ?  effect.col2 : myEffectMap.get(key).col2 + (effect.col2 == null ? 0 : effect.col2);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RT043')
                        myEffectMap.get(key).col3 = myEffectMap.get(key).col3 == null ?  effect.col3 : myEffectMap.get(key).col3 + (effect.col3 == null ? 0 : effect.col3);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT04')
                        myEffectMap.get(key).col4 = myEffectMap.get(key).col4 == null ?  effect.col4 : myEffectMap.get(key).col4 + (effect.col4 == null ? 0 : effect.col4);
                    if(ef.MMPJ_TOPG_Indicator__c == 'R061')
                        myEffectMap.get(key).col5 = myEffectMap.get(key).col5 == null ?  effect.col5 : myEffectMap.get(key).col5 + (effect.col5 == null ? 0 : effect.col5);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT06')
                        myEffectMap.get(key).col6 = myEffectMap.get(key).col6 == null ?  effect.col6 : myEffectMap.get(key).col6 + (effect.col6 == null ? 0 : effect.col6);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT78')
                        myEffectMap.get(key).col7 = myEffectMap.get(key).col7 == null ?  effect.col7 : myEffectMap.get(key).col7 + (effect.col7 == null ? 0 : effect.col7);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT09')
                        myEffectMap.get(key).col8 = myEffectMap.get(key).col8 == null ?  effect.col8 : myEffectMap.get(key).col8 + (effect.col8 == null ? 0 : effect.col8);
                }
                else
                {
                    myEffectMap.put(key, effect);
                }
            }
            if(ef.MMPJ_TOPG_Type__c == 'F_REPORTING_RRP_X')
            {
                if(ef.MMPJ_TOPG_Indicator__c == 'VOLT')
                    effect.col9 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RT02')
                    effect.col10 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RT043')
                    effect.col11 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT04')
                    effect.col12 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'R061')
                    effect.col13 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT06')
                    effect.col14 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT78')
                    effect.col15 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT09')
                    effect.col16 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;

                if(myEffectMap.containsKey(key))
                {
                    if(ef.MMPJ_TOPG_Indicator__c == 'VOLT')
                        myEffectMap.get(key).col9 = myEffectMap.get(key).col9 == null ?  effect.col9 : myEffectMap.get(key).col9 + (effect.col9 == null ? 0 : effect.col9);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RT02')
                        myEffectMap.get(key).col10 = myEffectMap.get(key).col10 == null ?  effect.col10 : myEffectMap.get(key).col10 + (effect.col10 == null ? 0 : effect.col10);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RT043')
                        myEffectMap.get(key).col11 = myEffectMap.get(key).col11 == null ?  effect.col11 : myEffectMap.get(key).col11 + (effect.col11 == null ? 0 : effect.col11);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT04')
                        myEffectMap.get(key).col12 = myEffectMap.get(key).col12 == null ?  effect.col12 : myEffectMap.get(key).col12 + (effect.col12 == null ? 0 : effect.col12);
                    if(ef.MMPJ_TOPG_Indicator__c == 'R061')
                        myEffectMap.get(key).col13 = myEffectMap.get(key).col13 == null ?  effect.col13 : myEffectMap.get(key).col13 + (effect.col13 == null ? 0 : effect.col13);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT06')
                        myEffectMap.get(key).col14 = myEffectMap.get(key).col14 == null ?  effect.col14 : myEffectMap.get(key).col14 + (effect.col14 == null ? 0 : effect.col14);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT78')
                        myEffectMap.get(key).col15 = myEffectMap.get(key).col15 == null ?  effect.col15 : myEffectMap.get(key).col15 + (effect.col15 == null ? 0 : effect.col15);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT09')
                        myEffectMap.get(key).col16 = myEffectMap.get(key).col16 == null ?  effect.col16 : myEffectMap.get(key).col16 + (effect.col16 == null ? 0 : effect.col16);
                }
                else
                {
                    myEffectMap.put(key, effect);
                }
            }
            if(ef.MMPJ_TOPG_Type__c == 'F_REPORTING')
            {
                if(ef.MMPJ_TOPG_Indicator__c == 'RT043')
                    effect.col17 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;
                if(ef.MMPJ_TOPG_Indicator__c == 'RSTT09')
                    effect.col18 = ef.MMPJ_TOPG_Value__c != null ? ef.MMPJ_TOPG_Value__c : 0;

                if(myEffectMap.containsKey(key))
                {
                    if(ef.MMPJ_TOPG_Indicator__c == 'RT043')
                        myEffectMap.get(key).col17 = myEffectMap.get(key).col17 == null ?  effect.col17 : myEffectMap.get(key).col17 + (effect.col17 == null ? 0 : effect.col17);
                    if(ef.MMPJ_TOPG_Indicator__c == 'RSTT09')
                        myEffectMap.get(key).col18 = myEffectMap.get(key).col18 == null ?  effect.col18 : myEffectMap.get(key).col18 + (effect.col18 == null ? 0 : effect.col18);
                }
                else
                {
                    myEffectMap.put(key, effect);
                }
            }
        }
        Decimal v1stCol, v2ndCol, v3rdCol, v4thCol, v5thCol, v6thCol, v7thCol;
        v1stCol = v2ndCol = v3rdCol = v4thCol = v5thCol = v6thCol = v7thCol = 0;

        Decimal sumCol1, sumCol2, sumCol3, sumCol4, sumCol5, sumCol6, sumCol7, sumCol8, sumCol9, sumCol10, sumCol11, sumCol12, sumCol13, sumCol14, sumCol15, sumCol16, sumCol17, sumCol18;
        sumCol1 = sumCol2 = sumCol3 = sumCol4 = sumCol5 = sumCol6 = sumCol7 = sumCol8 = sumCol9 = sumCol10 = sumCol11 = sumCol12 = sumCol13 = sumCol14 = sumCol15 = sumCol16 = sumCol17 = sumCol18=0;
        for(PrismaData e: myEffectMap.values())
        {
            sumCol1 += e.col1 == null ? 0 : e.col1;
            sumCol2 += e.col2 == null ? 0 : e.col2;
            sumCol3 += e.col3 == null ? 0 : e.col3;
            sumCol4 += e.col4 == null ? 0 : e.col4;
            sumCol5 += e.col5 == null ? 0 : e.col5;
            sumCol6 += e.col6 == null ? 0 : e.col6;
            sumCol7 += e.col7 == null ? 0 : e.col7;
            sumCol8 += e.col8 == null ? 0 : e.col8;
            sumCol9 += e.col9 == null ? 0 : e.col9;
            sumCol10 += e.col10 == null ? 0 : e.col10;
            sumCol11 += e.col11 == null ? 0 : e.col11;
            sumCol12 += e.col12 == null ? 0 : e.col12;
            sumCol13 += e.col13 == null ? 0 : e.col13;
            sumCol14 += e.col14 == null ? 0 : e.col14;
            sumCol15 += e.col15 == null ? 0 : e.col15;
            sumCol16 += e.col16 == null ? 0 : e.col16;
            sumCol17 += e.col17 == null ? 0 : e.col17;
            sumCol18 += e.col18 == null ? 0 : e.col18;

            v4thCol += (e.col9 == 0 && e.col10>0) ? e.col10 : (e.col1 == 0 || e.col9 == 0? 0 : (((e.col10/e.col9)-(e.col2/e.col1))*e.col9));
            v5thCol += (e.col9 == 0 && ((e.col12+e.col13)-e.col11)!=0) ? ((e.col12+e.col13)-e.col11) : (e.col1 == 0 || e.col9 == 0) ? 0 : ((((e.col12+e.col13)-e.col11)/e.col9)-(((e.col4+e.col5)-e.col3)/e.col1))*e.col9;
            v6thCol += (e.col15 == null ? 0 : e.col15)-(e.col7 == null ? 0 : e.col7);
            v7thCol += ((e.col18-e.col17)-(e.col8-e.col3))-((e.col16-e.col11)-(e.col8-e.col3));
            showEffectSection = true;
        }

        if(showEffectSection)
        {
            v1stCol = sumCol8-sumCol3;
            if(sumCol1 == 0 && sumCol9 != 0)
                v2ndCol = sumCol14 - sumCol11;
            else
                v2ndCol = (sumCol9 - sumCol1)*(sumCol1 == 0 ? 0 : (sumCol6- sumCol3)/sumCol1);
            v3rdCol = (sumCol18-sumCol17) - v1stCol - v7thCol - v2ndCol - v4thCol - v5thCol - v6thCol;
            List<DataEffect> queryPrismaEffects = new List<DataEffect>();
            queryPrismaEffects.add(new DataEffect('CAAP S/T A'+String.valueOf(yearVFP-1).right(2), v1stCol, '#00c5ff'));
            queryPrismaEffects.add(new DataEffect('Volume effect', v2ndCol));
            queryPrismaEffects.add(new DataEffect('Quality mix', v3rdCol));
            queryPrismaEffects.add(new DataEffect('Net Sales', v4thCol));
            queryPrismaEffects.add(new DataEffect('COGS & Dutues', v5thCol));
            queryPrismaEffects.add(new DataEffect('A&P Sales', v6thCol));
            queryPrismaEffects.add(new DataEffect('FX effect', v7thCol));
            queryPrismaEffects.add(new DataEffect('CAAP S/T A'+String.valueOf(yearVFP).right(2), true, '#00c5ff'));

            effectsChartData = stripJsonNulls(JSON.serialize(queryPrismaEffects));
        }
        return effectsChartData;
    }

    // IWSR Charts
    public class IWSRData
    {
        public String name {get; set;}
        public List<Decimal> data {get; set;}
        public IWSRData(String name, List<Decimal> data)
        {
            this.name = name;
            this.data = data;
        }
    }
    public String top10BrandsData {get; set;}

    public String top5BrandsChartYTitle {get; set;}
    public String top5BrandsData {get; set;}
    public List<IWSRData> top5Brands
    {
        get
        {
            if(top5Brands == null)
                top5Brands = new List<IWSRData>();
            return top5Brands;
        }
        set;
    }
    public String priceBrandsChartYTitle {get; set;}
    public String priceBandData {get; set;}
    public List<IWSRData> priceBands
    {
        get
        {
            if(priceBands == null)
                priceBands = new List<IWSRData>();
            return priceBands;
        }
        set;
    }
    public void calcDataFromIWSR()
    {
        Decimal iwsrYear = Decimal.valueOf((String.valueOf(System.Today().year()).right(2))) -2;
        String brandFilter;
        if(selectedBrand == 'Martell' || selectedBrand == 'Augier' || selectedBrand == 'Montesquiou')

            brandFilter = 'Cognac';
        else
            brandFilter = 'International Champagne';

        top5BrandsChartYTitle = '' + brandFilter+' by brand '+ String.valueOf(iwsrYear -1)+ '-' +String.valueOf(iwsrYear);
        priceBrandsChartYTitle = '' + brandFilter+' evolution by price band '+ String.valueOf(iwsrYear -1)+ '-' +String.valueOf(iwsrYear);

        //TOP10 chart data
        String iwsrMarket = selectedMarketVFP.substring(0, selectedMarketVFP.length()-3);
        List<IWSRData> top10 = new List<IWSRData>();
        for(AggregateResult iwsrAR : [SELECT MMPJ_TOPG_Brand__c, SUM(MMPJ_TOPG_VolYear1__c) BG, SUM(MMPJ_TOPG_VolYear__c) BH
                                      FROM MMPJ_TOPG_IWSRData__c
                                      WHERE MMPJ_TOPG_market__c =:iwsrMarket AND MMPJ_TOPG_VolYear__c != null AND MMPJ_TOPG_Brand__c != 'Other' AND MMPJ_TOPG_PRCategory5__c != ''
                                      GROUP BY MMPJ_TOPG_Brand__c
                                      ORDER BY SUM(MMPJ_TOPG_VolYear__c) DESC LIMIT 15])
        {
            Decimal bh = String.valueOf(iwsrAR.get('BH')) == null ? 0 : Decimal.valueOf(String.valueOf(iwsrAR.get('BH'))).setScale(2);
            Decimal bg = String.valueOf(iwsrAR.get('BG')) == null ? 0 : Decimal.valueOf(String.valueOf(iwsrAR.get('BG'))).setScale(2);
            top10.add(new IWSRData(String.valueOf(iwsrAR.get('MMPJ_TOPG_Brand__c')), new List<Decimal> {bh-bg}));
            showIWSRSection = true;
        }

        //TOP5 chart data
        Decimal totalYear1, totalYear;
        totalYear1 = totalYear = 0;
        for(AggregateResult iwsrAR : [SELECT MMPJ_TOPG_Brand__c, SUM(MMPJ_TOPG_VolYear1__c) BG, SUM(MMPJ_TOPG_VolYear__c) BH
                                      FROM MMPJ_TOPG_IWSRData__c
                                      WHERE MMPJ_TOPG_market__c =:iwsrMarket  AND MMPJ_TOPG_PRCategory5__c !='' AND MMPJ_TOPG_PRCategory5__c =:brandFilter
                                      AND MMPJ_TOPG_VolYear__c != null AND MMPJ_TOPG_VolYear1__c != null AND MMPJ_TOPG_Brand__c != 'Other'
                                      GROUP BY MMPJ_TOPG_Brand__c
                                      ORDER BY SUM(MMPJ_TOPG_VolYear__c) DESC LIMIT 5])
        {
            Decimal bh = String.valueOf(iwsrAR.get('BH')) == null ? 0 : Decimal.valueOf(String.valueOf(iwsrAR.get('BH'))).setScale(2);
            Decimal bg = String.valueOf(iwsrAR.get('BG')) == null ? 0 : Decimal.valueOf(String.valueOf(iwsrAR.get('BG'))).setScale(2);
            top5Brands.add(new IWSRData(String.valueOf(iwsrAR.get('MMPJ_TOPG_Brand__c')), new List<Decimal> {bg,bh}));
            totalYear1 += bg;
            totalYear += bh;
            showIWSRSection = true;
        }
        // other --> to incomment if the client want to show it
        // for(AggregateResult iwsrAR : [SELECT SUM(MMPJ_TOPG_VolYear1__c) BG, SUM(MMPJ_TOPG_VolYear__c) BH FROM MMPJ_TOPG_IWSRData__c
        //                            WHERE MMPJ_TOPG_market__c =:iwsrMarket AND MMPJ_TOPG_PRCategory5__c =:brandFilter])
        // {
        //   top5Brands.add(new IWSRData('Others', new List<Decimal> {Decimal.valueOf(String.valueOf(iwsrAR.get('BG')))-totalYear1,Decimal.valueOf(String.valueOf(iwsrAR.get('BH')))-totalYear}));
        // }

        //Price Bands chart data
        for(AggregateResult iwsrAR : [SELECT MMPJ_TOPG_PriceBands__c, SUM(MMPJ_TOPG_VolYear1__c) BG, SUM(MMPJ_TOPG_VolYear__c) BH
                                      FROM MMPJ_TOPG_IWSRData__c
                                      WHERE MMPJ_TOPG_market__c =:iwsrMarket AND MMPJ_TOPG_PRCategory5__c =:brandFilter
                                      AND MMPJ_TOPG_VolYear__c != null AND MMPJ_TOPG_VolYear1__c != null
                                      AND (MMPJ_TOPG_PriceBands__c LIKE '6%' OR MMPJ_TOPG_PriceBands__c LIKE '5%' OR MMPJ_TOPG_PriceBands__c LIKE '4%')
                                      GROUP BY MMPJ_TOPG_PriceBands__c
                                      ORDER BY SUM(MMPJ_TOPG_VolYear__c) DESC LIMIT 5])
        {
            Decimal bh = String.valueOf(iwsrAR.get('BH')) == null ? 0 : Decimal.valueOf(String.valueOf(iwsrAR.get('BH'))).setScale(2);
            Decimal bg = String.valueOf(iwsrAR.get('BG')) == null ? 0 : Decimal.valueOf(String.valueOf(iwsrAR.get('BG'))).setScale(2);
            priceBands.add(new IWSRData(String.valueOf(iwsrAR.get('MMPJ_TOPG_PriceBands__c')), new List<Decimal> {bg, bh}));
            showIWSRSection = true;
        }
        top10BrandsData = JSON.serialize(top10);
        top5BrandsData = JSON.serialize(top5Brands);
        priceBandData =  JSON.serialize(priceBands);
    }

    //method called by the apply filter button on the visualforce page
    public String BISUrl {get; set;}
    public PageReference applyFilters()
    {
        showResSections = true;
        showVLSection=false;
        showPLSection=false;
        showEffectSection=false;
        showIWSRSection=false;
        priceBands = null;
        top5Brands = null;
        BISUrl = null;
        if( selectedMarkets.size()==0)
        {
            showResSections = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select a Market and a Brand before applying your filters'));
        }
        else if(selectedMarkets.size()==0)
        {
            showResSections = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select a Market and a Brand before applying your filters'));
        }
        else if(selectedMarkets.size()>1)
        {
            showResSections = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'For the current version only one value per filter is supported.'));
        }
        else
        {
            selectedMarket = selectedMarkets[0].getValue();
            selectedMarketVFP = selectedMarket.replaceAll('_', ' ');
           // selectedBrand = selectedBrands[0].getValue();
           // selectedBrandVFP = selectedBrand;
            
            //BTO => To confirm

          for(MMPJ_TOPG_BMC__c BMC : [SELECT Name,MMPJ_TOPG_BISLink__c FROM MMPJ_TOPG_BMC__c WHERE Name =:selectedMarketVFP AND MMPJ_TOPG_BISFolder__c !=''])
                BISUrl = BMC.MMPJ_TOPG_BISLink__c; 

            queryPrismaVols();
            queryPrismaPLs();
            effectChartData = queryPrismaEffects();
            calcDataFromIWSR();
        }
        return null;
    }

    // Method to calculate the variation
    public Decimal calVar(Decimal firstVal, Decimal secondVal)
    {
        Decimal var;
        if(firstVal == null || firstVal == 0)
            var= null;
        else if( secondVal == null || secondVal == 0)
            var = -100;
        else
            var = (((secondVal-firstVal)/firstVal)*100).setScale(2);
        return var;
    }
    // mehtod  to format JSON String for charts
    public static String stripJsonNulls(String jsonString)
    {
        if(jsonString != null)
        {
            jsonString = jsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            jsonString = jsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            jsonString = jsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            jsonString = jsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            jsonString = jsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            jsonString = jsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }
        return jsonString;
    }  BTO : now we use Power BI *******************/
}