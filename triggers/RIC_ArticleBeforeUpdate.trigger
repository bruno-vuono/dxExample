trigger RIC_ArticleBeforeUpdate on RIC_Article__c (before update) {
	
    RIC_AP01_RIC_Article.unlockRecordBeforeUpdate(trigger.new, trigger.OldMap);
    RIC_AP01_RIC_Article.updateTechChangedFiels(trigger.new, trigger.OldMap);
}