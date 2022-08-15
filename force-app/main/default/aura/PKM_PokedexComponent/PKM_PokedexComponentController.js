({
	doInit: function(component, event, helper)
    {
        //component.set("v.selectedPokemonId","1");
        helper.fetchPokemonList(component);
    },
    
    handleClick: function(component, event, helper)
    {
        component.set("v.selectedPokemonId",component.get("v.selectedPokemonId")+1);
        console.log("selectedPokemonId: " + component.get("v.selectedPokemonId"));
    },
    
    pokemonSelected: function(component, event, helper)
    {
        console.log("Pokemon selected: " + JSON.stringify(event.currentTarget.dataset.pokemonid));
        component.set("v.selectedPokemonId", event.currentTarget.dataset.pokemonid);
    }
})