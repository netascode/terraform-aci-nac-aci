<!-- BEGIN_TF_DOCS -->
# IP Aging Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_ip_aging" {
  source  = "netascode/ip-aging/aci"
  version = ">= 0.1.0"

  admin_state = true
}
```
<!-- END_TF_DOCS -->