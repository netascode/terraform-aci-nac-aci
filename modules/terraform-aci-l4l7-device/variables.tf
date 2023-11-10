variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "context_aware" {
  description = "Context aware. Choices: `single-Context`, `multi-Context`."
  type        = string
  default     = "single-Context"

  validation {
    condition     = contains(["single-Context", "multi-Context"], var.context_aware)
    error_message = "Allowed values are `single-Context` or `multi-Context`."
  }
}

variable "type" {
  description = "Type. Choices: `PHYSICAL`, `VIRTUAL`, `CLOUD`."
  type        = string
  default     = "PHYSICAL"

  validation {
    condition     = contains(["PHYSICAL", "VIRTUAL", "CLOUD"], var.type)
    error_message = "Allowed values are `PHYSICAL`, `VIRTUAL` or `CLOUD`."
  }
}

variable "function" {
  description = "Function. Choices: `None`, `GoTo`, `GoThrough`, `L2`, `L1`."
  type        = string
  default     = "GoTo"

  validation {
    condition     = contains(["None", "GoTo", "GoThrough", "L2", "L1"], var.function)
    error_message = "Allowed values are `None`, `GoTo`, `GoThrough`, `L2` or `L1`."
  }
}

variable "copy_device" {
  description = "Copy device."
  type        = bool
  default     = false
}

variable "managed" {
  description = "Managed."
  type        = bool
  default     = false
}

variable "promiscuous_mode" {
  description = "Promiscuous mode."
  type        = bool
  default     = false
}

variable "service_type" {
  description = "Service type. Choices: `ADC`, `FW`, `OTHERS`, `COPY`, `NATIVELB`."
  type        = string
  default     = "OTHERS"

  validation {
    condition     = contains(["ADC", "FW", "OTHERS", "COPY", "NATIVELB"], var.service_type)
    error_message = "Allowed values are `ADC`, `FW`, `OTHERS`, `COPY` or `NATIVELB`."
  }
}

variable "trunking" {
  description = "Trunking."
  type        = bool
  default     = false
}

variable "physical_domain" {
  description = "Phyical domain name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.physical_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vmm_provider" {
  description = "Type. Choices: `CloudFoundry`, `Kubernetes`, `Microsoft`, `OpenShift`, `OpenStack`, `Redhat`, `VMware`."
  type        = string
  default     = "VMware"

  validation {
    condition     = contains(["CloudFoundry", "Kubernetes", "Microsoft", "OpenShift", "OpenStack", "Redhat", "VMware"], var.vmm_provider)
    error_message = "Allowed values are `CloudFoundry`, `Kubernetes`, `Microsoft`, `OpenShift`, `OpenStack`, `Redhat`, or `VMware`."
  }
}

variable "vmm_domain" {
  description = "Virtual Machine Manager domain name."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.vmm_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "concrete_devices" {
  description = "List of concrete devices. Allowed values `pod_id`: 1-255. Default value `pod_id`: 1. Allowed values `node_id`, `node2_id`: 1-4000. Allowed values `fex_id`: 101-199. Allowed values `module`: 1-9. Default value `module`: 1. Allowed values `port`: 1-127."
  type = list(object({
    name         = string
    alias        = optional(string, "")
    vcenter_name = optional(string, "")
    vm_name      = optional(string, "")
    interfaces = optional(list(object({
      name      = string
      alias     = optional(string, "")
      vnic_name = optional(string, "")
      pod_id    = optional(number, 1)
      node_id   = optional(number)
      node2_id  = optional(number)
      fex_id    = optional(number)
      module    = optional(number, 1)
      port      = optional(number)
      channel   = optional(string)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.concrete_devices : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.concrete_devices : c.alias == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.alias)), false)
    ])
    error_message = "`alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.concrete_devices : c.vcenter_name == null || try(can(regex("^.{0,512}$", c.vcenter_name)), false)
    ])
    error_message = "`vcenter_name`: Maximum characters: 512."
  }

  validation {
    condition = alltrue([
      for c in var.concrete_devices : c.vm_name == null || try(can(regex("^.{0,512}$", c.vm_name)), false)
    ])
    error_message = "`vm_name`: Maximum characters: 512."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,256}$", i.name))]
    ]))
    error_message = "`interfaces.name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 256."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : i.alias == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", i.alias)), false)]
    ]))
    error_message = "`interfaces.alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : i.vnic_name == null || try(can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", i.vnic_name)), false)]
    ]))
    error_message = "`interfaces.vnic_name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : (i.pod_id == null || try(i.pod_id >= 1 && i.pod_id <= 255, false))]
    ]))
    error_message = "`interfaces.pod_id`: Minimum value: 1. Maximum value: 255."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : (i.node_id == null || try(i.node_id >= 1 && i.node_id <= 4000, false))]
    ]))
    error_message = "`interfaces.node_id`: Minimum value: 1. Maximum value: 4000."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : (i.node2_id == null || try(i.node2_id >= 1 && i.node2_id <= 4000, false))]
    ]))
    error_message = "`interfaces.node2_id`: Minimum value: 1. Maximum value: 4000."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : (i.fex_id == null || try(i.fex_id >= 101 && i.fex_id <= 199, false))]
    ]))
    error_message = "`interfaces.fex_id`: Minimum value: 101. Maximum value: 199."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : (i.module == null || try(i.module >= 1 && i.module <= 9, false))]
    ]))
    error_message = "`interfaces.module`: Minimum value: 1. Maximum value: 9."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : (i.port == null || try(i.port >= 1 && i.port <= 127, false))]
    ]))
    error_message = "`interfaces.port`: Minimum value: 1. Maximum value: 127."
  }

  validation {
    condition = alltrue(flatten([
      for c in var.concrete_devices : [for i in coalesce(c.interfaces, []) : i.channel == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", i.channel)), false)]
    ]))
    error_message = "`interfaces.channel`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "logical_interfaces" {
  description = "List of logical interfaces. Allowed values `vlan`: 1-4096."
  type = list(object({
    name  = string
    alias = optional(string, "")
    vlan  = optional(number)
    concrete_interfaces = optional(list(object({
      device    = string
      interface = string
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for l in var.logical_interfaces : can(regex("^[a-zA-Z0-9_.-]{0,64}$", l.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l in var.logical_interfaces : l.alias == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", l.alias)), false)
    ])
    error_message = "`alias`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l in var.logical_interfaces : l.vlan == null || try(l.vlan >= 1 && l.vlan <= 4096, false)
    ])
    error_message = "`vlan`: Minimum value: 1. Maximum value: 4096."
  }

  validation {
    condition = alltrue(flatten([
      for l in var.logical_interfaces : [for c in coalesce(l.concrete_interfaces, []) : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.device))]
    ]))
    error_message = "`device`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue(flatten([
      for l in var.logical_interfaces : [for c in coalesce(l.concrete_interfaces, []) : can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,256}$", c.interface))]
    ]))
    error_message = "`interface`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, `}`, `~`, `?`, `&`, `+`. Maximum characters: 256."
  }
}
