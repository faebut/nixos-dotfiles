{
  config,
  pkgs,
  ...
}: let
  pandocData = ../../../config/pandoc;

  md2pdf = pkgs.writeShellApplication {
    name = "md2pdf";
    runtimeInputs = with pkgs; [
      gum
      pandoc
      texliveFull
      coreutils
      gnused
      util-linux
    ];
    text = ''
      datadir="''${MD2PDF_DATA_DIR:-${pandocData}}"
      default_template="''${MD2PDF_TEMPLATE:-eisvogel}"
      export TEXINPUTS="$datadir/assets//:''${TEXINPUTS:-}"

      usage() {
        cat <<EOF
      usage: md2pdf [-t TEMPLATE] [-o DIR] [-l] [FILE...] [-- PANDOC_ARGS...]

      Convert Markdown files to PDF with pandoc. Without FILE arguments all
      *.md files in the current directory are converted. Without -t you are
      asked which template to use.

        -t, --template NAME   use template NAME (see -l)
        -o, --output-dir DIR  write PDFs to DIR instead of next to the source
        -l, --list            list available templates
        -h, --help            show this help

      Templates live in: $datadir/defaults
      EOF
      }

      list_templates() {
        local file name desc
        for file in "$datadir"/defaults/*.yaml; do
          name="$(basename "$file" .yaml)"
          desc="$(sed -n 's/^# md2pdf: //p' "$file" | head -n 1)"
          printf '%s\t%s\n' "$name" "$desc"
        done
      }

      die() {
        echo "md2pdf: $*" >&2
        exit 1
      }

      template=""
      outdir=""
      files=()
      pandoc_args=()

      while [ "$#" -gt 0 ]; do
        case "$1" in
          -t | --template)
            [ "$#" -ge 2 ] || die "$1 needs an argument"
            template="$2"
            shift 2
            ;;
          -o | --output-dir)
            [ "$#" -ge 2 ] || die "$1 needs an argument"
            outdir="$2"
            shift 2
            ;;
          -l | --list)
            list_templates | column -t -s $'\t'
            exit 0
            ;;
          -h | --help)
            usage
            exit 0
            ;;
          --)
            shift
            pandoc_args=("$@")
            break
            ;;
          -*)
            die "unknown option: $1 (see --help)"
            ;;
          *)
            files+=("$1")
            shift
            ;;
        esac
      done

      if [ "''${#files[@]}" -eq 0 ]; then
        shopt -s nullglob
        files=(*.md)
        shopt -u nullglob
        [ "''${#files[@]}" -gt 0 ] || die "no Markdown files given and none found in $PWD"
      fi

      for file in "''${files[@]}"; do
        [ -f "$file" ] || die "file not found: $file"
      done

      interactive=false
      if [ -t 0 ] && [ -t 1 ]; then
        interactive=true
      fi

      if [ -z "$template" ]; then
        if [ "$interactive" = true ]; then
          options=()
          while IFS=$'\t' read -r name desc; do
            option="$(printf '%-16s %s' "$name" "$desc")"$'\t'"$name"
            if [ "$name" = "$default_template" ]; then
              options=("$option" "''${options[@]}")
            else
              options+=("$option")
            fi
          done < <(list_templates)

          template="$(gum choose \
            --header "Template for ''${#files[@]} file(s):" \
            --label-delimiter=$'\t' \
            "''${options[@]}")" || exit 130
        else
          template="$default_template"
        fi
      fi

      [ -f "$datadir/defaults/$template.yaml" ] || die "unknown template: $template (see --list)"

      if [ -n "$outdir" ]; then
        mkdir -p "$outdir"
        outdir="$(realpath "$outdir")"
      fi

      failed=0
      for file in "''${files[@]}"; do
        srcdir="$(dirname "$(realpath "$file")")"
        base="$(basename "$file")"
        out="''${outdir:-$srcdir}/''${base%.*}.pdf"

        cmd=(pandoc
          --data-dir="$datadir"
          --defaults="$template"
          "$base"
          --output="$out"
          "''${pandoc_args[@]}")

        if [ "$interactive" = true ]; then
          if (cd "$srcdir" && gum spin --spinner dot --show-error --title "$file -> $template" -- "''${cmd[@]}"); then
            gum style --foreground 2 "done   $out"
          else
            gum style --foreground 1 "failed $file"
            failed=$((failed + 1))
          fi
        else
          if (cd "$srcdir" && "''${cmd[@]}"); then
            echo "done   $out"
          else
            echo "failed $file" >&2
            failed=$((failed + 1))
          fi
        fi
      done

      [ "$failed" -eq 0 ] || die "$failed of ''${#files[@]} file(s) failed"
    '';
  };
in {
  home.packages = [md2pdf];

  xdg.dataFile."pandoc".source = pandocData;

  home.sessionVariables.TEXINPUTS = "${config.xdg.dataHome}/pandoc/assets//:";
}
