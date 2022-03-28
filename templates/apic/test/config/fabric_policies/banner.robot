*** Settings ***
Documentation   Banners
Suite Setup     Login APIC
Default Tags    apic   day0   config   fabric_policies
Resource        ../../apic_common.resource

*** Test Cases ***
Verify Banners
    GET   "/api/mo/uni/userext/preloginbanner.json"
{% if apic.fabric_policies.banners.apic_gui_banner_message is not defined %}
    String   $..aaaPreLoginBanner.attributes.guiMessage   {{ apic.fabric_policies.banners.apic_gui_banner_url | default(defaults.apic.fabric_policies.banners.apic_gui_banner_url) }}
{% endif %}
    String   $..aaaPreLoginBanner.attributes.guiTextMessage   {{ apic.fabric_policies.banners.apic_gui_alias | default(defaults.apic.fabric_policies.banners.apic_gui_alias) }}
