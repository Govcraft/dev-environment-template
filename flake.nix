{
  description = "Template for multi-environment development flake";

  outputs =
    { self }:
    {
      templates.default = {
        path = ./template;
        description = "Multi-environment project template with Rust, Node.js, Typst, and Golang support";
        welcomeText = ''

          You have created a new multi-environment development flake!

          To get started:
          1. Replace the description in flake.nix
          2. Adjust the dev-environments source if needed
          3. Uncomment and modify the environment variables in your .envrc file:
             - ENABLE_NODE, ENABLE_RUST, ENABLE_TYPST, ENABLE_GO to enable respective environments.
             - Example: `export ENABLE_RUST=true`
          4. Run `direnv reload` to load your configured environments.
        '';
      };
    };
}
