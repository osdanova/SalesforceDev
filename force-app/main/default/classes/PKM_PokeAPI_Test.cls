@isTest
public class PKM_PokeAPI_Test
{
    @isTest
    public static void test_upsertType()
    {
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getResourceMock('Test_PKMType1'));

        PKM_PokeAPI.upsertType(1);

        List<PKM_Type__c> list_types = [SELECT Id FROM PKM_Type__c WHERE Id_PKM__c = 1];
        System.assert(list_types.size() == 1);
    }

    @isTest
    public static void test_upsertAbility()
    {
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getResourceMock('Test_PKMAbility1'));

        PKM_PokeAPI.upsertAbility(1);

        List<PKM_Ability__c> list_abilities = [SELECT Id FROM PKM_Ability__c WHERE Id_PKM__c = 1];
        System.assert(list_abilities.size() == 1);
    }

    @isTest
    public static void test_upsertPokemonSpeciesAdvanced()
    {
        PKM_Type__c type4 = new PKM_Type__c(Id_PKM__c = 4);
        PKM_Type__c type12 = new PKM_Type__c(Id_PKM__c = 12);
        insert new List<PKM_Type__c> { type4, type12 };

        PKM_Ability__c ability34 = new PKM_Ability__c(Id_PKM__c = 34);
        PKM_Ability__c ability65 = new PKM_Ability__c(Id_PKM__c = 65);
        insert new List<PKM_Ability__c> { ability34, ability65 };
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getResourceMock('Test_PKMSpecies1'));
        PKM_PokeAPI.upsertPokemonSpeciesAdvanced(1);
        Test.stopTest();

        List<PKM_Species__c> list_species = [SELECT Id FROM PKM_Species__c WHERE Id_PKM__c = 1];
        System.assert(list_species.size() == 1);
    }
    
    @isTest
    public static void test_getMissingTypes()
    {
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getResourceMock('Test_PKMType1'));

        List<PKM_Type__c> list_missingTypes = PKM_PokeAPI.getMissingTypes(new Set<integer>{1});
        System.assert(list_missingTypes.size() == 1);
    }
    
    @isTest
    public static void test_getMissingAbilities()
    {
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getResourceMock('Test_PKMAbility1'));

        List<PKM_Ability__c> list_missingAbilities = PKM_PokeAPI.getMissingAbilities(new Set<integer>{1});
        System.assert(list_missingAbilities.size() == 1);
    }
    
    // Experimental function not used but still want the test done
    @isTest
    public static void test_parsePokemonJson()
    {
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getResourceMock('Test_PKMSpecies1'));
        PKM_Species__c species = PKM_PokemonWrapper.parsePokemonJson(PKM_PokeAPI.fetchPokemon(1));
    }
}