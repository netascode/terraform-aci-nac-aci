resource "aci_rest_managed" "aaaPreLoginBanner" {
  dn         = "uni/userext/preloginbanner"
  class_name = "aaaPreLoginBanner"
  content = {
    guiMessage       = var.apic_gui_banner_message != "" ? var.apic_gui_banner_message : var.apic_gui_banner_url
    isGuiMessageText = var.apic_gui_banner_message != "" ? "yes" : "no"
    guiTextMessage   = var.apic_gui_alias
    message          = var.apic_cli_banner
    switchMessage    = var.switch_cli_banner
  }
}
