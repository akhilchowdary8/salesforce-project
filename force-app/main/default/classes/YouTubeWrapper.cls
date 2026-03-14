/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : YouTubeWrapper
 * Author          : <YourName>
 * Created Date    : Mar 14, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Mar 14, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Mar 14, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class YouTubeWrapper {

    public List<Item> items;

    public class Item {
        public IdInfo id;
        public Snippet snippet;
    }

    public class IdInfo {
        public String videoId;
    }

    public class Snippet {
        public String title;
        public String description;
        public String channelTitle;
        public String publishedAt;
        public Thumbnails thumbnails;
    }
public class Thumbnails {
    public DefaultThumbnail defaultThumbnail;
}

    public class DefaultThumbnail {
        public String url;
    }

}