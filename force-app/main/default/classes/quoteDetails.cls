/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : quoteDetails
 * Author          : <YourName>
 * Created Date    : Feb 20, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Feb 20, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Feb 20, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class quoteDetails {

	@AuraEnabled(cacheable=true)
	public static List<SBQQ__Quote__c> doSomething(Id quoteId) {
		List<SBQQ__Quote__c> newList=[select SBQQ__ListAmount__c,SBQQ__CustomerDiscount__c,SBQQ__NetAmount__c,SBQQ__Status__c from SBQQ__Quote__c where id=:quoteId limit 1];
		return newList;
		// Your logic here
	}

}