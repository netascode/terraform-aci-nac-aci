# ACI As-Built

The following sections provide an overview of the main ACI Objects configured in the fabric.

## System

This section describes the system wide configuration.

### APIC Connectivity Preferences

<caption name="APIC Connectivity Preferences">

| Properties | Value |
|---|---|
| Interface to use for External Connections: | {{apic.fabric_policies.apic_conn_pref | default(defaults.apic.fabric_policies.apic_conn_pref)}} |
</caption>

### COOP Group Policy

<caption name="COOP Group Policy">

| Properties | Value |
|---|---|
| Type: | {{apic.fabric_policies.coop_group_policy | default(defaults.apic.fabric_policies.coop_group_policy)}} |
</caption>

### Date and Time Format Policy

<caption name="Date and Time Format Policy">

| Properties | Value |
|---|---|
| Display Format: | {{apic.fabric_policies.date_time_format.display_format | default(defaults.apic.fabric_policies.date_time_format.display_format)}} |
| Time Zone: | {{apic.fabric_policies.date_time_format.timezone | default(defaults.apic.fabric_policies.date_time_format.timezone)}} |
| Offset State: |  {{apic.fabric_policies.date_time_format.show_offset | default(defaults.apic.fabric_policies.date_time_format.show_offset)}} |
</caption>

### EP Loop Protection

<caption name="EP Loop Protection">

| Properties | Value |
|---|---|
| Administrative State: |  {{apic.fabric_policies.date_time_format.admin_state | default(defaults.apic.fabric_policies.date_time_format.admin_state)}} |
| Loop Detection Interval: |  {{apic.fabric_policies.date_time_format.detection_interval | default(defaults.apic.fabric_policies.date_time_format.detection_interval)}} |
| Loop Detection Multiplication Factor: |  {{apic.fabric_policies.date_time_format.detection_multiplier | default(defaults.apic.fabric_policies.date_time_format.detection_multiplier)}} |
| Action: |  {{apic.fabric_policies.date_time_format.action | default(defaults.apic.fabric_policies.date_time_format.action)}} |
</caption>

### Rogue EP Control

<caption name="Rogue EP Control">

| Properties | Value |
|---|---|
| Administrative State: | {{apic.fabric_policies.rogue_ep_control.admin_state | default(defaults.apic.fabric_policies.rogue_ep_control.admin_state)}} |
| Rogue EP Detection Interval: | {{apic.fabric_policies.rogue_ep_control.detection_interval | default(defaults.apic.fabric_policies.rogue_ep_control.detection_interval)}} |
| Rogue EP Detection Multiplication Factor: | {{apic.fabric_policies.rogue_ep_control.detection_multiplier | default(defaults.apic.fabric_policies.rogue_ep_control.detection_multiplier)}} |
| Hold Interval (sec): | {{apic.fabric_policies.rogue_ep_control.hold_interval | default(defaults.apic.fabric_policies.rogue_ep_control.hold_interval)}} |
</caption>

### IP Aging

<caption name="IP Aging">

| Properties | Value |
|---|---|
| Administrative State: | {{apic.fabric_policies.ip_aging | default(defaults.apic.fabric_policies.ip_aging)}} |
</caption>

### Fabric Wide Settings

<caption name="Fabric Wide Settings">

| Properties | Value |
|---|---|
| Disable Remote EP Learning: | {{apic.fabric_policies.global_settings.disable_remote_endpoint_learn | default(defaults.apic.fabric_policies.global_settings.disable_remote_endpoint_learn)}} |
| Enforce Subnet Check: | {{apic.fabric_policies.global_settings.enforce_subnet_check | default(defaults.apic.fabric_policies.global_settings.enforce_subnet_check)}} |
| Enforce EPG VLAN Validation: | {{apic.fabric_policies.global_settings.overlapping_vlan_validation | default(defaults.apic.fabric_policies.global_settings.overlapping_vlan_validation)}} |
| Enforce Domain Validation: | {{apic.fabric_policies.global_settings.domain_validation | default(defaults.apic.fabric_policies.global_settings.domain_validation)}} |
| Opflex Client Authentication: | |
| Reallocate Gipo: | {{apic.fabric_policies.global_settings.reallocate_gipo | default(defaults.apic.fabric_policies.global_settings.reallocate_gipo)}} |
| Restrict Infra VLAN Traffic: | |
</caption>

### ISIS Domain Policy

<caption name="ISIS Domain Policy">

| Properties | Value |
|---|---|
| ISIS MTU: | |
| ISIS Metric for redistributed routes: | {{apic.fabric_policies.fabric_isis_redistribute_metric | default(defaults.apic.fabric_policies.fabric_isis_redistribute_metric)}} |
| LSP Fast Flood Mode: | |
| LSP generation initial wait interval: | |
| LSP generation maximum wait interval: | |
| LSP generation second wait interval: | |
| SPF computation frequency initial wait interval: | |
| SPF computation frequency maximum wait interval: | |
| SPF computation frequency second wait interval: | |
</caption>

### Port Tracking

<caption name="Port Tracking">

| Properties | Value |
|---|---|
| Port Tracking State: | {{apic.fabric_policies.port_tracking_admin_state | default(defaults.apic.fabric_policies.port_tracking_admin_state)}} |
| Delay restore timer: | {{apic.fabric_policies.delay | default(defaults.apic.fabric_policies.delay)}} |
| Number of active fabric ports that triggers port tracking: | {{apic.fabric_policies.min_links | default(defaults.apic.fabric_policies.min_links)}} |
| Include APIC ports when port tracking is triggered: | |
</caption>

### Remote Leaf POD Redundancy

<caption name="Remote Leaf POD Redundancy">

| Properties | Value |
|---|---|
| Enable Remote Leaf Pod Redundancy Policy: | |
| Enable Remote Leaf Pod Redundancy pre-emption: | |
</caption>

### System Alias and Banners

<caption name="System Alias and Banners">

| Properties | Value |
|---|---|
| GUI Alias: | {{apic.fabric_policies.banner.apic_gui_alias | default(defaults.apic.fabric_policies.banner.apic_gui_alias)}} |
| Controller CLI Banner: | {{apic.fabric_policies.banner.apic_cli_banner | default(defaults.apic.fabric_policies.banner.apic_cli_banner)}} |
| Switch CLI Banner: | {{apic.fabric_policies.banner.switch_cli_banner | default(defaults.apic.fabric_policies.banner.switch_cli_banner)}} |
| Application Banner: | |
| Banner Severity: | |
| Use Text Banner: | |
| GUI Banner Text: | |
</caption>

## Fabric

This section describes the Fabric configuration, including node registration and node management configuration.

### Fabric Nodes

<caption name="Fabric Nodes">

| Name | Node ID | Pod ID | Fabric ID | Serial Number | Role |
|---|---|---|---|---|---|
{% for node in apic.node_policies.nodes %}
| {{ node.name | default("") }} | {{ node.id }} | {{ node.pod | default(defaults.apic.node_policies.nodes.pod) }} | | {{node.serial_number}} | {{node.role}} |
{% endfor %}
</caption>

### Node Management OOB Addressing

{% if apic.node_policies.nodes|length > 0 %}
<caption name="Fabric Nodes">

| Name | Node ID | Pod ID | IPv4 Address | IPv4 Gateway | IPv6 Address | IPv6 Gateway |
|---|---|---|---|---|---|---|
{% for node in apic.node_policies.nodes %}
| {{ node.name | default("") }} | {{ node.id }} | {{ node.pod | default(defaults.apic.node_policies.nodes.pod) }} | {{node.oob_address | default("")}} | {{node.oob_gateway | default("")}} | {{node.oob_v6_address | default("")}} | {{node.oob_v6_gateway | default("")}} |
{% endfor %}
</caption>
{% else %}
No OOB Management addresses configured.
{% endif %}

## Fabric Policies

This section describes the Fabric Policies.

### DNS Profiles

{% if apic.fabric_policies.dns_policies|length > 0 %}
{% for dns in apic.fabric_policies.dns_policies | default([])%}
<caption name="DNS Profiles: {{dns.name}}">

| DNS Profile Name | {{dns.name}} |
|---|---|
| IP Address | Preferred |
{% for provider in dns.providers | default([]) %}
| {{provider.ip}} | {% if provider.preferred | default(defaults.apic.fabric_policies.dns_policies.providers.preferred) %}yes{%else%}no{%endif%} |
{% endfor %}
| Domain Name | Default |
{% for domain in dns.domains | default([])  %}
| {{domain.name}} | {% if domain.default | default(defaults.apic.fabric_policies.dns_policies.domains.default) %}yes{%else%}no{%endif%} |
{% endfor %}
</caption>
{% endfor %}
{% else %}
No DNS Profiles configured.
{% endif %}

### Date/Time Policy

{% if apic.fabric_policies.pod_policies.date_time_policies|length > 0 %}
{% for policy in apic.fabric_policies.pod_policies.date_time_policies | default([]) %}

#### {{policy.name}}

<caption name="Date/Time Policy: {{policy.name}}">

| Administrative State | Authentication State | Server State | Timezone | Display Format | Offset State |
|---|---|---|---|---|---|
| {{ policy.ntp_admin_state | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_admin_state)}} | {{ policy.ntp_auth_state | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_auth_state)}} | {{ policy.apic_ntp_server_state | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.apic_ntp_server_state)}} | {{apic.fabric_policies.date_time_format.timezone | default(defaults.apic.fabric_policies.date_time_format.timezone)}} | {{apic.fabric_policies.date_time_format.display_format | default(defaults.apic.fabric_policies.date_time_format.display_format)}} | {{apic.fabric_policies.date_time_format.show_offset | default(defaults.apic.fabric_policies.date_time_format.show_offset)}} |
</caption>

{% if policy.ntp_servers|length > 0 %}
<caption name="Date/Time Servers: {{policy.name}}">

| NTP Server | Preferred | Key ID | Min Polling Interval | Max Polling Interval | Mgmt EPG |
| --- | --- | --- | --- | --- | --- |
{% for srv in policy.ntp_servers %}
| {{srv.hostname_ip}} | {{srv.preferred | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.preferred)}} | {{srv.auth_key_id | default("")}} | | | {{srv.mgmt_epg | default(defaults.apic.fabric_policies.pod_policies.date_time_policies.ntp_servers.mgmt_epg)}} |
{% endfor %}
</caption>
{% else %}
No NTP servers configured.
{% endif %}
{% endfor %}
{% else %}
No Date/Time Policies configured.
{% endif %}

