*** Settings ***
Documentation   Verify Site
Suite Setup     Login MSO
Default Tags    mso   config   day1
Resource        ../../mso_common.resource

*** Test Cases ***
Get Sites
    GET   "/api/v1/sites"

{% for site in mso.sites | default([]) %}

Verify Site {{ site.name }}
    ${site}=   Set Variable   $..sites[?(@.name=='{{ site.name }}')]
    String   ${site}.name   {{ site.name }}
{% for url in site.apic_urls | default([]) %}
    String   ${site}.urls[{{ loop.index - 1 }}]   {{ url }}
{% endfor %}
    String   ${site}.username   {{ site.username }}
    String   ${site}.apicSiteId   {{ site.id }}
    Number   ${site}.location.long   {{ site.location.long | default(defaults.mso.sites.location.long) }}
    Number   ${site}.location.lat   {{ site.location.long | default(defaults.mso.sites.location.lat) }}

{% endfor %}
