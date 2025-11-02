# Setup CI/CD Pipeline

Você vai configurar um pipeline de CI/CD completo com todas as verificações de qualidade automatizadas.

## O que será configurado?

O pipeline vai executar automaticamente:
- ✅ **Linting** - Laravel Pint
- ✅ **Análise Estática** - PHPStan
- ✅ **Testes** - Pest com cobertura
- ✅ **Build de Assets** - Vite/npm
- ✅ **Formatação Frontend** - Prettier
- ✅ **Cache** - Dependências Composer e NPM
- ✅ **Paralelização** - Jobs executam em paralelo

## Instruções

### 1. Verificação Inicial

- Confirme que estamos em um projeto Laravel
- Pergunte ao usuário qual plataforma CI usar:
  - GitHub Actions
  - GitLab CI
  - Ambos
- Pergunte se quer incluir deploy automático

### 2. Escolha da Plataforma

Baseado na escolha do usuário, execute a configuração correspondente:

---

## GITHUB ACTIONS

### 2.1. Criar Workflow de CI

Crie o diretório e arquivo de workflow:

```bash
mkdir -p .github/workflows
```

Crie o arquivo `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [ main, master, develop ]
  pull_request:
    branches: [ main, master, develop ]

jobs:
  lint:
    name: Lint (Pint)
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          extensions: bcmath, ctype, fileinfo, json, mbstring, openssl, pdo, tokenizer, xml, zip
          coverage: none

      - name: Cache Composer dependencies
        uses: actions/cache@v4
        with:
          path: vendor
          key: composer-${{ hashFiles('composer.lock') }}
          restore-keys: composer-

      - name: Install Composer dependencies
        run: composer install --prefer-dist --no-interaction --no-progress

      - name: Run Pint
        run: composer lint

  analyse:
    name: Static Analysis (PHPStan)
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          extensions: bcmath, ctype, fileinfo, json, mbstring, openssl, pdo, tokenizer, xml, zip
          coverage: none

      - name: Cache Composer dependencies
        uses: actions/cache@v4
        with:
          path: vendor
          key: composer-${{ hashFiles('composer.lock') }}
          restore-keys: composer-

      - name: Install Composer dependencies
        run: composer install --prefer-dist --no-interaction --no-progress

      - name: Run PHPStan
        run: composer analyse

  test:
    name: Tests (Pest)
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: password
          MYSQL_DATABASE: testing
        ports:
          - 3306:3306
        options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3

      redis:
        image: redis:7
        ports:
          - 6379:6379
        options: --health-cmd="redis-cli ping" --health-interval=10s --health-timeout=5s --health-retries=3

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          extensions: bcmath, ctype, fileinfo, json, mbstring, openssl, pdo, pdo_mysql, tokenizer, xml, zip, redis
          coverage: xdebug

      - name: Cache Composer dependencies
        uses: actions/cache@v4
        with:
          path: vendor
          key: composer-${{ hashFiles('composer.lock') }}
          restore-keys: composer-

      - name: Install Composer dependencies
        run: composer install --prefer-dist --no-interaction --no-progress

      - name: Copy .env
        run: cp .env.example .env

      - name: Generate application key
        run: php artisan key:generate

      - name: Run migrations
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: testing
          DB_USERNAME: root
          DB_PASSWORD: password
          REDIS_HOST: 127.0.0.1
          REDIS_PORT: 6379
        run: php artisan migrate --force

      - name: Run tests
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: testing
          DB_USERNAME: root
          DB_PASSWORD: password
          REDIS_HOST: 127.0.0.1
          REDIS_PORT: 6379
        run: composer test:coverage

      - name: Upload coverage reports to Codecov
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
          files: ./coverage.xml
        if: always()

  prettier:
    name: Format (Prettier)
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Cache NPM dependencies
        uses: actions/cache@v4
        with:
          path: node_modules
          key: npm-${{ hashFiles('package-lock.json') }}
          restore-keys: npm-

      - name: Install NPM dependencies
        run: npm ci

      - name: Run Prettier
        run: npm run prettier:check

  build:
    name: Build Assets
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Cache NPM dependencies
        uses: actions/cache@v4
        with:
          path: node_modules
          key: npm-${{ hashFiles('package-lock.json') }}
          restore-keys: npm-

      - name: Install NPM dependencies
        run: npm ci

      - name: Build assets
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: assets
          path: public/build/
```

### 2.2. Adicionar Badge no README

Adicione o badge de status do CI no `README.md`:

```markdown
![CI](https://github.com/seu-usuario/seu-repositorio/workflows/CI/badge.svg)
```

