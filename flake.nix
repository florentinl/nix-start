{
  description = "My nix templates for programming";

  outputs = _: {

    templates = {
      rust = {
        path = ./templates/rust;
        description = "My template for rust projects";
      };
    };

  };
}
