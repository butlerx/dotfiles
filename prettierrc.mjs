// pets: symlink=~/.prettierrc.mjs
// pets: package=npm:prettier

export default {
  singleQuote: true,
  trailingComma: 'all',
  proseWrap: 'always',
  overrides: [
    {
      files: ['*.js', '*.ts', '*.jsx', '*.tsx'],
      options: {
        printWidth: 100,
      },
    },
  ],
};
