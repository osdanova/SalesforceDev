({
    getPokemonData : function(component, pokemonId)
    {
		var action = component.get("c.getPokemonData");
        action.setParam("pokemonId",pokemonId);
        console.log('Calling Action');
        console.log('pokemonId: ' + pokemonId);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("Success fetching data");
                console.log("Response: " + JSON.stringify(response.getReturnValue()));
                component.set("v.pokemon", response.getReturnValue());
            }
            else if (state === "ERROR")
            {
                console.log("Error fetching data");
            }
        });
        $A.enqueueAction(action);
	}
})