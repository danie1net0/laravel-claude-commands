# Guia Rápido - Laravel Claude Commands

## 🚀 Instalação em 30 segundos

### Opção 1: Instalação Local (apenas este projeto)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/install.sh)
```

Quando aparecer o menu:
1. Digite `1` (instalação LOCAL)
2. Digite `1` (instalar TODOS os comandos)

Pronto! Comandos instalados em `.claude/commands/`

### Opção 2: Instalação Global (todos os projetos)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/install.sh)
```

Quando aparecer o menu:
1. Digite `2` (instalação GLOBAL)
2. Digite `1` (instalar TODOS os comandos)

Pronto! Comandos disponíveis em qualquer projeto Laravel.

## 🎯 Uso Imediato

Abra seu projeto Laravel no Claude Code e execute:

```
/setup-quality-tools
```

O Claude vai:
1. ✅ Instalar Pint, PHPStan, Pest, Prettier
2. ✅ Configurar Husky com git hooks
3. ✅ Criar arquivos de configuração
4. ✅ Executar formatação inicial

## 📦 Comandos Disponíveis

Execute no Claude Code depois de instalar:

```
/setup-quality-tools      # Linters e ferramentas de qualidade
/setup-laravel-boost      # Laravel Boost MCP para Claude
/setup-laravel-packages   # 13 pacotes essenciais
/setup-filament           # Filament v4 Admin Panel
/setup-ci                 # GitHub Actions & GitLab CI
```

## 🔄 Atualização

Para atualizar os comandos:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/update.sh)
```

## 💡 Exemplos Práticos

### Novo projeto Laravel completo

```bash
# 1. Criar projeto Laravel
laravel new meu-projeto
cd meu-projeto

# 2. Instalar comandos Claude
bash <(curl -fsSL https://raw.githubusercontent.com/danie1net0/laravel-claude-commands/main/install.sh)

# 3. No Claude Code, executar em sequência:
/setup-quality-tools
/setup-laravel-packages
/setup-filament
/setup-ci

# Pronto! Projeto Laravel completo em minutos.
```

### Adicionar Filament em projeto existente

```bash
# No Claude Code:
/setup-filament
```

O Claude vai instalar e configurar tudo automaticamente.

## ❓ FAQ Rápido

**Q: Preciso instalar em cada projeto?**
A: Se usar instalação GLOBAL, não. Comandos ficam disponíveis em todos os projetos.

**Q: Posso escolher apenas alguns comandos?**
A: Sim! No menu de instalação, escolha opção `7` (Personalizado).

**Q: Como atualizar?**
A: Execute o script de update ou reinstale os comandos.

**Q: Funciona com Docker/Sail?**
A: Sim! Os comandos detectam automaticamente se você usa Sail.

## 🆘 Precisa de Ajuda?

- 📖 Leia o [README completo](README.md)
- 🐛 [Reportar bug](https://github.com/danie1net0/laravel-claude-commands/issues)
- 💬 [Discussões](https://github.com/danie1net0/laravel-claude-commands/discussions)

---

**Dica:** Para projetos em equipe, use instalação LOCAL e faça commit dos comandos no Git. Assim toda equipe usa os mesmos comandos!
