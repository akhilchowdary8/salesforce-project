public class OpportunityDeletion implements Database.Batchable<SObject>, Database.Stateful {
  public Integer countFailed = 0;
  public Integer countSuccess = 0;
  List<Id> failedIds = new List<Id>();
  List<String> failedMessages = new List<String>();

public Database.QueryLocator start(Database.BatchableContext BC) {

    String pattern = '%' + 'Reddy' + '%';

    return Database.getQueryLocator('SELECT Id FROM Contact');
}
  public void execute(Database.BatchableContext BC, List<Contact> scope) {
    List<Contact> del = new List<Contact>();
    for (Contact temp : scope) {
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