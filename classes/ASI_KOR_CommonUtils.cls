public with sharing class ASI_KOR_CommonUtils {
	
	public static String generateSeparatedStringWithQuote(List<String> strList, String delim, String quote) {
		String result = '';
		if (strList != null && strList.size() > 0) {
			result = String.join(strList, quote + delim + quote);
			result = quote + result + quote;
		}
		return result;
	}
}