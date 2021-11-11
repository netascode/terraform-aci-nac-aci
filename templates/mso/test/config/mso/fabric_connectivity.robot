*** Settings ***
Documentation   Verify Fabric Connectivity
Suite Setup     Login MSO
Default Tags    mso   config   day1
Resource        ../../mso_common.resource

*** Test Cases ***
Get Fabric Connectivity
    GET   "/api/v1/sites/fabric-connectivity"

{% set ns = namespace(sites = 0) %}
{% for site in mso.sites | default([]) %}
    {% if site.multisite | default(defaults.mso.sites.multisite) == "enabled" %}
        {% set ns.sites = ns.sites + 1 %}
    {% endif %}
{% endfor %}
{% if ns.sites > 0 %}

Verify Fabric Connectivity
    String   $..controlPlaneBgpConfig.peeringType   {{ mso.fabric_connectivity.bgp.peering_type | default(defaults.mso.fabric_connectivity.bgp.peering_type) }}
    Integer   $..controlPlaneBgpConfig.ttl   {{ mso.fabric_connectivity.bgp.ttl | default(defaults.mso.fabric_connectivity.bgp.ttl) }}
    Integer   $..controlPlaneBgpConfig.keepAliveInterval   {{ mso.fabric_connectivity.bgp.keepalive_interval | default(defaults.mso.fabric_connectivity.bgp.keepalive_interval) }}
    Integer   $..controlPlaneBgpConfig.holdInterval   {{ mso.fabric_connectivity.bgp.hold_interval | default(defaults.mso.fabric_connectivity.bgp.hold_interval) }}
    Integer   $..controlPlaneBgpConfig.staleInterval   {{ mso.fabric_connectivity.bgp.stale_interval | default(defaults.mso.fabric_connectivity.bgp.stale_interval) }}
    Boolean   $..controlPlaneBgpConfig.gracefulRestartEnabled   {% if mso.fabric_connectivity.bgp.graceful_restart | default(defaults.mso.fabric_connectivity.bgp.graceful_restart) == "enabled" %}true{% else %}false{% endif %} 
    Integer   $..controlPlaneBgpConfig.maxAsLimit   {{ mso.fabric_connectivity.bgp.max_as | default(defaults.mso.fabric_connectivity.bgp.max_as) }}

{% for site in mso.sites | default([]) %}
{% if site.multisite | default(defaults.mso.sites.multisite) == "enabled" %}
{% set routed_domain_name = site.routed_domain | default() ~ defaults.mso.sites.routed_domain_suffix %}

Verify Fabric Connectivity Site {{ site.name }}
    ${site}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')]
    String   ${site}.id   %%sites%{{ site.name }}%%
    Integer   ${site}.apicSiteId   {{ site.id }}
    Boolean   ${site}.msiteEnabled   {% if site.multisite | default(defaults.mso.sites.multisite) == "enabled" %}true{% else %}false{% endif %} 
    String   ${site}.msiteDataPlaneMulticastTep   {{ site.multicast_tep | default() }}
    Integer   ${site}.bgpAsn   {{ site.bgp.as | default() }}
    String   ${site}.ospfAreaId   {{ site.ospf.area_id | default(defaults.mso.sites.ospf.area_id) }}
    String   ${site}.ospfAreaType   {{ site.ospf.area_type | default(defaults.mso.sites.ospf.area_type) }}
    String   ${site}.externalRoutedDomain   uni/l3dom-{{ routed_domain_name }}

{% for pol in site.ospf_policies | default([]) %}
{% set ctrl = [] %}
{% if pol.advertise_subnet | default(defaults.mso.sites.ospf_policies.advertise_subnet) == "enabled" %}{% set ctrl = ctrl + [('"advertise-subnet"')] %}{% endif %}
{% if pol.bfd | default(defaults.mso.sites.ospf_policies.bfd) == "enabled" %}{% set ctrl = ctrl + [('"bfd"')] %}{% endif %}
{% if pol.mtu_ignore | default(defaults.mso.sites.ospf_policies.mtu_ignore) == "enabled" %}{% set ctrl = ctrl + [('"mtu-ignore"')] %}{% endif %}
{% if pol.passive_interface | default(defaults.mso.sites.ospf_policies.passive_interface) == "enabled" %}{% set ctrl = ctrl + [('"passive-participation"')] %}{% endif %}
{% set pol_name = pol.name ~ defaults.mso.sites.ospf_policies.name_suffix %}

