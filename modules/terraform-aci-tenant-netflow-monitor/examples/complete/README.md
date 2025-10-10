<!-- BEGIN_TF_DOCS -->
# Tenant Netflow Monitor Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_tenant_netflow_monitor" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-netflow-monitor"
  version = ">= 0.9.0"

  name           = "MONITOR1"
  description    = "Netflow monitor 1"
  flow_record    = "RECORD1"
  flow_exporters = ["EXPORTER1", "EXPORTER2"]
}
```
<!-- END_TF_DOCS -->