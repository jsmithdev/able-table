@isTest
public class ProfileCardTest {

    public static User createTestData(){
        
        Id pId = [SELECT Id FROM Profile WHERE Name = 'Customer Community'].Id;
        Id recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Customer' AND SObjectType = 'Account'].Id;

        Account ac = new Account(Name='TestAccount');  //, RecordTypeId = recTypeId
        insert ac;
        
        Contact con = new Contact(
            FirstName='Jamie',
            LastName='Smith',
            AccountId = ac.Id
        );
        insert con;

        User u = new User(Alias = 'jme', Email='jme@example.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = pId, 
            ContactId = con.Id,
            TimeZoneSidKey='America/New_York', UserName='commuser@example.com',IsActive = true);
        insert u;
        


        Case c = new Case();
        c.Subject = 'Subby';

        Case cc = new Case();
        cc.Subject = 'Subby Child';
        cc.ParentId = c.Id;

        return u;
    }

    @isTest
    private static User getAdmin(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User u = [SELECT Id, ContactId FROM User WHERE ProfileId = :p.Id AND isActive = true ORDER BY LastModifiedDate DESC LIMIT 1];

        return u;
    }

    @isTest
    public static void getContactByUserId(){

        User u = ProfileCardTest.getAdmin();

        Contact rc = ProfileCard.getContactByUserId(u.Id);

        System.debug('Tested getContactByUserId: '+rc);
    }

    @isTest
    public static void getPhotoUrl(){

        User u = ProfileCardTest.getAdmin();

        String result = ProfileCard.getPhotoUrl(u.Id);

        System.debug('Tested getPhotoUrl: '+result);
    }

    @isTest
    public static void getCasesByUserId(){
    
        User u = ProfileCardTest.createTestData();

        List<Case> results = ProfileCard.getCasesByUserId(u.Id);
    }

    @isTest
    public static void cleanPhotos(){
    
        User u = ProfileCardTest.createTestData();

        ProfileCard.cleanPhotos(u.Id, '');
    }
}