# NDO Overview

## Structure

The NDO configuration is divided into five high level sections:

- `system`: Manage system level configuration like banners
- `sites`: Enable sites in NDO
- `site_connectivity`: Manage Multi-Site connectivity configuration
- `tenants`: Configure tenants using NDO
- `schemas`: Configurations applied at the schema and template level (e.g., VRFs and Bridge Domains)

## IPv6 Addresses

Whenever IPv6 addresses are being used, NDO normalizes them according to [RFC 5952](https://www.rfc-editor.org/rfc/rfc5952). Therefore the same format should be used when defining IPv6 addresses in YAML files. Otherwise Terraform for example might detect a configuration drift when comparing the configured IPv6 address with the one defined in the YAML file.

## Additional Resources

The ACI-as-Code Data Model describes how to create resources but not what functional purpose they serve within NDO. For more information about ACI please visit [ACI Developer Docs](https://developer.cisco.com/docs/aci/).
