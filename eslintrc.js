module.exports = {
  env: {
    es6: true,
    node: true,
    browser: true,
  },
  parser: 'typescript-eslint-parser',
  root: true,
  extends: [
    'airbnb',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'prettier',
    'prettier/@typescript-eslint',
  ],
  plugins: ['@typescript-eslint', 'prettier'],
  settings: {
    'import/parsers': {
      '@typescript-eslint/parser': ['.ts', '.tsx'],
    },
    'import/resolver': {
      typescript: {
        extensions: ['.ts', '.tsx'],
      },
      node: {
        extensions: ['.js'],
      },
    },
  },
  rules: {
    'arrow-parens': ['error', 'as-needed'],
    'func-style': ['error', 'declaration', { allowArrowFunctions: true }],
    'import/extensions': [
      'error',
      'always',
      {
        js: 'ignorePackages',
        ts: 'ignorePackages',
        tsx: 'ignorePackages',
      },
    ],
    'import/prefer-default-export': 0,
    'linebreak-style': ['error', 'unix'],
    'no-param-reassign': ['error', { props: false }],
    'no-use-before-define': ['error', { functions: false }],
    'react/jsx-filename-extension': [2, { extensions: ['.js', '.jsx', '.ts', '.tsx'] }],
    'react/prop-types': 0,
  },
};
