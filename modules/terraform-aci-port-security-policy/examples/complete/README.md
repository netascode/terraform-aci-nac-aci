<!-- BEGIN_TF_DOCS -->
# Port Security Policy Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_port_security_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-port-security-policy"
  version = "> 1.2.0"

  name              = "PORT_SEC_10"
  description       = "Port security with max 10 endpoints"
  maximum_endpoints = 10
  timeout           = 300
}
```
<!-- END_TF_DOCS -->