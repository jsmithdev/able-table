public without sharing class ProfileCard {
    
    @AuraEnabled(cacheable=true)
    public static Contact getContactByUserId(String userId) {

        String contactId = ProfileCard.getContactIdByUserId(userId);
        
        List<Contact> c = [
            SELECT Id, Name, FirstName, LastName, Email, AccountId
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
        ];

        return c.size() > 0 ? c[0] : null;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getPhotoUrl(String userId) {
        
        // ProfileCard.getPhotoUrl('0031w00000BGV5wAAH');
        List<ContentDocument> doc = [
            SELECT Id 
            FROM ContentDocument
            WHERE OwnerId = :userId
            ORDER By CreatedDate DESC
            LIMIT 1
        ];

        if(doc.size() > 0){
            return URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + 
                [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :doc[0].Id LIMIT 1].Id;
        }
        else {
            return '';
        }
    }

    @AuraEnabled(cacheable=true)
    public static String cleanPhotos(String userId, String name) {
        
        
        // ProfileCard.getPhotoUrl('0031w00000BGV5wAAH');
        List<ContentDocument> doc = [
            SELECT Id 
            FROM ContentDocument
            WHERE OwnerId = :userId
            AND Title != :name
        ];
        
        delete doc;

        return 'cleaned up';
    }

    @AuraEnabled(cacheable=true)
    public static String getContactIdByUserId(String userId) {

        List<User> u = [
            SELECT ContactId
            FROM User
            WHERE Id = :userId
            LIMIT 1
        ];

        return u.size() > 0 ? u[0].ContactId : 'No User Found in ProfileCard.getContactIdByUserId';
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getCasesByUserId(String userId) {
        
        String contactId = ProfileCard.getContactIdByUserId(userId);

        List<Contact> con = [SELECT AccountId FROM Contact WHERE Id = :contactId LIMIT 1];

        String accId = con.size() > 0 ? con[0].AccountId : 'ProfileCard: No Contact Found.';

        return [
            SELECT Id, CaseNumber, Status, Subject                
            FROM Case
            WHERE ParentId = :contactId
            OR ParentId = :accId
        ];
    }
}

/* @AuraEnabled(cacheable=true)
public static Contact getContactById(String contactId) {
            
    return [

        SELECT Id, Name, FirstName, LastName, Email, AccountId
        FROM Contact
        WHERE Id = :contactId
    ];
} */