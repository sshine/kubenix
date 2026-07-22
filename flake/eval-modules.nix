{ inputs, config, ... }:
{
  # evalModules is implemented in lib/eval-modules.nix as a plain function of
  # `pkgs`, so it can be imported without the flake (e.g. by nixpkgs). Here we
  # only wrap it per-system.
  flake.evalModules = inputs.nixpkgs.lib.genAttrs config.systems (
    system: import ../lib/eval-modules.nix { pkgs = inputs.nixpkgs.legacyPackages.${system}; }
  );

  # Share this system's evalModules with the other perSystem modules.
  perSystem =
    { pkgs, ... }:
    {
      _module.args.evalModules = import ../lib/eval-modules.nix { inherit pkgs; };
    };
}
