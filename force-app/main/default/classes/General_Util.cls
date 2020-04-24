public class General_Util {

    // General_Util.setCasesToAnotherUser();
    
    @AuraEnabled
    public static string setCasesToAnotherUser(){

        User u = [SELECT ID FROM User WHERE Name = 'Integration User'];
        
        List<Case> cases = new List<Case>();
        
        for(Case cs : [SELECT ID, OwnerId FROM Case WHERE OwnerId != :u.Id]){
            cs.OwnerId = u.Id;
            cases.add(cs);
        }

        update cases;

        return 'Updated '+cases.size()+' cases!';
    }
}