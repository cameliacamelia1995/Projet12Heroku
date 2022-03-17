@IsTest
public with sharing class AccRequest_Tests {
    @IsTest
    public static void verifyIdReturn() {
        //Cette méthode permet de vérifier si l'ID est bien retourné 
        // On crée un ID du compte pour le test
        Id acctsId = AccRequest.createAccount('TestingName');
        // Verify results
        System.assert(acctsId != null);
       Account acct = [SELECT Id, Name FROM Account WHERE Id=:acctsId];
        System.assert(acct != null);
        System.assertEquals(acct.Name, 'TestingName');
        
    }
    @IsTest
    public static void verifyGetId(){
        Account myAccts = new Account(Name = 'TestingAccount');
        insert myAccts;
        Account acctsId = [SELECT Id, Name FROM Account WHERE Id =:myAccts.Id LIMIT 1];
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://wise-panda-uks57h-dev-ed.lightning.force.com/services/apexrest/Account/'
            + acctsId.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Id thisAccts = AccRequest.getAccount();
        // Verify results
        System.assert(thisAccts != null);
        System.assertEquals(thisAccts, myAccts.Id);
    }
}