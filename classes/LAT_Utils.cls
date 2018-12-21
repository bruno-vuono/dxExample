/**********************************************************************************************************************************

    Developer: Francisco Orzabal
    Created Date: 06/06/2014

    Description:

    Last Modified Date:
    Last Developer:

    Versión:
    V1.0 - 06/06/2014 - Initial version [FO]

/**********************************************************************************************************************************/

global class LAT_Utils {

    static final String beginTable = '<table cellspacing="2" width="100%"><font face="Lucida Console" size="10"><tr><td><b><center>' + System.Label.VF_VTS_00001_AR+ '</center></b></td><td><b><center>' + System.Label.VF_VTS_00002_AR+'</center></b></td> <td><b><center>' + System.Label.VF_VTS_00003_AR+ '</center></b></td></tr>';
    static final String beginTableWithDiscount = '<table cellspacing="2" width="100%"><font face="Lucida Console" size="10"><tr><td><b><center>' + System.Label.VF_VTS_00001_AR+ '</center></b></td><td><b><center>' + System.Label.VF_VTS_00004_AR+ '</center></b></td><td><b><center>' + System.Label.VF_VTS_00002_AR+'</center></b></td> <td><b><center>' + System.Label.VF_VTS_00003_AR+ '</center></b></td></tr>';
    static final String beginTableHeader = '<table cellspacing="2" width="100%"><font face="Lucida Console" size="10"><tr><td><b><center>' + System.Label.VF_VTS_00001_AR+ '</center></b></td> <td><b><center>' + System.Label.VF_VTS_00003_AR+ '</center></b></td></tr>';
    static final String endTable = '</font></table>';
    private static Map<string, string> mapFIeldsIds;
    public static Boolean migro;
    public static boolean testOn;
    webservice static string getFieldId (string objectApiName, string fieldApiName) {

        if (mapFIeldsIds == null) {

            mapFIeldsIds = new Map<string, string>();

            List<CS002_FIeldsIds__c> listFIeldsIds = [SELECT Id, FieldApiName__c, FieldId__c, ObjectApiName__c
                                                    FROM CS002_FIeldsIds__c];

            for (CS002_FIeldsIds__c fi : listFIeldsIds) {
                mapFIeldsIds.put(fi.ObjectApiName__c + fi.FieldApiName__c, fi.FieldId__c);
            }

        }

        if (mapFIeldsIds.containsKey(objectApiName + fieldApiName)) {

            return mapFIeldsIds.get(objectApiName + fieldApiName);

        } else {

            string fieldId = getFieldIdWS(objectApiName, fieldApiName);

            CS002_FIeldsIds__c fi = new CS002_FIeldsIds__c(Name = fieldApiName + '-' + objectApiName,
                                                            ObjectApiName__c = objectApiName,
                                                            FieldApiName__c = fieldApiName,
                                                            FieldId__c = fieldId);

            DataBase.insert(fi);

            return fieldId;

        }

        return null;

    }

    webservice static Id getRtId(String SobjectTypeDevName){
        return Global_RecordTypeCache.getRtId(SobjectTypeDevName);
    }
    webservice static boolean wasMigrationDone(string countryCode){
        return  Utils.wasMigrationDone(countryCode);
    
    }
    webservice static string getFieldId2 (string objectApiName, string fieldApiName) {

        if (mapFIeldsIds == null) {

            mapFIeldsIds = new Map<string, string>();

            List<CS002_FIeldsIds__c> listFIeldsIds = [SELECT Id, FieldApiName__c, FieldId__c, ObjectApiName__c
                                                    FROM CS002_FIeldsIds__c];

            for (CS002_FIeldsIds__c fi : listFIeldsIds) {
                mapFIeldsIds.put(fi.ObjectApiName__c + fi.FieldApiName__c, fi.FieldId__c);
            }

        }

        if (mapFIeldsIds.containsKey(objectApiName + fieldApiName)) {

            return mapFIeldsIds.get(objectApiName + fieldApiName);

        } else {

            string fieldId = getFieldIdWS(objectApiName, fieldApiName);

            CS002_FIeldsIds__c fi = new CS002_FIeldsIds__c(Name = fieldApiName + '-' + objectApiName,
                                                            ObjectApiName__c = objectApiName,
                                                            FieldApiName__c = fieldApiName,
                                                            FieldId__c = fieldId);

            DataBase.insert(fi);

            return fieldId;

        }

        return null;

    }

    //Get ids of fields
    private static String getFieldIdWS (String theObject, String theField) {

        String toolingendpoint = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v37.0/tooling/';
        string idOrNameOfObject;
        // Get Id of Custom Sobject

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(theObject);
        DescribeSobjectResult descr = targetType.getDescribe();

        // Si el objeto es custom, obtenemos su id.
        if(descr.isCustom()) {
            HttpRequest reqo = new HttpRequest();
            reqo.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            reqo.setHeader('Content-Type', 'application/json');

            String queryObject = 'query/?q=select+Id,DeveloperName,NamespacePrefix+from+CustomObject+where+DeveloperName+=+\''+theObject.removeEnd('__c')+'\'+LIMIT+10';
            reqo.setEndpoint(toolingendpoint + queryObject);
            reqo.setMethod('GET');

            Http ho = new Http();
            if(!Test.isRunningTest()) {
                HttpResponse reso = ho.send(reqo);
                idOrNameOfObject = reso.getBody().substringBetween('"Id":"','"');
            }
        // Si el objeto es estandar directamente utilizamos el nombre que nos pasaron por parametro.
        } else {

            idOrNameOfObject = theObject;

        }

        // Get field Id of Sobject
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');

        String queryField = 'query/?q=select+id,DeveloperName,FullName,Metadata,TableEnumOrId+from+CustomField+where+TableEnumOrId+=+\''+idOrNameOfObject+'\'+AND+DeveloperName+=+\''+theField.removeEnd('__c')+'\'+limit+10';
        system.debug('queryField: ' + queryField);
        req.setEndpoint(toolingendpoint + queryField);
        req.setMethod('GET');

        Http h = new Http();
        if(!Test.isRunningTest()) {
            HttpResponse res = h.send(req);
            system.debug('res: ' + res);
            string idOfField = res.getBody().substringBetween('"Id":"','"');
            return idOfField;
        } else {
            return idOrNameOfObject;
        }


    }

    public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
        List <List <String>> allFields = new List<List<String>>();

        System.debug('111111111111111' + contents);
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');

        System.debug('22222222222222222' + contents);
        contents = contents.replaceAll('""','DBLQT');

        System.debug('33333333333333333' + contents);
        List <String> lines = new List<String>();
        try {
            lines = contents.split('\n');

        System.debug('444444444444444444' + lines);
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
          System.debug('line' + line);
            // check for blank CSV lines (only commas)
            //if (line.replaceAll(',','').trim().length() == 0) continue;
            if (line.replaceAll(';','').trim().length() == 0) continue;

            system.debug('ˆˆˆˆˆˆˆˆˆˆˆˆ fields a: ' + line);
            List <String> fields = line.split(';');
            system.debug('ˆˆˆˆˆˆˆˆˆˆˆˆ fields b: ' + fields);
            //if (fields.size() == 1) {
            //    fields = line.split(';');
            //}

            system.debug('ˆˆˆˆˆˆˆˆˆˆˆˆ fields c: ' + fields);
            List <String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                    System.debug('$$$$$$$$$$$$$$$$$$ in 1' + field);
                } else if (field.startsWith('"')) {
                      makeCompositeField = true;
                      compositeField = field;
                      System.debug('$$$$$$$$$$$$$$$$$$ in 2' + field);
                } else if (field.endsWith('"')) {
                      compositeField += ',' + field;
                      cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                      makeCompositeField = false;
                      System.debug('$$$$$$$$$$$$$$$$$$ in 3' + field);
                } else if (makeCompositeField) {
                      compositeField +=  ',' + field;
                      System.debug('$$$$$$$$$$$$$$$$$$ in 4' + field);
                } else {
                      cleanFields.add(field.trim());
                      System.debug('$$$$$$$$$$$$$$$$$$ in 5' + field);
                }
            }
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields;
    }

    webservice static String getObjectId(String objectName){
        if (mapFIeldsIds == null) {

            mapFIeldsIds = new Map<string, string>();

            List<CS002_FIeldsIds__c> listFIeldsIds = [SELECT Id, FieldApiName__c, FieldId__c, ObjectApiName__c
                                                    FROM CS002_FIeldsIds__c];

            for (CS002_FIeldsIds__c fi : listFIeldsIds) {
                mapFIeldsIds.put(fi.ObjectApiName__c + fi.FieldApiName__c, fi.FieldId__c);
            }

        }

        if (mapFIeldsIds.containsKey(objectName + 'Id')) {

            return mapFIeldsIds.get(objectName + 'Id');

        } else {

            string fieldId = getObjectIdWS(objectName);

            CS002_FIeldsIds__c fi = new CS002_FIeldsIds__c(Name = 'Id' + '-' + objectName,
                                                            ObjectApiName__c = objectName,
                                                            FieldApiName__c = 'Id',
                                                            FieldId__c = fieldId);

            DataBase.insert(fi);

            return fieldId;

        }

        return null;


    }

    webservice static String getObjectIdWS(String objectName){

        //Get ids of fields
        String toolingendpoint = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v37.0/tooling/';
        string idOrNameOfObject;
        // Get Id of Custom Sobject

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        DescribeSobjectResult descr = targetType.getDescribe();

        // Si el objeto es custom, obtenemos su id.
        if(descr.isCustom()) {
            HttpRequest reqo = new HttpRequest();
            reqo.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            reqo.setHeader('Content-Type', 'application/json');

            String queryObject = 'query/?q=select+Id,DeveloperName,NamespacePrefix+from+CustomObject+where+DeveloperName+=+\''+objectName.removeEnd('__c')+'\'+LIMIT+10';
            reqo.setEndpoint(toolingendpoint + queryObject);
            reqo.setMethod('GET');

            Http ho = new Http();
            if(!Test.isRunningTest()) {
                HttpResponse reso = ho.send(reqo);
                idOrNameOfObject = reso.getBody().substringBetween('"Id":"','"');
            }
           

        // Si el objeto es estandar directamente utilizamos el nombre que nos pasaron por parametro.
        } else {
            idOrNameOfObject = objectName;
        }
        return idOrNameOfObject;


    }

    public static Boolean isRunningTest(){
        if(testOn==null){
            testOn=false;
        }
        return Test.isRunningTest() && testOn;
    }
    
    /**
     * Get a Map of Lat_Accounts by their parent account
     * @param objs - accounts to get the ids from (its a Sobject to be used from the lat_triggers)
     * @return Map of <parentAccountId, LatAccount__c>
     */
    public static Map<Id, Lat_Account__c> getLatAccountMapByAccId(List<Sobject> objs){
        Set<Id> accsId = new Set<Id>();
        for (Sobject obj:objs){
            accsId.add(obj.Id);
        }
        system.debug('ernesto+++ laaccoutnsbyaccId----' + accsId);
        Map<Id, Lat_Account__c> retMap = new Map<Id, Lat_Account__c> ();
        List<Lat_Account__c> latAccs = [SELECT Id,Name,Lat_DirectSale__c,Lat_AccountId__c FROM Lat_Account__c WHERE Lat_AccountId__c IN :accsId];
        for (Lat_Account__c latAcc : latAccs){
            retMap.put(latAcc.Lat_AccountId__c, latAcc);
        }
        return retMap;
    }

    /**
     * Generate a html table to save in the OpptyLineItem__c
     * @param lineItem - Wrapper Object that comes is parse from the soap callout
     * @return - generated table
     */
    public static String generatePriceTableForLineItem(LAT_MX_PriceCalculation.PriceCatalogueDetailsOutput lineItem){

        system.debug('generatingTable+++' + lineItem);
        String table = '';
        String discountsTotal = '';
        // Informacion basica
        String rowCanal2Descuento = '';
        String descuentos = '';
        String impuestos = '';
        String rowSubtotal = '';
        String rowPrecioLista = '';
        String rowTotales = '';
        Decimal unitTotal = 0;
        Decimal total = 0;
        Decimal ivaPerUnit = (lineItem.amountTax / lineItem.quantityOrdered).setScale(2);
        Decimal IEPSPerUnit = (lineItem.amountExcise / lineItem.quantityOrdered).setScale(2);
        // Line 1 - Precio de Lista
        rowPrecioLista = '<tr><td width="250px">'+ Label.LAT_MX_VFP04_00032 + '</td> <td align="right" width="120px">' + formatNumber(lineItem.unitPriceExclusiveDiscountsAndCharges.setScale(2))+ '</td> <td align="right" width="120px">' +formatNumber(lineItem.amountExclusiveDiscountsAndCharges.setScale(2))+ '</td></tr>';
        unitTotal = lineItem.unitPriceExclusiveDiscountsAndCharges.setScale(2);
        total = lineItem.amountExclusiveDiscountsAndCharges.setScale(2);
        //Line 2 - Descuento Canal 2
        rowSubtotal =  '<tr><td width="250px">'+ Label.LAT_MX_VFP04_00033 + '</td> <td align="right" width="120px">' + formatNumber(lineItem.unitPrice.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber(lineItem.amountTaxable.setScale(2))+ '</td></tr>';
        String rowIVA = '<tr><td width="250px">'+ 'IVA' + '</td> <td align="right" width="120px">' + formatNumber(ivaPerUnit) + '</td> <td align="right" width="120px">' +formatNumber( lineItem.amountTax.setScale(2))+ '</td></tr>';
            
        String rowIEPS = '<tr><td width="250px">'+ 'IEPS' + '</td> <td align="right" width="120px">' + formatNumber(IEPSPerUnit) + '</td> <td align="right" width="120px">' + formatNumber(lineItem.amountExcise.setScale(2)) + '</td></tr>';
        if (lineItem.discountAndChargeDetails != null) {    
            for (LAT_MX_PriceCalculation.discountAndChargeDetailsOutput discount: lineItem.discountAndChargeDetails ) {
                if (discount.discountOrChargeType.trim().equals('D')){
                    descuentos += '<tr><td width="250px">'+ discount.discountOrChargeGroupDescription + '</td> <td align="right" width="120px">' + formatNumber( discount.unitDiscountOrCharge.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( discount.amountDiscountOrCharge.setScale(2) )+ '</td></tr>';
                    unitTotal += discount.unitDiscountOrCharge.setScale(2);
                    total += discount.amountDiscountOrCharge.setScale(2);
                } else if (discount.discountOrChargeType.trim().equals('C')) {
                        //impuestos += '<tr><td width="250px">'+ discount.discountOrChargeGroupDescription + '</td> <td align="right" width="120px">' + formatNumber( discount.unitDiscountOrCharge.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( discount.amountDiscountOrCharge.setScale(2) )+ '</td></tr>';
                        //unitTotal += discount.unitDiscountOrCharge.setScale(2);
                        //total += discount.amountDiscountOrCharge.setScale(2);
                } else if (discount.discountOrChargeType.trim().equals('O')) {
                        //otros += '<tr><td width="250px">'+ discount.discountOrChargeGroupDescription + '</td> <td align="right" width="120px">' + formatNumber( discount.unitDiscountOrCharge.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( discount.amountDiscountOrCharge.setScale(2) )+ '</td></tr>';
                }
            }
        }
        impuestos = rowIVA + rowIEPS;
        total += (lineItem.amountExcise + lineItem.amountTax).setScale(2);
        // FALTA EL ROW TOTALES
        rowTotales = '<tr><td width="250px">'+ Label.LAT_MX_VFP04_00034 + '</td> <td align="right" width="120px">' + formatNumber( (total/lineItem.quantityOrdered).setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( total.setScale(2) )+ '</td></tr>';
         
        discountsTotal = rowPrecioLista + descuentos + rowSubtotal + impuestos + rowTotales;  

        // Hay que ver si no va con header
        table = beginTable + discountsTotal + endTable;
        System.debug('Salimos de generatePriceTableForLineItem MX con Tabla : '+ table);
        return table;
    }
    /**
     * Generate a html table to save in the OpptyLineItem__c
     * @param lineItem - Wrapper Object that comes is parse from the soap callout
     * @return - generated table
     */
    public static String generatePriceTableForLineItem(LAT_BR_PriceCalculation.PriceCatalogueDetailsOutput lineItem, String country){

        system.debug('generatingTable+++' + lineItem);
        String headerProduct = '';
        String table = '';
        String discountsTotal = '';
        // Informacion basica
        String descuentos = '';
        String impuestos = '';
        String otros = '';
        String rowSubtotal = '';
        String rowPrecioLista = '';
        String rowTotales = '';
        Decimal unitTotal = 0;
        Decimal total = 0;
        Decimal ivaPerUnit = (lineItem.amountTax / lineItem.quantityOrdered).setScale(2);
        Decimal IEPSPerUnit = (lineItem.amountExcise / lineItem.quantityOrdered).setScale(2);
        // Header con el nombre del Producto
        headerProduct = '<tr><td width="490px"><b> '+ lineItem.description1 +'</b></td></tr>';
        // Line 1 - Precio de Lista
        rowPrecioLista = '<tr><td width="250px">'+ Label.LAT_MX_VFP04_00032 + '</td> <td align="right" width="120px">' + formatNumber(lineItem.unitPriceExclusiveDiscountsAndCharges.setScale(2))+ '</td> <td align="right" width="120px">' +formatNumber(lineItem.amountExclusiveDiscountsAndCharges.setScale(2))+ '</td></tr>';
        unitTotal = lineItem.unitPriceExclusiveDiscountsAndCharges.setScale(2);
        total = lineItem.amountExclusiveDiscountsAndCharges.setScale(2);
        //Line 2 - Descuento Canal 2
        rowSubtotal =  '<tr><td width="250px">'+ Label.LAT_MX_VFP04_00033 + '</td> <td align="right" width="120px">' + formatNumber(lineItem.unitPrice.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber(lineItem.amountTaxable.setScale(2))+ '</td></tr>';
        if (lineItem.discountAndChargeDetails != null) {    
            for (LAT_BR_PriceCalculation.discountAndChargeDetailsOutput discount: lineItem.discountAndChargeDetails ) {
                  //generate basic infor unit price, subtotal etc
                if (discount.discountOrChargeType.trim().equals('D')){
                    descuentos += '<tr><td width="250px">'+ discount.discountOrChargeGroupDescription + '</td> <td align="right" width="120px">' + formatNumber( discount.unitDiscountOrCharge.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( discount.amountDiscountOrCharge.setScale(2) )+ '</td></tr>';
                    unitTotal += discount.unitDiscountOrCharge.setScale(2);
                    total += discount.amountDiscountOrCharge.setScale(2);
                } else if (discount.discountOrChargeType.trim().equals('C')) {
                        impuestos += '<tr><td width="250px">'+ discount.discountOrChargeGroupDescription + '</td> <td align="right" width="120px">' + formatNumber( discount.unitDiscountOrCharge.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( discount.amountDiscountOrCharge.setScale(2) )+ '</td></tr>';
                        unitTotal += discount.unitDiscountOrCharge.setScale(2);
                        total += discount.amountDiscountOrCharge.setScale(2);
                } else if (discount.discountOrChargeType.trim().equals('O')) {
                        otros += '<tr><td width="250px">'+ discount.discountOrChargeGroupDescription + '</td> <td align="right" width="120px">' + formatNumber( discount.unitDiscountOrCharge.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( discount.amountDiscountOrCharge.setScale(2) )+ '</td></tr>';
                }
            }
        }         
        unitTotal += ivaPerUnit + IEPSPerUnit;
        total += (lineItem.amountExcise + lineItem.amountTax).setScale(2);
        // FALTA EL ROW TOTALES
        rowTotales = '<tr><td width="250px">'+ Label.LAT_MX_VFP04_00034 + '</td> <td align="right" width="120px">' + formatNumber( unitTotal.setScale(2) )+ '</td> <td align="right" width="120px">' +formatNumber( total.setScale(2) )+ '</td></tr>';
         
         

        // Hay que ver si no va con header
        if (country == '1') {
            discountsTotal =  otros + descuentos + rowSubtotal + impuestos + rowTotales; 
            table = headerProduct + beginTable +  discountsTotal + endTable;
        } else {
            impuestos = '<tr><td width="250px">'+ 'Impuestos ' + '</td> <td align="right" width="120px">' + formatNumber( lineItem.amountTax.setScale(2)/lineItem.quantityOrdered )+ '</td> <td align="right" width="120px">' +formatNumber( lineItem.amountTax.setScale(2) )+ '</td></tr>';
                    
            discountsTotal =  otros + descuentos + rowSubtotal + impuestos + rowTotales; 
            table = headerProduct + beginTable + rowPrecioLista +  discountsTotal + endTable;
        }
        System.debug('Salimos de generatePriceTableForLineItem Generico con Tabla : '+ table);
        return table;
    }




    public static String formatNumber(Decimal aValue){
        aValue.setScale(2);
        return aValue.format();
        //return formatNumber(String.valueOf(aValue));
    }



}