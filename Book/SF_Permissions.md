### [SF Book](../README.md)

# Emails

Salesforce offers a myriad of ways to grant permissions to users.

## Permission Sets

Create a set of permissions that can be assigned to users and groups.

### Permission Set Groups

Permission Sets can be grouped in a single place.

### Checking PS assignments

Using SOQL the assignments to Permission Sets and groups can be checked via PermissionSetAssignment.

    SELECT Id, Assignee.name, PermissionSet.name, PermissionSetGroup.DeveloperName from PermissionSetAssignment

To check which permission sets a PS Group has:

    SELECT id, PermissionSet.name from PermissionSetGroupComponent where PermissionSetGroupId = myGroup

NOTES:
* If a permission set is granted by a group it won't be shown in the SOQL query, the group will be shown instead.
* If a PS is assigned to a user group, it'll be linked to the group, not to each user in the SOQL query.

## Custom permissions

Custom permissions can be created via Setup > Custom Permissions. These can be then assigned to permission sets.\
To check if the running user has a custom permission via Apex, FeatureManagement can be used.

    Boolean hasCustomPermission = FeatureManagement.checkPermission('your_custom_permission_api_name');