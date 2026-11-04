{
  inputs,
  username,
  ...
}:
let
  inherit (inputs) sops-nix;
in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "surface-go-2";
    inherit username;
  };
  modules = [
    ./configuration.nix
    inputs.xremap-flake.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-hardware.nixosModules.microsoft-surface-go

    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit inputs username;
          device = "surface-go-2";
          nixvim-module = inputs.nixvim.homeModules.nixvim;
        };
        users.${username} = {
          imports = [ ../../../home/surface-go-2.nix ];
        };
      };
    }
  ];
}
