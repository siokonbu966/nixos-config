{ pkgs, inputs }:
let
  addons = (pkgs.extend inputs.firefox-addons.overlays.default).firefox-addons;
  soundfixerXpi = pkgs.fetchurl {
    name = "soundfixer-1.4.1.xpi";
    url = "https://addons.mozilla.org/firefox/downloads/file/4205769/soundfixer-1.4.1.xpi";
    sha256 = "b229c77635e4e89ab586144aea2fcc977a2c5e51509a84ac884fa59e29ee7792";
  };
  soundfixer = pkgs.runCommand "soundfixer-1.4.1" { inherit soundfixerXpi; } ''
    extensionDir="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$extensionDir"
    cp "$soundfixerXpi" "$extensionDir/soundfixer@unrelenting.technology.xpi"
  '' // {
    addonId = "soundfixer@unrelenting.technology";
    extid = "soundfixer@unrelenting.technology";
  };
  # Fetch the signed XPIs directly: fetchFirefoxAddon rewrites their Gecko IDs.
  nnnLocalstorageXpi = pkgs.fetchurl {
    name = "nnn-localstorage-1.0.3.xpi";
    url = "https://gitea.ns-siokon.f5.si/crocus/nnn-localstorage/releases/download/v1.0.3/5e2e67e6ac7b498e9608-1.0.3.xpi";
    sha256 = "cd0584bf03270131600d940729b5457bf9a56bb7fa8ae5f053452c9b93248b63";
  };
  nnnLocalstorage = pkgs.runCommand "nnn-localstorage-1.0.3" { inherit nnnLocalstorageXpi; } ''
    mkdir -p $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
    cp $nnnLocalstorageXpi $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/nnn-localstorage@crocus.xpi
  '' // {
    addonId = "nnn-localstorage@crocus";
    extid = "nnn-localstorage@crocus";
  };
  feedExtXpi = pkgs.fetchurl {
    name = "feed-ext-0.1.5.xpi";
    url = "https://gitea.ns-siokon.f5.si/crocus/feed-ext/releases/download/v0.1.5/feed-ext-0.1.5.xpi";
    sha256 = "96bb9b8833c26b7d75e5ab82084d74e9e9949af83e5d25c83855c1517ced3321";
  };
  feedExt = pkgs.runCommand "feed-ext-0.1.5" { inherit feedExtXpi; } ''
    mkdir -p $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
    cp $feedExtXpi $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/feed-ext@crocus.xpi
  '' // {
    addonId = "feed-ext@crocus";
    extid = "feed-ext@crocus";
  };
in
{
  packages = with addons; [
    containerise
    wappalyzer
    nos2x-fox
    keepa
    linkding-extension
    refined-github
    wayback-machine
    zotero-connector
    vimium
    enhancer-for-youtube
    proton-pass
    ublock-origin
    soundfixer
    nnnLocalstorage
    feedExt
  ];
}
