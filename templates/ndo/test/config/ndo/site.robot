*** Settings ***
Documentation   Verify Site
Suite Setup     Login NDO
Default Tags    ndo   config   day1
Resource        ../../ndo_common.resource

*** Test Cases ***
Get Sites
    ${r}=   GET On Session   ndo   /mso/api/v2/sites
    Set Suite Variable   ${r}

{% for site in ndo.sites | default([]) %}

Verify Site {{ site.name }}
    ${site}=   Set Variable   $..sites[?(@.common.name=='{{ site.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${site}.common.name   {{ site.name }}
{% for url in site.apic_urls | default([]) %}
    Should Be Equal Value Json String   ${r.json()}   ${site}.common.urls[{{ loop.index - 1 }}]   {{ url }}
{% endfor %}
    Should Be Equal Value Json String   ${r.json()}   ${site}.common.siteId   {{ site.id }}
    Should Be Equal Value Json Number   ${r.json()}   ${site}.common.longitude   {{ site.location.long | default(defaults.ndo.sites.location.long) }}
    Should Be Equal Value Json Number   ${r.json()}   ${site}.common.latitude   {{ site.location.lat | default(defaults.ndo.sites.location.lat) }}

{% endfor %}
