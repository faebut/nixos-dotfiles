"""Preset for Go templ files combining templ, HTML, htmx, and tailwindcss LSPs."""


def servers():
    return [
        ["templ", "lsp"],
        ["vscode-html-language-server", "--stdio"],
        ["htmx-lsp"],
        ["tailwindcss-language-server", "--stdio"],
    ]
