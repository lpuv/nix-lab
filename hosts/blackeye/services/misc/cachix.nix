{ config, ... }:

{
  services.cachix-agent.enable = true;

  environment.etc = {
    "cachix-agent.token".source = config.age.cachix-token.path;
  };
}