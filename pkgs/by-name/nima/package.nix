{
    lib,
    python3Packages,
    fetchFromGitHub,
}:
python3Packages.buildPythonPackage {
    pname = "nix-manipulator";
    version = "unstable-2025-12-19";

    src = fetchFromGitHub {
        owner = "Vortriz";
        repo = "nix-manipulator";
        rev = "0021d99fd8f1c4ead302dc193f3f51a4360d39f5";
        hash = "sha256-44uXrjEt/X628p77bCc0cUNZFmFrCKfheEKqrxTdtg0=";
    };

    pyproject = true;
    pythonRelaxDeps = true;

    build-system = [ python3Packages.uv-build ];

    dependencies = with python3Packages; [
        pydantic
        pygments
        tree-sitter
        tree-sitter-grammars.tree-sitter-nix
    ];

    doCheck = true;

    nativeCheckInputs = with python3Packages; [
        pytestCheckHook
    ];

    checkPhase = ''
        pytest -v -m "not nixpkgs"
    '';

    disabledTests = [
        "test_some_nixpkgs_packages"
    ];

    pythonImportsCheck = [ "nima" ];

    meta = {
        description = "Parse, manipulate, and reconstruct Nix source code with high-level abstractions";
        homepage = "https://github.com/Vortriz/nix-manipulator";
        license = lib.licenses.lgpl3Plus;
        mainProgram = "nima";
    };
}
