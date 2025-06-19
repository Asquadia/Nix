# Edit this configuration file to define what should be installed on
# your system.  help is availible in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual ('nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos_service";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # setup keyboard
  console.keyMap = "fr";
  services.xserver.xkb.layout = "fr";
  services.xserver.xkb.variant = "azerty";

  # List packages installed in system profile.
  # You can use Https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    nano
    wget
    git
    uidmap # this package is required to install rootless docker, to be more specific we need newuidmap and newgidmap commands which are in the uidmap package.
  ];

  # Install docker in rootless mode
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Define a User account. Dont forget to set the password with 'passwd' later.
  users.users.ascadia = {
    isNormalUser = true;
    description = "default user";
    extraGroups = [ "wheel" "docker" ];
    # These ranges are required for rootless Docker to work.
    subUidRanges = [ { startUid = 100000; count = 65536; } ];
    subGidRanges = [ { startGid = 100000; count = 65536; } ];
  };

  # Configure SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "25.05";
}
