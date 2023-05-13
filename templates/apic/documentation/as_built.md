## Endpoint Groups

This is a table of endpoint groups.

Tenant | Application Profile | Endpoint Group | Bridge Domain
---|---|---|---
{% for tenant in apic.tenants | default([]) %}
{% for ap in tenant.application_profiles | default([]) %}
{% for epg in ap.endpoint_groups | default([]) %}
{{ tenant.name }} | {{ ap.name ~ defaults.apic.tenants.application_profiles.name_suffix }} | {{ epg.name ~ defaults.apic.tenants.application_profiles.endpoint_groups.name_suffix }} | {{ epg.bridge_domain ~ defaults.apic.tenants.bridge_domains.name_suffix }}
{% endfor %}
{% endfor %}
{% endfor %}
