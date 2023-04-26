<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-nac-aci/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-nac-aci/actions/workflows/test.yml)

# Terraform ACI Nexus-as-Code Module

A Terraform module to configure ACI.

This module is part of the Cisco [*Nexus-as-Code*](https://cisco.com/go/nexusascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level ACI object model. More information can be found here: https://cisco.com/go/nexusascode.

A comprehensive example using this module is available here: https://github.com/netascode/nac-aci-comprehensive-example

## Usage

This module supports an inventory driven approach, where a complete ACI configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

There are six configuration sections which can be selectively enabled or disabled using module flags:

- `fabric_policies`: Configurations applied at the fabric level (e.g., fabric BGP route reflectors)
- `access_policies`: Configurations applied to external facing (downlink) interfaces (e.g., VLAN pools)
- `pod_policies`: Configurations applied at the pod level (e.g., TEP pool addresses)
- `node_policies`: Configurations applied at the node level (e.g., OOB node management address)
- `interface_policies`: Configurations applied at the interface level (e.g., assigning interface policy groups to physical ports)
- `tenants`: Configurations applied at the tenant level (e.g., VRFs and Bridge Domains)

The full data model documentation is available here: https://developer.cisco.com/docs/nexus-as-code/#!data-model

## Examples

Configuring a VLAN Pool using YAML:

#### `vlan_pool.yaml`

```hcl
apic:
  access_policies:
    vlan_pools:
      - name: VLAN_POOL_1
        ranges:
          - from: 1000
            to: 1099
```

#### `main.tf`

```hcl
module "vlan_pool" {
  source  = "netascode/aci/aci"
  version = "0.1.0"

  yaml_files = ["vlan_pool.yaml"]

  manage_access_policies = true
}
````

Configuring a Banner using native HCL:

#### `main.tf`

```hcl
module "banner" {
  source  = "netascode/aci/aci"
  version = "0.1.0"

  model = {
    apic = {
      fabric_policies = {
        banners = {
          apic_cli_banner = "My APIC Banner"
        }
      }
    }
  }

  manage_fabric_policies = true
}
````

Additional example repositories:

- https://github.com/netascode/nac-aci-simple-example
- https://github.com/netascode/nac-aci-comprehensive-example

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.6.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.2.4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_manage_access_policies"></a> [manage\_access\_policies](#input\_manage\_access\_policies) | Flag to indicate if access policies should be managed. | `bool` | `false` | no |
| <a name="input_manage_fabric_policies"></a> [manage\_fabric\_policies](#input\_manage\_fabric\_policies) | Flag to indicate if fabric policies should be managed. | `bool` | `false` | no |
| <a name="input_manage_interface_policies"></a> [manage\_interface\_policies](#input\_manage\_interface\_policies) | Flag to indicate if interface policies should be managed. | `bool` | `false` | no |
| <a name="input_manage_node_policies"></a> [manage\_node\_policies](#input\_manage\_node\_policies) | Flag to indicate if node policies should be managed. | `bool` | `false` | no |
| <a name="input_manage_pod_policies"></a> [manage\_pod\_policies](#input\_manage\_pod\_policies) | Flag to indicate if pod policies should be managed. | `bool` | `false` | no |
| <a name="input_manage_tenants"></a> [manage\_tenants](#input\_manage\_tenants) | Flag to indicate if tenants should be managed. | `bool` | `false` | no |
| <a name="input_managed_interface_policies_nodes"></a> [managed\_interface\_policies\_nodes](#input\_managed\_interface\_policies\_nodes) | List of node IDs for which interface policies should be managed. By default interface policies for all nodes will be managed. | `list(number)` | `[]` | no |
| <a name="input_managed_tenants"></a> [managed\_tenants](#input\_managed\_tenants) | List of tenant names to be managed. By default all tenants will be managed. | `list(string)` | `[]` | no |
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | `[]` | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.3.0 |
| <a name="provider_utils"></a> [utils](#provider\_utils) | >= 0.2.4 |

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [utils_yaml_merge.defaults](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
| [utils_yaml_merge.model](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aci_aaa"></a> [aci\_aaa](#module\_aci\_aaa) | netascode/aaa/aci | 0.1.0 |
| <a name="module_aci_aaep"></a> [aci\_aaep](#module\_aci\_aaep) | netascode/aaep/aci | 0.2.0 |
| <a name="module_aci_access_fex_interface_profile_auto"></a> [aci\_access\_fex\_interface\_profile\_auto](#module\_aci\_access\_fex\_interface\_profile\_auto) | netascode/access-fex-interface-profile/aci | 0.1.0 |
| <a name="module_aci_access_fex_interface_profile_manual"></a> [aci\_access\_fex\_interface\_profile\_manual](#module\_aci\_access\_fex\_interface\_profile\_manual) | netascode/access-fex-interface-profile/aci | 0.1.0 |
| <a name="module_aci_access_fex_interface_selector_auto"></a> [aci\_access\_fex\_interface\_selector\_auto](#module\_aci\_access\_fex\_interface\_selector\_auto) | netascode/access-fex-interface-selector/aci | 0.2.0 |
| <a name="module_aci_access_fex_interface_selector_manual"></a> [aci\_access\_fex\_interface\_selector\_manual](#module\_aci\_access\_fex\_interface\_selector\_manual) | netascode/access-fex-interface-selector/aci | 0.2.0 |
| <a name="module_aci_access_leaf_interface_policy_group"></a> [aci\_access\_leaf\_interface\_policy\_group](#module\_aci\_access\_leaf\_interface\_policy\_group) | netascode/access-leaf-interface-policy-group/aci | 0.1.4 |
| <a name="module_aci_access_leaf_interface_profile_auto"></a> [aci\_access\_leaf\_interface\_profile\_auto](#module\_aci\_access\_leaf\_interface\_profile\_auto) | netascode/access-leaf-interface-profile/aci | 0.1.0 |
| <a name="module_aci_access_leaf_interface_profile_manual"></a> [aci\_access\_leaf\_interface\_profile\_manual](#module\_aci\_access\_leaf\_interface\_profile\_manual) | netascode/access-leaf-interface-profile/aci | 0.1.0 |
| <a name="module_aci_access_leaf_interface_selector_auto"></a> [aci\_access\_leaf\_interface\_selector\_auto](#module\_aci\_access\_leaf\_interface\_selector\_auto) | netascode/access-leaf-interface-selector/aci | 0.2.1 |
| <a name="module_aci_access_leaf_interface_selector_manual"></a> [aci\_access\_leaf\_interface\_selector\_manual](#module\_aci\_access\_leaf\_interface\_selector\_manual) | netascode/access-leaf-interface-selector/aci | 0.2.1 |
| <a name="module_aci_access_leaf_interface_selector_sub_auto"></a> [aci\_access\_leaf\_interface\_selector\_sub\_auto](#module\_aci\_access\_leaf\_interface\_selector\_sub\_auto) | netascode/access-leaf-interface-selector/aci | 0.2.1 |
| <a name="module_aci_access_leaf_switch_policy_group"></a> [aci\_access\_leaf\_switch\_policy\_group](#module\_aci\_access\_leaf\_switch\_policy\_group) | netascode/access-leaf-switch-policy-group/aci | 0.1.0 |
| <a name="module_aci_access_leaf_switch_profile_auto"></a> [aci\_access\_leaf\_switch\_profile\_auto](#module\_aci\_access\_leaf\_switch\_profile\_auto) | netascode/access-leaf-switch-profile/aci | 0.2.0 |
| <a name="module_aci_access_leaf_switch_profile_manual"></a> [aci\_access\_leaf\_switch\_profile\_manual](#module\_aci\_access\_leaf\_switch\_profile\_manual) | netascode/access-leaf-switch-profile/aci | 0.2.0 |
| <a name="module_aci_access_span_destination_group"></a> [aci\_access\_span\_destination\_group](#module\_aci\_access\_span\_destination\_group) | netascode/access-span-destination-group/aci | 0.1.3 |
| <a name="module_aci_access_span_filter_group"></a> [aci\_access\_span\_filter\_group](#module\_aci\_access\_span\_filter\_group) | netascode/access-span-filter-group/aci | 0.1.2 |
| <a name="module_aci_access_span_source_group"></a> [aci\_access\_span\_source\_group](#module\_aci\_access\_span\_source\_group) | netascode/access-span-source-group/aci | 0.1.0 |
| <a name="module_aci_access_spine_interface_policy_group"></a> [aci\_access\_spine\_interface\_policy\_group](#module\_aci\_access\_spine\_interface\_policy\_group) | netascode/access-spine-interface-policy-group/aci | 0.1.0 |
| <a name="module_aci_access_spine_interface_profile_auto"></a> [aci\_access\_spine\_interface\_profile\_auto](#module\_aci\_access\_spine\_interface\_profile\_auto) | netascode/access-spine-interface-profile/aci | 0.1.0 |
| <a name="module_aci_access_spine_interface_profile_manual"></a> [aci\_access\_spine\_interface\_profile\_manual](#module\_aci\_access\_spine\_interface\_profile\_manual) | netascode/access-spine-interface-profile/aci | 0.1.0 |
| <a name="module_aci_access_spine_interface_selector_auto"></a> [aci\_access\_spine\_interface\_selector\_auto](#module\_aci\_access\_spine\_interface\_selector\_auto) | netascode/access-spine-interface-selector/aci | 0.2.0 |
| <a name="module_aci_access_spine_interface_selector_manual"></a> [aci\_access\_spine\_interface\_selector\_manual](#module\_aci\_access\_spine\_interface\_selector\_manual) | netascode/access-spine-interface-selector/aci | 0.2.0 |
| <a name="module_aci_access_spine_switch_policy_group"></a> [aci\_access\_spine\_switch\_policy\_group](#module\_aci\_access\_spine\_switch\_policy\_group) | netascode/access-spine-switch-policy-group/aci | 0.1.0 |
| <a name="module_aci_access_spine_switch_profile_auto"></a> [aci\_access\_spine\_switch\_profile\_auto](#module\_aci\_access\_spine\_switch\_profile\_auto) | netascode/access-spine-switch-profile/aci | 0.2.1 |
| <a name="module_aci_access_spine_switch_profile_manual"></a> [aci\_access\_spine\_switch\_profile\_manual](#module\_aci\_access\_spine\_switch\_profile\_manual) | netascode/access-spine-switch-profile/aci | 0.2.1 |
| <a name="module_aci_apic_connectivity_preference"></a> [aci\_apic\_connectivity\_preference](#module\_aci\_apic\_connectivity\_preference) | netascode/apic-connectivity-preference/aci | 0.1.0 |
| <a name="module_aci_application_profile"></a> [aci\_application\_profile](#module\_aci\_application\_profile) | netascode/application-profile/aci | 0.1.0 |
| <a name="module_aci_banner"></a> [aci\_banner](#module\_aci\_banner) | netascode/banner/aci | 0.1.1 |
| <a name="module_aci_bfd_interface_policy"></a> [aci\_bfd\_interface\_policy](#module\_aci\_bfd\_interface\_policy) | netascode/bfd-interface-policy/aci | 0.1.0 |
| <a name="module_aci_bgp_address_family_context_policy"></a> [aci\_bgp\_address\_family\_context\_policy](#module\_aci\_bgp\_address\_family\_context\_policy) | netascode/bgp-address-family-context-policy/aci | 0.1.0 |
| <a name="module_aci_bgp_best_path_policy"></a> [aci\_bgp\_best\_path\_policy](#module\_aci\_bgp\_best\_path\_policy) | netascode/bgp-best-path-policy/aci | 0.1.0 |
| <a name="module_aci_bgp_peer_prefix_policy"></a> [aci\_bgp\_peer\_prefix\_policy](#module\_aci\_bgp\_peer\_prefix\_policy) | netascode/bgp-peer-prefix-policy/aci | 0.1.0 |
| <a name="module_aci_bgp_policy"></a> [aci\_bgp\_policy](#module\_aci\_bgp\_policy) | netascode/bgp-policy/aci | 0.2.0 |
| <a name="module_aci_bgp_timer_policy"></a> [aci\_bgp\_timer\_policy](#module\_aci\_bgp\_timer\_policy) | netascode/bgp-timer-policy/aci | 0.1.0 |
| <a name="module_aci_bridge_domain"></a> [aci\_bridge\_domain](#module\_aci\_bridge\_domain) | netascode/bridge-domain/aci | 0.2.2 |
| <a name="module_aci_ca_certificate"></a> [aci\_ca\_certificate](#module\_aci\_ca\_certificate) | netascode/ca-certificate/aci | 0.1.0 |
| <a name="module_aci_cdp_policy"></a> [aci\_cdp\_policy](#module\_aci\_cdp\_policy) | netascode/cdp-policy/aci | 0.1.0 |
| <a name="module_aci_config_export"></a> [aci\_config\_export](#module\_aci\_config\_export) | netascode/config-export/aci | 0.1.1 |
| <a name="module_aci_config_passphrase"></a> [aci\_config\_passphrase](#module\_aci\_config\_passphrase) | netascode/config-passphrase/aci | 0.1.1 |
| <a name="module_aci_contract"></a> [aci\_contract](#module\_aci\_contract) | netascode/contract/aci | 0.2.2 |
| <a name="module_aci_coop_policy"></a> [aci\_coop\_policy](#module\_aci\_coop\_policy) | netascode/coop-policy/aci | 0.1.0 |
| <a name="module_aci_date_time_format"></a> [aci\_date\_time\_format](#module\_aci\_date\_time\_format) | netascode/date-time-format/aci | 0.1.0 |
| <a name="module_aci_date_time_policy"></a> [aci\_date\_time\_policy](#module\_aci\_date\_time\_policy) | netascode/date-time-policy/aci | 0.2.1 |
| <a name="module_aci_device_selection_policy"></a> [aci\_device\_selection\_policy](#module\_aci\_device\_selection\_policy) | netascode/device-selection-policy/aci | 0.1.1 |
| <a name="module_aci_dhcp_option_policy"></a> [aci\_dhcp\_option\_policy](#module\_aci\_dhcp\_option\_policy) | netascode/dhcp-option-policy/aci | 0.2.0 |
| <a name="module_aci_dhcp_relay_policy"></a> [aci\_dhcp\_relay\_policy](#module\_aci\_dhcp\_relay\_policy) | netascode/dhcp-relay-policy/aci | 0.2.0 |
| <a name="module_aci_dns_policy"></a> [aci\_dns\_policy](#module\_aci\_dns\_policy) | netascode/dns-policy/aci | 0.2.0 |
| <a name="module_aci_endpoint_group"></a> [aci\_endpoint\_group](#module\_aci\_endpoint\_group) | netascode/endpoint-group/aci | 0.2.8 |
| <a name="module_aci_endpoint_loop_protection"></a> [aci\_endpoint\_loop\_protection](#module\_aci\_endpoint\_loop\_protection) | netascode/endpoint-loop-protection/aci | 0.1.0 |
| <a name="module_aci_endpoint_security_group"></a> [aci\_endpoint\_security\_group](#module\_aci\_endpoint\_security\_group) | netascode/endpoint-security-group/aci | 0.2.5 |
| <a name="module_aci_error_disabled_recovery"></a> [aci\_error\_disabled\_recovery](#module\_aci\_error\_disabled\_recovery) | netascode/error-disabled-recovery/aci | 0.1.0 |
| <a name="module_aci_external_connectivity_policy"></a> [aci\_external\_connectivity\_policy](#module\_aci\_external\_connectivity\_policy) | netascode/external-connectivity-policy/aci | 0.2.1 |
| <a name="module_aci_external_endpoint_group"></a> [aci\_external\_endpoint\_group](#module\_aci\_external\_endpoint\_group) | netascode/external-endpoint-group/aci | 0.2.1 |
| <a name="module_aci_fabric_isis_bfd"></a> [aci\_fabric\_isis\_bfd](#module\_aci\_fabric\_isis\_bfd) | netascode/fabric-isis-bfd/aci | 0.1.0 |
| <a name="module_aci_fabric_isis_policy"></a> [aci\_fabric\_isis\_policy](#module\_aci\_fabric\_isis\_policy) | netascode/fabric-isis-policy/aci | 0.1.0 |
| <a name="module_aci_fabric_l2_mtu"></a> [aci\_fabric\_l2\_mtu](#module\_aci\_fabric\_l2\_mtu) | netascode/fabric-l2-mtu/aci | 0.1.0 |
| <a name="module_aci_fabric_leaf_interface_profile_auto"></a> [aci\_fabric\_leaf\_interface\_profile\_auto](#module\_aci\_fabric\_leaf\_interface\_profile\_auto) | netascode/fabric-leaf-interface-profile/aci | 0.1.0 |
| <a name="module_aci_fabric_leaf_interface_profile_manual"></a> [aci\_fabric\_leaf\_interface\_profile\_manual](#module\_aci\_fabric\_leaf\_interface\_profile\_manual) | netascode/fabric-leaf-interface-profile/aci | 0.1.0 |
| <a name="module_aci_fabric_leaf_switch_policy_group"></a> [aci\_fabric\_leaf\_switch\_policy\_group](#module\_aci\_fabric\_leaf\_switch\_policy\_group) | netascode/fabric-leaf-switch-policy-group/aci | 0.1.0 |
| <a name="module_aci_fabric_leaf_switch_profile_auto"></a> [aci\_fabric\_leaf\_switch\_profile\_auto](#module\_aci\_fabric\_leaf\_switch\_profile\_auto) | netascode/fabric-leaf-switch-profile/aci | 0.2.0 |
| <a name="module_aci_fabric_leaf_switch_profile_manual"></a> [aci\_fabric\_leaf\_switch\_profile\_manual](#module\_aci\_fabric\_leaf\_switch\_profile\_manual) | netascode/fabric-leaf-switch-profile/aci | 0.2.0 |
| <a name="module_aci_fabric_pod_policy_group"></a> [aci\_fabric\_pod\_policy\_group](#module\_aci\_fabric\_pod\_policy\_group) | netascode/fabric-pod-policy-group/aci | 0.1.1 |
| <a name="module_aci_fabric_pod_profile_auto"></a> [aci\_fabric\_pod\_profile\_auto](#module\_aci\_fabric\_pod\_profile\_auto) | netascode/fabric-pod-profile/aci | 0.2.1 |
| <a name="module_aci_fabric_pod_profile_manual"></a> [aci\_fabric\_pod\_profile\_manual](#module\_aci\_fabric\_pod\_profile\_manual) | netascode/fabric-pod-profile/aci | 0.2.1 |
| <a name="module_aci_fabric_scheduler"></a> [aci\_fabric\_scheduler](#module\_aci\_fabric\_scheduler) | netascode/fabric-scheduler/aci | 0.2.0 |
| <a name="module_aci_fabric_span_destination_group"></a> [aci\_fabric\_span\_destination\_group](#module\_aci\_fabric\_span\_destination\_group) | netascode/fabric-span-destination-group/aci | 0.1.1 |
| <a name="module_aci_fabric_span_source_group"></a> [aci\_fabric\_span\_source\_group](#module\_aci\_fabric\_span\_source\_group) | netascode/fabric-span-source-group/aci | 0.1.1 |
| <a name="module_aci_fabric_spine_interface_profile_auto"></a> [aci\_fabric\_spine\_interface\_profile\_auto](#module\_aci\_fabric\_spine\_interface\_profile\_auto) | netascode/fabric-spine-interface-profile/aci | 0.1.0 |
| <a name="module_aci_fabric_spine_interface_profile_manual"></a> [aci\_fabric\_spine\_interface\_profile\_manual](#module\_aci\_fabric\_spine\_interface\_profile\_manual) | netascode/fabric-spine-interface-profile/aci | 0.1.0 |
| <a name="module_aci_fabric_spine_switch_policy_group"></a> [aci\_fabric\_spine\_switch\_policy\_group](#module\_aci\_fabric\_spine\_switch\_policy\_group) | netascode/fabric-spine-switch-policy-group/aci | 0.1.0 |
| <a name="module_aci_fabric_spine_switch_profile_auto"></a> [aci\_fabric\_spine\_switch\_profile\_auto](#module\_aci\_fabric\_spine\_switch\_profile\_auto) | netascode/fabric-spine-switch-profile/aci | 0.2.0 |
| <a name="module_aci_fabric_spine_switch_profile_manual"></a> [aci\_fabric\_spine\_switch\_profile\_manual](#module\_aci\_fabric\_spine\_switch\_profile\_manual) | netascode/fabric-spine-switch-profile/aci | 0.2.0 |
| <a name="module_aci_fabric_wide_settings"></a> [aci\_fabric\_wide\_settings](#module\_aci\_fabric\_wide\_settings) | netascode/fabric-wide-settings/aci | 0.1.1 |
| <a name="module_aci_filter"></a> [aci\_filter](#module\_aci\_filter) | netascode/filter/aci | 0.2.1 |
| <a name="module_aci_firmware_group"></a> [aci\_firmware\_group](#module\_aci\_firmware\_group) | netascode/firmware-group/aci | 0.1.0 |
| <a name="module_aci_forwarding_scale_policy"></a> [aci\_forwarding\_scale\_policy](#module\_aci\_forwarding\_scale\_policy) | netascode/forwarding-scale-policy/aci | 0.1.0 |
| <a name="module_aci_geolocation"></a> [aci\_geolocation](#module\_aci\_geolocation) | netascode/geolocation/aci | 0.2.0 |
| <a name="module_aci_health_score_evaluation_policy"></a> [aci\_health\_score\_evaluation\_policy](#module\_aci\_health\_score\_evaluation\_policy) | netascode/health-score-evaluation-policy/aci | 0.1.0 |
| <a name="module_aci_igmp_interface_policy"></a> [aci\_igmp\_interface\_policy](#module\_aci\_igmp\_interface\_policy) | netascode/igmp-interface-policy/aci | 0.1.1 |
| <a name="module_aci_igmp_snooping_policy"></a> [aci\_igmp\_snooping\_policy](#module\_aci\_igmp\_snooping\_policy) | netascode/igmp-snooping-policy/aci | 0.1.0 |
| <a name="module_aci_imported_contract"></a> [aci\_imported\_contract](#module\_aci\_imported\_contract) | netascode/imported-contract/aci | 0.1.0 |
| <a name="module_aci_inband_endpoint_group"></a> [aci\_inband\_endpoint\_group](#module\_aci\_inband\_endpoint\_group) | netascode/inband-endpoint-group/aci | 0.1.2 |
| <a name="module_aci_inband_node_address"></a> [aci\_inband\_node\_address](#module\_aci\_inband\_node\_address) | netascode/inband-node-address/aci | 0.2.0 |
| <a name="module_aci_infra_dscp_translation_policy"></a> [aci\_infra\_dscp\_translation\_policy](#module\_aci\_infra\_dscp\_translation\_policy) | netascode/infra-dscp-translation-policy/aci | 0.1.0 |
| <a name="module_aci_interface_type"></a> [aci\_interface\_type](#module\_aci\_interface\_type) | netascode/interface-type/aci | 0.1.0 |
| <a name="module_aci_ip_aging"></a> [aci\_ip\_aging](#module\_aci\_ip\_aging) | netascode/ip-aging/aci | 0.1.0 |
| <a name="module_aci_ip_sla_policy"></a> [aci\_ip\_sla\_policy](#module\_aci\_ip\_sla\_policy) | netascode/ip-sla-policy/aci | 0.1.0 |
| <a name="module_aci_keyring"></a> [aci\_keyring](#module\_aci\_keyring) | netascode/keyring/aci | 0.1.1 |
| <a name="module_aci_l2_mtu_policy"></a> [aci\_l2\_mtu\_policy](#module\_aci\_l2\_mtu\_policy) | netascode/l2-mtu-policy/aci | 0.1.0 |
| <a name="module_aci_l2_policy"></a> [aci\_l2\_policy](#module\_aci\_l2\_policy) | netascode/l2-policy/aci | 0.1.1 |
| <a name="module_aci_l3out"></a> [aci\_l3out](#module\_aci\_l3out) | netascode/l3out/aci | 0.2.2 |
| <a name="module_aci_l3out_interface_profile_auto"></a> [aci\_l3out\_interface\_profile\_auto](#module\_aci\_l3out\_interface\_profile\_auto) | netascode/l3out-interface-profile/aci | 0.2.9 |
| <a name="module_aci_l3out_interface_profile_manual"></a> [aci\_l3out\_interface\_profile\_manual](#module\_aci\_l3out\_interface\_profile\_manual) | netascode/l3out-interface-profile/aci | 0.2.9 |
| <a name="module_aci_l3out_node_profile_auto"></a> [aci\_l3out\_node\_profile\_auto](#module\_aci\_l3out\_node\_profile\_auto) | netascode/l3out-node-profile/aci | 0.2.6 |
| <a name="module_aci_l3out_node_profile_manual"></a> [aci\_l3out\_node\_profile\_manual](#module\_aci\_l3out\_node\_profile\_manual) | netascode/l3out-node-profile/aci | 0.2.6 |
| <a name="module_aci_l4l7_device"></a> [aci\_l4l7\_device](#module\_aci\_l4l7\_device) | netascode/l4l7-device/aci | 0.2.3 |
| <a name="module_aci_link_level_policy"></a> [aci\_link\_level\_policy](#module\_aci\_link\_level\_policy) | netascode/link-level-policy/aci | 0.1.0 |
| <a name="module_aci_lldp_policy"></a> [aci\_lldp\_policy](#module\_aci\_lldp\_policy) | netascode/lldp-policy/aci | 0.1.0 |
| <a name="module_aci_login_domain"></a> [aci\_login\_domain](#module\_aci\_login\_domain) | netascode/login-domain/aci | 0.2.0 |
| <a name="module_aci_maintenance_group"></a> [aci\_maintenance\_group](#module\_aci\_maintenance\_group) | netascode/maintenance-group/aci | 0.1.0 |
| <a name="module_aci_management_access_policy"></a> [aci\_management\_access\_policy](#module\_aci\_management\_access\_policy) | netascode/management-access-policy/aci | 0.1.0 |
| <a name="module_aci_match_rule"></a> [aci\_match\_rule](#module\_aci\_match\_rule) | netascode/match-rule/aci | 0.2.1 |
| <a name="module_aci_mcp"></a> [aci\_mcp](#module\_aci\_mcp) | netascode/mcp/aci | 0.1.1 |
| <a name="module_aci_mcp_policy"></a> [aci\_mcp\_policy](#module\_aci\_mcp\_policy) | netascode/mcp-policy/aci | 0.1.0 |
| <a name="module_aci_monitoring_policy"></a> [aci\_monitoring\_policy](#module\_aci\_monitoring\_policy) | netascode/monitoring-policy/aci | 0.2.1 |
| <a name="module_aci_mst_policy"></a> [aci\_mst\_policy](#module\_aci\_mst\_policy) | netascode/mst-policy/aci | 0.2.0 |
| <a name="module_aci_multicast_route_map"></a> [aci\_multicast\_route\_map](#module\_aci\_multicast\_route\_map) | netascode/multicast-route-map/aci | 0.1.2 |
| <a name="module_aci_node_control_policy"></a> [aci\_node\_control\_policy](#module\_aci\_node\_control\_policy) | netascode/node-control-policy/aci | 0.1.0 |
| <a name="module_aci_node_registration"></a> [aci\_node\_registration](#module\_aci\_node\_registration) | netascode/node-registration/aci | 0.1.1 |
| <a name="module_aci_oob_contract"></a> [aci\_oob\_contract](#module\_aci\_oob\_contract) | netascode/oob-contract/aci | 0.2.0 |
| <a name="module_aci_oob_endpoint_group"></a> [aci\_oob\_endpoint\_group](#module\_aci\_oob\_endpoint\_group) | netascode/oob-endpoint-group/aci | 0.1.1 |
| <a name="module_aci_oob_external_management_instance"></a> [aci\_oob\_external\_management\_instance](#module\_aci\_oob\_external\_management\_instance) | netascode/oob-external-management-instance/aci | 0.1.0 |
| <a name="module_aci_oob_node_address"></a> [aci\_oob\_node\_address](#module\_aci\_oob\_node\_address) | netascode/oob-node-address/aci | 0.1.3 |
| <a name="module_aci_ospf_interface_policy"></a> [aci\_ospf\_interface\_policy](#module\_aci\_ospf\_interface\_policy) | netascode/ospf-interface-policy/aci | 0.1.0 |
| <a name="module_aci_physical_domain"></a> [aci\_physical\_domain](#module\_aci\_physical\_domain) | netascode/physical-domain/aci | 0.1.0 |
| <a name="module_aci_pim_policy"></a> [aci\_pim\_policy](#module\_aci\_pim\_policy) | netascode/pim-policy/aci | 0.1.1 |
| <a name="module_aci_pod_setup"></a> [aci\_pod\_setup](#module\_aci\_pod\_setup) | netascode/pod-setup/aci | 0.1.1 |
| <a name="module_aci_port_channel_member_policy"></a> [aci\_port\_channel\_member\_policy](#module\_aci\_port\_channel\_member\_policy) | netascode/port-channel-member-policy/aci | 0.1.0 |
| <a name="module_aci_port_channel_policy"></a> [aci\_port\_channel\_policy](#module\_aci\_port\_channel\_policy) | netascode/port-channel-policy/aci | 0.1.0 |
| <a name="module_aci_port_tracking"></a> [aci\_port\_tracking](#module\_aci\_port\_tracking) | netascode/port-tracking/aci | 0.1.0 |
| <a name="module_aci_psu_policy"></a> [aci\_psu\_policy](#module\_aci\_psu\_policy) | netascode/psu-policy/aci | 0.1.0 |
| <a name="module_aci_ptp"></a> [aci\_ptp](#module\_aci\_ptp) | netascode/ptp/aci | 0.1.1 |
| <a name="module_aci_qos"></a> [aci\_qos](#module\_aci\_qos) | netascode/qos/aci | 0.2.1 |
| <a name="module_aci_qos_policy"></a> [aci\_qos\_policy](#module\_aci\_qos\_policy) | netascode/qos-policy/aci | 0.1.3 |
| <a name="module_aci_redirect_backup_policy"></a> [aci\_redirect\_backup\_policy](#module\_aci\_redirect\_backup\_policy) | netascode/redirect-backup-policy/aci | 0.1.0 |
| <a name="module_aci_redirect_health_group"></a> [aci\_redirect\_health\_group](#module\_aci\_redirect\_health\_group) | netascode/redirect-health-group/aci | 0.1.0 |
| <a name="module_aci_redirect_policy"></a> [aci\_redirect\_policy](#module\_aci\_redirect\_policy) | netascode/redirect-policy/aci | 0.2.1 |
| <a name="module_aci_remote_location"></a> [aci\_remote\_location](#module\_aci\_remote\_location) | netascode/remote-location/aci | 0.1.1 |
| <a name="module_aci_rogue_endpoint_control"></a> [aci\_rogue\_endpoint\_control](#module\_aci\_rogue\_endpoint\_control) | netascode/rogue-endpoint-control/aci | 0.1.0 |
| <a name="module_aci_route_control_route_map"></a> [aci\_route\_control\_route\_map](#module\_aci\_route\_control\_route\_map) | netascode/route-control-route-map/aci | 0.1.1 |
| <a name="module_aci_routed_domain"></a> [aci\_routed\_domain](#module\_aci\_routed\_domain) | netascode/routed-domain/aci | 0.1.0 |
| <a name="module_aci_service_epg_policy"></a> [aci\_service\_epg\_policy](#module\_aci\_service\_epg\_policy) | netascode/service-epg-policy/aci | 0.1.0 |
| <a name="module_aci_service_graph_template"></a> [aci\_service\_graph\_template](#module\_aci\_service\_graph\_template) | netascode/service-graph-template/aci | 0.1.0 |
| <a name="module_aci_set_rule"></a> [aci\_set\_rule](#module\_aci\_set\_rule) | netascode/set-rule/aci | 0.2.2 |
| <a name="module_aci_smart_licensing"></a> [aci\_smart\_licensing](#module\_aci\_smart\_licensing) | netascode/smart-licensing/aci | 0.1.2 |
| <a name="module_aci_snmp_policy"></a> [aci\_snmp\_policy](#module\_aci\_snmp\_policy) | netascode/snmp-policy/aci | 0.2.2 |
| <a name="module_aci_snmp_trap_policy"></a> [aci\_snmp\_trap\_policy](#module\_aci\_snmp\_trap\_policy) | netascode/snmp-trap-policy/aci | 0.2.1 |
| <a name="module_aci_spanning_tree_policy"></a> [aci\_spanning\_tree\_policy](#module\_aci\_spanning\_tree\_policy) | netascode/spanning-tree-policy/aci | 0.1.0 |
| <a name="module_aci_storm_control_policy"></a> [aci\_storm\_control\_policy](#module\_aci\_storm\_control\_policy) | netascode/storm-control-policy/aci | 0.1.0 |
| <a name="module_aci_syslog_policy"></a> [aci\_syslog\_policy](#module\_aci\_syslog\_policy) | netascode/syslog-policy/aci | 0.2.1 |
| <a name="module_aci_system_global_gipo"></a> [aci\_system\_global\_gipo](#module\_aci\_system\_global\_gipo) | netascode/system-global-gipo/aci | 0.1.0 |
| <a name="module_aci_tacacs"></a> [aci\_tacacs](#module\_aci\_tacacs) | netascode/tacacs/aci | 0.1.1 |
| <a name="module_aci_tenant"></a> [aci\_tenant](#module\_aci\_tenant) | netascode/tenant/aci | 0.1.0 |
| <a name="module_aci_tenant_span_destination_group"></a> [aci\_tenant\_span\_destination\_group](#module\_aci\_tenant\_span\_destination\_group) | netascode/tenant-span-destination-group/aci | 0.1.1 |
| <a name="module_aci_tenant_span_source_group"></a> [aci\_tenant\_span\_source\_group](#module\_aci\_tenant\_span\_source\_group) | netascode/tenant-span-source-group/aci | 0.1.0 |
| <a name="module_aci_trust_control_policy"></a> [aci\_trust\_control\_policy](#module\_aci\_trust\_control\_policy) | netascode/trust-control-policy/aci | 0.1.0 |
| <a name="module_aci_user"></a> [aci\_user](#module\_aci\_user) | netascode/user/aci | 0.2.1 |
| <a name="module_aci_vlan_pool"></a> [aci\_vlan\_pool](#module\_aci\_vlan\_pool) | netascode/vlan-pool/aci | 0.2.2 |
| <a name="module_aci_vmware_vmm_domain"></a> [aci\_vmware\_vmm\_domain](#module\_aci\_vmware\_vmm\_domain) | netascode/vmware-vmm-domain/aci | 0.2.4 |
| <a name="module_aci_vpc_group"></a> [aci\_vpc\_group](#module\_aci\_vpc\_group) | netascode/vpc-group/aci | 0.2.0 |
| <a name="module_aci_vpc_policy"></a> [aci\_vpc\_policy](#module\_aci\_vpc\_policy) | netascode/vpc-policy/aci | 0.1.0 |
| <a name="module_aci_vrf"></a> [aci\_vrf](#module\_aci\_vrf) | netascode/vrf/aci | 0.2.3 |
| <a name="module_aci_vspan_destination_group"></a> [aci\_vspan\_destination\_group](#module\_aci\_vspan\_destination\_group) | netascode/vspan-destination-group/aci | 0.1.1 |
| <a name="module_aci_vspan_session"></a> [aci\_vspan\_session](#module\_aci\_vspan\_session) | netascode/vspan-session/aci | 0.1.0 |
<!-- END_TF_DOCS -->