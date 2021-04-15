# flake.nix - nix flake definition
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

{
  description =
    "a cute and fluffy software repository for the nix package manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; # we use the unstable version
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      packages = [ ./packages/neovide.nix ];
      fileNameToAttr = system: name:
      let pkgs = nixpkgs.legacyPackages."${system}";
          package = pkgs.callPackage name { };
        in {
          name = package.pname;
          value = package;
        };
    in flake-utils.lib.eachDefaultSystem (system: {
      packages =
        builtins.listToAttrs (builtins.map (fileNameToAttr system) packages);
    });
}
