@IsTest
private class YouTubeServiceTest {
    private class SuccessMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            System.assertEquals('GET', req.getMethod());
            System.assert(
                req.getEndpoint().contains('q=salesforce+integration'),
                'Expected encoded keyword in endpoint: ' + req.getEndpoint()
            );

            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"items":[]}');
            return res;
        }
    }

    private class ErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('failure');
            return res;
        }
    }

    @IsTest
    static void searchVideos_returnsResponseBody() {
        Test.setMock(HttpCalloutMock.class, new SuccessMock());

        Test.startTest();
        String response = YouTubeService.searchVideos('salesforce integration');
        Test.stopTest();

        System.assertEquals('{"items":[]}', response);
    }

    @IsTest
    static void searchVideos_returnsNullForBlankKeyword() {
        Test.startTest();
        String response = YouTubeService.searchVideos('   ');
        Test.stopTest();

        System.assertEquals(null, response);
    }

    @IsTest
    static void searchVideos_throwsForErrorResponse() {
        Test.setMock(HttpCalloutMock.class, new ErrorMock());

        Test.startTest();
        try {
            YouTubeService.searchVideos('salesforce');
            System.assert(false, 'Expected CalloutException to be thrown.');
        } catch (CalloutException ex) {
            System.assert(ex.getMessage().contains('status code 500'));
        }
        Test.stopTest();
    }
}
