{ config, ... }:

{
  services.cachix-agent.enable = true;

  environment.etc = {
    "cachix-agent.token".source = config.age.secrets.cachix-token.path;
  };
}