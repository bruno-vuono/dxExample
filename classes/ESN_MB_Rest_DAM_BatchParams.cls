global class ESN_MB_Rest_DAM_BatchParams {
	global List<String> listDamIdToSync;
	global Integer currentRange;
    global Integer maxRange;
    global String brandId;
    global Datetime startDate;
    global Datetime endDate;
    global List<String> session;
    
    global ESN_MB_Rest_DAM_BatchParams(String brandId) {
        System.debug('Constructor (String brandId). Param=' + brandId);
        this.brandId = brandId;
    }
    global ESN_MB_Rest_DAM_BatchParams(List<String> listDamIdToSync) {
        System.debug('Constructor (List<String> listDamIdToSync). Param=' + listDamIdToSync);
        this.listDamIdToSync = listDamIdToSync;
    }

    // Execute batch for all assets modified between startDate and endDate in a range for a brand
    global ESN_MB_Rest_DAM_BatchParams(Integer currentRange, Integer maxRange, String brandId, Datetime startDate, Datetime endDate, List<String> session, List<String> listDamIdToSync) {
        this.currentRange = currentRange;
        this.maxRange = maxRange;
        this.brandId = brandId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.session = session;
        this.listDamIdToSync = listDamIdToSync;

    }

}