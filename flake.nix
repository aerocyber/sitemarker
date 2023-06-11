{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.mach-nix.url = "github:DavHau/mach-nix?ref=3.3.0";
  outputs = { self, nixpkgs, mach-nix }@inputs:
  let
    pythonVersion = "python311";
    system = "x86_64-linux";
    mach-nix-wrapper = import mach-nix { inherit pkgs pythonVersion; };
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [ meson python311Packages.pygobject3 ninja gobject-introspection gettext glib gtk4 desktop-file-utils appstream ];

    };
  };
}
