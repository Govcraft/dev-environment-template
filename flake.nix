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
