{pkgs, ...}: {
  # Just install Obsidian
  # Everything else (settings, plugins, vim keybindings) managed through git in the vault
  home.packages = with pkgs; [
    obsidian
  ];
}
