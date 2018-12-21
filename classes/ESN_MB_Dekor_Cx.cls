public class ESN_MB_Dekor_Cx {
    public String getDekorURL(){
        String userId = UserInfo.getUserId();
        String auth = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf(userId + Label.ESN_MB_Dekor_Auth_Key)));
        String resultURL = Label.ESN_MB_Dekor_URL.replace('<firstname.lastname>', UserInfo.getFirstName() + '.' + UserInfo.getLastName())
        .replace('<userid>', userId)
        .replace('<auth>', auth);
        return resultURL;
    }
}