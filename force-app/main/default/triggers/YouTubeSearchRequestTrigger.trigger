trigger YouTubeSearchRequestTrigger on YouTube_Search_Request__c (after insert) {
    List<Id> requestIds = new List<Id>();

    for (YouTube_Search_Request__c req : Trigger.new) {
        if (!String.isBlank(req.Keyword__c)) {
            requestIds.add(req.Id);
        }
    }

    if (!requestIds.isEmpty()) {
        System.enqueueJob(new YouTubeQueueable(requestIds));
    }
}
