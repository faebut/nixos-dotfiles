{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser
      "text/html" = ["zen.desktop"];
      "x-scheme-handler/http" = ["zen.desktop"];
      "x-scheme-handler/https" = ["zen.desktop"];
      "x-scheme-handler/about" = ["zen.desktop"];
      "x-scheme-handler/unknown" = ["zen.desktop"];

      # Email
      "x-scheme-handler/mailto" = ["thunderbird.desktop"];
      "message/rfc822" = ["thunderbird.desktop"];
      
      # Documents - PDF
      "application/pdf" = ["org.gnome.Papers.desktop"];
      "application/x-bzpdf" = ["org.gnome.Papers.desktop"];
      "application/x-ext-pdf" = ["org.gnome.Papers.desktop"];
      "application/x-gzpdf" = ["org.gnome.Papers.desktop"];
      "application/x-xzpdf" = ["org.gnome.Papers.desktop"];
      
      # Documents - Other
      "application/illustrator" = ["org.gnome.Papers.desktop"];
      
      # Documents - DjVu
      "image/vnd.djvu" = ["org.gnome.Papers.desktop"];
      "image/vnd.djvu+multipage" = ["org.gnome.Papers.desktop"];
      "application/x-ext-djv" = ["org.gnome.Papers.desktop"];
      "application/x-ext-djvu" = ["org.gnome.Papers.desktop"];
      
      # Documents - Comic books (Papers can handle these, but Foliate also supports CBZ)
      "application/vnd.comicbook-rar" = ["org.gnome.Papers.desktop"];
      "application/x-cb7" = ["org.gnome.Papers.desktop"];
      "application/x-cbr" = ["org.gnome.Papers.desktop"];
      "application/x-cbt" = ["org.gnome.Papers.desktop"];
      "application/x-ext-cb7" = ["org.gnome.Papers.desktop"];
      "application/x-ext-cbr" = ["org.gnome.Papers.desktop"];
      "application/x-ext-cbt" = ["org.gnome.Papers.desktop"];
      "application/x-ext-cbz" = ["org.gnome.Papers.desktop"];
      
      # eBooks
      "application/epub+zip" = ["com.github.johnfactotum.Foliate.desktop"];
      "application/x-mobipocket-ebook" = ["com.github.johnfactotum.Foliate.desktop"];
      "application/vnd.amazon.mobi8-ebook" = ["com.github.johnfactotum.Foliate.desktop"];
      "application/x-fictionbook+xml" = ["com.github.johnfactotum.Foliate.desktop"];
      "application/x-zip-compressed-fb2" = ["com.github.johnfactotum.Foliate.desktop"];
      "application/vnd.comicbook+zip" = ["com.github.johnfactotum.Foliate.desktop"]; # CBZ - prefer Foliate over Papers
      "x-scheme-handler/opds" = ["com.github.johnfactotum.Foliate.desktop"];
      
      # LibreOffice Writer - Word documents & text
      "application/msword" = ["writer.desktop"];
      "application/vnd.ms-word" = ["writer.desktop"];
      "application/vnd.ms-word.document.macroEnabled.12" = ["writer.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"]; # DOCX
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = ["writer.desktop"];
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"]; # ODT
      "application/vnd.oasis.opendocument.text-template" = ["writer.desktop"];
      "application/rtf" = ["writer.desktop"];
      "text/rtf" = ["writer.desktop"];
      
      # LibreOffice Calc - Spreadsheets
      "application/vnd.ms-excel" = ["calc.desktop"];
      "application/vnd.ms-excel.sheet.macroEnabled.12" = ["calc.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["calc.desktop"]; # XLSX
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = ["calc.desktop"];
      "application/vnd.oasis.opendocument.spreadsheet" = ["calc.desktop"]; # ODS
      "application/vnd.oasis.opendocument.spreadsheet-template" = ["calc.desktop"];
      "application/excel" = ["calc.desktop"];
      "application/x-excel" = ["calc.desktop"];
      "text/csv" = ["calc.desktop"];
      "application/csv" = ["calc.desktop"];
      
      # LibreOffice Impress - Presentations
      "application/vnd.ms-powerpoint" = ["impress.desktop"];
      "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = ["impress.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["impress.desktop"]; # PPTX
      "application/vnd.openxmlformats-officedocument.presentationml.template" = ["impress.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow" = ["impress.desktop"];
      "application/vnd.oasis.opendocument.presentation" = ["impress.desktop"]; # ODP
      "application/vnd.oasis.opendocument.presentation-template" = ["impress.desktop"];
      
      # Images
      "image/png" = ["org.gnome.Loupe.desktop"];
      "image/jpeg" = ["org.gnome.Loupe.desktop"];
      "image/jpg" = ["org.gnome.Loupe.desktop"];
      "image/gif" = ["org.gnome.Loupe.desktop"];
      "image/webp" = ["org.gnome.Loupe.desktop"];
      "image/svg+xml" = ["org.gnome.Loupe.desktop"];
      "image/bmp" = ["org.gnome.Loupe.desktop"];
      "image/tiff" = ["org.gnome.Loupe.desktop"];
    };
  };
}
