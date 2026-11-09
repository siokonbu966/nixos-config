{ inputs, lib, pkgs, ... }:
let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  gitea-cli = unstablePkgs.buildGo127Module {
    pname = "gitea-cli";
    version = "1.1.0";

    src = unstablePkgs.fetchFromGitea {
      domain = "gitea.com";
      owner = "gitea";
      repo = "cli";
      rev = "v1.1.0";
      hash = "sha256-VXGLBbX6Y8Gkli2CLLHv0qeZuReAmJXh2ntGHoFQsU8=";
    };

    subPackages = [ "cmd/gt" ];
    vendorHash = "sha256-PSjD8n0gn/9LskgQWqQPniS/sBbJf6mV04/AZHRa8l4=";
    ldflags = [ "-X=gitea.dev/cli/internal/version.Version=1.1.0" ];

    meta = {
      description = "Official command-line client for Gitea";
      homepage = "https://gitea.com/gitea/cli";
      mainProgram = "gt";
      license = lib.licenses.mit;
    };
  };
in
{
  home.packages = [ gitea-cli ];

  programs.zsh.initContent = lib.mkAfter ''
    eval "$(${gitea-cli}/bin/gt completion zsh)"
  '';
}
