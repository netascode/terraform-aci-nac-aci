*** Settings ***
Documentation   Verify Remote Location
Suite Setup     Login NDO
Default Tags    ndo   config   day0
Resource        ../../ndo_common.resource

*** Test Cases ***
Get Remote Locations
    ${r}=   GET On Session   ndo   /api/v1/platform/remote-locations
    Set Suite Variable   ${r}

{% for remote in ndo.remote_locations | default([]) %}

Verify Remote Location {{ remote.name }}
    ${remote}=   Set Variable   $..remoteLocations[?(@.name=='{{ remote.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${remote}.name   {{ remote.name }}
    Should Be Equal Value Json String   ${r.json()}   ${remote}.description   {{ remote.description | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${remote}.credential.hostname   {{ remote.hostname_ip }}
    Should Be Equal Value Json Integer   ${r.json()}   ${remote}.credential.port   {{ remote.port | default(defaults.ndo.remote_locations.port) }}
    Should Be Equal Value Json String   ${r.json()}   ${remote}.credential.remotePath   {{ remote.path | default(defaults.ndo.remote_locations.path) }}
    Should Be Equal Value Json String   ${r.json()}   ${remote}.credential.protocolType   {{ remote.protocol | default(defaults.ndo.remote_locations.protocol) }}
    Should Be Equal Value Json String   ${r.json()}   ${remote}.credential.authType   {{ remote.authentication | default(defaults.ndo.remote_locations.authentication) }}

{% endfor %}
