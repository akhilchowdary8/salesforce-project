trigger Accountfieldupdate on Account (before Update) {
    for (Account acc : Trigger.new) {
        if (acc != null) {
            acc.Description = acc.Description;
        }
    }
}
