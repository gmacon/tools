{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forSystems = systems: f:
        nixpkgs.lib.genAttrs systems (system:
          f system nixpkgs.legacyPackages.${system});
      forAllSystems = forSystems supportedSystems;
    in
    {
      packages = forAllSystems (system: pkgs: {
        default = pkgs.python3Packages.callPackage ./default.nix { };
      });
    };
}
