{ config, device, lib, pkgs, ... }:
let
  user = if device == "zephyr" then {
    name = "hoguhogu966";
    email = "302459077+hoguhogu966@users.noreply.github.com";
  } else {
    name = "Siokonbu966";
    email = "167207736+Siokonbu966@users.noreply.github.com";
  };
in
{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".direnv"
      ".venv"
      "__pycache__/"
      "*.py[cod]"
      ".pytest_cache/"
      ".mypy_cache/"
      ".ipynb_checkpoints/"
    ];
    settings = {
      inherit user;
      init.defaultBranch = "main";
      ghq.root = "~/src";
      pull.rebase = "true";
      core.editor = "vi";
      wt.basedir = ".git/wt";
      alias = {
        clone = "clone --recursive";
        ahead = "log --oneline origin/main..HEAD";
        fetch-head = "!git symbolic-ref --short refs/remotes/origin/HEAD";
        default-branch = "!git fetch-head | sed 's!.*/!!'";
        home = "!git switch $(git default-branch)";
        logg = ''log --graph --abbrev-commit --pretty=format:"%C(yellow)%h%C(reset) - %C(cyan)%ad%C(reset) %C(green)(%ar)%C(reset)%C(auto)%d%C(reset)%n          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%n"'';
        swf = "!f() { branch=$(git branch -a --format='%(refname:short)' | grep -v '/HEAD$' | fzf) || return; branch=$(printf '%s' \"$branch\" | sed 's#^remotes/[^/]*/##'); git switch \"$branch\"; }; f";
        sms = "submodule foreach \"git status\"";
        root = "rev-parse --show-toplevel";
        uncommit = "reset HEAD^";
        recommit = "commit -c ORIG_HEAD";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };
      commit.verbose = true;
      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };
      fetch = {
        all = true;
        writeCommitGraph = true;
        prune = true;
        pruneTags = true;
      };
      column.ui = "auto";
      branch.sort = "-committerdate";
      help.autocorrect = "prompt";
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
    signing = {
      format = "ssh";
    } // lib.optionalAttrs (device != "zephyr") {
      key = "~/.ssh/github.pub";
    };
    includes = [
      {
        condition = "gitdir:${config.programs.git.settings.ghq.root}/gitea/";
        contents.user = {
          name = "crocus";
          email = "1+crocus@noreply.gitea.ns-siokon.f5.si";
        };
      }
    ];
  };

  home.packages = with pkgs; [
    git-wt
    git-lfs
    git-filter-repo
    lazygit
  ];
}
