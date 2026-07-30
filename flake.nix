{
  description = "Standalone WebHID Chromium wrapper for ASUS Gear Link";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./package.nix {};
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/gearlink";
        };
      });
      
      # This part is optional and changes global settings to add the package and udev rules
      
      nixosModules.default = { pkgs, ... }: {
        environment.systemPackages = [ self.packages.${pkgs.system}.default ];
        services.udev.extraRules = ''
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0b05", MODE="0666", TAG+="uaccess"
        '';
      };
    };
}
