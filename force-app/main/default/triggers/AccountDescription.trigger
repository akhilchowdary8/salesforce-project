trigger AccountDescription on Account (before update) {
      System.debug('Trigger.newMap');
    System.debug(Trigger.newMap.keySet());
    System.debug('Trigger.new');
    System.debug(Trigger.new);
    System.debug('Trigger.old');
    System.debug(Trigger.old);
    System.debug('Trigger.oldMap');
    System.debug(Trigger.oldMap.keySet());
    for(Account a:trigger.new){
        a.Description='successfully account update';
    }
    

}