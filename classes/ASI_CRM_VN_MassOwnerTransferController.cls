/***************************************************************************************************************************
 * Name:        ASI_CRM_VN_MassOwnerTransferController
 * Description:  class for ASI_CRM_VN_MassOwnerTransfer VF page
 *
 * Version History
 * Date             Developer               Comments
 * ---------------  --------------------    --------------------------------------------------------------------------------
 * 2018-01-12       Jeffrey Cheung          Created
 ****************************************************************************************************************************/

public without sharing class ASI_CRM_VN_MassOwnerTransferController {
    public String selectedOutletType { get; set; }
    public String selectedOutletSubType { get; set; }
    public String selectedPROSImage { get; set; }
    public String selectedOutletOwner { get; set; }
    public String selectedArea { get; set; }
    public String selectedProvince { get; set; }
    public String selectedDistrict { get; set; }
    public String filteredOutletsJSON { get; set; }

    public List<SelectOption> getOutletTypes() {
        return getSelectOptions('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_VN_OutletType__c');
    }
    public List<SelectOption> getOutletSubtypes() {
        return getSelectOptions('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_Outlet_Sub_Type__c');
    }
    public List<SelectOption> getPROSImages() {
        return getSelectOptions('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_Check_Image__c');
    }
    public List<SelectOption> getOutletOwners() {
        Id currentUserId = UserInfo.getUserId();
        List<User> users = [SELECT Id, Name FROM User WHERE Profile.Name = 'ASI VN Standard User' AND managerId = :currentUserId ORDER BY Name];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select --'));

        for (User user : users) {
            options.add(new SelectOption(user.Id, user.Name));
        }
        return options;
    }
    public List<SelectOption> getAreas() {
        return getSelectOptions('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_Area__c');
    }
    public List<SelectOption> getProvinces() {
        return getSelectOptions('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_VN_Province__c');
    }
    public List<SelectOption> getDistricts() {
        return getSelectOptions('ASI_CRM_AccountsAdditionalField__c', 'ASI_CRM_VN_Quan__c');
    }
    public List<SelectOption> getNewOutletOwners() {
        List<User> users = [SELECT Id, Name FROM User WHERE Profile.Name = 'ASI VN Standard User' ORDER BY Name];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select --'));

        for (User user : users) {
            options.add(new SelectOption(user.Id, user.Name));
        }
        return options;
    }

    public List<SelectOption> getSelectOptions(String objectName, String fieldName) {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select --'));
        //        Copy from https://th3silverlining.com/2012/02/01/salesforce-dynamically-determining-the-field-type-of-a-dynamically-determined-sobject/
        Schema.SObjectType t = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult r = t.getDescribe();
        Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = f.getPicklistValues();

        for (Schema.PicklistEntry picklistEntry : ple) {
            options.add(new SelectOption(picklistEntry.getValue(), picklistEntry.getLabel()));
        }
        options.sort();
        return options;
    }

    public void searchOutlet() {
        List<String> recordTypes = new List<String>{
                'ASI_CRM_VN_Outlet', 'ASI_CRM_VN_Off_Trade_Outlet'
        };

        Id ownerId = UserInfo.getUserId();
       	Set<Id> ownerIdSet = new Set<Id>();
        ownerIdSet.add(ownerId);
        for(User u : [SELECT Id FROM User WHERE ManagerId = :ownerId]) {
            ownerIdSet.add(u.Id);
        }
        
        String query = 'SELECT ' +
                'Id, Name, ASI_CRM_CustomerCode__c, ASI_CRM_VN_Region__c, ASI_CRM_Area__c, ASI_CRM_VN_Province__c, ASI_CRM_VN_OutletType__c, ASI_CRM_VN_Is_Locked__c, RecordType.Name, Owner.Name ' +
                'FROM ASI_CRM_AccountsAdditionalField__c ' +
                'WHERE RecordType.DeveloperName IN :recordTypes ' + 
                'AND OwnerId in :ownerIdSet ';

        if (String.isNotEmpty(selectedOutletType)) {
            query += 'AND ASI_CRM_VN_OutletType__c = :selectedOutletType ';
        }
        if (String.isNotEmpty(selectedOutletSubType)) {
            query += 'AND ASI_CRM_Outlet_Sub_Type__c = :selectedOutletSubType ';
        }
        if (String.isNotEmpty(selectedPROSImage)) {
            query += 'AND ASI_CRM_Check_Image__c = :selectedPROSImage ';
        }
        if (String.isNotEmpty(selectedOutletOwner)) {
            query += 'AND OwnerId = :selectedOutletOwner ';
        }
        if (String.isNotEmpty(selectedArea)) {
            query += 'AND ASI_CRM_Area__c = :selectedArea ';
        }
        if (String.isNotEmpty(selectedProvince)) {
            query += 'AND ASI_CRM_VN_Province__c = :selectedProvince ';
        }
        if (String.isNotEmpty(selectedDistrict)) {
            query += 'AND ASI_CRM_VN_OutletType__c = :selectedDistrict ';
        }
        query += 'LIMIT 500 ';

        List<ASI_CRM_AccountsAdditionalField__c> outlets = Database.query(query);
        this.filteredOutletsJSON = JSON.serialize(outlets);
    }

    public void resetFilter() {
        selectedOutletType = '';
        selectedOutletSubType = '';
        selectedPROSImage = '';
        selectedOutletOwner = '';
        selectedArea = '';
        selectedProvince = '';
        selectedDistrict = '';
    }

    @RemoteAction
    public static String changeOwner(Id newOwnerId, String selectedOutlets) {

        List<ASI_CRM_AccountsAdditionalField__c> selectedOutletsList = (List<ASI_CRM_AccountsAdditionalField__c>) JSON.deserialize(selectedOutlets, List<ASI_CRM_AccountsAdditionalField__c>.class);
        List<ASI_CRM_AccountsAdditionalField__c> childOutletList = new List<ASI_CRM_AccountsAdditionalField__c>();

        Set<Id> selectedOutletIds = ASI_CRM_VN_Util_Pluck.ids(selectedOutletsList);

        //        change outlet owner
        ASI_CRM_VN_OutletHierarchy cls = new ASI_CRM_VN_OutletHierarchy(selectedOutletsList);
        for (ASI_CRM_AccountsAdditionalField__c outlet : selectedOutletsList) {
            outlet.OwnerId = newOwnerId;
            //          update  child outlets
            for (ASI_CRM_AccountsAdditionalField__c childOutlet : cls.getAllOutlet(outlet.Id)) {
                childOutlet.OwnerId = newOwnerId;
                childOutletList.add(childOutlet);
            }

        }


        //        change contract owner
        List<ASI_CRM_VN_Contract__c> contracts = [SELECT Id, Name, OwnerId, ASI_CRM_Contract_Status__c, ASI_CRM_Outlet_WS__r.Name FROM ASI_CRM_VN_Contract__c WHERE ASI_CRM_Outlet_WS__c IN :selectedOutletIds];
        for (ASI_CRM_VN_Contract__c contract : contracts) {
            contract.OwnerId = newOwnerId;
        }

        //        change Gift Box/POSM Request owner
        List<ASI_GiftBox_Request_Header__c> requests = [SELECT Id, Name, OwnerId, ASI_GiftBox_Status__c, ASI_CRM_Customer__r.Name FROM ASI_GiftBox_Request_Header__c WHERE ASI_CRM_Customer__c IN :selectedOutletIds];
        for (ASI_GiftBox_Request_Header__c request : requests) {
            request.OwnerId = newOwnerId;
        }

        List<String> lockedRecordIds = new List<String>();

        for (ASI_CRM_AccountsAdditionalField__c outlet : selectedOutletsList) {
            if (outlet.ASI_CRM_VN_Is_Locked__c && 
                (outlet.RecordType.Name == 'Outlet (VN) - Inactive' || outlet.RecordType.Name == 'VN Inactive Off-Trade Outlet')) {
                lockedRecordIds.add(outlet.Name);
            }
        }
        for (ASI_CRM_AccountsAdditionalField__c childOutlet : childOutletList) {
            if (childOutlet.ASI_CRM_VN_Is_Locked__c && 
                (childOutlet.RecordType.Name == 'Outlet (VN) - Inactive' || childOutlet.RecordType.Name == 'VN Inactive Off-Trade Outlet')) {
                lockedRecordIds.add(childOutlet.Name);
            }
        }

        // can transfer if contract is Draft/Approved/Closed
        Set<String> transferableContractStatus = new Set<String>{
                'Draft', 'Approved', 'Closed'
        };
        List<String> lockedContractIds = new List<String>();
        for (ASI_CRM_VN_Contract__c contract : contracts) {
            if (!transferableContractStatus.contains(contract.ASI_CRM_Contract_Status__c)) {
                lockedContractIds.add(contract.Name + '(' + contract.ASI_CRM_Outlet_WS__r.Name +')');
            }
        }

        // can transfer if request is Open/Complete
        Set<String> transferableRequestStatus = new Set<String>{
                'Open', 'Complete'
        };
        List<String> lockedRequestIds = new List<String>();
        for (ASI_GiftBox_Request_Header__c request : requests) {
            if (!transferableRequestStatus.contains(request.ASI_GiftBox_Status__c)) {
                lockedRequestIds.add(request.Name + '(' + request.ASI_CRM_Customer__r.Name +')');
            }
        }


        if (!lockedRecordIds.isEmpty() || !lockedContractIds.isEmpty() || !lockedRequestIds.isEmpty()) {
            DmlException e = new DmlException();
            String msg = 'Transfer failed. <br>';
            if (!lockedRecordIds.isEmpty()) {
                msg += 'The following outlets are locked: ' + String.join(lockedRecordIds, ', ') + '. <br>';
            }
            if (!lockedContractIds.isEmpty()) {
                msg += 'The following contracts are during Approval Process: ' + String.join(lockedContractIds, ', ') + '. <br>';
            }
            if (!lockedRequestIds.isEmpty()) {
                msg += 'The following requests are during Approval Process: ' + String.join(lockedRequestIds, ', ') + '. <br>';
            }
            e.setMessage(msg);
            throw e;
        }

        //        call DML
        update selectedOutletsList;
        update childOutletList;
        update contracts;
        update requests;

        return '';
    }

}