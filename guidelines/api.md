# API Resources - Essentials

## Princípio Fundamental

**SEMPRE use API Resources para retornar dados JSON em APIs**, exceto em casos de respostas MUITO simples (ex: `{"success": true}`).

## Quando Usar

### ✅ SEMPRE Use Resources:
- APIs RESTful
- Retornar models ou collections
- Ocultar dados sensíveis
- Transformar dados
- Incluir/excluir campos condicionalmente
- Formatar relacionamentos

### ❌ Exceções (respostas muito simples):
```php
return response()->json(['success' => true]);
return response()->json(['message' => 'Operação concluída']);
```

## Criando Resources

```bash
php artisan make:resource UserResource
php artisan make:resource UserCollection
```

## Estrutura

```
app/Http/Resources/
├── User/
│   ├── UserResource.php
│   └── UserCollection.php
├── Post/
│   ├── PostResource.php
│   └── PostCollection.php
```

## Resource Básico

```php
<?php

namespace App\Http\Resources\User;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'created_at' => $this->created_at->toISOString(),
        ];
    }
}
```

**Uso:**
```php
public function show(User $user)
{
    return new UserResource($user);
}
```

## Collection

```php
public function index()
{
    $users = User::all();

    return UserResource::collection($users);
}
```

## Atributos Condicionais

### When

```php
public function toArray(Request $request): array
{
    return [
        'id' => $this->id,
        'name' => $this->name,
        'email' => $this->email,

        // Apenas para admin
        'email_verified_at' => $this->when(
            $request->user()?->isAdmin(),
            $this->email_verified_at
        ),

        // Apenas se existe
        'phone' => $this->when($this->phone, $this->phone),
    ];
}
```

### MergeWhen

```php
public function toArray(Request $request): array
{
    return [
        'id' => $this->id,
        'name' => $this->name,

        // Múltiplos campos sensíveis
        $this->mergeWhen($request->user()?->isAdmin(), [
            'last_login_at' => $this->last_login_at,
            'last_login_ip' => $this->last_login_ip,
            'stripe_customer_id' => $this->stripe_customer_id,
        ]),
    ];
}
```

## Relacionamentos

### WhenLoaded (evita N+1)

```php
public function toArray(Request $request): array
{
    return [
        'id' => $this->id,
        'title' => $this->title,

        // Apenas se foi eager loaded
        'author' => UserResource::make($this->whenLoaded('user')),
        'comments' => CommentResource::collection($this->whenLoaded('comments')),
    ];
}
```

**Controller:**
```php
public function show(Post $post)
{
    $post->load(['user', 'comments']);

    return new PostResource($post);
}
```

### WhenCounted

```php
public function toArray(Request $request): array
{
    return [
        'id' => $this->id,
        'title' => $this->title,

        // Apenas se ->withCount('comments') foi usado
        'comments_count' => $this->whenCounted('comments'),
    ];
}
```

**Controller:**
```php
public function index()
{
    $posts = Post::withCount('comments')->get();

    return PostResource::collection($posts);
}
```

## Paginação

```php
public function index()
{
    $users = User::paginate(15);

    return UserResource::collection($users);
}
```

**Resposta automática:**
```json
{
    "data": [...],
    "links": {
        "first": "...",
        "last": "...",
        "next": "..."
    },
    "meta": {
        "current_page": 1,
        "total": 150,
        "per_page": 15
    }
}
```

## Collection Customizada

```php
class UserCollection extends ResourceCollection
{
    public function toArray(Request $request): array
    {
        return [
            'data' => $this->collection,
        ];
    }

    public function with(Request $request): array
    {
        return [
            'meta' => [
                'total' => $this->collection->count(),
                'active_count' => $this->collection->where('active', true)->count(),
            ],
        ];
    }
}
```

## Exemplo Completo

```php
<?php

namespace App\Http\Resources\User;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'avatar_url' => $this->avatar_url,
            'is_admin' => $this->isAdmin(),
            'created_at' => $this->created_at->toISOString(),

            // Dados sensíveis (admin apenas)
            $this->mergeWhen($request->user()?->isAdmin(), [
                'email_verified_at' => $this->email_verified_at,
                'last_login_at' => $this->last_login_at,
            ]),

            // Relacionamentos
            'subscription' => SubscriptionResource::make($this->whenLoaded('subscription')),
            'posts' => PostResource::collection($this->whenLoaded('posts')),
            'posts_count' => $this->whenCounted('posts'),
        ];
    }
}
```

## Status Code Customizado

```php
public function store(StoreUserRequest $request)
{
    $user = User::create($request->validated());

    return (new UserResource($user))
        ->response()
        ->setStatusCode(201); // Created
}
```

## Boas Práticas

```php
✅ return new UserResource($user);
✅ return UserResource::collection($users);
✅ Use whenLoaded() para relacionamentos
✅ Use whenCounted() para contagens
✅ Oculte dados sensíveis com when()
✅ Type hints: toArray(Request $request): array

❌ return response()->json($user);
❌ return $user->toArray();
❌ 'posts' => $this->posts (causa N+1)
❌ Expor passwords, tokens, IDs internos
```

## Regras Importantes

1. **SEMPRE use Resources** (exceto respostas muito simples)
2. **Type hints obrigatórios**
3. **Oculte dados sensíveis** (when/mergeWhen)
4. **Use whenLoaded()** (evita N+1)
5. **Use whenCounted()** (não carregue só para contar)
6. **Datas em ISO 8601** (toISOString())
7. **Nested resources** para relacionamentos
8. **Collections para listas**

## Checklist

- [ ] Resource criado ao invés de json direto?
- [ ] Método toArray() com type hints?
- [ ] Dados sensíveis protegidos?
- [ ] Relacionamentos com whenLoaded()?
- [ ] Contagens com whenCounted()?
- [ ] Datas formatadas?
- [ ] Testado com eager loading?
