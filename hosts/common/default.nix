{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    kitty
    python3
  ];
}
