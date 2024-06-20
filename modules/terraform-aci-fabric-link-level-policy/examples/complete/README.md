<!-- BEGIN_TF_DOCS -->
# Terraform ACI Fabric Policies Link Level Module

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_link_level_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-link-level-policy"
  version = ">= 0.0.1"

  name         = "name"
  descr        = "My Description"
  linkDebounce = 1000
}
```
<!-- END_TF_DOCS -->