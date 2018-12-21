public with sharing virtual class ASI_KOR_AbstractPageController implements ASI_KOR_PageInterface {
	private static String DEF_CC_KEY = 'DEFAULT';
	private Map<String, ASI_KOR_ComponentInterface> componentControllerMap;
	public ASI_KOR_AbstractPageController thisController { get {return this;} set; }
	
	public ASI_KOR_AbstractPageController() {
		this.componentControllerMap = new Map<String, ASI_KOR_ComponentInterface>();
	}
	public void setComponentController(ASI_KOR_ComponentInterface cController) {
		this.componentControllerMap.put(DEF_CC_KEY, cController);
	}
	public void setComponentController(String key, ASI_KOR_ComponentInterface cController) {
		this.componentControllerMap.put(key, cController);
	}
	public ASI_KOR_ComponentInterface getComponentController() {
		return this.componentControllerMap.get(DEF_CC_KEY);
	}
	public ASI_KOR_ComponentInterface getComponentController(String key) {
		return this.componentControllerMap.get(key);
	}
	
}