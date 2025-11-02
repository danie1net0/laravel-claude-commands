# Laravel Claude Commands

Comandos Claude reutilizáveis para automatizar a configuração de projetos Laravel com qualidade, ferramentas modernas e boas práticas.

## 📦 Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `/setup-quality-tools` | Pint, PHPStan, Pest, Prettier, Husky, Commitlint |
| `/setup-laravel-boost` | Laravel Boost MCP para integração com Claude |
| `/setup-laravel-packages` | 13 pacotes essenciais (Sanctum, Scramble, Debugbar, etc.) |
| `/setup-filament` | Filament v4 Admin Panel com Tailwind CSS v4 |
| `/setup-ci` | GitHub Actions & GitLab CI configurados |

## 🚀 Instalação Rápida

### Instalação Local (apenas no projeto atual)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/install.sh)
```

Escolha opção `1` (LOCAL) quando solicitado.

### Instalação Global (disponível em todos os projetos)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/install.sh)
```

Escolha opção `2` (GLOBAL) quando solicitado.

## 🔄 Atualização

Para atualizar os comandos já instalados:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/update.sh)
```

Este script atualiza automaticamente:
- Comandos locais (`.claude/commands/`)
- Comandos globais (`~/.claude/commands/`)

## 📖 Uso

Depois de instalados, use os comandos no Claude Code:

```
/setup-quality-tools
```

O Claude seguirá as instruções detalhadas de cada comando, instalando e configurando tudo automaticamente.

## 🎯 Diferença entre Local e Global

### Local (`.claude/commands/`)
- ✅ Comandos versionados junto com o projeto
- ✅ Ideal para projetos em equipe
- ✅ Pode fazer commit no Git
- ✅ Cada projeto pode ter versões diferentes

### Global (`~/.claude/commands/`)
- ✅ Disponível em todos os projetos Laravel
- ✅ Não precisa instalar em cada projeto
- ✅ Ideal para uso pessoal
- ✅ Sempre a versão mais recente

## 📋 Detalhes dos Comandos

### `/setup-quality-tools`
Configura ferramentas de qualidade e linters:
- **Laravel Pint** - Formatação de código PHP (PSR-12)
- **PHPStan/Larastan** - Análise estática (nível 5)
- **Pest** - Framework de testes moderno
- **Prettier** - Formatação frontend (Blade + Tailwind)
- **Husky** - Git hooks (pre-commit, pre-push, commit-msg)
- **Commitlint** - Validação de mensagens de commit
- **EditorConfig** - Configuração de editor

### `/setup-laravel-boost`
Instala e configura o Laravel Boost:
- **15+ ferramentas MCP** para Claude
- Consulta ao banco de dados
- Inspeção de rotas, models e configurações
- Execução de código via Tinker
- Busca em logs
- **17.000+ itens** de documentação Laravel com busca semântica

### `/setup-laravel-packages`
Instala 13 pacotes essenciais:
- **laravel/sanctum** - Autenticação API
- **laravel/telescope** - Debugging e profiling
- **barryvdh/laravel-debugbar** - Debug bar
- **spatie/laravel-permission** - Roles & Permissions
- **spatie/laravel-query-builder** - Query builder para APIs
- **dedoc/scramble** - Documentação OpenAPI/Swagger
- E mais 7 pacotes...

### `/setup-filament`
Configura Filament v4:
- **Filament v4.x** com Tailwind CSS v4
- Painel Admin completo
- Criação de usuário administrador
- Plugins opcionais (Shield, Excel, Apex Charts)
- Campos brasileiros (CPF, CNPJ, CEP)

### `/setup-ci`
Configura pipelines CI/CD:
- **GitHub Actions** - 5 jobs paralelos
- **GitLab CI** - Pipeline completo
- Testes, linting, análise estática
- Build de assets
- Deploy automatizado

## 🛠️ Instalação Manual

Se preferir, clone o repositório:

```bash
git clone https://github.com/danie1net0/laravel-claude-commands.git
cd laravel-claude-commands

# Copiar para projeto local
cp commands/*.md /caminho/do/projeto/.claude/commands/

# Ou copiar para global
cp commands/*.md ~/.claude/commands/
```

## 📝 Requisitos

- **Claude Code** instalado
- **Laravel 11+** (para comandos específicos do Laravel)
- **Git** (para git hooks)
- **Node.js 20+** (para Prettier e Husky)
- **PHP 8.2+** (recomendado 8.4)

## 🤝 Contribuindo

Contribuições são bem-vindas! Para adicionar ou melhorar comandos:

1. Fork este repositório
2. Crie uma branch: `git checkout -b meu-comando`
3. Adicione seu comando em `commands/`
4. Commit: `git commit -m 'feat: adiciona comando xyz'`
5. Push: `git push origin meu-comando`
6. Abra um Pull Request

### Estrutura de um Comando

Comandos são arquivos Markdown (`.md`) com instruções para o Claude:

```markdown
# Nome do Comando

Descrição do que o comando faz.

## Instruções

### 1. Verificação Inicial
- Verificar requisitos
- Perguntar ao usuário

### 2. Instalação
```bash
composer require pacote
```

### 3. Configuração
...
```

## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

## 🔗 Links Úteis

- [Claude Code](https://claude.ai/claude-code)
- [Documentação Laravel](https://laravel.com/docs)
- [Filament](https://filamentphp.com)
- [Laravel Boost](https://github.com/laravel/boost)

## ⭐ Agradecimentos

Criado para a comunidade Laravel que usa Claude Code para acelerar o desenvolvimento.

Se este projeto te ajudou, considere dar uma ⭐!

---

**Nota:** Substitua `danie1net0` pela sua organização/usuário GitHub após criar o repositório.
