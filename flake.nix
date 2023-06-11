{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }@inputs:
  let
    ghcVersion = "ghc92";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    dependencies = with pkgs; [ meson ninja gobject-introspection gettext glib python3 pkg-config gtk4 desktop-file-utils appstream python311Packages.pygobject3 ];
  in
  {
    packages.${system}.default = pkgs;

    devShells.${system}.default = dependencies.shellFor {
      packages = p: [ dependencies ];
      nativeBuildInputs = tools ++ [ pkgs.readline ];
    };
  };
}
