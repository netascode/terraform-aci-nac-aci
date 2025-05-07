resource "aci_rest_managed" "aaaPreLoginBanner" {
  dn          = "uni/userext/preloginbanner"
  class_name  = "aaaPreLoginBanner"
  escape_html = var.escape_html
  content = {
    guiMessage            = var.apic_gui_banner_message != "" ? var.apic_gui_banner_message : var.apic_gui_banner_url
    isGuiMessageText      = var.apic_gui_banner_message != "" ? "yes" : "no"
    guiTextMessage        = var.apic_gui_alias
    message               = var.apic_cli_banner
    showBannerMessage     = var.apic_app_banner != "" ? "yes" : "no"
    bannerMessage         = var.apic_app_banner
    bannerMessageSeverity = var.apic_app_banner_severity
    switchMessage         = var.switch_cli_banner
  }
}
