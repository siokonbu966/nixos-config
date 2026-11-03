{
  inputs,
  username,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    device = "surface-go-2";
    inherit username;
  };
  modules = [
    ./configuration.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-go

    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit username;
          device = "surface-go-2";
        };
        users.${username} = {
          imports = [ ../../../home/surface-go-2.nix ];
        };
      };
    }
  ];
}
