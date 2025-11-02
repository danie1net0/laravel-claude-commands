# Setup Filament v4 Admin Panel

Você vai instalar e configurar o Filament v4, um poderoso admin panel para Laravel com Tailwind CSS v4.

## O que é Filament v4?

Filament v4 é a versão mais recente do framework de desenvolvimento acelerado para Laravel. Inclui:
- **Admin Panel** - Interface administrativa completa e moderna
- **Form Builder** - Construtor de formulários avançado
- **Table Builder** - Tabelas com filtros, ações e bulk actions
- **Notifications** - Sistema de notificações em tempo real
- **Actions** - Botões e modais reutilizáveis
- **Widgets** - Dashboard customizável
- **Multi-Factor Authentication** - MFA integrado nativamente
- **Tailwind CSS v4** - Performance aprimorada e builds mais rápidos

## Requisitos do Sistema

Antes de instalar, verifique os requisitos:
- **PHP 8.2+** (recomendado: 8.4)
- **Laravel 11.28+** (recomendado: 12.x)
- **Tailwind CSS v4.0+**
- **Node.js 20+**

## Instruções

### 1. Verificação Inicial

- Confirme que estamos em um projeto Laravel 11.28+
- Verifique a versão do PHP: `php -v` (deve ser 8.2+)
- Pergunte ao usuário:
  - Qual painel criar: Admin, App, ou ambos?
  - Quer instalar plugins adicionais?
  - Qual idioma usar (PT-BR recomendado)?
  - Quer habilitar MFA (autenticação multi-fator)?

### 2. Instalação do Filament v4

**Instalação do Panel Builder (Recomendado):**

```bash
composer require filament/filament:"^4.0"
```

**Nota para Windows PowerShell:** Use `"~4.0"` ao invés de `"^4.0"`.

**Aguarde a instalação completar.** Filament instala automaticamente todas as dependências necessárias.

### 3. Instalar Painéis

**Criar o painel administrativo:**

```bash
php artisan filament:install --panels
```

Este comando:
- Cria `app/Providers/Filament/AdminPanelProvider.php`
- Registra o provider em `bootstrap/providers.php`
- Configura rotas em `/admin`
- Prepara o ambiente para Tailwind CSS v4

**Verificar registro do Provider:**

Confirme que o provider foi registrado em `bootstrap/providers.php`:

```php
return [
    App\Providers\AppServiceProvider::class,
    App\Providers\Filament\AdminPanelProvider::class, // ← Deve estar aqui
];
```

**Configuração manual (se necessário):**

Se o comando automático não funcionar, crie manualmente:

```bash
php artisan make:filament-panel admin
```

### 4. Criar Usuário Admin

**Criar o primeiro usuário administrador:**

```bash
php artisan make:filament-user
```

**Ou criar via Tinker:**

```bash
php artisan tinker
```

```php
use App\Models\User;
use Illuminate\Support\Facades\Hash;

User::create([
    'name' => 'Admin',
    'email' => 'admin@admin.com',
    'password' => Hash::make('password'),
]);
```

**Importante:** Anote as credenciais criadas!

### 5. Configurar Tailwind CSS v4

**IMPORTANTE:** Filament v4 requer Tailwind CSS v4. Execute os seguintes passos:

**5.1. Instalar Tailwind CSS v4:**

```bash
npm install tailwindcss@next @tailwindcss/vite@next --save-dev
```

**5.2. Atualizar vite.config.js:**

```js
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        tailwindcss(),
    ],
});
```

**5.3. Atualizar resources/css/app.css:**

```css
@import 'tailwindcss';
```

**5.4. Criar ou atualizar tailwind.config.js:**

```js
/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './resources/**/*.blade.php',
        './resources/**/*.js',
        './resources/**/*.vue',
        './vendor/filament/**/*.blade.php',
    ],
};
```

**5.5. Compilar assets:**

```bash
npm install
npm run dev
```

**Para produção:**

```bash
npm run build
```

### 6. Configurar Painel Admin

Edite o arquivo `app/Providers/Filament/AdminPanelProvider.php`:

**6.1. Configurar cores e branding:**

```php
use Filament\Panel;
use Filament\Support\Colors\Color;

public function panel(Panel $panel): Panel
{
    return $panel
        ->default()
        ->id('admin')
        ->path('admin')
        ->login()
        ->colors([
            'primary' => Color::Blue,
        ])
        ->brandName('Minha Aplicação')
        ->brandLogo(asset('images/logo.png'))
        ->brandLogoHeight('2rem')
        ->favicon(asset('images/favicon.png'))
        ->darkMode(true)
        ->sidebarCollapsibleOnDesktop()
        ->navigationGroups([
            'Sistema',
            'Configurações',
        ])
        ->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
        ->discoverPages(in: app_path('Filament/Pages'), for: 'App\\Filament\\Pages')
        ->discoverWidgets(in: app_path('Filament/Widgets'), for: 'App\\Filament\\Widgets')
        ->middleware([
            EncryptCookies::class,
            AddQueuedCookiesToResponse::class,
            StartSession::class,
            AuthenticateSession::class,
            ShareErrorsFromSession::class,
            VerifyCsrfToken::class,
            SubstituteBindings::class,
            DisableBladeIconComponents::class,
            DispatchServingFilamentEvent::class,
        ])
        ->authMiddleware([
            Authenticate::class,
        ]);
}
```

