<!-- BEGIN_TF_DOCS -->
# Fabric Pod Profile Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_fabric_pod_profile" {
  source  = "netascode/fabric-pod-profile/aci"
  version = ">= 0.2.0"

  name = "POD1-2"
  selectors = [{
    name         = "SEL1"
    policy_group = "POD1-2"
    pod_blocks = [{
      name = "PB1"
      from = 1
      to   = 2
    }]
  }]
}
```
<!-- END_TF_DOCS -->