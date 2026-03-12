/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : PortfolioController
 * Author          : <YourName>
 * Created Date    : Mar 1, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Mar 1, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Mar 1, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public with sharing class PortfolioController {

    @AuraEnabled(cacheable=true)
    public static List<Experience__c> getExperiences() {
        return [
            SELECT Id, Name, Company__c, Role__c, Domain__c
            FROM Experience__c
            ORDER BY Start_Date__c DESC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        return [
            SELECT Id, Name, Type__c, Technologies__c
            FROM Project__c
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Certification__c> getCertifications() {
        return [
            SELECT Id, Name, Issued_By__c, Category__c
            FROM Certification__c
        ];
    }
}