output "name" {
    value = aci_rest_managed.macsecKeyChainPol.content.name
    description = "MACsec KeyChain Policy name"
}