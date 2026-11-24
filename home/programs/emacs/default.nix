{ pkgs, lib, ... }:
let
  # Wayland (niri) では pgtk ビルドが必須。darwin では通常の emacs (NS)。
  emacsPkg =
    if pkgs.stdenv.isDarwin then
      pkgs.emacs
    else
      (pkgs.emacs-pgtk or pkgs.emacs);
  emacsPackage = emacsPkg.override {
    withNativeCompilation = false;
  };

  tex = pkgs.texliveSmall.withPackages (ps: with ps; [
    latexmk
    jlreq
    luatexja
    geometry
    textpos
    unicode-math
    lualatex-math
    amsmath
    amsfonts
    fontspec
    haranoaji
  ]);

  # Terminal invocations use -nw; desktop launchers without a TTY stay graphical.
  emacsWrapper = pkgs.writeShellScriptBin "emacs" ''
    if [ -t 0 ] && [ -t 1 ]; then
      exec ${emacsPackage}/bin/emacs -nw "$@"
    else
      exec ${emacsPackage}/bin/emacs "$@"
    fi
  '';
in
{
  home.packages = [
    emacsPackage
    (lib.hiPrio emacsWrapper)
    pkgs.prettier

    tex
    # AUCTeX: provides `tex'/'latex' features required by init/50-latex.el
    pkgs.auctex
    pkgs.biz-ud-gothic
  ]
  # 端末 (`emacs -nw') 用のシステム連携ツール。GUI 用は内蔵 selection で動く。
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.xsel
  ];

  home.sessionVariables = {
    OSFONTDIR = "${pkgs.biz-ud-gothic}/share/fonts/truetype";
  };
  home.file = {
    ".emacs.d/init.el".source = ../../../configs/emacs/init.el;
    ".emacs.d/init/10-clipboard.el".source = ../../../configs/emacs/10-clipboard.el;
    ".emacs.d/init/40-markdown-mode.el".source = ../../../configs/emacs/40-markdown-mode.el;
    ".emacs.d/init/50-latex.el".source = ../../../configs/emacs/50-latex.el;
  };
}
