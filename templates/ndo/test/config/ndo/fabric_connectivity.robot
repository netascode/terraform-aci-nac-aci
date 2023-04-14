*** Settings ***
Documentation   Verify Fabric Connectivity
Suite Setup     Login NDO
Default Tags    ndo   config   day1
Resource        ../../ndo_common.resource

*** Test Cases ***
Get Fabric Connectivity
    ${r}=   GET On Session   ndo   /api/v1/sites/fabric-connectivity
    Set Suite Variable   ${r}

{% set ns = namespace(sites = 0) %}
{% for site in ndo.sites | default([]) %}
    {% if site.multisite | default(defaults.ndo.sites.multisite) == "enabled" %}
        {% set ns.sites = ns.sites + 1 %}
    {% endif %}
{% endfor %}
{% if ns.sites > 0 %}

Verify Fabric Connectivity
    Should Be Equal Value Json String   ${r.json()}   $..controlPlaneBgpConfig.peeringType   {{ ndo.fabric_connectivity.bgp.peering_type | default(defaults.ndo.fabric_connectivity.bgp.peering_type) }}
    Should Be Equal Value Json Integer   ${r.json()}   $..controlPlaneBgpConfig.ttl   {{ ndo.fabric_connectivity.bgp.ttl | default(defaults.ndo.fabric_connectivity.bgp.ttl) }}
    Should Be Equal Value Json Integer   ${r.json()}   $..controlPlaneBgpConfig.keepAliveInterval   {{ ndo.fabric_connectivity.bgp.keepalive_interval | default(defaults.ndo.fabric_connectivity.bgp.keepalive_interval) }}
    Should Be Equal Value Json Integer   ${r.json()}   $..controlPlaneBgpConfig.holdInterval   {{ ndo.fabric_connectivity.bgp.hold_interval | default(defaults.ndo.fabric_connectivity.bgp.hold_interval) }}
    Should Be Equal Value Json Integer   ${r.json()}   $..controlPlaneBgpConfig.staleInterval   {{ ndo.fabric_connectivity.bgp.stale_interval | default(defaults.ndo.fabric_connectivity.bgp.stale_interval) }}
    Should Be Equal Value Json Boolean   ${r.json()}   $..controlPlaneBgpConfig.gracefulRestartEnabled   {% if ndo.fabric_connectivity.bgp.graceful_restart | default(defaults.ndo.fabric_connectivity.bgp.graceful_restart) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json Integer   ${r.json()}   $..controlPlaneBgpConfig.maxAsLimit   {{ ndo.fabric_connectivity.bgp.max_as | default(defaults.ndo.fabric_connectivity.bgp.max_as) }}

{% for site in ndo.sites | default([]) %}
{% if site.multisite | default(defaults.ndo.sites.multisite) == "enabled" %}
{% set routed_domain_name = site.routed_domain | default() ~ defaults.ndo.sites.routed_domain_suffix %}

Verify Fabric Connectivity Site {{ site.name }}
    ${site}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')]
    Should Be Equal Value Json String   ${r.json()}   ${site}.id   %%sites%{{ site.name }}%%
    Should Be Equal Value Json Integer   ${r.json()}   ${site}.apicSiteId   {{ site.id }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${site}.msiteEnabled   {% if site.multisite | default(defaults.ndo.sites.multisite) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   ${site}.msiteDataPlaneMulticastTep   {{ site.multicast_tep | default() }}
    Should Be Equal Value Json Integer   ${r.json()}   ${site}.bgpAsn   {{ site.bgp.as | default() }}
    Should Be Equal Value Json String   ${r.json()}   ${site}.ospfAreaId   {{ site.ospf.area_id | default(defaults.ndo.sites.ospf.area_id) }}
    Should Be Equal Value Json String   ${r.json()}   ${site}.ospfAreaType   {{ site.ospf.area_type | default(defaults.ndo.sites.ospf.area_type) }}
    Should Be Equal Value Json String   ${r.json()}   ${site}.externalRoutedDomain   uni/l3dom-{{ routed_domain_name }}

{% for pol in site.ospf_policies | default([]) %}
{% set ctrl = [] %}
{% if pol.advertise_subnet | default(defaults.ndo.sites.ospf_policies.advertise_subnet) == "enabled" %}{% set ctrl = ctrl + [('advertise-subnet')] %}{% endif %}
{% if pol.bfd | default(defaults.ndo.sites.ospf_policies.bfd) == "enabled" %}{% set ctrl = ctrl + [('bfd')] %}{% endif %}
{% if pol.mtu_ignore | default(defaults.ndo.sites.ospf_policies.mtu_ignore) == "enabled" %}{% set ctrl = ctrl + [('mtu-ignore')] %}{% endif %}
{% if pol.passive_interface | default(defaults.ndo.sites.ospf_policies.passive_interface) == "enabled" %}{% set ctrl = ctrl + [('passive-participation')] %}{% endif %}
{% set pol_name = pol.name ~ defaults.ndo.sites.ospf_policies.name_suffix %}

Verify Fabric Connectivity Site {{ site.name }} OSPF Policy {{ pol_name }}
    ${pol}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].ospfPolicies[?(@.name=='{{ pol_name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${pol}.name   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   ${pol}.networkType   {{ pol.network_type | default(defaults.ndo.sites.ospf_policies.network_type) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${pol}.priority   {{ pol.priority | default(defaults.ndo.sites.ospf_policies.priority) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${pol}.interfaceCost   {{ pol.interface_cost | default(defaults.ndo.sites.ospf_policies.interface_cost) }}
    ${list} =   Create List   {{ ctrl | join('   ') }}
    Should Be Equal Value Json List   ${r.json()}    ${pol}.interfaceControls   ${list}
    Should Be Equal Value Json Integer   ${r.json()}   ${pol}.helloInterval   {{ pol.hello_interval | default(defaults.ndo.sites.ospf_policies.hello_interval) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${pol}.deadInterval   {{ pol.dead_interval | default(defaults.ndo.sites.ospf_policies.dead_interval) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${pol}.retransmitInterval   {{ pol.retransmit_interval | default(defaults.ndo.sites.ospf_policies.retransmit_interval) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${pol}.transmitDelay   {{ pol.retransmit_delay | default(defaults.ndo.sites.ospf_policies.retransmit_delay) }}

{% endfor %}

{% for pod in site.pods | default([]) %}

Verify Fabric Connectivity Site {{ site.name }} Pod {{ pod.id | default(defaults.sites.pods.id) }}
    ${pod}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].pods[?(@.podId=={{ pod.id | default(defaults.sites.pods.id) }})]
    Should Be Equal Value Json Integer   ${r.json()}   ${pod}.podId   {{ pod.id | default(defaults.sites.pods.id) }}
    Should Be Equal Value Json String   ${r.json()}   ${pod}.name   pod-{{ pod.id | default(defaults.sites.pods.id) }}
    Should Be Equal Value Json String   ${r.json()}   ${pod}.msiteDataPlaneUnicastTep   {{ pod.unicast_tep | default() }}

{% for spine in pod.spines | default([]) %}

Verify Fabric Connectivity Site {{ site.name }} Pod {{ pod.id | default(defaults.sites.pods.id) }} Spine {{ spine.id }}
    ${spine}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].pods[?(@.podId=={{ pod.id | default(defaults.sites.pods.id) }})].spines[?(@.nodeId=={{ spine.id }})]
    Should Be Equal Value Json Integer   ${r.json()}   ${spine}.nodeId   {{ spine.id }}
    Should Be Equal Value Json String   ${r.json()}   ${spine}.name   {{ spine.name }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${spine}.bgpPeeringEnabled   {% if spine.bgp_peering | default(defaults.ndo.sites.pods.spines.bgp_peering) == "enabled" %}true{% else %}false{% endif %} 
    Should Be Equal Value Json String   ${r.json()}   ${spine}.msiteControlPlaneTep   {{ spine.control_plane_tep }}
    Should Be Equal Value Json Boolean   ${r.json()}   ${spine}.routeReflectorEnabled   {% if spine.bgp_route_reflector | default(defaults.ndo.sites.pods.spines.bgp_route_reflector) == "enabled" %}true{% else %}false{% endif %} 

{% for interface in spine.interfaces | default([]) %}
{% set pol_name = interface.ospf.policy ~ defaults.ndo.sites.ospf_policies.name_suffix %}

Verify Fabric Connectivity Site {{ site.name }} Pod {{ pod.id | default(defaults.sites.pods.id) }} Spine {{ spine.id }} Interface {{ interface.module | default(defaults.ndo.sites.pods.spines.interfaces.module) }}/{{ interface.port }}
    ${int}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].pods[?(@.podId=={{ pod.id | default(defaults.sites.pods.id) }})].spines[?(@.nodeId=={{ spine.id }})].ports[?(@.portId=='{{ interface.module | default(defaults.ndo.sites.pods.spines.interfaces.module) }}/{{ interface.port }}')]
    Should Be Equal Value Json String   ${r.json()}   ${int}.portId   {{ interface.module | default(defaults.ndo.sites.pods.spines.interfaces.module) }}/{{ interface.port }}
    Should Be Equal Value Json String   ${r.json()}   ${int}.ipAddress   {{ interface.ip }}
    Should Be Equal Value Json String   ${r.json()}   ${int}.mtu   {{ interface.mtu | default(defaults.ndo.sites.pods.spines.interfaces.mtu) }}
    Should Be Equal Value Json String   ${r.json()}   ${int}.routingPolicy   {{ pol_name }}
    Should Be Equal Value Json String   ${r.json()}   ${int}.ospfAuthType   {{ interface.ospf.authentication_type | default(defaults.ndo.sites.pods.spines.interfaces.ospf.authentication_type) }}
    Should Be Equal Value Json Integer   ${r.json()}   ${int}.ospfAuthKeyId   {{ interface.ospf.authentication_key_id | default(defaults.ndo.sites.pods.spines.interfaces.ospf.authentication_key_id) }}

{% endfor %}

{% endfor %}

{% endfor %}

{% endif %}
{% endfor %}

{% endif %}
