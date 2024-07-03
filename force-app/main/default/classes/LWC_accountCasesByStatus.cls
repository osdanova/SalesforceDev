public with sharing class LWC_accountCasesByStatus
{
    @AuraEnabled(cacheable=true)
    public static Map<string,integer> getAccountCasesByStatus(string accountId)
    {
        Map<string,integer> caseStatusCount = new Map<string,integer>();
        for(Case iCase : [SELECT Id, Status FROM Case WHERE AccountId = :accountId])
        {
            if(!caseStatusCount.keyset().contains(iCase.Status)){
                caseStatusCount.put(iCase.Status, 0);
            }
            caseStatusCount.put(iCase.Status, caseStatusCount.get(iCase.Status) + 1);
        }
        return caseStatusCount;
    }
}