<!-- BEGIN_TF_DOCS -->
# Remote Leaf Pod Redundancy Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_remote_leaf_pod_redundancy_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-remote-leaf-pod-redundancy-policy"
  version = ">= 0.8.0"

  enable_remote_leaf_policy = true
  enable_preemption         = true
}
```
<!-- END_TF_DOCS -->