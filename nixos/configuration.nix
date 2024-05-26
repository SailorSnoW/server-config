{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # Some host providers will need this one.
    # ./networking.nix # generated at runtime by nixos-infect

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.oci-containers = { backend = "docker"; };

  environment.systemPackages = with pkgs; [ git jq curl ];

  networking.domain = "";
  networking.hostName = "snow-server"; # TODO

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  time = {
    timeZone = "Europe/Paris";
    hardwareClockInLocalTime = true;
  };

  security.sudo.enable = true;

  users.users = {
    snow = {
      initialPassword = "snowpassisgreat";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO
      ];
      extraGroups = [ "wheel" ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
