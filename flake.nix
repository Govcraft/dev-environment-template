{
  description = "Multi-environment project example";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dev-environments.url = "github:Govcraft/dev-environments";
  };
  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.dev-environments.flakeModules.rust
        inputs.dev-environments.flakeModules.node
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Enable environments
        rust-dev.enable = true;
        rust-dev.rustVersion = "nightly";
        node-dev.enable = true;

        # Create the combined shell
        devShells.default = pkgs.mkShell {
          buildInputs = nixpkgs.lib.flatten (nixpkgs.lib.attrValues config.env-packages);
          shellHook = nixpkgs.lib.concatStringsSep "\n" (nixpkgs.lib.attrValues config.env-hooks);
        };
      };
    };
}
