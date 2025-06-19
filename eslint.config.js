// pets: symlink=~/.eslint.config.js
// @ts-check
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettierConfig from 'eslint-plugin-prettier/recommended';

const typeScriptExtensions = ['.ts', '.cts', '.mts', '.tsx'];
const allExtensions = [...typeScriptExtensions, '.js', '.jsx', '.mjs'];

export default tseslint.config(
  eslint.configs.recommended,
  tseslint.configs.recommendedTypeChecked,
  tseslint.configs.stylisticTypeChecked,
  prettierConfig,
  {
    languageOptions: {
      parserOptions: {
        project: true,
      },
    },
    settings: {
      'import/resolver': { node: { extensions: [...allExtensions, '.json'] } },
      'import/extensions': allExtensions,
      'import/ignore': ['node_modules', '\\.(scss|css|less|hbs|svg|json)$'],
      'import/parsers': { '@typescript-eslint/parser': typeScriptExtensions },
      'import/external-module-folders': ['node_modules', 'node_modules/@types'],
    },
    rules: {
      // enforces use of function declarations or expressions
      // https://eslint.org/docs/rules/func-style
      'func-style': ['error', 'declaration', { allowArrowFunctions: true }],

      // Ensure consistent use of file extension within the import path
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/extensions.md
      'import/extensions': [
        'error',
        'ignorePackages',
        {
          ts: 'never',
          js: 'never',
          mjs: 'never',
          jsx: 'never',
          tsx: 'never',
        },
      ],

      // React rules
      'no-param-reassign': ['error', { props: false }],
      'react/jsx-filename-extension': [2, { extensions: ['.js', '.jsx', '.ts', '.tsx'] }],
      'react/prop-types': 0,

      // Best practices
      // enforces getter/setter pairs in objects
      // https://eslint.org/docs/rules/accessor-pairs
      'accessor-pairs': 'off',
      // enforces return statements in callbacks of array's methods
      // https://eslint.org/docs/rules/array-callback-return
      'array-callback-return': ['error', { allowImplicit: true }],
      // treat var statements as if they were block scoped
      // https://eslint.org/docs/rules/block-scoped-var
      'block-scoped-var': 'error',
      // specify the maximum cyclomatic complexity allowed in a program
      // https://eslint.org/docs/rules/complexity
      complexity: ['off', 20],
      // enforce that class methods use "this"
      // https://eslint.org/docs/rules/class-methods-use-this
      'class-methods-use-this': ['error', { exceptMethods: [] }],
      // require return statements to either always or never specify values
      // https://eslint.org/docs/rules/consistent-return
      'consistent-return': 'error',
      // require default case in switch statements
      // https://eslint.org/docs/rules/default-case
      'default-case': ['error', { commentPattern: '^no default$' }],
      // Enforce default clauses in switch statements to be last
      // https://eslint.org/docs/rules/default-case-last
      'default-case-last': 'error',
      // https://eslint.org/docs/rules/default-param-last
      'default-param-last': 'error',
      // encourages use of dot notation whenever possible
      // https://eslint.org/docs/rules/dot-notation
      'dot-notation': ['error', { allowKeywords: true }],
      // require the use of === and !==
      // https://eslint.org/docs/rules/eqeqeq
      eqeqeq: ['error', 'always', { null: 'ignore' }],
      // Require grouped accessor pairs in object literals and classes
      // https://eslint.org/docs/rules/grouped-accessor-pairs
      'grouped-accessor-pairs': 'error',
      // make sure for-in loops have an if statement
      // https://eslint.org/docs/rules/guard-for-in
      'guard-for-in': 'error',
      // enforce a maximum number of classes per file
      // https://eslint.org/docs/rules/max-classes-per-file
      'max-classes-per-file': ['error', 1],
      // disallow the use of alert, confirm, and prompt
      // https://eslint.org/docs/rules/no-alert
      'no-alert': 'error',
      // disallow use of arguments.caller or arguments.callee
      // https://eslint.org/docs/rules/no-caller
      'no-caller': 'error',
      // Disallow returning value in constructor
      // https://eslint.org/docs/rules/no-constructor-return
      'no-constructor-return': 'error',
      // disallow division operators explicitly at beginning of regular expression
      // https://eslint.org/docs/rules/no-div-regex
      'no-div-regex': 'off',
      // disallow else after a return in an if
      // https://eslint.org/docs/rules/no-else-return
      'no-else-return': ['error', { allowElseIf: false }],
      // disallow empty functions, except for standalone funcs/arrows
      // https://eslint.org/docs/rules/no-empty-function
      'no-empty-function': ['error', { allow: ['arrowFunctions', 'functions', 'methods'] }],
      // disallow comparisons to null without a type-checking operator
      // https://eslint.org/docs/rules/no-eq-null
      'no-eq-null': 'off',
      // disallow use of eval()
      // https://eslint.org/docs/rules/no-eval
      'no-eval': 'error',
      // disallow adding to native types
      // https://eslint.org/docs/rules/no-extend-native
      'no-extend-native': 'error',
      // disallow unnecessary function binding
      // https://eslint.org/docs/rules/no-extra-bind
      'no-extra-bind': 'error',
      // disallow Unnecessary Labels
      // https://eslint.org/docs/rules/no-extra-label
      'no-extra-label': 'error',
      // deprecated in favor of no-global-assign
      // https://eslint.org/docs/rules/no-native-reassign
      'no-native-reassign': 'off',
      // disallow implicit type conversions
      // https://eslint.org/docs/rules/no-implicit-coercion
      'no-implicit-coercion': ['off', { boolean: false, number: true, string: true, allow: [] }],
      // disallow var and named functions in global scope
      // https://eslint.org/docs/rules/no-implicit-globals
      'no-implicit-globals': 'off',
      // disallow use of eval()-like methods
      // https://eslint.org/docs/rules/no-implied-eval
      'no-implied-eval': 'error',
      // disallow this keywords outside of classes or class-like objects
      // https://eslint.org/docs/rules/no-invalid-this
      'no-invalid-this': 'off',
      // disallow usage of __iterator__ property
      // https://eslint.org/docs/rules/no-iterator
      'no-iterator': 'error',
      // disallow use of labels for anything other than loops and switches
      // https://eslint.org/docs/rules/no-labels
      'no-labels': ['error', { allowLoop: false, allowSwitch: false }],
      // disallow unnecessary nested blocks
      // https://eslint.org/docs/rules/no-lone-blocks
      'no-lone-blocks': 'error',
      // disallow creation of functions within loops
      // https://eslint.org/docs/rules/no-loop-func
      'no-loop-func': 'error',

      // ES6 rules
      // require let or const instead of var
      'no-var': 'error',
      // require method and property shorthand syntax for object literals
      // https://eslint.org/docs/rules/object-shorthand
      'object-shorthand': [
        'error',
        'always',
        {
          ignoreConstructors: false,
          avoidQuotes: true,
        },
      ],
      // suggest using arrow functions as callbacks
      'prefer-arrow-callback': [
        'error',
        {
          allowNamedFunctions: false,
          allowUnboundThis: true,
        },
      ],
      // suggest using of const declaration for variables that are never modified after declared
      'prefer-const': [
        'error',
        {
          destructuring: 'any',
          ignoreReadBeforeAssign: true,
        },
      ],
      // Prefer destructuring from arrays and objects
      // https://eslint.org/docs/rules/prefer-destructuring
      'prefer-destructuring': [
        'error',
        {
          VariableDeclarator: {
            array: false,
            object: true,
          },
          AssignmentExpression: {
            array: true,
            object: false,
          },
        },
        {
          enforceForRenamedProperties: false,
        },
      ],

      // ensure absolute imports are above relative imports and that unassigned imports are ignored
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/order.md
      'import/order': [
        'error',
        {
          groups: ['builtin', 'external', 'parent', 'sibling', 'index', 'object', 'type'],
          distinctGroup: true,
          alphabetize: { order: 'asc', caseInsensitive: false },
        },
      ],

      // disallow magic numbers
      // https://eslint.org/docs/rules/no-magic-numbers
      'no-magic-numbers': [
        'off',
        { ignore: [], ignoreArrayIndexes: true, enforceConst: true, detectObjects: false },
      ],
      // disallow use of multiline strings
      // https://eslint.org/docs/rules/no-multi-str
      'no-multi-str': 'error',
      // disallow use of new operator when not part of the assignment or comparison
      // https://eslint.org/docs/rules/no-new
      'no-new': 'error',
      // disallow use of new operator for Function object
      // https://eslint.org/docs/rules/no-new-func
      'no-new-func': 'error',
      // disallows creating new instances of String, Number, and Boolean
      // https://eslint.org/docs/rules/no-new-wrappers
      'no-new-wrappers': 'error',
      // Disallow calls to the Object constructor without an argument
      // https://eslint.org/docs/latest/rules/no-object-constructor
      'no-object-constructor': 'error',
      // disallow use of octal escape sequences in string literals, such as
      // var foo = 'Copyright \251';
      // https://eslint.org/docs/rules/no-octal-escape
      'no-octal-escape': 'error',
      // disallow reassignment of function parameters
      // disallow parameter object manipulation except for specific exclusions
      // rule: https://eslint.org/docs/rules/no-param-reassign.html
      'no-param-reassign': [
        'error',
        {
          props: true,
          ignorePropertyModificationsFor: [
            'acc', // for reduce accumulators
            'accumulator', // for reduce accumulators
            'e', // for e.returnvalue
            'ctx', // for Koa routing
            'context', // for Koa routing
            'req', // for Express requests
            'request', // for Express requests
            'res', // for Express responses
            'response', // for Express responses
            '$scope', // for Angular 1 scopes
            'staticContext', // for ReactRouter context
          ],
        },
      ],

      // disallow usage of __proto__ property
      // https://eslint.org/docs/rules/no-proto
      'no-proto': 'error',

      // disallow certain object properties
      // https://eslint.org/docs/rules/no-restricted-properties
      'no-restricted-properties': [
        'error',
        {
          object: 'arguments',
          property: 'callee',
          message: 'arguments.callee is deprecated',
        },
        {
          object: 'global',
          property: 'isFinite',
          message: 'Please use Number.isFinite instead',
        },
        {
          object: 'self',
          property: 'isFinite',
          message: 'Please use Number.isFinite instead',
        },
        {
          object: 'window',
          property: 'isFinite',
          message: 'Please use Number.isFinite instead',
        },
        {
          object: 'global',
          property: 'isNaN',
          message: 'Please use Number.isNaN instead',
        },
        {
          object: 'self',
          property: 'isNaN',
          message: 'Please use Number.isNaN instead',
        },
        {
          object: 'window',
          property: 'isNaN',
          message: 'Please use Number.isNaN instead',
        },
        {
          property: '__defineGetter__',
          message: 'Please use Object.defineProperty instead.',
        },
        {
          property: '__defineSetter__',
          message: 'Please use Object.defineProperty instead.',
        },
        {
          object: 'Math',
          property: 'pow',
          message: 'Use the exponentiation operator (**) instead.',
        },
      ],

      // disallow use of assignment in return statement
      // https://eslint.org/docs/rules/no-return-assign
      'no-return-assign': ['error', 'always'],

      // disallow redundant `return await`
      // https://eslint.org/docs/rules/no-return-await
      'no-return-await': 'error',

      // disallow use of `javascript:` urls.
      // https://eslint.org/docs/rules/no-script-url
      'no-script-url': 'error',

      // disallow comparisons where both sides are exactly the same
      // https://eslint.org/docs/rules/no-self-compare
      'no-self-compare': 'error',

      // disallow use of comma operator
      // https://eslint.org/docs/rules/no-sequences
      'no-sequences': 'error',

      // restrict what can be thrown as an exception
      // https://eslint.org/docs/rules/no-throw-literal
      'no-throw-literal': 'error',

      // disallow unmodified conditions of loops
      // https://eslint.org/docs/rules/no-unmodified-loop-condition
      'no-unmodified-loop-condition': 'off',

      // disallow usage of expressions in statement position
      // https://eslint.org/docs/rules/no-unused-expressions
      'no-unused-expressions': [
        'error',
        {
          allowShortCircuit: false,
          allowTernary: false,
          allowTaggedTemplates: false,
        },
      ],

      // disallow unnecessary .call() and .apply()
      // https://eslint.org/docs/rules/no-useless-call
      'no-useless-call': 'off',

      // disallow useless string concatenation
      // https://eslint.org/docs/rules/no-useless-concat
      'no-useless-concat': 'error',

      // disallow redundant return; keywords
      // https://eslint.org/docs/rules/no-useless-return
      'no-useless-return': 'error',

      // disallow use of void operator
      // https://eslint.org/docs/rules/no-void
      'no-void': ['error', { allowAsStatement: true }],

      // disallow usage of configurable warning terms in comments: e.g. todo
      // https://eslint.org/docs/rules/no-warning-comments
      'no-warning-comments': ['off', { terms: ['todo', 'fixme', 'xxx'], location: 'start' }],

      // require using Error objects as Promise rejection reasons
      // https://eslint.org/docs/rules/prefer-promise-reject-errors
      'prefer-promise-reject-errors': ['error', { allowEmptyReject: true }],

      // Suggest using named capture group in regular expression
      // https://eslint.org/docs/rules/prefer-named-capture-group
      'prefer-named-capture-group': 'off',

      // Prefer Object.hasOwn() over Object.prototype.hasOwnProperty.call()
      // https://eslint.org/docs/rules/prefer-object-has-own
      'prefer-object-has-own': 'error',

      // https://eslint.org/docs/rules/prefer-regex-literals
      'prefer-regex-literals': ['error', { disallowRedundantWrapping: true }],

      // require use of the second argument for parseInt()
      // https://eslint.org/docs/rules/radix
      radix: 'error',

      // https://eslint.org/docs/rules/require-await
      'require-await': 'error',

      // Enforce the use of u flag on RegExp
      // https://eslint.org/docs/rules/require-unicode-regexp
      'require-unicode-regexp': 'off',

      // requires to declare all vars on top of their containing scope
      // https://eslint.org/docs/rules/vars-on-top
      'vars-on-top': 'error',

      // require or disallow Yoda conditions
      // https://eslint.org/docs/rules/yoda
      yoda: 'error',
      // Enforces that a return statement is present in property getters
      // https://eslint.org/docs/rules/getter-return
      'getter-return': ['error', { allowImplicit: true }],

      // Disallow await inside of loops
      // https://eslint.org/docs/rules/no-await-in-loop
      'no-await-in-loop': 'warn',

      // disallow assignment in conditional expressions
      'no-cond-assign': ['error', 'always'],

      // disallow use of console
      'no-console': 'error',

      // disallow function or variable declarations in nested blocks
      'no-inner-declarations': 'error',

      // Disallow returning values from Promise executor functions
      // https://eslint.org/docs/rules/no-promise-executor-return
      'no-promise-executor-return': 'error',

      // Disallow template literal placeholder syntax in regular strings
      // https://eslint.org/docs/rules/no-template-curly-in-string
      'no-template-curly-in-string': 'error',

      // Disallow loops with a body that allows only one iteration
      // https://eslint.org/docs/rules/no-unreachable-loop
      'no-unreachable-loop': [
        'error',
        {
          ignore: [], // WhileStatement, DoWhileStatement, ForStatement, ForInStatement, ForOfStatement
        },
      ],

      // https://eslint.org/docs/rules/no-unsafe-optional-chaining
      'no-unsafe-optional-chaining': ['error', { disallowArithmeticOperators: true }],

      // disallow negation of the left operand of an in expression
      // deprecated in favor of no-unsafe-negation
      'no-negated-in-lhs': 'off',

      // Disallow assignments that can lead to race conditions due to usage of await or yield
      // https://eslint.org/docs/rules/require-atomic-updates
      // note: not enabled because it is very buggy
      'require-atomic-updates': 'off',

      // ensure that the results of typeof are compared against a valid string
      // https://eslint.org/docs/rules/valid-typeof
      'valid-typeof': ['error', { requireStringLiterals: true }],

      // enforces no braces where they can be omitted
      // https://eslint.org/docs/rules/arrow-body-style
      // disabled because ttps://github.com/prettier/eslint-plugin-prettier/issues/65
      'arrow-body-style': 'off',

      // disallow importing from the same path more than once
      // https://eslint.org/docs/rules/no-duplicate-imports
      // replaced by https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-duplicates.md
      'no-duplicate-imports': 'off',

      // disallow symbol constructor
      // https://eslint.org/docs/rules/no-new-symbol
      'no-new-symbol': 'error',

      // Disallow specified names in exports
      // https://eslint.org/docs/rules/no-restricted-exports
      'no-restricted-exports': [
        'error',
        {
          restrictedNamedExports: [
            'default', // use `export default` to provide a default export
            'then', // this will cause tons of confusion when your module is dynamically `import()`ed, and will break in most node ESM versions
          ],
        },
      ],

      // disallow specific imports
      // https://eslint.org/docs/rules/no-restricted-imports
      'no-restricted-imports': [
        'off',
        {
          paths: [],
          patterns: [],
        },
      ],

      // disallow useless computed property keys
      // https://eslint.org/docs/rules/no-useless-computed-key
      'no-useless-computed-key': 'error',

      // disallow unnecessary constructor
      // https://eslint.org/docs/rules/no-useless-constructor
      'no-useless-constructor': 'error',

      // disallow renaming import, export, and destructured assignments to the same name
      // https://eslint.org/docs/rules/no-useless-rename
      'no-useless-rename': [
        'error',
        {
          ignoreDestructuring: false,
          ignoreImport: false,
          ignoreExport: false,
        },
      ],

      // disallow parseInt() in favor of binary, octal, and hexadecimal literals
      // https://eslint.org/docs/rules/prefer-numeric-literals
      'prefer-numeric-literals': 'error',

      // suggest using Reflect methods where applicable
      // https://eslint.org/docs/rules/prefer-reflect
      'prefer-reflect': 'off',

      // use rest parameters instead of arguments
      // https://eslint.org/docs/rules/prefer-rest-params
      'prefer-rest-params': 'error',

      // suggest using the spread syntax instead of .apply()
      // https://eslint.org/docs/rules/prefer-spread
      'prefer-spread': 'error',

      // suggest using template literals instead of string concatenation
      // https://eslint.org/docs/rules/prefer-template
      'prefer-template': 'error',

      // import sorting
      // https://eslint.org/docs/rules/sort-imports
      'sort-imports': [
        'off',
        {
          ignoreCase: false,
          ignoreDeclarationSort: false,
          ignoreMemberSort: false,
          memberSyntaxSortOrder: ['none', 'all', 'multiple', 'single'],
        },
      ],

      // require a Symbol description
      // https://eslint.org/docs/rules/symbol-description
      'symbol-description': 'error',
      // Static analysis:

      // ensure imports point to files/modules that can be resolved
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-unresolved.md
      'import/no-unresolved': ['error', { caseSensitiveStrict: true, commonjs: true }],

      // ensure named imports coupled with named exports
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/named.md#when-not-to-use-it
      // TypeScript compilation already ensures that named imports exist in the referenced module
      'import/named': 'off',

      // ensure default import coupled with default export
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/default.md#when-not-to-use-it
      'import/default': 'off',

      // Helpful warnings:

      // disallow invalid exports, e.g. multiple defaults
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/export.md
      'import/export': 'error',

      // do not allow a default import name to match a named export
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-named-as-default.md
      'import/no-named-as-default': 'error',

      // warn on accessing default export property names that are also named exports
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-named-as-default-member.md
      'import/no-named-as-default-member': 'error',

      // disallow use of jsdoc-marked-deprecated imports
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-deprecated.md
      'import/no-deprecated': 'error',

      // Forbid the use of extraneous packages
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-extraneous-dependencies.md
      // paths are treated both as absolute paths, and relative to process.cwd()
      'import/no-extraneous-dependencies': [
        'error',
        {
          devDependencies: [
            'test/**', // tape, common npm pattern
            'tests/**', // also common npm pattern
            'spec/**', // mocha, rspec-like pattern
            '**/__tests__/**', // jest pattern
            '**/__mocks__/**', // jest pattern
            'test.{js,jsx}', // repos with a single test file
            'test-*.{js,jsx}', // repos with multiple top-level test files
            '**/*{.,_}{test,spec}.{js,jsx}', // tests where the extension or filename suffix denotes that it is a test
            '**/jest.config.js', // jest config
            '**/jest.setup.js', // jest setup
            '**/vue.config.js', // vue-cli config
            '**/webpack.config.js', // webpack config
            '**/webpack.config.*.js', // webpack config
            '**/rollup.config.js', // rollup config
            '**/rollup.config.*.js', // rollup config
            '**/gulpfile.js', // gulp config
            '**/gulpfile.*.js', // gulp config
            '**/Gruntfile{,.js}', // grunt config
            '**/protractor.conf.js', // protractor config
            '**/protractor.conf.*.js', // protractor config
            '**/karma.conf.js', // karma config
            '**/eslint.config.{mjs,js}', // eslint config
            '**/*.test.*',
            '**/*.spec.*',
            '**/testHelper.*',
          ],
          optionalDependencies: false,
        },
      ],

      // Forbid mutable exports
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-mutable-exports.md
      'import/no-mutable-exports': 'error',

      // Module systems:

      // disallow require()
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-commonjs.md
      'import/no-commonjs': 'off',

      // disallow AMD require/define
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-amd.md
      'import/no-amd': 'error',

      // Style guide:

      // disallow non-import statements appearing before import statements
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/first.md
      'import/first': 'error',

      // disallow duplicate imports
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-duplicates.md
      'import/no-duplicates': 'error',

      // Require a newline after the last import/require in a group
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/newline-after-import.md
      'import/newline-after-import': 'error',

      // Forbid import of modules using absolute paths
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-absolute-path.md
      'import/no-absolute-path': 'error',

      // Forbid require() calls with expressions
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-dynamic-require.md
      'import/no-dynamic-require': 'error',

      // Forbid Webpack loader syntax in imports
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-webpack-loader-syntax.md
      'import/no-webpack-loader-syntax': 'error',

      // Prevent importing the default as if it were named
      // https://github.com/import-js/eslint-plugin-import/blob/master/docs/rules/no-named-default.md
      'import/no-named-default': 'error',

      // Reports if a module's default export is unnamed
      // https://github.com/import-js/eslint-plugin-import/blob/d9b712ac7fd1fddc391f7b234827925c160d956f/docs/rules/no-anonymous-default-export.md
      'import/no-anonymous-default-export': [
        'error',
        {
          allowArray: false,
          allowArrowFunction: true,
          allowAnonymousClass: false,
          allowAnonymousFunction: false,
          allowLiteral: false,
          allowObject: true,
        },
      ],

      // Forbid a module from importing itself
      // https://github.com/import-js/eslint-plugin-import/blob/44a038c06487964394b1e15b64f3bd34e5d40cde/docs/rules/no-self-import.md
      'import/no-self-import': 'error',

      // Forbid cyclical dependencies between modules
      // https://github.com/import-js/eslint-plugin-import/blob/d81f48a2506182738409805f5272eff4d77c9348/docs/rules/no-cycle.md
      'import/no-cycle': ['error', { maxDepth: '∞' }],

      // Ensures that there are no useless path segments
      // https://github.com/import-js/eslint-plugin-import/blob/ebafcbf59ec9f653b2ac2a0156ca3bcba0a7cf57/docs/rules/no-useless-path-segments.md
      'import/no-useless-path-segments': ['error', { commonjs: true }],

      // Reports modules without any exports, or with unused exports
      // https://github.com/import-js/eslint-plugin-import/blob/f63dd261809de6883b13b6b5b960e6d7f42a7813/docs/rules/no-unused-modules.md
      'import/no-unused-modules': [
        'error',
        {
          missingExports: true,
          unusedExports: true,
        },
      ],

      // Reports the use of import declarations with CommonJS exports in any module except for the main module.
      // https://github.com/import-js/eslint-plugin-import/blob/1012eb951767279ce3b540a4ec4f29236104bb5b/docs/rules/no-import-module-exports.md
      'import/no-import-module-exports': ['error'],

      // Use this rule to prevent importing packages through relative paths.
      // https://github.com/import-js/eslint-plugin-import/blob/1012eb951767279ce3b540a4ec4f29236104bb5b/docs/rules/no-relative-packages.md
      'import/no-relative-packages': 'error',

      // enforce a consistent style for type specifiers (inline or top-level)
      // https://github.com/import-js/eslint-plugin-import/blob/d5fc8b670dc8e6903dbb7b0894452f60c03089f5/docs/rules/consistent-type-specifier-style.md
      'import/consistent-type-specifier-style': ['error', 'prefer-inline'],

      // Reports the use of empty named import blocks.
      // https://github.com/import-js/eslint-plugin-import/blob/d5fc8b670dc8e6903dbb7b0894452f60c03089f5/docs/rules/no-empty-named-blocks.md
      'import/no-empty-named-blocks': 'error',
      // enforce return after a callback
      'callback-return': 'off',

      // require all requires be top-level
      // https://eslint.org/docs/rules/global-require
      'global-require': 'error',

      // enforces error handling in callbacks (node environment)
      'handle-callback-err': 'off',

      // disallow use of the Buffer() constructor
      // https://eslint.org/docs/rules/no-buffer-constructor
      'no-buffer-constructor': 'error',

      // disallow mixing regular variable and require declarations
      'no-mixed-requires': ['off', false],

      // disallow use of new operator with the require function
      'no-new-require': 'error',

      // disallow string concatenation with __dirname and __filename
      // https://eslint.org/docs/rules/no-path-concat
      'no-path-concat': 'error',

      // disallow use of process.env
      'no-process-env': 'error',

      // disallow process.exit()
      'no-process-exit': 'off',

      // restrict usage of specified node modules
      'no-restricted-modules': 'off',

      // disallow use of synchronous methods (off by default)
      'no-sync': 'off',

      strict: ['error', 'never'],

      // require camel case names
      camelcase: ['error', { properties: 'never', ignoreDestructuring: false }],

      // enforce or disallow capitalization of the first letter of a comment
      // https://eslint.org/docs/rules/capitalized-comments
      'capitalized-comments': [
        'off',
        'never',
        {
          line: {
            ignorePattern: '.*',
            ignoreInlineComments: true,
            ignoreConsecutiveComments: true,
          },
          block: {
            ignorePattern: '.*',
            ignoreInlineComments: true,
            ignoreConsecutiveComments: true,
          },
        },
      ],

      // enforces consistent naming when capturing the current execution context
      'consistent-this': 'off',

      // requires function names to match the name of the variable or property to which they are
      // assigned
      // https://eslint.org/docs/rules/func-name-matching
      'func-name-matching': [
        'off',
        'always',
        {
          includeCommonJSModuleExports: false,
          considerPropertyDescriptor: true,
        },
      ],

      // require function expressions to have a name
      // https://eslint.org/docs/rules/func-names
      'func-names': 'error',

      // disallow specified identifiers
      // https://eslint.org/docs/rules/id-denylist
      'id-denylist': 'off',

      // this option enforces minimum and maximum identifier lengths
      // (variable names, property names etc.)
      'id-length': 'off',

      // require identifiers to match the provided regular expression
      'id-match': 'off',

      // require or disallow an empty line between class members
      // https://eslint.org/docs/rules/lines-between-class-members
      'lines-between-class-members': 'off',

      // require or disallow newlines around directives
      // https://eslint.org/docs/rules/lines-around-directive
      'lines-around-directive': [
        'error',
        {
          before: 'always',
          after: 'always',
        },
      ],

      // Require or disallow logical assignment logical operator shorthand
      // https://eslint.org/docs/latest/rules/logical-assignment-operators
      'logical-assignment-operators': ['error', 'always', { enforceForIfStatements: true }],

      // specify the maximum depth that blocks can be nested
      'max-depth': ['off', 4],

      // specify the max number of lines in a file
      // https://eslint.org/docs/rules/max-lines
      'max-lines': [
        'off',
        {
          max: 300,
          skipBlankLines: true,
          skipComments: true,
        },
      ],

      // enforce a maximum function length
      // https://eslint.org/docs/rules/max-lines-per-function
      'max-lines-per-function': [
        'off',
        {
          max: 50,
          skipBlankLines: true,
          skipComments: true,
          IIFEs: true,
        },
      ],

      // specify the maximum depth callbacks can be nested
      'max-nested-callbacks': 'off',

      // limits the number of parameters that can be used in the function declaration.
      'max-params': ['off', 3],

      // specify the maximum number of statement allowed in a function
      'max-statements': ['off', 10],

      // enforce a particular style for multiline comments
      // https://eslint.org/docs/rules/multiline-comment-style
      'multiline-comment-style': ['off', 'starred-block'],

      // require a capital letter for constructors
      'new-cap': [
        'error',
        {
          newIsCap: true,
          newIsCapExceptions: [],
          capIsNew: false,
          capIsNewExceptions: ['Immutable.Map', 'Immutable.Set', 'Immutable.List'],
        },
      ],

      'newline-after-var': 'off',

      // https://eslint.org/docs/rules/newline-before-return
      'newline-before-return': 'off',

      // disallow use of the Array constructor
      'no-array-constructor': 'error',

      // disallow use of bitwise operators
      // https://eslint.org/docs/rules/no-bitwise
      'no-bitwise': 'error',

      // disallow use of the continue statement
      // https://eslint.org/docs/rules/no-continue
      'no-continue': 'off',

      // disallow comments inline after code
      'no-inline-comments': 'off',

      // disallow if as the only statement in an else block
      // https://eslint.org/docs/rules/no-lonely-if
      'no-lonely-if': 'error',

      // disallow use of chained assignment expressions
      // https://eslint.org/docs/rules/no-multi-assign
      'no-multi-assign': ['error'],

      // disallow negated conditions
      // https://eslint.org/docs/rules/no-negated-condition
      'no-negated-condition': 'off',

      // disallow nested ternary expressions
      'no-nested-ternary': 'error',

      // disallow use of the Object constructor
      'no-new-object': 'error',

      // disallow use of unary operators, ++ and --
      // https://eslint.org/docs/rules/no-plusplus
      'no-plusplus': ['error', { allowForLoopAfterthoughts: true }],

      // disallow certain syntax forms
      // https://eslint.org/docs/rules/no-restricted-syntax
      'no-restricted-syntax': [
        'error',
        {
          selector: 'ForInStatement',
          message:
            'for..in loops iterate over the entire prototype chain, which is virtually never what you want. Use Object.{keys,values,entries}, and iterate over the resulting array.',
        },
        {
          selector: 'LabeledStatement',
          message:
            'Labels are a form of GOTO; using them makes code confusing and hard to maintain and understand.',
        },
        {
          selector: 'WithStatement',
          message:
            '`with` is disallowed in strict mode because it makes code impossible to predict and optimize.',
        },
      ],

      // disallow the use of ternary operators
      'no-ternary': 'off',

      // disallow dangling underscores in identifiers
      // https://eslint.org/docs/rules/no-underscore-dangle
      'no-underscore-dangle': [
        'error',
        {
          allow: [],
          allowAfterThis: false,
          allowAfterSuper: false,
          enforceInMethodNames: true,
        },
      ],

      // disallow the use of Boolean literals in conditional expressions
      // also, prefer `a || b` over `a ? a : b`
      // https://eslint.org/docs/rules/no-unneeded-ternary
      'no-unneeded-ternary': ['error', { defaultAssignment: false }],

      // allow just one var statement per function
      'one-var': ['error', 'never'],

      // require assignment operator shorthand where possible or prohibit it entirely
      // https://eslint.org/docs/rules/operator-assignment
      'operator-assignment': ['error', 'always'],

      // Require or disallow padding lines between statements
      // https://eslint.org/docs/rules/padding-line-between-statements
      'padding-line-between-statements': 'off',

      // Disallow the use of Math.pow in favor of the ** operator
      // https://eslint.org/docs/rules/prefer-exponentiation-operator
      'prefer-exponentiation-operator': 'error',

      // Prefer use of an object spread over Object.assign
      // https://eslint.org/docs/rules/prefer-object-spread
      'prefer-object-spread': 'error',

      // do not require jsdoc
      // https://eslint.org/docs/rules/require-jsdoc
      'require-jsdoc': 'off',

      // requires object keys to be sorted
      'sort-keys': ['off', 'asc', { caseSensitive: false, natural: true }],

      // sort variables within the same declaration block
      'sort-vars': 'off',

      // require or disallow a space immediately following the // or /* in a comment
      // https://eslint.org/docs/rules/spaced-comment
      'spaced-comment': [
        'error',
        'always',
        {
          line: {
            exceptions: ['-', '+'],
            markers: ['=', '!', '/'], // space here to support sprockets directives, slash for TS /// comments
          },
          block: {
            exceptions: ['-', '+'],
            markers: ['=', '!', ':', '::'], // space here to support sprockets directives and flow comment types
            balanced: true,
          },
        },
      ],

      // require or disallow the Unicode Byte Order Mark
      // https://eslint.org/docs/rules/unicode-bom
      'unicode-bom': ['error', 'never'],

      // enforce or disallow variable initializations at definition
      'init-declarations': 'off',

      // disallow the catch clause parameter name being the same as a variable in the outer scope
      'no-catch-shadow': 'off',

      // disallow labels that share a name with a variable
      // https://eslint.org/docs/rules/no-label-var
      'no-label-var': 'error',

      // disallow specific globals
      'no-restricted-globals': [
        'error',
        {
          name: 'isFinite',
          message:
            'Use Number.isFinite instead https://github.com/airbnb/javascript#standard-library--isfinite',
        },
        {
          name: 'isNaN',
          message:
            'Use Number.isNaN instead https://github.com/airbnb/javascript#standard-library--isnan',
        },
      ],

      // disallow declaration of variables already declared in the outer scope
      '@typescript-eslint/no-shadow': ['error', { ignoreOnInitialization: true }],
      'no-shadow': 'off',

      // disallow use of undefined when initializing variables
      'no-undef-init': 'error',

      // disallow use of undefined variable
      // https://eslint.org/docs/rules/no-undefined
      'no-undefined': 'error',

      // disallow declaration of variables that are not used in the code
      'no-unused-vars': 'off',
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          varsIgnorePattern: '^_',
          argsIgnorePattern: '^_',
          vars: 'all',
          args: 'after-used',
          ignoreRestSiblings: true,
        },
      ],

      // disallow use of variables before they are defined
      'no-use-before-define': 'off',
      '@typescript-eslint/no-use-before-define': [
        'error',
        { functions: false, typedefs: false, classes: true, variables: true },
      ],

      '@typescript-eslint/no-explicit-any': ['error', { fixToUnknown: true }],
    },
  },
  {
    // Specific overrides for test files
    files: ['**/*.test.*', '**/*.spec.*', '**/testHelper.*'],
    rules: {
      'import/no-extraneous-dependencies': 'off',
    },
  },
);