**6.2. Se quiser usar PT-BR, instale a tradução:**

```bash
composer require filament/spatie-laravel-translatable-plugin
```

Ou use o pacote de tradução:

```bash
php artisan vendor:publish --tag=filament-panels-translations
```

Depois configure no painel:

```php
->locale('pt_BR')
```

### 7. Criar Resource Exemplo (Opcional)

**Criar um Resource para o modelo User:**

```bash
php artisan make:filament-resource User --generate
```

Este comando cria:
- `app/Filament/Resources/UserResource.php`
- `app/Filament/Resources/UserResource/Pages/`
- Gera automaticamente formulários e tabelas baseado no Model

**Exemplo de Resource customizado:**

```php
<?php

namespace App\Filament\Resources;

use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class UserResource extends Resource
{
    protected static ?string $model = User::class;

    protected static ?string $navigationIcon = 'heroicon-o-users';

    protected static ?string $navigationGroup = 'Sistema';

    protected static ?int $navigationSort = 1;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('email')
                    ->email()
                    ->required()
                    ->maxLength(255),
                Forms\Components\DateTimePicker::make('email_verified_at'),
                Forms\Components\TextInput::make('password')
                    ->password()
                    ->required()
                    ->maxLength(255)
                    ->dehydrateStateUsing(fn ($state) => Hash::make($state))
                    ->visible(fn ($context) => $context === 'create'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('email')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListUsers::route('/'),
            'create' => Pages\CreateUser::route('/create'),
            'edit' => Pages\EditUser::route('/{record}/edit'),
        ];
    }
}
```

### 8. Instalar Plugins Úteis (Opcional)

Pergunte ao usuário se deseja instalar plugins adicionais:

#### 8.1. Spatie Media Library

**Para upload e gerenciamento de arquivos:**

```bash
composer require filament/spatie-laravel-media-library-plugin
```

#### 8.2. Filament Shield

**Para gerenciamento de permissões (Roles & Permissions):**

```bash
composer require bezhansalleh/filament-shield
```

Configurar:
```bash
php artisan vendor:publish --tag=filament-shield-config
php artisan shield:install
php artisan shield:generate --all
```

#### 8.3. Filament Settings

**Para gerenciar configurações do sistema:**

```bash
composer require filament/spatie-laravel-settings-plugin
```

#### 8.4. Filament Excel

**Para importação e exportação de Excel:**

```bash
composer require pxlrbt/filament-excel
```

#### 8.5. Apex Charts

**Para gráficos e dashboards:**

```bash
composer require leandrocfe/filament-apex-charts
```

#### 8.6. PT-BR Form Fields

**Campos de formulário brasileiros (CPF, CNPJ, CEP, etc.):**

```bash
composer require leandrocfe/filament-ptbr-form-fields
```

### 9. Configurar Widget de Dashboard (Opcional)

**Criar um widget de estatísticas:**

```bash
php artisan make:filament-widget StatsOverview --stats-overview
```

Edite `app/Filament/Widgets/StatsOverview.php`:

```php
<?php

namespace App\Filament\Widgets;

use App\Models\User;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends BaseWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total de Usuários', User::count())
                ->description('Usuários cadastrados')
                ->descriptionIcon('heroicon-m-users')
                ->color('success'),
            Stat::make('Novos Hoje', User::whereDate('created_at', today())->count())
                ->description('Cadastrados hoje')
                ->descriptionIcon('heroicon-m-arrow-trending-up')
                ->color('info'),
            Stat::make('Ativos', User::whereNotNull('email_verified_at')->count())
                ->description('Usuários verificados')
                ->descriptionIcon('heroicon-m-check-badge')
                ->color('warning'),
        ];
    }
}
```

### 10. Publicar Configurações e Assets

**Publicar configurações (opcional):**

```bash
php artisan vendor:publish --tag=filament-config
php artisan vendor:publish --tag=filament-views
php artisan vendor:publish --tag=filament-translations
```

**Compilar assets:**

Se houver customizações de tema, compile os assets:

```bash
npm install
npm run build
```

### 11. Configurar .env

Adicione/verifique as seguintes variáveis no `.env`:

```env
APP_NAME="Minha Aplicação"
APP_URL=http://localhost

# Filament
FILAMENT_FILESYSTEM_DISK=public
```

### 12. Criar Painel App (Opcional)

Se o usuário quiser um segundo painel (ex: área do cliente):

```bash
php artisan make:filament-panel app
```

Configure o caminho:
```php
->path('app')
```

### 13. Configurar Navegação Personalizada

Crie grupos de navegação no `AdminPanelProvider.php`:

```php
->navigationGroups([
    'Usuários',
    'Conteúdo',
    'Configurações',
    'Sistema',
])
```

Nos Resources, defina o grupo:

