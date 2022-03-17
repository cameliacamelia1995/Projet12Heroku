@IsTest
public with sharing class ContractRequest_Test {
    @IsTest
    public static void verifyCreatedContract() {
        Id myAcc = DataFactory.AccCreator();
        Date newDate = Date.today();
        Id contractId = ContracRequest.createdContract(myAcc, 'Draft', newDate, 10);
        System.assert(contractId != null);
        Contract newContract = [SELECT Id, Status, ContractTerm, StartDate FROM Contract WHERE Id =: contractId];
        System.assertEquals(newContract.Status, 'Draft');
        System.assertEquals(newContract.ContractTerm, 10);
        System.assertEquals(newContract.StartDate, newDate);
    }
    @IsTest 
    public static void verifyUpdatedContract() {
        Id recordId = DataFactory.AccCreator();
        Date nDate = Date.parse('10/09/2022');
        Contract beforeUpdatedContract = new Contract(AccountId = recordId, Status = 'Draft', StartDate = nDate, ContractTerm = 5);
        insert beforeUpdatedContract;
        Contract myOldcontract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id =: beforeUpdatedContract.Id LIMIT 1];
        // Set up a test request
          //Simulation de la requête pour modifier les champs contacts
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://wise-panda-uks57h-dev-ed.lightning.force.com/services/apexrest/Contract/'
            + myOldcontract.Id;
        request.httpMethod = 'PATCH';
        Request.addHeader('Content-Type', 'Application/Json');
        request.requestBody = Blob.valueOf('{"Status": "Activated", "StartDate": "09/11/2022", "ContractTerm": "10"}');
        RestContext.request = request;
        Id contractId = ContracRequest.updatedContract();
        System.assert(contractId != null);
        Contract updatedContract = [SELECT Id, AccountId, Status, StartDate, ContractTerm FROM Contract WHERE Id =: contractId LIMIT 1];
        System.assertEquals(myOldcontract.Status, 'Draft');
        System.assertEquals(updatedContract.Status, 'Activated');
        System.assertEquals(updatedContract.ContractTerm, 10);
    }
}
