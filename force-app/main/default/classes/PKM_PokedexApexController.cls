public without sharing class PKM_PokedexApexController
{
    @AuraEnabled
    public static List<PKM_Species__c> fetchPokemonList()
    {
        return [SELECT Id_PKM__c, Name,
                                         Type1__r.Name, Type2__r.Name, 
                                         Ability1__r.Name, Ability2__r.Name, Ability3__r.Name,
                                         ArtworkURL__c, SpriteURL__c,
                                         Description__c
                                    FROM PKM_Species__c
                                ORDER BY Id_PKM__c ASC];
    }
    
    @AuraEnabled
    public static PokemonData getPokemonData(integer pokemonId)
    {
        PKM_Species__c pokemon = [SELECT Id_PKM__c, Name,
                                         Type1__r.Name, Type2__r.Name, 
                                         Ability1__r.Name, Ability2__r.Name, Ability3__r.Name,
                                         ArtworkURL__c, SpriteURL__c,
                                         Description__c
                                    FROM PKM_Species__c
                                    WHERE Id_PKM__c = :pokemonId
                                    LIMIT 1];
        
        System.debug('Pokemon found: ' + pokemon);
        
        return new PokemonData(pokemon.Id_PKM__c, pokemon.Name, 
                               pokemon.Type1__r.Name, pokemon.Type2__r.Name, 
                               pokemon.Ability1__r.Name, pokemon.Ability2__r.Name, pokemon.Ability3__r.Name,
                               pokemon.ArtworkURL__c, pokemon.SpriteURL__c, pokemon.Description__c);
    }
    
    public class PokemonData
    {
        @AuraEnabled public integer id;
        @AuraEnabled public string name;
        @AuraEnabled public string type1;
        @AuraEnabled public string type2;
        @AuraEnabled public string ability1;
        @AuraEnabled public string ability2;
        @AuraEnabled public string ability3;
        @AuraEnabled public string artworkUrl;
        @AuraEnabled public string spriteUrl;
        @AuraEnabled public string description;
        
        public PokemonData (Decimal id, string name, 
                            string type1, string type2, 
                            string ability1, string ability2, string ability3, 
                            string artworkUrl, string spriteUrl, 
                            string description)
        {
            this.id = (integer) id;
            this.name = name;
            this.type1 = type1;
            this.type2 = type2;
            this.ability1 = ability1;
            this.ability2 = ability2;
            this.ability3 = ability3;
            this.artworkUrl = artworkUrl;
            this.spriteUrl = spriteUrl;
            this.description = description;
        }
    }
}