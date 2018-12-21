global without sharing class ASI_TnE_KR_AnPSchd implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        Integer AnPRe1 = Integer.valueOf(ASI_KR_Schd_Setting__c.getValues('For AnP Reminder').ASI_KR_numOfDays1__c);
        Integer AnPRe2 = Integer.valueOf(ASI_KR_Schd_Setting__c.getValues('For AnP Reminder').ASI_KR_numOfDays2__c);
        if(ASI_KR_Schd_Setting__c.getValues('For AnP Reminder').ASI_KR_isActivate__c)
        	database.executebatch(new ASI_TnE_KR_remindAnP(AnPRe1,AnPRe2));
    }//end method: excute
}//end class