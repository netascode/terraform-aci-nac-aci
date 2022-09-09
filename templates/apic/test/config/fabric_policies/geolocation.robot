*** Settings ***
Documentation   Verify Geolocation Policies
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
{% for site in apic.fabric_policies.geolocation.sites | default([]) %}

Verify Site {{ site.name }}
    ${r}=   GET On Session   apic   /api/mo/uni/fabric/site-{{ site.name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..geoSite.attributes.name   {{ site.name }}
    Should Be Equal Value Json String   ${r.json()}    $..geoSite.attributes.descr   {{ site.description | default() }}

{% for building in site.buildings | default([]) %}

Verify Site {{ site.name }} Building {{ building.name }}
    ${building}=   Set Variable   $..geoSite.children[?(@.geoBuilding.attributes.name=='{{ building.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${building}..geoBuilding.attributes.name   {{ building.name }}
    Should Be Equal Value Json String   ${r.json()}    ${building}..geoBuilding.attributes.descr   {{ building.description | default() }}

{% for floor in building.floors | default([]) %}

Verify Site {{ site.name }} Building {{ building.name }} Floor {{ floor.name }}
    ${floor}=   Set Variable   $..geoSite.children[?(@.geoBuilding.attributes.name=='{{ building.name }}')].geoBuilding.children[?(@.geoFloor.attributes.name=='{{ floor.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${floor}..geoFloor.attributes.name   {{ floor.name }}
    Should Be Equal Value Json String   ${r.json()}    ${floor}..geoFloor.attributes.descr   {{ floor.description | default() }}

{% for room in floor.rooms | default([]) %}

Verify Site {{ site.name }} Building {{ building.name }} Floor {{ floor.name }} Room {{ room.name }}
    ${room}=   Set Variable   $..geoSite.children[?(@.geoBuilding.attributes.name=='{{ building.name }}')].geoBuilding.children[?(@.geoFloor.attributes.name=='{{ floor.name }}')].geoFloor.children[?(@.geoRoom.attributes.name=='{{ room.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${room}..geoRoom.attributes.name   {{ room.name }}
    Should Be Equal Value Json String   ${r.json()}    ${room}..geoRoom.attributes.descr   {{ room.description | default() }}

{% for row in room.rows | default([]) %}

Verify Site {{ site.name }} Building {{ building.name }} Floor {{ floor.name }} Room {{ room.name }} Row {{ row.name }}
    ${row}=   Set Variable   $..geoSite.children[?(@.geoBuilding.attributes.name=='{{ building.name }}')].geoBuilding.children[?(@.geoFloor.attributes.name=='{{ floor.name }}')].geoFloor.children[?(@.geoRoom.attributes.name=='{{ room.name }}')].geoRoom.children[?(@.geoRow.attributes.name=='{{ row.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${row}..geoRow.attributes.name   {{ row.name }}
    Should Be Equal Value Json String   ${r.json()}    ${row}..geoRow.attributes.descr   {{ row.description | default() }}

{% for rack in row.racks | default([]) %}

Verify Site {{ site.name }} Building {{ building.name }} Floor {{ floor.name }} Room {{ room.name }} Row {{ row.name }} Rack {{ rack.name }}
    ${rack}=   Set Variable   $..geoSite.children[?(@.geoBuilding.attributes.name=='{{ building.name }}')].geoBuilding.children[?(@.geoFloor.attributes.name=='{{ floor.name }}')].geoFloor.children[?(@.geoRoom.attributes.name=='{{ room.name }}')].geoRoom.children[?(@.geoRow.attributes.name=='{{ row.name }}')].geoRow.children[?(@.geoRack.attributes.name=='{{ rack.name }}')]
    Should Be Equal Value Json String   ${r.json()}    ${rack}..geoRack.attributes.name   {{ rack.name }}
    Should Be Equal Value Json String   ${r.json()}    ${rack}..geoRack.attributes.descr   {{ rack.description | default() }}

{% for node in rack.nodes | default([]) %}
{% set query = "nodes[?id==`" ~ node ~ "`].pod" %}
{% set pod = (apic.node_policies | community.general.json_query(query))[0] | default('1') %}

Verify Site {{ site.name }} Building {{ building.name }} Floor {{ floor.name }} Room {{ room.name }} Row {{ row.name }} Rack {{ rack.name }} Node {{ node }}
    ${node}=   Set Variable   $..geoSite.children[?(@.geoBuilding.attributes.name=='{{ building.name }}')].geoBuilding.children[?(@.geoFloor.attributes.name=='{{ floor.name }}')].geoFloor.children[?(@.geoRoom.attributes.name=='{{ room.name }}')].geoRoom.children[?(@.geoRow.attributes.name=='{{ row.name }}')].geoRow.children[?(@.geoRack.attributes.name=='{{ rack.name }}')].geoRack.children[?(@.geoRsNodeLocation.attributes.tDn=='topology/pod-{{ pod }}/node-{{ node }}')]
    Should Be Equal Value Json String   ${r.json()}    ${node}..geoRsNodeLocation.attributes.tDn   topology/pod-{{ pod }}/node-{{ node }}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}
