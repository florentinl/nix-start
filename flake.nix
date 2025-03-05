{
  description = "My nix templates for programming";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {

      templates = {
        rust = {
          path = ./templates/rust;
          description = "My template for rust projects";
        };

        go = {
          path = ./templates/go;
          description = "My template for go projects";
        };
      };

      defaultPackage =
        let
          supportedSystems = [
            "x86_64-linux"
            "aarch64-linux"
          ];

          forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
        in
        forEachSystem (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          pkgs.stdenv.mkDerivation {
            pname = "nix-start";
            version = "0.1.0";

            dontUnpack = true;

            installPhase = ''
              mkdir -p $out
              cat > $out/nix-start.plugin.zsh <<EOF
              function nix-start {
                  nix flake init --template github:florentinl/nix-start#\$1
              }

              _nix_start() {
                  local languages
                  languages=(\$(nix flake show github:florentinl/nix-start --json --quiet 2>/dev/null | ${pkgs.lib.getExe pkgs.jq} -r '.templates | keys.[]'))

                  _describe 'values' languages
              }

              compdef _nix_start nix-start
              EOF
            '';

            meta = with pkgs.lib; {
              description = "Nix start plugin";
              homepage = "https://github.com/florentinl/nix-start";
              maintainers = with maintainers; [ florentin ];
            };
          }
        );

    };
}
