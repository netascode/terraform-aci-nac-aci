*** Settings ***
Documentation   Verify Site
Suite Setup     Login MSO
Default Tags    mso   config   day1
Resource        ../../mso_common.resource

*** Test Cases ***
Get Sites
    ${r}=   GET On Session   mso   /api/v1/sites
    Set Suite Variable   ${r}

{% for site in mso.sites | default([]) %}

Verify Site {{ site.name }}
    ${site}=   Set Variable   $..sites[?(@.name=='{{ site.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${site}.name   {{ site.name }}
{% for url in site.apic_urls | default([]) %}
    Should Be Equal Value Json String   ${r.json()}   ${site}.urls[{{ loop.index - 1 }}]   {{ url }}
{% endfor %}
    Should Be Equal Value Json String   ${r.json()}   ${site}.username   {{ site.username }}
    Should Be Equal Value Json String   ${r.json()}   ${site}.apicSiteId   {{ site.id }}
    Should Be Equal Value Json Number   ${r.json()}   ${site}.location.long   {{ site.location.long | default(defaults.mso.sites.location.long) }}
    Should Be Equal Value Json Number   ${r.json()}   ${site}.location.lat   {{ site.location.long | default(defaults.mso.sites.location.lat) }}

{% endfor %}
