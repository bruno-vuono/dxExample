trigger RIC_ArticleAfterUpdate on RIC_Article__c (after update) {
  
    RIC_AP01_RIC_Article.notifyRTCAOnArticleUpdate(trigger.new, trigger.OldMap);
}