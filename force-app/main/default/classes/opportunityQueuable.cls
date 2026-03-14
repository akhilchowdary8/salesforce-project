public class opportunityQueuable implements Queueable {
    public void execute(QueueableContext sc){
	Database.executeBatch(new OpportunityDeletion(),10);
    
    }

}