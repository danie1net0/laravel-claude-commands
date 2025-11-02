# Setup de Pacotes Laravel Essenciais

Você vai instalar e configurar pacotes essenciais do Laravel para o projeto.

## Pacotes Disponíveis

### Localização
- **lucascudo/laravel-pt-br-localization** - Traduções PT-BR completas para Laravel

### Autenticação & API
- **laravel/sanctum** - Autenticação SPA e API com tokens

### Debug & Desenvolvimento
- **laravel/telescope** - Dashboard de debug e monitoramento
- **barryvdh/laravel-debugbar** - Barra de debug no browser
- **dutchcodingcompany/filament-developer-logins** - Logins rápidos para desenvolvimento (Filament)

### Documentação API
- **dedoc/scramble** - Geração automática de documentação OpenAPI/Swagger

### Testes
- **pestphp/pest-plugin-livewire** - Plugin Pest para testes de componentes Livewire/Filament

### Dados
- **spatie/laravel-data** - DTOs e transformação de dados

### Backup
- **spatie/laravel-backup** - Sistema completo de backup

### HTTP Client
- **saloonphp/saloon** - Cliente HTTP moderno e poderoso
- **saloonphp/laravel-plugin** - Integração Laravel para Saloon
- **saloonphp/cache-plugin** - Plugin de cache para Saloon

### Filas & Jobs
- **laravel/horizon** - Dashboard para Redis queues

## Instruções

### 1. Verificação Inicial

- Confirme que estamos em um projeto Laravel
- Pergunte ao usuário quais pacotes ele deseja instalar usando checkboxes
- Mostre uma breve descrição de cada pacote para ajudar na escolha

### 2. Instalação dos Pacotes Selecionados

Para cada pacote selecionado, execute a instalação e configuração correspondente:

---

## AUTENTICAÇÃO & API

### laravel/sanctum

**IMPORTANTE:** Sanctum é ideal para SPAs e autenticação de API com tokens. Se o projeto já usa sessões padrão do Laravel, avalie se realmente precisa do Sanctum.

**Instalação:**
```bash
composer require laravel/sanctum
```

**Configuração:**

1. Publique a configuração e migrations:
```bash
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

2. Execute as migrations:
```bash
php artisan migrate
```

3. Configure o middleware no arquivo `bootstrap/app.php`:

```php
use Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful;

->withMiddleware(function (Middleware $middleware) {
    $middleware->api(prepend: [
        EnsureFrontendRequestsAreStateful::class,
    ]);
})
```

4. Configure o `.env`:
```env
SANCTUM_STATEFUL_DOMAINS=localhost,localhost:3000,127.0.0.1,127.0.0.1:8000,::1
SESSION_DRIVER=cookie
SESSION_DOMAIN=localhost
```

5. Adicione o trait `HasApiTokens` no Model User:

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    // ...
}
```

**Exemplo de uso - Criar token:**

```php
// No controller de login
$token = $user->createToken('auth-token')->plainTextToken;

return response()->json([
    'token' => $token,
    'user' => $user
]);
```

**Exemplo de uso - Proteger rota:**

```php
// routes/api.php
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
```

**Verificação:**
- Verifique se a migration `personal_access_tokens` foi criada
- Teste criando um token via Tinker: `User::first()->createToken('test')->plainTextToken`
- Teste uma rota protegida com o token

---

## LOCALIZAÇÃO

### lucascudo/laravel-pt-br-localization

**Instalação:**
```bash
composer require lucascudo/laravel-pt-br-localization --dev
```

**Configuração:**

1. Publique os arquivos de tradução:
```bash
php artisan vendor:publish --tag=laravel-pt-br-localization
```

2. Configure o locale padrão no arquivo `config/app.php`:
```php
'locale' => 'pt_BR',
'fallback_locale' => 'pt_BR',
```

**Verificação:**
- Confirme que o diretório `lang/pt_BR/` foi criado
- Teste com `php artisan tinker` e execute `__('validation.required')`

---

## DEBUG & DESENVOLVIMENTO

### laravel/telescope

**Instalação:**
```bash
composer require laravel/telescope --dev
```

**Configuração:**

1. Instale o Telescope:
```bash
php artisan telescope:install
```

2. Execute as migrations:
```bash
php artisan migrate
```

3. Publique os assets:
```bash
php artisan telescope:publish
```

4. **IMPORTANTE - Apenas Desenvolvimento:** Edite o `AppServiceProvider.php`:

Abra `app/Providers/AppServiceProvider.php` e adicione no método `register()`:

```php
use Laravel\Telescope\TelescopeServiceProvider;

public function register(): void
{
    if ($this->app->environment('local')) {
        $this->app->register(TelescopeServiceProvider::class);
    }
}
```

