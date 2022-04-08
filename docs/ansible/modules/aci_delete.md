# aci_delete

This module is used to compare the rendered configuration of a certain object with the currently configured objects within ACI. If an object is configured within ACI but missing from the rendered configuration it will be deleted subsequently. Some objects, like ones configured from MSO or objects with a name of "default" will be ignored (not considered for deletion). There are certain module options to define additional attributes/values which would indicate that the object should not be considered for deletion.

## Parameters

Parameter | Type | Mandatory | Comments
----------|------|-----------|---------
**aci_class** | list<<string\>\> | yes | A list of classes that should be be compared, eg. fvTenant
**file** | string | yes | The file (path) with the rendered configuration
**ignore** | list<<string\>\> | no | List of additional attribute values (except ```default```) to ignore
**ignore_attr** | list<<string\>\> | no | List of additional attributes (except ```name```) to consider to ignore
**match_dn** | string | no | A string that must be part of the objects DN, otherwise it is not considered for deletion
**ignore_annotations** | list<<string\>\> | no | A list of annotations to ignore
**only_aac** | bool | no | If `true` only delete objects with `orchestrator:aac` annotation.

## Return Values

Key | Type | Comments
----|------|---------
**deleted_dn** | list<<string\>\> | List of DNs for objects that have been deleted
