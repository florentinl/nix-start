function nix-start {
    nix flake init --template github:florentinl/nix-start#$1
}

_nix_start() {
    local languages
    languages=($(nix flake show github:florentinl/nix-start --json | jq -r '.templates | keys.[]'))

    _describe 'values' languages
}

compdef _nix_start nix-start
