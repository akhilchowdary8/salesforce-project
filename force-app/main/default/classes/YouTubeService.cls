public with sharing class YouTubeService {

    @TestVisible
    private static final String NAMED_CREDENTIAL_PATH = 'callout:YouTube_API/youtube/v3/search';

    public static String searchVideos(String keyword) {
        if (String.isBlank(keyword)) {
            return null;
        }

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(60000);
        req.setEndpoint(buildSearchEndpoint(keyword));

        HttpResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();

        if (statusCode < 200 || statusCode >= 300) {
            throw new CalloutException('YouTube API call failed with status code ' + statusCode);
        }

        return res.getBody();
    }

    @TestVisible
    private static String buildSearchEndpoint(String keyword) {
        return NAMED_CREDENTIAL_PATH
            + '?q=' + EncodingUtil.urlEncode(keyword, 'UTF-8')
            + '&part=snippet&type=video&maxResults=5';
    }
}
