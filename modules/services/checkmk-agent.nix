{ config, pkgs, inputs, ... }:

let
  # Instantiate the nixpkgs tree specifically from the PR branch
  cmkPkgs = import inputs.checkmk-pr { inherit (pkgs) system; };
in
{
  # 1. Import the unmerged NixOS module directly via its file path in the PR
  imports = [
    "${inputs.checkmk-pr}/nixos/modules/services/monitoring/cmk-agent.nix"
  ];

  # 2. Configure the service
  services.cmk-agent = {
    enable = true;
    
    # 3. Force the service to use the package from the PR, not your system pkgs
    package = cmkPkgs.checkmk-agent;
    
  };
  networking.firewall.allowedTCPPorts = [ 6556 ];
}
