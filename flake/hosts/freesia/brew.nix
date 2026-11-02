{
  homebrew = {
    enable = true;
    casks = [
      # Firefox keeps using the standard macOS profile directory.
      "firefox"
      # Karabiner requires macOS system integration and privileged components.
      "ghostty"
      "karabiner-elements"
      #"lm-studio"
    ];
    onActivation = {
      autoUpdate = false;
    };
  };
}
