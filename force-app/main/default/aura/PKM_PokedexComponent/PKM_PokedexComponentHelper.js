({
	fetchPokemonList : function(component, event, helper)
    {
		var action = component.get("c.fetchPokemonList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("Success fetching data");
                console.log("Response: " + JSON.stringify(response.getReturnValue()));
                component.set("v.pokemonList", response.getReturnValue());
            }
            else if (state === "ERROR")
            {
                console.log("Error fetching data");
                console.log("Message: " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	}
})