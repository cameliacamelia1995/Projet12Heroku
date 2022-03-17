@RestResource(urlMapping='/Account/*')
//cette classe retourne l'ID d'un compte pour la création d'un contrat dans postman
global with sharing class AccRequest {
    @HttpGet
    global static Id getAccount() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String AccountId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);

        Account accts = [SELECT Id FROM Account WHERE Id =: AccountId];
        return accts.Id;
    }
    @HttpPost
    global static Id createAccount(String AccName){
        
        Account myAccts = new Account();
        myAccts.Name = AccName;
        insert myAccts;
        return myAccts.Id;
    }
}
