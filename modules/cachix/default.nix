{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix = {
    settings = {
      substituters = [
        "https://siokonbu966.cachix.org"
        "https://kopuz.cachix.org"
        "https://nix-community.cachix.org"
        "https://ghostty.cachix.org"
        "https://niri.cachix.org"
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "siokonbu966.cachix.org-1:RrvzXSLjP8pq8fgMSeI62P5l19lLinBd5cYSF017pKg="
        "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        "niri.cachix.org-1:Wv0UzwLBOfMIiQRtEPf50VzM2g0R0u1uJj59y/v68cM="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };
}
