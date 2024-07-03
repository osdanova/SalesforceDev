public with sharing class LWC_testLwc
{
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsWithNames(integer count)
    {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT :count];
        return accounts;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> get10AccountsWithNames()
    {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        return accounts;
    }
}