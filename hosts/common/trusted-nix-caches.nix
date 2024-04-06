{
  # Caches in trusted-substituters can be used by unprivileged users i.e. in
  # flakes but are not enabled by default.
  nix.settings.trusted-substituters = [
    "https://nix-community.cachix.org"
    "https://leo.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "leo.cachix.org-1:PWiBVeYOI46JPauR2yAJs7+5zCSPsckCIgk7lphqL6s="
  ];
}