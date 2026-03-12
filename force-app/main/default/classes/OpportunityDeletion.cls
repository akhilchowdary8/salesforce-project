public class OpportunityDeletion implements Database.Batchable<SObject>, Database.Stateful {
  public Integer countFailed = 0;
  public Integer countSuccess = 0;
  List<Id> failedIds = new List<Id>();
  List<String> failedMessages = new List<String>();

  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      'select id from opportunity where CloseDate< TODAY'
    );
  }
  public void execute(Database.BatchableContext BC, List<opportunity> scope) {
    List<Opportunity> del = new List<Opportunity>();
    for (Opportunity temp : scope) {
          del.add(temp);
    } 
   Database.DeleteResult[] res = Database.delete(del, false);

    for (Integer i = 0; i < res.size(); i++) {
      if (res[i].isSuccess()) {
        countSuccess++;
      } else {
        countFailed++;
        Database.Error errors = res[i].getErrors()[0];
        failedIds.add(res[i].Id);
        failedMessages.add(res[i].Id + ' → ' + errors.getMessage());
      }
    }
  }

  public void finish(Database.BatchableContext BC) {
    System.debug('countFailed'+countFailed);
	System.debug('countSuccess'+countSuccess);
  }
}