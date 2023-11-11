<!-- BEGIN_TF_DOCS -->
# Fabric ISIS Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_isis_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-isis-policy"
  version = ">= 0.8.0"

  redistribute_metric = 60
}
```
<!-- END_TF_DOCS -->