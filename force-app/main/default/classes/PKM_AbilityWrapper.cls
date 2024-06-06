public class PKM_AbilityWrapper
{
    public integer Id_PKM;
    public string name;
    
    public static PKM_AbilityWrapper fromJson(string abilityJson)
    {
        abilityJson = PKM_PokeAPI.formatJsonToValidApex(abilityJson);
        PKM_AbilityWrapper abilityWrapper = (PKM_AbilityWrapper) Json.deserialize(abilityJson, PKM_AbilityWrapper.Class);
        return abilityWrapper;
    }

    public PKM_Ability__c toAbility()
    {
        PKM_Ability__c ability = new PKM_Ability__c();
        ability.Id_PKM__c = Id_PKM;
        ability.name = name;

        return ability;
    }
}