### Syslog

{% if apic.fabric_policies.monitoring.syslogs|length > 0 %}
{% for syslog in apic.fabric_policies.monitoring.syslogs | default([]) %}
<caption name="Syslog: {{syslog.name ~ defaults.apic.fabric_policies.monitoring.syslogs.name_suffix}}">

| Profile Name | Administrative State | Format | Show Milliseconds | Local Admin State | Local Severity | Console Admin State | Console Severity |
|---|---|---|---|---|---|---|---|
| {{syslog.name ~ defaults.apic.fabric_policies.monitoring.syslogs.name_suffix}} | {{syslog.admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.admin_state)}} | {{syslog.format | default(defaults.apic.fabric_policies.monitoring.syslogs.format)}} | {{syslog.show_millisecond | default(defaults.apic.fabric_policies.monitoring.syslogs.show_millisecond)}} | {{ syslog.local_admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.local_admin_state)}} | {{syslog.local_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.local_severity)}} | {{syslog.console_admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.console_admin_state)}} | {{syslog.console_severity | default(defaults.apic.fabric_policies.monitoring.syslogs.console_severity)}} |
</caption>

{% if syslog.destinations|length > 0 %}
<caption name = "Syslog Profile {{syslog.name}} Destinations">

| Hostname | Name | Protocol | Port | Administrative State | Facility | Severity | Mgmt EPG |
|---|---|---|---|---|---|---|---|
{% for dst in syslog.destinations %}
| {{dst.hostname_ip}} | {{dst.name}} | {{dst.protocol}} | {{dst.port | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.port)}} | {{dst.admin_state | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.admin_state)}} | {{dst.facility | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.facility)}} | {{dst.severity | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.severity)}} | {{dst.mgmt_epg | default(defaults.apic.fabric_policies.monitoring.syslogs.destinations.mgmt_epg)}} |
{% endfor %}
</caption>
{% else %}
No Syslog Destinations configured.
{% endif %}
{% endfor %}
{% else %}
No Syslog Policies configured.
{% endif %}

### SNMP
{% if apic.fabric_policies.pod_policies.snmp_policies|length > 0 %}
{% for snmp in apic.fabric_policies.pod_policies.snmp_policies | default([]) %}
<caption name="SNMP Policy: {{snmp.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix}}">

| Name | Administrative State | Contact | Location |
|---|---|---|---|
| {{snmp.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix}} | {{snmp.admin_state | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.admin_state)}} | {{snmp.contact | default(apic.fabric_policies.pod_policies.snmp_policies.contact)}} | {{snmp.location | default(defaults.apic.fabric_policies.pod_policies.snmp_policies.location)}} |
</caption>

{% if snmp.communities is defined %}
<caption name="Community Policy (SNMP Policy: {{snmp.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix}})">

| Community Policies | Description |
|---|---|
{% for community in snmp.communities | default([]) %}
| {{community}} | |
{% endfor %}
</caption>
{% else %}
No SNMP Communities configured.
{% endif %}

{% if snmp.client is defined %}
<caption name="Client Group Policy (SNMP Policy: {{snmp.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.name_suffix}}">

| Client Name | Address | Mgmt EPG |
|---|---|---|
{% for client in snmp.clients %}
{% for entry in clients.entries | default([]) %}
| {{client.name ~ defaults.apic.fabric_policies.pod_policies.snmp_policies.clients.name_suffix}} | {{entry.ip}} | {{client.mgmt_epg}} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No SNMP Client Group Policies configured.
{% endif %}
{%endfor%}
{% else %}
No SNMP policies configured.
{% endif %}

### BGP Route Reflectors

<caption name="BGP Route Reflectors">

| Properties | Value |
|---|---|
| Name | default |
| ASN | {{apic.fabric_policies.fabric_bgp_as | default("")}} |
| Route Reflector Nodes | {{apic.fabric_policies.fabric_bgp_rr | default([]) | join(", ")}} |
| External Route Reflector Nodes | {{apic.fabric_policies.fabric_bgp_ext_rr | default([]) | join(", ")}} |
</caption>

### Pod Policy Group

<caption name="Pod Policy Group">

| Properties | Value |
|---|---|
| Pod Policy Name | {{apic.fabric_policies.pod_policy_groups.name | default(defaults.apic.fabric_policies.pod_policy_groups.name)}} |
| Date / Time Policy | {{ apic.fabric_policies.pod_policy_groups.date_time_policy | default("")}} |
| ISIS Policy | |
| COOP Group Policy | |
| BGP Route Reflector Policy | |
| Mgmt Access Policy | {{ apic.fabric_policies.pod_policy_groups.management_access_policy | default("")}} |
| SNMP Policy | {{ apic.fabric_policies.pod_policy_groups.snmp_policy | default("")}} |
| MACSec Policy | |
</caption>

### Pod Fabric Setup Policy

<caption name="Pod Policy Group">

| Pod ID | Pod Type | TEP Pool |
|---|---|---|
{% for pod in apic.pod_policies.pods | default([]) %}
| {{pod.id}} | | {{pod.tep_pool}} |
{% endfor %}
</caption>

### Fabric Leaf Switch Policy Groups

{% for leaf_polgrp in apic.fabric_policies.leaf_switch_policy_groups | default([]) %}

### Policy: {{leaf_polgrp.name ~ defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix}}

<caption name="Fabric Leaf Switch Policy Groups: {{leaf_polgrp.name ~ defaults.apic.fabric_policies.leaf_switch_policy_groups.name_suffix}}">

| Properties | Value |
|---|---|
| Monitoring Policy | |
| TechSupport Export Policy: | |
| Core Export Policy | |
| Inventory Policy | |
| Power Redundancy Policy {{ leaf_polgrp.psu_policy | default("")}} |
| Analytics Policy | |
| Node Control Policy | {{ leaf_polgrp.node_control_policy| default("")}} |
| TWAMP Server Policy | |
| TWAMP Responder Policy | |
</caption>
{% endfor %}

### Fabric Leaf Switch Profiles

<caption name="Fabric Leaf Switch Profiles">

| Name | Switch Association(s) | Block(s) | Policy Group |
|---|---|---|---|
{% if apic.fabric_policies.auto_generate_switch_pod_profiles | default(defaults.apic.fabric_policies.auto_generate_switch_pod_profiles) %}
{% for node in apic.node_policies.nodes | default([]) %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_switch_profile_name | default(defaults.apic.fabric_policies.leaf_switch_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_switch_selector_name | default(defaults.apic.fabric_policies.leaf_switch_selector_name))) %}
| {{leaf_switch_profile_name}} | {{leaf_switch_selector_name}} | {{node.id}} | {{node.fabric_policy_group | default("")}} |
{% endfor %}
{% else %}
{% for sw_prof in apic.fabric_policies.leaf_switch_profiles | default([])%}
{% set ns = namespace(blocks = []) %}
{% for sel in sw_prof.selectors | default([]) %}
{% for block in sel.node_blocks | default([]) %}
{% if block.to is not defined %}
{% set _ = ns.blocks.append(block.from) %}
{% else %}
{% set _ = ns.blocks.append(block.from ~ "-" ~ block.to) %}
{% endif %}
{% endfor %}
| {{ sw_prof.name ~ defaults.apic.fabric_policies.leaf_switch_profiles.name_suffix}} | {{sel.name ~ defaults.apic.fabric_policies.leaf_switch_profiles.selectors.name_suffix}} | {{ ns.blocks | join(", ")}} | {{ sel.policy | default("")}} |
{% endfor %}
{% endfor %}
{% endif %}
</caption>

## Access Policies

This section describes the Fabric Access Policies.

## Access Leaf Switch Profiles
<caption name="Access Access Leaf Switch Profiles">

| Name | Leaf Selector(s) | Block(s) | Policy Group | Interface Selector Profile(s) |
|---|---|---|---|---|
{% if apic.access_policies.auto_generate_switch_pod_profiles | default(defaults.apic.access_policies.auto_generate_switch_pod_profiles) %}
{% for node in apic.node_policies.nodes | default([]) %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_profile_name | default(defaults.apic.access_policies.leaf_switch_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_selector_name | default(defaults.apic.access_policies.leaf_switch_selector_name))) %}
{%- set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}
| {{leaf_switch_profile_name}} | {{leaf_switch_selector_name}} | {{node.id}} | {{node.fabric_policy_group | default("")}} | {{leaf_switch_selector_name}} |
{% endfor %}
{% else %}
{% for sw_prof in apic.access_policies.leaf_switch_profiles | default([])%}
{% set ns = namespace(blocks = []) %}
{% for sel in sw_prof.selectors | default([]) %}
{% for block in sel.node_blocks | default([]) %}
{% if block.to is not defined %}
{% set _ = ns.blocks.append(block.from) %}
{% else %}
{% set _ = ns.blocks.append(block.from ~ "-" ~ block.to) %}
{% endif %}
{% endfor %}
| {{ sw_prof.name ~ defaults.apic.access_policies.leaf_switch_profiles.name_suffix}} | {{sel.name ~ defaults.apic.access_policies.leaf_switch_profiles.selectors.name_suffix}} | {{ ns.blocks | join(", ")}} | {{ sel.policy | default("")}} | {{sw_prof.interface_profiles | default([]) | join(", ")}} |
{% endfor %}
{% endfor %}
{% endif %}
</caption>

### Leaf Access Interface Profiles

<caption name="Leaf Access Interface Profiles">

