global class ASI_CRM_TW_SalesCallPlanPageNewCtrl {
    
    public String strVPID { get; set; }
    public Account objAccount { get; private set; }
    public ASI_CRM_AccountsAdditionalField__c objAccountAddt { get; private set; }
    public ASI_HK_CRM_Visitation_Plan_Detail__c objVisitPlanDetail { get; private set; }
    public List<ASI_CRM_ConfirmedSalesVolume__c> lstSalesVolCon { get; private set; }
    public List<ASI_CRM_CalculatedSalesVolume__c> lstSalesVolCal { get; private set; }
    public List<SalesVol> lstSVCon { get; private set; }
    public List<SalesVol> lstSVCal { get; private set; }
    public List<SalesMovnt> lstSalesMovnt { get; private set; }
    public List<PromoStatus> lstPromoStatus { get; private set; }
    public List<GMARec> lstGMARec { get; private set; }
    public Boolean isQuickSave {get;set;}
    public ASI_CRM_TW_Settings__c customSettingTW {get;set;}
    public String GMAtoAccId {get;set;}
    public String GMAtoVPDId {get;set;}
    public String encodedAccountName{get;set;}
    public Decimal decNumberOfDays {get;set;}
    public Id idVisitPlanDetail {get;set;}
    Public Id idAcc {get;set;}
    public boolean allowEdit {get;set;}
    public String accountRegion {get;set;}

    public String CurrentPage { get; set; } // Page 1 = 0 , Page 2 = 1, Page 3 = 2, Page 4 = 3

    public String LastOfftakeYear {get; set; }
    public String LastOfftakeMonth {get; set; }
    public String LastDepletionYear {get; set; }
    public String LastDepletionMonth {get; set; }
    

    public String strCalSalesPotential { get; set; }
    
    public List<SelectOption> lstFileCountList {get; set;}  
    
    public List<Attachment> lstAttachmentGeneral { get; set; }
    
    //Added by Twinkle(Introv) 11/07/2014 for Promotion Status
    public List<ASI_CRM_Promotion_Status__c> lstPromoStatusRec { get; set; }
    public Map<String, PromoStatus> mapRemovePromoStatus = new Map<String, PromoStatus>();
    public String theRow { get; set; }
    public List<Integer> lstaddRows;
    public Integer index = 10000;
    
    //Added by Twinkle(Introv) 28/04/2015
    public boolean allowSetup {get;set;}
    
    //Added by Twinkle(Introv) 11/22/2016 for Pass Order
    public List<PassOrder> listPassOrder { get; private set; }
    public Map<String, PassOrder> mapRemovePassOrder = new Map<String, PassOrder>();
    public List<Integer> lstaddRows_PassOrder;
    public Integer index_PassOrder = 10000;
    
    //Added by Introv (Twinkle) @20161207 - for Visit Location Comparison
    public List<ASI_CRM_TW_Office_Location__c> listOfficeLocation {get;set;}
    
    //Added by Introv @20161124 - for getting location
    public Decimal Longitude {get; set;}
    public Decimal Latitude {get; set;}
    
    public String strRemarks {
        get { return objVisitPlanDetail.ASI_TH_CRM_Activity_Remarks__c; }
        set { objVisitPlanDetail.ASI_TH_CRM_Activity_Remarks__c = value; }
    }
    public String strObjective {
        get { return objVisitPlanDetail.ASI_HK_CRM_Visit_Objective__c; }
        set { objVisitPlanDetail.ASI_HK_CRM_Visit_Objective__c = value; }
    }
    public String strCxlReason {
        get { return objVisitPlanDetail.ASI_HK_CRM_Cancellation_Reason__c; }
        set { objVisitPlanDetail.ASI_HK_CRM_Cancellation_Reason__c = value; }
    }
    
    public String strCancelReason {
        get { return objVisitPlanDetail.ASI_CRM_Cancel_Reason__c; }
        set { objVisitPlanDetail.ASI_CRM_Cancel_Reason__c = value; }
    }
    
    public DateTime VisitDateF {
        get { return objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_From__c; }
        set { objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_From__c = value; }
    }
    public DateTime VisitDateT {
        get { return objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_To__c; }
        set { objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_To__c = value; }
    }
    public String strChannelCode {
        get { return objAccountAddt.ASI_CRM_Channel__r.ASI_CRM_CN_Channel_Code__c; }
        set { objAccountAddt.ASI_CRM_Channel__r.ASI_CRM_CN_Channel_Code__c = value; }
    } 
    public String strRegion {
        get { return objAccountAddt.ASI_CRM_Region__c; }
        set { objAccountAddt.ASI_CRM_Region__c = value; }
    }
    

    public class SalesVol {
        public String strRecDate { get; private set; }
        public String strType { get; private set; }
        public Decimal decVol { get; private set; }
        public String strShare { get; private set; }
        public Decimal decTotal { get; private set; }
        public String strImage { get; private set; }
        public String strSalesPotential { get; private set; }
        public Boolean blnDraft { get; private set; }
    }
    
    global class SalesMovnt implements Comparable{
        public String idRec { get; private set; }
        //public Id idSubBrand { get; private set; }
        //public String strSubBrand { get; private set; }
        public String strPriority { get; private set; }
        public Decimal decPrioritySorting { get; private set; }
        public Decimal decQTDPurchase { get; private set; }
        public Boolean blnDistribution { get; private set; }
        public Decimal decFacing { get; set; }
        public Decimal decListPrice { get; set; }
        public Decimal decActualRSP { get; set; }
        public Decimal decTurnoverBotl { get; private set; }
        public Boolean blnDraft { get; private set; }
        public String strSalesMovntOpt { get; set; }
        public Decimal decCurrentStock {get;set;}
        
        //Added by Twinkle (Introv) @20161130 - Replace SubBrand to Item Group on Page 2 
        public Id idItmGroup { get; private set; }
        public String strItmGroup { get; private set; }
        
        global Integer compareTo(Object compareTo) {                     
            SalesMovnt compareToSalesMovnt = (SalesMovnt)compareTo;
            if (decPrioritySorting  == compareToSalesMovnt.decPrioritySorting ) return 0;
            if (decPrioritySorting > compareToSalesMovnt.decPrioritySorting ) return 1;
            return -1;        
        }
        
        public String strErrorMessageFacing { get; set; }
        public String strErrorMessageListPrice { get; set; }
        public String strErrorMessageActualRSP { get; set; }
        public String strErrorMessageCurrentStock { get; set; }
    }        
    
    global class PromoStatus implements Comparable{
        public String idRec { get; private set; }
        public Id idPromo { get; private set; }
        public Id idSupplier { get; set; }
        public Id idAttachment { get; set; }
        public String strPromo { get; private set; }
        public String strDesc { get; private set; }
        public Datetime dteStart { get; private set; }
        public Datetime dteEnd{ get; private set; }
        public Date dtePurchaseDue { get; private set; }
        public String strPromoOpt { get; set; }
        public Boolean blnAccept { get; set; }
        public Decimal decOfferUnit { get; set; }
        public String strSupplier { get; set; }
        public Boolean blnDraft { get; private set; }
        
        public Account Supplier { get; set; }
        
        public String strTask { get; set; }
        public Boolean blnDone { get; set; }
        public String strRemarks { get; set; }
        public Boolean blnNew { get; set; }
        
        global Integer compareTo(Object compareTo) {                
            PromoStatus compareToPromoStatus = (PromoStatus)compareTo;
            if (dtePurchaseDue > compareToPromoStatus.dtePurchaseDue) return 1;
            else if (dtePurchaseDue < compareToPromoStatus.dtePurchaseDue) return -1;
            else return 0;        
        }
        
        public String strErrorMessageOfferUnit { get; set; }
    }
    
    public class GMARec {
        public String idRec { get; private set; }
        public Datetime dteDate { get; private set; }
        public Id idSubBrand { get; private set; }
        public String strSubBrand { get; private set; }
        public String strSize { get; private set; }
        public String strDisplay { get; private set; }
        public String strImporter { get; private set; }
        public Decimal decAlcholo { get; private set; }
        public Decimal decVol { get; private set; }
        public Decimal decEstVol { get; private set; }
    }
    
    global class PassOrder {
        public String idRec { get; set; }
        public String strName { get; set; }
        public String idVPD { get; set; }
        public String idItemGroup { get; set; }
        public Decimal decQuantity { get; set; }
        public String idSupplier { get; set; }
        public String strRemark { get; set; }
        public String strErrorMessageQty { get; set; }
        
        /*global Integer compareTo(Object compareTo) {                
            PassOrder compareToPassOrder = (PassOrder)compareTo;
            if (strName > compareToPassOrder.strName) return 1;
            else if (strName < compareToPassOrder.strName) return -1;
            else return 0;        
        }*/
    }
    
    public List<SelectOption> SupplierList {
        get{
            List<ASI_CRM_AccountsAdditionalField__c> listSupplier = [SELECT id, ASI_CRM_Account__c, Name FROM ASI_CRM_AccountsAdditionalField__c 
            WHERE RecordType.DeveloperName In ('ASI_CRM_TW_Outlet', 'ASI_CRM_TW_KeyAccount', 'ASI_CRM_TW_Wholesaler')
            AND ASI_CRM_Is_Supplier__c = true
            AND ASI_CRM_Account__r.ASI_TH_CRM_Region__c = :accountRegion
            ORDER BY Name];
            
            List<SelectOption> supplierList = new List<SelectOption>();
            
            for(ASI_CRM_AccountsAdditionalField__c supplier : listSupplier ){
                supplierList.add(new SelectOption(supplier.ASI_CRM_Account__c, supplier.Name));
            }
            return supplierList;
        }
    } 
    
    //Added by Twinkle(Introv) @20161122 - for Pass Order
    public List<SelectOption> ItemGroupList {
        get{
            /*List<ASI_MFM_Item_Group__c> listItemGroup = [SELECT id, Name FROM ASI_MFM_Item_Group__c  
            WHERE RecordType.DeveloperName = 'ASI_CRM_TW_Item_Group' AND 
            (ASI_CRM_Applied_To__c INCLUDES (:objAccountAddt.ASI_CRM_Channel__r.ASI_CRM_CN_Channel_Code__c) OR
            ASI_CRM_Applied_To__c INCLUDES (:objAccountAddt.ASI_CRM_CN_Sub_Channel__r.ASI_CRM_CN_Sub_Channel_Code__c))
            ORDER BY Name];*/
            
            ASI_CRM_TW_ItemGroup_UtilityCls utilityCls = new ASI_CRM_TW_ItemGroup_UtilityCls();
            String strCh = objAccountAddt.ASI_CRM_Channel__r.ASI_CRM_CN_Channel_Code__c + ';'+ objAccountAddt.ASI_CRM_CN_Sub_Channel__r.ASI_CRM_CN_Sub_Channel_Code__c;
            List<ASI_MFM_Item_Group__c> listItemGroup = utilityCls.getItemGroup(strCh);
            
            List<SelectOption> ItemGroupList = new List<SelectOption>();
            
            for(ASI_MFM_Item_Group__c itm : listItemGroup){
                ItemGroupList.add(new SelectOption(itm.id, itm.Name));
            }
            return ItemGroupList;
        }
    } 
    
    public PageReference dateValidation() {
        PageReference redirectPage;
        // Modified by William @ 2014-07-03
        // If there is visit date defined, means not ad-hoc plan, and restrict for date checking
        if (objVisitPlanDetail.ASI_CRM_Date_Difference_Actual_Planned__c != null) {
            if(objVisitPlanDetail.ASI_CRM_Date_Difference_Actual_Planned__c < -7 )
            {
                redirectPage = new PageReference('/apex/ASI_CRM_TW_SalesCallPlanErrorPage?accid=' + idAcc +'&vpid=' + idVisitPlanDetail);
                redirectPage.setRedirect(true);
            }
        }
        return redirectPage;
    }
    
    public PageReference errorMessage(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot edit the plan, as  it is 7 days before the plannd date.'));
        return null;
    
    }
    public ASI_CRM_TW_SalesCallPlanPageNewCtrl(ApexPages.StandardController stdController) {
        lstaddRows = new List<Integer>();
        lstaddRows_PassOrder = new List<Integer>();
        
        allowEdit = true;
        allowSetup = false;
        
        currentPage = ApexPages.currentPage().getParameters().get('page');
        if(CurrentPage == null || CurrentPage =='')
            CurrentPage = '0';
        
        idVisitPlanDetail = ApexPages.currentPage().getParameters().get('vpid');
        idAcc = ApexPages.currentPage().getParameters().get('accid');
        isQuickSave = true;
        
        listOfficeLocation = [SELECT id, Name, ASI_CRM_TW_Longitude__c, ASI_CRM_TW_Latitude__c FROM ASI_CRM_TW_Office_Location__c];
        
        customSettingTW = [SELECT id, ASI_CRM_TW_GMA_VPD_Id__c, ASI_CRM_TW_GMA_Account_Id__c, ASI_CRM_TW_NoOfDays_VPD__c, ASI_CRM_TW_Distance_Tolerance__c FROM ASI_CRM_TW_Settings__c];
        
        if(customSettingTW != null) {
            GMAtoVPDId = customSettingTW.ASI_CRM_TW_GMA_VPD_Id__c;
            GMAtoAccId = customSettingTW.ASI_CRM_TW_GMA_Account_Id__c;
            decNumberOfDays = customSettingTW.ASI_CRM_TW_NoOfDays_VPD__c;
        }
        if (decNumberOfDays == null)
            decNumberOfDays = 7;
        
        // Initial options
        lstFileCountList = new List<SelectOption>() ;  
        for (Integer i = 1; i <= 5; i++)
            lstFileCountList.add(new SelectOption('' + i , '' + i));
        
        // Initial one row of photo to upload
        lstAttachmentGeneral = new List<Attachment>();
        lstAttachmentGeneral.add(new Attachment());
        
        // Sample URL parameter vpid=a75M00000008PvY&accid=001M000000W2Ugg
        // https://pernod-ricard--asisb5conf--c.cs7.visual.force.com/apex/ASI_CRM_TW_SalesCallPlanPage?vpid=a75M00000008PvY&accid=001M000000W2Ugg
        //DEV
        if (idVisitPlanDetail == null) idVisitPlanDetail = 'a75M00000008PvY';
        //if (idAcc == null) idAcc = '001M000000W2Ugg'; //DEV
        //if (idAcc == null) idAcc = '001M000000XzQc4IAF'; //DEV
        
        if (idVisitPlanDetail == null) throw new ASI_CRM_TW_Function.CRM_TW_Exception('Invalid Visitation Plan Detail Id (empty)');
        if (idAcc == null) throw new ASI_CRM_TW_Function.CRM_TW_Exception('Invalid Account Id (empty)');

        strVPID = idVisitPlanDetail;
        
        // Obtain Account (Outlet) fields
        List<Account> lstAccounts = [
            SELECT Id, Name, ASI_KOR_Customer_Code__c, ASI_TH_CRM_Region__c, ASI_HK_CRM_Address__c, Phone, 
                Owner.Name, 
                (SELECT Id, Name, Title, Birthdate, MobilePhone, Email FROM Contacts WHERE ASI_HK_CRM_Main_Contact__c = true)
            FROM Account 
            WHERE Id = :idAcc
            LIMIT 1];
        
        if (lstAccounts == null || lstAccounts.size() <= 0)
            throw new ASI_CRM_TW_Function.CRM_TW_Exception('Invalid Account Id (' + idAcc + ')');
        else
        {
            objAccount = lstAccounts[0];
            accountRegion = objAccount.ASI_TH_CRM_Region__c;
            encodedAccountName = EncodingUtil.urlEncode(objAccount.Name, 'UTF-8');
        }
        // Obtain Account Additional (Customer) fields
        List<ASI_CRM_AccountsAdditionalField__c> lstAccAddt = [
            SELECT Id, Name, ASI_CRM_Channel__c, ASI_CRM_CN_Sub_Channel__r.Name,
                ASI_CRM_CN_Sub_Channel__c, ASI_TH_CRM_OutletImage__c,
                ASI_CRM_CN_Sub_Channel__r.ASI_CRM_CN_Sub_Channel_Code__c,
                ASI_TH_CRM_OutletImage__r.Name, ASI_CRM_Sales_Potential__c,
                ASI_CRM_Channel__r.ASI_CRM_CN_Channel_Code__c,
                ASI_CRM_Latest_Supplier__r.Name, ASI_CRM_Region__c,
                ASI_CRM_Longitude__c, ASI_CRM_Latitude__c,
                ASI_CRM_Account_Segment__r.Name, ASI_CRM_TW_Action_Grade__r.Name
            FROM ASI_CRM_AccountsAdditionalField__c 
            WHERE ASI_CRM_Account__c = :idAcc
            LIMIT 1
        ];
        
        if (lstAccAddt == null || lstAccAddt.size() <= 0)
            throw new ASI_CRM_TW_Function.CRM_TW_Exception('Customer Record Not Found (Account Id: ' + idAcc + ')');
        else
            objAccountAddt = lstAccAddt[0];
        
        if (objAccountAddt.ASI_TH_CRM_OutletImage__c != NULL)
            allowSetup = true;
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Outlet Image is blank. Please setup.'));   
                
        // Visitation Plan Detail
        List<ASI_HK_CRM_Visitation_Plan_Detail__c> lstVPD = [
            SELECT Id, Name,
                ASI_TH_CRM_Visit_Date_Time_From__c, ASI_TH_CRM_Visit_Date_Time_To__c, ASI_HK_CRM_Visit_Date__c,
                ASI_HK_CRM_Visit_Objective__c, ASI_TH_CRM_Activity_Remarks__c,
                ASI_HK_CRM_Cancellation_Reason__c, ASI_HK_CRM_Visitation_Plan__r.Name, ASI_CRM_Date_Difference_Actual_Planned__c, 
                ASI_CRM_Cancel_Reason__c, ASI_CRM_Longitude__c, ASI_CRM_Latitude__c, ASI_CRM_Last_Distance_Calculation__c
            FROM ASI_HK_CRM_Visitation_Plan_Detail__c
            WHERE Id = :idVisitPlanDetail
        ];

        if (lstVPD == null || lstVPD.size() <= 0)
            throw new ASI_CRM_TW_Function.CRM_TW_Exception('Visitation Plan Detail Not Found (Visitation Plan Id: ' + idVisitPlanDetail + ')');
        else
            objVisitPlanDetail = lstVPD[0];
        
        //Added by William Yang 2014-06-17
        if(objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_From__c == null)
            objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_From__c = System.Now();
        //End       
        
        List<ASI_CRM_CalculatedSegmentation__c> lstCS = [
            SELECT Id, ASI_CRM_SalesPotential__c
            FROM ASI_CRM_CalculatedSegmentation__c
            WHERE ASI_CRM_Outlet__c = :idAcc
            AND ASI_CRM_Date__c <= :objVisitPlanDetail.ASI_HK_CRM_Visit_Date__c
            ORDER BY ASI_CRM_Date__c DESC
            LIMIT 1
        ];
        strCalSalesPotential = '';
        if (lstCS != null && lstCS.size() >0)
            strCalSalesPotential = lstCS[0].ASI_CRM_SalesPotential__c;
            
        // Page 1 - Sales Volumn Record
        lstSVCon = buildConfirmedSalesVol(idAcc);
        lstSVCal = buildCalculatedSalesVol(idAcc);
        
        Longitude = objVisitPlanDetail.ASI_CRM_Longitude__c;
        Latitude = objVisitPlanDetail.ASI_CRM_Latitude__c;
        
        //20171221 Introv
        system.debug('Longitude   init.  ' + Longitude);
        system.debug('Latitude   init.  ' + Latitude);
        
        // Page 2 - Sales Movement Record
        lstSalesMovnt = buildSalesMovnt(idAcc, idVisitPlanDetail, objAccountAddt.ASI_CRM_Channel__c, objAccountAddt.ASI_CRM_CN_Sub_Channel__c, objAccountAddt.ASI_TH_CRM_OutletImage__c);
        if (lstSalesMovnt != null && lstSalesMovnt.size() > 1)
            lstSalesMovnt.Sort();
        
        // Page 3 - Promotional Detail Record
        lstPromoStatus = buildPromoStatus(idAcc, idVisitPlanDetail, strChannelCode, strRegion, (VisitDateF == null ? System.now().date() : VisitDateF.date()));
        if (lstPromoStatus != null && lstPromoStatus.size() > 1)
            lstPromoStatus.Sort();
        system.debug(lstPromoStatus );
        // Page - GMA
        lstGMARec = buildGMA(idAcc);
        system.debug(lstPromoStatus );
        if(objVisitPlanDetail.ASI_CRM_Date_Difference_Actual_Planned__c - decNumberOfDays > 0 || objVisitPlanDetail.ASI_CRM_Date_Difference_Actual_Planned__c + decNumberOfDays < 0)
        {
            allowEdit = false;
            if(objVisitPlanDetail.ASI_CRM_Date_Difference_Actual_Planned__c - decNumberOfDays > 0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This report is Read-Only as it has been 7 days after the Planned Visit Date.'));
            
        }
        
        // Page 5 - Pass Order Record
        listPassOrder = buildPassOrder(idVisitPlanDetail);
        if (listPassOrder == null || listPassOrder.size() <= 0){
            PassOrder tempObjPassOrder = new PassOrder();
            listPassOrder.add(tempObjPassOrder);
        }
        system.debug(listPassOrder);
        
    }
    
    //Added by Twinkle(Introv) 20141128 - Add a row in promo status
    public void AddRow(){
        Map<Integer, PromoStatus> mapCount = new Map<Integer, PromoStatus>();

        Integer rowIndex;
        if(theRow == null)
            rowIndex = 0;
        else
            rowIndex = Integer.valueof(theRow)-1;
        
        lstaddRows.add(rowIndex);     
        for(integer i = 0; i < lstPromoStatus.size(); i++){
            mapCount.put(i, lstPromoStatus[i]);
        }
        
        if(mapCount != null && mapCount.size()>0 && lstaddRows != null && lstaddRows.size() > 0){   
            PromoStatus ps = new PromoStatus();            
            Integer tempRow = lstaddRows[lstaddRows.size()-1];
            
            if(mapCount.get(tempRow) != null){
                ps.idRec = '#'+lstaddRows.size();
                ps.idPromo = mapCount.get(tempRow).idPromo;          
                ps.strPromo = mapCount.get(tempRow).strPromo;
                ps.strDesc = mapCount.get(tempRow).strDesc;
                ps.dteStart = mapCount.get(tempRow).dteStart;
                ps.dteEnd = mapCount.get(tempRow).dteEnd;
                ps.dtePurchaseDue = mapCount.get(tempRow).dtePurchaseDue;
                ps.blnDraft = true;
                ps.strPromoOpt = 'N';
                ps.blnAccept = false;
                ps.strTask = 'Display Setup';
                ps.blnNew = true;

                lstPromoStatus.add(ps);
            }
        }
        
        if (lstPromoStatus != null && lstPromoStatus.size() > 1)
            lstPromoStatus.Sort();       
    }
    
    //Added by Twinkle(Introv) 20141128 - Remove a row in promo status
    public void RemoveRow(){  
        Integer rowIndex;
        if(theRow == null)
            rowIndex = 0;
        else
            rowIndex = Integer.valueof(theRow)-1;
            
        mapRemovePromoStatus.put(lstPromoStatus[rowIndex].idRec, lstPromoStatus[rowIndex]);
        lstPromoStatus.remove(rowIndex);
    }
    
    //Added by Twinkle(Introv) 20161122 - Add a row in pass order
    public void AddRow_PassOrder(){
        Map<Integer, PassOrder> mapCount = new Map<Integer, PassOrder>();

        Integer rowIndex;
        if(theRow == null)
            rowIndex = 0;
        else
            rowIndex = Integer.valueof(theRow)-1;
        
        lstaddRows_PassOrder.add(rowIndex);     
        for(integer i = 0; i < listPassOrder.size(); i++){
            mapCount.put(i, listPassOrder[i]);
        }
        
        system.debug('listPassOrder: '+listPassOrder);
        if(mapCount != null && mapCount.size()>0 && lstaddRows_PassOrder != null && lstaddRows_PassOrder.size() > 0){   
            PassOrder order = new PassOrder();            
            Integer tempRow = lstaddRows_PassOrder[lstaddRows_PassOrder.size()-1];
            
            if(mapCount.get(tempRow) != null){
                order.idRec = '#'+lstaddRows_PassOrder.size();
                order.idVPD = order.idVPD;
                order.idItemGroup = mapCount.get(tempRow).idItemGroup;    
                order.decQuantity = mapCount.get(tempRow).decQuantity;
                order.idSupplier = mapCount.get(tempRow).idSupplier;
                order.strRemark = mapCount.get(tempRow).strRemark;    

                listPassOrder.add(order);
            }
        }
        system.debug('listPassOrder: '+listPassOrder);
        
        /*if (listPassOrder != null && listPassOrder.size() > 1)
            listPassOrder.Sort();       
        */
    }
    
    //Added by Twinkle(Introv) 20161122 - Remove a row in pass order
    public void RemoveRow_PassOrder(){  
        Integer rowIndex;
        if(theRow == null)
            rowIndex = 0;
        else
            rowIndex = Integer.valueof(theRow)-1;
            
        mapRemovePassOrder.put(listPassOrder[rowIndex].idRec, listPassOrder[rowIndex]);
        listPassOrder.remove(rowIndex);
    }

    /** To save record with draft flag = true, and ignore any validation rules */
    public PageReference quickSave() {
        Boolean saveSuccess = implSaveChanges();
        PageReference redirectPage = null;

        if (saveSuccess) {
            if(isQuickSave)
            {
                //Added by William Yang 20140813 to avoid duplicate records
                lstSalesMovnt = buildSalesMovnt(idAcc, idVisitPlanDetail, objAccountAddt.ASI_CRM_Channel__c, objAccountAddt.ASI_CRM_CN_Sub_Channel__c, objAccountAddt.ASI_TH_CRM_OutletImage__c);
                if (lstSalesMovnt != null && lstSalesMovnt.size() > 1)
                    lstSalesMovnt.Sort();
                
                lstPromoStatus = buildPromoStatus(idAcc, idVisitPlanDetail, strChannelCode, strRegion, (VisitDateF == null ? System.now().date() : VisitDateF.date()));
                if (lstPromoStatus != null && lstPromoStatus.size() > 1)
                    lstPromoStatus.Sort();
                lstPromoStatus=null;
                
                lstGMARec = buildGMA(idAcc);
                //End
               
                listPassOrder = buildPassOrder(idVisitPlanDetail); //Added by Twinkle(Introv) @20161122 for Pass Order 
                               
                redirectPage = Page.ASI_CRM_TW_SalesCallPlanNewPage;
                redirectPage.getParameters().put('vpid', objVisitPlanDetail.id);
                redirectPage.getParameters().put('accid', objAccount.id);
                redirectPage.getParameters().put('page', currentPage);
                redirectPage.setRedirect(true);
                
                return redirectPage;
            }
            else
            {
                redirectPage = new PageReference('/'+objVisitPlanDetail.id);
                redirectPage.setRedirect(true);
            }
        }
        
        return redirectPage;
    }
    
    /** To save record with draft flag = false, need passing all validation rules */
    public PageReference Save() {
        // Declaration
        Boolean blnValidation =  true; // Inital set to true
        isQuickSave = false;
        
        return quickSave(); //DEV
    }
    
    public Boolean implSaveChanges() {
        // Declaration
        Boolean blnHeaderValidation = true;
        Boolean blnValidation =  true; // Initial set to true
        CurrentPage = '0';
        
        system.debug('Current Longitude: '+Longitude);
        system.debug('Current Latitude: '+Latitude);
        
        List<ASI_HK_CRM_Visitation_Plan_Detail__c> lstTemp = [
            SELECT Id, ASI_HK_CRM_Visit_Date__c, ASI_CRM_Cancel_Reason__c, ASI_CRM_Location_Initial__c FROM ASI_HK_CRM_Visitation_Plan_Detail__c WHERE Id = :objVisitPlanDetail.Id
        ];
        ASI_HK_CRM_Visitation_Plan_Detail__c objVD = new ASI_HK_CRM_Visitation_Plan_Detail__c();
        if (lstTemp != null && lstTemp.size() > 0)
            objVD = lstTemp[0];
        
        //Modified by William Yang 2014-06-17
        if(objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_To__c == null)
            objVisitPlanDetail.ASI_TH_CRM_Visit_Date_Time_To__c = System.Now();
        
        //Added by Twinkle(Introv) @20150521 - Check Date From vs Date To
        if (VisitDateF.date() > VisitDateT.date()) {
            blnHeaderValidation = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Visit Date (To) should be after Visit Date (From).'));
            return false;
        }
        //Added by Twinkle(Introv) @20150521
        
        if (VisitDateF != null && objVD.ASI_HK_CRM_Visit_Date__c != null && objVD.ASI_HK_CRM_Visit_Date__c != VisitDateF.date() && !(VisitDateF.day() == objVD.ASI_HK_CRM_Visit_Date__c.day()+1 && VisitDateF.hour() < 3)) {
            if(objVisitPlanDetail.ASI_CRM_Cancel_Reason__c == null || objVisitPlanDetail.ASI_CRM_Cancel_Reason__c == '')
                if (strCxlReason == null || strCxlReason == '') {
                    blnHeaderValidation = false;
                    System.debug('Cancel Reason: ' + objVisitPlanDetail.ASI_CRM_Cancel_Reason__c);
                    //showPageError('date: ' + String.valueofGmt(VisitDateF.date()));
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Visit date differ from planned, please enter reason.'));
                    return false;
                }
        }
        
        if ((strObjective == null || strObjective.length() < 1) && objVisitPlanDetail.ASI_CRM_Cancel_Reason__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Objective is required.'));
            return false;
        }

        // Update Visitation Plan Detail
        objVD.ASI_TH_CRM_Visit_Date_Time_From__c = VisitDateF;
        objVD.ASI_TH_CRM_Visit_Date_Time_To__c = VisitDateT;
        objVD.ASI_HK_CRM_Cancellation_Reason__c = strCxlReason;
        objVD.ASI_CRM_Cancel_Reason__c = strCancelReason;
        objVD.ASI_HK_CRM_Visit_Objective__c = strObjective;
        objVD.ASI_TH_CRM_Activity_Remarks__c = strRemarks;
        //objVD.ASI_CRM_Longitude__c = (Longitude != null && Longitude != 0)? Longitude:null;
        //objVD.ASI_CRM_Latitude__c = (Latitude != null && Latitude != 0)? Latitude:null;
        
        //Added by Introv @20161124 - Compare current User Location with Outlet location & Company Location
        boolean boolLocationMatched = false;
        Decimal intTolerance = customSettingTW.ASI_CRM_TW_Distance_Tolerance__c;
        
        system.debug('Enter');
        
        
        //if(Longitude != null && Longitude != 0 && Latitude != null && Latitude != 0){
            if(objVD.ASI_CRM_Location_Initial__c == null){
                objVD.ASI_CRM_Longitude__c = Longitude;
                objVD.ASI_CRM_Latitude__c = Latitude;
            }
            else{
                objVD.ASI_CRM_Longitude_Last_Modified__c = Longitude;
                objVD.ASI_CRM_Latitude_Last_Modified__c = Latitude;
            }
            
            if(Longitude != null && Longitude != 0 && Latitude != null && Latitude != 0 && objAccountAddt.ASI_CRM_Longitude__c != null && objAccountAddt.ASI_CRM_Latitude__c != null){
                Location loc1 = Location.newInstance(Latitude, Longitude);
                Location loc2 = Location.newInstance(objAccountAddt.ASI_CRM_Latitude__c, objAccountAddt.ASI_CRM_Longitude__c);
                
                system.debug('Outlet. Get Distance: '+Location.getDistance(loc1, loc2, 'km')*1000);
                
                objVD.ASI_CRM_Last_Distance_Calculation__c = Decimal.valueof(Location.getDistance(loc1, loc2, 'km')*1000)+'(Outlet)\n'; //Temp for checking    
                if(Location.getDistance(loc1, loc2, 'km')*1000 <= intTolerance){
                    if(objVD.ASI_CRM_Location_Initial__c == null)
                        objVD.ASI_CRM_Location_Initial__c = 'Outlet';
                    else
                        objVD.ASI_CRM_Location_Last_Modified__c = 'Outlet';
                        
                    boolLocationMatched = true;
                }
            }
            system.debug('Location matched: '+boolLocationMatched);
            
            if(!boolLocationMatched){
                for(ASI_CRM_TW_Office_Location__c  ol : listOfficeLocation){
                    Location loc1 = Location.newInstance(Latitude, Longitude);
                    Location loc2 = Location.newInstance(ol.ASI_CRM_TW_Latitude__c, ol.ASI_CRM_TW_Longitude__c);
                
                    system.debug('Office. Get Distance: '+Location.getDistance(loc1, loc2, 'km')*1000);
                    //system.debug('2. Calculate Distance: '+calculateDistance(ol.ASI_CRM_TW_Latitude__c, ol.ASI_CRM_TW_Longitude__c, Latitude, Longitude));
                    
                    objVD.ASI_CRM_Last_Distance_Calculation__c += Decimal.valueof(Location.getDistance(loc1, loc2, 'km')*1000)+'('+ol.Name+')\n'; //Temp for checking  
                    if(ol.ASI_CRM_TW_Longitude__c != null && ol.ASI_CRM_TW_Latitude__c != null){
                        if(Location.getDistance(loc1, loc2, 'km')*1000 <= intTolerance){
                            if(objVD.ASI_CRM_Location_Initial__c == null)
                                objVD.ASI_CRM_Location_Initial__c = ol.Name;
                            else
                                objVD.ASI_CRM_Location_Last_Modified__c = ol.Name;
                                
                            boolLocationMatched = true;
                            break;
                        }
                    }
                }
            }
            
            if(!boolLocationMatched){
                if(objAccountAddt.ASI_CRM_Longitude__c != null && objAccountAddt.ASI_CRM_Latitude__c != null){
                    if(objVD.ASI_CRM_Location_Initial__c == null)
                        objVD.ASI_CRM_Location_Initial__c = 'Others';
                    else
                        objVD.ASI_CRM_Location_Last_Modified__c = 'Others';
                }
                else{
                    if(objVD.ASI_CRM_Location_Initial__c == null)
                        objVD.ASI_CRM_Location_Initial__c = 'Unknown Outlet Geolocation';
                    else
                        objVD.ASI_CRM_Location_Last_Modified__c = 'Unknown Outlet Geolocation';
                }
            }
        //}
        //Added by Introv @20161124
        
        if (blnHeaderValidation == true)
            update objVD;
        else
            showPageError('Visit date (From) differ from planned visit date, please enter "Reason". ');
        
        //if (CallLog!=null)
        //    upsert CallLog;
        
        //Page 2 Validation
        /*For (SalesMovnt salesMovnt:lstSalesMovnt){
            if(salesMovnt.blnDistribution == true && salesMovnt.decListPrice == null || salesMovnt.decListPrice = 0){            
                showPageError('Please enter List Price. ');
                }
            else if (salesMovnt.blnDistribution && salesMovnt.decActualRSP == null)
                showPageError('Please enter actualRSP. ');
        }*/
        
        /*if(objVD.ASI_CRM_Cancel_Reason__c == null && objVD.ASI_CRM_Cancel_Reason__c == '')
            return false;
        else {*/
            system.debug('listPassOrder: '+listPassOrder);
            Boolean blnIsError = false;
        
            List<ASI_CRM_Sales_Movement__c> lstUpsertSalesMovnt = new List<ASI_CRM_Sales_Movement__c>();
            
            for (SalesMovnt salesMovnt : lstSalesMovnt ){  
                
                salesMovnt.strErrorMessageFacing = '';
                salesMovnt.strErrorMessageListPrice = '';
                salesMovnt.strErrorMessageActualRSP = '';  
                salesMovnt.strErrorMessageCurrentStock = '';             
                
                ASI_CRM_Sales_Movement__c sm = new ASI_CRM_Sales_Movement__c ();   
                sm.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Sales_Movement__cASI_CRM_TW_SalesMovement');        
                
                sm.id = salesMovnt.idRec;
                sm.ASI_CRM_VisitationPlanDetail__c = objVisitPlanDetail.id;
                sm.ASI_CRM_Account__c = objAccount.id;            
                //sm.ASI_CRM_Sub_brand__c = salesMovnt.idSubBrand;
                sm.ASI_CRM_Item_Group__c = salesMovnt.idItmGroup;
                
                //Modified by William Yang 2014-06-17
                //sm.ASI_CRM_Date__c = objVD.ASI_HK_CRM_Visit_Date__c;
                sm.ASI_CRM_Date__c = VisitDateF.date();
                //End
                
                if(salesMovnt.decActualRSP != null && salesMovnt.decActualRSP != 0)
                    salesMovnt.strSalesMovntOpt = 'Y';
                
                if (salesMovnt.strSalesMovntOpt == 'Y') {
                    if(strChannelCode == 'WS' || strChannelCode == 'CVS'){
                        if (salesMovnt.decActualRSP == 0 || salesMovnt.decActualRSP == null ) { 
                            CurrentPage = '1';
                            salesMovnt.strErrorMessageActualRSP = 'Please enter Actual RSP.';
                            blnIsError = true;
                        }
                        if (salesMovnt.decCurrentStock == 0 || salesMovnt.decCurrentStock == null) { 
                            CurrentPage = '1';
                            salesMovnt.strErrorMessageCurrentStock = 'Please enter Current Stock.';
                            blnIsError = true;
                        }
                    }
                    else{
                        if (salesMovnt.decListPrice == 0 || salesMovnt.decListPrice == null ) { 
                            CurrentPage = '1';
                            salesMovnt.strErrorMessageListPrice = 'Please enter List Price.';
                            blnIsError = true;
                        }
                        if (salesMovnt.decActualRSP == 0 || salesMovnt.decActualRSP == null ) { 
                            CurrentPage = '1';
                            salesMovnt.strErrorMessageActualRSP = 'Please enter Actual RSP.';
                            blnIsError = true;
                        }
                        if (salesMovnt.decCurrentStock == 0 || salesMovnt.decCurrentStock == null ) { 
                            CurrentPage = '1';
                            salesMovnt.strErrorMessageCurrentStock = 'Please enter Current Stock.';
                            blnIsError = true;
                        }
                    }
                    
                    sm.ASI_CRM_Distribution__c = true;
                }
                else
                    sm.ASI_CRM_Distribution__c = false;
                
                System.debug('salesMovnt.decFacing:' + salesMovnt.decFacing);
                System.debug('salesMovnt.decListPrice:' + salesMovnt.decListPrice);
                System.debug('salesMovnt.decActualRSP:' + salesMovnt.decActualRSP);
                sm.ASI_CRM_Facing__c = salesMovnt.decFacing;
                sm.ASI_CRM_List_Price__c = salesMovnt.decListPrice;
                sm.ASI_CRM_Actual_RSP__c = salesMovnt.decActualRSP;    
                sm.ASI_CRM_Current_Stock__c = salesMovnt.decCurrentStock;
                
                lstUpsertSalesMovnt.add(sm);
            }
            
            List<ASI_CRM_Promotion_Status__c> lstUpsertPromoStatus = new List<ASI_CRM_Promotion_Status__c>();
            List<ASI_CRM_Promotion_Status__c> lstRemovePromoStatus = new List<ASI_CRM_Promotion_Status__c>();
            Set<id> setRemovePromoStatus = new Set<id>();
            
            //Modified by Twinkle(Introv) 20141128 - For Add/Remove on Page 3
            if(lstPromoStatus != null && lstPromoStatus.size()>0){
                for (PromoStatus promoStatus: lstPromoStatus){                   
                    ASI_CRM_Promotion_Status__c ps = new ASI_CRM_Promotion_Status__c();    
                     ps.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Promotion_Status__cASI_CRM_TW_PromotionStatus');           
    
                    if(!mapRemovePromoStatus.containsKey(promoStatus.idRec)){
                        if(promoStatus.idRec != null && promoStatus.idRec.contains('#')) 
                            promoStatus.idRec = null;
                                                                                    
                        ps.id = promoStatus.idRec;
                        ps.ASI_CRM_VisitationPlanDetail__c = objVisitPlanDetail.id;
                        ps.ASI_CRM_Account__c = objAccount.id;            
                        ps.ASI_CRM_Promotion__c = promoStatus.idPromo;
                        //addded by Stella.Li 2015-03-16
                        ps.ASI_CRM_Source__c  = 'Sales Call';
                        //End
                        //Modified by William Yang 2014-06-17
                        //ps.ASI_CRM_Date__c = objVD.ASI_HK_CRM_Visit_Date__c;
                        ps.ASI_CRM_Date__c = VisitDateF.date();
                        //End
                        
                        //Comment by Twinkle(Introv) 20150114 - Remove YES/NO radio button  
                        /*if(promoStatus.decOfferUnit != null && promoStatus.decOfferUnit != 0){
                            promoStatus.strPromoOpt = 'Y';  
                        if (promoStatus.strPromoOpt == 'Y') {
                            if (promoStatus.decOfferUnit == null || promoStatus.decOfferUnit == 0 ) { 
                                CurrentPage = '2';
                                promoStatus.strErrorMessageOfferUnit = 'Please enter Unit.';
                                blnIsError = true;
                            }
                            ps.ASI_CRM_Offer_Accepted__c = true;
                        }else 
                            ps.ASI_CRM_Offer_Accepted__c = false;
                        */
                        if(promoStatus.decOfferUnit != null && promoStatus.decOfferUnit != 0){
                            ps.ASI_CRM_Offer_Accepted__c = true;                        
                        }else{
                            ps.ASI_CRM_Offer_Accepted__c = false;
                        }
                        ps.ASI_CRM_Unit__c = promoStatus.decOfferUnit;                           
                        ps.ASI_CRM_Supplier__c = promoStatus.idSupplier;
                        ps.ASI_CRM_Done__c = promoStatus.blnDone;
                        ps.ASI_CRM_Remarks__c = promoStatus.strRemarks;
                        
                        if(ps.id != null || (ps.id == null && ps.ASI_CRM_Offer_Accepted__c == true))
                            lstUpsertPromoStatus.add(ps);
                    //}
                    }
                }
                //Modified by Twinkle(Introv) 20141128
                
                //Added by Twinkle(Introv) 20141128 - For Remove on Page 3
                if(mapRemovePromoStatus != null && mapRemovePromoStatus.size() > 0){
                    lstRemovePromoStatus = [SELECT Id FROM ASI_CRM_Promotion_Status__c WHERE Id IN: mapRemovePromoStatus.keySet()];
                    delete lstRemovePromoStatus;
                }
                system.debug(lstUpsertPromoStatus);
                //Added by Twinkle(Introv) 20141128
            }
            
            //Added by Twinkle(Introv) 20161122 for Pass Order
            List<ASI_CRM_Pass_Order__c> lstUpsertPassOrder = new List<ASI_CRM_Pass_Order__c>();
            List<ASI_CRM_Pass_Order__c> lstRemovePassOrder = new List<ASI_CRM_Pass_Order__c>();
            Set<id> setRemovePassOrder = new Set<id>();
            
            system.debug('listPassOrder: '+listPassOrder);
            if(listPassOrder != null && listPassOrder.size()>0){
                for(PassOrder order : listPassOrder){                   
                    ASI_CRM_Pass_Order__c tempPassOrder = new ASI_CRM_Pass_Order__c();    
                     tempPassOrder.RecordTypeId = Global_RecordTypeCache.getRTId('ASI_CRM_Pass_Order__cASI_CRM_TW_Pass_Order');           
        
                    if(!mapRemovePassOrder.containsKey(order.idRec)){
                        if(order.idRec != null && order.idRec.contains('#')) 
                            order.idRec = null;
                                                                                    
                        tempPassOrder.id = order.idRec;
                        tempPassOrder.ASI_CRM_Order_Date__c = VisitDateT.date();
                        tempPassOrder.ASI_CRM_Visitation_Plan_Detail__c = objVisitPlanDetail.id;
                        tempPassOrder.ASI_CRM_Account__c = objAccount.id;  
                        tempPassOrder.ASI_CRM_Item_Group__c = order.idItemGroup;
                        tempPassOrder.ASI_CRM_Supplier__c = order.idSupplier;     
                        tempPassOrder.ASI_CRM_Quantity_Btl_Box__c = order.decQuantity;
                        tempPassOrder.ASI_CRM_Remark__c = order.strRemark;   
                        
                        /*if (order.decQuantity == null || order.decQuantity == 0) { 
                            if(CurrentPage == '0')
                                CurrentPage = '4';
                            order.strErrorMessageQty = 'Please enter Quantity.';
                            blnIsError = true;
                        }*/        
                        
                        if(tempPassOrder.id != null && (tempPassOrder.ASI_CRM_Quantity_Btl_Box__c == NULL || tempPassOrder.ASI_CRM_Quantity_Btl_Box__c == 0)){
                            if(CurrentPage == '0')
                                CurrentPage = '4';
                            order.strErrorMessageQty = 'Please enter Quantity.';
                            blnIsError = true;
                        }
                        else if(tempPassOrder.id != null || 
                          (tempPassOrder.id == null && (tempPassOrder.ASI_CRM_Quantity_Btl_Box__c != NULL && tempPassOrder.ASI_CRM_Quantity_Btl_Box__c != 0)))
                            lstUpsertPassOrder.add(tempPassOrder);
                    }
                }
            }
            if(mapRemovePassOrder != null && mapRemovePassOrder.size() > 0){
                lstRemovePassOrder = [SELECT Id FROM ASI_CRM_Pass_Order__c WHERE Id IN: mapRemovePassOrder.keySet()];
                delete lstRemovePassOrder;
            }
            system.debug('lstUpsertPassOrder: '+lstUpsertPassOrder);
            
            if (blnIsError == true) 
                return false;
            else{
                if(lstUpsertSalesMovnt != null && lstUpsertSalesMovnt.size() > 0)
                    upsert lstUpsertSalesMovnt;
                if(lstUpsertPromoStatus != null && lstUpsertPromoStatus.size() >0)
                    upsert lstUpsertPromoStatus;
                if(lstUpsertPassOrder != null && lstUpsertPassOrder.size() >0)
                    upsert lstUpsertPassOrder;
                return true;
            } 
            //Added by Twinkle(Introv) 20161122 for Pass Order
        //}
    }
    
    /** Get Current time in local-time zone */
    public Datetime getLocalTime(Datetime dt) {
        TimeZone tz = UserInfo.getTimeZone();
        return dt.AddSeconds(tz.getOffset(dt) / 1000);
    }
    
    /** For Sales Call Plan Page 1 */
    private List<SalesVol> buildConfirmedSalesVol(Id idAcc) {
        // Declaration
        List<SalesVol> lstRes = new List<SalesVol>();
        Date dteMaxDate = null;
        SalesVol sv = new SalesVol();
        Decimal decTTLVol = 0;
        Decimal decTTTotal = 0;
        
        // Max Confirmed Sales Volume Date
        AggregateResult[] agrRes = [
            SELECT MAX(ASI_CRM_Date__c) ASI_CRM_Date__c
            FROM ASI_CRM_ConfirmedSalesVolume__c
            WHERE ASI_CRM_Outlet__c = :idAcc
        ];
        
        if (agrRes!=null && agrRes.size() > 0)
            dteMaxDate = (Date) agrRes[0].get('ASI_CRM_Date__c');
            
        // Confirmed Sales Volume List according to the MaxDate 
        lstSalesVolCon = [
            SELECT ASI_CRM_Date__c, ASI_CRM_ProductCategory__r.Name, ASI_CRM_PRTShare__c, ASI_CRM_PRTVolume__c, ASI_CRM_Total__c
            FROM ASI_CRM_ConfirmedSalesVolume__c
            WHERE ASI_CRM_Outlet__c = :idAcc
            AND ASI_CRM_Date__c = :dteMaxDate
            ORDER BY ASI_CRM_ProductCategory__r.Name
        ];
        
        for (ASI_CRM_ConfirmedSalesVolume__c csv : lstSalesVolCon) {
            sv = new SalesVol();
            sv.strRecDate = String.valueOf(csv.ASI_CRM_Date__c);
            sv.strType = csv.ASI_CRM_ProductCategory__r.Name;
            sv.decVol = csv.ASI_CRM_PRTVolume__c;
            sv.strShare = csv.ASI_CRM_PRTShare__c;
            sv.decTotal = csv.ASI_CRM_Total__c;
            sv.strImage = '';
            sv.strSalesPotential = '';
            lstRes.add(sv);
            
            decTTLVol += sv.decVol;
            decTTTotal += sv.decTotal;
        }
        // To construct total row
        sv = new SalesVol();
        sv.strRecDate = '';
        sv.strType = 'Total';
        sv.decVol = decTTLVol;
        sv.strShare = String.valueOf((decTTLVol * 100 / (decTTTotal == 0 ? 1 : decTTTotal)).setScale(2, RoundingMode.HALF_UP)) + ' %';
        sv.decTotal = decTTTotal;
        sv.strImage = '';
        sv.strSalesPotential = '';
        lstRes.add(sv);
        
        return lstRes;
    }

    /** For Sales Call Plan Page 1 */
    private List<SalesVol> buildCalculatedSalesVol(Id idAcc) {
        // Declaration
        List<SalesVol> lstRes = new List<SalesVol>();
        Date dteMaxDate = null;
        SalesVol sv = new SalesVol();
        Decimal decTTLVol = 0;
        Decimal decTTTotal = 0;
        
        // Max Calculated Sales Volume Date
        AggregateResult[] agrRes = [SELECT MAX(ASI_CRM_Date__c) ASI_CRM_Date__c FROM ASI_CRM_CalculatedSalesVolume__c WHERE ASI_CRM_Outlet__c = :idAcc ];
        dteMaxDate = null;
        if (agrRes != null && agrRes.size() > 0)
            dteMaxDate = (Date) agrRes[0].get('ASI_CRM_Date__c');
        // Calculated Sales Volume List according to the MaxDate 
        lstSalesVolCal = [
            SELECT ASI_CRM_Date__c, ASI_CRM_ProductCategory__r.Name, ASI_CRM_PRTShare__c, ASI_CRM_PRTVolume__c, ASI_CRM_Total__c
            FROM ASI_CRM_CalculatedSalesVolume__c
            WHERE ASI_CRM_Outlet__c = :idAcc
            AND ASI_CRM_Date__c = :dteMaxDate
            ORDER BY ASI_CRM_ProductCategory__r.Name
        ];
        
        lstRes = new List<SalesVol>();
        for (ASI_CRM_CalculatedSalesVolume__c csv : lstSalesVolCal) {
            sv = new SalesVol();
            sv.strRecDate = String.valueOf(csv.ASI_CRM_Date__c);
            sv.strType = csv.ASI_CRM_ProductCategory__r.Name;
            sv.decVol = csv.ASI_CRM_PRTVolume__c != null ? csv.ASI_CRM_PRTVolume__c : 0;
            sv.strShare = csv.ASI_CRM_PRTShare__c;
            sv.decTotal = csv.ASI_CRM_Total__c != null ? csv.ASI_CRM_Total__c : 0;
            sv.strImage = '';
            sv.strSalesPotential = '';
            lstRes.add(sv);
            
            decTTLVol += sv.decVol;
            decTTTotal += sv.decTotal;
        }
        // To construct total row
        sv = new SalesVol();
        sv.strRecDate = '';
        sv.strType = 'Total';
        sv.decVol = decTTLVol;
        sv.strShare = String.valueOf((decTTLVol * 100 / (decTTTotal == 0 ? 1 : decTTTotal)).setScale(2, RoundingMode.HALF_UP)) + ' %';
        sv.decTotal = decTTTotal;
        sv.strImage = '';
        sv.strSalesPotential = '';
        lstRes.add(sv);
        
        return lstRes;
    }
    
    /*** For Sales Movement Page 2 */
    private List<SalesMovnt> buildSalesMovnt(Id idAcc, Id idVPID, Id idCh, Id idSubCh, Id idImage) {
        // Declaration
        Map<Id, SalesMovnt> mapSalesMovnt = new Map<Id, SalesMovnt>();
        Map<Id, ASI_CRM_Sales_Movement__c> mapLastVisitRes = new Map<Id, ASI_CRM_Sales_Movement__c>();
        Map<Id, ASI_CRM_OutletDepletion__c> mapLastOutletDepletion = new Map<Id, ASI_CRM_OutletDepletion__c>();
        Map<Id, ASI_TH_CRM_Actual_Offtake__c> mapActualOfftake = new Map<Id, ASI_TH_CRM_Actual_Offtake__c>();
        
        //Modified by William Yang (Introv) @ 21/04/2016
        String strVisitYear = String.ValueOf(VisitDateF.year());
        String strVisitMonth = String.ValueOf(VisitDateF.month());
        String strLastVisitYear = '';
        String strLastVisitMonth = '';
        String strLastOfftakeYear = '';
        String strLastOfftakeMonth = '';
        String strLastDepletionYear = '';
        String strLastDepletionMonth='';
        
        
        //Modified by William Yang(Introv) @21/04/2016 
        //Get Last Visit Sales Movement Detail Record       
        
        for (ASI_CRM_Sales_Movement__c objSalesMovntRec : [
            SELECT Id, ASI_CRM_Account__c,
                ASI_CRM_Actual_RSP__c, ASI_CRM_Date__c, 
                ASI_CRM_Distribution__c, ASI_CRM_Draft_Flag__c,
                ASI_CRM_Facing__c, ASI_CRM_List_Price__c,
                ASI_CRM_Sub_brand__c, ASI_CRM_VisitationPlanDetail__c,
                ASI_CRM_Sub_brand__r.Name, ASI_CRM_Year__c, ASI_CRM_Month__c,
                ASI_CRM_Current_Stock__c, ASI_CRM_Item_Group__c, ASI_CRM_Item_Group__r.Name
            FROM ASI_CRM_Sales_Movement__c
            WHERE ASI_CRM_Account__c = :idAcc
            //AND ASI_CRM_VisitationPlanDetail__c = :idVPID
            ORDER BY ASI_CRM_Date__c DESC 
        ]) {     
            if(strLastVisitYear == '' && strLastVisitMonth == '')
            {
                strLastVisitYear = objSalesMovntRec.ASI_CRM_Year__c;
                strLastVisitMonth = objSalesMovntRec.ASI_CRM_Month__c;
            }
            if(objSalesMovntRec.ASI_CRM_Year__c == strLastVisitYear && objSalesMovntRec.ASI_CRM_Month__c == strLastVisitMonth)
                if(objSalesMovntRec.ASI_CRM_Year__c ==  strVisitYear && objSalesMovntRec.ASI_CRM_Month__c == strVisitMonth) {
                    SalesMovnt sm = new SalesMovnt();
                    sm.idRec = objSalesMovntRec.Id;
                    //sm.idSubBrand = objSalesMovntRec.ASI_CRM_Sub_brand__c;
                    //sm.strSubBrand = objSalesMovntRec.ASI_CRM_Sub_brand__r.Name;
                    sm.idItmGroup = objSalesMovntRec.ASI_CRM_Item_Group__c;
                    sm.strItmGroup = objSalesMovntRec.ASI_CRM_Item_Group__r.Name;
                    //sm.strPriority = ''; //DEV
                    sm.decQTDPurchase = 0; //DEV
                    sm.blnDistribution = objSalesMovntRec.ASI_CRM_Distribution__c;
                    sm.strSalesMovntOpt = (sm.blnDistribution) ? 'Y' : 'N';
                    sm.decFacing = objSalesMovntRec.ASI_CRM_Facing__c;
                    sm.decListPrice = objSalesMovntRec.ASI_CRM_List_Price__c;
                    sm.decActualRSP = objSalesMovntRec.ASI_CRM_Actual_RSP__c;
                    sm.decCurrentStock = objSalesMovntRec.ASI_CRM_Current_Stock__c;
                    sm.decTurnoverBotl = 0; //DEV
                    sm.blnDraft = objSalesMovntRec.ASI_CRM_Draft_Flag__c;
                    //mapSalesMovnt.put(objSalesMovntRec.ASI_CRM_Sub_brand__c, sm);  
                    mapSalesMovnt.put(objSalesMovntRec.ASI_CRM_Item_Group__c, sm);  
                }
                else 
                    mapLastVisitRes.put(objSalesMovntRec.ASI_CRM_Item_Group__c, objSalesMovntRec);
            else
                break;
        }
        
        // Dynamic generate Sales Movement Record
        List<ASI_CRM_ServicePackItem__c> lstSP = [
            SELECT Id, ASI_CRM_Priority__c, ASI_CRM_TW_Priority_Sorting__c,
                ASI_CRM_ServicePack__c, ASI_CRM_ServicePack__r.Name,
                ASI_CRM_Subbrand__c, ASI_CRM_Subbrand__r.Name,
                ASI_CRM_Item_Group__c, ASI_CRM_Item_Group__r.Name
            FROM ASI_CRM_ServicePackItem__c
            WHERE ASI_CRM_ServicePack__r.ASI_CRM_Channel__c = :idCh
            AND ASI_CRM_ServicePack__r.ASI_CRM_SubChannel__c = :idSubCh
            AND ASI_CRM_ServicePack__r.ASI_CRM_OutletImage__c = :idImage
            ORDER BY ASI_CRM_Priority__c, ASI_CRM_Item_Group__r.Name
        ]; 
        
        /*Set<id> setSubBrandId = new Set<id>();
        for (ASI_CRM_ServicePackItem__c spi : lstSP) {
            setSubBrandId.add(spi.ASI_CRM_Subbrand__c);
        }

        // Get Latest Monthly Outlet Actual Offtake Record
        for (ASI_TH_CRM_Actual_Offtake__c objActualOfftakeRec : [SELECT Id, ASI_TH_CRM_Quantity__c, ASI_TH_CRM_Sub_brand__c,
                                                            ASI_TH_CRM_Year__c , ASI_TH_CRM_Month__c 
                                                            FROM ASI_TH_CRM_Actual_Offtake__c
                                                            WHERE ASI_TH_CRM_Outlet__c = :idAcc
                                                            AND ASI_TH_CRM_Sub_brand__c in :setSubBrandId
                                                            Order by ASI_TH_CRM_Offtake_G_L_Date__c Desc
        ]) {       
            if(strLastOfftakeYear == '' && strLastOfftakeMonth == ''){
                strLastOfftakeYear = objActualOfftakeRec.ASI_TH_CRM_Year__c;
                strLastOfftakeMonth = objActualOfftakeRec.ASI_TH_CRM_Month__c;
            }
            if(strLastOfftakeYear == objActualOfftakeRec.ASI_TH_CRM_Year__c && strLastOfftakeMonth == objActualOfftakeRec.ASI_TH_CRM_Month__c) 
                mapActualOfftake.put(objActualOfftakeRec.ASI_TH_CRM_Sub_brand__c, objActualOfftakeRec);
            else 
                break;
        }
        
        LastOfftakeYear = strLastOfftakeYear;
        LastOfftakeMonth = strLastOfftakeMonth;
        
        // Get Latest Monthly Outlet Depletions Record
        for (ASI_CRM_OutletDepletion__c objOutletDepletionRec : [SELECT Id, ASI_CRM_Depletion__c, ASI_CRM_SubBrand__c, ASI_CRM_Year__c, ASI_CRM_Month__c
                                                            FROM ASI_CRM_OutletDepletion__c
                                                            WHERE ASI_CRM_Outlet__c = :idAcc
                                                            AND ASI_CRM_SubBrand__c in :setSubBrandId
                                                            Order by ASI_CRM_Date__c Desc
        ]) {       
            if(strLastDepletionYear == '' && strLastDepletionMonth == ''){
                strLastDepletionYear = objOutletDepletionRec.ASI_CRM_Year__c;
                strLastDepletionMonth = objOutletDepletionRec.ASI_CRM_Month__c;
            }
            if(strLastDepletionYear == objOutletDepletionRec.ASI_CRM_Year__c && strLastDepletionMonth == objOutletDepletionRec.ASI_CRM_Month__c) 
                mapLastOutletDepletion.put(objOutletDepletionRec.ASI_CRM_SubBrand__c, objOutletDepletionRec ); 
            else 
                break;
        }
        
        LastDepletionYear = strLastDepletionYear;
        LastDepletionMonth = strLastDepletionMonth;                               
        */
        
        for (ASI_CRM_ServicePackItem__c spi : lstSP) {
            SalesMovnt sm = new SalesMovnt();
            Boolean blnExists = false;
            if (mapSalesMovnt.containsKey(spi.ASI_CRM_Item_Group__c))
                blnExists = true;
            
            if (blnExists) {
                sm = mapSalesMovnt.get(spi.ASI_CRM_Item_Group__c);                                                
            } else {
                sm.blnDistribution = false;
                
                if (mapLastVisitRes.containsKey(spi.ASI_CRM_Item_Group__c)){
                    ASI_CRM_Sales_Movement__c lastVisitSalesMovnt = (ASI_CRM_Sales_Movement__c)mapLastVisitRes.get(spi.ASI_CRM_Item_Group__c);
                    
                    sm.decFacing = lastVisitSalesMovnt.ASI_CRM_Facing__c;
                    sm.decListPrice = lastVisitSalesMovnt.ASI_CRM_List_Price__c;
                    sm.decActualRSP = lastVisitSalesMovnt.ASI_CRM_Actual_RSP__c;    
                    sm.decCurrentStock = lastVisitSalesMovnt.ASI_CRM_Current_Stock__c;
                }
            }
            
            /*if (mapActualOfftake.containsKey(spi.ASI_CRM_Subbrand__c)){
                ASI_TH_CRM_Actual_Offtake__c lastVisitActualOfftake = (ASI_TH_CRM_Actual_Offtake__c)mapActualOfftake.get(spi.ASI_CRM_Subbrand__c);
                
                sm.decQTDPurchase = lastVisitActualOfftake.ASI_TH_CRM_Quantity__c;
            }               
            else    
                sm.decQTDPurchase = 0;*/
            
            sm.strSalesMovntOpt = (sm.blnDistribution) ? 'Y' : 'N';
            sm.idItmGroup = spi.ASI_CRM_Item_Group__c;
            sm.strItmGroup = spi.ASI_CRM_Item_Group__r.Name;
            sm.strPriority = spi.ASI_CRM_Priority__c;
            sm.decPrioritySorting = spi.ASI_CRM_TW_Priority_Sorting__c;

            /*if (mapLastOutletDepletion.containsKey(spi.ASI_CRM_Subbrand__c)){
                ASI_CRM_OutletDepletion__c lastOutletDepletion = (ASI_CRM_OutletDepletion__c)mapLastOutletDepletion.get(spi.ASI_CRM_Subbrand__c); 
               sm.decTurnoverBotl = lastOutletDepletion.ASI_CRM_Depletion__c;                
            }else
               sm.decTurnoverBotl = 0; //DEV
            */
            
            mapSalesMovnt.put(spi.ASI_CRM_Item_Group__c, sm);
        } 
        
        return mapSalesMovnt.values();
    }
    
    /*** For Sales Call Plan Page 3 */
    private List<PromoStatus> buildPromoStatus(Id idAcc, Id idVPID, String strCh, String strRegion, Date dteDate) {
        // Declaration
        Map<String, PromoStatus> mapPromoStatus = new Map<String, PromoStatus>();
        Map<Id, Attachment> mapAttachment = new Map<Id, Attachment>();
        Set<Id> idTempPromo = new Set<Id>();      
        lstPromoStatusRec = new List<ASI_CRM_Promotion_Status__c>();
        
        // Get saved Promotional Detail Record
        lstPromoStatusRec = [
            SELECT Id, ASI_CRM_Source__c, ASI_CRM_Customer__c, ASI_CRM_Account__c, ASI_CRM_Date__c, ASI_CRM_Promotion__c,
                ASI_CRM_Offer_Accepted__c, ASI_CRM_Supplier__c, ASI_CRM_Supplier__r.Name,
                ASI_CRM_Unit__c, ASI_CRM_VisitationPlanDetail__c,
                ASI_CRM_VisitationPlanDetail__r.ASI_HK_CRM_Visitation_Plan__r.Name,
                ASI_CRM_VisitationPlanDetail__r.ASI_TH_CRM_Visit_Date_Time_From__c,
                ASI_CRM_VisitationPlanDetail__r.ASI_TH_CRM_Visit_Date_Time_To__c,
                ASI_CRM_Draft_Flag__c,
                ASI_CRM_Task__c, ASI_CRM_Done__c, ASI_CRM_Remarks__c
            FROM ASI_CRM_Promotion_Status__c
            WHERE ASI_CRM_Account__c = :idAcc
            //AND ASI_CRM_VisitationPlanDetail__c = :idVPID
            AND ASI_CRM_Promotion__r.ASI_HK_CRM_Promotion_Start_Date__c <= :dteDate
            AND ASI_CRM_Promotion__r.ASI_HK_CRM_Promotion_End_Date__c >= :dteDate
        ];
        system.debug(lstPromoStatusRec);
        
        for (ASI_CRM_Promotion_Status__c objPromoStatusRec : lstPromoStatusRec) {
            PromoStatus ps = new PromoStatus();
            
            ps.idRec = objPromoStatusRec.Id;
            ps.idPromo = objPromoStatusRec.ASI_CRM_Promotion__c;
            ps.strPromo = objPromoStatusRec.ASI_CRM_VisitationPlanDetail__r.ASI_HK_CRM_Visitation_Plan__r.Name;
            ps.strDesc = objPromoStatusRec.ASI_CRM_VisitationPlanDetail__r.ASI_HK_CRM_Visitation_Plan__r.Name;
            ps.dteStart = objPromoStatusRec.ASI_CRM_VisitationPlanDetail__r.ASI_TH_CRM_Visit_Date_Time_From__c;
            ps.dteEnd = objPromoStatusRec.ASI_CRM_VisitationPlanDetail__r.ASI_TH_CRM_Visit_Date_Time_To__c;
            //ps.dtePurchaseDue;
            ps.blnAccept = objPromoStatusRec.ASI_CRM_Offer_Accepted__c;
            ps.strPromoOpt = (ps.blnAccept) ? 'Y' : 'N';
            ps.decOfferUnit = objPromoStatusRec.ASI_CRM_Unit__c;
            ps.idSupplier= objPromoStatusRec.ASI_CRM_Supplier__c; //DEV
            ps.Supplier = new Account();
            ps.blnDraft = objPromoStatusRec.ASI_CRM_Draft_Flag__c;
            ps.strTask = objPromoStatusRec.ASI_CRM_Task__c;
            ps.blnDone = objPromoStatusRec.ASI_CRM_Done__c;
            ps.strRemarks = objPromoStatusRec.ASI_CRM_Remarks__c;
            ps.blnNew = false;

            mapPromoStatus.put(ps.idRec, ps);
            idTempPromo.add(ps.idPromo);
        }
        system.debug(mapPromoStatus);
        
        // Dynamic generate Promotional Record
        List<ASI_HK_CRM_Promotion__c> lstPromo = [
            SELECT Id, Name,
                ASI_HK_CRM_Promotion_Name__c, ASI_HK_CRM_Promotion_Start_Date__c,
                ASI_HK_CRM_Promotion_End_Date__c, ASI_CRM_PurchaseDueDate__c
            FROM ASI_HK_CRM_Promotion__c
            WHERE ASI_HK_CRM_Promotion_Start_Date__c <= :dteDate
            AND ASI_HK_CRM_Promotion_End_Date__c >= :dteDate
            AND ASI_CRM_Channel__c includes (:strCh)
            AND (ASI_CRM_Region__c includes (:strRegion) or ASI_CRM_Region__c = NULL)
        ];        
        system.debug(lstPromo);
        
        //Modified by Twinkle(Introv) 20141211 - For Add/Remove on Page 3
        boolean checkExistOrNot;
        for (ASI_HK_CRM_Promotion__c p : lstPromo) {
            checkExistOrNot = false;
            PromoStatus ps = new PromoStatus();           
            if(mapPromoStatus != null && mapPromoStatus.size()>0){
                for (String key : mapPromoStatus.keySet()) {
                    PromoStatus records = mapPromoStatus.get(key);
                    if(records.idPromo == p.id){
                        checkExistOrNot = true;
                        ps = mapPromoStatus.get(records.idRec);     
                        
                        ps.strPromo = p.Name;
                        ps.strDesc = p.ASI_HK_CRM_Promotion_Name__c;
                        ps.dteStart = p.ASI_HK_CRM_Promotion_Start_Date__c;
                        ps.dteEnd = p.ASI_HK_CRM_Promotion_End_Date__c;
                        ps.dtePurchaseDue = p.ASI_CRM_PurchaseDueDate__c;
                        ps.blnDraft = true;
                        ps.strTask = 'Display Setup';
                    }
                }
            }
            if(checkExistOrNot == false){
                ps.idRec = '#'+String.valueof(index);
                ps.idPromo = p.Id;
                ps.strPromoOpt = 'N';
                ps.decOfferUnit = 0;
                ps.blnAccept = false;
                ps.strPromo = p.Name;               
                ps.strDesc = p.ASI_HK_CRM_Promotion_Name__c;
                ps.dteStart = p.ASI_HK_CRM_Promotion_Start_Date__c;
                ps.dteEnd = p.ASI_HK_CRM_Promotion_End_Date__c;
                ps.dtePurchaseDue = p.ASI_CRM_PurchaseDueDate__c;
                ps.blnDraft = true;
                ps.strTask = 'Display Setup';
                ps.blnNew = true;
            }

            index++;
            mapPromoStatus.put(ps.idRec, ps);
            idTempPromo.add(ps.idPromo);
        }
        system.debug(mapPromoStatus);
        //Modified by Twinkle(Introv) 20141211
        
        // Dynamic generate Promotional Detail Record
        List<ASI_HK_CRM_Promotion_Detail__c> lstPromoD = [
            SELECT ASI_HK_CRM_Promotion__r.Id, ASI_HK_CRM_Promotion__r.Name,
                ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_Name__c, ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_Start_Date__c,
                ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_End_Date__c, ASI_HK_CRM_Promotion__r.ASI_CRM_PurchaseDueDate__c
            FROM ASI_HK_CRM_Promotion_Detail__c
            WHERE ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_Start_Date__c <= :dteDate
            AND ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_End_Date__c >= :dteDate
            AND ASI_HK_CRM_Account__c = :idAcc
        ];
        system.debug(lstPromo);
        
        //Modified by Twinkle(Introv) 20141211 - For Add/Remove on Page 3
        for (ASI_HK_CRM_Promotion_Detail__c p : lstPromoD) {
            PromoStatus ps = new PromoStatus();
            if(mapPromoStatus != null && mapPromoStatus.size()>0){
                for (String key : mapPromoStatus.keySet()) {
                    PromoStatus records = mapPromoStatus.get(key);
                    if(records.idPromo == p.id){
                        ps = mapPromoStatus.get(records.idRec);    
                        
                        ps.strPromo = p.ASI_HK_CRM_Promotion__r.Name;
                        ps.strDesc = p.ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_Name__c;
                        ps.dteStart = p.ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_Start_Date__c;
                        ps.dteEnd = p.ASI_HK_CRM_Promotion__r.ASI_HK_CRM_Promotion_End_Date__c;
                        ps.dtePurchaseDue = p.ASI_HK_CRM_Promotion__r.ASI_CRM_PurchaseDueDate__c;
                        ps.blnDraft = true; 

                        mapPromoStatus.put(ps.idRec, ps);
                    }
                }
            }                
        }
        system.debug(mapPromoStatus);

        //Assign Attachment
        mapAttachment = new Map<ID, Attachment>([SELECT id, ParentId FROM Attachment WHERE ParentId in :idTempPromo]);
        
        if(mapAttachment != null && mapAttachment.size() > 0){
            for (Attachment attachment : mapAttachment.values()){
                for (String key : mapPromoStatus.keySet()) {
                    PromoStatus records = mapPromoStatus.get(key);
                    if(records.idPromo == attachment.ParentId){
                        PromoStatus ps = mapPromoStatus.get(records.idRec);                    
                        if (ps !=null && ps.idAttachment == null) {
                            ps.idAttachment = attachment.id;                               
                        }
                        mapPromoStatus.put(ps.idRec, ps);
                    }
                }
            }
        }
        
        system.debug(mapPromoStatus);
        if(mapPromoStatus != null && mapPromoStatus.size()>0)
            return mapPromoStatus.values();
        else 
            return null;
        //Modified by Twinkle(Introv) 20141211
    }
    
    /*** For GMA Page 4 */
    private List<GMARec> buildGMA(Id idAcc) {
        // Declaration
        Map<Id, GMARec> mapGMA = new Map<Id, GMARec>();
        
        // Dynamic generate Sales Movement Record
        List<ASI_KOR_GMA__c> lstGMA = [
            SELECT Id, ASI_KOR_Date__c,
                ASI_CRM_Sub_brand__c, ASI_CRM_Sub_brand__r.Name,
                ASI_KOR_Size_cl__c, ASI_KOR_Remarks__c,
                ASI_KOR_Importer_Name__c, ASI_KOR_Alcohol__c,
                ASI_KOR_Quantity_Btl__c, ASI_KOR_Estimated_Q_ty_of_GMA_Sales__c
            FROM ASI_KOR_GMA__c
            WHERE ASI_KOR_Venue__c = :idAcc
        ];
        for (ASI_KOR_GMA__c gma : lstGMA) {
            GMARec g = new GMARec();
            g.idRec = gma.Id;
            g.dteDate = gma.ASI_KOR_Date__c;
            g.idSubBrand = gma.ASI_CRM_Sub_brand__c;
            g.strSubBrand = gma.ASI_CRM_Sub_brand__r.Name;
            g.strSize = String.valueOf(gma.ASI_KOR_Size_cl__c);
            g.strDisplay = gma.ASI_KOR_Remarks__c;
            g.strImporter = gma.ASI_KOR_Importer_Name__c;
            g.decAlcholo = gma.ASI_KOR_Alcohol__c;
            g.decVol = gma.ASI_KOR_Quantity_Btl__c;
            g.decEstVol = gma.ASI_KOR_Estimated_Q_ty_of_GMA_Sales__c;
            
            mapGMA.put(g.idSubBrand, g);
        }
        return mapGMA.values();
    }
    
    /*** For Pass Order Page 5 */
    private List<PassOrder> buildPassOrder(Id idVPID) {
        // Declaration
        List<PassOrder> templistPassOrder = new List<PassOrder>();
        
        // Query Pass Order records
        for(ASI_CRM_Pass_Order__c order : [SELECT Id, Name, ASI_CRM_Account__c, ASI_CRM_Item_Group__c, ASI_CRM_Quantity_Btl_Box__c, 
                                           ASI_CRM_Remark__c, ASI_CRM_Supplier__c, ASI_CRM_Visitation_Plan_Detail__c
                                           FROM ASI_CRM_Pass_Order__c
                                           WHERE ASI_CRM_Visitation_Plan_Detail__c = :idVPID]){
                                           
            PassOrder tempObjPassOrder = new PassOrder();
            tempObjPassOrder.idRec = order.id;
            tempObjPassOrder.idVPD = order.ASI_CRM_Visitation_Plan_Detail__c;
            tempObjPassOrder.strName = order.Name;
            tempObjPassOrder.idItemGroup = order.ASI_CRM_Item_Group__c;
            tempObjPassOrder.decQuantity = order.ASI_CRM_Quantity_Btl_Box__c;
            tempObjPassOrder.idSupplier = order.ASI_CRM_Supplier__c;
            tempObjPassOrder.strRemark = order.ASI_CRM_Remark__c;
            
            templistPassOrder.add(tempObjPassOrder);
            index_PassOrder++;
        }
        
        return templistPassOrder;
    }

    /** Show error message */
    private void showPageMessage(ApexPages.Severity severity, String msg) {
        ApexPages.addMessage(new ApexPages.Message(severity, msg));
    }
    /** Show error message */
    private void showPageError(String msg) {
        showPageMessage(ApexPages.Severity.ERROR, msg);
    }
    
    /** Option list for Sales Movement Yes and No */
    public List<SelectOption> getSalesMovntOpt() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('N', 'No'));
        options.add(new SelectOption('Y', 'Yes'));
        return options;
    }
    
    /** Option list for Promotion Status Yes and No */
    public List<SelectOption> getPromoOpt() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('N', 'No'));
        options.add(new SelectOption('Y', 'Yes'));
        return options;
    }

    public PageReference mktSurveyPage() {
        PageReference p = Page.ASI_CRM_TW_MarketSurvey_Page;
        p.getParameters().put('accountId', String.valueOf(objAccount.Id));
        p.getParameters().put('channelCode', String.valueOf(strChannelCode));
        return p;
    }
    
    /*public Decimal calculateDistance(Decimal lat1, Decimal lon1, Decimal lat2,   Decimal lon2){
        Double Radius = 6371.00;
        Double dLat = toRadians(lat2-lat1);
        Double dLon = toRadians(lon2-lon1);
        Double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(toRadians(lat1)) *   Math.cos(toRadians(lat2)) *
        Math.sin(dLon/2) * Math.sin(dLon/2);
        Double c = 2 * Math.asin(Math.sqrt(a));
        return Radius * c * .62;
    }

    private Double toRadians(Decimal degree){
       Double res = degree * 3.1415926 / 180;
       return res;
    }*/

    @RemoteAction
    public static String insertAttachment(String strParentID, String attachmentBody, String attachmentName, String pType, String attachmentId) {
    
        if(attachmentBody != null) {
            Attachment att = getAttachment(attachmentId);
            String newBody = '';
            if(att.Body != null) {
                newBody = EncodingUtil.base64Encode(att.Body);
            }
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            if(attachmentId == null) {
                Integer intSeq = 0;
                String strFName = '';
                List<Attachment> lstAtt = new List<Attachment>();
                
                String str15ID = strParentID;
                if (str15ID.length() == 18)
                    str15ID = str15ID.substring(1, 15);
                
                if (pType == null || pType == '' || pType == '1') {
                    pType = '1';
                    lstAtt = [SELECT Id, Name FROM Attachment WHERE ParentId = :strParentID AND Name LIKE '%General%' ORDER BY Name DESC LIMIT 1 ];
                } else if (pType == '2') {
                    lstAtt = [SELECT Id, Name FROM Attachment WHERE ParentId = :strParentID AND Name LIKE '%Merchan%' ORDER BY Name DESC LIMIT 1 ];
                } else if (pType == '3') {
                    lstAtt = [SELECT Id, Name FROM Attachment WHERE ParentId = :strParentID AND Name LIKE '%GMA%' ORDER BY Name DESC LIMIT 1 ];
                } else if (pType == '31' || pType == '32' || pType == '33' || pType == '34') {
                    lstAtt = [SELECT Id, Name FROM Attachment WHERE ParentId = :strParentID AND Name LIKE '%PromoStatus%' ORDER BY Name DESC LIMIT 1 ];
                }
                
                if (lstAtt != null && lstAtt.size() > 0) {
                    strFName = lstAtt[0].Name;
                    String[] arrToken = strFName.split('\\.', 2);
                    if (arrToken != null && arrToken.size() > 0) {
                        String strTemp = '';
                        if (pType == '1') strTemp = arrToken[0].replace('General_', '');
                        if (pType == '2') strTemp = arrToken[0].replace('Merchan_', '');
                        if (pType == '3') strTemp = arrToken[0].replace('GMA_', '');
                        if (pType == '31' || pType == '32' || pType == '33' || pType == '34') strTemp = arrToken[0].replace('PromoStatus_', '');
                        intSeq = Integer.valueOf(strTemp);
                    }
                }

                intSeq++;
                String[] arrToken = attachmentName.split('\\.', 2);
                if (arrToken != null && arrToken.size() >= 2) {
                    strFName = '.' + arrToken[1];
                }
                if (pType == '1') strFName = 'General_' + ASI_CRM_TW_SalesCallPlanPageNewCtrl.fileSeq(intSeq) + strFName;
                if (pType == '2') strFName = 'Merchan_' + ASI_CRM_TW_SalesCallPlanPageNewCtrl.fileSeq(intSeq) + strFName;
                if (pType == '3') strFName = 'GMA_' + ASI_CRM_TW_SalesCallPlanPageNewCtrl.fileSeq(intSeq) + strFName;
                if (pType == '31' || pType == '32' || pType == '33' || pType == '34') strFName = 'PromoStatus_' + ASI_CRM_TW_SalesCallPlanPageCtrl.fileSeq(intSeq) + strFName;

                if (strFName == null || strFName == '')
                    strFName = 'noname';
                
                att.Name = strFName;
                att.parentId = strParentID;
            }
            upsert att;
            return att.Id;
        } else {
            return 'Attachment Body was null';
        }
    }
    
    public static String fileSeq(Integer i) {
        String strTemp = String.valueOf(i);
        
        if (strTemp == null) return '';
        if (strTemp.length() == 1) return '0000' + String.valueOf(i);
        if (strTemp.length() == 2) return '000' + String.valueOf(i);
        if (strTemp.length() == 3) return '00' + String.valueOf(i);
        if (strTemp.length() == 4) return '0' + String.valueOf(i);
        return strTemp;
    }
    
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
    //Added by Twinkle(Introv) @20150428, for outlet image setup
    public PageReference outletImageSetup() {
        ASI_CRM_Pros_Segmentation__c prosSeg = new ASI_CRM_Pros_Segmentation__c();
        if(idAcc != NULL)
            prosSeg = [SELECT id FROM ASI_CRM_Pros_Segmentation__c WHERE ASI_CRM_SG_Account__c=:idAcc limit 1];        
        
        PageReference redirectPage;
        if(prosSeg != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Testing'));
            redirectPage = new PageReference('/apex/ASI_CRM_TW_CriteriaSheet?id='+prosSeg.id+'&type=1');
            redirectPage.setRedirect(true);
        }
        return redirectPage;
    }
}