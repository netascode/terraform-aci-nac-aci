<!-- BEGIN_TF_DOCS -->
# Fabric Spine Interface Policy Group Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_spine_interface_policy_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-spine-interface-policy-group"
  version = "> 2.0.0"

  name              = "SPINES"
  description       = "All Spines"
  link_level_policy = "default"
  macsec_policy     = "default"
}
```
<!-- END_TF_DOCS -->