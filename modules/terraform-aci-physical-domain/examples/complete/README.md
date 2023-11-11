<!-- BEGIN_TF_DOCS -->
# Physical Domain Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_physical_domain" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-physical-domain"
  version = ">= 0.8.0"

  name                 = "PHY1"
  vlan_pool            = "VP1"
  vlan_pool_allocation = "dynamic"
  security_domains     = ["SEC1"]
}
```
<!-- END_TF_DOCS -->