@isTest
public class Util_CalloutMock_Test
{
    @isTest
    public static void test_getResourceMock()
    {
        Util_CalloutMock.getResourceMock ('TEST');
    }

    @isTest
    public static void test_getMultiResourceMock()
    {
        Util_CalloutMock.getMultiResourceMock (new Map<String,String> {'www.google.com' => 'TEST'});
    }
}