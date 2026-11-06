{
  homebrew = {
    enable = true;
    casks = [
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
