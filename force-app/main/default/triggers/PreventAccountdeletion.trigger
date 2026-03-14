trigger PreventAccountdeletion on Account (before insert) {
    for (Account acc : Trigger.new) {
        if (acc != null) {
            acc.Description = acc.Description;
        }
    }
}
