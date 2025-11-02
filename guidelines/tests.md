# Testes - Essentials

## Princípios

- **SEMPRE use Pest** (nunca PHPUnit direto)
- Mensagens **sempre em português**
- Expectations **sempre encadeadas**
- Models **sempre com factories**
- **Estrutura espelha o código testado**

## Regra #1: Expectations Encadeadas

**❌ Nunca:**
```php
expect($user->name)->toBe('John');
expect($user->email)->toBe('john@example.com');
expect($user->isActive())->toBeTrue();
```

**✅ Sempre:**
```php
expect($user)
    ->name->toBe('John')
    ->email->toBe('john@example.com')
    ->and($user->isActive())->toBeTrue();
```

## Estrutura de Diretórios

**IMPORTANTE:** Estrutura DEVE espelhar o código testado.

```
app/Models/User.php                     → tests/Unit/Models/UserTest.php
app/Services/PaymentService.php         → tests/Unit/Services/PaymentServiceTest.php
app/Actions/CreateUserAction.php        → tests/Unit/Actions/CreateUserActionTest.php
app/Http/Controllers/Api/UserController → tests/Feature/Api/UserControllerTest.php
```

## Nomenclatura

```php
✅ it('redireciona usuários não autenticados para login')
✅ it('calcula preço da assinatura corretamente')
✅ test('usuário pode cancelar assinatura ativa')
✅ test('administrador visualiza lista de usuários')

❌ it('funciona')
❌ test('teste de assinatura')
```

## Sintaxe Básica

```php
it('retorna uma resposta bem-sucedida', function () {
    $this->get('/')
        ->assertStatus(200);
});

test('usuário pode assinar um plano', function () {
    $user = User::factory()->create();
    $plan = Plan::factory()->create();

    $this->actingAs($user)
        ->post('/subscribe', ['plan_id' => $plan->id])
        ->assertSuccessful();
});
```

## Expectations

### Básicas

```php
expect($value)
    ->toBeTrue()
    ->not->toBeNull()
    ->toBeGreaterThan(0);

expect($array)
    ->toHaveCount(5)
    ->toContain('item')
    ->and($array[0])->toBe('first');

expect($string)
    ->toContain('substring')
    ->toStartWith('prefix')
    ->toEndWith('suffix');
```

### HTTP Responses

```php
$this->get('/api/users')
    ->assertSuccessful()
    ->assertJsonCount(10, 'data')
    ->assertJsonStructure(['data', 'meta']);
```

### Collections

```php
expect($users)
    ->toBeInstanceOf(Collection::class)
    ->toHaveCount(10)
    ->first()->name->toBe('John')
    ->email->toContain('@')
    ->and($users->last())->name->toBe('Jane')
    ->email->toContain('@');
```

## Factories

**SEMPRE use factories:**

```php
$user = User::factory()->create();

$admin = User::factory()->create([
    'role' => 'admin',
]);

$subscriber = User::factory()->subscribed()->create();
$plan = Plan::factory()->active()->create();
```

## Datasets

```php
dataset('emails-invalidos', function () {
    return [
        'invalido',
        '@exemplo.com',
        'teste@',
    ];
});

it('rejeita emails inválidos', function (string $email) {
    expect($email)->not->toBeValidEmail();
})->with('emails-invalidos');
```

### Inline

```php
it('valida formato de email', function (string $email) {
    expect($email)->toBeValidEmail();
})->with([
    'teste@exemplo.com',
    'usuario@dominio.com',
]);

test('calcula desconto', function (int $valor, int $desconto, int $esperado) {
    expect(calcularDesconto($valor, $desconto))->toBe($esperado);
})->with([
    [100, 10, 90],
    [200, 20, 160],
]);
```

## Assertions HTTP

```php
$response->assertSuccessful();
$response->assertOk();
$response->assertCreated();
$response->assertNotFound();
$response->assertForbidden();
$response->assertUnauthorized();
$response->assertRedirect($uri);
$response->assertSee('texto');
```

## Assertions de Banco

```php
$this->assertDatabaseHas('users', [
    'email' => 'test@example.com',
]);

$this->assertDatabaseMissing('subscriptions', [
    'status' => 'cancelled',
]);
```

## Livewire/Volt

```php
use Livewire\Volt\Volt;

test('contador incrementa corretamente', function () {
    Volt::test('components.counter')
        ->assertSet('count', 0)
        ->call('increment')
        ->assertSet('count', 1);
});
```

## Filament

```php
use Livewire\Livewire;
use App\Filament\Resources\UserResource\Pages\ListUsers;

test('administrador visualiza tabela de usuários', function () {
    $admin = User::factory()->admin()->create();
    $users = User::factory()->count(5)->create();

    $this->actingAs($admin);

    Livewire::test(ListUsers::class)
        ->assertCanSeeTableRecords($users);
});

it('filtra usuários por email', function () {
    $admin = User::factory()->admin()->create();
    $user = User::factory()->create(['email' => 'teste@example.com']);

    $this->actingAs($admin);

    Livewire::test(ListUsers::class)
        ->searchTable('teste@example.com')
        ->assertCanSeeTableRecords([$user])
        ->assertCountTableRecords(1);
});
```

## Custom Expectations

```php
// tests/Pest.php
expect()->extend('toBeValidEmail', function () {
    return $this->toMatch('/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/');
});

// Uso
expect('test@example.com')->toBeValidEmail();
```

## Custom Helpers

```php
// tests/Pest.php
function criarUsuarioAutenticado()
{
    return User::factory()->create();
}

function criarAdmin()
{
    return User::factory()->admin()->create();
}

// Uso
test('usuário autenticado acessa dashboard', function () {
    $user = criarUsuarioAutenticado();

    $this->actingAs($user)
        ->get('/dashboard')
        ->assertSuccessful();
});
```

## Regras Importantes

1. **Estrutura espelha código testado**
2. **Mensagens em português**
3. **SEMPRE expectations encadeadas**
4. **SEMPRE use factories**
5. **Código autoexplicativo** (evite comentários)
6. **Use datasets** para evitar duplicação
7. **Execute testes antes de commits**

## Executar Testes

```bash
php artisan test
php artisan test tests/Feature/HomeTest.php
php artisan test --filter="subscription"
php artisan test --coverage
```

## Checklist

- [ ] Arquivo no diretório correto (espelha código)?
- [ ] Nome em português e descritivo?
- [ ] Usando factories para models?
- [ ] Expectations encadeadas?
- [ ] Sem comentários desnecessários?
- [ ] Testou happy path e edge cases?
