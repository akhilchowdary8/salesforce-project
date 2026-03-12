public class BatchPractise implements Database.Batchable<Sobject> {
    
    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator('select id from Leads');
        
        
        
    }
    public void execute (Database.BatchableContext bc, List<Lead> scope){
        for (Lead a: scope	){
            a.email = 'akhil';
        }
        update scope;
        
    }
   public void finish(Database.BatchableContext bc){
        
    }

}