# System Config

Location in GUI:
`Infrastructure` » `System Configuration`

{{ aac_doc }}

### Examples

```yaml
ndo:
  system_config:
    lockout_time: 5
    allowed_consecutive_attempts: 5
    banner:
      alias: Banner New
      type: informational
      message: Message New
      state: active
```
