public class MMPJ_Ext_Vign_FileSharing {
    //@future
    public static void insertDocument(String sObjectName, Id entityId, Id docId)
    {
        system.debug('FileSharing : updateDocument: DEB');
        system.debug('FileSharing : sObjectName:' + sObjectName + ' IdentityId:' + entityId + ' docId:'+ docId);
        List<ContentVersion> myContentVersion = [SELECT Id, Title, ContentDocument.FileExtension FROM ContentVersion WHERE ContentDocumentId =:docId  ];
        system.debug('FileSharing : link.size():' + myContentVersion.size() );
        if(myContentVersion.size() == 1)
        {
                System.debug('#####ContentVersion Id = ' + myContentVersion[0].Id);
                ContentDistribution cd = new ContentDistribution();
                System.debug('###contentTitle='+myContentVersion[0].Title);
                cd.name = myContentVersion[0].Title + '.' + myContentVersion[0].ContentDocument.FileExtension;
                cd.ContentVersionId = myContentVersion[0].Id;
                cd.PreferencesAllowOriginalDownload = true;
                cd.PreferencesAllowPDFDownload = false;
                cd.PreferencesAllowViewInBrowser = true;
                insert cd;
                
               /* String url = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE ID = :cd.Id].DistributionPublicUrl;
                System.debug('##### URL Distribution = ' + url);
                system.debug('FileSharing : sObjectName: ' + sObjectName);
                sObject record = Schema.getGlobalDescribe().get(sObjectName).newSObject();
                record.Id = entityId;
                record.put('MMPJ_Ext_Vign_Lien_Public__c',url);
                update record;*/

                String url = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE ID = :cd.Id].DistributionPublicUrl;
                System.debug('##### URL Distribution = ' + url);
                system.debug('FileSharing : sObjectName: ' + sObjectName);
                sObject record = Schema.getGlobalDescribe().get(sObjectName).newSObject();
                record.Id = entityId;

                Id orgId = UserInfo.getOrganizationId();
                Id contentVersionId = myContentVersion[0].Id;

                String urlsuffix = url.split('sfc/p/')[1];
                urlsuffix = urlsuffix.substring(12);

                String urlprefix = System.URL.getSalesforceBaseURL().getHost();
                System.debug('### instance host=' + urlprefix);
                String orgName = [SELECT InstanceName FROM Organization LIMIT 1].InstanceName;
                urlprefix = 'https://' + urlprefix.split('\\.')[0] + '--c.' + orgName + '.content.force.com/sfc/dist/version/download/?';
                System.debug('### url prefix=' + urlprefix);

                String fullURL =urlprefix + 'oid=' + orgId + '&ids=' + contentVersionId + '&d=' + urlsuffix;
                System.debug('### url generated=' + fullURL);
                record.put('MMPJ_Ext_Vign_Lien_Public__c',fullURL);
                update record;
            }
        system.debug('FileSharing : updateDocument: FIN');
    }
}