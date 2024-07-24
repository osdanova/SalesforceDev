### [SF Book](../README.md)

# Apex Async

Asynchronous processes get into a queue and are processed in a separate execution. They have increased governor limits compared to normal apex executions.

[Docs](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_async_overview.htm)

## Future

The simplest way of running an async process. They get queued and executed as soon as they can. They can't have a return value and can only be passed primitive data types (Ids, strings, numbers...) and collections of them.

Useful to prevent delaying an Apex transaction.

    @future
    public static void processRecords(List<ID> recordIds)
    {   
         // Get those records based on the IDs
         List<Account> accts = [SELECT Name FROM Account WHERE Id IN :recordIds];
         // Process records
    }

    @future(callout=true)
    public static void getStockQuotes(String acctName)
    {   
         // Perform a callout to an external service
    }

## Queueable

An improvement over future jobs. They return the id of the job, can be passed objects and can be chained. Since they are set up as an instance they can also be set variables.

    // Fibonacci
    public class FibonacciDepthQueueable implements Queueable
    {
        private long nMinus1, nMinus2;
        
        public static void calculateFibonacciTo(integer depth)
        {
            AsyncOptions asyncOptions = new AsyncOptions();
            asyncOptions.MaximumQueueableStackDepth = depth;
            System.enqueueJob(new FibonacciDepthQueueable(null, null), asyncOptions);
        }
        
        private FibonacciDepthQueueable(long nMinus1param, long nMinus2param)
        {
            nMinus1 = nMinus1param;
            nMinus2 = nMinus2param;
        }
    
        public void execute(QueueableContext context)
        {
            integer depth = AsyncInfo.getCurrentQueueableStackDepth();
        
            // Calculate step
            long fibonacciSequenceStep;
            switch on (depth)
            {
                when 1, 2 {
                    fibonacciSequenceStep = 1;
                }
                when else {
                    fibonacciSequenceStep = nMinus1 + nMinus2;
                }
            }
        
            System.debug('depth: ' + depth + ' fibonacciSequenceStep: ' + fibonacciSequenceStep);
        
            if(System.AsyncInfo.hasMaxStackDepth() &&
               AsyncInfo.getCurrentQueueableStackDepth() >= 
               AsyncInfo.getMaximumQueueableStackDepth())
            {
                // Reached maximum stack depth
                Fibonacci__c result = new Fibonacci__c(
                    Depth__c = depth,
                    Result = fibonacciSequenceStep
                    );
                insert result;
            }
            else {
                System.enqueueJob(new FibonacciDepthQueueable(fibonacciSequenceStep, nMinus1));
            }
        }
    }

Note that they are executed like this:

    System.enqueueJob(new FibonacciDepthQueueable(null, null), asyncOptions);
    System.enqueueJob(new MyQueueable(), delayInMinutesUpTo10);

Queueables can be chained by calling System.enqueueJob in the execute method.

## Schedulable

Limit: 100 scheduled jobs

To schedule an Apex class to run on a specific schedule with the Schedule Apex page (In Apex Classes) or via Apex. It is recommended to only use schedulable to call another process instead of adding the process directly into the schedulable class.

    global class ScheduledMerge implements Schedulable
    {
        global void execute(SchedulableContext SC) {
            MergeNumbers M = new MergeNumbers(); 
        }
    }

And they're invoked like this through Apex:

    ScheduledMerge m = new ScheduledMerge();
    String sch = '20 30 8 10 2 ?';
    String jobID = System.schedule('Merge Job', sch, m);

Job execution can be tracked with:

    CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];

The cron expression follow this syntax:

    Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year

Seconds and Minutes do not accept special characters, meaning Apex doesn’t allow for a job to be scheduled more than once an hour. For the others a noticeably special characters is "*" which means "All values". For day of week and day of month, if one is set the other must be "?".

Jobs can be scheduled to run once however the Scheduled Job will remain until aborted even without a next run time. To make a job run once it can be aborted at the end of the execution.

    CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :sc.getTriggerId()];
    System.abortjob(ct.Id);

These jobs appear in the Scheduled Jobs (CronTrigger; CronJobDetail has the name) page as well as in the Apex Jobs (AsyncApexJob pointing to CronTrigger; Job Type: Scheduled Apex). Once aborted, both CronTrigger objects are deleted (Unless it runs more times) and only the AsyncApexJob remains.

## Batchable

Limit: 5 batches running at the same time, up to 100 in flex queue

Batch jobs split the load in smaller chunks for long-running jobs with large data volumes.

* The objects to be processed are returned in the start method, this can be done through a QueryLocator or a collection of objects.
* The objects are split into chunks (default 200, defined on call) and processed in the execute method.
* Once all chunks are finished, the finish method is run.

Each execution of a batch Apex job is considered a discrete transaction. For example, a batch Apex job that contains 1,000 records and is executed without the optional scope parameter is considered five transactions of 200 records each.


### QueryLocator

    public class SearchAndReplace implements Database.Batchable<sObject
    {
        public final String Query;
        public final String Entity;
        public final String Field;
        public final String Value;

        public SearchAndReplace(String q, String e, String f, String v){
            Query=q; Entity=e; Field=f;Value=v;
        }

        public Database.QueryLocator start(Database.BatchableContext bc){
            return Database.getQueryLocator(query);
        }

        public void execute(Database.BatchableContext bc, List<sObject> scope)
        {
            for(sobject s : scope){
                s.put(Field,Value); 
            }
            update scope;
        }

        public void finish(Database.BatchableContext bc){
        }
    }

### Collection

    public class batchClass implements Database.batchable
    { 
        public Iterable start(Database.BatchableContext info){ 
            return new CustomAccountIterable(); 
        }     
        public void execute(Database.BatchableContext info, List<Account> scope)
        {
            List<Account> accsToUpdate = new List<Account>();
            for(Account a : scope)
            { 
                a.Name = 'true'; 
                a.NumberOfEmployees = 70; 
                accsToUpdate.add(a); 
            } 
            update accsToUpdate; 
        }     
        public void finish(Database.BatchableContext info){     
        } 
    }

To execute a batch use:

    integer chunkSize = 100;
    ID batchprocessid = Database.executeBatch(new batchClass(), chunkSize);

Note: The optimal scope size is a factor of 2000, for example, 100, 200, 400 and so on.

Batches can be tracked by their id:

    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchprocessid ];

They can also be scheduled:

    integer minutesUntilLaunch = 5;
    integer chunkSize = 100;
    String cronID = System.scheduleBatch(new batchClass(), 'Scheduled Job Name', minutesUntilLaunch, chunkSize);

### Callouts

To be able to do callouts the class must implement Database.AllowsCallouts.

### State

Given that each bulk execution is its own transaction, they don't share variables. Static variables are unique per transaction and non-static variables are not shared.

Implementing Database.Stateful allows the transactions to see non-static variables in the batch instance.

    public class SummarizeAccountTotal implements Database.Batchable<sObject>, Database.Stateful
    {

        public final String Query;
        public integer Summary;
        
        public SummarizeAccountTotal(String q){Query=q;
            Summary = 0;
        }

        public Database.QueryLocator start(Database.BatchableContext bc){
            return Database.getQueryLocator(query);
        }
        
        public void execute(
                        Database.BatchableContext bc, 
                        List<sObject> scope){
            for(sObject s : scope){
                Summary = Integer.valueOf(s.get('total__c'))+Summary;
            }
        }

        public void finish(Database.BatchableContext bc){
        }
    }

 ### Chaining

Batches can be chained by calling Database.executeBatch or System.scheduleBatch in the finish method.