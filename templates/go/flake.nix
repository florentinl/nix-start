{
  description = "Go Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShell = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            go
            gopls
          ];
        }
      );

      defaultPackage = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.buildGoPackage {
          pname = "nix-start";
          version = "0.0.0";

          src = ./.;
          vendorHash = pkgs.lib.fakeSha256;
        }
      );
    };

}
