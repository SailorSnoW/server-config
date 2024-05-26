{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

    ];
    config = { allowUnfree = true; };
  };

  home = {
    snow = "snow";
    homeDirectory = "/home/snow";
  };

  programs.helix.enable = true;
  home.packages = with pkgs; [ fastfetch ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
