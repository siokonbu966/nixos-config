# home/programs/nixvim

このディレクトリは Home Manager の `programs.nixvim` 設定をモジュール分割して管理しています。

## ディレクトリ構造

```text
home/programs/nixvim/
├── default.nix                    # nixvim-module を読み込み、config.nix を適用
├── config.nix                     # 基本設定と plugins ディレクトリを集約
├── config/
│   ├── base.nix                   # 基本設定（globals など）
│   ├── options.nix                # vim オプション
│   ├── keymaps.nix                # キーマップ
│   ├── lsp.nix                    # LSP 設定
│   ├── diagnostic.nix             # 診断表示設定
│   └── plugins/
│       ├── default.nix            # プラグインカテゴリの集約
│       ├── editor/                # 編集支援系プラグイン
│       ├── ui/                    # UI 系プラグイン
│       └── other/                 # その他ユーティリティ系プラグイン
├── flake.nix                      # nixvim 単体評価用 flake
└── flake.lock
```

## 導入しているプラグイン

`config/plugins/default.nix` から読み込まれているモジュールを基準に、現在有効化されているプラグインを整理しています。

### editor

- bufferline
- nvim-cmp（`cmp`, `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-vsnip`）
- vim-vsnip（`extraPlugins`）
- diffview
- nvim-autopairs
- treesitter
- indent-blankline
- rainbow-delimiters

### ui

- nvim-web-devicons（`extraPlugins`）
- kanagawa（colorscheme）
- lualine
- mini
- mini-icons
- oil
- render-markdown
- telescope
- tiny-inline-diagnostic

### other

- gitsigns
- lazygit
- neocord
- smear-cursor
- which-key

## 補足

- `config/plugins/other/obsidian.nix` は存在しますが、`config/plugins/other/default.nix` で import されていないため現在は未導入です。