| Name | Block(s) | Description | Policy Group |
|---|---|---|---|
{% if apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) or apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) %}
{% for node in apic.interface_policies.nodes | default([]) %}
{% for port in node.interfaces | default([]) %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_profile_name | default(defaults.apic.access_policies.leaf_switch_profile_name))) %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_selector_name | default(defaults.apic.access_policies.leaf_switch_selector_name))) %}
{% set leaf_interface_selector_name = (node.module | default(defaults.apic.interface_policies.nodes.interfaces.from_module) ~ ":" ~ int.port) | regex_replace("^(?P<mod>.+):(?P<port>.+)$", (apic.access_policies.leaf_interface_selector_name | default(defaults.apic.access_policies.leaf_interface_selector_name))) %}
| {{leaf_switch_profile_name}} | {{leaf_interface_selector_name}} | {{port.description | default("")}} | {{port.policy_group | default("")}} |
{% endfor %}
{% endfor %}
abc{% set leaf_interface_profile_name = (_node.id ~ ":" ~ _node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}{{ comma1() }}
{{ leaf_switch_profile_name }}
{% else %}
{% for node in apic.access_policies.leaf_interface_profiles | default([]) %}
{% for selector in node.selectors | default([])%}
{% for block in selector.port_blocks | default([])%}
{% if block.to_port is defined %}
| {{ node.name ~ apic.access_policies.leaf_interface_profiles.name_suffix }} | {{ block.from_module|default(defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module) ~"/"~block.from_port ~ "-" ~ block.from_module|default(defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)~"/"~block.to_port }} | {{block.description | default("")}} | {{selectors.policy_group | default("")}} |
{% else %}
| {{ node.name ~ apic.access_policies.leaf_interface_profiles.name_suffix  }} | {{ block.from_module|default(defaults.apic.access_policies.leaf_interface_profiles.selectors.port_blocks.from_module)~"/"~block.from_port }} | {{block.description | default("")}} | {{selectors.policy_group | default("")}} |
{% endif %}
{% endfor %}
{% for block in selector.sub_port_blocks | default([])%}
{% if block.to_port is defined %}
| {{ node.name ~ apic.access_policies.leaf_interface_profiles.name_suffix }} | {{ block.from_module|default(defaults.apic.access_policies.leaf_interface_profiles.selectors.sub_port_blocks.from_module) ~"/"~block.from_port ~ "-" ~ block.from_module|default(defaults.apic.access_policies.leaf_interface_profiles.selectors.sub_port_blocks.from_module)~"/"~block.to_port }} | {{block.description | default("")}} | {{selectors.policy_group | default("")}} |
{% else %}
| {{ node.name ~ apic.access_policies.leaf_interface_profiles.name_suffix  }} | {{ block.from_module|default(defaults.apic.access_policies.leaf_interface_profiles.selectors.sub_port_blocks.from_module)~"/"~block.from_port }} | {{block.description | default("")}} | {{selectors.policy_group | default("")}} |
{% endif %}
{% endfor %}
{% endfor %}
{% endfor %}
{% endif %}
</caption>

### Leaf Access Interface Policy Groups

<caption name="Leaf Access Interface Policy Groups">

| Name | Link Level Policy | LACP Policy | CDP Policy | LLDP Policy | AAEP | Link Type |
|---|---|---|---|---|---|---|
{% for ipg in apic.access_policies.leaf_interface_policy_groups | default([]) %}
{% set port_type = "" %}
{% if ipg.type == "vpc"%}
{% set port_type = "vPC"%}
{% elif ipg.type == "pc" %}
{% set port_type = "PC" %}
{% elif port_type == "access"%}
{% set port_type = "Access" %}
{% else %}
{% endif %}
| {{ipg.name ~ defaults.apic.access_policies.leaf_interface_policy_groups.name_suffix}} | {{ipg.link_level_policy | default("default")}} | {% if ipg.type == "access" %} {%else%}{{ipg.port_channel_policy | default("default")}}{%endif%} | {{ipg.cdp_policy | default("default")}} | {{ipg.lldp_policy | default("default")}} | {{ipg.aaep | default("default")}} | {{port_type}} |
{% endfor %}
</caption>

### Spine Access Switch Profiles

<caption name="Spine Access Switch Profiles">

| Name | Switch Association(s) | Block(s) | Policy Group |
|---|---|---|---|
{% if apic.fabric_policies.auto_generate_switch_pod_profiles | default(defaults.apic.fabric_policies.auto_generate_switch_pod_profiles) %}
{% for node in apic.node_policies.nodes | default([]) %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_switch_profile_name | default(defaults.apic.fabric_policies.leaf_switch_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.fabric_policies.leaf_switch_selector_name | default(defaults.apic.fabric_policies.leaf_switch_selector_name))) %}
| {{leaf_switch_profile_name}} | {{leaf_switch_selector_name}} | {{node.id}} | {{node.fabric_policy_group | default("")}} |
{% endfor %}
{% else %}
{% for sw_prof in apic.fabric_policies.spine_switch_profiles | default([])%}
{% set ns = namespace(blocks = []) %}
{% for sel in sw_prof.selectors | default([]) %}
{% for block in sel.node_blocks | default([]) %}
{% if block.to is not defined %}
{% set _ = ns.blocks.append(block.from) %}
{% else %}
{% set _ = ns.blocks.append(block.from ~ "-" ~ block.to) %}
{% endif %}
{% endfor %}
| {{ sw_prof.name ~ defaults.apic.fabric_policies.spine_switch_profiles.name_suffix}} | {{sel.name ~ defaults.apic.fabric_policies.spine_switch_profiles.selectors.name_suffix}} | {{ ns.blocks | join(", ")}} | {{ sel.policy | default("")}} |
{% endfor %}
{% endfor %}
{% endif %}
</caption>

### Spine Access Interface Profiles

<caption name="Spine Access Interface Profiles">

| Name | Block(s) | Description | Policy Group |
|---|---|---|---|
{% if apic.auto_generate_access_leaf_switch_interface_profiles | default(defaults.apic.auto_generate_access_leaf_switch_interface_profiles) or apic.auto_generate_switch_pod_profiles | default(defaults.apic.auto_generate_switch_pod_profiles) %}
{% for node in apic.interface_policies.nodes | default([]) %}
{% for port in node.interfaces | default([]) %}
{% set leaf_switch_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_profile_name | default(defaults.apic.access_policies.leaf_switch_profile_name))) %}
{% set leaf_interface_profile_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}
{% set leaf_switch_selector_name = (node.id ~ ":" ~ node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_switch_selector_name | default(defaults.apic.access_policies.leaf_switch_selector_name))) %}
{% set leaf_interface_selector_name = (node.module | default(defaults.apic.interface_policies.nodes.interfaces.from_module) ~ ":" ~ int.port) | regex_replace("^(?P<mod>.+):(?P<port>.+)$", (apic.access_policies.leaf_interface_selector_name | default(defaults.apic.access_policies.leaf_interface_selector_name))) %}
| {{leaf_switch_profile_name}} | {{leaf_interface_selector_name}} | {{port.description | default("")}} | {{port.policy_group | default("")}} |
{% endfor %}
{% endfor %}
{%- set leaf_interface_profile_name = (_node.id ~ ":" ~ _node.name) | regex_replace("^(?P<id>.+):(?P<name>.+)$", (apic.access_policies.leaf_interface_profile_name | default(defaults.apic.access_policies.leaf_interface_profile_name))) %}{{ comma1() }}
{{ leaf_switch_profile_name }}
{% else %}
{% for node in apic.access_policies.spine_interface_profiles | default([]) %}
{% for selector in node.selectors | default([]) %}
{% for block in selector.port_blocks | default([]) %}
| {{node.name ~ defaults.apic.access_policies.spine_interface_profiles.name_suffix}} | {{block.from_module | default(defaults.apic.access_policies.spine_interface_profiles.selectors.port_blocks.from_module)}}/{{block.from_port}}{% if block.to_port is defined %}-{{block.to_port}}{%endif%} | {{selector.description | default("")}} | {{selector.policy_group | default("")}} |
{% endfor %}
{% endfor %}
{% endfor %}
{% endif %}
</caption>

### Link Level Policies

{% if apic.access_policies.link_level_policies|length > 0 %}
<caption name="Link Level Policies">

| Name | Auto-Negotiation | Speed | Link Bounce Interval (ms) |
|---|---|---|---|
{% for pol in apic.access_policies.link_level_policies | default([])%}
| {{pol.name ~ defaults.apic.access_policies.link_level_policies.name_suffix}} | {{pol.auto | default(defaults.apic.access_policies.link_level_policies.auto)}} | {{pol.speed | default(defaults.apic.access_policies.link_level_policies.speed)}} | |
{% endfor %}
</caption>
{% else %}
No Link Level Policies configured.
{% endif %}

### CDP Policies

{% if apic.access_policies.interface_policies.cdp_policies|length > 0 %}
<caption name="CDP Policies">

| Name | Admin State |
|---|---|
{% for pol in apic.access_policies.interface_policies.cdp_policies | default([]) %}
| {{pol.name ~ defaults.apic.access_policies.interface_policies.cdp_policies.name_suffix}} | {{pol.admin_state}} |
{% endfor %}
</caption>
{% else %}
No CDP Policies configured.
{% endif %}

### LLDP Interface Policies

{% if apic.access_policies.interface_policies.lldp_policies|length > 0 %}
<caption name="LLDP Policies">

| Name | Receive State | Transmit State |
|---|---|---|
{% for pol in apic.access_policies.interface_policies.lldp_policies | default([]) %}
| {{pol.name ~ defaults.apic.access_policies.interface_policies.lldp_policies.name_suffix}} | {{pol.admin_rx_state}} | {{pol.admin_tx_state}} |
{% endfor %}
</caption>
{% else %}
No LLDP Policies configured.
{% endif %}

### LACP Interface Policies

{% if apic.access_policies.interface_policies.port_channel_policies|length > 0 %}
<caption name="LACP Interface Policies">

| Name | Controls | Mode | Minimum Links | Maximum Links |
|---|---|---|---|---|
{% for pol in apic.access_policies.interface_policies.port_channel_policies | default([]) %}
| {{pol.name ~ defaults.apic.access_policies.interface_policies.port_channel_policies.name_suffix}} | {% set controls = [] %}{% if pol.fast_select_standby | default(defaults.apic.access_policies.interface_policies.port_channel_policies.fast_select_standby) %}{% set _ = controls.append("fast-sel-hot-stdby") %}{%endif%}{% if pol.graceful_convergence | default(defaults.apic.access_policies.interface_policies.port_channel_policies.graceful_convergence) %}{% set _ = controls.append("graceful-conv")%}{%endif%}{% if pol.suspend_individual | default(defaults.apic.access_policies.interface_policies.port_channel_policies.suspend_individual) %}{% set _ = controls.append("susp-individual") %}{%endif%}{{controls | join(",")}} | {{pol.mode}} | {{pol.min_links | default(defaults.apic.access_policies.interface_policies.port_channel_policies.min_links)}} | {{pol.max_links | default(defaults.apic.access_policies.interface_policies.port_channel_policies.max_links)}} |
{% endfor %}
</caption>
{% else %}
No LACP Interface Policies configured.
{% endif %}

