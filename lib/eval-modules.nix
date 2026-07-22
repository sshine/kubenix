{ pkgs }:
let
  evalModules =
    attrs@{ module ? null
    , modules ? [ module ]
    , ...
    }:
    let
      lib' = pkgs.lib.extend (
        _lib: _self: import ./upstreamables.nix { inherit (pkgs) lib; inherit pkgs; }
      );
    in
    lib'.evalModules (
      pkgs.lib.recursiveUpdate
        {
          modules = modules ++ [
            { config._module.args = { inherit pkgs; name = "default"; }; }
          ];
          specialArgs = {
            inherit pkgs;
            kubenix = {
              lib = import ./. { inherit pkgs; inherit (pkgs) lib; };
              inherit evalModules;
              modules = import ../modules;
            };
          };
        }
        (builtins.removeAttrs attrs [ "module" ])
    );
in
evalModules
