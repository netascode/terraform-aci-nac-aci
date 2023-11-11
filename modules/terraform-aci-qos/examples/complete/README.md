<!-- BEGIN_TF_DOCS -->
# QoS Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

```hcl
module "aci_qos" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-qos"
  version = ">= 0.8.0"

  preserve_cos = true
  qos_classes = [{
    level                = 1
    admin_state          = false
    mtu                  = 9000
    bandwidth_percent    = 30
    scheduling           = "strict-priority"
    congestion_algorithm = "wred"
    minimum_buffer       = 1
    pfc_state            = true
    no_drop_cos          = "cos1"
    pfc_scope            = "fabric"
    ecn                  = true
    forward_non_ecn      = true
    wred_max_threshold   = 90
    wred_min_threshold   = 10
    wred_probability     = 5
    weight               = 1
  }]
}
```
<!-- END_TF_DOCS -->