5. Adicione ao `.env`:
```env
TELESCOPE_ENABLED=true
```

**Acesso:**
- URL: `http://seu-app.test/telescope`
- Configure autenticação no `config/telescope.php` para produção

**Verificação:**
- Acesse `/telescope` no browser
- Verifique se o dashboard carrega corretamente

---

### barryvdh/laravel-debugbar

**Instalação:**
```bash
composer require barryvdh/laravel-debugbar --dev
```

**Configuração:**

1. Publique a configuração (opcional):
```bash
php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"
```

2. Adicione ao `.env`:
```env
DEBUGBAR_ENABLED=true
```

**Nota:** A debugbar só aparece em ambiente `local` por padrão.

**Verificação:**
- Acesse qualquer página do app no browser
- Verifique se a barra de debug aparece na parte inferior

---

### dutchcodingcompany/filament-developer-logins

**IMPORTANTE:** Este pacote só deve ser instalado se o projeto usar **Filament**.

**Instalação:**
```bash
composer require dutchcodingcompany/filament-developer-logins --dev
```

**Configuração:**

1. Publique a configuração:
```bash
php artisan vendor:publish --tag=filament-developer-logins-config
```

2. Configure usuários de desenvolvimento no arquivo `config/filament-developer-logins.php`:

```php
'users' => [
    [
        'name' => 'Admin',
        'email' => 'admin@example.com',
    ],
    [
        'name' => 'User',
        'email' => 'user@example.com',
    ],
],
```

3. **IMPORTANTE:** Adicione ao `.env`:
```env
FILAMENT_DEVELOPER_LOGINS_ENABLED=true
```

**Uso:**
- Na página de login do Filament, aparecerão botões para login rápido
- Funciona apenas em ambiente `local`

**Verificação:**
- Acesse a página de login do Filament
- Verifique se aparecem botões de "Login as Admin", etc.

---

## DOCUMENTAÇÃO API

### dedoc/scramble

**IMPORTANTE:** Scramble gera documentação OpenAPI/Swagger automaticamente a partir das suas rotas e controllers.

**Instalação:**
```bash
composer require dedoc/scramble
```

**Configuração:**

1. Publique a configuração:
```bash
php artisan vendor:publish --tag=scramble-config
```

2. Configure quais rotas documentar no arquivo `config/scramble.php`:

```php
'api_path' => 'api',
'api_domain' => null,
```

3. **Opcional:** Configure autenticação para o Scramble no `config/scramble.php`:

```php
'middleware' => ['web'],
```

Para produção, adicione middleware de autenticação:
```php
'middleware' => ['web', 'auth'],
```

**Uso - Documentar endpoints com PHPDoc:**

```php
/**
 * Lista todos os usuários
 *
 * Retorna uma lista paginada de todos os usuários do sistema.
 *
 * @response 200 {
 *   "data": [{"id": 1, "name": "User", "email": "user@example.com"}]
 * }
 */
public function index()
{
    return User::paginate();
}
```

**Uso - Type Hints melhoram a documentação:**

```php
public function store(StoreUserRequest $request): JsonResponse
{
    $user = User::create($request->validated());

    return response()->json($user, 201);
}
```

**Acesso:**
- URL: `http://seu-app.test/docs/api`
- Interface Swagger interativa com todos os endpoints

**Verificação:**
- Acesse `/docs/api` no browser
- Verifique se seus endpoints de API aparecem
- Teste fazer requisições pela interface Swagger

**Dicas:**
- Use FormRequests para documentação automática de parâmetros
- Use Resources para documentação de respostas
- PHPDoc adiciona descrições e exemplos

---

## TESTES

### pestphp/pest-plugin-livewire

**IMPORTANTE:** Este plugin só deve ser instalado se o projeto usar **Livewire** ou **Filament** (que usa Livewire).

**Instalação:**
```bash
composer require pestphp/pest-plugin-livewire --dev
```

**Configuração:**

O plugin é ativado automaticamente. Não precisa de configuração adicional.

**Exemplo de uso - Testar componente Livewire:**

Crie um teste em `tests/Feature/Livewire/CreateUserTest.php`:

```php
<?php

use App\Livewire\CreateUser;
use App\Models\User;

test('pode criar um usuário', function () {
    Livewire::test(CreateUser::class)
        ->set('name', 'John Doe')
        ->set('email', 'john@example.com')
        ->call('save')
        ->assertHasNoErrors()
        ->assertDispatched('user-created');

    expect(User::where('email', 'john@example.com')->exists())->toBeTrue();
});

test('valida email obrigatório', function () {
    Livewire::test(CreateUser::class)
        ->set('name', 'John Doe')
        ->call('save')
        ->assertHasErrors(['email' => 'required']);
});
```

