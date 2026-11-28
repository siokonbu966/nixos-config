{
  fetchFromGitHub,
  ollama,
}:
let
  version = "0.40.19";
  llamaCppVersion = "b12734";
in
ollama.overrideAttrs (oldAttrs: {
  inherit version;

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${version}";
    hash = "sha256-XEucojPeaE1qTlswF4S6bupHVJq7rWeaGXEXFRtvIK0=";
  };

  vendorHash = "sha256-1mzJrZUHH2ouP6I+LVojHbft7No5AumqKZVq0I/Ubsg=";

  passthru = oldAttrs.passthru // {
    inherit llamaCppVersion;
    llamaCppSrc = fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.cpp";
      tag = llamaCppVersion;
      hash = "sha256-tC6rd5SBptt2OdWzX19V/Xr7PJVOWaUnRZEYphKAeLs=";
    };
  };
})
