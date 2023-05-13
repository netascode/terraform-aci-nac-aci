## Endpoint Groups

This is a table of endpoint groups.

Schema | Template | Application Profile | Endpoint Group | Bridge Domain
---|---|---|---|---
{% for schema in ndo.schemas | default([]) %}
{% for template in schema.templates | default([]) %}
{% for ap in template.application_profiles | default([]) %}
{% for epg in ap.endpoint_groups | default([]) %}
{{ schema.name }} | {{ template.name }} | {{ ap.name ~ defaults.ndo.schemas.templates.application_profiles.name_suffix }} | {{ epg.name ~ defaults.ndo.schemas.templates.application_profiles.endpoint_groups.name_suffix }} | {{ epg.bridge_domain.name ~ defaults.ndo.schemas.templates.bridge_domains.name_suffix }}
{% endfor %}
{% endfor %}
{% endfor %}
{% endfor %}
