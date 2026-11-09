{
  lib,
  fetchFromGitHub,
  installShellFiles,
  oniguruma,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leaf-markdown-viewer";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "RivoLink";
    repo = "leaf";
    tag = finalAttrs.version;
    hash = "sha256-Qj5QfuoXmh+YH3+MrPKmTKjDPAYIOrewJf3LastPJQo=";
  };

  cargoHash = "sha256-eAPW1VhBEyrQBKeFniKD1RxCdy6p6teAVwnNRBWJ+BA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ oniguruma ];

  # Tests mutate process-global state, so parallel execution is unsafe.
  dontUseCargoParallelTests = true;

  # This local-file preview test fails in Nix's extracted source sandbox.
  cargoTestFlags = [
    "--"
    "--skip=tests::render_preview::preview_mode_only_before_shows_content"
  ];

  # The self-updater cannot replace binaries in the read-only Nix store.
  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "use update::run_update;" "" \
      --replace-fail "        run_update()?;" '        bail!("leaf was installed through Nix; update it with your Nix configuration instead of `leaf --update`");'
  '';

  postInstall = ''
    installShellCompletion --cmd leaf \
      --bash completions/leaf.bash \
      --fish completions/leaf.fish \
      --nushell completions/leaf.nu \
      --zsh completions/leaf.zsh

    install -Dm644 completions/leaf.ps1 $out/share/powershell/leaf.Completion.ps1
  '';

  meta = {
    description = "Terminal Markdown previewer with a GUI-like experience";
    homepage = "https://leaf.rivolink.mg";
    license = lib.licenses.mit;
    mainProgram = "leaf";
    platforms = lib.platforms.unix;
  };
})
