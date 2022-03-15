@RestResource(urlMapping='/Contract/*')
global with sharing class ContracRequest {
    @HttpPost
    global static Id createdContract(Id idAcc, String StatusContract, Date dateStart, Integer termContract) {
        Contract myContract = new Contract(AccountId = idAcc, Status = StatusContract, StartDate = dateStart, ContractTerm = termContract);
        insert myContract;
        return myContract.Id;
    }
    @HttpPatch 
    global static Id updatedContract(){
        RestRequest request = RestContext.request;
            String contractId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/')+1);
                Contract thisContract = [SELECT Id, Status, ContractTerm FROM Contract WHERE Id = :contractId];
            // Deserialize the JSON string into name-value pairs
            //Les champs seront liés a leur valeur en string avec cette map
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
            // Iterate through each parameter field and value
            for(String fieldName : params.keySet()) {
                // Set the field and value on the Case sObject
                thisContract.put(fieldName, params.get(fieldName));
                //On assigne la nouvelle valeur au champs
                if(fieldName == 'Status'){
                    String StatusField = (String)thisContract.get('Status');
                    StatusField = (String)params.get(fieldName);
                }
                if(fieldName == 'ContractTerm'){
                  Integer term = Integer.valueOf((String)thisContract.get('ContractTerm'));
                 term = Integer.valueOf((String)params.get(fieldName));
                }
            }
            update thisContract;
           return thisContract.Id;
    }
}
