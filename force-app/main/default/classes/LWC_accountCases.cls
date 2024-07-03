public with sharing class LWC_accountCases
{
    @AuraEnabled(cacheable=true)
    public static List<Case> getAccountCases(string accountId)
    {
        List<Case> cases = [SELECT Id, Subject, CreatedDate FROM Case WHERE AccountId = :accountId];
        return cases;
    }
}