Substitua `seu-usuario` e `seu-repositorio` pelos valores corretos.

### 2.3. Configurar Deploy (Opcional)

Se o usuário quiser deploy automático, crie `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [ main, master ]

jobs:
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'

      - name: Install Composer dependencies
        run: composer install --prefer-dist --no-interaction --no-progress --no-dev --optimize-autoloader

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install NPM dependencies
        run: npm ci

      - name: Build assets
        run: npm run build

      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /var/www/html
            git pull origin main
            composer install --no-dev --optimize-autoloader
            npm ci
            npm run build
            php artisan migrate --force
            php artisan optimize
            php artisan queue:restart
```

**Configure os secrets no GitHub:**
- `Settings` → `Secrets and variables` → `Actions` → `New repository secret`
- Adicione: `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`

---

## GITLAB CI

### 2.1. Criar Arquivo de Pipeline

Crie o arquivo `.gitlab-ci.yml` na raiz do projeto:

```yaml
image: php:8.4-fpm

variables:
  MYSQL_ROOT_PASSWORD: password
  MYSQL_DATABASE: testing
  DB_HOST: mysql
  DB_USERNAME: root
  DB_PASSWORD: password
  REDIS_HOST: redis

cache:
  paths:
    - vendor/
    - node_modules/

stages:
  - build
  - test
  - quality
  - deploy

# Template para jobs PHP
.php-base:
  before_script:
    - apt-get update -qq && apt-get install -y -qq git curl libzip-dev zip unzip
    - docker-php-ext-install pdo_mysql zip bcmath
    - curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    - composer install --prefer-dist --no-interaction --no-progress

# Template para jobs Node
.node-base:
  image: node:20
  before_script:
    - npm ci

# Build
install:
  extends: .php-base
  stage: build
  script:
    - composer install --prefer-dist --no-interaction --no-progress
  artifacts:
    paths:
      - vendor/
    expire_in: 1 hour

install-node:
  extends: .node-base
  stage: build
  script:
    - npm ci
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 hour

# Quality
lint:
  extends: .php-base
  stage: quality
  dependencies:
    - install
  script:
    - composer lint

analyse:
  extends: .php-base
  stage: quality
  dependencies:
    - install
  script:
    - composer analyse
  allow_failure: false

prettier:
  extends: .node-base
  stage: quality
  dependencies:
    - install-node
  script:
    - npm run prettier:check

# Test
test:
  extends: .php-base
  stage: test
  dependencies:
    - install
  services:
    - mysql:8.0
    - redis:7
  before_script:
    - apt-get update -qq && apt-get install -y -qq git curl libzip-dev zip unzip
    - docker-php-ext-install pdo_mysql zip bcmath
    - pecl install redis && docker-php-ext-enable redis
    - curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    - composer install --prefer-dist --no-interaction --no-progress
    - cp .env.example .env
    - php artisan key:generate
  script:
    - php artisan migrate --force
    - composer test:coverage
  coverage: '/^\s*Lines:\s*\d+.\d+\%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml

# Build Assets
build:
  extends: .node-base
  stage: test
  dependencies:
    - install-node
  script:
    - npm run build
  artifacts:
    paths:
      - public/build/
    expire_in: 1 week

# Deploy (opcional)
deploy-production:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh $SSH_USER@$SSH_HOST "cd /var/www/html && git pull origin main && composer install --no-dev --optimize-autoloader && npm ci && npm run build && php artisan migrate --force && php artisan optimize && php artisan queue:restart"
  only:
    - main
    - master
  when: manual
```

### 2.2. Configurar Variáveis no GitLab

Configure as variáveis CI/CD no GitLab:

1. Vá em `Settings` → `CI/CD` → `Variables`
2. Adicione as variáveis:
   - `SSH_HOST` - IP ou domínio do servidor
   - `SSH_USER` - Usuário SSH
   - `SSH_PRIVATE_KEY` - Chave privada SSH (marque como Protected e Masked)

### 2.3. Adicionar Badge no README

Adicione o badge de status do pipeline no `README.md`:

```markdown
![Pipeline](https://gitlab.com/seu-usuario/seu-repositorio/badges/main/pipeline.svg)
![Coverage](https://gitlab.com/seu-usuario/seu-repositorio/badges/main/coverage.svg)
```

---

## 3. Configurações Adicionais

### 3.1. Configurar Codecov (Opcional)

Para cobertura de código:

**GitHub Actions:**
1. Acesse https://codecov.io e conecte seu repositório
2. Copie o token
3. Adicione como secret `CODECOV_TOKEN`

