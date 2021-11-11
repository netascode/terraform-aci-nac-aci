*** Settings ***
Documentation   Verify Remote Location
Suite Setup     Login MSO
Default Tags    mso   config   day0
Resource        ../../mso_common.resource

*** Test Cases ***
Get Remote Locations
    GET   "/api/v1/platform/remote-locations"

{% for remote in mso.remote_locations | default([]) %}

Verify Remote Location {{ remote.name }}
    ${remote}=   Set Variable   $..remoteLocations[?(@.name=='{{ remote.name }}')]
    String   ${remote}.name   {{ remote.name }}
    String   ${remote}.description   {{ remote.description | default() }}
    String   ${remote}.credential.hostname   {{ remote.hostname_ip }}
    Integer   ${remote}.credential.port   {{ remote.port | default(defaults.mso.remote_locations.port) }}
    String   ${remote}.credential.remotePath   {{ remote.path | default(defaults.mso.remote_locations.path) }}
    String   ${remote}.credential.protocolType   {{ remote.protocol | default(defaults.mso.remote_locations.protocol) }}
    String   ${remote}.credential.authType   {{ remote.authentication | default(defaults.mso.remote_locations.authentication) }}

{% endfor %}
