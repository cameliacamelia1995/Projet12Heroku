@IsTest
public with sharing class DataFactory {
    public static Id contactCreator() {
        // Create test record
        Contact contactTest = new Contact(FirstName='Eren', LastName='Yeager',Email='eren@rumbling.com',Phone='680-5142', Password__c='mikasa');
        insert contactTest;
        return contactTest.Id;
    }
    public static Id AccCreator() {
        Account newAcc = new Account(Name = 'Norman');
        insert newAcc;
        return newAcc.Id;
    }
}