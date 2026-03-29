{
  # Python
  "python.analysis.typeCheckingMode" = "basic";

  # Nix
  "nix.enableLanguageServer" = true;
  "nix.formatterPath" = "alejandra";
  "nix.serverSettings" = {
    "nil" = {
      "formatting" = {
        "command" = ["alejandra"];
      };
    };
  };

  # Zig
  "zig.zls.enabled" = "on";

  # Go
  "go.toolsManagement.autoUpdate" = true;
  "go.inlayHints.constantValues" = true;
  "go.lintTool" = "golangci-lint-v2";
  "gopls" = {
    "ui.semanticTokens" = false;
  };

  # Ruff / Biome
  "ruff.importStrategy" = "useBundled";
  "ruff.format.preview" = true;
  "ruff.lint.preview" = true;
  "biome.suggestInstallingGlobally" = false;

  # formatter: language-specific
  "[jsonc]" = {"editor.defaultFormatter" = "vscode.json-language-features";};
  "[json]" = {"editor.defaultFormatter" = "vscode.json-language-features";};
  "[typescript]" = {"editor.defaultFormatter" = "biomejs.biome";};
  "[typescriptreact]" = {"editor.defaultFormatter" = "biomejs.biome";};
  "[css]" = {"editor.defaultFormatter" = "biomejs.biome";};
  "[html]" = {"editor.defaultFormatter" = "vscode.html-language-features";};
  "[snippets]" = {"editor.defaultFormatter" = "biomejs.biome";};
  "[csv]" = {"editor.inlayHints.maximumLength" = 0;};

  # codeActionsOnSave
  "editor.codeActionsOnSave" = {
    "source.organizeImports.biome" = "explicit";
    "source.fixAll.biome" = "explicit";
  };

  "[python]" = {
    "editor.codeActionsOnSave" = {
      "source.organizeImports" = "explicit";
    };
  };
}
