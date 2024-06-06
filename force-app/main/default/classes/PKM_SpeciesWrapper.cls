public class PKM_SpeciesWrapper
{
    public integer Id_PKM;
    public string description;
    
    public static PKM_SpeciesWrapper fromJson(string speciesJson)
    {
        Map<String, Object> map_deserializedJson =  (Map<String, Object>) JSON.deserializeUntyped(speciesJson);
        
        PKM_SpeciesWrapper speciesWrapper = new PKM_SpeciesWrapper();
        speciesWrapper.Id_PKM = (integer) map_deserializedJson.get('id');
        List<Object> descEntries = (List<Object>) map_deserializedJson.get('flavor_text_entries');
        Map<String,Object> descEntry = (Map<String,Object>) descEntries.get(0);
        speciesWrapper.description = (string) descEntry.get('flavor_text');
        
        return speciesWrapper;
    }
}