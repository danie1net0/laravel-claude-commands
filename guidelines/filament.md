# Filament - Essentials

## Princípios

- **Métodos privados** - organizar schema, columns, actions
- **Evitar aninhamento** - criar variáveis intermediárias
- **Imports explícitos** - sempre importar classes completas
- **DTOs com spatie/laravel-data** - para entrada/saída
- **Actions customizadas** - lógica em Actions, não em pages
- **Não usar model diretamente** - sempre via Actions

## Estrutura de Resources

```php
class UserResource extends Resource
{
    public static function form(Form $form): Form
    {
        return $form
            ->schema(self::formSchema())
            ->actions(self::formActions());
    }

    private static function formSchema(): array
    {
        $fields[] = TextInput::make('name')
            ->label('Nome')
            ->required();

        $fields[] = Select::make('role')
            ->options(['admin' => 'Administrador'])
            ->required();

        return $fields;
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns(self::tableColumns())
            ->filters(self::tableFilters())
            ->actions(self::tableActions());
    }

    private static function tableColumns(): array
    {
        $columns[] = TextColumn::make('name')
            ->searchable()
            ->sortable();

        return $columns;
    }
}
```

## Evitar Aninhamento

**✅ Correto:**
```php
private static function formSchema(): array
{
    $personalSchema[] = TextInput::make('name');
    $personalSchema[] = TextInput::make('email');

    $addressSchema[] = TextInput::make('street');
    $addressSchema[] = TextInput::make('city');

    $fields[] = Grid::make(2)->schema($personalSchema);
    $fields[] = Section::make('Endereço')->schema($addressSchema);

    return $fields;
}
```

**❌ Errado:**
```php
return [
    Grid::make(2)->schema([
        TextInput::make('name'),
        TextInput::make('email'),
    ]),
];
```

## Imports

**✅ Correto:**
```php
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Select;

$fields[] = TextInput::make('name');
$fields[] = Select::make('role');
```

**❌ Errado:**
```php
$fields[] = Forms\Components\TextInput::make('name');
```

## Pages com Actions

### CreateRecord

```php
class CreateUser extends CreateRecord
{
    protected static string $resource = UserResource::class;

    protected function handleRecordCreation(array $data): Model
    {
        $input = new CreateUserData(
            name: $data['name'],
            email: $data['email'],
            role: $data['role'],
        );

        app(CreateUserAction::class)->execute($input);

        return User::whereEmail($input->email)->first();
    }
}
```

### EditRecord

```php
class EditUser extends EditRecord
{
    protected static string $resource = UserResource::class;

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $data['role'] = $this->record->roles->first()?->name;
        return $data;
    }

    protected function handleRecordUpdate(Model $record, array $data): Model
    {
        $input = new UpdateUserData(
            id: $this->record->id,
            name: $data['name'],
            email: $data['email'],
        );

        app(UpdateUserAction::class)->execute($input);

        return $record->refresh();
    }
}
```

## DTOs

```php
use Spatie\LaravelData\Data;

class CreateUserData extends Data
{
    public function __construct(
        public string $name,
        public string $email,
        public string $role,
        public array $permissions = [],
    ) {}
}
```

## Actions

```php
class CreateUserAction
{
    public function execute(CreateUserData $data): User
    {
        $user = User::create([
            'name' => $data->name,
            'email' => $data->email,
        ]);

        $user->assignRole($data->role);

        if (!empty($data->permissions)) {
            $user->givePermissionTo($data->permissions);
        }

        return $user;
    }
}
```

## Boas Práticas

### Organização

```php
✅ private static function formSchema(): array
✅ private static function tableColumns(): array
✅ private static function tableFilters(): array
❌ Tudo direto no método form() ou table()
```

### Aninhamento

```php
✅ $gridSchema[] = TextInput::make('name');
✅ $fields[] = Grid::make()->schema($gridSchema);
❌ Grid::make()->schema([TextInput::make('name')])
```

### Imports

```php
✅ use Filament\Forms\Components\TextInput;
✅ TextInput::make('name')
❌ Forms\Components\TextInput::make('name')
```

### DTOs e Actions

```php
✅ new CreateUserData(...)
✅ app(CreateUserAction::class)->execute($data)
❌ User::create($data) direto na page
```

## Checklist

- [ ] Métodos privados para schema, columns, actions?
- [ ] Evitando aninhamento de arrays?
- [ ] Imports explícitos?
- [ ] DTOs criados com spatie/laravel-data?
- [ ] Actions criadas para create/update/delete?
- [ ] Lógica de negócio nas Actions?
- [ ] mutateFormDataBeforeFill quando necessário?
- [ ] Labels em português?
