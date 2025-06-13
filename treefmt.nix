{
    # Used to find the project root
    projectRootFile = "flake.nix";

    programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        toml-sort.enable = true;
        keep-sorted.enable = true;
    };

    settings = {
        global.excludes = [
            # Exclude all files generated by nvfetcher
            "**sources/*"
        ];

        formatter = {
            # nix
            alejandra = {
                options = ["--threads" "16"];
                priority = 3;
            };

            deadnix.priority = 1;

            statix.priority = 2;
        };
    };
}
