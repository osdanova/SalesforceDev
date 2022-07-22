public class PKM_PokemonWrapper
{
    public string name;
    public Sprites sprites;
    public integer pokemonId;
    
    public class Sprites
    {
        public string front_default;
        public Sprites_other other;
    }
    public class Sprites_other
    {
        public Sprites_other_officialArtwork officialArtwork;
    }
    
    public class Sprites_other_officialArtwork
    {
        public string front_default;
    }
    
    public static PKM_PokemonWrapper fromJson(string pokemonJson)
    {
        pokemonJson = formatJsonToValidApex(pokemonJson);
        PKM_PokemonWrapper pokemonWrapper = (PKM_PokemonWrapper) Json.deserialize(pokemonJson, PKM_PokemonWrapper.Class);
        return pokemonWrapper;
    }
    
    public static string formatJsonToValidApex(string pokemonJson)
    {
        pokemonJson = pokemonJson.replace('"id"','"pokemonId"');
        pokemonJson = pokemonJson.replace('"official-artwork"','"officialArtwork"');
        return pokemonJson;
    }
}