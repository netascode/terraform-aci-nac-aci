# Template

The `deploy_order` attribute influences the order of template deployment, where a template with a lower number will always be deployed before a template with a higher number. This flag is only relevant for Terraform.

Location in GUI:
`Application Management` » `Schemas`

{{ doc_gen }}

### Examples

```yaml
ndo:
  schemas:
    - name: ABC
      templates:
        - name: TEMPLATE1
          tenant: MSO1
          sites:
            - APIC1
```
