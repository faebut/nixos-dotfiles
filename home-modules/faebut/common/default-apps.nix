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
    };
  };
}
