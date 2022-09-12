*** Settings ***
Documentation   Verify Management Access Policy
Suite Setup     Login APIC
Default Tags    apic   day1   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***

{%- for policy in apic.fabric_policies.pod_policies.management_access_policies | default([]) %}
{% set management_access_policy_name = policy.name ~ defaults.apic.fabric_policies.pod_policies.management_access_policies.name_suffix %}

Verify Management Access Policy {{ policy.name }}
    ${r}=   GET On Session   apic   /api/node/mo/uni/fabric/comm-{{ management_access_policy_name }}.json   params=rsp-subtree=full
    Set Suite Variable   ${r}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.attributes.name   {{ management_access_policy_name }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.attributes.descr   {{ policy.description | default() }}

Verify Management Access Policy {{ policy.name }} Telnet
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commTelnet.attributes.adminSt   {{ policy.telnet.admin_state | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.telnet.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commTelnet.attributes.port   {{ policy.telnet.port | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.telnet.port) }}

{% set ssl_ciphers = [] %}
{% if policy.ssh.aes128_ctr | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes128_ctr) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_ciphers = ssl_ciphers + [("aes128-ctr")] %}{% endif %}
{% if policy.ssh.aes128_gcm | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes128_gcm) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_ciphers = ssl_ciphers + [("aes128-gcm@openssh.com")] %}{% endif %}
{% if policy.ssh.aes192_ctr | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes192_ctr) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_ciphers = ssl_ciphers + [("aes192-ctr")] %}{% endif %}
{% if policy.ssh.aes256_ctr | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.aes256_ctr) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_ciphers = ssl_ciphers + [("aes256-ctr")] %}{% endif %}
{% if policy.ssh.chacha | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.chacha) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_ciphers = ssl_ciphers + [("chacha20-poly1305@openssh.com")] %}{% endif %}

{% set ssh_macs = [] %}
{% if policy.ssh.hmac_sha1 | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.hmac_sha1) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssh_macs = ssh_macs + [("hmac-sha1")] %}{% endif %}
{% if policy.ssh.hmac_sha2_256 | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.hmac_sha2_256) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssh_macs = ssh_macs + [("hmac-sha2-256")] %}{% endif %}
{% if policy.ssh.hmac_sha2_512 | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.hmac_sha2_512) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssh_macs = ssh_macs + [("hmac-sha2-512")] %}{% endif %}

Verify Management Access Policy {{ policy.name }} SSH
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commSsh.attributes.adminSt   {{ policy.ssh.admin_state | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commSsh.attributes.port   {{ policy.ssh.port | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.port) }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commSsh.attributes.passwordAuth   {{ policy.ssh.password_auth | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.ssh.password_auth) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commSsh.attributes.sshCiphers   {{ ssl_ciphers | join(',') }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commSsh.attributes.sshMacs   {{ ssh_macs | join(',') }}

{% set ssl_protocols = [] %}
{% if policy.https.tlsv1 | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.tlsv1) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_protocols = ssl_protocols + [("TLSv1")] %}{% endif %}
{% if policy.https.tlsv1_1 | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.tlsv1_1) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_protocols = ssl_protocols + [("TLSv1.1")] %}{% endif %}
{% if policy.https.tlsv1_2 | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.tlsv1_2) | cisco.aac.aac_bool("yes") == "yes" %}{% set ssl_protocols = ssl_protocols + [("TLSv1.2")] %}{% endif %}

Verify Management Access Policy {{ policy.name }} HTTPS
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttps.attributes.adminSt   {{ policy.https.admin_state | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttps.attributes.clientCertAuthState   {{ policy.https.client_cert_auth_state | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.client_cert_auth_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttps.attributes.dhParam   {{ policy.https.dh | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.dh) }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttps.attributes.port   {{ policy.https.port | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.port) }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttps.attributes.sslProtocols   {{ ssl_protocols | join(',') }}             
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttps.children..commRsKeyRing.attributes.tnPkiKeyRingName   {{ policy.https.key_ring | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.https.key_ring) }}

Verify Management Access Policy {{ policy.name }} HTTP
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttp.attributes.adminSt   {{ policy.http.admin_state | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.http.admin_state) | cisco.aac.aac_bool("enabled") }}
    Should Be Equal Value Json String   ${r.json()}    $..commPol.children..commHttp.attributes.port   {{ policy.http.port | default(defaults.apic.fabric_policies.pod_policies.management_access_policies.http.port) }}

{% endfor %}