// pets: symlink=~/.prettierrc.mjs
// pets: package=npm:prettier

export default {
  singleQuote: true,
  trailingComma: 'all',
  proseWrap: 'always',
  overrides: [
    {
      files: ['*.js', '*.mjs', '*.cjs', '*.jsx', '*.ts', '*.mts', '*.cts', '*.tsx'],
      options: {
        printWidth: 100,
      },
    },
  ],
};