Verify Fabric Connectivity Site {{ site.name }} OSPF Policy {{ pol_name }}
    ${pol}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].ospfPolicies[?(@.name=='{{ pol_name }}')]
    String   ${pol}.name   {{ pol_name }}
    String   ${pol}.networkType   {{ pol.network_type | default(defaults.mso.sites.ospf_policies.network_type) }}
    Integer   ${pol}.priority   {{ pol.priority | default(defaults.mso.sites.ospf_policies.priority) }}
    Integer   ${pol}.interfaceCost   {{ pol.interface_cost | default(defaults.mso.sites.ospf_policies.interface_cost) }}
    Array   ${pol}.interfaceControls   [{{ ctrl | join(', ') }}]
    Integer   ${pol}.helloInterval   {{ pol.hello_interval | default(defaults.mso.sites.ospf_policies.hello_interval) }}
    Integer   ${pol}.deadInterval   {{ pol.dead_interval | default(defaults.mso.sites.ospf_policies.dead_interval) }}
    Integer   ${pol}.retransmitInterval   {{ pol.retransmit_interval | default(defaults.mso.sites.ospf_policies.retransmit_interval) }}
    Integer   ${pol}.transmitDelay   {{ pol.retransmit_delay | default(defaults.mso.sites.ospf_policies.retransmit_delay) }}

{% endfor %}

{% for pod in site.pods | default([]) %}

Verify Fabric Connectivity Site {{ site.name }} Pod {{ pod.id | default(defaults.sites.pods.id) }}
    ${pod}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].pods[?(@.podId=={{ pod.id | default(defaults.sites.pods.id) }})]
    Integer   ${pod}.podId   {{ pod.id | default(defaults.sites.pods.id) }}
    String   ${pod}.name   pod-{{ pod.id | default(defaults.sites.pods.id) }}
    String   ${pod}.msiteDataPlaneUnicastTep   {{ pod.unicast_tep | default() }}

{% for spine in pod.spines | default([]) %}

Verify Fabric Connectivity Site {{ site.name }} Pod {{ pod.id | default(defaults.sites.pods.id) }} Spine {{ spine.id }}
    ${spine}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].pods[?(@.podId=={{ pod.id | default(defaults.sites.pods.id) }})].spines[?(@.nodeId=={{ spine.id }})]
    Integer   ${spine}.nodeId   {{ spine.id }}
    String   ${spine}.name   {{ spine.name }}
    Boolean   ${spine}.bgpPeeringEnabled   {% if spine.bgp_peering | default(defaults.mso.sites.pods.spines.bgp_peering) == "enabled" %}true{% else %}false{% endif %} 
    String   ${spine}.msiteControlPlaneTep   {{ spine.control_plane_tep }}
    Boolean   ${spine}.routeReflectorEnabled   {% if spine.bgp_route_reflector | default(defaults.mso.sites.pods.spines.bgp_route_reflector) == "enabled" %}true{% else %}false{% endif %} 

{% for interface in spine.interfaces | default([]) %}
{% set pol_name = interface.ospf.policy ~ defaults.mso.sites.ospf_policies.name_suffix %}

Verify Fabric Connectivity Site {{ site.name }} Pod {{ pod.id | default(defaults.sites.pods.id) }} Spine {{ spine.id }} Interface {{ interface.module | default(defaults.mso.sites.pods.spines.interfaces.module) }}/{{ interface.port }}
    ${int}=   Set Variable   $.sites[?(@.id=='%%sites%{{ site.name }}%%')].pods[?(@.podId=={{ pod.id | default(defaults.sites.pods.id) }})].spines[?(@.nodeId=={{ spine.id }})].ports[?(@.portId=='{{ interface.module | default(defaults.mso.sites.pods.spines.interfaces.module) }}/{{ interface.port }}')]
    String   ${int}.portId   {{ interface.module | default(defaults.mso.sites.pods.spines.interfaces.module) }}/{{ interface.port }}
    String   ${int}.ipAddress   {{ interface.ip }}
    String   ${int}.mtu   {{ interface.mtu | default(defaults.mso.sites.pods.spines.interfaces.mtu) }}
    String   ${int}.routingPolicy   {{ pol_name }}
    String   ${int}.ospfAuthType   {{ interface.ospf.authentication_type | default(defaults.mso.sites.pods.spines.interfaces.ospf.authentication_type) }}
    Integer   ${int}.ospfAuthKeyId   {{ interface.ospf.authentication_key_id | default(defaults.mso.sites.pods.spines.interfaces.ospf.authentication_key_id) }}

{% endfor %}

{% endfor %}

{% endfor %}

{% endif %}
{% endfor %}

{% endif %}
