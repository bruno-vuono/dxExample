global class LAT_CallOutMockTest implements WebServiceMock{
	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       //LAT_GetStock.port respElement = 
         //  new LAT_GetStock.port();
       	  LAT_GetStockTypes.GetStockResponse_element respElement = new LAT_GetStockTypes.GetStockResponse_element(); 
       	  String s = '';
       	  Map<String,LAT_GetStockTypes.GetStockResponse_element> res = new  Map<String,LAT_GetStockTypes.GetStockResponse_element>();
       		res.put(s,respElement);
       response.put('response_x', res); 
   }
}