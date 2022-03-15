@RestResource(urlMapping='/Account/*')
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
}