**Exemplo de uso - Testar Filament Resource:**

```php
<?php

use App\Filament\Resources\UserResource;
use App\Models\User;

test('pode renderizar a página de listagem', function () {
    $this->actingAs(User::factory()->create())
        ->get(UserResource::getUrl('index'))
        ->assertSuccessful();
});

test('pode renderizar a página de criação', function () {
    $this->actingAs(User::factory()->create())
        ->get(UserResource::getUrl('create'))
        ->assertSuccessful();
});

test('pode criar um usuário', function () {
    $this->actingAs(User::factory()->create());

    $data = [
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'password' => 'password',
    ];

    Livewire::test(UserResource\Pages\CreateUser::class)
        ->fillForm($data)
        ->call('create')
        ->assertHasNoFormErrors();

    expect(User::where('email', 'john@example.com')->exists())->toBeTrue();
});
```

**Métodos disponíveis:**
- `Livewire::test()` - Testa um componente
- `->set()` - Define propriedade
- `->call()` - Chama método
- `->assertSet()` - Verifica propriedade
- `->assertHasErrors()` - Verifica erros de validação
- `->assertHasNoErrors()` - Verifica ausência de erros
- `->assertDispatched()` - Verifica eventos disparados
- `->fillForm()` - Preenche formulário Filament
- `->assertHasFormErrors()` - Verifica erros de formulário

**Verificação:**
- Crie um teste simples de componente Livewire
- Execute `php artisan test` ou `composer test`
- Verifique se o teste passa

---

## DADOS

### spatie/laravel-data

**Instalação:**
```bash
composer require spatie/laravel-data
```

**Configuração:**

1. Publique a configuração (opcional):
```bash
php artisan vendor:publish --tag=data-config
```

**Exemplo de uso:**

Crie um arquivo de exemplo em `app/Data/UserData.php`:

```php
<?php

namespace App\Data;

use Spatie\LaravelData\Data;

class UserData extends Data
{
    public function __construct(
        public string $name,
        public string $email,
    ) {}
}
```

**Verificação:**
- Arquivo de configuração publicado (se executou o comando)
- Exemplo criado com sucesso

---

## BACKUP

### spatie/laravel-backup

**Instalação:**
```bash
composer require spatie/laravel-backup
```

**Configuração:**

1. Publique a configuração:
```bash
php artisan vendor:publish --provider="Spatie\Backup\BackupServiceProvider"
```

2. Configure no `.env`:
```env
BACKUP_DISK=local
BACKUP_NOTIFICATION_MAIL_TO=seu-email@example.com
```

3. **IMPORTANTE:** Configure o disco de backup em `config/backup.php`:

Verifique as seções:
- `destination.disks` - Onde os backups serão salvos
- `backup.name` - Nome da aplicação no backup
- `backup.source.databases` - Bancos a fazer backup

4. Configure um cronjob para executar backups automáticos.

Adicione no `routes/console.php` ou `app/Console/Kernel.php`:

```php
use Spatie\Backup\Commands\BackupCommand;

Schedule::command(BackupCommand::class)->daily()->at('02:00');
```

**Teste:**
```bash
php artisan backup:run
```

**Verificação:**
- Execute `php artisan backup:run`
- Verifique se o backup foi criado em `storage/app/backups/`
- Verifique se não há erros no log

---

## HTTP CLIENT

### Saloon (saloonphp/saloon + laravel-plugin + cache-plugin)

**IMPORTANTE:** Estes 3 pacotes devem ser instalados juntos.

**Instalação:**
```bash
composer require saloonphp/saloon saloonphp/laravel-plugin saloonphp/cache-plugin
```

**Configuração:**

1. Publique a configuração:
```bash
php artisan vendor:publish --tag=saloon-config
```

2. Configure cache (opcional) no `.env`:
```env
SALOON_CACHE_DRIVER=redis
```

**Exemplo de uso:**

Crie um connector de exemplo em `app/Http/Integrations/ExampleConnector.php`:

```php
<?php

namespace App\Http\Integrations;

use Saloon\Http\Connector;

class ExampleConnector extends Connector
{
    public function resolveBaseUrl(): string
    {
        return 'https://api.example.com';
    }

    protected function defaultHeaders(): array
    {
        return [
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
        ];
    }
}
```

**Verificação:**
- Arquivo de configuração publicado
- Exemplo de connector criado

---

## FILAS & JOBS

### laravel/horizon

**IMPORTANTE:** Horizon requer **Redis** configurado.

**Instalação:**
```bash
composer require laravel/horizon
```

**Configuração:**

1. Instale o Horizon:
```bash
php artisan horizon:install
```

