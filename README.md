<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-nac-aci/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-nac-aci/actions/workflows/test.yml)

# Terraform ACI Network-as-Code Module

A Terraform module to configure ACI.

This module is part of the Cisco [*Network-as-Code*](https://netascode.cisco.com) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level ACI object model. More information can be found here: https://netascode.cisco.com.

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

The full data model documentation is available here: https://netascode.cisco.com/docs/data_models/apic/overview/ 

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
  source  = "netascode/nac-aci/aci"
  version = ">= 0.7.0"

  yaml_files = ["vlan_pool.yaml"]

  manage_access_policies = true
}
````

Configuring a Banner using native HCL:

#### `main.tf`

```hcl
module "banner" {
  source  = "netascode/nac-aci/aci"
  version = ">= 0.7.0"

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.17.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 1.0.2, < 2.0.0 |

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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [terraform_data.validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aci_aaa"></a> [aci\_aaa](#module\_aci\_aaa) | ./modules/terraform-aci-aaa | n/a |
| <a name="module_aci_aaep"></a> [aci\_aaep](#module\_aci\_aaep) | ./modules/terraform-aci-aaep | n/a |
| <a name="module_aci_access_fex_interface_profile_auto"></a> [aci\_access\_fex\_interface\_profile\_auto](#module\_aci\_access\_fex\_interface\_profile\_auto) | ./modules/terraform-aci-access-fex-interface-profile | n/a |
| <a name="module_aci_access_fex_interface_profile_manual"></a> [aci\_access\_fex\_interface\_profile\_manual](#module\_aci\_access\_fex\_interface\_profile\_manual) | ./modules/terraform-aci-access-fex-interface-profile | n/a |
| <a name="module_aci_access_fex_interface_selector_auto"></a> [aci\_access\_fex\_interface\_selector\_auto](#module\_aci\_access\_fex\_interface\_selector\_auto) | ./modules/terraform-aci-access-fex-interface-selector | n/a |
| <a name="module_aci_access_fex_interface_selector_manual"></a> [aci\_access\_fex\_interface\_selector\_manual](#module\_aci\_access\_fex\_interface\_selector\_manual) | ./modules/terraform-aci-access-fex-interface-selector | n/a |
| <a name="module_aci_access_leaf_interface_policy_group"></a> [aci\_access\_leaf\_interface\_policy\_group](#module\_aci\_access\_leaf\_interface\_policy\_group) | ./modules/terraform-aci-access-leaf-interface-policy-group | n/a |
| <a name="module_aci_access_leaf_interface_profile_auto"></a> [aci\_access\_leaf\_interface\_profile\_auto](#module\_aci\_access\_leaf\_interface\_profile\_auto) | ./modules/terraform-aci-access-leaf-interface-profile | n/a |
| <a name="module_aci_access_leaf_interface_profile_manual"></a> [aci\_access\_leaf\_interface\_profile\_manual](#module\_aci\_access\_leaf\_interface\_profile\_manual) | ./modules/terraform-aci-access-leaf-interface-profile | n/a |
| <a name="module_aci_access_leaf_interface_selector_auto"></a> [aci\_access\_leaf\_interface\_selector\_auto](#module\_aci\_access\_leaf\_interface\_selector\_auto) | ./modules/terraform-aci-access-leaf-interface-selector | n/a |
| <a name="module_aci_access_leaf_interface_selector_manual"></a> [aci\_access\_leaf\_interface\_selector\_manual](#module\_aci\_access\_leaf\_interface\_selector\_manual) | ./modules/terraform-aci-access-leaf-interface-selector | n/a |
| <a name="module_aci_access_leaf_interface_selector_sub_auto"></a> [aci\_access\_leaf\_interface\_selector\_sub\_auto](#module\_aci\_access\_leaf\_interface\_selector\_sub\_auto) | ./modules/terraform-aci-access-leaf-interface-selector | n/a |
| <a name="module_aci_access_leaf_switch_configuration"></a> [aci\_access\_leaf\_switch\_configuration](#module\_aci\_access\_leaf\_switch\_configuration) | ./modules/terraform-aci-switch-configuration | n/a |
| <a name="module_aci_access_leaf_switch_policy_group"></a> [aci\_access\_leaf\_switch\_policy\_group](#module\_aci\_access\_leaf\_switch\_policy\_group) | ./modules/terraform-aci-access-leaf-switch-policy-group | n/a |
| <a name="module_aci_access_leaf_switch_profile_auto"></a> [aci\_access\_leaf\_switch\_profile\_auto](#module\_aci\_access\_leaf\_switch\_profile\_auto) | ./modules/terraform-aci-access-leaf-switch-profile | n/a |
| <a name="module_aci_access_leaf_switch_profile_manual"></a> [aci\_access\_leaf\_switch\_profile\_manual](#module\_aci\_access\_leaf\_switch\_profile\_manual) | ./modules/terraform-aci-access-leaf-switch-profile | n/a |
| <a name="module_aci_access_monitoring_policy"></a> [aci\_access\_monitoring\_policy](#module\_aci\_access\_monitoring\_policy) | ./modules/terraform-aci-access-monitoring-policy | n/a |
| <a name="module_aci_access_span_destination_group"></a> [aci\_access\_span\_destination\_group](#module\_aci\_access\_span\_destination\_group) | ./modules/terraform-aci-access-span-destination-group | n/a |
| <a name="module_aci_access_span_filter_group"></a> [aci\_access\_span\_filter\_group](#module\_aci\_access\_span\_filter\_group) | ./modules/terraform-aci-access-span-filter-group | n/a |
| <a name="module_aci_access_span_source_group"></a> [aci\_access\_span\_source\_group](#module\_aci\_access\_span\_source\_group) | ./modules/terraform-aci-access-span-source-group | n/a |
| <a name="module_aci_access_spine_interface_policy_group"></a> [aci\_access\_spine\_interface\_policy\_group](#module\_aci\_access\_spine\_interface\_policy\_group) | ./modules/terraform-aci-access-spine-interface-policy-group | n/a |
| <a name="module_aci_access_spine_interface_profile_auto"></a> [aci\_access\_spine\_interface\_profile\_auto](#module\_aci\_access\_spine\_interface\_profile\_auto) | ./modules/terraform-aci-access-spine-interface-profile | n/a |
| <a name="module_aci_access_spine_interface_profile_manual"></a> [aci\_access\_spine\_interface\_profile\_manual](#module\_aci\_access\_spine\_interface\_profile\_manual) | ./modules/terraform-aci-access-spine-interface-profile | n/a |
| <a name="module_aci_access_spine_interface_selector_auto"></a> [aci\_access\_spine\_interface\_selector\_auto](#module\_aci\_access\_spine\_interface\_selector\_auto) | ./modules/terraform-aci-access-spine-interface-selector | n/a |
| <a name="module_aci_access_spine_interface_selector_manual"></a> [aci\_access\_spine\_interface\_selector\_manual](#module\_aci\_access\_spine\_interface\_selector\_manual) | ./modules/terraform-aci-access-spine-interface-selector | n/a |
| <a name="module_aci_access_spine_switch_configuration"></a> [aci\_access\_spine\_switch\_configuration](#module\_aci\_access\_spine\_switch\_configuration) | ./modules/terraform-aci-switch-configuration | n/a |
| <a name="module_aci_access_spine_switch_policy_group"></a> [aci\_access\_spine\_switch\_policy\_group](#module\_aci\_access\_spine\_switch\_policy\_group) | ./modules/terraform-aci-access-spine-switch-policy-group | n/a |
| <a name="module_aci_access_spine_switch_profile_auto"></a> [aci\_access\_spine\_switch\_profile\_auto](#module\_aci\_access\_spine\_switch\_profile\_auto) | ./modules/terraform-aci-access-spine-switch-profile | n/a |
| <a name="module_aci_access_spine_switch_profile_manual"></a> [aci\_access\_spine\_switch\_profile\_manual](#module\_aci\_access\_spine\_switch\_profile\_manual) | ./modules/terraform-aci-access-spine-switch-profile | n/a |
| <a name="module_aci_apic_connectivity_preference"></a> [aci\_apic\_connectivity\_preference](#module\_aci\_apic\_connectivity\_preference) | ./modules/terraform-aci-apic-connectivity-preference | n/a |
| <a name="module_aci_application_profile"></a> [aci\_application\_profile](#module\_aci\_application\_profile) | ./modules/terraform-aci-application-profile | n/a |
| <a name="module_aci_atomic_counter"></a> [aci\_atomic\_counter](#module\_aci\_atomic\_counter) | ./modules/terraform-aci-atomic-counter | n/a |
| <a name="module_aci_banner"></a> [aci\_banner](#module\_aci\_banner) | ./modules/terraform-aci-banner | n/a |
| <a name="module_aci_bfd_interface_policy"></a> [aci\_bfd\_interface\_policy](#module\_aci\_bfd\_interface\_policy) | ./modules/terraform-aci-bfd-interface-policy | n/a |
| <a name="module_aci_bfd_ipv4_policy"></a> [aci\_bfd\_ipv4\_policy](#module\_aci\_bfd\_ipv4\_policy) | ./modules/terraform-aci-bfd-policy | n/a |
| <a name="module_aci_bfd_ipv6_policy"></a> [aci\_bfd\_ipv6\_policy](#module\_aci\_bfd\_ipv6\_policy) | ./modules/terraform-aci-bfd-policy | n/a |
| <a name="module_aci_bfd_multihop_node_policy"></a> [aci\_bfd\_multihop\_node\_policy](#module\_aci\_bfd\_multihop\_node\_policy) | ./modules/terraform-aci-bfd-multihop-node-policy | n/a |
| <a name="module_aci_bgp_address_family_context_policy"></a> [aci\_bgp\_address\_family\_context\_policy](#module\_aci\_bgp\_address\_family\_context\_policy) | ./modules/terraform-aci-bgp-address-family-context-policy | n/a |
| <a name="module_aci_bgp_best_path_policy"></a> [aci\_bgp\_best\_path\_policy](#module\_aci\_bgp\_best\_path\_policy) | ./modules/terraform-aci-bgp-best-path-policy | n/a |
| <a name="module_aci_bgp_peer_prefix_policy"></a> [aci\_bgp\_peer\_prefix\_policy](#module\_aci\_bgp\_peer\_prefix\_policy) | ./modules/terraform-aci-bgp-peer-prefix-policy | n/a |
| <a name="module_aci_bgp_policy"></a> [aci\_bgp\_policy](#module\_aci\_bgp\_policy) | ./modules/terraform-aci-bgp-policy | n/a |
| <a name="module_aci_bgp_route_summarization_policy"></a> [aci\_bgp\_route\_summarization\_policy](#module\_aci\_bgp\_route\_summarization\_policy) | ./modules/terraform-aci-bgp-route-summarization-policy | n/a |
| <a name="module_aci_bgp_timer_policy"></a> [aci\_bgp\_timer\_policy](#module\_aci\_bgp\_timer\_policy) | ./modules/terraform-aci-bgp-timer-policy | n/a |
| <a name="module_aci_bridge_domain"></a> [aci\_bridge\_domain](#module\_aci\_bridge\_domain) | ./modules/terraform-aci-bridge-domain | n/a |
| <a name="module_aci_ca_certificate"></a> [aci\_ca\_certificate](#module\_aci\_ca\_certificate) | ./modules/terraform-aci-ca-certificate | n/a |
| <a name="module_aci_cdp_policy"></a> [aci\_cdp\_policy](#module\_aci\_cdp\_policy) | ./modules/terraform-aci-cdp-policy | n/a |
| <a name="module_aci_config_export"></a> [aci\_config\_export](#module\_aci\_config\_export) | ./modules/terraform-aci-config-export | n/a |
| <a name="module_aci_config_passphrase"></a> [aci\_config\_passphrase](#module\_aci\_config\_passphrase) | ./modules/terraform-aci-config-passphrase | n/a |
| <a name="module_aci_contract"></a> [aci\_contract](#module\_aci\_contract) | ./modules/terraform-aci-contract | n/a |
| <a name="module_aci_control_plane_mtu"></a> [aci\_control\_plane\_mtu](#module\_aci\_control\_plane\_mtu) | ./modules/terraform-aci-control-plane-mtu | n/a |
| <a name="module_aci_coop_policy"></a> [aci\_coop\_policy](#module\_aci\_coop\_policy) | ./modules/terraform-aci-coop-policy | n/a |
| <a name="module_aci_data_plane_policing_policy"></a> [aci\_data\_plane\_policing\_policy](#module\_aci\_data\_plane\_policing\_policy) | ./modules/terraform-aci-data-plane-policing-policy | n/a |
| <a name="module_aci_date_time_format"></a> [aci\_date\_time\_format](#module\_aci\_date\_time\_format) | ./modules/terraform-aci-date-time-format | n/a |
| <a name="module_aci_date_time_policy"></a> [aci\_date\_time\_policy](#module\_aci\_date\_time\_policy) | ./modules/terraform-aci-date-time-policy | n/a |
| <a name="module_aci_device_selection_policy"></a> [aci\_device\_selection\_policy](#module\_aci\_device\_selection\_policy) | ./modules/terraform-aci-device-selection-policy | n/a |
| <a name="module_aci_dhcp_option_policy"></a> [aci\_dhcp\_option\_policy](#module\_aci\_dhcp\_option\_policy) | ./modules/terraform-aci-dhcp-option-policy | n/a |
| <a name="module_aci_dhcp_relay_policy"></a> [aci\_dhcp\_relay\_policy](#module\_aci\_dhcp\_relay\_policy) | ./modules/terraform-aci-dhcp-relay-policy | n/a |
| <a name="module_aci_dns_policy"></a> [aci\_dns\_policy](#module\_aci\_dns\_policy) | ./modules/terraform-aci-dns-policy | n/a |
| <a name="module_aci_eigrp_interface_policy"></a> [aci\_eigrp\_interface\_policy](#module\_aci\_eigrp\_interface\_policy) | ./modules/terraform-aci-eigrp-interface-policy | n/a |
| <a name="module_aci_endpoint_group"></a> [aci\_endpoint\_group](#module\_aci\_endpoint\_group) | ./modules/terraform-aci-endpoint-group | n/a |
| <a name="module_aci_endpoint_ip_tag_policy"></a> [aci\_endpoint\_ip\_tag\_policy](#module\_aci\_endpoint\_ip\_tag\_policy) | ./modules/terraform-aci-endpoint-ip-tag-policy | n/a |
| <a name="module_aci_endpoint_loop_protection"></a> [aci\_endpoint\_loop\_protection](#module\_aci\_endpoint\_loop\_protection) | ./modules/terraform-aci-endpoint-loop-protection | n/a |
| <a name="module_aci_endpoint_mac_tag_policy"></a> [aci\_endpoint\_mac\_tag\_policy](#module\_aci\_endpoint\_mac\_tag\_policy) | ./modules/terraform-aci-endpoint-mac-tag-policy | n/a |
| <a name="module_aci_endpoint_retention_policy"></a> [aci\_endpoint\_retention\_policy](#module\_aci\_endpoint\_retention\_policy) | ./modules/terraform-aci-endpoint-retention-policy | n/a |
| <a name="module_aci_endpoint_security_group"></a> [aci\_endpoint\_security\_group](#module\_aci\_endpoint\_security\_group) | ./modules/terraform-aci-endpoint-security-group | n/a |
| <a name="module_aci_error_disabled_recovery"></a> [aci\_error\_disabled\_recovery](#module\_aci\_error\_disabled\_recovery) | ./modules/terraform-aci-error-disabled-recovery | n/a |
| <a name="module_aci_external_connectivity_policy"></a> [aci\_external\_connectivity\_policy](#module\_aci\_external\_connectivity\_policy) | ./modules/terraform-aci-external-connectivity-policy | n/a |
| <a name="module_aci_external_endpoint_group"></a> [aci\_external\_endpoint\_group](#module\_aci\_external\_endpoint\_group) | ./modules/terraform-aci-external-endpoint-group | n/a |
| <a name="module_aci_fabric_isis_bfd"></a> [aci\_fabric\_isis\_bfd](#module\_aci\_fabric\_isis\_bfd) | ./modules/terraform-aci-fabric-isis-bfd | n/a |
| <a name="module_aci_fabric_isis_policy"></a> [aci\_fabric\_isis\_policy](#module\_aci\_fabric\_isis\_policy) | ./modules/terraform-aci-fabric-isis-policy | n/a |
| <a name="module_aci_fabric_l2_mtu"></a> [aci\_fabric\_l2\_mtu](#module\_aci\_fabric\_l2\_mtu) | ./modules/terraform-aci-fabric-l2-mtu | n/a |
| <a name="module_aci_fabric_leaf_interface_policy_group"></a> [aci\_fabric\_leaf\_interface\_policy\_group](#module\_aci\_fabric\_leaf\_interface\_policy\_group) | ./modules/terraform-aci-fabric-leaf-interface-policy-group | n/a |
| <a name="module_aci_fabric_leaf_interface_profile_auto"></a> [aci\_fabric\_leaf\_interface\_profile\_auto](#module\_aci\_fabric\_leaf\_interface\_profile\_auto) | ./modules/terraform-aci-fabric-leaf-interface-profile | n/a |
| <a name="module_aci_fabric_leaf_interface_profile_manual"></a> [aci\_fabric\_leaf\_interface\_profile\_manual](#module\_aci\_fabric\_leaf\_interface\_profile\_manual) | ./modules/terraform-aci-fabric-leaf-interface-profile | n/a |
| <a name="module_aci_fabric_leaf_interface_selector_auto"></a> [aci\_fabric\_leaf\_interface\_selector\_auto](#module\_aci\_fabric\_leaf\_interface\_selector\_auto) | ./modules/terraform-aci-fabric-leaf-interface-selector | n/a |
| <a name="module_aci_fabric_leaf_interface_selector_manual"></a> [aci\_fabric\_leaf\_interface\_selector\_manual](#module\_aci\_fabric\_leaf\_interface\_selector\_manual) | ./modules/terraform-aci-fabric-leaf-interface-selector | n/a |
| <a name="module_aci_fabric_leaf_interface_selector_sub_auto"></a> [aci\_fabric\_leaf\_interface\_selector\_sub\_auto](#module\_aci\_fabric\_leaf\_interface\_selector\_sub\_auto) | ./modules/terraform-aci-fabric-leaf-interface-selector | n/a |
| <a name="module_aci_fabric_leaf_switch_configuration"></a> [aci\_fabric\_leaf\_switch\_configuration](#module\_aci\_fabric\_leaf\_switch\_configuration) | ./modules/terraform-aci-switch-configuration | n/a |
| <a name="module_aci_fabric_leaf_switch_policy_group"></a> [aci\_fabric\_leaf\_switch\_policy\_group](#module\_aci\_fabric\_leaf\_switch\_policy\_group) | ./modules/terraform-aci-fabric-leaf-switch-policy-group | n/a |
| <a name="module_aci_fabric_leaf_switch_profile_auto"></a> [aci\_fabric\_leaf\_switch\_profile\_auto](#module\_aci\_fabric\_leaf\_switch\_profile\_auto) | ./modules/terraform-aci-fabric-leaf-switch-profile | n/a |
| <a name="module_aci_fabric_leaf_switch_profile_manual"></a> [aci\_fabric\_leaf\_switch\_profile\_manual](#module\_aci\_fabric\_leaf\_switch\_profile\_manual) | ./modules/terraform-aci-fabric-leaf-switch-profile | n/a |
| <a name="module_aci_fabric_link_level_policy"></a> [aci\_fabric\_link\_level\_policy](#module\_aci\_fabric\_link\_level\_policy) | ./modules/terraform-aci-fabric-link-level-policy | n/a |
| <a name="module_aci_fabric_macsec_interfaces_policy"></a> [aci\_fabric\_macsec\_interfaces\_policy](#module\_aci\_fabric\_macsec\_interfaces\_policy) | ./modules/terraform-aci-macsec-interfaces-policy | n/a |
| <a name="module_aci_fabric_macsec_keychain_policies"></a> [aci\_fabric\_macsec\_keychain\_policies](#module\_aci\_fabric\_macsec\_keychain\_policies) | ./modules/terraform-aci-macsec-keychain-policies | n/a |
| <a name="module_aci_fabric_macsec_parameters_policy"></a> [aci\_fabric\_macsec\_parameters\_policy](#module\_aci\_fabric\_macsec\_parameters\_policy) | ./modules/terraform-aci-macsec-parameters-policy | n/a |
| <a name="module_aci_fabric_pod_policy_group"></a> [aci\_fabric\_pod\_policy\_group](#module\_aci\_fabric\_pod\_policy\_group) | ./modules/terraform-aci-fabric-pod-policy-group | n/a |
| <a name="module_aci_fabric_pod_profile_auto"></a> [aci\_fabric\_pod\_profile\_auto](#module\_aci\_fabric\_pod\_profile\_auto) | ./modules/terraform-aci-fabric-pod-profile | n/a |
| <a name="module_aci_fabric_pod_profile_manual"></a> [aci\_fabric\_pod\_profile\_manual](#module\_aci\_fabric\_pod\_profile\_manual) | ./modules/terraform-aci-fabric-pod-profile | n/a |
| <a name="module_aci_fabric_scheduler"></a> [aci\_fabric\_scheduler](#module\_aci\_fabric\_scheduler) | ./modules/terraform-aci-fabric-scheduler | n/a |
| <a name="module_aci_fabric_span_destination_group"></a> [aci\_fabric\_span\_destination\_group](#module\_aci\_fabric\_span\_destination\_group) | ./modules/terraform-aci-fabric-span-destination-group | n/a |
| <a name="module_aci_fabric_span_source_group"></a> [aci\_fabric\_span\_source\_group](#module\_aci\_fabric\_span\_source\_group) | ./modules/terraform-aci-fabric-span-source-group | n/a |
| <a name="module_aci_fabric_spine_interface_profile_auto"></a> [aci\_fabric\_spine\_interface\_profile\_auto](#module\_aci\_fabric\_spine\_interface\_profile\_auto) | ./modules/terraform-aci-fabric-spine-interface-profile | n/a |
| <a name="module_aci_fabric_spine_interface_profile_manual"></a> [aci\_fabric\_spine\_interface\_profile\_manual](#module\_aci\_fabric\_spine\_interface\_profile\_manual) | ./modules/terraform-aci-fabric-spine-interface-profile | n/a |
| <a name="module_aci_fabric_spine_interface_selector_auto"></a> [aci\_fabric\_spine\_interface\_selector\_auto](#module\_aci\_fabric\_spine\_interface\_selector\_auto) | ./modules/terraform-aci-fabric-spine-interface-selector | n/a |
| <a name="module_aci_fabric_spine_interface_selector_manual"></a> [aci\_fabric\_spine\_interface\_selector\_manual](#module\_aci\_fabric\_spine\_interface\_selector\_manual) | ./modules/terraform-aci-fabric-spine-interface-selector | n/a |
| <a name="module_aci_fabric_spine_interface_selector_sub_auto"></a> [aci\_fabric\_spine\_interface\_selector\_sub\_auto](#module\_aci\_fabric\_spine\_interface\_selector\_sub\_auto) | ./modules/terraform-aci-fabric-spine-interface-selector | n/a |
| <a name="module_aci_fabric_spine_switch_configuration"></a> [aci\_fabric\_spine\_switch\_configuration](#module\_aci\_fabric\_spine\_switch\_configuration) | ./modules/terraform-aci-switch-configuration | n/a |
| <a name="module_aci_fabric_spine_switch_policy_group"></a> [aci\_fabric\_spine\_switch\_policy\_group](#module\_aci\_fabric\_spine\_switch\_policy\_group) | ./modules/terraform-aci-fabric-spine-switch-policy-group | n/a |
| <a name="module_aci_fabric_spine_switch_profile_auto"></a> [aci\_fabric\_spine\_switch\_profile\_auto](#module\_aci\_fabric\_spine\_switch\_profile\_auto) | ./modules/terraform-aci-fabric-spine-switch-profile | n/a |
| <a name="module_aci_fabric_spine_switch_profile_manual"></a> [aci\_fabric\_spine\_switch\_profile\_manual](#module\_aci\_fabric\_spine\_switch\_profile\_manual) | ./modules/terraform-aci-fabric-spine-switch-profile | n/a |
| <a name="module_aci_fabric_wide_settings"></a> [aci\_fabric\_wide\_settings](#module\_aci\_fabric\_wide\_settings) | ./modules/terraform-aci-fabric-wide-settings | n/a |
| <a name="module_aci_fex_interface_shutdown"></a> [aci\_fex\_interface\_shutdown](#module\_aci\_fex\_interface\_shutdown) | ./modules/terraform-aci-interface-shutdown | n/a |
| <a name="module_aci_filter"></a> [aci\_filter](#module\_aci\_filter) | ./modules/terraform-aci-filter | n/a |
| <a name="module_aci_firmware_group"></a> [aci\_firmware\_group](#module\_aci\_firmware\_group) | ./modules/terraform-aci-firmware-group | n/a |
| <a name="module_aci_forwarding_scale_policy"></a> [aci\_forwarding\_scale\_policy](#module\_aci\_forwarding\_scale\_policy) | ./modules/terraform-aci-forwarding-scale-policy | n/a |
| <a name="module_aci_geolocation"></a> [aci\_geolocation](#module\_aci\_geolocation) | ./modules/terraform-aci-geolocation | n/a |
| <a name="module_aci_health_score_evaluation_policy"></a> [aci\_health\_score\_evaluation\_policy](#module\_aci\_health\_score\_evaluation\_policy) | ./modules/terraform-aci-health-score-evaluation-policy | n/a |
| <a name="module_aci_hsrp_group_policy"></a> [aci\_hsrp\_group\_policy](#module\_aci\_hsrp\_group\_policy) | ./modules/terraform-aci-hsrp-group-policy | n/a |
| <a name="module_aci_hsrp_interface_policy"></a> [aci\_hsrp\_interface\_policy](#module\_aci\_hsrp\_interface\_policy) | ./modules/terraform-aci-hsrp-interface-policy | n/a |
| <a name="module_aci_igmp_interface_policy"></a> [aci\_igmp\_interface\_policy](#module\_aci\_igmp\_interface\_policy) | ./modules/terraform-aci-igmp-interface-policy | n/a |
| <a name="module_aci_igmp_snooping_policy"></a> [aci\_igmp\_snooping\_policy](#module\_aci\_igmp\_snooping\_policy) | ./modules/terraform-aci-igmp-snooping-policy | n/a |
| <a name="module_aci_imported_contract"></a> [aci\_imported\_contract](#module\_aci\_imported\_contract) | ./modules/terraform-aci-imported-contract | n/a |
| <a name="module_aci_imported_l4l7_device"></a> [aci\_imported\_l4l7\_device](#module\_aci\_imported\_l4l7\_device) | ./modules/terraform-aci-imported-l4l7-device | n/a |
| <a name="module_aci_inband_endpoint_group"></a> [aci\_inband\_endpoint\_group](#module\_aci\_inband\_endpoint\_group) | ./modules/terraform-aci-inband-endpoint-group | n/a |
| <a name="module_aci_inband_node_address"></a> [aci\_inband\_node\_address](#module\_aci\_inband\_node\_address) | ./modules/terraform-aci-inband-node-address | n/a |
| <a name="module_aci_infra_dhcp_relay_policy"></a> [aci\_infra\_dhcp\_relay\_policy](#module\_aci\_infra\_dhcp\_relay\_policy) | ./modules/terraform-aci-infra-dhcp-relay-policy | n/a |
| <a name="module_aci_infra_dscp_translation_policy"></a> [aci\_infra\_dscp\_translation\_policy](#module\_aci\_infra\_dscp\_translation\_policy) | ./modules/terraform-aci-infra-dscp-translation-policy | n/a |
| <a name="module_aci_interface_configuration_fex"></a> [aci\_interface\_configuration\_fex](#module\_aci\_interface\_configuration\_fex) | ./modules/terraform-aci-interface-configuration | n/a |
| <a name="module_aci_interface_shutdown"></a> [aci\_interface\_shutdown](#module\_aci\_interface\_shutdown) | ./modules/terraform-aci-interface-shutdown | n/a |
| <a name="module_aci_interface_type"></a> [aci\_interface\_type](#module\_aci\_interface\_type) | ./modules/terraform-aci-interface-type | n/a |
| <a name="module_aci_ip_aging"></a> [aci\_ip\_aging](#module\_aci\_ip\_aging) | ./modules/terraform-aci-ip-aging | n/a |
| <a name="module_aci_ip_sla_policy"></a> [aci\_ip\_sla\_policy](#module\_aci\_ip\_sla\_policy) | ./modules/terraform-aci-ip-sla-policy | n/a |
| <a name="module_aci_keyring"></a> [aci\_keyring](#module\_aci\_keyring) | ./modules/terraform-aci-keyring | n/a |
| <a name="module_aci_l2_mtu_policy"></a> [aci\_l2\_mtu\_policy](#module\_aci\_l2\_mtu\_policy) | ./modules/terraform-aci-l2-mtu-policy | n/a |
| <a name="module_aci_l2_policy"></a> [aci\_l2\_policy](#module\_aci\_l2\_policy) | ./modules/terraform-aci-l2-policy | n/a |
| <a name="module_aci_l3out"></a> [aci\_l3out](#module\_aci\_l3out) | ./modules/terraform-aci-l3out | n/a |
| <a name="module_aci_l3out_interface_profile_auto"></a> [aci\_l3out\_interface\_profile\_auto](#module\_aci\_l3out\_interface\_profile\_auto) | ./modules/terraform-aci-l3out-interface-profile | n/a |
| <a name="module_aci_l3out_interface_profile_manual"></a> [aci\_l3out\_interface\_profile\_manual](#module\_aci\_l3out\_interface\_profile\_manual) | ./modules/terraform-aci-l3out-interface-profile | n/a |
| <a name="module_aci_l3out_node_profile_auto"></a> [aci\_l3out\_node\_profile\_auto](#module\_aci\_l3out\_node\_profile\_auto) | ./modules/terraform-aci-l3out-node-profile | n/a |
| <a name="module_aci_l3out_node_profile_manual"></a> [aci\_l3out\_node\_profile\_manual](#module\_aci\_l3out\_node\_profile\_manual) | ./modules/terraform-aci-l3out-node-profile | n/a |
| <a name="module_aci_l4l7_device"></a> [aci\_l4l7\_device](#module\_aci\_l4l7\_device) | ./modules/terraform-aci-l4l7-device | n/a |
| <a name="module_aci_ldap"></a> [aci\_ldap](#module\_aci\_ldap) | ./modules/terraform-aci-ldap | n/a |
| <a name="module_aci_leaf_fabric_interface_configuration"></a> [aci\_leaf\_fabric\_interface\_configuration](#module\_aci\_leaf\_fabric\_interface\_configuration) | ./modules/terraform-aci-fabric-interface-configuration | n/a |
| <a name="module_aci_leaf_fabric_interface_configuration_sub"></a> [aci\_leaf\_fabric\_interface\_configuration\_sub](#module\_aci\_leaf\_fabric\_interface\_configuration\_sub) | ./modules/terraform-aci-fabric-interface-configuration | n/a |
| <a name="module_aci_leaf_interface_configuration"></a> [aci\_leaf\_interface\_configuration](#module\_aci\_leaf\_interface\_configuration) | ./modules/terraform-aci-interface-configuration | n/a |
| <a name="module_aci_leaf_interface_configuration_sub"></a> [aci\_leaf\_interface\_configuration\_sub](#module\_aci\_leaf\_interface\_configuration\_sub) | ./modules/terraform-aci-interface-configuration | n/a |
| <a name="module_aci_link_level_policy"></a> [aci\_link\_level\_policy](#module\_aci\_link\_level\_policy) | ./modules/terraform-aci-link-level-policy | n/a |
| <a name="module_aci_lldp_policy"></a> [aci\_lldp\_policy](#module\_aci\_lldp\_policy) | ./modules/terraform-aci-lldp-policy | n/a |
| <a name="module_aci_login_domain"></a> [aci\_login\_domain](#module\_aci\_login\_domain) | ./modules/terraform-aci-login-domain | n/a |
| <a name="module_aci_macsec_interfaces_policy"></a> [aci\_macsec\_interfaces\_policy](#module\_aci\_macsec\_interfaces\_policy) | ./modules/terraform-aci-macsec-interfaces-policy | n/a |
| <a name="module_aci_macsec_keychain_policies"></a> [aci\_macsec\_keychain\_policies](#module\_aci\_macsec\_keychain\_policies) | ./modules/terraform-aci-macsec-keychain-policies | n/a |
| <a name="module_aci_macsec_parameters_policy"></a> [aci\_macsec\_parameters\_policy](#module\_aci\_macsec\_parameters\_policy) | ./modules/terraform-aci-macsec-parameters-policy | n/a |
| <a name="module_aci_maintenance_group"></a> [aci\_maintenance\_group](#module\_aci\_maintenance\_group) | ./modules/terraform-aci-maintenance-group | n/a |
| <a name="module_aci_management_access_policy"></a> [aci\_management\_access\_policy](#module\_aci\_management\_access\_policy) | ./modules/terraform-aci-management-access-policy | n/a |
| <a name="module_aci_match_rule"></a> [aci\_match\_rule](#module\_aci\_match\_rule) | ./modules/terraform-aci-match-rule | n/a |
| <a name="module_aci_mcp"></a> [aci\_mcp](#module\_aci\_mcp) | ./modules/terraform-aci-mcp | n/a |
| <a name="module_aci_mcp_policy"></a> [aci\_mcp\_policy](#module\_aci\_mcp\_policy) | ./modules/terraform-aci-mcp-policy | n/a |
| <a name="module_aci_monitoring_policy"></a> [aci\_monitoring\_policy](#module\_aci\_monitoring\_policy) | ./modules/terraform-aci-monitoring-policy | n/a |
| <a name="module_aci_mpls_custom_qos_policy"></a> [aci\_mpls\_custom\_qos\_policy](#module\_aci\_mpls\_custom\_qos\_policy) | ./modules/terraform-aci-mpls-custom-qos-policy | n/a |
| <a name="module_aci_mst_policy"></a> [aci\_mst\_policy](#module\_aci\_mst\_policy) | ./modules/terraform-aci-mst-policy | n/a |
| <a name="module_aci_multicast_route_map"></a> [aci\_multicast\_route\_map](#module\_aci\_multicast\_route\_map) | ./modules/terraform-aci-multicast-route-map | n/a |
| <a name="module_aci_nd_interface_policy"></a> [aci\_nd\_interface\_policy](#module\_aci\_nd\_interface\_policy) | ./modules/terraform-aci-nd-interface-policy | n/a |
| <a name="module_aci_nd_ra_prefix_policy"></a> [aci\_nd\_ra\_prefix\_policy](#module\_aci\_nd\_ra\_prefix\_policy) | ./modules/terraform-aci-nd-ra-prefix-policy | n/a |
| <a name="module_aci_netflow_exporter"></a> [aci\_netflow\_exporter](#module\_aci\_netflow\_exporter) | ./modules/terraform-aci-netflow-exporter | n/a |
| <a name="module_aci_netflow_monitor"></a> [aci\_netflow\_monitor](#module\_aci\_netflow\_monitor) | ./modules/terraform-aci-netflow-monitor | n/a |
| <a name="module_aci_netflow_record"></a> [aci\_netflow\_record](#module\_aci\_netflow\_record) | ./modules/terraform-aci-netflow-record | n/a |
| <a name="module_aci_netflow_vmm_exporter"></a> [aci\_netflow\_vmm\_exporter](#module\_aci\_netflow\_vmm\_exporter) | ./modules/terraform-aci-netflow-vmm-exporter | n/a |
| <a name="module_aci_node_control_policy"></a> [aci\_node\_control\_policy](#module\_aci\_node\_control\_policy) | ./modules/terraform-aci-node-control-policy | n/a |
| <a name="module_aci_node_registration"></a> [aci\_node\_registration](#module\_aci\_node\_registration) | ./modules/terraform-aci-node-registration | n/a |
| <a name="module_aci_nutanix_vmm_domain"></a> [aci\_nutanix\_vmm\_domain](#module\_aci\_nutanix\_vmm\_domain) | ./modules/terraform-aci-nutanix-vmm-domain | n/a |
| <a name="module_aci_oob_contract"></a> [aci\_oob\_contract](#module\_aci\_oob\_contract) | ./modules/terraform-aci-oob-contract | n/a |
| <a name="module_aci_oob_endpoint_group"></a> [aci\_oob\_endpoint\_group](#module\_aci\_oob\_endpoint\_group) | ./modules/terraform-aci-oob-endpoint-group | n/a |
| <a name="module_aci_oob_external_management_instance"></a> [aci\_oob\_external\_management\_instance](#module\_aci\_oob\_external\_management\_instance) | ./modules/terraform-aci-oob-external-management-instance | n/a |
| <a name="module_aci_oob_node_address"></a> [aci\_oob\_node\_address](#module\_aci\_oob\_node\_address) | ./modules/terraform-aci-oob-node-address | n/a |
| <a name="module_aci_ospf_interface_policy"></a> [aci\_ospf\_interface\_policy](#module\_aci\_ospf\_interface\_policy) | ./modules/terraform-aci-ospf-interface-policy | n/a |
| <a name="module_aci_ospf_route_summarization_policy"></a> [aci\_ospf\_route\_summarization\_policy](#module\_aci\_ospf\_route\_summarization\_policy) | ./modules/terraform-aci-ospf-route-summarization-policy | n/a |
| <a name="module_aci_ospf_timer_policy"></a> [aci\_ospf\_timer\_policy](#module\_aci\_ospf\_timer\_policy) | ./modules/terraform-aci-ospf-timer-policy | n/a |
| <a name="module_aci_physical_domain"></a> [aci\_physical\_domain](#module\_aci\_physical\_domain) | ./modules/terraform-aci-physical-domain | n/a |
| <a name="module_aci_pim_policy"></a> [aci\_pim\_policy](#module\_aci\_pim\_policy) | ./modules/terraform-aci-pim-policy | n/a |
| <a name="module_aci_pod_setup"></a> [aci\_pod\_setup](#module\_aci\_pod\_setup) | ./modules/terraform-aci-pod-setup | n/a |
| <a name="module_aci_port_channel_member_policy"></a> [aci\_port\_channel\_member\_policy](#module\_aci\_port\_channel\_member\_policy) | ./modules/terraform-aci-port-channel-member-policy | n/a |
| <a name="module_aci_port_channel_policy"></a> [aci\_port\_channel\_policy](#module\_aci\_port\_channel\_policy) | ./modules/terraform-aci-port-channel-policy | n/a |
| <a name="module_aci_port_security_policy"></a> [aci\_port\_security\_policy](#module\_aci\_port\_security\_policy) | ./modules/terraform-aci-port-security-policy | n/a |
| <a name="module_aci_port_tracking"></a> [aci\_port\_tracking](#module\_aci\_port\_tracking) | ./modules/terraform-aci-port-tracking | n/a |
| <a name="module_aci_priority_flow_control_policy"></a> [aci\_priority\_flow\_control\_policy](#module\_aci\_priority\_flow\_control\_policy) | ./modules/terraform-aci-priority-flow-control-policy | n/a |
| <a name="module_aci_psu_policy"></a> [aci\_psu\_policy](#module\_aci\_psu\_policy) | ./modules/terraform-aci-psu-policy | n/a |
| <a name="module_aci_ptp"></a> [aci\_ptp](#module\_aci\_ptp) | ./modules/terraform-aci-ptp | n/a |
| <a name="module_aci_ptp_profile"></a> [aci\_ptp\_profile](#module\_aci\_ptp\_profile) | ./modules/terraform-aci-ptp-profile | n/a |
| <a name="module_aci_qos"></a> [aci\_qos](#module\_aci\_qos) | ./modules/terraform-aci-qos | n/a |
| <a name="module_aci_qos_policy"></a> [aci\_qos\_policy](#module\_aci\_qos\_policy) | ./modules/terraform-aci-qos-policy | n/a |
| <a name="module_aci_radius"></a> [aci\_radius](#module\_aci\_radius) | ./modules/terraform-aci-radius | n/a |
| <a name="module_aci_rbac_node_rule"></a> [aci\_rbac\_node\_rule](#module\_aci\_rbac\_node\_rule) | ./modules/terraform-aci-rbac-node-rule | n/a |
| <a name="module_aci_redirect_backup_policy"></a> [aci\_redirect\_backup\_policy](#module\_aci\_redirect\_backup\_policy) | ./modules/terraform-aci-redirect-backup-policy | n/a |
| <a name="module_aci_redirect_health_group"></a> [aci\_redirect\_health\_group](#module\_aci\_redirect\_health\_group) | ./modules/terraform-aci-redirect-health-group | n/a |
| <a name="module_aci_redirect_policy"></a> [aci\_redirect\_policy](#module\_aci\_redirect\_policy) | ./modules/terraform-aci-redirect-policy | n/a |
| <a name="module_aci_remote_location"></a> [aci\_remote\_location](#module\_aci\_remote\_location) | ./modules/terraform-aci-remote-location | n/a |
| <a name="module_aci_rogue_endpoint_control"></a> [aci\_rogue\_endpoint\_control](#module\_aci\_rogue\_endpoint\_control) | ./modules/terraform-aci-rogue-endpoint-control | n/a |
| <a name="module_aci_route_control_route_map"></a> [aci\_route\_control\_route\_map](#module\_aci\_route\_control\_route\_map) | ./modules/terraform-aci-route-control-route-map | n/a |
| <a name="module_aci_route_tag_policy"></a> [aci\_route\_tag\_policy](#module\_aci\_route\_tag\_policy) | ./modules/terraform-aci-route-tag-policy | n/a |
| <a name="module_aci_routed_domain"></a> [aci\_routed\_domain](#module\_aci\_routed\_domain) | ./modules/terraform-aci-routed-domain | n/a |
| <a name="module_aci_service_epg_policy"></a> [aci\_service\_epg\_policy](#module\_aci\_service\_epg\_policy) | ./modules/terraform-aci-service-epg-policy | n/a |
| <a name="module_aci_service_graph_template"></a> [aci\_service\_graph\_template](#module\_aci\_service\_graph\_template) | ./modules/terraform-aci-service-graph-template | n/a |
| <a name="module_aci_set_rule"></a> [aci\_set\_rule](#module\_aci\_set\_rule) | ./modules/terraform-aci-set-rule | n/a |
| <a name="module_aci_smart_licensing"></a> [aci\_smart\_licensing](#module\_aci\_smart\_licensing) | ./modules/terraform-aci-smart-licensing | n/a |
| <a name="module_aci_snmp_policy"></a> [aci\_snmp\_policy](#module\_aci\_snmp\_policy) | ./modules/terraform-aci-snmp-policy | n/a |
| <a name="module_aci_snmp_trap_policy"></a> [aci\_snmp\_trap\_policy](#module\_aci\_snmp\_trap\_policy) | ./modules/terraform-aci-snmp-trap-policy | n/a |
| <a name="module_aci_spanning_tree_policy"></a> [aci\_spanning\_tree\_policy](#module\_aci\_spanning\_tree\_policy) | ./modules/terraform-aci-spanning-tree-policy | n/a |
| <a name="module_aci_spine_fabric_interface_configuration"></a> [aci\_spine\_fabric\_interface\_configuration](#module\_aci\_spine\_fabric\_interface\_configuration) | ./modules/terraform-aci-fabric-interface-configuration | n/a |
| <a name="module_aci_spine_interface_configuration"></a> [aci\_spine\_interface\_configuration](#module\_aci\_spine\_interface\_configuration) | ./modules/terraform-aci-interface-configuration | n/a |
| <a name="module_aci_sr_mpls_external_endpoint_group"></a> [aci\_sr\_mpls\_external\_endpoint\_group](#module\_aci\_sr\_mpls\_external\_endpoint\_group) | ./modules/terraform-aci-external-endpoint-group | n/a |
| <a name="module_aci_sr_mpls_global_configuration"></a> [aci\_sr\_mpls\_global\_configuration](#module\_aci\_sr\_mpls\_global\_configuration) | ./modules/terraform-aci-sr-mpls-global-configuration | n/a |
| <a name="module_aci_sr_mpls_l3out"></a> [aci\_sr\_mpls\_l3out](#module\_aci\_sr\_mpls\_l3out) | ./modules/terraform-aci-l3out | n/a |
| <a name="module_aci_sr_mpls_l3out_interface_profile_manual"></a> [aci\_sr\_mpls\_l3out\_interface\_profile\_manual](#module\_aci\_sr\_mpls\_l3out\_interface\_profile\_manual) | ./modules/terraform-aci-l3out-interface-profile | n/a |
| <a name="module_aci_sr_mpls_l3out_node_profile_manual"></a> [aci\_sr\_mpls\_l3out\_node\_profile\_manual](#module\_aci\_sr\_mpls\_l3out\_node\_profile\_manual) | ./modules/terraform-aci-l3out-node-profile | n/a |
| <a name="module_aci_storm_control_policy"></a> [aci\_storm\_control\_policy](#module\_aci\_storm\_control\_policy) | ./modules/terraform-aci-storm-control-policy | n/a |
| <a name="module_aci_subinterface_shutdown"></a> [aci\_subinterface\_shutdown](#module\_aci\_subinterface\_shutdown) | ./modules/terraform-aci-interface-shutdown | n/a |
| <a name="module_aci_syslog_policy"></a> [aci\_syslog\_policy](#module\_aci\_syslog\_policy) | ./modules/terraform-aci-syslog-policy | n/a |
| <a name="module_aci_system_global_gipo"></a> [aci\_system\_global\_gipo](#module\_aci\_system\_global\_gipo) | ./modules/terraform-aci-system-global-gipo | n/a |
| <a name="module_aci_system_performance"></a> [aci\_system\_performance](#module\_aci\_system\_performance) | ./modules/terraform-aci-system-performance | n/a |
| <a name="module_aci_tacacs"></a> [aci\_tacacs](#module\_aci\_tacacs) | ./modules/terraform-aci-tacacs | n/a |
| <a name="module_aci_tenant"></a> [aci\_tenant](#module\_aci\_tenant) | ./modules/terraform-aci-tenant | n/a |
| <a name="module_aci_tenant_data_plane_policing_policy"></a> [aci\_tenant\_data\_plane\_policing\_policy](#module\_aci\_tenant\_data\_plane\_policing\_policy) | ./modules/terraform-aci-data-plane-policing-policy | n/a |
| <a name="module_aci_tenant_monitoring_policy"></a> [aci\_tenant\_monitoring\_policy](#module\_aci\_tenant\_monitoring\_policy) | ./modules/terraform-aci-tenant-monitoring-policy | n/a |
| <a name="module_aci_tenant_netflow_exporter"></a> [aci\_tenant\_netflow\_exporter](#module\_aci\_tenant\_netflow\_exporter) | ./modules/terraform-aci-tenant-netflow-exporter | n/a |
| <a name="module_aci_tenant_netflow_monitor"></a> [aci\_tenant\_netflow\_monitor](#module\_aci\_tenant\_netflow\_monitor) | ./modules/terraform-aci-tenant-netflow-monitor | n/a |
| <a name="module_aci_tenant_netflow_record"></a> [aci\_tenant\_netflow\_record](#module\_aci\_tenant\_netflow\_record) | ./modules/terraform-aci-tenant-netflow-record | n/a |
| <a name="module_aci_tenant_span_destination_group"></a> [aci\_tenant\_span\_destination\_group](#module\_aci\_tenant\_span\_destination\_group) | ./modules/terraform-aci-tenant-span-destination-group | n/a |
| <a name="module_aci_tenant_span_source_group"></a> [aci\_tenant\_span\_source\_group](#module\_aci\_tenant\_span\_source\_group) | ./modules/terraform-aci-tenant-span-source-group | n/a |
| <a name="module_aci_track_list"></a> [aci\_track\_list](#module\_aci\_track\_list) | ./modules/terraform-aci-track-list | n/a |
| <a name="module_aci_track_member"></a> [aci\_track\_member](#module\_aci\_track\_member) | ./modules/terraform-aci-track-member | n/a |
| <a name="module_aci_trust_control_policy"></a> [aci\_trust\_control\_policy](#module\_aci\_trust\_control\_policy) | ./modules/terraform-aci-trust-control-policy | n/a |
| <a name="module_aci_useg_endpoint_group"></a> [aci\_useg\_endpoint\_group](#module\_aci\_useg\_endpoint\_group) | ./modules/terraform-aci-useg-endpoint-group | n/a |
| <a name="module_aci_user"></a> [aci\_user](#module\_aci\_user) | ./modules/terraform-aci-user | n/a |
| <a name="module_aci_vlan_pool"></a> [aci\_vlan\_pool](#module\_aci\_vlan\_pool) | ./modules/terraform-aci-vlan-pool | n/a |
| <a name="module_aci_vmware_vmm_domain"></a> [aci\_vmware\_vmm\_domain](#module\_aci\_vmware\_vmm\_domain) | ./modules/terraform-aci-vmware-vmm-domain | n/a |
| <a name="module_aci_vpc_group"></a> [aci\_vpc\_group](#module\_aci\_vpc\_group) | ./modules/terraform-aci-vpc-group | n/a |
| <a name="module_aci_vpc_policy"></a> [aci\_vpc\_policy](#module\_aci\_vpc\_policy) | ./modules/terraform-aci-vpc-policy | n/a |
| <a name="module_aci_vrf"></a> [aci\_vrf](#module\_aci\_vrf) | ./modules/terraform-aci-vrf | n/a |
| <a name="module_aci_vspan_destination_group"></a> [aci\_vspan\_destination\_group](#module\_aci\_vspan\_destination\_group) | ./modules/terraform-aci-vspan-destination-group | n/a |
| <a name="module_aci_vspan_session"></a> [aci\_vspan\_session](#module\_aci\_vspan\_session) | ./modules/terraform-aci-vspan-session | n/a |
<!-- END_TF_DOCS -->