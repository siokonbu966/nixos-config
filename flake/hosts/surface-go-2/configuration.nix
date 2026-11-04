{ pkgs, username, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../../modules/font.nix
    ../../../modules/fontconfig.nix
    ../../../modules/i18n.nix
    ../../../modules/sops
    ../../../modules/cachix
  ];

  networking.hostName = "surface-go-2";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;

  services = {
    dbus.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
    libinput.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = false;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  security.rtkit.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  console.keyMap = "jp106";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Asia/Tokyo";
  system.stateVersion = "26.05";
}
