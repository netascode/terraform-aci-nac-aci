<!-- BEGIN_TF_DOCS -->
# Routed Domain Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_routed_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-routed-domain"
  version = ">= 0.8.0"

  name                 = "RD1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]
}
```
<!-- END_TF_DOCS -->