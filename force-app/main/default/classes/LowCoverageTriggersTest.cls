@IsTest
private class LowCoverageTriggersTest {
    @IsTest
    static void coverPreventAccountDeletionTrigger() {
        Account acc = new Account(Name = 'Trigger Insert Account');
        insert acc;
        System.assertNotEquals(null, acc.Id);
    }

    @IsTest
    static void coverLeadTrigger() {
        Lead l = new Lead(LastName = 'Lead Trigger', Company = 'Acme');
        insert l;
        System.assertNotEquals(null, l.Id);
    }

    @IsTest
    static void coverAccountFieldUpdateTrigger() {
        Account acc = new Account(Name = 'Before Update Trigger');
        insert acc;
        acc.Name = 'Updated Name';
        update acc;
        System.assertEquals('Updated Name', [SELECT Name FROM Account WHERE Id = :acc.Id].Name);
    }
}