### LACP Member Policies

{% if apic.access_policies.interface_policies.port_channel_member_policies|length > 0 %}
<caption name="LACP Member Policies">

| Name | Priority | Transmit Rate |
|---|---|---|
{% for pol in apic.access_policies.interface_policies.port_channel_member_policies | default([]) %}
| {{pol.name ~ defaults.apic.access_policies.interface_policies.port_channel_member_policies.name_suffix}} | {{pol.priority | default(defaults.apic.access_policies.interface_policies.port_channel_member_policies.priority)}} | {{pol.rate | default(defaults.apic.access_policies.interface_policies.port_channel_member_policies.rate)}} |
{% endfor %}
</caption>
{% else %}
No LACP Member Policies configured.
{% endif %}

### MCP Interface Policies

{% if apic.access_policies.interface_policies.mcp_policies|length > 0 %}
<caption name="MCP Interface Policies">

| Name | Administrative State |
|---|---|
{% for pol in apic.access_policies.interface_policies.mcp_policies | default([]) %}
| {{pol.name ~ defaults.apic.access_policies.interface_policies.mcp_policies.name_suffix}} | {{pol.admin_state}} |
{% endfor %}
</caption>
{% else %}
No MCP Interface Policies configured.
{% endif %}

### MCP Global Policy

{% if apic.access_policies.mcp|length > 0 %}
<caption name="MCP Global Policy">

| Administrative State | Control | Initial Delay (sec) | Loop Detect Multiplier | Loop Protection Action | Transmit Frequency (sec) |
|---|---|---|---|---|---|
{% for pol in apic.access_policies.mcp | default([]) %}
| {{pol.admin_state | default(defaults.apic.access_policies.mcp.admin_state)}} | {% if apic.access_policies.mcp.per_vlan | default(defaults.apic.access_policies.mcp.per_vlan) %}pdu-per-vlan{%endif%} | {{pol.apic.access_policies.mcp.initial_delay | default(defaults.apic.access_policies.mcp.initial_delay)}} | {{pol.loop_detection | default(defaults.apic.access_policies.mcp.loop_detection)}} | {{pol.loop_detection | default(defaults.apic.access_policies.mcp.loop_detection)}} | {{pol.frequency_sec | default(defaults.apic.access_policies.mcp.frequency_sec)}} |
{% endfor %}
</caption>
{% else %}
No MCP Global Policies configured.
{% endif %}

### STP Interface Policies

{% if apic.access_policies.spanning_tree_policies|length > 0 %}
<caption name="STP Interface Policies">
| Name | Control |
|---|---|
{% for pol in apic.access_policies.spanning_tree_policies | default([]) %}{% set control = [] %}{% if pol.bpdu_filter | default(defaults.apic.access_policies.spanning_tree_policies.bpdu_filter) %}{% set _ = control.append("bpdu-filter")%}{%endif%}{% if pol.bpdu_guard | default(defaults.apic.access_policies.spanning_tree_policies.bpdu_guard) %}{% set _ = control.append("bpdu-guard") %}{%endif%}
| {{pol.name ~ defaults.apic.access_policies.spanning_tree_policies.name_suffix}} | {{control | join(",")}} |
{% endfor %}
</caption>
{% else %}
No STP Interface Policies configured.
{% endif %}

### Virtual Port Channel Security Policy

{% if apic.node_policies.vpc_groups.groups|length > 0 %}
<caption name="Virtual Port Channel Security Policy">

| Name | Domain Policy | Nodes | Logical ID | Pod |
|---|---|---|---|---|
{% for vpc in apic.node_policies.vpc_groups.groups | default([]) %}
{% set ns = namespace(pod_id = "1") %}
{% for node in apic.node_policies.nodes %}
{% if node.id == vpc.switch_1 or node.id == vpc.switch_2%}{% set ns.pod_id = node.id %}{%endif%}
{% endfor %}
| {{vpc.name | default("")}} | {{vpc.policy | default("")}} | {{vpc.switch_1}},{{vpc.switch_2}} | {{vpc.id}} | {{ ns.pod_id }} |
{% endfor %}
</caption>
{% else %}
No Virtual Port Channel Security Policy configured.
{% endif %}

### AAEPS

<caption name="AAEPs">

