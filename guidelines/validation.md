# Validação - Essentials

## Princípios

- **SEMPRE use Form Requests** - nunca validação inline
- Mensagens **sempre em português**
- Rules **organizadas e legíveis**
- **Não use `authorize()` com apenas `return true`** - omita o método
- Rules **customizadas** quando apropriado

## Form Request vs Inline

**❌ Nunca:**
```php
$validated = $request->validate([
    'email' => 'required|email',
]);
```

**✅ Sempre:**
```php
class StoreUserRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users'],
            'password' => ['required', 'min:8', 'confirmed'],
        ];
    }

    public function messages(): array
    {
        return [
            'name.required' => 'O nome é obrigatório.',
            'email.unique' => 'Este e-mail já está em uso.',
            'password.confirmed' => 'As senhas não coincidem.',
        ];
    }
}
```

## Estrutura

### Sem Autorização (omitir método)

```php
class StoreUserRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
        ];
    }

    public function messages(): array
    {
        return [
            'name.required' => 'O nome é obrigatório.',
        ];
    }

    public function attributes(): array
    {
        return [
            'name' => 'nome',
            'email' => 'e-mail',
        ];
    }
}
```

### Com Autorização

```php
class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('update', $this->route('user'));
    }

    public function rules(): array
    {
        $userId = $this->route('user')->id;

        return [
            'email' => ['required', 'email', "unique:users,email,{$userId}"],
        ];
    }
}
```

## Rules Principais

```php
'name' => ['required']              // Obrigatório
'email' => ['nullable']             // Opcional
'age' => ['integer']                // Inteiro
'price' => ['numeric']              // Número
'active' => ['boolean']             // Boolean
'data' => ['array']                 // Array
'email' => ['email']                // Email
'url' => ['url']                    // URL

'name' => ['min:3']                 // Mínimo
'name' => ['max:255']               // Máximo
'age' => ['between:18,65']          // Entre

'password' => ['confirmed']         // Confirmação
'status' => ['in:active,inactive']  // Lista permitida

'email' => ['unique:users']         // Único
'plan_id' => ['exists:plans,id']    // Existe

'ends_at' => ['after:starts_at']    // Depois de
'birth' => ['before:today']         // Antes de

'avatar' => ['image']               // Imagem
'avatar' => ['max:2048']            // Max 2MB
```

## Validação de Arrays

```php
return [
    'products' => ['required', 'array', 'min:1'],
    'products.*.id' => ['required', 'exists:products,id'],
    'products.*.quantity' => ['required', 'integer', 'min:1'],
];
```

## Rules Customizadas

```bash
php artisan make:rule Uppercase
```

```php
class Uppercase implements ValidationRule
{
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (strtoupper($value) !== $value) {
            $fail('O campo :attribute deve estar em maiúsculas.');
        }
    }
}
```

**Uso:**
```php
return [
    'code' => ['required', new Uppercase],
];
```

## Autorização

**❌ Nunca:**
```php
public function authorize(): bool
{
    return true;  // Desnecessário
}
```

**✅ Omitir quando não há autorização:**
```php
class StoreUserRequest extends FormRequest
{
    // Sem método authorize()

    public function rules(): array { ... }
}
```

**✅ Com Policy:**
```php
public function authorize(): bool
{
    return $this->user()->can('update', $this->route('post'));
}
```

## Mensagens em Português

```php
public function messages(): array
{
    return [
        'name.required' => 'O nome é obrigatório.',
        'name.max' => 'O nome não pode ter mais de :max caracteres.',
        'email.email' => 'O e-mail deve ser válido.',
        'email.unique' => 'Este e-mail já está em uso.',
        'password.min' => 'A senha deve ter no mínimo :min caracteres.',
        'password.confirmed' => 'As senhas não coincidem.',
    ];
}
```

## Boas Práticas

```php
✅ StoreUserRequest extends FormRequest
✅ ['required', 'string', 'max:255']  // Array syntax
✅ 'O nome é obrigatório.'            // Português
✅ Omitir authorize() sem autorização
✅ app/Http/Requests/User/StoreUserRequest.php
❌ $request->validate() no controller
❌ 'required|string|max:255'          // String syntax
❌ authorize() { return true; }
```

## Checklist

- [ ] Form Request criado?
- [ ] Método `authorize()` omitido se não valida autorização?
- [ ] Rules em array syntax?
- [ ] Mensagens em português?
- [ ] Attributes customizados?
- [ ] Rules de unique ignoram registro atual (update)?
- [ ] Organizado por diretórios?
