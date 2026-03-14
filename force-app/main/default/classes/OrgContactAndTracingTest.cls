@IsTest
private class OrgContactAndTracingTest {
    @IsTest
    static void accountContactService_and_contactHandler_areCovered() {
        Account acc1 = new Account(Name = 'Account One');
        Account acc2 = new Account(Name = 'Account Two');
        insert new List<Account>{ acc1, acc2 };

        Contact c1 = new Contact(LastName = 'One', AccountId = acc1.Id, Active__c = true);
        Contact c2 = new Contact(LastName = 'Two', AccountId = acc1.Id, Active__c = false);
        insert new List<Contact>{ c1, c2 };

        AccountContactService.updateActiveContacts(new Set<Id>{ acc1.Id, acc2.Id });
        Map<Id, Account> initialAccounts = new Map<Id, Account>([
            SELECT Active_Contacts__c
            FROM Account
            WHERE Id IN :new Set<Id>{ acc1.Id, acc2.Id }
        ]);
        System.assertEquals(1, initialAccounts.get(acc1.Id).Active_Contacts__c);
        System.assertEquals(0, initialAccounts.get(acc2.Id).Active_Contacts__c);

        ContactTriggerHandler.afterInsertHandler(new List<Contact>{ c1, c2 });

        Contact oldC1 = c1.clone(false, true, false, false);
        c1.Active__c = false;
        update c1;
        ContactTriggerHandler.afterUpdateHandler(
            new List<Contact>{ c1 },
            new Map<Id, Contact>{ c1.Id => oldC1 }
        );

        Contact oldC2 = c2.clone(false, true, false, false);
        c2.AccountId = acc2.Id;
        c2.Active__c = true;
        update c2;
        ContactTriggerHandler.afterUpdateHandler(
            new List<Contact>{ c2 },
            new Map<Id, Contact>{ c2.Id => oldC2 }
        );

        delete c2;
        ContactTriggerHandler.afterDeleteHandler(new List<Contact>{ c2 });
        undelete c2;
        c2 = [SELECT Id, AccountId FROM Contact WHERE Id = :c2.Id];
        ContactTriggerHandler.afterUndeleteHandler(new List<Contact>{ c2 });

        Map<Id, Account> finalAccounts = new Map<Id, Account>([
            SELECT Active_Contacts__c
            FROM Account
            WHERE Id IN :new Set<Id>{ acc1.Id, acc2.Id }
        ]);
        System.assertEquals(0, finalAccounts.get(acc1.Id).Active_Contacts__c);
        System.assertEquals(1, finalAccounts.get(acc2.Id).Active_Contacts__c);
    }

    @IsTest
    static void tracingAndControllerClasses_areCovered() {
        Person__c p1 = new Person__c(
            Name = 'Person One',
            Mobile__c = '9999999991',
            Token__c = 'tok1',
            Health_Status__c = 'Green',
            Status_Update_Date__c = Date.today()
        );
        Person__c p2 = new Person__c(
            Name = 'Person Two',
            Mobile__c = '9999999992',
            Token__c = 'tok2',
            Health_Status__c = 'Yellow',
            Status_Update_Date__c = Date.today().addDays(-1)
        );
        insert new List<Person__c>{ p1, p2 };

        Location__c loc1 = new Location__c(
            Name = 'Main Office',
            Address__c = 'Street 1',
            Pincode__c = '500001',
            Status__c = 'Green',
            Red_Score__c = 1,
            Status_Update_Date__c = Date.today()
        );
        Location__c loc2 = new Location__c(
            Name = 'Branch',
            Address__c = 'Street 2',
            Pincode__c = '500002',
            Status__c = 'Red',
            Red_Score__c = 4,
            Status_Update_Date__c = Date.today().addDays(-1)
        );
        insert new List<Location__c>{ loc1, loc2 };

        People_Tracing__c peopleTrace = new People_Tracing__c(
            Person_1__c = p1.Id,
            Person_2__c = p2.Id,
            Contact_Date__c = Date.today()
        );
        insert peopleTrace;

        Location_Tracing__c locationTrace = new Location_Tracing__c(
            Person__c = p1.Id,
            Location__c = loc1.Id,
            Visit_Date__c = Date.today()
        );
        Location_Tracing__c locationTrace2 = new Location_Tracing__c(
            Person__c = p2.Id,
            Location__c = loc2.Id,
            Visit_Date__c = Date.today()
        );
        insert new List<Location_Tracing__c>{ locationTrace, locationTrace2 };

        System.assertEquals(2, CTLocationController.getRecentStatusChanges().size());
        System.assertEquals(1, CTLocationController.searchLocations('Main').size());
        System.assertEquals(loc1.Id, CTLocationController.getLocationById(loc1.Id).Id);
        System.assertEquals(1, CTLocationController.getStatusCount().get('Green'));

        System.assertNotEquals(null, CTPersonController.getToken('9999999991'));
        System.assertEquals(2, CTPersonController.getRecentHealthChanges('ignored').size());
        System.assertEquals(1, CTPersonController.searchPeople('Person O').size());
        System.assertEquals(p1.Id, CTPersonController.getPersonById(p1.Id).Id);

        System.assertEquals(1, CTPeopleTracingController.getTraces(p1.Id).size());
        List<People_Tracing__c> duplicatePeople = CTPeopleTracingController.checkDuplicates(new List<People_Tracing__c>{
            new People_Tracing__c(Person_1__c = p1.Id, Person_2__c = p2.Id, Contact_Date__c = Date.today())
        });
        System.assertEquals(1, duplicatePeople.size());

        System.assertEquals(1, CTLocationTracingController.getVistors(loc1.Id).size());
        System.assertEquals(1, CTLocationTracingController.getLocationsByPersonIds(new Set<Id>{ p1.Id }).size());
        System.assertEquals(1, CTLocationTracingController.getLocationsByLocationIds(new Set<Id>{ loc1.Id }).size());
        List<Location_Tracing__c> duplicateLocations = CTLocationTracingController.checkDuplicates(new List<Location_Tracing__c>{
            new Location_Tracing__c(Person__c = p1.Id, Location__c = loc1.Id, Visit_Date__c = Date.today())
        });
        System.assertEquals(1, duplicateLocations.size());
    }
}
