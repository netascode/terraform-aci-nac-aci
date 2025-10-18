<!-- BEGIN_TF_DOCS -->
# Nutanix VMM Domain Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_nutanix_vmm_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-nutanix-vmm-domain"
  version = ">= 0.8.0"

  name                = "VMW1"
  access_mode         = "read-write"
  vlan_pool           = "VLANPOOL1"
  allocation          = "dynamic"
  custom_vswitch_name = "NutanixVSwitch"
  security_domains    = ["SECURITY-DOMAIN1", "SECURITY-DOMAIN2"]
  credential_policies = [
    {
      name     = "CRED-POL1"
      username = "admin"
      password = "P@ssw0rd!"
    },
    {
      name     = "CRED-POL2"
      username = "nutanix"
      password = "Nutanix123!"
    }
  ]
  controller_profile = {
    name        = "ControllerProfile1"
    hostname_ip = "10.0.0.1"
    datacenter  = "DC1"
    aos_version = "6.6"
    credentials = "CRED-POL1"
    statistics  = true
  }
  cluster_controller = {
    name               = "CC1"
    hostname_ip        = "10.0.0.3"
    cluster_name       = "Cluster1"
    credentials        = "CRED-POL2"
    port               = 35001
    controller_profile = "ControllerProfile1"
  }
}
```
<!-- END_TF_DOCS -->