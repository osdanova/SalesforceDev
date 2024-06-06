public class PKM_TypeWrapper
{
    public integer Id_PKM;
    public string name;
    
    public static PKM_TypeWrapper fromJson(string typeJson)
    {
        typeJson = PKM_PokeAPI.formatJsonToValidApex(typeJson);
        PKM_TypeWrapper typeWrapper = (PKM_TypeWrapper) Json.deserialize(typeJson, PKM_TypeWrapper.Class);
        return typeWrapper;
    }

    public PKM_Type__c toType()
    {
        PKM_Type__c type = new PKM_Type__c();
        type.Id_PKM__c = Id_PKM;
        type.name = name;

        return type;
    }
}