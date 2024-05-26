{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    plugins = [ ];
    shellAliases = { ls = "ls --color=auto"; };
    history = {
      expireDuplicatesFirst = true;
      save = 512;
    };
  };
}
