{
  inputs,
  flake,
  pkgs,
  ...
}:
let
  user = "saumavel";
in
rec {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    flake.modules.darwin.common
    flake.modules.common.common
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = "saumavel";

  users.users.${user} = {
    isHidden = false;
    home = "/Users/${user}";
    name = "${user}";
    shell = pkgs.fish;
  };

  nix-homebrew = {
    inherit user;
    enable = true;
    mutableTaps = false;
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };
  
  homebrew = {
    enable = true;
    taps = builtins.attrNames nix-homebrew.taps;
    brews = [
      "nvm"  
      "luarocks"
      "findent"
      "node"
    ];
    # NOTE: Here you can install packages from brew
    # https://formulae.brew.sh
    casks = [
      "raycast"
      "arc"
      "bitwig-studio"
      "ferdium"
      "karabiner-elements" 
      "transnomino"
      "julia"
      "chatgpt"
      "cheatsheet"
      "plex"
      "coolterm"
      # spurning um hvort þetta sé sniðugt fyrir lokaritgerð
      # "zotero"
    ];
    # NOTE: Here you can install packages from the Mac App Store
    masApps = {
      # `nix run nixpkgs #mas -- search <app name>`
      "Keynote" = 409183694;
      "Pages" = 409201541;
    };
  };

  programs.fish.enable = true;

  home-manager.users.${user}.imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    flake.modules.home.saumavel
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Enable tailscale. We manually authenticate when we want with out or delete all of this.
  services.tailscale.enable = true;
}
