{
  lib,
  stdenv,
  fetchgit,
  glib,
}:
stdenv.mkDerivation {
  pname = "gnome-shell-extension-searchlightng";
  version = "unstable-2026-08-18";

  src = fetchgit {
    url = "https://git.salix.host/salix/searchlightng.git";
    rev = "fd336a92d51d4689d504667e4b02f145d30c5019";
    hash = "sha256-I+I7OmO7U96E5hq3Fs0LswY6WslN4PBu/WC84CVlz8I=";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/search-light-ng@salix.host
    cp -r \
      LICENSE \
      *.js \
      metadata.json \
      stylesheet.css \
      ui \
      preferences \
      effects \
      schemas \
      $out/share/gnome-shell/extensions/search-light-ng@salix.host/
    runHook postInstall
  '';

  meta = {
    description = "Take the apps search out of GNOME overview (SearchLightNG fork)";
    homepage = "https://git.salix.host/salix/searchlightng";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