| Name | Associated Domain(s) | VLAN Pool(s) |
|---|---|---|
{% for aaep in apic.access_policies.aaeps | default([]) %}
{% for dom in aaep.physical_domains | default([])%}
{% for _dom in apic.access_policies.physical_domains | default([]) %}
{% if dom  ~ defaults.apic.access_policies.physical_domains.name_suffix == _dom.name  ~ defaults.apic.access_policies.physical_domains.name_suffix %}
| {{aaep.name  ~ defaults.apic.access_policies.aaeps.name_suffix}} | {{ dom  ~ defaults.apic.access_policies.physical_domains.name_suffix}} | {{_dom.vlan_pool | default("")}} |
{% endif %}
{% endfor %}
{% endfor %}
{% for dom in aaep.routed_domains | default([])%}
{% for _dom in apic.access_policies.routed_domains | default([]) %}
{% if dom  ~ defaults.apic.access_policies.routed_domains.name_suffix == _dom.name  ~ defaults.apic.access_policies.routed_domains.name_suffix %}
| {{aaep.name  ~ defaults.apic.access_policies.aaeps.name_suffix}} | {{ dom  ~ defaults.apic.access_policies.routed_domains.name_suffix}} | {{_dom.vlan_pool | default("")}} |
{% endif %}
{% endfor %}
{% endfor %}
{% for dom in aaep.vmware_vmm_domains | default([])%}
{% for _dom in apic.fabric_policies.vmware_vmm_domains | default([]) %}
{% if dom  ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix == _dom.name  ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix %}
| {{aaep.name  ~ defaults.apic.fabric_policies.aaeps.name_suffix}} | {{ dom  ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}} | {{_dom.vlan_pool | default("")}} |
{% endif %}
{% endfor %}
{% endfor %}
{# Missing logic for L2 Domains, FC Domains, Red Hat Domains#}
{% endfor %}
</caption>

### AAEPs Associated with Application EPGs

<caption name="AAEP Associated Application EPGs">

| AAEP | EPG | Encap | Mode | Trunk |
|---|---|---|---|---|
{% for aaep in apic.access_policies.aaeps | default([]) %}
{% for epg in aaep.endpoint_groups | default([]) %}
| {{aaep.name ~ defaults.apic.access_policies.aaeps.name_suffix}} | uni/tn-{{epg.tenan}}/ap-{{epg.application_profile}}/epg-{{epg.endpoint_group}} | vlan-{{epg.vlan}} | {{epg.mode | default(defaults.apic.access_policies.aaeps.endpoint_groups.mode)}} | {{epg.deployment_immediacy | default(defaults.apic.access_policies.aaeps.endpoint_groups.deployment_immediacy)}} |
{% endfor %}
{% endfor %}
</caption>

### Domains

<caption name="Domains">

| Name | Type | Associated VLAN Pool |
|---|---|---|
{% for dom in apic.access_policies.physical_domains | default([])%}
| {{ dom.name ~ defaults.apic.access_policies.physical_domains.name_suffix}} | phys | {{dom.vlan_pool | default("")}} |
{% endfor %}
{% for dom in apic.access_policies.routed_domains | default([])%}
| {{ dom.name ~ defaults.apic.access_policies.physical_domains.routed_domains}} | l3dom | {{dom.vlan_pool | default("")}} |
{% endfor %}
{% for dom in apic.fabric_policies.vmware_vmm_domains | default([])%}
| {{ dom.name ~ defaults.apic.access_policies.physical_domains.vmware_vmm_domains}} | l3dom | {{dom.vlan_pool | default("")}} |
{% endfor %}
</caption>

### VLAN Pools

<caption name="VLAN Pools">

| Name | Pool Allocation Mode | VLAN Range / Allocation Mode |
|---|---|---|
{% for pool in apic.access_policies.vlan_pools | default([]) %}
{% for range in pool.ranges | default([]) %}
| {{ pool.name ~ defaults.apic.access_policies.vlan_pools.name_suffix}} | {{pool.allocation | default(defaults.apic.access_policies.vlan_pools.allocation)}} | {{range.from}} |
{% endfor %}
{% endfor %}
</caption>

## Virtual Networking

This section describes the Virtual Machine Manager (VMM) configuration.

### VMM Domains

<caption name="VMM Domain(s)">

| Name | Vendor | vSwitch Type | VLAN Pool | Access Mode |
|---|---|---|---|---|
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
| {{ vmm.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}} | VMware | Distributed Switch | {{vmm.vlan_pool | default("")}} | {{vmm.access_mode ~ defaults.apic.fabric_policies.vmware_vmm_domains.access_mode}} |
{% endfor %}
</caption>

<caption name="vSwitch Policies">

| VMM Domain | Port Channel Policy | LLDP Policy | CDP Policy | MTU Policy | Netflow Exporter |
|---|---|---|---|---|---|
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
| {{vmm.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}} | {{vmm.vswitch.port_channel_policy | default("")}} | {{vmm.vswitch.lldp_policy | default("")}} | {{vmm.vswitch.cdp_policy | default("")}} | {{vmm.vswitch.mtu_policy | default("")}} | |
{% endfor %}
</caption>

<caption name="vCenter Credential(s)">

| VMM Domain | Profile Name | Username | Description |
|---|---|---|---|
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
{% for creds in vmm.credential_policies | default([]) %}
| {{vmm.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.name_suffix}} | {{ creds.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.credential_policies.name_suffix}} | {{creds.username}} | |
{% endfor %}
{% endfor %}
</caption>

<caption name="vCenter(s)">

| VMM Domain | Name | Type | IP/Hostname | Associated Credential |
|---|---|---|---|---|
{% for vmm in apic.fabric_policies.vmware_vmm_domains | default([]) %}
{% for vcenter in vmm.vcenters %}
| {{vcenter.name ~ defaults.apic.fabric_policies.vmware_vmm_domains.vcenters.name_suffi}} | VMware | {{vcenter.hostname_ip}} | {{vcenter.credential_policy}} |
{% endfor %}
{% endfor %}
</caption>

### VMM Controllers

### VMM Credentials

## Admin Policies

This section describes the Admin Policies.

### AAA

#### TACACS Providers

<caption name="TACACS Providers">

| Hostname | Description | Auth Protocol | Monitor Server | Port | Retries | Timeout | Mgmt EPG |
|---|---|---|---|---|---|---|---|
{% for prov in apic.fabric_policies.aaa.tacacs_providers | default([]) %}
| {{prov.hostname_ip}} | {{prov.description | default("")}} | {{prov.protocol | default(defaults.apic.fabric_policies.aaa.tacacs_providers.protocol)}} | {{prov.monitoring | default(defaults.apic.fabric_policies.aaa.tacacs_providers.monitoring)}} | {{prov.port | default(defaults.apic.fabric_policies.aaa.tacacs_providers.port)}} | {{prov.retries | default(defaults.apic.fabric_policies.aaa.tacacs_providers.retries)}} | {{prov.timeout | default(defaults.apic.fabric_policies.aaa.tacacs_providers.timeout)}} | {{prov.mgmt_epg | default(defaults.apic.fabric_policies.aaa.tacacs_providers.mgmt_epg)}} |
{% endfor %}
</caption>

#### Login Domains

<caption name="AAA Login Domains">

| Login Name | Description | Provider Group | Realm | Server Name | Description | Order |
|---|---|---|---|---|---|---|
{% for dom in apic.fabric_policies.aaa.login_domains | default([]) %}
{% for dom_tac in dom.tacacs_providers | default([])%}
| {{dom.name}} | {{dom.description | default("")}} | {{dom.name}} | {{dom_tac.hostname_ip}} | | {{dom_tac.priority | default(defaults.apic.fabric_policies.aaa.login_domains.tacacs_providers.priority)}} |
{% endfor %}
{% endfor %}
</caption>

#### AuthRealm

<caption name="AAA AuthRealm">

| Properties | Configuration |
|---|---|
| Default Login Policy | {{apic.fabric_policies.aaa.remote_user_login_policy | default(defaults.apic.fabric_policies.aaa.remote_user_login_policy)}} |
| Use ICMP Reachable Only | {{apic.fabric_policies.aaa.default_fallback_check | default(defaults.apic.fabric_policies.aaa.default_fallback_check)}} |
</caption>

<caption name="AAA AuthRealm Default Authentication">

| Properties | Configuration |
|---|---|
| Realm | {{apic.fabric_policies.aaa.default_realm | default(defaults.apic.fabric_policies.aaa.default_realm)}} |
| Login Domain | {{apic.fabric_policies.aaa.default_login_domain | default("")}} |
| Fallback Domain Availability | |
| Realm Subtype | |
</caption>

<caption name="AAA AuthRealm Console Authentication">

| Properties | Configuration |
|---|---|
| Realm | {{apic.fabric_policies.aaa.console_realm | default(defaults.apic.fabric_policies.aaa.console_realm)}} |
| Login Domain | {{apic.fabric_policies.aaa.console_login_domain | default("")}} |
| Realm Subtype | |
</caption>

### Schedulers

{% for scheduler in apic.fabric_policies.schedulers | default([]) %}
{% if scheduler.recurring_windows|length > 0 %}
{% set schedulers_configured = true %}
{% endif %}
{% endfor %}
{% if schedulers_configured %}
<caption name="Scheduler(s)">

| Name | Day | Hour | Minute | Max Concurrent Nodes | Max Running Time (DD:HH:MM:SS) |
|---|---|---|---|---|---|
{% for scheduler in apic.fabric_policies.schedulers | default([]) %}
{% for recurring in scheduler.recurring_windows | default([])%}
| {{scheduler.name ~ apic.fabric_policies.schedulers.name_suffix}} | {{recurring.day}} | {{recurring.hour}} | {{recurring.minute}} | | |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Schedulers configured.
{% endif %}

### Export Policies

#### Configuration Export Policies

{% if apic.fabric_policies.config_exports|length > 0 %}
<caption name="Export Policies">

| Name | Format | Scheduler | Remote Location | Encrypted | Target DN |
|---|---|---|---|---|---|
{% for pol in apic.fabric_policies.config_exports | default([]) %}
| {{pol.name ~ defaults.apic.fabric_policies.config_exports.name_suffi}} | {{pol.format | default(defaults.apic.fabric_policies.config_exports.format)}} | {{pol.scheduler | default("")}} | {{pol.remote_location | default("")}} | {% if apic.fabric_policies.config_passphrase is defined %}yes{%endif%} | |
{% endfor %}
</caption>
{% else %}
No Config Export Policies configured.
{% endif %}

#### Remote Locations

{% if apic.fabric_policies.remote_locations|length > 0 %}
<caption name="Export Policies">

| Name | Hostname | Username | Remote Path | Protocol | Port | Mgmt EPG |
|---|---|---|---|---|---|---|
{% for remote in apic.fabric_policies.remote_locations | default([])%}
| {{remote.name ~ defaults.apic.fabric_policies.remote_locations.name_suffix}} | {{remote.hostname_ip}} | {{remote.username | default("")}} | {{remote.path | default(defaults.apic.fabric_policies.remote_locations.path)}} | {{remote.protocol}} | {{remote.port}} | {{remote.mgmt_epg | default(defaults.apic.fabric_policies.remote_locations.mgmt_epg)}} |
{% endfor %}
</caption>
{% else %}
No Remote Locations configured.
{% endif %}

## Tenant Design

The table below lists the tenants configured in the fabric.

<caption name="apic.tenants|default([])|length Tenants">

| Name | Description | Monitoring Policy | Security Domains |
|---|---|---|---|
{% for tenant in apic.tenants | default([]) %}
| {{ tenant.name }} | {{tenant.description | default("")}} | | |
{%endfor%}
</caption>

{% for tenant in apic.tenants | default([]) %}
### Tenant Details: {{tenant.name}}

#### Application Profiles

{% if tenant.application_profiles|length > 0 %}
<caption name="Application Profiles - {{tenant.name}}">

| Name | Description |
|---|---|
{% for ap in tenant.application_profiles | default([]) %}
| {{ap.name ~ defaults.apic.tenants.application_profiles.name_suffix}} | {{ap.description | default("")}} |
{%endfor%}
</caption>
{% else %}
No Application Profiles configured
{% endif %}

#### Endpoint Groups (EPGs)

{% for ap in tenant.application_profiles | default([]) %}
{% if ap.endpoint_groups|length > 0 %}
{% set epgs_configured = true %}
{% endif %}
{% endfor %}
{% if epgs_configured %}
<caption name="Endpoint Groups - {{tenant.name}}">

| Application Profile | Endpoint Group | Bridge Domain |
|---|---|---|
{% for ap in tenant.application_profiles | default([]) %}
{% for epg in ap.endpoint_groups | default([]) %}
| {{ ap.name ~ defaults.apic.tenants.application_profiles.name_suffix }} | {{ epg.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix }} | {{ epg.bridge_domain ~ defaults.apic.tenants.bridge_domains.name_suffix }} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Endpoint Groups configured
{% endif %}

##### EPG Static Bindings

{% for ap in tenant.application_profiles | default([]) %}
{% for epg in ap.endpoint_groups | default([]) %}
{% if epg.static_ports|length > 0 %}
{% set epg_static_ports_configured = true %}
{% endif %}
{% endfor %}
{% endfor %}
{% if epg_static_ports_configured %}
<caption name="EPG Static Bindings - {{tenant.name}}">

| App Profile | EPG | Encap | Path | Deployment Immediacy | Mode |
|---|---|---|---|---|---|
{% for ap in tenant.application_profiles | default([]) %}
{% for epg in ap.endpoint_groups | default([]) %}
{% for static_port in epg.static_ports | default([]) %}
{% set pod_id = "1" %}{% for node in apic.node_policies.nodes | default([]) %}{% if node.id == static_port.node_id %}{% set pod_id = node.pod | default(defaults.apic.node_policies.nodes.pod)%}{%endif%}{% endfor %}
| {{ap.name ~ defaults.apic.tenants.application_profiles.name_suffix}} | {{epg.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix}} | vlan-{{static_port.vlan}} | {% if static_port.node2_id is defined %}topology/pod-{{pod_id}}/protpaths-{{static_port.node_id}}-{{static_port.node2_id}}/pathep-[{{static_port.channel}}]{%else%}topology/pod-{{pod_id}}/paths-{{static_port.node_id}}/pathep-[eth{{static_port.module|default(defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.module)}}/{{static_port.port}}]{%endif%} | {{static_port.deployment_immediacy | default(defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.deployment_immediacy)}} | {{static_port.mode | default(defaults.apic.tenants.application_profiles.endpoint_groups.static_ports.mode)}} |
{% endfor %}
{% endfor %}
{% endfor %}
</caption>
{% else %}
No EPG Static Bindings configured.
{% endif %}

#### VRFs

{% if tenant.vrfs|length > 0 %}
<caption name="VRFs - {{tenant.name}}">

| Tenant | Name | Policy Enforcement | Policy Enforcement Direction | Preferred Group |
|---|---|---|---|---|
{% for vrf in tenant.vrfs | default([])%}
| {{tenant.name}} | {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{vrf.enforcement_preference | default(defaults.apic.tenants.vrfs.enforcement_preference)}} | {{vrf.enforcement_direction | default(defaults.apic.tenants.vrfs.enforcement_direction)}} | {{vrf.preferred_group | default(defaults.tenants.vrfs.preferred_group)}} |
{% endfor %}
</caption>
{% else %}
No VRFs configured
{% endif %}

##### Provided Contracts

{% for vrf in tenant.vrfs | default([]) %}
{% if vrf.contracts.providers|length > 0 %}
{% set provided_contracts = true %}
{% endif %}
{% endfor %}
{% if provided_contracts %}
<caption name="VRF Provided contracts - {{tenant.name}}">

| VRF | Contract | Contract owned by Tenant |
|---|---|---|
{% for vrf in tenant.vrfs | default([]) %}
{% for prov in vrf.contracts.providers | default([]) %}
{% set ns = namespace(contract_in_same_tenant = False) %}
{% for contract in tenant.contracts | default([]) %}
{% if prov == contract.name ~ defaults.apic.tenants.contracts.name_suffix %}
{% set ns.contract_in_same_tenant = True %}
{% endif %}
{% endfor %}
{% if ns.contract_in_same_tenant %}
| {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{prov}} | {{tenant.name}} |
{% else %}
| {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{prov}} | common |
{% endif %}
{% endfor %}
{% endfor %}
</caption>
{% else %}
No contracts are being provided by VRFs.
{% endif %}

##### Consumed Contracts

{% for vrf in tenant.vrfs | default([]) %}
{% if vrf.contracts.providers|length > 0 %}
{% set consumed_contracts = true %}
{% endif %}
{% endfor %}
{% if consumed_contracts %}
<caption name="VRF Consumed contracts - {{tenant.name}}">

| VRF Name | Contract | Contract owned by Tenant |
|---|---|---|
{% for vrf in tenant.vrfs | default([]) %}
{% for contract in vrf.contracts.consumers | default([]) %}
{% set ns = namespace(same_tenant=False) %}
{% for ctr in tenant.contracts | default([])%}
{%if ctr.name == contract %}
{% set ns.same_tenant = True %}
{% endif %}
{% endfor %}
{% if ns.same_tenant == True %}
| {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{contract ~ defaults.apic.tenants.contracts.name_suffix}} | {{tenant.name}} |
{% else %}
| {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{contract ~ defaults.apic.tenants.contracts.name_suffix}} | common |
{% endif %}
{% endfor %}
{% for contract in vrf.contracts.imported_consumers | default([])%}
{% for imp_ctr in tenant.imported_contracts | default([]) %}
{‰ if contract == imp_ctr.name %}
| {{ tenant.name }} | {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{contract ~ defaults.apic.tenants.contracts.name_suffix}} | {{imp_ctr.tenant}} |
{‰ endif %}
{% endfor %}
{% endfor %}
{% endfor %}
</caption>
{% else %}
No contracts are being consumed by VRFs.
{% endif %}

{% if tenant.vrfs|length > 0 %}
##### Miscellaneous Properties

<caption name="VRF(s) Properties - {{tenant.name}}">

| VRF | Create SNMP Context | DNS Labels | IP Dataplane Learning | Endpoint Retention Policy | Monitoring Policy |
|---|---|---|---|---|---|
{% for vrf in tenant.vrfs | default([])%}
| {{ tenant.name }} | {{vrf.name ~ defaults.apic.tenants.vrfs.name_suffix}} | {{vrf.dns_labels|default([])|join(", ")}} | {% if vrf.data_plane_learning | default(defaults.apic.tenants.vrfs.data_plane_learning) %}enabled{%else%}disabled{%endif%} | | |
{% endfor %}
</caption>
{% endif %}

#### Bridge Domains

{% if tenant.bridge_domains|length > 0 %}
<caption name="Bridge Domains - {{tenant.name}}">

| Name | VRF | Description | BD Configuration | BD Subnets | Associated L3OUTs |
|---|---|---|---|---|---|
{% for bd in tenant.bridge_domains | default([])%}
{% set ns = namespace(bd_subnets = []) %}
{% for subnet in bd.subnets %}
{% if subnet.public | default(defaults.apic.tenants.bridge_domains.subnets.public) %}{% set _ = ns.bd_subnets.append(subnet.ip ~ " (public)")%}{%else%}{% set _ = ns.bd_subnets.append(subnet.ip ~ " (private)")%}{%endif%}
{% endfor %}
| {{bd.name ~ defaults.apic.tenants.bridge_domains.name_suffix}} | {{ bd.vrf | default("")}} | {{bd.description|default("")}} | L2 Unicast: {{bd.unkown_unicast|default(defaults.apic.tenants.bridge_domains.unknown_unicast)}}<br>L3 Unknown Multicast: {{bd.unknown_ipv4_multicast|default(defaults.apic.tenants.bridge_domains.unknown_ipv4_multicast)}}<br>Multi-destination Flooding: {{bd.multi_destination_flooding|default(defaults.apic.tenants.bridge_domains.multi_destination_flooding)}}<br>Unicast Routing: {{bd.unicast_routing|default(defaults.apic.tenants.bridge_domains.unicast_routing)}}<br>ARP Flooding: {{bd.arp_flooding | default(defaults.apic.tenants.bridge_domains.arp_flooding)}}<br>Unicast Routing: {{bd.unicast_routing | default(defaults.apic.tenants.bridge_domains.arp_flooding)}}<br>Limit IP Learning to Subnet: {{bd.limit_ip_learn_to_subnets|default(defaults.apic.tenants.bridge_domains.limit_ip_learn_to_subnets)}}<br>EP Move Detect: {{bd.ep_move_detection|default(defaults.apic.tenants.bridge_domains.ep_move_detection)}} | {{ns.bd_subnets|join("<br>")}} | {{bd.l3outs|default([])|join("<br>")}} |
{%endfor%}
</caption>
{% else %}
No Bridge Domains configured.
{%endif%}

#### L3OUTs

{% if tenant.l3outs|length > 0 %}
{% for l3out in tenant.l3outs | default([])%}

##### L3OUT Details: {{ l3out.name ~ defaults.apic.tenants.l3outs.name_suffix }}

<caption name="Layer 3 Outside Connections ({{l3out.name}}) - {{tenant.name}}">

| Name | VRF | Description | External L3 Domain | Routing Protocol |
|---|---|---|---|---|
{% set ns = namespace(bgp=False,ospf=False,eigrp=False)%}
{% for node in l3out.node_profiles | default([])%}
{% if node.bgp_peers is defined%}
{% set ns.bgp = True%}
{% endif %}
{% endfor %}
{% if l3out.ospf is defined %}
{% set ns.ospf = True%}
{% endif %}
{% set protocols = []%}
{% if ns.bgp %}{% set _ = protocols.append("BGP")%}{%endif%}
{% if ns.ospf %}{% set _ = protocols.append("OSPF")%}{%endif%}
| {{l3out.name ~ defaults.apic.tenants.l3outs.name_suffix}} | {{l3out.vrf ~ defaults.apic.tenants.vrfs.name_suffix}} | {{l3out.description | default("")}} | {{l3out.domain ~ defaults.access_policies.routed_domains.name_suffix}} | {{protocols | join(", ")}} |
</caption>
{%endfor%}
{% else %}
No L3OUTs configured.
{% endif %}

###### Node and Interface Profiles

{% if l3out.node_profiles is defined%}
<caption name="Logical Node Profile(s) ({{l3out.name}}) - {{tenant.name}}">

| Name | Description | Node ID | Router ID / Is Loopback | Static Route / Next Hop |
|---|---|---|---|---|
{% for node_profile in l3out.node_profiles | default([]) %}
{% for node in node_profile.nodes | default([]) %}
{% for route in node.static_routes | default([]) %}
{% for next_hop in route.next_hops | default([]) %}
| {{ node_profile.name ~ defaults.apic.tenants.l3outs.nodes.node_profiles.name_suffix }} | | {{node.router_id}} / {% if node.router_id_as_loopback | default(defaults.apic.tenants.l3outs.node_profiles.nodes.router_id_as_loopback)%}yes{%else%}no{%endif%} | {{route.prefix}} / {{next_hop.ip}} |
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
</caption>
{% else %}
No L3OUT Node Profiles configured.
{% endif %}

{% if l3out.ospf is defined %}
<caption name="Logical Interface Profile(s) ({{l3out.name}}) - {{tenant.name}}">

| Node Profile | Node | Path | Type | IP Address | Encap | OPSF Interface Profile | Auth Type | Auth Key Id |
|---|---|---|---|---|---|---|---|---|
{% for node_prof in l3out.node_profiles | default([])%}
{% for int_prof in node_prof.interface_profiles | default([])%}
{% for int in int_prof.interfaces | default([])%}
{% set ns = namespace(pod_id="1") %}{% for node in apic.node_policies.nodes | default([]) %}{% if node.id == int.node_id %}{% set ns.pod_id = node.pod | default(defaults.apic.node_policies.nodes.pod)%}{%endif%}{% endfor %}
| {{node_prof.name }} | {% if int.node2_id is defined %}{{ int.node_id ~","~int.node2_id}}{%else%}{{int.node_id}}{%endif%} | {% if int.node2_id is defined %}topology/pod-{{ns.pod_id}}/protpaths-{{int.node_id}}-{{int.node2_id}}/pathep-[{{int.channel}}]{%else%}topology/pod-{{ns.pod_id}}/paths-{{int.node_id}}/pathep-[eth{{int.module|default(defaults.apic.l3outs.node_profiles.interface_profiles.interfaces.module)}}/{{int.port}}]{%endif%} | {{int.ip | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.ip)}} | {% if int.vlan is defined %}{{ "vlan-"~int.vlan }}{%endif%} | | | |
{% endfor %}
{% endfor %}
{% endfor %}
</caption>

