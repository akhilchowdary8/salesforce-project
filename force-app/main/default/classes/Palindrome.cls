public class Palindrome {
public Boolean isPalindrome(String str){
    String input = str == null ? '' : str.replaceAll('[^a-zA-Z]','').toLowerCase();
    String b='';
    for(Integer i = input.length() - 1; i >= 0; i--){
        b = b + input.substring(i, i + 1);
    }
    return input.equals(b);
}
}
