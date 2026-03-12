/*Rollup Summary of Opportunity Amounts to Account
Scenario: Maintain a custom field Total_Opportunity_Amount__c on Account that reflects the sum of all active Opportunity Amounts.*/ 

trigger Opprtunityupdatecontacts on Opportunity (after insert, after update, after delete) {
Set<Id> accountIds=new Set<Id>();
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            if (opp.AccountId != null && !opp.IsClosed) {
                accountIds.add(opp.AccountId);
            }
        }
    }
    
    if (Trigger.isDelete) {
        for (Opportunity opp : Trigger.old) {
            if (opp.AccountId != null && !opp.IsClosed) {
                accountIds.add(opp.AccountId);
            }
        }
    }


// fetch all accounts
List<Account> upac=new List<Account>();
List <AggregateResult> Ac=[Select Accountid, sum(Amount) totalsum from Opportunity where accountid in :accountIds Group by accountid ];
// assign related amount to each account from all relate opportunitis
    for(AggregateResult ar:Ac){
        Account acc = new Account();
				acc.Total_Opportunity_Amount_c__c=(Decimal)ar.get('totalsum');
				acc.id=(Id)ar.get('Accountid');
				upac.add(acc);
			
			}
Update Upac;

}