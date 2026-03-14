@IsTest
private class YouTubeQueueableTest {
    private class QueueableMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(
                '{"items":[' +
                '{"id":{"videoId":"vid-001"},"snippet":{"title":"First Video","description":"Desc 1","channelTitle":"Channel 1","publishedAt":"2026-03-10T12:00:00Z","thumbnails":{"default":{"url":"https://img.example.com/1.jpg"}}}},' +
                '{"id":{"videoId":"vid-002"},"snippet":{"title":"Second Video","description":"Desc 2","channelTitle":"Channel 2","publishedAt":"2026-03-11T12:00:00Z","thumbnails":{"default":{"url":"https://img.example.com/2.jpg"}}}},' +
                '{"id":{"videoId":""},"snippet":{"title":"Skip Me","description":"Invalid","channelTitle":"Channel 3","publishedAt":"2026-03-11T12:00:00Z"}}' +
                ']}'
            );
            return res;
        }
    }

    private class UpsertMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(
                '{"items":[' +
                '{"id":{"videoId":"vid-001"},"snippet":{"title":"Updated Title","description":"Updated Desc","channelTitle":"Updated Channel","publishedAt":"2026-03-12T12:00:00Z","thumbnails":{"default":{"url":"https://img.example.com/updated.jpg"}}}}' +
                ']}'
            );
            return res;
        }
    }

    @IsTest
    static void execute_createsVideosFromResponse() {
        YouTube_Search_Request__c requestRecord = new YouTube_Search_Request__c(
            Name = 'Search 1',
            Keyword__c = 'apex'
        );
        insert requestRecord;

        delete [SELECT Id FROM YouTube_Video__c];

        Test.setMock(HttpCalloutMock.class, new QueueableMock());

        Test.startTest();
        System.enqueueJob(new YouTubeQueueable(new List<Id>{ requestRecord.Id }));
        Test.stopTest();

        List<YouTube_Video__c> videos = [
            SELECT Video_Id__c, Title__c, Channel_Name__c, Description__c, Thumbnail_URL__c, Published_Date__c
            FROM YouTube_Video__c
            ORDER BY Video_Id__c
        ];

        System.assertEquals(2, videos.size());
        System.assertEquals('vid-001', videos[0].Video_Id__c);
        System.assertEquals('First Video', videos[0].Title__c);
        System.assertEquals('Channel 1', videos[0].Channel_Name__c);
        System.assertEquals(Date.newInstance(2026, 3, 10), videos[0].Published_Date__c);
        System.assertEquals('https://img.example.com/1.jpg', videos[0].Thumbnail_URL__c);
    }

    @IsTest
    static void execute_upsertsExistingVideoByExternalId() {
        insert new YouTube_Video__c(
            Name = 'Existing Video',
            Video_Id__c = 'vid-001',
            Title__c = 'Old Title'
        );

        YouTube_Search_Request__c requestRecord = new YouTube_Search_Request__c(
            Name = 'Search 2',
            Keyword__c = 'integration'
        );
        insert requestRecord;

        Test.setMock(HttpCalloutMock.class, new UpsertMock());

        Test.startTest();
        System.enqueueJob(new YouTubeQueueable(new List<Id>{ requestRecord.Id }));
        Test.stopTest();

        List<YouTube_Video__c> videos = [
            SELECT Video_Id__c, Title__c, Channel_Name__c, Thumbnail_URL__c
            FROM YouTube_Video__c
            WHERE Video_Id__c = 'vid-001'
        ];

        System.assertEquals(1, videos.size());
        System.assertEquals('Updated Title', videos[0].Title__c);
        System.assertEquals('Updated Channel', videos[0].Channel_Name__c);
        System.assertEquals('https://img.example.com/updated.jpg', videos[0].Thumbnail_URL__c);
    }

    @IsTest
    static void execute_handlesEmptyRequestIds() {
        Test.startTest();
        System.enqueueJob(new YouTubeQueueable(new List<Id>()));
        Test.stopTest();

        System.assert(true);
    }
}
