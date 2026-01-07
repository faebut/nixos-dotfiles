# LibreOffice configuration
{
  # Configure LibreOffice settings via registrymodifications.xcu
  xdg.configFile."libreoffice/4/user/registrymodifications.xcu" = {
    force = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <!-- Icon theme: Colibre (SVG + Dark) -->
        <item oor:path="/org.openoffice.Office.Common/Misc">
          <prop oor:name="SymbolStyle" oor:op="fuse">
            <value>colibre_dark_svg</value>
          </prop>
        </item>
        
        <!-- Application appearance: Light (0 = automatic, 1 = light, 2 = dark) -->
        <item oor:path="/org.openoffice.Office.Common/Appearance">
          <prop oor:name="ApplicationAppearance" oor:op="fuse">
            <value>1</value>
          </prop>
        </item>

        <!-- Disable warning when saving in Microsoft Office formats -->
        <item oor:path="/org.openoffice.Office.Common/Save/Document">
          <prop oor:name="WarnAlienFormat" oor:op="fuse">
            <value>false</value>
          </prop>
        </item>
      </oor:items>
    '';
  };
}
