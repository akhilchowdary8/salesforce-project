/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : PractiseOneController
 * Author          : <YourName>
 * Created Date    : Jan 28, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Jan 28, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Jan 28, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class PractiseOneController {

	@AuraEnabled(cacheable=true)
	public static List<Account> fetchAccounts() {
	return [select id,name,lastmodifieddate from Account];
		// Your logic here
	}

}