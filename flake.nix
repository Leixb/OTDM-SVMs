{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = with self.overlays; [ ampl gensvmdat ];
          };
        in
        {
          checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              shfmt.enable = true;
              shellcheck.enable = true;
            };
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              ampl
              gensvmdat
              texlab
              texlive.combined.scheme-full
              python3.pkgs.pygments
              which
              nixpkgs-fmt
            ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };

          packages =
            let
              zip-derivation = drv: pkgs.runCommand "${drv.name}-zip"
                {
                  nativeBuildInputs = [ pkgs.zip ];
                } ''
                mkdir -p $out
                cd ${drv}
                zip -Jr $out/${drv.name}.zip .
              '';

              document = pkgs.runCommand "lab2-svms.pdf"
                {
                  nativeBuildInputs = with pkgs; [
                    texlive.combined.scheme-full
                    python3.pkgs.pygments
                    which
                  ];
                  src = nix-filter.lib.filter {
                    root = ./.;
                    include = [
                      "document"
                      "ampl"
                      "benchmarks"
                      "outputs"
                    ];
                  };
                  TEXMFHOME = "./cache";
                  TEXMFVAR = "./cache/var";
                } ''
                cp -r "$src" build
                chmod -R +w build
                cd build/document
                latexmk
                mkdir -p $out
                cp *.pdf $out/$name
              '';

              data = pkgs.runCommand "data"
                {
                  src = nix-filter.lib.filter {
                    root = ./.;
                    exclude = [
                      ".gitignore"
                      ".envrc"
                      "document"
                      "flake.nix"
                      "flake.lock"
                      "nix"
                    ];
                  };
                } ''
                cp -r "$src" $out
              '';

            in
            {
              inherit (pkgs) ampl gensvmdat;
              inherit document data;

              data-zip = zip-derivation data;

              default = self.packages.${system}.delivery;
              delivery = pkgs.symlinkJoin {
                name = "ampl-delivery";
                paths = with self.packages.${system}; [
                  document
                  data-zip
                ];
              };

            };
        }
      ) // {
      overlays.ampl = final: prev: {
        ampl = prev.callPackage ./nix/ampl.nix { };
      };
      overlays.gensvmdat = final: prev: {
        gensvmdat = prev.callPackage ./nix/gensvmdat.nix { };
      };
    };
}
