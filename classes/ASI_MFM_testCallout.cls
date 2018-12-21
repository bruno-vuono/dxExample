public class ASI_MFM_testCallout {
    public static void deletePlan(string planId) {
        ASI_MFM_DWInterface.DWInterfaceSoap dwi = new ASI_MFM_DWInterface.DWInterfaceSoap();
        dwi.timeout_x = 2000;
        ASI_MFM_DWInterface.WSResult resp = dwi.deletePlan(planId);
        system.debug(resp.succeed);
        system.debug(resp.message);
    }
}