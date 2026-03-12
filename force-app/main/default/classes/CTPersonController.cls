public with sharing class CTPersonController {
    public Static String getToken(String Mobile) {
        Blob targetBlob = Blob.valueOf(Mobile);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        String result = EncodingUtil.base64Encode(hash);
        return result;

    }
    /**
     * Get 100 reconrds with recent health change
     * @return pList<person__c>
     */
    public Static List<Person__c> getRecentHealthChanges(String Mobile){
        List<Person__c> pList =[SELECT CreatedDate, CreatedById, Health_Status__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Mobile__c, Name, OwnerId, Status_Update_Date__c, SystemModstamp, Token__c FROM Person__c order by Status_Update_Date__c desc Nulls last limit 100];
        return pList;

    }
    public Static  List<Person__c> searchPeople(String peoples) {
        String people=peoples + '%';
        List<Person__c> pList =[SELECT CreatedDate, CreatedById, Health_Status__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Mobile__c, Name, OwnerId, Status_Update_Date__c, SystemModstamp, Token__c FROM Person__c where Name like :people or Mobile__c like :people or Token__c like :people order by Status_Update_Date__c desc Nulls last ];
        return pList;


        
    }
    public Static Person__c getPersonById(String personid){
       Person__c p =[SELECT CreatedDate, CreatedById, Health_Status__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Mobile__c, Name, OwnerId, Status_Update_Date__c, SystemModstamp, Token__c FROM Person__c where Id = :personid LIMIT 1];
       if(p!=NULL){
        return p;
       }
    
       return null;

    }


}