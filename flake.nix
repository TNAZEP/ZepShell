{
  description = "ZepShell - A QuickShell based shell for Hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, quickshell }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.writeShellScriptBin "zepshell" ''
        ${quickshell.packages.${system}.quickshell}/bin/quickshell ${./src}
      '';

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          quickshell.packages.${system}.quickshell
          pkgs.qt6.qtdeclarative
          pkgs.qt6.qtsvg
        ];
      };
    };
}
