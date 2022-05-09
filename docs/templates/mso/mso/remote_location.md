# Remote Location

Location in GUI:
`Operations` » `Remote Locations`

!!! warning

    SSH key should be generated in PEM format:

        ssh-keygen -t rsa -m PEM

    The ssh_key input is a single line string with "\n" for each new line".
    
        -----BEGIN RSA PRIVATE KEY-----
        Proc-Type: 4,ENCRYPTED
        DEK-Info: AES-128-CBC,234BAAD9A19386249918BB2C07874AD1
        
        CUqdVbGGnu9XRtHfdVzZ0SvLGaEgkDTvBk5kNnkkSHXjlJTdpjzccD7K8sWKfSR+
        ***[ OMITTED OUTPUT ]*** 
        QvCyfRIP8jW8EDic5m7VXWEE9vVxyLhTtH0BOgZNTfzCYhdhHeLXKehS9qqhmoy2
        -----END RSA PRIVATE KEY-----
    
    The above snippet will need to be translated into a string format like below.

    -----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-128-CBC,234BAAD9A19386249918BB2C07874AD1\n\nCUqdVbGGnu9XRtHfdVzZ0SvLGaEgkDTvBk5kNnkkSHXjlJTdpjzccD7K8sWKfSR+\n***[ OMITTED OUTPUT ]***\nQvCyfRIP8jW8EDic5m7VXWEE9vVxyLhTtH0BOgZNTfzCYhdhHeLXKehS9qqhmoy2\n-----END RSA PRIVATE KEY-----\n
    
    This can be done automatically by leveraging ansible lookup functionality in SSH example below.

{{ aac_doc }}
### Examples

Password example:

```yaml
mso:
  remote_locations:
    - name: APIC1
      description: APIC1 SCP
      hostname_ip: 10.10.10.10
      port: 22
      protocol: scp
      path: /
      authentication: password
      username: admin
      password: !vault |
        $ANSIBLE_VAULT;1.1;AES256
        32396265303231363335666463353163316465383161636362333432303931393663363764383032
        3035303964653162623937393935323766616664663139390a643364643434623533366361633231
        31663434333430666631613064306464623135646561626531616538353665393136366434616239
        3638643832666631620a646537616130303661323462666366626261383231323033643931626635
        3231
```

SSH example:

```yaml
mso:
  remote_locations:
    - name: APIC1
      description: APIC1 SCP
      hostname_ip: 10.10.10.10
      port: 22
      protocol: scp
      path: /
      authentication: password
      username: admin
      ssh_key: "-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-128-CBC,234BAAD9A19386249918BB2C07874AD1\n\nCUqdVbGGnu9XRtHfdVzZ0SvLGaEgkDTvBk5kNnkkSHXjlJTdpjzccD7K8sWKfSR+\n ***[ OMITTED OUTPUT ]*** \nQvCyfRIP8jW8EDic5m7VXWEE9vVxyLhTtH0BOgZNTfzCYhdhHeLXKehS9qqhmoy2\n-----END RSA PRIVATE KEY-----\n"
      passphrase: passphrase
```
