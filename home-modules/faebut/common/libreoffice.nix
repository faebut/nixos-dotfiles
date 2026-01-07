# LibreOffice configuration
{
  # Configure LibreOffice settings via registrymodifications.xcu
  xdg.configFile."libreoffice/4/user/registrymodifications.xcu" = {
    force = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <!-- Icon theme: Colibre Dark (non-SVG) -->
        <item oor:path="/org.openoffice.Office.Common/Misc">
          <prop oor:name="SymbolStyle" oor:op="fuse">
            <value>colibre_dark</value>
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

        <!-- Enable hyphenation -->
        <item oor:path="/org.openoffice.Office.Writer/Hyphenation">
          <prop oor:name="IsHyphAuto" oor:op="fuse">
            <value>true</value>
          </prop>
        </item>
        <item oor:path="/org.openoffice.Office.Writer/Hyphenation">
          <prop oor:name="IsHyphSpecial" oor:op="fuse">
            <value>true</value>
          </prop>
        </item>

        <!-- User information -->
        <item oor:path="/org.openoffice.UserProfile/Data">
          <prop oor:name="givenname" oor:op="fuse">
            <value>Fabian</value>
          </prop>
        </item>
        <item oor:path="/org.openoffice.UserProfile/Data">
          <prop oor:name="sn" oor:op="fuse">
            <value>Trost</value>
          </prop>
        </item>

        <!-- Disable first start wizard -->
        <item oor:path="/org.openoffice.Setup/Office">
          <prop oor:name="ooSetupConnectionURL" oor:op="fuse">
            <value></value>
          </prop>
        </item>
        <item oor:path="/org.openoffice.Setup/Office">
          <prop oor:name="ooSetupInstCompleted" oor:op="fuse">
            <value>true</value>
          </prop>
        </item>
        <item oor:path="/org.openoffice.Setup/Product">
          <prop oor:name="ooSetupLastVersion" oor:op="fuse">
            <value>25.8</value>
          </prop>
        </item>

        <!-- Disable tip of the day -->
        <item oor:path="/org.openoffice.Office.Common/Misc">
          <prop oor:name="LastTipOfTheDayShown" oor:op="fuse">
            <value>99999</value>
          </prop>
        </item>
      </oor:items>
    '';
  };
}
