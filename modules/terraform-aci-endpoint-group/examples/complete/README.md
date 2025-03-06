<!-- BEGIN_TF_DOCS -->
# Endpoint Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_endpoint_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-endpoint-group"
  version = ">= 0.9.1"

  tenant                      = "ABC"
  application_profile         = "AP1"
  name                        = "EPG1"
  alias                       = "EPG1-ALIAS"
  description                 = "My Description"
  flood_in_encap              = false
  intra_epg_isolation         = true
  preferred_group             = true
  qos_class                   = "level1"
  custom_qos_policy           = "CQP1"
  bridge_domain               = "BD1"
  trust_control_policy        = "TRUST_POL"
  contract_consumers          = ["CON1"]
  contract_providers          = ["CON1"]
  contract_imported_consumers = ["I_CON1"]
  contract_intra_epgs         = ["CON1"]
  contract_masters = [{
    endpoint_group      = "EPG2"
    application_profile = "AP1"
  }]
  physical_domains = ["PHY1"]
  tags = [
    "tag1",
    "tag2"
  ]
  subnets = [{
    description        = "Subnet Description"
    ip                 = "1.1.1.1/24"
    public             = true
    shared             = true
    igmp_querier       = true
    nd_ra_prefix       = true
    no_default_gateway = false
  }]
  vmware_vmm_domains = [{
    name                 = "VMW1"
    u_segmentation       = true
    delimiter            = ":"
    vlan                 = 123
    netflow              = false
    deployment_immediacy = "lazy"
    resolution_immediacy = "lazy"
    allow_promiscuous    = true
    forged_transmits     = true
    mac_changes          = true
    custom_epg_name      = "custom-epg-name"
  }]
  static_ports = [{
    node_id              = 101
    vlan                 = 123
    primary_vlan         = 124
    pod_id               = 1
    port                 = 10
    sub_port             = 1
    module               = 1
    deployment_immediacy = "lazy"
    mode                 = "untagged"
    ptp = {
      profile = "PTP1"
    }
  }]
  static_leafs = [{
    node_id              = 102
    vlan                 = 124
    deployment_immediacy = "lazy"
    mode                 = "untagged"
  }]
  static_endpoints = [{
    name           = "EP1"
    alias          = "EP1-ALIAS"
    mac            = "11:11:11:11:11:11"
    ip             = "1.1.1.10"
    type           = "silent-host"
    node_id        = 101
    node2_id       = 102
    vlan           = 123
    pod_id         = 1
    channel        = "VPC1"
    additional_ips = ["1.1.1.11"]
  }]
  l4l7_virtual_ips = [{
    ip          = "1.2.3.4"
    description = "My Virtual IP"
  }]
  l4l7_address_pools = [{
    name            = "POOL1"
    gateway_address = "1.1.1.1/24"
    from            = "1.1.1.10"
    to              = "1.1.1.100"
  }]
}
```
<!-- END_TF_DOCS -->