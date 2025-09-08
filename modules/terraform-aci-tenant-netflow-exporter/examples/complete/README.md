<!-- BEGIN_TF_DOCS -->
# Tenant Netflow Exporter Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_tenant_netflow_exporter" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-tenant-netflow-exporter"
  version = ">= 0.9.0"

  name                = "EXPORTER1"
  description         = "Netflow exporter 1"
  source_type         = "custom-src-ip"
  source_ip           = "172.16.0.0/20"
  destination_port    = "1234"
  destination_ip      = "10.1.1.1"
  dscp                = "AF12"
  epg_type            = "epg"
  tenant              = "ABC"
  application_profile = "AP1"
  endpoint_group      = "EPG1"
  vrf                 = "VRF1"
}
```
<!-- END_TF_DOCS -->