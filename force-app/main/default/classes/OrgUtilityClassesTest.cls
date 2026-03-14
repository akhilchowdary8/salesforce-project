@IsTest
private class OrgUtilityClassesTest {
    @IsTest
    static void utilityClasses_areCovered() {
        Akhil akhilObj = new Akhil();
        System.assertNotEquals(null, akhilObj);

        Ap.Am();

        BatchPractice2 emptyBatch = new BatchPractice2();
        System.assertNotEquals(null, emptyBatch);
        System.assertEquals('OK', BatchPractice2.ping());

        ConClass con = new ConClass(7, 'Akhil', 'OpenAI');
        System.assertNotEquals(null, con);

        FirstClass first = new FirstClass();
        first.Akhilr();

        NewClass newClassObj = new NewClass();
        newClassObj.Akhilr();
        newClassObj.getSt();
        newClassObj.addNum(2, 3);

        NewIntegrationClass integrationClass = new NewIntegrationClass();
        System.assertNotEquals(null, integrationClass);
        System.assertEquals('OK', NewIntegrationClass.ping());

        NewStack newStack = new NewStack();
        System.assertEquals(true, newStack.isEmpty());
        newStack.push('A');
        newStack.push('B');
        System.assertEquals(2, newStack.size());
        System.assertEquals('B', String.valueOf(newStack.peek()));
        System.assertEquals('B', String.valueOf(newStack.pop()));
        System.assertEquals('A', String.valueOf(newStack.pop()));
        System.assertEquals(null, newStack.pop());

        Stack stack = new Stack();
        System.assertEquals(true, stack.isEmpty());
        stack.push('One');
        stack.push('Two');
        System.assertEquals(false, stack.isEmpty());
        System.assertEquals(2, stack.size());
        System.assertEquals('Two', String.valueOf(stack.peek()));
        System.assertEquals('Two', String.valueOf(stack.pop()));

        Palindrome palindrome = new Palindrome();
        System.assertEquals(true, palindrome.isPalindrome('Madam'));
        System.assertEquals(false, palindrome.isPalindrome('Salesforce'));

        Spractise practise = new Spractise();
        System.assertNotEquals(null, practise);
        System.assertEquals('OK', Spractise.ping());

        YouTubeWrapper wrapper = new YouTubeWrapper();
        wrapper.items = new List<YouTubeWrapper.Item>();
        YouTubeWrapper.Item item = new YouTubeWrapper.Item();
        item.id = new YouTubeWrapper.IdInfo();
        item.id.videoId = 'abc123';
        item.snippet = new YouTubeWrapper.Snippet();
        item.snippet.title = 'Video';
        item.snippet.channelTitle = 'Channel';
        item.snippet.thumbnails = new Map<String, YouTubeWrapper.Thumbnail>();
        YouTubeWrapper.Thumbnail thumb = new YouTubeWrapper.Thumbnail();
        thumb.url = 'https://example.com/image.jpg';
        item.snippet.thumbnails.put('default', thumb);
        wrapper.items.add(item);
        System.assertEquals('abc123', wrapper.items[0].id.videoId);
        System.assertEquals('https://example.com/image.jpg', wrapper.items[0].snippet.thumbnails.get('default').url);

        YouTubeWrapper parsed = YouTubeWrapper.parse(
            '{"items":[{"id":{"videoId":"id-1"},"snippet":{"title":"Title 1","description":"Desc","channelTitle":"Channel","publishedAt":"2026-03-10T12:00:00Z","thumbnails":{"default":{"url":"https://example.com/t1.jpg"}}}}]}'
        );
        System.assertEquals('id-1', parsed.items[0].id.videoId);
    }
}
