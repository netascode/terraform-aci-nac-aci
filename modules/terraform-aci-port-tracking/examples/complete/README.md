<!-- BEGIN_TF_DOCS -->
# Port Tracking Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_port_tracking" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-tracking"
  version = ">= 0.8.0"

  admin_state = true
  delay       = 5
  min_links   = 2
}
```
<!-- END_TF_DOCS -->