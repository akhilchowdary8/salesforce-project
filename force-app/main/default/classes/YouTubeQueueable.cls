public class YouTubeQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> requestIds;

    public YouTubeQueueable(List<Id> requestIds) {
        this.requestIds = requestIds;
    }

    public void execute(QueueableContext context) {
        if (requestIds == null || requestIds.isEmpty()) {
            return;
        }

        List<YouTube_Search_Request__c> requests = [
            SELECT Id, Keyword__c
            FROM YouTube_Search_Request__c
            WHERE Id IN :requestIds
        ];

        List<YouTube_Video__c> videosToUpsert = new List<YouTube_Video__c>();

        for (YouTube_Search_Request__c req : requests) {
            if (String.isBlank(req.Keyword__c)) {
                continue;
            }

            String response = YouTubeService.searchVideos(req.Keyword__c);
            if (String.isBlank(response)) {
                continue;
            }

            YouTubeWrapper data = (YouTubeWrapper) JSON.deserialize(response, YouTubeWrapper.class);
            if (data == null || data.items == null) {
                continue;
            }

            for (YouTubeWrapper.Item item : data.items) {
                if (item == null || item.id == null || String.isBlank(item.id.videoId) || item.snippet == null) {
                    continue;
                }

                YouTube_Video__c video = new YouTube_Video__c();
                video.Video_Id__c = item.id.videoId;
                video.Title__c = item.snippet.title;
                video.Channel_Name__c = item.snippet.channelTitle;
                video.Description__c = item.snippet.description;

                if (item.snippet.publishedAt != null) {
                    video.Published_Date__c = item.snippet.publishedAt.dateGmt();
                }

                if (item.snippet.thumbnails != null && item.snippet.thumbnails.containsKey('default')) {
                    video.Thumbnail_URL__c = item.snippet.thumbnails.get('default').url;
                }

                videosToUpsert.add(video);
            }
        }

        if (!videosToUpsert.isEmpty()) {
            upsert videosToUpsert Video_Id__c;
        }
    }
}
