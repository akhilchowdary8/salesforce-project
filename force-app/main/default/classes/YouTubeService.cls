public with sharing class YouTubeService {

    public static String searchVideos(String keyword){

//         String apiKey = 'AIzaSyAXYKG4WKFtQ70Fr01j5r5GcEuEXFv4TAw';
// String endpoint = 'https://www.googleapis.com/youtube/v3/search?q=' 
//                     + keyword +
//                     '&part=snippet&type=video&maxResults=5&key='
//                     + apiKey;


        Http http = new Http();
        HttpRequest req = new HttpRequest();

        // req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60000);
  req.setEndpoint(
            'callout:YouTube_API/youtube/v3/search?q=' + keyword +
            '&part=snippet&type=video&maxResults=5'
        );       
		 HttpResponse res = http.send(req);

        System.debug('Status Code: ' + res.getStatusCode());
        System.debug('Response: ' + res.getBody());

        return res.getBody();
    }
}