# Home Manager Configuration Structure and Style

This directory separates host-specific Home Manager profiles from package- and tool-specific settings. Follow the existing layout when adding or changing configuration.

## File responsibilities

- `<device>.nix` (for example, `saffron.nix`) is a host profile. It selects modules through `imports` and holds host-level values such as the username, home directory, and `stateVersion`.
- `programs/<package>/default.nix` is a Home Manager module for a package or feature. Keep the package, its `programs.*` configuration, and related `services.*`, `xdg.*`, and other settings together.
- `tools/` contains tool modules managed separately from `programs/`. Host profiles import them in the same way.
- For larger configurations, or when a feature has several related files, keep helper `.nix` files in that feature's directory and reference them from `default.nix` with `imports` or `import`. Examples include `firefox/`, `nixvim/`, and `ghostty/`.

## Host profiles and platforms

Host profiles are Nix modules, usually with an argument set followed by one attribute set. Their `imports` list is the main place to select the software enabled for that host. `saffron.nix` groups imports with comments such as `cli`, `gui`, `utils`, `wm`, and `vm`.

| Profile | Platform / role | Home directory | Notes |
| --- | --- | --- | --- |
| `saffron.nix` | NixOS, x86_64 Linux | `/home/${username}` | Desktop profile with GUI, window-manager, audio, and saffron-specific modules. |
| `surface.nix` | NixOS, x86_64 Linux | `/home/${username}` | Surface-specific profile and modules. |
| `wsl.nix` | NixOS on WSL | `/home/${username}` | Primarily CLI-focused. Check the host entrypoint for the target system architecture. |
| `freesia.nix` | nix-darwin, aarch64 Darwin (Apple Silicon) | `/Users/${username}` | macOS profile. Some GUI apps use `brew-nix` packages. |
| `zephyr.nix` | nix-darwin, aarch64 Darwin (Apple Silicon) | `/Users/${username}` | macOS profile with a `zephyr`-specific module. |
| `first-linux` | NixOS bootstrap profile | Uses `saffron.nix` | The target architecture is determined by the bootstrap host entrypoint. |
| `first-darwin` | nix-darwin bootstrap profile | Uses `freesia.nix` | The target architecture is determined by the bootstrap host entrypoint. |

The `saffron-ci` configuration uses the saffron Home Manager profile with CI-specific conditions. The `first-linux` and `first-darwin` entrypoints reuse the saffron and freesia profiles respectively; they are bootstrap system configurations, not separate files under `home/`.

Example profile structure:

```nix
{ username, ... }:
{
  imports = [
    # cli
    ./programs/git
    ./programs/zsh

    # gui
    ./programs/firefox

    # utils
    ./programs/dotfiles

    # tools
    ./tools/default-app
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
}
```

- Import feature directories (for example, `./programs/<package>`); Nix resolves a directory import to its `default.nix`.
- Group imports by purpose, using only the categories relevant to that host. Add host-specific modules in a clearly named group where useful.
- Keep package configuration in its module; use the host profile to choose which modules are enabled. Existing disabled imports are commented out as `#./programs/...`.
- Use `lib.optionals` or a similar conditional when a module should only be imported under certain conditions.
- Set `home.username`, `home.homeDirectory`, and `home.stateVersion` to the appropriate host values. Linux profiles use `/home/${username}` and macOS profiles use `/Users/${username}`.
- `programs.home-manager.enable = true;` is set in `saffron.nix`; check the relevant host profile for other hosts.

### Linux and Darwin differences

- Prefer platform-aware package selection inside a package module when a feature is shared across Linux and macOS. Existing modules use `pkgs.stdenv.hostPlatform.isDarwin` with `lib.mkIf` or `lib.optional`; for example, `obs` selects a brew cask on Darwin and configures `programs.obs-studio` on Linux.
- On macOS, GUI apps supplied by `brew-nix` use `pkgs.brewCasks.<name>`. Apps that require privileged system integration belong in nix-darwin's `homebrew.casks` list rather than a Home Manager package module.
- Do not manage macOS Firefox profile files through Home Manager: the standard profile directory is TCC-protected. The Firefox module handles Darwin separately.
- Select packages based on the target platform (`pkgs` and `pkgs.stdenv.hostPlatform`) instead of assuming that every Home Manager profile runs on Linux. Check host entrypoints when the architecture is not stated in the profile itself.

## Package and feature modules

The standard location is `home/programs/<package>/default.nix`. Accept only the module arguments needed and return a Home Manager module attribute set.

```nix
{ pkgs, ... }:
{
  home.packages = [ pkgs.example ];
}
```

When Home Manager provides an option for the program, use it alongside package installation as appropriate:

```nix
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
```

Existing modules commonly group the following settings by feature:

- `home.packages`: CLI and GUI packages
- `programs.<name>`: program options provided by Home Manager
- `services.<name>` and `wayland.windowManager.<name>`: services and window managers
- `xdg.configFile`, `home.file`, `home.sessionVariables`, and `xdg.desktopEntries`: configuration files, environment variables, and desktop entries

Use only the module arguments that are needed. Existing modules use arguments such as `pkgs`, `lib`, `config`, `inputs`, `username`, and `device`. For host- or OS-dependent behavior, make the condition explicit with values such as `pkgs.stdenv.hostPlatform.isDarwin`, `device`, `lib.mkIf`, `lib.optional`, or `lib.optionals`. Some existing modules default `device` to `"saffron"` (for example, `{ device ? "saffron", ... }:`).

Use priority functions such as `lib.mkDefault` when a module should provide a default that other configuration can override. For example, `obsidian` applies `lib.mkDefault` to part of its Nixvim configuration.

## Configuration files and splitting larger modules

- Describe generated configuration using Nix attribute sets, strings, or the format helpers used by neighboring modules. Existing patterns include `pkgs.formats.toml`, `pkgs.formats.json`, and `programs.*.settings`.
- To deploy an existing dotfile or configuration directory, use `xdg.configFile` or `home.file` with `source`. Repository-relative paths are relative to the module file.
- Keep split configuration files in the feature's subdirectory. Firefox imports or reads helpers such as `containers.nix`, `extensions.nix`, and `search.nix`; Nixvim collects modules under `config/` through `programs.nixvim.imports`.
- Handle OS-specific package or configuration choices in the package module where practical. For example, `ghostty` chooses its package based on the host platform.

## When making changes

1. Add new Home Manager-managed software under `home/programs/<package>/default.nix` (or under `home/tools/` for tools).
2. Add `./programs/<package>` or `./tools/<tool>` to each host profile that should use it.
3. Keep `home.packages`, `programs.*`, and related configuration together in the feature module. Leave host selection and genuinely host-specific settings in the profile.
4. Follow the surrounding indentation, attribute grouping, and Nix string/list style. Use comments to explain non-obvious reasons or host-specific caveats.
5. Evaluate the relevant system configuration after Nix changes. CI reference evaluation targets are `.#nixosConfigurations.saffron-ci.config.system.build.toplevel.drvPath` and `.#darwinConfigurations.freesia.config.system.build.toplevel.drvPath`.

This guide reflects the current `saffron.nix` profile and the modules under `home/programs/`. Consult the relevant Home Manager module or package documentation for the exact options supported by each program.
