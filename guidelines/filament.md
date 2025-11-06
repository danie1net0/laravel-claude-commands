# Filament - Essentials

## Princípios

- **Métodos privados** - organizar schema, columns, actions
- **Evitar aninhamento** - criar variáveis intermediárias
- **Actions customizadas** - lógica em Actions, não em pages
- **Não usar model diretamente** - sempre via Actions

## Estrutura de Resources

```php
class UserResource extends Resource
{
    public static function form(Form $form): Form
    {
        return $form->schema(self::formSchema());
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

```php
// ✅ Correto:
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

// ❌ Errado:
return [
    Grid::make(2)->schema([
        TextInput::make('name'),
        Section::make('Endereço')->schema([
            TextInput::make('street'),
        ]),
    ]),
];
```

## Campos Comuns

```php
TextInput::make('name')
    ->label('Nome')
    ->required()
    ->maxLength(255);

Select::make('status')
    ->options(['active' => 'Ativo'])
    ->required();

Textarea::make('bio')
    ->rows(3)
    ->maxLength(500);

DatePicker::make('birth_date')
    ->native(false)
    ->maxDate(now());

FileUpload::make('avatar')
    ->image()
    ->maxSize(1024);
```

## Boas Práticas

```php
✅ Métodos privados para schema/columns
✅ Variáveis intermediárias
✅ Labels em português
✅ Actions para lógica

❌ Aninhamento profundo
❌ Lógica no Resource
❌ Model::create() direto
```
