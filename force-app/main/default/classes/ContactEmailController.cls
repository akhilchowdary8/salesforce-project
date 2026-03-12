public with sharing class ContactEmailController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchKey) {

        if(String.isBlank(searchKey)){
            return new List<Contact>();
        }

        String searchPattern = '%' + searchKey + '%';

        return [
            SELECT Id, Name, Email
            FROM Contact
            WHERE Name LIKE :searchPattern
            OR Email LIKE :searchPattern
            ORDER BY Name
            LIMIT 20
        ];
    }

    @AuraEnabled
    public static String sendEmails(List<Id> contactIds, String subject, String message){

        if(contactIds == null || contactIds.isEmpty()){
            throw new AuraHandledException('No contacts selected.');
        }

        if(String.isBlank(subject) || String.isBlank(message)){
            throw new AuraHandledException('Subject and Message are required.');
        }

        List<Contact> contacts = [
            SELECT Id, Email
            FROM Contact
            WHERE Id IN :contactIds
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Contact c : contacts){

            if(String.isBlank(c.Email)){
                continue;
            }

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new List<String>{c.Email});
            email.setSubject(subject);
            email.setPlainTextBody(message);

            emails.add(email);
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }

        return 'Emails sent successfully.';
    }
}