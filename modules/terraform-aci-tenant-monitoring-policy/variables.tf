variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Track List name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "snmp_trap_policies" {
  description = "List of SNMP trap policy names."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for snmp in var.snmp_trap_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", snmp))
    ])
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "syslog_policies" {
  description = "List of syslog policies. Default value `audit`: true. Default value `events`: true. Default value `faults`: true. Default value `session`: false. Default value `minimum_severity`: `warnings`."
  type = list(object({
    name             = string
    audit            = optional(bool, true)
    events           = optional(bool, true)
    faults           = optional(bool, true)
    session          = optional(bool, false)
    minimum_severity = optional(string, "warnings")
  }))
  default = []

  validation {
    condition = alltrue([
      for syslog in var.syslog_policies : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", syslog.name))
    ])
    error_message = "Allowed characters `name`: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for syslog in var.syslog_policies : contains(["emergencies", "alerts", "critical", "errors", "warnings", "notifications", "information", "debugging"], syslog.minimum_severity)
    ])
    error_message = "`minimum_severity`: Allowed values are `emergencies`, `alerts`, `critical`, `errors`, `warnings`, `notifications`, `information` or `debugging`."
  }
}

variable "fault_severity_policies" {
  description = "List of Fault Severity Assignment Policies."
  type = list(object({
    class = string
    faults = list(object({
      fault_id         = string
      initial_severity = optional(string, "inherit")
      target_severity  = optional(string, "inherit")
      description      = optional(string, "")
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for policy in var.fault_severity_policies : can(contains(["actrlMgmtRule", "authRsSvrToMonPol", "bfdRsIfPol", "bfdRsMhIfPol", "bfdRsMhNodePol", "bgpRsBestPathCtrlPol", "bgpRsBgpNodeCtxPol", "bgpInfraPeerP", "bgpPeerP", "bgpRsPeerPfxPol", "bgpRsPeerToProfile", "bgpSiteOfOriginDef", "callhomeRsDestGroup", "callhomeRsSmartdestGroup", "callhomeRsQueryGroupRel", "cloudRsAD", "cloudRsLDevToCloudSubnet", "cloudRsLDevToComputePol", "cloudRsLDevToMgmtPol", "cloudsecCapabilityLocal", "compVNic", "compVm", "dbgacRsAcExtPolToContext", "dbgacRsContext", "dbgacRsToEpg", "dbgacRsToEpgForEpgToEpg", "dbgacRsToEsgForEpgToEpg", "dbgacRsToEp", "dbgacRsToEpIp", "dbgacRsToEpForEpToEp", "dbgacRsToEpIpForEpToEp", "dbgacRsToEpForEpgToEp", "dbgacRsToEpIpForEpgToEp", "dbgacRsToAbsEpg", "dbgacRsToAbsEpgForEpgToEpg", "dbgacRsToLDevForEpToExt", "dbgacRsToLDevForEpgToIp", "dbgacRsFromEpg", "dbgacRsFromEsg", "dbgacRsFromEp", "dbgacRsFromEpIp", "dbgacRsFromEpForEpToEpg", "dbgacRsFromEpIpForEpToEpg", "dbgacRsFromAbsEpg", "dbgacRsFromLDevForExtToEp", "dbgacRsFromLDevForIpToEpg", "dhcpRsDhcpOptionPol", "dhcpRsProv", "dhcpRsLblDefToRelayP", "dnsRsDnsProfile", "dnsepgNwIssues", "dnsepgRsSvrEpg", "eigrpRsIfPol", "eigrpRsKeyChainPol", "epmAnycastIpEp", "epmRogueIpEp", "epmSviIpEp", "epmRogueMacEp", "fileRsARemoteHostToEpp", "fvAEPg", "fvBDConfigIssues", "fvRsCtxToBgpCtxAfPol", "fvRsBgpCtxPol", "fvBD", "fvRsBd", "fvRsEpTagBd", "fvRsQosRequirement", "fvRsCons", "fvRsConsIf", "fvRsProv", "fvCtxConfigIssues", "fvRsCustQosPol", "fvRsTnDenyRule", "fvRsDomAtt", "fvRsCtxToEigrpCtxAfPol", "fvRsBdToEpRet", "fvRsCtxToEpRet", "fvIp", "fvESg", "fvRsExportToFabricProfile", "fvRsBDToFhs", "fvRsTrustCtrl", "fvLocale", "fvAssocNodeDef", "fvRsBdFloodTo", "fvRsIgmpsn", "fvEpIpTag", "fvRsImportFromFabricProfile", "fvRsIntraEpg", "fvRsMldsn", "fvEpMacTag", "fvRsABDPolMonPol", "fvRsAEPgMonPol", "fvRsApMonPol", "fvRsCtxMonPol", "fvRsTenantMonPol", "fvRsBDToNdP", "fvRsNdPfxPol", "fvRsBDToNetflowMonitorPol", "fvIfConfigIssues", "fvNwIssues", "fvNwIssuesExtended", "fvRsCtxToOspfCtxPol", "fvRsOspfCtxPol", "fvOrchsInfo", "fvRsBDSubnetToOut", "fvRsBDToOut", "fvPolDeliveryStatus", "fvRsCtx", "fvRsScope", "fvRsTnlCtx", "fvRsDppPol", "fvRsAddrMgmtPool", "fvRsVmmVSwitchEnhancedLagPol", "fvRsCtxToSDWanVpn", "fvRsCtxToExtRouteTagPol", "fvRsCtxToRtctrlProfile", "fvRsBDToRelayP", "fvRsBDSubnetToProfile", "fvRsBDToProfile", "fvRsBDToProfileDef", "fvRtSummSubnet", "fvRsSubnetToRtSummPol", "fvRsSecInherited", "fvStCEp", "fvStorageIssues", "fvSubnet", "fvRsProtBy", "fvRsCloudAccount", "fvTrackMember", "fvRsOtmListMember", "fvRsIpslaMonPol", "fvExtRoutableUcastConnP", "fvRsVrfValidationPol", "fvRsEpTagCtx", "fvRsDomDefNsLocal", "fvFabricExpRtctrlP", "fvIntraVrfFabricImpRtctrlP", "fvCtxRtSummPol", "fvTnlEPg", "hsrpRsGroupPol", "hsrpGroupP", "hsrpGroupDef", "hsrpRsIfPol", "hsrpIfDef", "hsrpSecVip", "igmpRsIfPol", "igmpRsSnoopAccessGroupFilterRMap", "infraCEPg", "infraPEPg", "infraRsInfraBD", "infraRsVipAddrNs", "infraRsVlanNs", "ipRsNHTrackMember", "ipRsNexthopRouteTrack", "ipRsRouteTrack", "isakmpRsProfileToKeyring", "l2BD", "l2RsDscpRuleAtt", "l2RsDot1pRuleAtt", "l2L2AnycastEP", "l2MacCktEp", "l2RsPathDomAtt", "l2PortSecurityPolDef", "l2extRsEBd", "l2extRsL2DomAtt", "l2extInstP", "l2extDomDef", "l3Ctx", "l3CtxSubstitute", "l3RsL3dscpRuleAtt", "l3RsL3dot1pRuleAtt", "l3EncRtdIf", "l3FwdCtx", "l3IpCktEp", "l3Inst", "l3extRsArpIfPol", "l3extRsInterleakPol", "l3extRsRedistributePol", "l3extRsLIfPCustQosPol", "l3extRsEgressQosDppPol", "l3extRsIngressQosDppPol", "l3extRsL3DomAtt", "l3extRsBdProfile", "l3extConsLbl", "l3extInstP", "l3extRsLblToInstP", "l3extInstPDef", "l3extRsOutToFBRGroup", "l3extRsDynPathAtt", "l3extFloatingNode", "l3extRsDampeningPol", "l3extRsOutToMdpProvP", "l3extRsPathL3OutAtt", "l3extVirtualLIfP", "l3extLNodeP", "l3extRsLNodePMplsCustQosPol", "l3extRsNdIfPol", "l3extRsLIfPToNetflowMonitorPol", "l3extDomDef", "l3extRsEctx", "l3extRsVSwitchEnhancedLagPol", "l3extRsInstPToProfile", "l3extRsPathToRogueExceptMacGroup", "l3extRsLblToProfile", "l3extRsSubnetToProfile", "l3extRsSubnetToRtSumm", "l3extSummSubnetConfigIssues", "leakRouteIntPfx", "EPG/BD in case of APIC, cloudSubnet/CloudCidr in case of CAPIC", "mgmtInstPDef", "mgmtRsMgmtBD", "mgmtConfigAddr", "mgmtConfigNode", "mgmtInstP", "mgmtInB", "mgmtNodeDef", "mgmtRsOoBCons", "mgmtRsOoBProv", "mgmtOoB", "mgmtRsInstPCtx", "mgmtRsOoBCtx", "mldRsMldsnoopAccessGroupFilterRMap", "mplsRsIfPol", "mplsRsLabelPol", "ndRsPfxPToNdPfxPol", "ndRsRaSubnetToNdPfxPol", "netflowRsMonitorToExporter", "netflowRsMonitorToRecord", "netflowRsExporterToCtx", "netflowRsExporterToEPg", "opflexIDEpFaultInfo", "opflexIDEp", "opflexpAgentIDEpFaultInfo", "opflexpVmmIDEpFaultInfo", "orchsRsToMdev", "orchsRsToFuncProfile", "orchsRsAbsGraphRef", "orchsRsFromRPToL3Dom", "orchsRsIpPoolRef", "orchsRsIpPoolRefv2", "orchsRsSvcsEncapToSvcAlloc", "orchsRsSvcsIpToSvcAlloc", "orchsRsSvcsIpToIpPoolRef", "orchsRsLDevItem", "orchsRsAllocLDev", "orchsRsFromRPToL3OutInstP", "ospfRsIfPol", "pimCSWEntry", "pimExtP", "pimRsIfPol", "pimRsV6IfPol", "pimBSRFilterPol", "pimInterVRFEntryPol", "pimMAFilterPol", "pimStaticRPEntryPol", "pkiTP", "pkiKeyRing", "ptpEpgCfg", "ptpRtdEpgCfg", "ptpRsProfile", "ptpRsLatencyPtpMode", "qinqCktEp", "qosRsEgressDppPol", "qosRsIngressDppPol", "rtctrlRsScopeToAttrP", "rtctrlRsSetPolicyTagToInstP", "rtctrlRsCtxPToSubjP", "rtdmcRsFilterToRtMapPol", "snmpRsDestGroup", "spanVSrcDef", "spanRsVSrcGrpToFilterGrp", "spanRsDestApic", "spanRsDestEpg", "spanRsDestPathEp", "spanRsProvDestGrp", "spanRsSrcToEpg", "spanRsSrcToEpP", "spanRsSrcToPathEp", "spanRsSrcToVPort", "spanRsSrcToVPortDef", "spanRsDestToVPort", "spanRsDestToVPortDef", "spanRsProvToVDestGrp", "spanDest", "spanSrc", "spanSrcDef", "spanSrcGrp", "spanSrcGrpDef", "spanRsSrcToBDDef", "spanRsSrcToCtxDef", "spanVSrc", "sviIf", "syslogRsDestGroup", "tacacsRsDestGroup", "traceroutepRsTrEpDst", "traceroutepRsTrEpIpDst", "traceroutepRsTrExtEpIpDst", "traceroutepRsTrEpExtIpSrc", "traceroutepRsTrEpIpSrc", "traceroutepRsTrEpSrc", "vlanCktEp", "vnsVBgpDevCfg", "vnsVBgpVEncapAsc", "vnsRsLIfCtxToBD", "vnsRsCDevToChassis", "vnsCDev", "vnsCFolder", "vnsRsToCIf", "vnsCParam", "vnsCRel", "vnsConfIssue", "vnsConnectionInst", "vnsFuncConnInst", "vnsTermConnInst", "vnsCtrlrEp", "vnsDevFolder", "vnsDevParam", "vnsRsALDevToDevMgr", "vnsAbsFuncConn", "vnsVGrp", "vnsVGrpP", "vnsRsIPSLAMonitoringPol", "vnsTermNodeInst", "vnsRsChassisToMChassis", "vnsRsDevMgrToMDevMgr", "vnsLDevVip", "vnsRsL1L2RedirectHealthGroup", "vnsRsRedirectHealthGroup", "vnsGraphInst", "vnsAbsGraph", "vnsAbsFolder", "vnsGFolder", "vnsAbsFuncProf", "vnsRsDevFolderToMFolder", "vnsRsFolderInstToMFolder", "vnsAbsParam", "vnsGParam", "vnsAbsCfgRel", "vnsGRel", "vnsFolderInst", "vnsParamInst", "vnsLDevIf", "vnsLDevIfLIf", "vnsLIf", "vnsMgmtLIf", "vnsCtrlrMgmtPol", "vnsNodeInst", "vnsVOspfDevCfg", "vnsVOspfVEncapAsc", "vnsRsBackupPol", "vnsRsCfgToConn", "vnsRsCfgToVConn", "vnsRsVLIfP", "vnsRsALDevToPhysDomP", "vnsRsALDevToDomP", "vnsRsALDevToVxlanInstP", "vnsRsLdevIfToLDev", "vnsRsLIfCtxToLIf", "vnsRsLIfCtxToCustQosPol", "vnsRsLIfCtxToRemoteSvcRedirectPol", "vnsRsLDevCtxToRtrCfg", "vnsRsLIfCtxToSvcEPgPol", "vnsRsLIfCtxToSvcRedirectPol", "vnsRsLIfCtxToInstP", "vnsRsLIfCtxToOut", "vnsRsLIfDomP", "vnsRsMgmtAddr", "vnsRsAbsCopyConnection", "vnsRsAbsConnectionConns", "vnsRsVDevDomainRefContToDomainRef", "vnsRsVDevToDomainRef", "vnsRsNodeToCloudLDev", "vnsRsNodeToLDev", "vnsRsConnToLIfInst", "vnsRsConnToCtxTermInst", "vnsRsConnToFltInst", "vnsRsConnToAConnInst", "vnsRsChassisEpg", "vnsRsDevMgrEpg", "vnsRsConnToCtxTerm", "vnsRsConnToFlt", "vnsRsMConnAtt", "vnsRsMConnAttInst", "vnsRsConnToAConn", "vnsRsDefaultScopeToTerm", "vnsRsDevEpg", "vnsRsLDevCtxToLDev", "vnsRsMetaIf", "vnsRsNodeInstToLDevCtx", "vnsRsNodeInstToCloudLDev", "vnsRsMDevAtt", "vnsRsNodeToMFunc", "vnsRsNodeToAbsFuncProf", "vnsRsScopeToTerm", "vnsRsProfToCloudModeMDev", "vnsRsClusterPol", "vnsRsCDevTemplateToAddrInst", "vnsRsProfToMFunc", "vnsCfgRelInst", "vnsRsCIfAtt", "vnsRsCIfAttN", "vnsVFunc", "vnsRsLDevVipToInstPol", "vnsEPpInfo", "vnsREPpInfo", "vnsSHEPpInfo", "vnsVDevDomainRefCont", "vnsRsCDevToCtrlrP", "vnsVDev", "vnsRsInstPolToVmmConfigFile", "vsanCktEp", "vxlanCktEp", "vzAny", "vzRsAnyToCons", "vzRsAnyToProv", "vzRsIf", "vzSubj", "vzRsDenyRule", "vzRsFiltAtt", "vzRsAnyToConsIf", "vzRsGraphAtt", "vzRsInTermGraphAtt", "vzRsOutTermGraphAtt", "vzRsSubjGraphAtt", "vzRsFiltGraphAtt", "vzRsSdwanPol", "vzRsSubjFiltAtt", "vzTaboo"], policy.class))
    ])
    error_message = "Class name is not supported."
  }
  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : fault.description == null || try(can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", fault.description)), false)
      ]
    ]))
    error_message = "`faults.description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : contains(["warning", "minor", "major", "critical", "inherit", "squelched"], fault.initial_severity)
      ]
    ]))
    error_message = "`initial_severity`: Allowed values are `warning`, `minor`, `major`, `critical`, `inherit` or `squelched`."
  }

  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : contains(["warning", "minor", "major", "critical", "inherit", "squelched"], fault.target_severity)
      ]
    ]))
    error_message = "`target_severity`: Allowed values are `warning`, `minor`, `major`, `critical`, `inherit` or `squelched`."
  }
  validation {
    condition = alltrue(flatten([
      for policy in var.fault_severity_policies : [
        for fault in policy.faults : index(["warning", "minor", "major", "critical", "inherit", "squelched"], fault.target_severity) >= index(["warning", "minor", "major", "critical", "inherit", "squelched"], fault.initial_severity)
      ]
    ]))
    error_message = "`target_severity` level must be equal or higher than `initial_severity` level."
  }

}

