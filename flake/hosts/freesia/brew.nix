{
  homebrew = {
    enable = true;
    casks = [
      # Karabiner requires macOS system integration and privileged components.
      "ghostty"
      "karabiner-elements"
      # Use the official installer for Tailscale's privileged system integration.
      "tailscale-app"
      #"lm-studio"
    ];
    onActivation = {
      autoUpdate = false;
    };
  };
}
