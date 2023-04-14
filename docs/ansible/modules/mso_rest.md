# mso_rest

This module enables management of NDO (Nexus Dashboard Orchestrator) through direct access to the REST API. NDO assigns unique IDs to each object which then need to be referenced if the object is to be modified or deleted. In order to allow the user to modify/delete objects without knowing its ID in advance, wherever an ID needs to be inserted it can be replaced with a placeholder (format: ```%%API_ENDPOINT%OBJECT_KEY%%```). This placeholder will then be resolved during runtime. ```API_ENDPOINT``` is the respective API endpoint of that object, and OBJECT_KEY is an attribute that is used as a unique key (eg. its name). The supported API endpoints and the objects key attribute are defined in ```module_utils/mso.py```.

## Parameters

Parameter | Type | Mandatory | Comments
----------|------|-----------|---------
**method** | choice [delete, get, post, put, patch, post_or_put] | yes | HTTP(S) request method
**path** | string | yes |  URI being used to execute API calls
**src** | string | no |  Name of the absolute path of the filename that includes the body of the HTTP request being sent to the NDO
**content** | string | no |  When used instead of ```src```, sets the payload of the API request directly
