public class Util_CalloutMock
{
    public static StaticResourceCalloutMock getResourceMock (string filename, integer status, Map<String,String> map_headers)
    {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(filename);
        mock.setStatusCode(status);
        for(string header : map_headers.keyset()){
            mock.setHeader(header, map_headers.get(header));
        }
        
        return mock;
    }
    public static StaticResourceCalloutMock getResourceMock (string filename)
    {
        return(getResourceMock (filename, 200, new Map<String,String> {'Content-Type' => 'application/json'}));
    }
}