{% elif l3out.node_profiles is defined %}
<caption name="Logical Interface Profile(s) ({{l3out.name}}) - {{tenant.name}}">

| Node Profile | Node | Path | Type | IP Address | Encap |
|---|---|---|---|---|---|
{% for node_prof in l3out.node_profiles | default([])%}
{% for int_prof in node_prof.interface_profiles | default([])%}
{% for int in int_prof.interfaces | default([])%}
{% set ns = namespace(pod_id="1") %}{% for node in apic.node_policies.nodes | default([]) %}{% if node.id == int.node_id %}{% set ns.pod_id = node.pod | default(defaults.apic.node_policies.nodes.pod)%}{%endif%}{% endfor %}
| {{node_prof.name }} | {% if int.node2_id is defined %}{{ int.node_id ~","~int.node2_id}}{%else%}{{int.node_id}}{%endif%} | {% if int.node2_id is defined %}topology/pod-{{ns.pod_id}}/protpaths-{{int.node_id}}-{{int.node2_id}}/pathep-[{{int.channel}}]{%else%}topology/pod-{{ns.pod_id}}/paths-{{int.node_id}}/pathep-[eth{{int.module|default(defaults.apic.l3outs.node_profiles.interface_profiles.interfaces.module)}}/{{int.port}}]{%endif%} | {{int.ip | default(defaults.apic.tenants.l3outs.node_profiles.interface_profiles.interfaces.ip)}} | {% if int.vlan is defined %}{{ "vlan-"~int.vlan }}{%endif%} |
{% endfor %}
{% endfor %}
{% endfor %}
</caption>
{% endif %}

{% if l3out.ospf is defined %}
<caption name="OSPF Configuration ({{l3out.name}}) - {{tenant.name}}">

