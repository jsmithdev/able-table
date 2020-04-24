public with sharing class LightningLookup {
        
    @AuraEnabled(cacheable=true)
    public static List<LightningLookupResult> search(String sObjectType, String query, String marker) {

        System.debug(sObjectType + ' '+ query +' '+ marker);

        Integer LMT = 3; // -1 for no limit
        
        if(sObjectType == ''){ return null; }
        
        String search = 'SELECT Name, Id FROM '+sObjectType;

        if(query == ''){
            // Set soql to get most recent
            search+= ' Order By LastModifiedDate DESC';
        }
        else {
            // Set soql to search, wildcard left, right or both
            String key = marker == 'left' 
                ? '%'+ query
                : marker == 'right'
                    ?  query +'%'
                    : '%'+ query +'%';
                    
            search+= ' WHERE Name LIKE :key ';
        }

        search += LMT > -1 ? ' LIMIT '+LMT+' ' : '';

        System.debug(search);

        List<sObject> data = Database.query( search );


        
        // Wrap results
        List<LightningLookupResult> results = new List<LightningLookupResult>();

        for (sObject obj : data) {

            String name = (String)obj.get('Name');
            
            results.add(new LightningLookupResult(obj.Id, name, sObjectType));
        }
        
        return results;
    }
    
    public class LightningLookupResult {

        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String sObjectType;

        public LightningLookupResult(Id id, String name, String sObjectType) {
            this.id = id;
            this.name = name;
            this.sObjectType = sObjectType;
        }
    }
}