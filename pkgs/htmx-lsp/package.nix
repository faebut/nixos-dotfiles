{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "htmx-lsp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ThePrimeagen";
    repo = "htmx-lsp";
    rev = "0352bf8e7546c945c0338f418b9dd0f895f55871";
    hash = "sha256-RvnqLfvFda0e5nLruOV5/Tgu4+qJzuCGHknWCNUeBl4=";
  };

  cargoHash = "sha256-Z3t9MJ56k5MYNLLyrKpT8WeWc1+N4IhdhIgxsqjefCc=";

  meta = {
    description = "Language server implementation for htmx";
    homepage = "https://github.com/ThePrimeagen/htmx-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [vinnymeller];
    mainProgram = "htmx-lsp";
  };
}
