public class BatchPractise implements Database.Batchable<Sobject> {
    
    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Email FROM Lead');
    }
    public void execute (Database.BatchableContext bc, List<Lead> scope){
        for (Lead a: scope	){
            a.Email = 'batchpractice@example.com';
        }
        update scope;
        
    }
   public void finish(Database.BatchableContext bc){
        
    }

}