**GitLab CI:**
1. Acesse https://codecov.io e conecte seu repositório
2. O upload já está configurado no pipeline

### 3.2. Ajustar composer.json

Certifique-se de ter os scripts necessários no `composer.json`:

```json
"scripts": {
    "test": "pest",
    "test:coverage": "pest --coverage --coverage-cobertura=coverage.xml",
    "lint": "pint --test",
    "analyse": "phpstan analyse --memory-limit=-1"
}
```

### 3.3. Ajustar package.json

Certifique-se de ter os scripts necessários no `package.json`:

```json
"scripts": {
    "dev": "vite",
    "build": "vite build",
    "prettier": "prettier --write resources/",
    "prettier:check": "prettier --check resources/"
}
```

### 3.4. Configurar .env.example

Certifique-se de que `.env.example` está atualizado para CI:

```env
APP_NAME=Laravel
APP_ENV=testing
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=testing
DB_USERNAME=root
DB_PASSWORD=password

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
```

### 3.5. Otimizações de Cache

**Para GitHub Actions**, os caches já estão configurados.

**Para GitLab CI**, adicione cache global no `.gitlab-ci.yml`:

```yaml
cache:
  key:
    files:
      - composer.lock
      - package-lock.json
  paths:
    - vendor/
    - node_modules/
```

---

## 4. Verificação Final

### 4.1. Teste Local

Antes de commitar, teste localmente:

```bash
# Simular CI localmente
composer lint
composer analyse
composer test
npm run prettier:check
npm run build
```

### 4.2. Primeiro Commit

Faça commit e push:

```bash
git add .
git commit -m "ci: adiciona pipeline de CI/CD"
git push origin main
```

### 4.3. Verifique o Pipeline

**GitHub Actions:**
- Vá em `Actions` no repositório
- Verifique se todos os jobs passaram

**GitLab CI:**
- Vá em `CI/CD` → `Pipelines`
- Verifique se todos os stages passaram

---

## 5. Resumo Final

Mostre ao usuário um resumo:

## ✅ CI/CD Configurado com Sucesso!

**Pipeline configurado:**
- ✅ [GitHub Actions / GitLab CI / Ambos]
- ✅ Lint (Pint)
- ✅ Análise Estática (PHPStan)
- ✅ Testes (Pest) com cobertura
- ✅ Formatação (Prettier)
- ✅ Build de Assets (Vite)
- ✅ Cache de dependências
- ✅ Jobs executam em paralelo
- ✅ [Deploy automático configurado (se aplicável)]

**Arquivos criados:**
- `.github/workflows/ci.yml` (se GitHub)
- `.github/workflows/deploy.yml` (se GitHub + deploy)
- `.gitlab-ci.yml` (se GitLab)

**Como funciona:**

**Triggers:**
- Push em `main`, `master`, `develop`
- Pull Requests / Merge Requests

**Jobs executados:**
1. **Lint** - Verifica formatação PHP com Pint
2. **Analyse** - Análise estática com PHPStan
3. **Test** - Executa testes com Pest (MySQL + Redis)
4. **Prettier** - Verifica formatação frontend
5. **Build** - Compila assets

**Próximos passos:**

1. **Adicione badges no README:**
   ```markdown
   ![CI](https://github.com/user/repo/workflows/CI/badge.svg)
   ![Coverage](https://codecov.io/gh/user/repo/branch/main/graph/badge.svg)
   ```

2. **Configure branch protection:**
   - Exija que CI passe antes de merge
   - Exija review de código

3. **Monitore cobertura:**
   - Configure Codecov
   - Defina mínimo de cobertura (ex: 80%)

4. **Otimize o pipeline:**
   - Use cache de dependências
   - Paralelização está configurada
   - Considere usar runners dedicados

**Comandos úteis:**

```bash
# Simular CI localmente
composer lint && composer analyse && composer test

# Forçar re-run do pipeline
git commit --allow-empty -m "ci: trigger pipeline"
git push
```

**Recursos:**
- GitHub Actions: https://docs.github.com/actions
- GitLab CI: https://docs.gitlab.com/ee/ci/
- Codecov: https://codecov.io

---

## Notas Importantes

- O pipeline executa em todas as branches configuradas
- Testes rodam com MySQL e Redis (simula produção)
- Deploy é manual por segurança (pode automatizar se quiser)
- Cache acelera builds subsequentes
- Jobs executam em paralelo para velocidade
- Configure secrets/variables antes de usar deploy
- Use branch protection para garantir qualidade
- Monitore tempo de execução e otimize se necessário
- Cobertura de código é enviada para Codecov (opcional)
- Pipeline falha se qualquer check não passar
