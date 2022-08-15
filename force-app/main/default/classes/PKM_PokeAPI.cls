public class PKM_PokeAPI
{
    public static final string BASE_URL = 'https://pokeapi.co/api/v2/';
    
    public static string fetchData(string endpoint, integer identifier)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL + endpoint + '/' + identifier);
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }

    public static string fetchPokemon(integer identifier) {
        return fetchData('pokemon', identifier);
    }
    public static string fetchType(integer identifier) {
        return fetchData('type', identifier);
    }
    public static string fetchAbility(integer identifier) {
        return fetchData('ability', identifier);
    }
    public static string fetchSpecies(integer identifier) {
        return fetchData('pokemon-species', identifier);
    }
    
    public static PKM_PokemonWrapper getPokemonWrapper(integer identifier) {
        return PKM_PokemonWrapper.fromJson(fetchPokemon(identifier));
    }
    public static PKM_TypeWrapper getTypeWrapper(integer identifier) {
        return PKM_TypeWrapper.fromJson(fetchType(identifier));
    }
    public static PKM_AbilityWrapper getAbilityWrapper(integer identifier) {
        return PKM_AbilityWrapper.fromJson(fetchAbility(identifier));
    }
    
    public static PKM_Species__c getPokemon(integer identifier) {
        return getPokemonWrapper(identifier).toSpecies();
    }
    public static PKM_Type__c getType(integer identifier) {
        return getTypeWrapper(identifier).toType();
    }
    public static PKM_Ability__c getAbility(integer identifier) {
        return getAbilityWrapper(identifier).toAbility();
    }
    public static string getDescription(integer identifier) {
        string description = PKM_SpeciesWrapper.fromJson(fetchSpecies(identifier)).description;
        return replaceNextLine(description);
    }

    public static void upsertType(integer identifier){
        upsert getType(identifier) Id_PKM__c;
    }
    public static void upsertAbility(integer identifier){
        upsert getAbility(identifier) Id_PKM__c;
    }

    public static void upsertPokemonSpeciesAdvanced(integer identifier)
    {
        // Fetch the pokemon
        PKM_Species__c species = getPokemon(identifier);
        species.Description__c = getDescription(identifier);

        // Check if the types and abilities are in database, otherwise fetch them
        Set<integer> set_typeIds = new Set<integer>{
            (integer) species.Type1__r.Id_PKM__c,
            (integer) species.Type2__r.Id_PKM__c
        };
        set_typeIds.remove(null);
        Set<integer> set_abilityIds = new Set<integer>{
            (integer) species.Ability1__r.Id_PKM__c, 
            (integer) species.Ability2__r.Id_PKM__c, 
            (integer) species.Ability3__r.Id_PKM__c
        };
        set_abilityIds.remove(null);

        // NOTE: Can't make callouts after DML ops
        List<PKM_Type__c> list_missingTypeIds = getMissingTypes(set_typeIds);
        List<PKM_Ability__c> list_missingAbilityIds = getMissingAbilities(set_abilityIds);
        
        upsert list_missingTypeIds Id_PKM__c;
        upsert list_missingAbilityIds Id_PKM__c;

        upsert species Id_PKM__c;
    }

    public static List<PKM_Type__c> getMissingTypes(Set<integer> set_typeIds)
    {
        Set<integer> set_typeIdsDB = new Set<integer>();
        for(PKM_Type__c type : [SELECT Id, Id_PKM__c FROM PKM_Type__c WHERE Id_PKM__c IN :set_typeIds]) {
            set_typeIdsDB.add((integer)type.Id_PKM__c);
        }

        Set<integer> set_missingTypeIds = new Set<integer>();
        for(integer typeId : set_typeIds)
        {
            if(!set_typeIdsDB.contains(typeId)) {
                set_missingTypeIds.add(typeId);
            }
        }

        List<PKM_Type__c> list_types = new List<PKM_Type__c>();
        for(integer typeId : set_missingTypeIds){
            list_types.add(getType(typeId));
        }

        return list_types;
    }

    public static List<PKM_Ability__c> getMissingAbilities(Set<integer> set_abilityIds)
    {
        Set<integer> set_abilityIdsDB = new Set<integer>();
        for(PKM_Ability__c ability : [SELECT Id, Id_PKM__c FROM PKM_Ability__c WHERE Id_PKM__c IN :set_abilityIds]) {
            set_abilityIdsDB.add((integer)ability.Id_PKM__c);
        }

        Set<integer> set_missingAbilityIds = new Set<integer>();
        for(integer abilityId : set_abilityIds)
        {
            if(!set_abilityIdsDB.contains(abilityId)) {
                set_missingAbilityIds.add(abilityId);
            }
        }

        List<PKM_Ability__c> list_abilities = new List<PKM_Ability__c>();
        for(integer abilityId : set_missingAbilityIds){
            list_abilities.add(getAbility(abilityId));
        }

        return list_abilities;
    }
    
    // Replaces Json values that are not valid Apex field names
    public static string formatJsonToValidApex(string pokemonJson)
    {
        pokemonJson = pokemonJson.replace('"id"','"Id_PKM"');
        pokemonJson = pokemonJson.replace('"official-artwork"','"officialArtwork"');
        return pokemonJson;
    }
    
    public static string replaceNextLine(string pokeApiText)
    {
        return pokeApiText.replace('','\r\n');
    }

    public static integer getIdFromUrl(String url)
    {
        string[] urlSplit = url.split('/');
        return Integer.valueOf(urlSplit[urlSplit.size() - 1]);
    }
}