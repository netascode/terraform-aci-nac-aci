*** Settings ***
Documentation   Verify Match Rule
Suite Setup     Login APIC
Default Tags    apic   day2   config   tenants
Resource        ../../../apic_common.resource

*** Test Cases ***
{% set tenant = ((apic | default()) | json_query('tenants[?name==`' ~ item[2] ~ '`]'))[0] %}
{% for rule in tenant.policies.match_rules | default([]) %}
{% set rule_name = rule.name ~ defaults.apic.tenants.policies.match_rules.name_suffix %}

Verify Match Rule {{ rule_name }}
    GET   "/api/mo/uni/tn-{{ tenant.name }}/subj-{{ rule_name }}.json?rsp-subtree=full"
    String   $..rtctrlSubjP.attributes.name   {{ rule_name }}
    String   $..rtctrlSubjP.attributes.descr   {{ rule.description | default() }}

{% for re_comm_term in rule.regex_community_terms | default([]) %}
{% set re_comm_term_name = re_comm_term.name ~ defaults.apic.tenants.policies.match_rules.regex_community_terms.name_suffix %}

Verify Match Rule {{ rule_name }} Regex Community Terms {{ re_comm_term_name }}
    ${regex_comm_term}=   Set Variable   $..rtctrlSubjP.children[?(@.rtctrlMatchCommRegexTerm.attributes.name=='{{ re_comm_term_name }}')]
    String   ${regex_comm_term}..rtctrlMatchCommRegexTerm.attributes.name   {{ re_comm_term_name }}
    String   ${regex_comm_term}..rtctrlMatchCommRegexTerm.attributes.regex   {{ re_comm_term.regex }}
    String   ${regex_comm_term}..rtctrlMatchCommRegexTerm.attributes.commType   {{ re_comm_term.type | default(defaults.apic.tenants.policies.match_rules.regex_community_terms.type)  }}
    String   ${regex_comm_term}..rtctrlMatchCommRegexTerm.attributes.descr   {{ re_comm_term.description | default() }}

{% endfor %}

{% for comm_term in rule.community_terms | default([]) %}
{% set comm_term_name = comm_term.name ~ defaults.apic.tenants.policies.match_rules.community_terms.name_suffix %}

Verify Match Rule {{ rule_name }} Community Terms {{ comm_term_name }}
    ${comm_term}=   Set Variable   $..rtctrlSubjP.children[?(@.rtctrlMatchCommTerm.attributes.name=='{{ comm_term_name }}')]
    String   ${comm_term}..rtctrlMatchCommTerm.attributes.name   {{ comm_term.name }}
    String   ${comm_term}..rtctrlMatchCommTerm.attributes.descr   {{ comm_term.description | default() }}

{% for factor in comm_term.factors  | default([]) %}

Verify Match Rule {{ rule_name }} Community Terms {{ comm_term_name }} Community Factor {{ factor.community }}
    ${comm_term}=   Set Variable   $..rtctrlSubjP.children[?(@.rtctrlMatchCommTerm.attributes.name=='{{ comm_term_name }}')]
    ${comm_term_comm}=   Set Variable    ${comm_term}..rtctrlMatchCommTerm.children[?(@.rtctrlMatchCommFactor.attributes.community=='{{ factor.community }}')]
    String   ${comm_term_comm}..rtctrlMatchCommFactor.attributes.community   {{ factor.community }}
    String   ${comm_term_comm}..rtctrlMatchCommFactor.attributes.descr   {{ factor.description | default() }}
    String   ${comm_term_comm}..rtctrlMatchCommFactor.attributes.scope   {{ factor.scope | default(defaults.apic.tenants.policies.match_rules.community_terms.factors.scope) }}

{% endfor %}

{% endfor %}

{% for prefix in rule.prefixes | default([]) %}

Verify Match Rule {{ rule_name }} Prefix {{ prefix.ip }}
    ${prefix}=   Set Variable   $..rtctrlSubjP.children[?(@.rtctrlMatchRtDest.attributes.ip=='{{ prefix.ip }}')]
    String   ${prefix}..rtctrlMatchRtDest.attributes.ip   {{ prefix.ip }}
    String   ${prefix}..rtctrlMatchRtDest.attributes.descr   {{ prefix.description | default() }}
    String   ${prefix}..rtctrlMatchRtDest.attributes.aggregate   {{ prefix.aggregate | default(defaults.apic.tenants.policies.match_rules.prefixes.aggregate) }}
    String   ${prefix}..rtctrlMatchRtDest.attributes.fromPfxLen   {{ prefix.from_length | default(defaults.apic.tenants.policies.match_rules.prefixes.from_length) }}
    String   ${prefix}..rtctrlMatchRtDest.attributes.toPfxLen   {{ prefix.to_length | default(defaults.apic.tenants.policies.match_rules.prefixes.to_length) }}

{% endfor %}

{% endfor %}
