trigger AccountTrigger on Account (After Update) {
    List<Account> akhil=Trigger.new;
    for(Account a:akhil )
    {
        if(a.name == 'Akhil'){
            
  throw new NameException('Error: The name "Akhil" is not allowed.');
        
        
    }
    
    

} 
public class NameException extends Exception {}
}