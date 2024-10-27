# flake.nix
{
  description = "Template for multi-environment development flake";
  
  outputs = { self }: {
    templates.default = {
      path = ./template;
      description = "Multi-environment project template with Rust and Node.js support";
      welcomeText = ''
        You have created a new multi-environment development flake!
        
        To get started:
        1. Replace the description in flake.nix
        2. Adjust the dev-environments source if needed
        3. Configure your desired development environments using the documented options
        4. Run `nix develop` to enter the development shell
      '';
    };
  };
}

# template/flake.nix
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
        # Node.js Development Environment Options
        # -------------------------------------
        # enable: boolean - Enable/disable the Node environment
        # nodeVersion: string - Version of Node.js to use (default: "20")
        # withTools: list of strings - Global tools to include (default: ["typescript" "yarn" "pnpm"])
        # extraPackages: list of packages - Additional packages to include
        # ide.type: enum - IDE preference ("vscode", "webstorm", "none") (default: "none")
        node-dev = {
          enable = true;
          nodeVersion = "20";
          # Example configuration:
          # withTools = [ "typescript" "yarn" "pnpm" ];
          # extraPackages = [ ];
          # ide.type = "none";
        };

        # Rust Development Environment Options
        # ----------------------------------
        # enable: boolean - Enable/disable the Rust environment
        # rustVersion: enum - Rust toolchain ("stable", "beta", "nightly") (default: "stable")
        # withTools: list of strings - Additional Rust tools to include (converted to cargo-*)
        # extraPackages: list of packages - Additional packages to include
        # ide.type: enum - IDE preference ("rust-rover", "vscode", "none") (default: "none")
        rust-dev = {
          enable = true;
          rustVersion = "nightly";
          # Example configuration:
          # withTools = [ ];  # Will be prefixed with cargo-
          # extraPackages = [ ];
          # ide.type = "none";
        };

        # Create the combined shell
        devShells.default = pkgs.mkShell {
          buildInputs = nixpkgs.lib.flatten (nixpkgs.lib.attrValues config.env-packages);
          shellHook = nixpkgs.lib.concatStringsSep "\n" (nixpkgs.lib.attrValues config.env-hooks);
        };
      };
    };
}

# template/.gitignore
.direnv/
result
