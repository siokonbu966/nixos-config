{ inputs, ... }:
{
  imports = [
    inputs.nix-secure-enclave-key.homeManagerModules.default
  ];

  # Secure Enclave-backed SSH authentication and Git SSH signing for macOS.
  # The private key never leaves the Secure Enclave; ~/.ssh/id_enclave_key is
  # only a stub/reference to the CryptoTokenKit identity.
  # https://github.com/ryoppippi/nix-secure-enclave-key
  programs.nix-secure-enclave-key = {
    enable = true;
    identities = {
      git-signing = {
        # Non-secret SSH stub/reference used for login and signing.
        keyFile = "~/.ssh/id_enclave_key";
        # Reuse this CryptoTokenKit identity if it already exists.
        label = "nix-secure-enclave-key";
        # "none" allows unattended signing without Touch ID.
        protection = "none";
        # Create the missing identity and SSH stub during activation.
        autoEnsure = true;
        github = {
          # Disabled because enabling it would add pkgs.gh (stable) to
          # home.packages and collide with the nixpkgs-unstable gh from
          # ./programs/gh. Register the key manually once instead:
          #   nix-secure-enclave-key github add --type both
          autoAdd = false;
          type = "both";
        };
      };
    };
    signingIdentity = "git-signing";
    # Sign Git commits and tags with the Secure Enclave-backed key by default.
    signByDefault = true;
  };

  programs.ssh.extraConfig = "Include ~/.ssh/hosts_config";
}
