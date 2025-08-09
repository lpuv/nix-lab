# personal homelab config, using colmena!

## Install procedure
- Create [template](https://www.mariosangiorgio.com/post/nixos-lxc/) on Proxmox
- Add to FreeIPA DNS
- Populate host key in `secrets.nix` 
```bash
colmena apply --on <host>
  
```
