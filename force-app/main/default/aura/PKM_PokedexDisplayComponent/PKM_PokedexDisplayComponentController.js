({
	doInit: function(component, event, helper)
    {
        helper.getPokemonData(component, component.get("v.pokemonId"));
    },
    
    pokemonIdChanged: function(component, event, helper)
    {
        helper.getPokemonData(component, component.get("v.pokemonId"));
    }
})