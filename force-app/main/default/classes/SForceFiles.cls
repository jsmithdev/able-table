public with sharing class SForceFiles {

    public String sessionId {
        get{ return UserInfo.getSessionId(); }
        set{}
    }

    public SForceFiles() { }
    
    @AuraEnabled
    public static String getSessionId() {
        return Page.SessionId.getContent().toString();
    }
    
    @AuraEnabled
    public static List<ContentVersion> getFiles( String recordId ){

        // get links
        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :recordId
        ];

        // get doc ids
        List<Id> docIds = new List<Id>();
        for( ContentDocumentLink link : links ){
            docIds.add( link.ContentDocumentId );
        }

        // get versions
        List<ContentVersion> versions = [
            SELECT Id, Title, PathOnClient, ContentDocumentId, ContentUrl,
                FileExtension, FileType, ContentSize, OwnerId, ContentModifiedDate
            FROM ContentVersion 
            WHERE ContentDocumentId IN :docIds
        ];//VersionData

        return versions;
    }

    @AuraEnabled
    public static String getDocId(String versionId) { 
        
        return [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :versionId LIMIT 1].ContentDocumentId;
    }

    @AuraEnabled
    public static String removeDoc(String docId) { 
        
        ContentDocument doc = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id = :docId 
            LIMIT 1
        ];

        delete doc;

        return 'Removed '+docId;
    }
}