| L3OUT | Area ID | Area Type | Area Cost | Area Controls |
|---|---|---|---|---|
| {{l3out.name ~ defaults.apic.tenants.l3outs.name_suffix}} | {{ l3out.ospf.area }} | {{l3out.ospf.area_type | default(defaults.apic.tenants.l3outs.ospf.area_type)}} | {{l3out.ospf.area_cost | default(defaults.apic.tenants.l3outs.ospf.area_cost)}} | |
</caption>
{% endif %}

##### External Network Profiles (External EPGs)

{% if l3out.external_endpoint_groups|length > 0 %}
<caption name ="External Network Profile(s) ({{l3out.name}}) - {{tenant.name}}">

| Name | Subnet | Aggregate | Scope | Route Summarization |
|---|---|---|---|---|
{% for extepg in l3out.external_endpoint_groups | default([])%}
{% for subnet in extepg.subnets | default([])%}
{% set scopes = []%}
{% if subnet.import_security | default(defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.import_security) %}{% set _ = scopes.append("External Subnets for the External EPG")%}{%endif%}{% if subnet.shared_security | default(defaults.apic.tenants.l3outs.external_endpoint_groups.subnets.shared_security)%}{% set _ = scopes.append("Shared Security Import Subnet")%}{%endif%}
| {{tenant.name}} | {{l3out.name ~ defaults.apic.tenants.l3outs.name_suffix}} | {{extepg.name ~ defaults.apic.tenants.l3outs.external_endpoint_groups.name_suffix}} | {{ subnet.prefix }} | {% if subnet.prefix == "0.0.0.0/0" and subnet.export_route_control | default(defaults.apic.tenants.l3outs.external_endpoint_groups.export_route_control) and subnet.aggregate_export_route_control | default(defaults.apic.tenants.l3outs.external_point_groups.aggregate_export_route_control)%}0.0.0.0/0 le 32{%elif subnet.export_route_control|default(defaults.apic.tenants.l3outs.external_endpoint_groups.export_route_control) and subnet.bgp_route_summarization|default(defaults.apic.tenants.l3outs.external_endpoint_groups.bgp_route_summarization) %}{{subnet.prefix}}{%else%} {%endif%} | {{scopes|join("<br>")}} | {%if subnet.export_route_control|default(defaults.apic.tenants.l3outs.external_endpoint_groups.export_route_control) and subnet.bgp_route_summarization|default(defaults.apic.tenants.l3outs.external_endpoint_groups.bgp_route_summarization) %}{{subnet.prefix}}{%endif%} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No External Network Profiles (External EPGs) configured.
{% endif %}

#### Security Policies

##### Contracts

{% if tenant.contracts|length >0 %}
<caption name="Contracts - {{tenant.name}}">

| Contract | Scope | QoS-Class |
|---|---|---|
{% for contract in tenant.contracts | default([]) %}
| {{contract.name ~ defaults.apic.tenants.contracts.name_suffix}} | {{contract.scope | default(defaults.apic.tenants.contracts.scope)}} | {{contract.qos_class | default(defaults.apic.tenants.contracts.qos_class)}} |
{% endfor %}
{% for contract in tenant.oob_contracts | default([]) %}
| {{contract.name ~ defaults.apic.tenants.oob_contracts.name_suffix}} | {{contract.scope | default(defaults.apic.tenants.oob_contracts.scope)}} | |
{% endfor %}
</caption>
{% else %}
No contracts configured.
{% endif %}

##### Subjects

{% for contract in tenants.contracts | default([]) %}
{% for subject in contract.subjects | default([]) %}
{% if subject.filters|length >0 %}
{% set subjects_configured = true %}
{% endif %}
{% endfor %}
{% endfor %}
{% if subjects_configured %}
<caption name="Subjects - {{tenant.name}}">

| Contract | Subject | Description | QoS-Class | Reverse Filter Ports | Filter | Action |
|---|---|---|---|---|---|---|
{% for contract in tenants.contracts | default([]) %}
{% for subject in contract.subjects | default([]) %}
{% for filter in subject.filters | default([])%}
| {{contract.name ~ defaults.apic.tenants.contracts.name_suffix}} | {{subject.name ~ defaults.apic.tenants.contracts.subjects.name_suffix}} | {{subject.description | default("")}} | {{subject.qos_class | default(defaults.apic.tenants.contracts.subjects.qos_class)}} | | {{filter.name}} | {{ filter.action | default(defaults.apic.tenants.contracts.subjects.filters.action)}} |
{% endfor %}
{% endfor %}
{% endfor %}
{% for contract in tenants.oob_contracts | default([]) %}
{% for subject in contract.subjects | default([]) %}
{% for filter in subject.filters | default([])%}
| {{subject.name ~ defaults.apic.tenants.contracts.subjects.name_suffix}} | {{contract.name ~ defaults.apic.tenants.contracts.name_suffix}} | {{tenant.name}} | {{subject.description | default("")}} | | | {{filter.name}} | |
{% endfor %}
{% endfor %}
{% endfor %}
</caption>
{% else %}
No contract subjects configured.
{% endif %}

##### Filters

{% if tenant.filters|length > 0 %}
<caption name="Filters - {{tenant.name}}">

| Filter Name | Entry | EtherType | ARP Flag | IP Protocol | Src Port From | Src Port To | Dst Port From | Dst Port To | TCP Rules |
|---|---|---|---|---|---|---|---|---|---|
{% for filter in tenant.filters | default([])%}
{% for entry in filter.entries | default([]) %}
{% set properties = [] %}
{% if entry.stateful | default(defaults.apic.tenants.filters.entries.stateful) %}{% set x = properties.append("Stateful: Enabled")%}{%else%}{%set _ = properties.append("Stateful: Disabled")%}{%endif%}
| {{ filter.name ~ defaults.apic.tenants.filters.name_suffix}} | {{entry.name ~ defaults.apic.tenants.filters.entries.name_suffix}} | {{entry.ethertype | default(defaults.apic.tenants.filters.entries.ethertype)}} | | {{entry.protocol | default(defaults.apic.tenants.filters.entries.protocol)}} | {{entry.source_from_port | default(defaults.apic.tenants.filters.subjects.entries.source_from_port)}} | {{entry.source_to_port|default("")}} | {{entry.destination_from_port | default(defaults.apic.tenants.filters.entries.destination_from_port)}} | {{entry.destination_to_port | default("")}} | {{properties|join("<br>")}} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No contract filters configured.
{% endif %}

#### Policies (Protocol)

##### BGP Policies

{% if tenant.policies.bgp_address_family_context_policies|length > 0 %}
<caption name="BGP Address Family Context - {{tenant.name}}">

| Name | Description | eBGP Distance | iBGP Distance | Local Distance | eBGP Max ECMP | iBGP Max ECMP | Local Max ECMP | Enable Host Route Leak |
|---|---|---|---|---|---|---|---|---|
{% for bgp_afi_pol in tenant.policies.bgp_address_family_context_policies | default([]) %}
| {{bgp_afi_pol.name ~ defaults.apic.tenants.policies.bgp_address_family_context_policies.name_suffix}} | {{bgp_afi_pol.description | default("")}} | {{bgp_afi_pol.ebgp_distance | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ebgp_distance)}} | {{bgp_afi_pol.ibgp_distance | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ibgp_distance)}} | {{bgp_afi_pol.local_distance | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.local_distance)}} | {{bgp_afi_pol.ebgp_max_ecmp | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ebgp_max_ecmp)}} | {{bgp_afi_pol.ibgp_max_ecmp | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.ibgp_max_ecmp)}} | {{bgp_afi_pol.local_max_ecmp | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.local_max_ecmp)}} | {{bgp_afi_pol.enable_host_route_leak | default(defaults.apic.tenants.policies.bgp_address_family_context_policies.enable_host_route_leak)}} |
{% endfor %}
</caption>
{% else %}
No BGP Policies configured.
{% endif %}

##### OSPF Policies

{% if tenant.policies.ospf_interface_policies|length > 0 %}
<caption name="OSPF Timer Policies - {{tenant.name}}">

| Name | Description | Network Type | Interface Controls | Hello Interval | Dead Interval | Retransmit Interval | Transmit Delay |
|---|---|---|---|---|---|---|---|
{% for ospf_pol in tenant.policies.ospf_interface_policies | default([]) %}
| {{ ospf_pol.name | default(defaults.apic.tenants.policies.ospf_interface_policies.name_suffix)}} | {{ospf_pol.description | default("")}} | {{ospf_pol.network_type | default(defaults.apic.tenants.policies.ospf_interface_policies.network_type)}} | Passive Interface: {% if ospf_pol.passive_interface | default(defaults.apic.tenants.policies.ospf_interface_policies) %}enabled{%else%}disabled{%endif%}<br>MTU Ignore: {%if ospf_pol.mtu_ignore | default(defaults.apic.tenants.policies.ospf_interface_policies.mtu_ignore)%}enabled{%else%}disabled{%endif%}<br>Advertise Subnet: {%if ospf_pol.advertise_subnet | default(defaults.apic.tenants.policies.ospf_interface_policies.advertise_subnet)%}enabled{%else%}disabled{%endif%}<br>BFD: {%if ospf_pol.bfd | default(defaults.apic.tenants.policies.ospf_interface_policies)%}enabled{%else%}disabled{%endif%} | {{ospf_pol.hello_interval | default(defaults.apic.tenants.policies.ospf_interface_policies.hello_interval)}} | {{ospf_pol.dead_interval | default(defaults.apic.tenants.policies.ospf_interface_policies.dead_interval)}} | {{ospf_pol.lsa_retransmit_interval | default(defaults.apic.tenants.policies.ospf_interface_policies.lsa_retransmit_interval)}} | {{ospf_pol.lsa_transmit_delay | default(defaults.apic.tenants.policies.ospf_interface_policies.lsa_transmit_delay)}} |
{% endfor %}
</caption>
{% else %}
No OSPF policies configured.
{% endif %}

##### DHCP

{% for dchp_rel in tenant.policies.dhcp_relay_policies | default([])%}
{% if dhcp_rel.providers|length > 0 %}
{% set dchp_policies_configured = true %}
{% endif %}
{% endfor %}
{% if dchp_policies_configured %}
<caption name ="DHCP Relay Policies - {{tenant.name}}">

