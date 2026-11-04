{ pkgs, ...}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    
    initContent = ''
      source ~/.p10k.zsh
      eval "$(git wt --init zsh)"
      alias nixc='cd ~/nixos-config/'
      alias initpart='nix flake init -t github:hercules-ci/flake-parts'
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      # g: 引数なし→ghq+fzfでリポジトリ選択してcd、引数あり→gitに転送
      function __ghq_pick() {
        local ghq_root selected
        ghq_root="$(ghq root)"

        selected="$(
          ghq list --full-path \
            | sed "s#^''${ghq_root}/##" \
            | fzf --height 40% --reverse \
                --preview "eza --tree --level=2 --git-ignore --color=always --icons \"''${ghq_root}/{}\" 2>/dev/null || ls \"''${ghq_root}/{}\""
        )"

        [[ -n "$selected" ]] && printf '%s\n' "''${ghq_root}/''${selected}"
      }

      function g() {
        if [[ $# -eq 0 ]]; then
          local selected
          selected="$(__ghq_pick)" || return
          [[ -n "$selected" ]] && cd -- "$selected"
        else
          git "$@"
        fi
      }

      # worktree: git worktreeをfzfで選択して移動
      function worktree() {
        local selected
        selected="$(
          git wt --json \
            | jq -r '.[] | [
                (if .current then "*" else " " end),
                .branch,
                .path,
                .head
              ] | @tsv' \
            | fzf --height 40% --reverse \
                --with-nth=1,2 \
                --delimiter=$'\t' \
                --preview 'git -C {3} log --oneline --graph -20' \
            | cut -f3
        )"

        [[ -n "$selected" ]] && cd -- "$selected"
      }

      inknb() {
        if [[ -z "$1" ]]; then
          echo "Usage: inknb <notebook:id>"
          return 1
        fi

        note_path=$(nb show --path "$1") || {
          echo "Error: Could not find item '$1'"
          return 1
        }
        ink "$note_path"
      }
    '';
  };

  home.file.".p10k.zsh".source = ./p10k.zsh;

  home.packages = with pkgs; [ jq eza ];
}
