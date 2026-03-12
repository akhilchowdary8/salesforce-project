@IsTest
public class ContactEmailControllerTest {

    @TestSetup
    static void setup(){

        List<Contact> contacts = new List<Contact>();

        for(Integer i=0;i<5;i++){
            contacts.add(new Contact(
                LastName = 'Test ' + i,
                Email = 'test'+i+'@email.com'
            ));
        }

        insert contacts;
    }

    @IsTest
    static void testSearchContacts(){

        Test.startTest();

        List<Contact> results = ContactEmailController.searchContacts('Test');

        Test.stopTest();

        System.assert(results.size() > 0);
    }

    @IsTest
    static void testSendEmails(){

        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 2];

        List<Id> ids = new List<Id>();

        for(Contact c : contacts){
            ids.add(c.Id);
        }

        Test.startTest();

        String result = ContactEmailController.sendEmails(
            ids,
            'Test Subject',
            'Test Message'
        );

        Test.stopTest();

        System.assertEquals('Emails sent successfully.', result);
    }
}