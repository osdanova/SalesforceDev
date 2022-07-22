public class PKM_PokeAPI
{
    public static final string baseUrl = 'https://pokeapi.co/api/v2/';
    
    public static string fetchPokemon(integer identifier)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(baseUrl + 'pokemon/' + identifier);
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }
    
    public static PKM_PokemonWrapper getPokemon(integer identifier)
    {
        return PKM_PokemonWrapper.fromJson(fetchPokemon(identifier));
    }

    public static void upsertPokemonSpecies(integer identifier)
    {
        PKM_PokemonWrapper pokeWrapper = getPokemon(identifier);
        
        if(pokeWrapper?.pokemonId == null){
            System.debug('Error fetching pokemon data');
            return;
        }
        
        PKM_Species__c species = new PKM_Species__c();
        species.Id_PKM__c = pokeWrapper.pokemonId;
        species.name = pokeWrapper.name;
        species.SpriteURL__c = pokeWrapper.sprites.front_default;
        species.ArtworkURL__c = pokeWrapper.sprites.other.officialArtwork.front_default;
        
        Database.upsert(new List<PKM_Species__c> {species}, PKM_Species__c.Id_PKM__c);
    }
}