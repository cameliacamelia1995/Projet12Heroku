@RestResource(urlMapping='/Contact/*')
global with sharing class ContactRequest {
    //Url va permettre de trouver les infos dans postman & l'appli
    //Crée un contact 
    //Mettre a jour un contact
    //Supprimer un contact
    //On oublie pas de déclarer l'ID dans la méthode
    @HttpPost
    global static Id createdContact(String FirstNameContact, String LastNameContact, String EmailContact, String PasswordContact) {
        //On vérifie que le mail n'existe pas déjà 
        List<Contact> VerifyMailContact = [SELECT Id FROM Contact WHERE Email =: EmailContact];
        //Si le contact exite déjà on retourne son ID
        if(VerifyMailContact.size() > 0) {
          return VerifyMailContact[0].Id;
        }
        else {
            Contact insertedContact = new Contact(FirstName = FirstNameContact, LastName = LastNameContact, Email = EmailContact, Password__c = PasswordContact);
            insert insertedContact;
            return insertedContact.Id;
        }
    }
    @HttpDelete 
    global static Id desactivedContact() {
            RestRequest request = RestContext.request;
            String contactId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
          Contact thisContact = [SELECT Id, Status__c FROM Contact WHERE Id =:contactId];
          thisContact.Status__c = 'Desactivated';
          update thisContact;
          return thisContact.Id;
    }
    @HttpPatch
    global static Id updateContact() {
            RestRequest request = RestContext.request;
            String contactId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
                Contact thisContact = [SELECT Id, Email, Password__c FROM Contact WHERE Id = :contactId];
            // Deserialize the JSON string into name-value pairs
            //Les champs seront liés a leur valeur en string avec cette map
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                // Set the field and value on the Case sObject
                thisContact.put(fieldName, params.get(fieldName));
                if(fieldName == 'Email'){
                    String MailField = (String)thisContact.get('Email');
                    MailField = (String)params.get(fieldName);
                }
                if(fieldName == 'Password__c'){
                  String Password = (String)thisContact.get('Password__c');
                  Password = (String)params.get(fieldName);
                }
            }
            update thisContact;
           return thisContact.Id;
    }
}