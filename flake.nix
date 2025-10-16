{
  description = "nodejs-safe";

  inputs = {
    nixpkgs.url = "github:miuirussia/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    nodePackages = import ./nix { inherit pkgs; };

    nodejs-safe = pkgs.runCommand "nodejs-safe" { } ''
      mkdir -p $out/bin
      for item in 'corepack' 'npm' 'npx' 'pnpm' 'pnpx' 'yarn' 'yarnpkg';
      do
        ln -s "${nodePackages.corepack}/lib/node_modules/corepack/dist/$item.js" "$out/bin/$item"
      done
      ln -s ${pkgs.nodejs-slim}/bin/node $out/bin/node
    '';
  in {
    packages.x86_64-linux.nodejs-safe = pkgs.writeShellScriptBin "nodejs-safe" ''
      set -euo pipefail

      if [ $# -eq 0 ]; then
        echo "Usage: $0 <tool> [arguments...]"
        echo "Available tools: node, corepack, npm, npx, pnpm, pnpx, yarn, yarnpkg"
        exit 1
      fi

      PATH=${pkgs.lib.strings.makeBinPath [nodejs-safe]}:PATH

      TOOL="$1"
      shift  # Remove the first argument, leaving only the tool arguments

      case "$TOOL" in
        node|corepack|npm|npx|pnpm|pnpx|yarn|yarnpkg)
          exec "$TOOL" "$@"
          ;;
        *)
          echo "Error: Unknown tool '$TOOL'"
          echo "Available tools: node, corepack, npm, npx, pnpm, pnpx, yarn, yarnpkg"
          exit 1
          ;;
      esac
    '';

    packages.x86_64-linux.default = self.packages.x86_64-linux.nodejs-safe;

  };
}
