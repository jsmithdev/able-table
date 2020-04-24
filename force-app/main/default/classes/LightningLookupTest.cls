@isTest
public with sharing class LightningLookupTest {
    
    @isTest
    public static void search(){

        List<String> fieldArray = new List<String>{'Name', 'Phone'};

        String base = ' SELECT Id, Name, Phone FROM Account ';

        String query = 'bordercollies';

        LightningLookup.search(fieldArray, base, query);
    }
}