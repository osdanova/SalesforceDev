@isTest
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
    
    public static MultiStaticResourceCalloutMock getMultiResourceMock (Map<string,string> map_endpoint_filename, integer status, Map<String,String> map_headers)
    {
        MultiStaticResourceCalloutMock mock = new MultiStaticResourceCalloutMock();
        for (string endpoint : map_endpoint_filename.keyset()) {
            mock.setStaticResource(endpoint, map_endpoint_filename.get(endpoint));
        }
        mock.setStatusCode(status);
        for (string header : map_headers.keyset()) {
            mock.setHeader(header, map_headers.get(header));
        }
        
        return mock;
    }
    public static MultiStaticResourceCalloutMock getMultiResourceMock (Map<string,string> map_endpoint_filename)
    {
        return(getMultiResourceMock (map_endpoint_filename, 200, new Map<String,String> {'Content-Type' => 'application/json'}));
    }
}