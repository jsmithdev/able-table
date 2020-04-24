public with sharing class AssetFiles {
    
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getFiles(String WORKSPACE_NAME){
        
        //get lib id
        ID workspaceId = [
            SELECT Id, Name, DeveloperName
            FROM ContentWorkspace 
            WHERE Name = :WORKSPACE_NAME
            LIMIT 1
        ].Id;

        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :workspaceId
        ];

        List <ContentVersion> allDocuments = [
            SELECT Id, Title, PathOnClient, ContentDocumentId, ContentUrl,
                FileExtension, FileType, ContentSize, OwnerId, ContentModifiedDate, VersionData
            FROM ContentVersion 
            WHERE ContentDocument.ParentId = :workspaceId
        ];

        // get doc ids
        List<Id> docIds = new List<Id>();
        for( ContentDocumentLink link : links ){
            docIds.add( link.ContentDocumentId );
        }

        return allDocuments;
    }
}