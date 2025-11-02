# Setup Quality Tools para Laravel

Você vai configurar um ambiente completo de ferramentas de qualidade e linters em um projeto Laravel limpo.

## Instruções

Execute as seguintes etapas em ordem:

### 1. Verificação Inicial
- Confirme que estamos em um projeto Laravel (verifique se existe `artisan`, `composer.json` com Laravel)
- Confirme com o usuário se ele quer prosseguir com a instalação completa

### 2. Instalação de Dependências PHP (Composer)

Instale os seguintes pacotes como dependências de desenvolvimento:

```bash
composer require --dev laravel/pint
composer require --dev larastan/larastan:"^3.0"
composer require --dev pestphp/pest:"^3.7.4"
composer require --dev pestphp/pest-plugin-arch
composer require --dev pestphp/pest-plugin-laravel
```

Se o projeto usar Livewire/Filament, pergunte ao usuário e instale também:
```bash
composer require --dev pestphp/pest-plugin-livewire
```

### 3. Instalação de Dependências Node (NPM/Yarn/PNPM)

Detecte o gerenciador de pacotes (verifique lockfiles: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`) e instale:

```bash
npm install --save-dev prettier prettier-plugin-blade prettier-plugin-tailwindcss
npm install --save-dev husky
npm install --save-dev @commitlint/cli @commitlint/config-conventional
npm install --save-dev commitizen cz-conventional-changelog
```

### 4. Criar Arquivo pint.json

Crie o arquivo `pint.json` na raiz do projeto com a seguinte configuração:

```json
{
  "preset": "psr12",
  "rules": {
    "align_multiline_comment": true,
    "array_indentation": true,
    "array_syntax": true,
    "array_push": true,
    "assign_null_coalescing_to_coalesce_equal": true,
    "binary_operator_spaces": true,
    "blank_line_after_namespace": true,
    "blank_line_after_opening_tag": true,
    "blank_line_before_statement": {
      "statements": [
        "continue",
        "do",
        "exit",
        "if",
        "for",
        "foreach",
        "return",
        "switch",
        "throw",
        "try",
        "while",
        "yield"
      ]
    },
    "cast_spaces": true,
    "class_attributes_separation": true,
    "class_reference_name_casing": true,
    "combine_consecutive_issets": true,
    "combine_consecutive_unsets": true,
    "concat_space": {
      "spacing": "one"
    },
    "declare_parentheses": true,
    "explicit_string_variable": true,
    "fully_qualified_strict_types": true,
    "global_namespace_import": {
      "import_classes": true,
      "import_constants": true,
      "import_functions": true
    },
    "group_import": true,
    "heredoc_indentation": {
      "indentation": "same_as_start"
    },
    "lambda_not_used_import": true,
    "list_syntax": true,
    "logical_operators": true,
    "magic_constant_casing": true,
    "mb_str_functions": true,
    "method_chaining_indentation": true,
    "modernize_strpos": true,
    "modernize_types_casting": true,
    "multiline_comment_opening_closing": true,
    "multiline_whitespace_before_semicolons": true,
    "native_function_type_declaration_casing": true,
    "new_with_braces": true,
    "no_alias_functions": true,
    "no_alternative_syntax": true,
    "no_empty_comment": true,
    "no_empty_statement": true,
    "no_empty_phpdoc": true,
    "no_extra_blank_lines": {
      "tokens": [
        "attribute",
        "break",
        "case",
        "continue",
        "curly_brace_block",
        "default",
        "extra",
        "parenthesis_brace_block",
        "return",
        "square_brace_block",
        "switch",
        "throw",
        "use",
        "use_trait"
      ]
    },
    "no_multiline_whitespace_around_double_arrow": true,
    "no_php4_constructor": true,
    "no_singleline_whitespace_before_semicolons": true,
    "no_spaces_around_offset": true,
    "no_superfluous_elseif": true,
    "no_superfluous_phpdoc_tags": true,
    "no_trailing_comma_in_singleline": true,
    "no_unneeded_control_parentheses": true,
    "no_useless_concat_operator": true,
    "no_useless_else": true,
    "no_useless_return": true,
    "no_whitespace_before_comma_in_array": true,
    "not_operator_with_successor_space": true,
    "object_operator_without_whitespace": true,
    "ordered_traits": true,
    "ordered_class_elements": true,
    "ordered_interfaces": true,
    "pow_to_exponentiation": true,
    "return_assignment": true,
    "random_api_migration": true,
    "regular_callable_call": true,
    "self_accessor": true,
    "self_static_accessor": true,
    "set_type_to_cast": true,
    "short_scalar_cast": true,
    "simple_to_complex_string_variable": true,
    "simplified_if_return": true,
    "simplified_null_return": true,
    "single_class_element_per_statement": true,
    "single_import_per_statement": false,
    "single_line_comment_spacing": true,
    "single_line_comment_style": true,
    "single_space_after_construct": true,
    "space_after_semicolon": true,
    "strict_comparison": true,
    "strict_param": true,
    "ternary_to_null_coalescing": true,
    "trailing_comma_in_multiline": true,
    "trim_array_spaces": true,
    "unary_operator_spaces": true,
    "use_arrow_functions": true,
    "void_return": true,
    "whitespace_after_comma_in_array": true,
    "class_definition": true
  }
}
```

### 5. Criar Arquivo phpstan.neon

Crie o arquivo `phpstan.neon` na raiz do projeto:

```neon
includes:
    - vendor/larastan/larastan/extension.neon

parameters:
    level: 5
    treatPhpDocTypesAsCertain: false
    paths:
        - app/
```

**Nota:** As regras `ignoreErrors` podem ser adicionadas posteriormente conforme necessário (por exemplo, para ignorar métodos de macros do Laravel).

### 6. Criar Arquivo .prettierrc

Crie o arquivo `.prettierrc` na raiz do projeto:

```json
{
  "plugins": [
    "prettier-plugin-blade",
    "prettier-plugin-tailwindcss"
  ],
  "overrides": [
    {
      "files": [
        "*.blade.php"
      ],
      "options": {
        "parser": "blade"
      }
    }
  ],
  "printWidth": 120,
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "all"
}
```

### 7. Criar Arquivo .prettierignore

Crie o arquivo `.prettierignore`:

```
vendor/
node_modules/
public/
storage/
bootstrap/cache/
```

### 8. Criar Arquivo .editorconfig

Crie o arquivo `.editorconfig` na raiz do projeto:

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
indent_size = 4
indent_style = space
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false

[*.{yml,yaml,blade.php,css,js,json,xml}]
indent_size = 2
```

### 9. Criar Arquivo commitlint.config.js

Crie o arquivo `commitlint.config.js` na raiz do projeto:

```javascript
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'header-max-length': [2, 'always', 150],
  },
};
```

### 10. Criar Teste de Arquitetura

Crie o arquivo `tests/Feature/ArchTest.php`:

```php
<?php

use Illuminate\Database\Eloquent\Model;

arch('globals')
    ->expect(['dd', 'dump', 'ray'])
    ->not->toBeUsed();

arch()->preset()->security()->ignoring('App\Helpers');
arch()->preset()->php();

arch('app')
    ->expect('env')->not->toBeUsed()
    ->expect('App\Http\Controllers')->toHaveSuffix('Controller')
    ->expect('App\Models')->toExtend(Model::class)->ignoring('App\Models\Casts')->ignoring('App\Models\Scopes');
```

### 11. Configurar Husky

Execute os seguintes comandos:

```bash
npx husky init
```

### 12. Criar Git Hooks

**Primeiro, crie o arquivo `.husky/common.sh` (funções compartilhadas):**

```bash
#!/usr/bin/env sh

# Detecta automaticamente como executar comandos PHP
# Verifica se Laravel Sail existe E se o container está rodando
# Caso contrário, usa PHP local
run_php() {
    if [ -x "./vendor/bin/sail" ] && docker ps -q --filter "name=laravel.test" | grep -q .; then
        ./vendor/bin/sail php "$@"
    else
        php "$@"
    fi
}
```

**Criar arquivo `.husky/pre-commit`:**

```bash
#!/usr/bin/env sh
. "$(dirname "$0")/common.sh"

# Verifica se é merge
git merge HEAD &> /dev/null
IS_MERGE_PROCESS=$?

if [ $IS_MERGE_PROCESS -ne 0 ]; then
    exit 0
fi

# Recupera arquivos em staging
STAGED_FILES=$(git diff --cached --name-only)

# Aborta a execução caso a área de staging esteja limpa
if [ -z "$STAGED_FILES" ]; then
    exit 0
fi

# Executa formatação
echo "🔍 Formatando código PHP com Pint..."
run_php vendor/bin/pint

echo "🎨 Formatando código frontend com Prettier..."
npm run prettier

# Re-adiciona arquivos formatados
git add $STAGED_FILES

echo "✅ Código formatado com sucesso!"
```

**Criar arquivo `.husky/pre-push`:**

```bash
#!/usr/bin/env sh
. "$(dirname "$0")/common.sh"

echo "🔍 Validando código com Pint..."
run_php vendor/bin/pint --test

echo "🔬 Executando análise estática com PHPStan..."
run_php vendor/bin/phpstan analyse --memory-limit=-1

echo "🧪 Executando testes com Pest..."
run_php vendor/bin/pest --compact

echo "✅ Todas as verificações passaram!"
```

**Criar arquivo `.husky/commit-msg`:**

```bash
#!/usr/bin/env sh

npx --no -- commitlint --edit $1
```

**Criar arquivo `.husky/prepare-commit-msg`:**

```bash
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

exec < /dev/tty && node_modules/.bin/cz --hook || true
```

Torne os hooks executáveis:
```bash
chmod +x .husky/common.sh .husky/pre-commit .husky/pre-push .husky/commit-msg .husky/prepare-commit-msg
```

### 13. Adicionar Scripts no composer.json

Adicione ou atualize a seção `scripts` no `composer.json`:

```json
"scripts": {
    "post-autoload-dump": [
        "Illuminate\\Foundation\\ComposerScripts::postAutoloadDump",
        "@php artisan package:discover --ansi"
    ],
    "post-update-cmd": [
        "@php artisan vendor:publish --tag=laravel-assets --ansi --force"
    ],
    "post-root-package-install": [
        "@php -r \"file_exists('.env') || copy('.env.example', '.env');\""
    ],
    "post-create-project-cmd": [
        "@php artisan key:generate --ansi"
    ],
    "test": "pest",
    "test:coverage": "pest --coverage",
    "lint": "pint --test",
    "lint:fix": "pint",
    "analyse": "phpstan analyse --memory-limit=-1",
    "format": "@lint:fix && npm run prettier",
    "check": [
        "@lint",
        "@analyse",
        "@test"
    ],
    "optimize": "php artisan optimize:clear && php artisan filament:optimize",
    "horizon": "php artisan horizon"
}
```

**Nota:** O comando `optimize` usa `filament:optimize` que só funciona se o Filament estiver instalado. Se não usar Filament, remova essa parte ou use apenas `php artisan optimize:clear`.

### 14. Adicionar Scripts no package.json

Adicione ou atualize a seção `scripts` no `package.json`:

```json
"scripts": {
    "dev": "vite",
    "build": "vite build",
    "prettier": "prettier --write resources/",
    "prettier:check": "prettier --check resources/"
}
```

Adicione também a configuração do Commitizen:

```json
"config": {
    "commitizen": {
        "path": "./node_modules/cz-conventional-changelog"
    }
}
```

### 15. Formatação Inicial

Execute a formatação inicial do código:

```bash
composer lint:fix
npm run prettier
```

### 16. Teste Final

Execute os testes para garantir que tudo está funcionando:

```bash
composer check
```

### 17. Resumo Final

Mostre ao usuário um resumo do que foi instalado e configurado:

- ✅ Laravel Pint (formatação PHP)
- ✅ PHPStan com Larastan (análise estática)
- ✅ Pest com plugins (testes)
- ✅ Prettier com plugins Blade e Tailwind
- ✅ Husky com 4 hooks configurados
- ✅ Commitlint e Commitizen
- ✅ EditorConfig
- ✅ Scripts Composer e NPM
- ✅ Testes de arquitetura

Informe também os comandos úteis:
- `composer test` - Executa os testes
- `composer test:coverage` - Executa testes com cobertura
- `composer lint` - Valida código
- `composer lint:fix` - Formata código
- `composer analyse` - Análise estática
- `composer format` - Formata PHP e frontend
- `composer check` - Executa todas as verificações (lint + analyse + test)
- `composer optimize` - Limpa cache e otimiza (inclui Filament se instalado)
- `composer horizon` - Inicia Laravel Horizon
- `npm run prettier` - Formata frontend
- `npm run prettier:check` - Verifica formatação frontend
- `git commit` - Usa Commitizen para commits padronizados

## Notas Importantes

- Pergunte ao usuário antes de prosseguir com cada etapa importante
- Se algum arquivo já existir, pergunte se quer sobrescrever
- Se o projeto já tiver algumas ferramentas, adapte a instalação
- Teste cada etapa antes de prosseguir para a próxima
- Se usar Docker/Sail, ajuste os comandos nos hooks conforme necessário
