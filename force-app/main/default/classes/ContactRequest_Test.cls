@IsTest
public with sharing class ContactRequest_Test {
    @IsTest
    public static void verifyContactCreated() {
        Id contactId = ContactRequest.createdContact('Ace', 'Roger', 'ace.roger@wano.com', 'onepiece');
        System.assert(contactId != null);
        Contact newContact = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact WHERE Id =: contactId];
        System.assert(newContact != null);
        System.assertEquals('Ace',newContact.FirstName);
        System.assertEquals('Roger', newContact.LastName);
    }
    @IsTest
    public static void verifyExistingContact(){
        Id contactId = DataFactory.contactCreator();
        Contact newC = [SELECT Id, Email, LastName FROM Contact WHERE Id =: contactId LIMIT 1];
        Id myNewContact = ContactRequest.createdContact('Eren','Yeager','eren@rumbling.com', 'mikasa');
        System.assert(myNewContact != null);
        Contact nc = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact WHERE Id =: myNewContact];
        System.assert(nc != null);
        System.assertEquals(nc.LastName, newC.LastName);
        System.assertEquals(nc.Email, newC.Email);
        System.assertEquals(nc.Id, newC.Id);
    }
    @IsTest
    public static void verifyDesactivatedContact(){
        Id recordId = DataFactory.contactCreator();
        Contact myNcontact = [SELECT Id, Status__c FROM Contact WHERE Id =: recordId LIMIT 1];
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://wise-panda-uks57h-dev-ed.lightning.force.com/services/apexrest/Contact/'
            + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        Id updateContact = ContactRequest.desactivedContact();
       Contact testContact = [SELECT Id, Status__c FROM Contact WHERE Id =: updateContact LIMIT 1];
        // Verify record is deleted
        System.assertNotEquals(myNcontact.Status__c, testContact.Status__c);
    }
    @IsTest
    public static void verifyUpdtatedContact(){
        Id recordId = DataFactory.contactCreator();
        Contact myNcontact = [SELECT Id, LastName, Email, Password__c FROM Contact WHERE Id =: recordId LIMIT 1];
        // Set up a test request
          //Simulation de la requête pour modifier les champs contacts
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://wise-panda-uks57h-dev-ed.lightning.force.com/services/apexrest/Contact/'
            + recordId;
        request.httpMethod = 'PATCH';
        Request.addHeader('Content-Type', 'Application/Json');
        request.requestBody = Blob.valueOf('{"LastName": "Yamato", "Email": "ace.y@onepiece.fr", "Password__c": "kaido"}');
        RestContext.request = request;
        Id contactId = ContactRequest.updateContact();
        System.assert(contactId != null);
        Contact updatedC = [SELECT Id, LastName, Email, Password__c FROM Contact WHERE Id =: contactId LIMIT 1];
        System.assert(updatedC != null);
        System.assertEquals(myNcontact.LastName, 'Yeager');
        System.assertEquals(updatedc.LastName, 'Yamato');
        System.assertNotEquals(myNcontact.Email, updatedC.Email);
        System.assertNotEquals(myNcontact.Password__c, updatedC.Password__c);
        System.assertEquals(myNcontact.Id, updatedC.Id);

    }
}