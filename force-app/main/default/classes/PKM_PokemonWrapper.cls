public class PKM_PokemonWrapper
{
    // -------------------------------
    // Typed version
    // - Cleaner
    // - Field names may have invalid characters
    // - All fields are initialized to null
    // - Can be reused to send the data back in the same format

    public integer Id_PKM;
    public string name;
    public Sprites sprites;
    public List<Abilities> abilities;
    public List<Types> types;
    
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

    public class Abilities
    {
        public integer slot;
        public Ability ability;
        public boolean is_hidden;
    }
    public class Ability
    {
        public string url;

        public integer getId() {
            return PKM_PokeAPI.getIdFromUrl(url);
        }
    }

    public class Types
    {
        public integer slot;
        public Type type;
    }
    public class Type
    {
        public string url;

        public integer getId() {
            return PKM_PokeAPI.getIdFromUrl(url);
        }
    }
    
    public static PKM_PokemonWrapper fromJson(string pokemonJson)
    {
        pokemonJson = PKM_PokeAPI.formatJsonToValidApex(pokemonJson);
        PKM_PokemonWrapper pokemonWrapper = (PKM_PokemonWrapper) Json.deserialize(pokemonJson, PKM_PokemonWrapper.Class);
        return pokemonWrapper;
    }

    public PKM_Species__c toSpecies()
    {
        PKM_Species__c species = new PKM_Species__c();
        species.Id_PKM__c = Id_PKM;
        species.name = name;
        species.SpriteURL__c = sprites.front_default;
        species.ArtworkURL__c = sprites.other.officialArtwork.front_default;
        for(Types type : types)
        {
            switch on type.slot
            {
                when 1 {
                    species.Type1__r = new PKM_Type__c(Id_PKM__c = type.type.getId());
                }
                when 2 {
                    species.Type2__r = new PKM_Type__c(Id_PKM__c = type.type.getId());
                }
            }
        }
        for(Abilities ability : abilities)
        {
            switch on ability.slot
            {
                when 1 {
                    species.Ability1__r = new PKM_Ability__c(Id_PKM__c = ability.ability.getId());
                }
                when 2 {
                    species.Ability2__r = new PKM_Ability__c(Id_PKM__c = ability.ability.getId());
                }
                when 3 {
                    species.Ability3__r = new PKM_Ability__c(Id_PKM__c = ability.ability.getId());
                }
            }
        }

        return species;
    }

    // -------------------------------
    // Untyped version
    // - Field names should be no problem
    // - The output object doesn't initialize its fields to null
    // - Easier to make mistakes
    // - Better suited for directly mapping an object

    public static PKM_Species__c parsePokemonJson (string speciesJson)
    {
        Map<String, Object> map_deserializedJson =  (Map<String, Object>) JSON.deserializeUntyped(speciesJson);
        
        PKM_Species__c species = new PKM_Species__c();
        
        if(map_deserializedJson.containsKey('id')) species.Id_PKM__c = (Decimal) map_deserializedJson.get('id');
        if(map_deserializedJson.containsKey('name')) species.Name = (String) map_deserializedJson.get('name');
        if(map_deserializedJson.containsKey('sprites'))
        {
            Map<String, Object> map_sprites = (Map<String, Object>) map_deserializedJson.get('sprites');
            if(map_sprites.containsKey('front_default')) species.SpriteURL__c = (String) map_sprites.get('front_default');
            if(map_sprites.containsKey('other'))
            {
                Map<String, Object> map_other = (Map<String, Object>) map_sprites.get('other');
                if(map_other.containsKey('official-artwork'))
                {
                    Map<String, Object> map_officialArtwork = (Map<String, Object>) map_other.get('official-artwork');
                    if(map_officialArtwork.containsKey('front_default')) species.ArtworkURL__c = (String) map_officialArtwork.get('front_default');
                }
            }
        }
        if(map_deserializedJson.containsKey('abilities'))
        {
            List<Object> list_abilities = (List<Object>) map_deserializedJson.get('abilities');
            for(Object abilityContainer : list_abilities)
            {
                Map<String, Object> map_abilityContainer = (Map<String, Object>) abilityContainer;
                if(map_abilityContainer.containsKey('ability'))
                {
                    Map<String, Object> map_ability = (Map<String, Object>) map_abilityContainer.get('ability');
                }
            }
        }

        return species;
    }
}