```php
protected static ?string $navigationGroup = 'Usuários';
protected static ?int $navigationSort = 1;
```

### 14. Configurar Tema Customizado (Opcional)

**Criar tema customizado:**

```bash
php artisan make:filament-theme
```

Isso cria arquivos de tema em `resources/css/filament/`.

Configure no `tailwind.config.js`:

```js
export default {
    content: [
        './resources/**/*.blade.php',
        './vendor/filament/**/*.blade.php',
    ],
    // ...
}
```

### 15. Verificação Final

Execute os seguintes testes:

**1. Acesse o painel:**
```
http://localhost/admin
```

**2. Faça login com as credenciais criadas**

**3. Verifique se aparecem:**
- Dashboard
- Menu de navegação
- Widgets (se criou)
- Resources (se criou)

**4. Teste criar/editar/deletar um registro**

### 16. Resumo Final

Mostre ao usuário um resumo do que foi instalado:

## ✅ Filament v4 Instalado com Sucesso!

**O que foi configurado:**
- ✅ Filament v4.x instalado
- ✅ Tailwind CSS v4 configurado
- ✅ Painel Admin criado e configurado
- ✅ Usuário administrador criado
- ✅ Assets compilados com Vite
- ✅ [Lista de plugins instalados, se houver]
- ✅ Resources criados: [lista]
- ✅ Widgets criados: [lista]
- ✅ Tema e cores configurados
- ✅ Navegação organizada em grupos

**Acesso ao painel:**
- URL: `http://localhost/admin`
- Email: [email do admin criado]
- Senha: [senha do admin criado]

**Próximos passos:**

1. **Criar Resources para seus Models:**
   ```bash
   php artisan make:filament-resource NomeDoModel --generate
   ```

2. **Criar Pages customizadas:**
   ```bash
   php artisan make:filament-page NomeDaPagina
   ```

3. **Criar Widgets para o Dashboard:**
   ```bash
   php artisan make:filament-widget NomeDoWidget
   ```

4. **Customizar cores e tema:**
   - Edite `app/Providers/Filament/AdminPanelProvider.php`
   - Altere cores, logo, favicon

5. **Explorar a documentação:**
   - https://filamentphp.com/docs

**Comandos úteis:**
- `php artisan make:filament-resource Model --generate` - Criar Resource com scaffold
- `php artisan make:filament-page PageName` - Criar página customizada
- `php artisan make:filament-widget WidgetName` - Criar widget
- `php artisan make:filament-relation-manager ResourceName relationName` - Criar gerenciador de relação
- `php artisan filament:upgrade` - Atualizar Filament

**Plugins recomendados:**
- `bezhansalleh/filament-shield` - Roles & Permissions
- `filament/spatie-laravel-media-library-plugin` - Upload de arquivos
- `pxlrbt/filament-excel` - Importar/Exportar Excel
- `leandrocfe/filament-apex-charts` - Gráficos
- `leandrocfe/filament-ptbr-form-fields` - Campos brasileiros (CPF, CNPJ, CEP)

**Dicas:**
- Use `->searchable()` nas colunas para habilitar busca
- Use `->sortable()` para ordenação
- Use `->toggleable()` para permitir ocultar colunas
- Agrupe Resources com `$navigationGroup`
- Use `$navigationSort` para ordenar itens no menu
- Adicione ícones com `$navigationIcon` (Heroicons)

**Recursos adicionais:**
- Documentação: https://filamentphp.com/docs
- Plugins: https://filamentphp.com/plugins
- Comunidade: https://discord.gg/filament

---

## Notas Importantes sobre Filament v4

**Requisitos obrigatórios:**
- ✅ **PHP 8.2+** (recomendado: 8.4)
- ✅ **Laravel 11.28+** (recomendado: 12.x)
- ✅ **Tailwind CSS v4.0+** (obrigatório!)
- ✅ **Node.js 20+**

**Mudanças importantes do v3 para v4:**
- Tailwind CSS v4 é obrigatório (não funciona com v3)
- Sistema de configuração do Tailwind foi reformulado
- Builds mais rápidos com Tailwind v4
- Multi-Factor Authentication (MFA) integrado nativamente
- Performance aprimorada
- Provider registrado em `bootstrap/providers.php` (não em `config/app.php`)

**Melhores práticas:**
- Sempre use `--generate` ao criar Resources para scaffold automático
- Configure permissões adequadas em produção
- Use Filament Shield para controle de acesso granular
- Customize o tema para combinar com sua marca
- Organize Resources em grupos de navegação
- Use Widgets para criar dashboards informativos
- Filament usa Livewire internamente - componentes são reativos
- Sempre compile assets após mudanças: `npm run dev` (desenvolvimento) ou `npm run build` (produção)
- Verifique se o provider está registrado em `bootstrap/providers.php`

**Compatibilidade:**
- Windows PowerShell: Use `"~4.0"` ao invés de `"^4.0"` nos comandos Composer
- Projetos existentes: Migre para Tailwind v4 antes de instalar Filament v4
- Plugins: Verifique compatibilidade com v4 antes de instalar