2. Execute as migrations:
```bash
php artisan migrate
```

3. Publique os assets:
```bash
php artisan horizon:publish
```

4. Configure Redis no `.env`:
```env
QUEUE_CONNECTION=redis
REDIS_CLIENT=phpredis
```

5. Configure autenticação no `app/Providers/HorizonServiceProvider.php`:

```php
use Laravel\Horizon\Horizon;

protected function gate(): void
{
    Horizon::auth(function ($request) {
        return app()->environment('local') ||
               $request->user()?->email === 'admin@example.com';
    });
}
```

6. **IMPORTANTE:** Adicione ao supervisor ou use em desenvolvimento:
```bash
php artisan horizon
```

**Acesso:**
- URL: `http://seu-app.test/horizon`

**Verificação:**
- Execute `php artisan horizon` em um terminal
- Acesse `/horizon` no browser
- Dispatche um job de teste e veja no dashboard

---

### 3. Configurações Finais

Após instalar os pacotes selecionados:

1. **Atualizar composer scripts** (se aplicável):

Se instalou Telescope ou Horizon, adicione ao `composer.json`:

```json
"scripts": {
    "post-update-cmd": [
        "@php artisan vendor:publish --tag=laravel-assets --ansi --force",
        "@php artisan telescope:publish --ansi",
        "@php artisan horizon:publish --ansi"
    ]
}
```

2. **Atualizar .gitignore:**

Adicione (se não existir):
```
/storage/framework/cache/data/spatie
```

3. **Documentar no README:**

Sugira ao usuário documentar os pacotes instalados no README.md do projeto.

---

### 4. Resumo Final

Mostre ao usuário um resumo do que foi instalado:

## ✅ Pacotes Instalados com Sucesso!

**Pacotes instalados:**
- [Lista dos pacotes que foram instalados]

**Configurações realizadas:**
- [Lista de configurações aplicadas]

**Próximos passos:**

**Se instalou Sanctum:**
- Adicione `HasApiTokens` trait no Model User
- Configure `SANCTUM_STATEFUL_DOMAINS` no `.env`
- Crie rotas API protegidas com `auth:sanctum`
- Teste gerando um token: `User::first()->createToken('test')`

**Se instalou Scramble:**
- Acesse `/docs/api` para ver a documentação
- Adicione PHPDoc nos controllers para melhorar a documentação
- Use FormRequests e Resources para documentação automática
- Configure autenticação em produção

**Se instalou Pest Plugin Livewire:**
- Crie testes para componentes Livewire em `tests/Feature/Livewire/`
- Use `Livewire::test()` para testar componentes
- Teste Filament Resources com `fillForm()` e `assertHasNoFormErrors()`
- Execute `composer test` para rodar os testes

**Se instalou Telescope:**
- Acesse `/telescope` para ver o dashboard
- Configure autenticação em produção

**Se instalou Debugbar:**
- Verifique a barra de debug na parte inferior do browser

**Se instalou Filament Developer Logins:**
- Use os botões de login rápido na página de login do Filament

**Se instalou Laravel Backup:**
- Configure o cronjob para backups automáticos
- Teste com `php artisan backup:run`
- Configure notificações por email

**Se instalou Saloon:**
- Crie connectors em `app/Http/Integrations/`
- Use o plugin de cache para otimizar requisições

**Se instalou Horizon:**
- Execute `php artisan horizon` para iniciar
- Acesse `/horizon` para ver o dashboard
- Configure supervisor para produção

**Se instalou PT-BR Localization:**
- Traduções disponíveis em `lang/pt_BR/`
- Locale configurado para pt_BR

**Comandos úteis:**
- `php artisan telescope:clear` - Limpar dados do Telescope
- `php artisan horizon:pause` - Pausar Horizon
- `php artisan horizon:continue` - Retomar Horizon
- `php artisan backup:run` - Executar backup manual
- `php artisan backup:list` - Listar backups
- `php artisan backup:clean` - Limpar backups antigos

**Notas importantes:**
- Telescope e Debugbar devem ser usados apenas em desenvolvimento
- Horizon requer Redis configurado
- Configure autenticação para Telescope e Horizon em produção
- Execute backups regularmente e teste a restauração
- Developer Logins funciona apenas em ambiente local

---

## Notas Importantes

- Sempre pergunte ao usuário quais pacotes instalar, não instale todos automaticamente
- Verifique se o ambiente tem os requisitos (Redis para Horizon, Filament para Developer Logins)
- Configure corretamente as permissões de acesso para Telescope e Horizon em produção
- Teste cada pacote após instalação
- Alguns pacotes são apenas para desenvolvimento (`--dev`) e não devem ir para produção
- Documente os pacotes instalados no README do projeto