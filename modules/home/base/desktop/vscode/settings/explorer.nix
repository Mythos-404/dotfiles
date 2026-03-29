{
  # 资源管理器
  "explorer.fileNesting.enabled" = true;
  "explorer.incrementalNaming" = "smart";
  "explorer.sortOrder" = "type";
  "explorer.sortOrderLexicographicOptions" = "unicode";

  # 文件
  "files.autoSave" = "onFocusChange";
  "files.eol" = "\n";
  "files.associations" = {
    "App.css" = "tailwindcss";
  };

  # file nesting 规则
  "explorer.fileNesting.patterns" = {
    "*.ts" = "\${capture}.js";
    "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
    "*.jsx" = "\${capture}.js";
    "*.tsx" = "\${capture}.ts";
    "tsconfig.json" = "tsconfig.*.json";
    "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb, bun.lock";
    "*.sqlite" = "\${capture}.\${extname}-*";
    "*.db" = "\${capture}.\${extname}-*";
    "*.sqlite3" = "\${capture}.\${extname}-*";
    "*.db3" = "\${capture}.\${extname}-*";
    "*.sdb" = "\${capture}.\${extname}-*";
    "*.s3db" = "\${capture}.\${extname}-*";
    "*.go" = "\${capture}_test.go";
  };
}
