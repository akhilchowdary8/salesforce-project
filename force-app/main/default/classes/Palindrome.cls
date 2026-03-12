public class Palindrome {
public Boolean isPalindrome(String str){
    String input=str.replaceAll('[^a-zA-Z]','');
    input.toLowerCase();
    String b='';
    for(Integer i=input.length()-1;i>1;i--){
        b=b+input.substring(i-1,i);
    }
    System.debug(input);
	System.debug(b);
	System.debug(input.toLowerCase().equals(b));    
    return input.toLowerCase().equals(b);

//code here
}
}