# nix-lab


## Install Procedure
```
# install agenix to get secrets loaded
nix-channel --add https://github.com/ryantm/agenix/archive/main.tar.gz agenix
nix-channel --update

# Open up a shell to get git:
nix-shell -p git nixFlakes

# Copy agenix ssh key
nano /mnt/etc/agenixKey
chmod 600 /mnt/etc/agenixKey
ln -s /mnt/etc/agenixKey /etc/agenixKey

# once shell loaded, clone the repo to /mnt/etc/nixos
git clone https://github.com/lpuv/nix-lab /mnt/etc/nixos
cd /mnt/etc/nixos

# update flake
nix --experimental-features 'flakes nix-command' flake update

# prepare for new hardware-configuration
rm /mnt/etc/nixos/hosts/blackeye/hardware.nix

# generate new config (ignore the generated configuration.nix)
nixos-generate-config --root /mnt
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/blackeye/
rm /mnt/etc/nixos/configuration.nix

# make sure we're in the right directory
cd /mnt/etc/nixos
git add --all # add the new hardware config
git commit -m "update hardware configuration" # commit it
git push # and push to github

# needs more space to build (at least 4GB)
mount -o remount,size=4G /run/user/0

# install
nixos-install --flake .#blackeye -j 4 --no-root-passwd
```



