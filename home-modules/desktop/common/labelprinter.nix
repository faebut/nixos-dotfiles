{pkgs, ...}: let
  printRed = pkgs.writeShellApplication {
    name = "print-red";
    runtimeInputs = with pkgs; [
      inkscape
      python3Packages.brother-ql
      coreutils
    ];
    text = ''
      printer="''${QL_PRINTER:-tcp://BRWC41375CA8B0D.local:9100}"

      if [ "$#" -lt 1 ]; then
        echo "usage: print-red FILE..." >&2
        echo "Prints SVG, PDF or PNG files in black/red on a 62mm DK-22251 roll." >&2
        exit 1
      fi

      tmpdir="$(mktemp -d)"
      trap 'rm -rf "$tmpdir"' EXIT

      for file in "$@"; do
        if [ ! -f "$file" ]; then
          echo "print-red: file not found: $file" >&2
          exit 1
        fi

        case "''${file,,}" in
          *.png)
            image="$file"
            ;;
          *.svg | *.pdf)
            image="$tmpdir/$(basename "$file").png"
            inkscape "$file" \
              --export-type=png \
              --export-filename="$image" \
              --export-width=696 \
              --export-background=white \
              --export-background-opacity=1 \
              >/dev/null 2>&1
            ;;
          *)
            echo "print-red: unsupported file type: $file" >&2
            exit 1
            ;;
        esac

        brother_ql -m QL-820NWB -b network -p "$printer" print -l 62red --red "$image"
      done
    '';
  };
in {
  home.packages = [printRed];
}