| Name | Description | Owner | Provider IP | Associated EPG |
|---|---|---|---|---|
{% for dchp_rel in tenant.policies.dhcp_relay_policies | default([])%}
{% for prov in dhcp_rel.providers | default([]) %}
| {{dhcp_rel.name ~ defaults.apic.tenants.policies.dhcp_relay_policies.name_suffix}} | {{dhcp_rel.description | default("")}} | tenant | {{prov.ip}} | {%if prov.type == "epg"%}uni/tn-{{prov.name}}/ap-{{prov.application_profile}}/epg-{{prov.endpoint_group}}{%else%}uni/tn-{{prov.tenant}}/out-{{prov.l3out}}/instP-{{prov.external_endpoint_group}}{%endif%} |
{%endfor%}
{%endfor%}
</caption>
{% else %}
No DHCP Policies configured.
{% endif %}

{% for bd in tenant.bridge_domains | default([])%}
{% if bd.dhcp_labels|length > 0 %}
{% set dhcp_labels_inuse = true %}
{% endif %}
{% endfor %}
{% if dhcp_labels_inuse %}
<caption name="DHCP Relay Associated Bridge Domains - {{tenant.name}}">

| Bridge Domain | DHCP Relay Policy | Owner |
|---|---|---|
{% for bd in tenant.bridge_domains | default([])%}
{% for dhcp in bd.dhcp_labels %}
| {{bd.name ~ defaults.apic.tenants.bridge_domains.name_suffix}} | {{dhcp.dhcp_relay_policy}} | tenant |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No DHCP Policies associated with Bridge Domains.
{% endif %}

##### Route Maps

{% for l3out in tenants.l3outs | default([])%}
{% if l3out.import_route_map.contexts|length > 0 or l3out.export_route_map.contexts|length > 0%}
{% set default_route_maps_defined = true %}
{% endif %}
{% endfor %}
{% if default_route_maps_defined %}
<caption name="Default L3OUT Route-Maps - {{tenant.name}}">

| L3OUT | Route-Map | Direction | Continue? | Context Name | Action | Order | Match Rule | Set Rule |
|---|---|---|---|---|---|---|---|---|
{% for l3out in tenants.l3outs | default([])%}
{% for context in l3out.import_route_map.contexts | default([]) %}
| {{l3out.name ~ defaults.apic.tenants.l3outs.name_suffix}} | default-import | Import | No | {{context.name ~ defaults.apic.tenants.l3outs.import_route_map.contexts.name_suffix}} | {{context.action | default(defaults.apic.tenants.l3outs.import_route_map.contexts.action)}} | {{context.order | default(defaults.apic.tenants.l3outs.import_route_map.contexts.order)}} | {%if context.match_rule is defined%}{{context.match_rule}} {%endif%}| {% if context.set_rule %}{{context.set_rule}}{%endif%} |
{% endfor %}
{% for export in l3out.export_route_map.contexts | default([]) %}
| {{l3out.name ~ defaults.apic.tenants.l3outs.name_suffix}} | default-export | Export | No | {{context.name ~ defaults.apic.tenants.l3outs.export_route_map.contexts.name_suffix}} | {{context.action | default(defaults.apic.tenants.l3outs.export_route_map.contexts.action)}} | {{context.order | default(defaults.apic.tenants.l3outs.export_route_map.contexts.order)}} | {%if context.match_rule is defined%}{{context.match_rule}} {%endif%}| {% if context.set_rule %}{{context.set_rule}}{%endif%} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Default Route Maps configured.
{% endif %}

{% if tenant.policies.route_control_route_maps|length > 0 %}
<caption name="Route-Maps - {{tenant.name}}">

| Route-Map | Context | Action | Order | Match Rule(s) | Set Rule |
|---|---|---|---|---|---|
{% for rm in tenant.policies.route_control_route_maps | default([])%}
{% for ctx in rm.contexts %}
| {{rm.name ~ defaults.apic.tenants.policies.route_control_route_maps.name_suffix}} | {{ctx.name ~ defaults.apic.tenants.policies.route_control_route_maps.contexts.name_suffix}} | {{ctx.action | default(defaults.apic.tenants.policies.route_control_route_maps.contexts.action) }} | {{ctx.order | default(defaults.apic.tenants.policies.route_control_route_maps.contexts.order)}} | {{ctx.match_rules|default([])|join("<br>")}} | {{ctx.set_rule | default("")}} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Route-Maps configured.
{% endif %}

{% if tenant.policies.match_rules|length > 0 %}
<caption name="Prefix Match Rules - {{tenant.name}}">

| Match Rule | Description | Prefix | Prefix Description | Prefix Aggregate | Prefix From Lenght | Prefix To Length |
|---|---|---|---|---|---|---|
{% for mr in tenant.policies.match_rules | default([]) %}
{% for prefix in mr.prefixes | default([])%}
| {{ tenant.name }} | {{mr.name ~ defaults.apic.tenants.policies.match_rules.name_suffix}} | {{mr.description | default("")}} | {{prefix.ip}} | {{prefix.aggregate | default(defaults.apic.tenants.policies.match_rules.prefixes.aggregate)}} | {{prefix.from_length | default(defaults.apic.tenants.policies.match_rules.prefixes.from_length)}} | {{prefix.to_length | default(defaults.apic.tenants.policies.match_rules.prefixes.to_length)}} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Prefix Match Rules configured.
{% endif %}

{% if tenant.policies.match_rules|length > 0 %}
<caption name="Community Match Rules - {{tenant.name}}">

| Match Rule | Description | Comunity Rule | Community Rule Description | Community | Description | Scope |
|---|---|---|---|---|---|---|
{% for mr in tenant.policies.match_rules | default([]) %}
{% for community in mr.regex_community_terms | default([])%}
{% for community in community_mr.factors | default([]) %}
| {{mr.name ~ defaults.apic.tenants.policies.match_rules}} | {{mr.description | default("")}} | {{community_mr.name}} | {{community_mr.description | default("")}} | {{community.community}} | {{community.description | default("")}} | {{community.scope | default(defaults.apic.tenants.policies.match_rules.community_terms.factors.scope)}} |
{% endfor %}
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Community Match Rules configured.
{% endif %}

{% if tenant.policies.match_rules|length > 0 %}
<caption name="Regex Community Match Rules - {{tenant.name}}">

| Match Rule | Description | Community Rule | Community Rule Description | Name | Description | Type | Regex |
|---|---|---|---|---|---|---|---|
{% for mr in tenant.policies.match_rules | default([]) %}
{% for prefix in mr.prefixes | default([])%}
| {{mr.name ~ defaults.apic.tenants.policies.match_rules.name_suffix}} | {{mr.description | default("")}} | {{community.name ~ defaults.apic.tenants.policies.match_rules.regex_community_terms.name_suffix}} | {{community.description | default("")}} | {{community.type | default(defaults.apic.tenants.policies.match_rules.regex_community_terms.type)}} | {{community.regex}} |
{% endfor %}
{% endfor %}
</caption>
{% else %}
No Regex Community Match Rules configured.
{% endif %}

{% if tenant.policies.set_rules|length > 0 %}
<caption name="Set Rules - {{tenant.name}}">

| Set Rule | Description | Properties |
|---|---|---|
{% for rule in tenant.policies.set_rules | default([]) %}
{% set ns = namespace(properties = [])%}
{% if rule.community is defined%}{% set _ = ns.properties.append("Community: " ~ rule.community ~ " (" ~ rule.community_mode|default(defaults.apic.tenants.policies.set_rules.community_mode) ~ ")")%}{%endif%}
{% if rule.tag is defined%}{%set _ = ns.properties.append("Tag: "~rule.tag)%}{%endif%}
{% if rule.weight is defined%}{%set _ = ns.properties.append("Weight: "~rule.weight)%}{%endif%}
{% if rule.next_hop is defined%}{%set _ = ns.properties.append("Next-hop: "~rule.next_hop)%}{%endif%}
{% if rule.preference is defined%}{%set _ = ns.properties.append("Preference: "~rule.preference)%}{%endif%}
{% if rule.metric is defined%}{%set _ = ns.properties.append("Metric: "~rule.metric)%}{%endif%}
{% if rule.next_hop_propagation is defined%}{%if rule.next_hop_propagation %}{%set _ = ns.properties.append("Next-hop Propagation: Enabled")%}{%else%}{%set _ = ns.properties.append("Next-hop Propagation: Disabled")%}{%endif%}{%endif%}
{% if rule.multipath is defined%}{%if rule.multipath %}{%set _ = ns.properties.append("Multipath: Enabled")%}{%else%}{%set _ = ns.properties.append("Multipath: Disabled")%}{%endif%}{%endif%}
{% if rule.dampening is defined%}{%set _ = ns.properties.append("Dampening Half-Life: "~rule.dampening.half_life|default(defaults.apic.tenants.policies.set_rules.dampening.half_life)~"<br>Dampening Max Suppress Time: "~rule.dampening.max_suppress_time|default(defaults.apic.tenants.policies.set_rules.dampening.max_suppress_time)~"<br>Dampening Reuse Limit: "~rule.dampening.reuse_limit|default(defaults.apic.tenants.policies.set_rules.dampening.reuse_limit)~"<br>Dampening Suppress Limit: "~rule.dampening.suppress_limit|default(defaults.apic.tenants.policies.set_rules.dampening.suppress_limit))%}{%endif%}
{% if rule.set_as_path is defined%}{%set _ = ns.properties.append("AS-path ASN: "~rule.set_as_path.asn~"<br>AS-path Count: "~rule.set_as_path.count|default(defaults.apic.tenants.policies.set_rules.set_as_path.count)~"<br>AS-path Criteria: "~rule.set_as_path.criteria|default(defaults.apic.tenants.policies.set_rules.set_as_path.criteria)~"<br>AS-path Order: "~rule.set_as_path.order|default(defaults.apic.tenants.policies.set_rules.set_as_path.order))%}{%endif%}
{% for com in rule.additional_communities | default([]) %}
{% set _ = ns.properties.append(com.community)%}
{% endfor %}
| {{ rule.name ~ defaults.apic.tenants.policies.set_rules.name_suffix}} | {{rule.description | default("")}} | {{ns.properties|join("<br>")}} |
{% endfor %}
</caption>
{% else %}
No Set Rules configured.
{% endif %}

{%endfor%}
