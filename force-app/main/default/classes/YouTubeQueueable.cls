public class YouTubeQueueable implements Queueable, Database.AllowsCallouts {

    private List<Id> requestIds;

    public YouTubeQueueable(List<Id> requestIds){
        this.requestIds = requestIds;
    }

    public void execute(QueueableContext context){

        List<YouTube_Search_Request__c> requests =
        [SELECT Id, Keyword__c
         FROM YouTube_Search_Request__c
         WHERE Id IN :requestIds];

        for(YouTube_Search_Request__c req : requests){

            String response = YouTubeService.searchVideos(req.Keyword__c);

            YouTubeWrapper data =
            (YouTubeWrapper)JSON.deserialize(response, YouTubeWrapper.class);

            List<YouTube_Video__c> videos = new List<YouTube_Video__c>();

            for(YouTubeWrapper.Item item : data.items){

                YouTube_Video__c video = new YouTube_Video__c();

                video.Video_Id__c = item.id.videoId;
                video.Title__c = item.snippet.title;
                video.Channel_Name__c = item.snippet.channelTitle;
                video.Description__c = item.snippet.description;
                //video.Thumbnail_URL__c = item.snippet.thumbnails.defaultThumbnail.url;

                videos.add(video);

            }

            if(!videos.isEmpty()){
                upsert videos Video_Id__c;
            }

        }

    }

}