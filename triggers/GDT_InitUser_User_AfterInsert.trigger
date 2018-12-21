/*
+-----------------------+------------------------------------------------------------------------------------+
| Author                | Sophie DUCATEL / Simon GAZIN                                                                   
+-----------------------+------------------------------------------------------------------------------------+
| Description           | GDT                                                                                
|                       |                                                                                    
|     - Object(s)       | User                                                                               
|     - Description     | automatically add Permission sets to a new user                                   
+-----------------------+------------------------------------------------------------------------------------+
| Creation Date         | 01/06/2015                                                                        
+-----------------------+------------------------------------------------------------------------------------+
| Modifications         |                                                                                    
+-----------------------+------------------------------------------------------------------------------------+
| Governor informations |                                                                                    
+-----------------------+------------------------------------------------------------------------------------+
*/
trigger GDT_InitUser_User_AfterInsert on User (after insert) {

	// isRunningTest() - Returns true if the currently executing code was called by code contained in a test method, false otherwise.    
	if(!Test.isRunningTest()){
		if(System.Label.GDT_InitUser_isActive == 'true') {
			System.debug('trigger GDT_InitUser_User_AfterInsert'); 
			GDT_InitUser_Class UserNew = new GDT_InitUser_Class();
			UserNew.InitUserAfter(trigger.new[0]);
		}
	}
}