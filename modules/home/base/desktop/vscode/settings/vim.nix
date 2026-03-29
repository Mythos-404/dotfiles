{
  "vim.leader" = "<space>";
  "vim.easymotion" = true;
  "vim.incsearch" = true;
  "vim.useSystemClipboard" = true;
  "vim.useCtrlKeys" = true;
  "vim.hlsearch" = true;
  "vim.sneak" = true;
  "vim.sneakReplacesF" = true;
  "vim.camelCaseMotion.enable" = true;

  "vim.normalModeKeyBindingsNonRecursive" = [
    {
      before = ["g" "r"];
      commands = ["editor.action.rename"];
    }
    {
      before = ["g" "a"];
      commands = ["editor.action.quickFix"];
    }
    {
      before = ["K"];
      commands = ["editor.action.showHover"];
      silent = true;
    }
    {
      before = ["g" "["];
      commands = ["editor.action.marker.prevInFiles"];
    }
    {
      before = ["g" "]"];
      commands = ["editor.action.marker.nextInFiles"];
    }
  ];

  "vim.visualModeKeyBindings" = [
    {
      before = ["L"];
      commands = ["editor.action.indentLines"];
    }
    {
      before = ["H"];
      commands = ["editor.action.outdentLines"];
    }
  ];
}
