{
    description = "My personal NUR repository";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        treefmt-nix = {
            url = "github:numtide/treefmt-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        ...
    } @ inputs: let
        forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
        forAllPkgs = f: forAllSystems (system: f nixpkgs.legacyPackages.${system});
        treefmtEval = forAllPkgs (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in {
        legacyPackages = forAllSystems (system:
            import ./default.nix {
                pkgs = import nixpkgs {inherit system;};
            });

        formatter = forAllPkgs (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

        packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});

        homeManagerModules = import ./modules/home-manager;

        devShells = forAllSystems (system: let
            pkgs = nixpkgs.legacyPackages.${system};
        in {
            default = pkgs.mkShell {
                buildInputs = [
                    treefmtEval.${system}.config.build.wrapper
                ];

                packages =
                    (with pkgs; [
                        alejandra
                        nvfetcher
                    ])
                    ++ (with self.packages.${system}; [
                        niriswitcher
                    ]);
            };
        });
    };
}
