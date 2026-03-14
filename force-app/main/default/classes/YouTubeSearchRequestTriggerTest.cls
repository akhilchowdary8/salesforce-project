@IsTest
private class YouTubeSearchRequestTriggerTest {
    private class TriggerMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(
                '{"items":[' +
                '{"id":{"videoId":"trigger-001"},"snippet":{"title":"Triggered Video","description":"Created by trigger","channelTitle":"Trigger Channel","publishedAt":"2026-03-13T12:00:00Z","thumbnails":{"default":{"url":"https://img.example.com/trigger.jpg"}}}}' +
                ']}'
            );
            return res;
        }
    }

    @IsTest
    static void trigger_enqueuesQueueableForKeyword() {
        delete [SELECT Id FROM YouTube_Video__c];

        Test.setMock(HttpCalloutMock.class, new TriggerMock());

        Test.startTest();
        insert new YouTube_Search_Request__c(
            Name = 'Triggered Search',
            Keyword__c = 'youtube'
        );
        Test.stopTest();

        List<YouTube_Video__c> videos = [
            SELECT Video_Id__c, Title__c
            FROM YouTube_Video__c
            WHERE Video_Id__c = 'trigger-001'
        ];

        System.assertEquals(1, videos.size());
        System.assertEquals('Triggered Video', videos[0].Title__c);
    }

    @IsTest
    static void trigger_skipsBlankKeyword() {
        delete [SELECT Id FROM YouTube_Video__c];

        Test.startTest();
        insert new YouTube_Search_Request__c(
            Name = 'Blank Search',
            Keyword__c = '   '
        );
        Test.stopTest();

        Integer videoCount = [SELECT COUNT() FROM YouTube_Video__c];
        System.assertEquals(0, videoCount);
    }
}
