@isTest
public with sharing class SForceFilesTest {
    
    @isTest
    public static void createData() {

        Id LinkedEntityId = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;

        ContentVersion cv = new ContentVersion(
            title = 'Test',
            PathOnClient = 'Test',
            VersionData = Blob.valueOf('Test')
        );
        insert cv;

        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1].ContentDocumentId;

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = LinkedEntityId,
            ContentDocumentId = docId,
            shareType = 'V'
        );
        insert cdl;
    }

    @isTest
    public static void test1(){

        SForceFilesTest.createData();

        Id LinkedEntityId = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].Id;

        Test.startTest();
        
        String up = SForceFiles.uploadFile(
            Blob.valueOf('Test'),
            'TestTitle',
            LinkedEntityId
        );

        System.assertEquals(up, 'Uploaded File');

        Test.stopTest();
    }
    /* 
    @isTest
    public static void AWS_S3Test1() {
        AWS_S3.getCreds();
    }
    */
}