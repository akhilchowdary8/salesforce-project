public class YouTubeWrapper {
    public List<Item> items;

    public static YouTubeWrapper parse(String payload) {
        return (YouTubeWrapper) JSON.deserialize(payload, YouTubeWrapper.class);
    }

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
        public Datetime publishedAt;
        public Map<String, Thumbnail> thumbnails;
    }

    public class Thumbnail {
        public String url;
    }
}
