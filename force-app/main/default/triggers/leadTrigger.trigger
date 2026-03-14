trigger leadTrigger on Lead (before insert) {
    for (Lead l : Trigger.new) {
        if (l != null) {
            l.Description = l.Description;
        }
    }
}
