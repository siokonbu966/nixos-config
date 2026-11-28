{
  lib,
  fetchFromGitHub,
  buildGo127Module,
}: let
  version = "2026.11.2";
in
  buildGo127Module {
    pname = "cloudflared";
    inherit version;

    src = fetchFromGitHub {
      owner = "cloudflare";
      repo = "cloudflared";
      tag = version;
      hash = "sha256-j0WVmn7XMLla31yBn3K1rmeCexSQTWrgm4xtaEBiJAw=";
    };

    vendorHash = "sha256-l5dvI3C8eQKcF6zACHIOud5KWfIRkdZNoVEPRR9Oxt0=";

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
      "-X github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=nix"
    ];

    # nixpkgs skips the test suite on Darwin as well (ICMP proxy and other
    # tests require sockets/permissions unavailable in the sandbox).
    doCheck = false;

    meta = with lib; {
      description = "Client for various Cloudflare services, including Tunnel, Access, and DNS over HTTPS";
      homepage = "https://github.com/cloudflare/cloudflared";
      license = licenses.asl20;
      mainProgram = "cloudflared";
      platforms = platforms.unix;
    };
  }
