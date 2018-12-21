/*
+-----------------------+------------------------------------------------------------------------------------+
| Author                | Sophie DUCATEL / Simon GAZIN                                                              
+-----------------------+------------------------------------------------------------------------------------+
| Description           | GDT                                                                                
|                       |                                                                                    
|     - Object(s)       | User                                                                               
|     - Description     | automatically add a Role a new user                                   
+-----------------------+------------------------------------------------------------------------------------+
| Creation Date         | 01/06/2015                                                                        
+-----------------------+------------------------------------------------------------------------------------+
| Modifications         |                                                                                    
+-----------------------+------------------------------------------------------------------------------------+
| Governor informations |                                                                                    
+-----------------------+------------------------------------------------------------------------------------+
*/
trigger GDT_InitUser_User_BeforeInsert on User (before insert) {
   
    // isRunningTest() - Returns true if the currently executing code was called by code contained in a test method, false otherwise.    
    if(!Test.isRunningTest()){
    	if(System.Label.GDT_InitUser_isActive == 'true') {
	        System.debug('trigger GDT_InitUser'); 
	        GDT_InitUser_Class UserNew = new GDT_InitUser_Class();
	        UserNew.InitUserBefore(trigger.new[0]);
	    }
    }  
}