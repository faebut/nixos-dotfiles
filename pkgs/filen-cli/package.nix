{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  versionCheckHook,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:
let
  pname = "filen-cli";
  version = "0.0.39";

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-cli";
    tag = "v${version}";
    hash = "sha256-+J3gFn+aLQte8h3CUkQjC0TODYTPaWwksjNsMbCuqfo=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-ikNJJ4zpAxM9AomOESObpfCL8X2R3+sc5k0FW1MWSmg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/node_modules .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun build \
      --compile \
      --target=bun \
      --minify \
      --sourcemap src/index.ts \
      --outfile dist/filen \
      --define IS_RUNNING_AS_BINARY=true \
      --define "VERSION=v${version}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./dist/filen $out/bin

    wrapProgram $out/bin/filen \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"

    runHook postInstall
  '';

  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  preVersionCheck = ''
    cat > filen-version << EOF
    #!/bin/sh
    exec $out/bin/filen --skip-update "\$@"
    EOF
    chmod +x filen-version
    versionCheckProgram="$(pwd)/filen-version"
  '';

  doInstallCheck = true;

  meta = {
    description = "CLI tool for interacting with the Filen cloud";
    homepage = "https://github.com/FilenCloudDienste/filen-cli";
    changelog = "https://github.com/FilenCloudDienste/filen-cli/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "filen";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
