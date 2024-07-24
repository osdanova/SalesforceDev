global with sharing class ASYNC_SchedulableTest implements Schedulable
{
    global void execute(SchedulableContext SC) {
        List<Account> accounts =[SELECT Id FROM Account];

        // Execute once
        CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        System.abortjob(ct.Id);
    }
}