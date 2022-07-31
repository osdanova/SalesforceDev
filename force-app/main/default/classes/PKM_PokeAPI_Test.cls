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
        Map<String,String> map_endpoint_filename = new Map<String,String>();
        map_endpoint_filename.put(PKM_PokeAPI.BASE_URL + 'type/4', 'Test_PKMType4');
        map_endpoint_filename.put(PKM_PokeAPI.BASE_URL + 'type/12', 'Test_PKMType12');
        map_endpoint_filename.put(PKM_PokeAPI.BASE_URL + 'ability/34', 'Test_PKMAbility34');
        map_endpoint_filename.put(PKM_PokeAPI.BASE_URL + 'ability/65', 'Test_PKMAbility65');
        map_endpoint_filename.put(PKM_PokeAPI.BASE_URL + 'pokemon/1', 'Test_PKMSpecies1');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, Util_CalloutMock.getMultiResourceMock(map_endpoint_filename));
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