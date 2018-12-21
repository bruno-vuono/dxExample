public virtual with sharing class ASI_KOR_PromotionCalendarCommonClass {

	public static final String CALENDAR_TYPE_MONTH = 'month';
	public static final String CALENDAR_TYPE_YEAR = 'year';
	public static final List<SelectOption> CALENDAR_TYPES = new SelectOption[] {
		new SelectOption(CALENDAR_TYPE_MONTH, Label.ASI_KOR_VF_PROMOTION_MonthView)
		, new SelectOption(CALENDAR_TYPE_YEAR, Label.ASI_KOR_VF_PROMOTION_YearView)
	};
	
	public List<SelectOption> calendarViewTypeList { get { return CALENDAR_TYPES; } private set; }
	public String selectedCalendarType { get; set; }
	
	protected String pmtObjPrefix;
	protected String pmtObjLabel;
	
	protected ASI_KOR_PromotionCalendarCommonClass(String defaultCalendarType) {
		this.selectedCalendarType = defaultCalendarType;
		Schema.DescribeSObjectResult pmtType = Schema.SObjectType.ASI_KOR_Promotion__c;
		this.pmtObjPrefix = pmtType.getKeyPrefix();
		this.pmtObjLabel = pmtType.getLabel();
	}
	
	public PageReference redirectToAnotherCalendarType() {
		PageReference redirectPage = null;
		if (this.selectedCalendarType == CALENDAR_TYPE_MONTH) {
			redirectPage = Page.ASI_KOR_PromotionCalendarMonthPage;
		} else if (this.selectedCalendarType == CALENDAR_TYPE_YEAR) {
			redirectPage = Page.ASI_KOR_PromotionCalendarYearPage;
		}
		if (redirectPage != null)
			redirectPage.setRedirect(true);
		return redirectPage;
	}
	
	protected PageReference getRedirectToViewPage(String pmtId) {
		if (pmtId != null && pmtId.length() > 0) {
			ASI_KOR_Promotion__c pmt = new ASI_KOR_Promotion__c(Id = pmtId);
			PageReference redirectPage = new ApexPages.StandardController(pmt).view();
			return redirectPage;
		} else {
			//TODO: show error message
		}
		return null;
	}
	
	/*protected String removeParam(String theUrl, String paramName) {
		String result = theUrl;
		if (theUrl != null && paramName != null) {
			List<String> urlAndParamStr = theUrl.split('\\?');
			if (urlAndParamStr.size() > 1) {
				String urlStr = urlAndParamStr.remove(0);
				String paramStr = String.join(urlAndParamStr, '');
				Integer startIndex = paramStr.indexOf('?' + paramName + '=');
				Integer endIndex = -1;
				if (startIndex < 0 && paramStr.startsWith(paramName + '=')) startIndex = 0;
				if (startIndex >= 0) {
					endIndex = paramStr.indexOf('&', startIndex);
					if (endIndex < 0) endIndex = paramStr.length() - 1;
					result = urlStr
						+ (startIndex == 0 ? '' : paramStr.substring(0, startIndex))
						+ (endIndex == paramStr.length() ? '' : paramStr.substring(endIndex + 1, paramStr.length()));
				}
			}
		}
		return result;
	}
	
	protected String addParam(String theUrl, Map<String, String> params) {
		String result = theUrl;
		if (theUrl != null && params != null && params.size() > 0) {
			Integer questionMarkIndex = theUrl.indexOf('?');
			Boolean hasParam = false;
			if (questionMarkIndex > 0)
				hasParam = true;
			Set<String> paramNames = params.keySet();
			for (String paramName : paramNames) {
				result += (hasParam ? '&' : '?') + paramName + '=' + params.get(paramName);
				if (!hasParam) hasParam = true;
			}
		}
		return result;
	}*/
	
	protected Boolean isValidYear(String theYear) {
		if (theYear == null) {
			return false;
		} else {
			try {
				Integer theYearInt = Integer.valueOf(theYear);
				if (theYearInt / 100 <= 9 || theYearInt / 1000 >= 10) return false;
			} catch (TypeException te) {
				return false;
			}
		}
		return true;
	}
	
	protected Boolean isValidMonth(String theMonth) {
		if (theMonth == null) {
			return false;
		} else {
			try {
				Integer theMonthInt = Integer.valueOf(theMonth);
				if (theMonthInt < 0 || theMonthInt > 11) return false;
			} catch (TypeException te) {
				return false;
			}
		}
		return true;
	}
}