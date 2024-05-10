<!-- BEGIN_TF_DOCS -->
# VMware VMM Domain Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_vmware_vmm_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vmware-vmm-domain"
  version = ">= 0.8.0"

  name                        = "VMW1"
  access_mode                 = "read-only"
  delimiter                   = "="
  tag_collection              = true
  vlan_pool                   = "VP1"
  allocation                  = "static"
  vswitch_cdp_policy          = "CDP1"
  vswitch_lldp_policy         = "LLDP1"
  vswitch_port_channel_policy = "PC1"
  vswitch_mtu_policy          = "L2-8950"
  security_domains            = ["SEC1"]
  vswitch_enhanced_lags = [
    {
      name    = "ELAG1"
      mode    = "passive"
      lb_mode = "dst-ip-l4port"
    },
    {
      name = "ELAG2"
    }
  ]
  vcenters = [{
    name              = "VC1"
    hostname_ip       = "1.1.1.1"
    datacenter        = "DC"
    credential_policy = "CP1"
    dvs_version       = "6.5"
    statistics        = true
    mgmt_epg_type     = "oob"
  }]
  credential_policies = [{
    name     = "CP1"
    username = "USER1"
    password = "PASSWORD1"
  }]
  uplinks = [
    {
      id   = 1
      name = "UL1"
    },
    {
      id   = 2
      name = "UL2"
    }
  ]
}
```
<!-- END_TF_DOCS -->