public with sharing class MMPJ_TOPG_AP01_RAID{

    public static void updateProjMarketAndBrand(List <MMPJ_TOPG_Project__c> lstProjects){
        system.debug('in trigger ==========');
        List <Id> listProjectsIds = new List <Id>();
        for (MMPJ_TOPG_Project__c proj : lstProjects){
            listProjectsIds.add(proj.id); 
        }
        system.debug('listProjectsIds =='+listProjectsIds);
        //list of Project Brands 
        List<MMPJ_TOPG_Project_Brand__c> lstProjectsBrand = [select id
                                                            ,MMPJ_TOPG_Brand__c
                                                            ,MMPJ_TOPG_Project__c 
                                                            from MMPJ_TOPG_Project_Brand__c
                                                            where MMPJ_TOPG_Project__c  in:listProjectsIds];
        // get list ids of brands
        List<id> lstBrandIds = new list <id>();
        for  (MMPJ_TOPG_Project_Brand__c projBrand :lstProjectsBrand)
        {
            lstBrandIds.add(projBrand.MMPJ_TOPG_Brand__c) ;
        }

        //list of Project Markets 
        List<MMPJ_TOPG_Project_Market__c> lstProjectsMarket = [select id
                                                                ,MMPJ_TOPG_Market__c
                                                                ,MMPJ_TOPG_Project__c 
                                                                from MMPJ_TOPG_Project_Market__c
                                                                where MMPJ_TOPG_Project__c  in:listProjectsIds];
        //get list ids of Market
        List<id> lstMarketIds = new list<id>();                                                    
        for  (MMPJ_TOPG_Project_Market__c projMarket :lstProjectsMarket)
        {
            lstMarketIds.add(projMarket.MMPJ_TOPG_Market__c);
        }
        // list of names for the brands and markets                                                          
        List<MMPJ_TOPG_Brand__c> lstbrandsNames =[select  name from MMPJ_TOPG_Brand__c where id  in:lstBrandIds ];
        List<MMPJ_TOPG_Market__c> lstMarketsNames =[select name from MMPJ_TOPG_Market__c where id in:lstMarketIds ];

        //list of raids to be updated
        List <MMPJ_TOPG_RAID__c>lstRaidToUpdate = new List<MMPJ_TOPG_RAID__c>();
        for (MMPJ_TOPG_RAID__c raid : [select id ,MMPJ_TOPG_Project__c,MMPJ_TOPG_Brand__c,MMPJ_TOPG_Market__c from MMPJ_TOPG_RAID__c where MMPJ_TOPG_Project__c in:listProjectsIds]) {
            // if raids is linked to project
            //set it empty before re use it
            raid.MMPJ_TOPG_Brand__c='';
            if (raid.MMPJ_TOPG_Project__c!=null){
                for (MMPJ_TOPG_Brand__c brand :lstbrandsNames){
                    if (raid.MMPJ_TOPG_Brand__c!=null && !raid.MMPJ_TOPG_Brand__c.contains(brand.name)){
                        raid.MMPJ_TOPG_Brand__c=raid.MMPJ_TOPG_Brand__c+';'+brand.name;
                    }
                    else
                    {
                        raid.MMPJ_TOPG_Brand__c=brand.name+';';
                    } 
                }
                //set it empty before re use it 
                raid.MMPJ_TOPG_Market__c='';
                for (MMPJ_TOPG_Market__c market :lstMarketsNames){
                    if (raid.MMPJ_TOPG_Market__c!=null && !raid.MMPJ_TOPG_Market__c.contains(market.name)){
                        raid.MMPJ_TOPG_Market__c=raid.MMPJ_TOPG_Market__c+';'+market.name;
                    }
                    else {
                        raid.MMPJ_TOPG_Market__c=market.name+';';
                    }
                }  
            }
            lstRaidToUpdate.add(raid);
        }  
        // update list of raids 
        if (lstRaidToUpdate.size()>0)
            update lstRaidToUpdate;

        system.debug('out  trigger =========='); 
    }
    //BTO no objet market and brand on BMC
   /* public static void updateBMCMarketAndBrand(List <MMPJ_TOPG_BMC__c> lstBMCs){
        List <Id> lstBMCIds = new List <Id>();
        for (MMPJ_TOPG_BMC__c bmc:lstBMCs){
            lstBMCIds.add(bmc.id); 
        }
        //list of BMC's Market and Brands                                                     
        List <MMPJ_TOPG_BMC__c> lstBMCBrandAndMarkets = [select id,MMPJ_TOPG_Brand__r.name,MMPJ_TOPG_Market__r.name from MMPJ_TOPG_BMC__c where id in:lstBMCIds ];
        List <MMPJ_TOPG_RAID__c>lstRaidToUpdate = new List<MMPJ_TOPG_RAID__c>();
        for (MMPJ_TOPG_RAID__c raid : [select id ,MMPJ_TOPG_Project__c,MMPJ_TOPG_Brand__c,MMPJ_TOPG_Market__c,MMPJ_TOPG_Meeting__c from MMPJ_TOPG_RAID__c]) {
            // if raids is linked to meeting
            if (raid.MMPJ_TOPG_Meeting__c!=null){
                for (MMPJ_TOPG_BMC__c brandMarket :lstBMCBrandAndMarkets ){
                    if(raid.MMPJ_TOPG_Brand__c!=null && !raid.MMPJ_TOPG_Brand__c.contains(brandMarket.MMPJ_TOPG_Brand__r.name))
                    { 
                        raid.MMPJ_TOPG_Brand__c=raid.MMPJ_TOPG_Brand__c+';'+brandMarket.MMPJ_TOPG_Brand__r.name;
                    }
                    else{
                        raid.MMPJ_TOPG_Brand__c=brandMarket.MMPJ_TOPG_Brand__r.name+';';
                    }
                    if (raid.MMPJ_TOPG_Market__c!=null && !raid.MMPJ_TOPG_Market__c.contains(brandMarket.MMPJ_TOPG_Market__r.name)){
                        raid.MMPJ_TOPG_Market__c=raid.MMPJ_TOPG_Market__c+';'+brandMarket.MMPJ_TOPG_Market__r.name;
                    }
                    else{
                        raid.MMPJ_TOPG_Market__c=brandMarket.MMPJ_TOPG_Market__r.name+';';
                    }     
                    lstRaidToUpdate.add(raid); 
                }
            }
        }
        update lstRaidToUpdate;
    } */
    public static void updateRaidsMarketAndBrand(List <MMPJ_TOPG_RAID__c> lstRaids){
        List<Id> lstProjectsOfRaidIds = new List <Id>();
        List<Id> lstMeetingsRaidIds = new List <Id>();
        List<MMPJ_TOPG_Meeting__c> lstMeetings = new List <MMPJ_TOPG_Meeting__c>();
        for (MMPJ_TOPG_RAID__c raid:lstRaids){
            lstProjectsOfRaidIds.add(raid.MMPJ_TOPG_Project__c); 
            lstMeetingsRaidIds.add(raid.MMPJ_TOPG_Meeting__c); 
        }
        /*lstMeetings =[select id
        ,name
        ,MMPJ_TOPG_BMC__r.MMPJ_TOPG_Brand__r.name
        ,MMPJ_TOPG_BMC__r.MMPJ_TOPG_Market__r.name 
        from MMPJ_TOPG_Meeting__c where id in:lstMeetingsRaidIds ];*/
        //list of Project Brands 
        List<MMPJ_TOPG_Project_Brand__c> lstProjectsBrand = [select id
                                                            ,MMPJ_TOPG_Brand__c
                                                            ,MMPJ_TOPG_Project__c 
                                                            from MMPJ_TOPG_Project_Brand__c
                                                            where MMPJ_TOPG_Project__c  in:lstProjectsOfRaidIds];
        // get list ids of brands
        List<id> lstBrandIds = new list <id>();
        for  (MMPJ_TOPG_Project_Brand__c projBrand :lstProjectsBrand)
        {
            lstBrandIds.add(projBrand.MMPJ_TOPG_Brand__c) ;
        }

        //list of Project Markets 
        List<MMPJ_TOPG_Project_Market__c> lstProjectsMarket = [select id
                                                              ,MMPJ_TOPG_Market__c
                                                              ,MMPJ_TOPG_Project__c 
                                                               from MMPJ_TOPG_Project_Market__c
                                                               where MMPJ_TOPG_Project__c  in:lstProjectsOfRaidIds];
        //get list ids of Market
        List<id> lstMarketIds = new list<id>();                                                    
        for  (MMPJ_TOPG_Project_Market__c projMarket :lstProjectsMarket)
        {
            lstMarketIds.add(projMarket.MMPJ_TOPG_Market__c);
        }
        // list of names for the brands and markets                                                          
        List<MMPJ_TOPG_Brand__c> lstbrandsNames =[select  name from MMPJ_TOPG_Brand__c where id  in:lstBrandIds ];
        List<MMPJ_TOPG_Market__c> lstMarketsNames =[select name from MMPJ_TOPG_Market__c where id in:lstMarketIds ];
        for (MMPJ_TOPG_RAID__c raid:lstRaids){
            if (raid.MMPJ_TOPG_Project__c!=null){
                for (MMPJ_TOPG_Brand__c brand :lstbrandsNames){
                    if (raid.MMPJ_TOPG_Brand__c!=null && !raid.MMPJ_TOPG_Brand__c.contains(brand.name)){
                        raid.MMPJ_TOPG_Brand__c=raid.MMPJ_TOPG_Brand__c+';'+brand.name;
                    }
                    else
                    {
                        raid.MMPJ_TOPG_Brand__c=brand.name+';';
                    } 
                }
                for (MMPJ_TOPG_Market__c market :lstMarketsNames){
                    if (raid.MMPJ_TOPG_Market__c!=null && !raid.MMPJ_TOPG_Market__c.contains(market.name)){
                        raid.MMPJ_TOPG_Market__c=raid.MMPJ_TOPG_Market__c+';'+market.name;
                    }
                    else {
                        raid.MMPJ_TOPG_Market__c=market.name+';';
                    }
                }  
            }
            //BTO => begin : BMC Brand removing 
           /* else if (raid.MMPJ_TOPG_Meeting__c!=null){
                for (MMPJ_TOPG_Meeting__c meeting :lstMeetings)
                {
                    String brandName =meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Brand__r.name;
                    String marketName =meeting.MMPJ_TOPG_BMC__r.MMPJ_TOPG_Market__r.name;
                    if (raid.MMPJ_TOPG_Brand__c!=null && !raid.MMPJ_TOPG_Brand__c.contains(brandName))
                    {
                        raid.MMPJ_TOPG_Brand__c=raid.MMPJ_TOPG_Brand__c+';'+brandName;
                    }
                    else
                    {
                        raid.MMPJ_TOPG_Brand__c=brandName+';';
                    }
                   } 
            }*/
            //BTO => End : BMC Brand removing
        }
    }
}