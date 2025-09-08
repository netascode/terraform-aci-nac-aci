<!-- BEGIN_TF_DOCS -->
# Netflow Record Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_netflow_record" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-netflow-record"
  version = ">= 0.9.0"

  name             = "RECORD1"
  description      = "Netflow record 1"
  match_parameters = ["dst-ip", "src-ip"]
}
```
<!-- END_TF_DOCS -->