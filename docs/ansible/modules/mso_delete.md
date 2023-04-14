# mso_delete

This module is used to compare a list of object keys (from the inventory) with the currently configured objects within NDO. If an object is configured within NDO but missing from the provided list of object keys it will be deleted subsequently. There are certain module options to define attributes/values which would indicate that the object should not be considered for deletion.

## Parameters

Parameter | Type | Mandatory | Comments
----------|------|-----------|---------
**path** | string | yes | URI being used to execute API calls
**desired** | list<<string\>\> | no | List of desired object keys, all others will be deleted
**ignore** | list<<string\>\> | no | List of attribute values to ignore
**ignore_attr** | list<<string\>\> | no | List of attributes to consider to ignore
