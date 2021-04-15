# neovide.nix - package definition for the neovide neovim interface
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

#TODO(superwhiskers): make this work

{ rustPlatform, pkg-config, fetchFromGitHub, openssl, cmake, freetype, expat, gn
, writeScript, bash, python, ninja, ... }:
let
  # the revision, hash, and cargo hash of the neovide version to get
  revision = "e1d8d404167f5c6d5471ce1404493eb1805e94d2";
  sourcesHash = "8f435fcdf6aa462157138ee070f8aff40201bb3202ad8ff56168d0f13526d110";
  crateHash = "sha256-WXmnDwY2tf6HnvlmAwgjd1i0aE9FB7QkOF7t18AktnI=";

  # the revision and hash of the skia version to get
  skiaRevision = "6f919cdb58eee29bb84c096d250d7aedabd96325";
  skiaHash = "sha256-8qOuI6rMgPQL+H8bWuick43eeJwVl8yffGYgbFEBsc4=";

  skiaSources = fetchFromGitHub {
    owner = "rust-skia";
    repo = "skia";
    rev = skiaRevision;
    sha256 = skiaHash;
  };
in rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = sourcesHash;
  cargoHash = crateHash;
  cargoDepsName = pname;
  nativeBuildInputs = [ pkg-config cmake python ];
  buildInputs = [ openssl freetype expat ];

  preBuild = ''
    sed -i 's/debug = true/opt-level = 3\ndebug = false/' Cargo.toml
    sed -i 's/default = \["sdl2"\]/default = \["winit"\]/' Cargo.toml
    export SKIA_SOURCE_DIR="${skiaSources}"
    export SKIA_NINJA_COMMAND="${ninja}/bin/ninja"
    export SKIA_GN_COMMAND="${gn}/bin/gn"
    export SKIA_USE_SYSTEM_LIBRARIES=""
  '';

  src = fetchFromGitHub {
    owner = "Kethku";
    repo = "neovide";
    rev = revision;
    sha256 = sourcesHash;
  };
}
