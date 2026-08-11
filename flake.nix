{
  description = "Nativum — a passive zero-JavaScript native web UI system built on HTML and CSS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "nativum";
          version = "0.1.0";

          src = ./.;

          buildPhase = ''
            runHook preBuild
            ./tools/build.sh
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            install -D -m 0644 dist/nativum.css $out/nativum.css
            install -D -m 0644 dist/SHA256SUMS $out/SHA256SUMS
            install -D -m 0644 LICENSE $out/LICENSE
            install -D -m 0644 docs/security.md $out/SECURITY.md
            runHook postInstall
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python3
            coreutils
            # Playwright MCP — Web画面の動作検証 (開発ツールでありCoreの実行時依存ではない)
            playwright-mcp
          ];

          shellHook = ''
            echo "nativum dev shell — build: tools/build.sh / verify: tools/verify.sh / serve: tools/serve.sh / browser: playwright-mcp"
          '';
        };
      });
}
