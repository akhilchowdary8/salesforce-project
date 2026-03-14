@IsTest
private class OrgAsyncApexClassesTest {
    @IsTest
    static void batchClasses_areCovered() {
        Account accountRecord = new Account(Name = 'Async Account');
        insert accountRecord;

        Contact c1 = new Contact(LastName = 'Delete One', AccountId = accountRecord.Id);
        Contact c2 = new Contact(LastName = 'Delete Two', AccountId = accountRecord.Id);
        insert new List<Contact>{ c1, c2 };

        Lead leadRecord = new Lead(LastName = 'Lead One', Company = 'Acme');
        insert leadRecord;

        Test.startTest();
        Id batchJobId = Database.executeBatch(new BatchPractise(), 1);
        Test.stopTest();
        System.assertNotEquals(null, batchJobId);

        Lead updatedLead = [SELECT Email FROM Lead WHERE Id = :leadRecord.Id];
        System.assertEquals('batchpractice@example.com', updatedLead.Email);

        OpportunityDeletion deletionBatch = new OpportunityDeletion();
        Database.QueryLocator queryLocator = deletionBatch.start(null);
        System.assertNotEquals(null, queryLocator);
        deletionBatch.execute(null, [SELECT Id FROM Contact WHERE Id IN :new Set<Id>{ c1.Id, c2.Id }]);
        deletionBatch.finish(null);
        System.assertEquals(2, deletionBatch.countSuccess);
    }

    @IsTest
    static void queueableAndSchedulable_areCovered() {
        Account accountRecord = new Account(Name = 'Async Account Two');
        insert accountRecord;

        Contact c3 = new Contact(LastName = 'Queueable Delete', AccountId = accountRecord.Id);
        Contact c4 = new Contact(LastName = 'Schedule Delete', AccountId = accountRecord.Id);
        insert new List<Contact>{ c3, c4 };

        Test.startTest();
        new opportunityQueuable().execute(null);
        new OpportunitySchedulable().execute(null);
        Test.stopTest();

        Integer remainingContacts = [
            SELECT COUNT()
            FROM Contact
            WHERE Id IN :new Set<Id>{ c3.Id, c4.Id }
        ];
        System.assertEquals(0, remainingContacts);
    }
}
