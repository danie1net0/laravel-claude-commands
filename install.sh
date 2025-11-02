#!/bin/bash

set -e

REPO="danie1net0/laravel-claude-commands"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/commands"

COMMANDS=(
    "setup-quality-tools.md"
    "setup-laravel-boost.md"
    "setup-laravel-packages.md"
    "setup-filament.md"
    "setup-ci.md"
)

print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════╗"
    echo "║   Laravel Claude Commands - Installer             ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo ""
}

print_success() {
    echo "✅ $1"
}

print_info() {
    echo "📥 $1"
}

print_error() {
    echo "❌ $1"
    exit 1
}

download_command() {
    local file=$1
    local target_dir=$2

    print_info "Baixando $file..."

    if curl -fsSL "$BASE_URL/$file" -o "$target_dir/$file" 2>/dev/null; then
        return 0
    else
        print_error "Falha ao baixar $file"
        return 1
    fi
}

install_local() {
    print_info "Instalação LOCAL (projeto atual)"
    echo ""

    if [ ! -f "artisan" ]; then
        print_error "Este diretório não parece ser um projeto Laravel!"
    fi

    TARGET_DIR=".claude/commands"
    mkdir -p "$TARGET_DIR"

    install_commands "$TARGET_DIR"

    echo ""
    print_success "Comandos instalados em $TARGET_DIR/"
    echo ""
    echo "Use no Claude Code:"
    echo "  • /setup-quality-tools"
    echo "  • /setup-laravel-boost"
    echo "  • /setup-laravel-packages"
    echo "  • /setup-filament"
    echo "  • /setup-ci"
}

install_global() {
    print_info "Instalação GLOBAL (sistema)"
    echo ""

    TARGET_DIR="$HOME/.claude/commands"
    mkdir -p "$TARGET_DIR"

    install_commands "$TARGET_DIR"

    echo ""
    print_success "Comandos instalados em $TARGET_DIR/"
    echo ""
    echo "Comandos disponíveis em TODOS os projetos Laravel!"
}

install_commands() {
    local target_dir=$1

    echo "Selecione os comandos para instalar:"
    echo ""
    echo "  1) Todos os comandos"
    echo "  2) setup-quality-tools    - Pint, PHPStan, Pest, Prettier, Husky"
    echo "  3) setup-laravel-boost    - Laravel Boost MCP para Claude"
    echo "  4) setup-laravel-packages - Pacotes essenciais do Laravel"
    echo "  5) setup-filament         - Filament v4 Admin Panel"
    echo "  6) setup-ci               - GitHub Actions & GitLab CI"
    echo "  7) Personalizado (escolher múltiplos)"
    echo ""
    read -p "Opção (1-7): " option
    echo ""

    case $option in
        1)
            for cmd in "${COMMANDS[@]}"; do
                download_command "$cmd" "$target_dir"
            done
            ;;
        2)
            download_command "setup-quality-tools.md" "$target_dir"
            ;;
        3)
            download_command "setup-laravel-boost.md" "$target_dir"
            ;;
        4)
            download_command "setup-laravel-packages.md" "$target_dir"
            ;;
        5)
            download_command "setup-filament.md" "$target_dir"
            ;;
        6)
            download_command "setup-ci.md" "$target_dir"
            ;;
        7)
            echo "Digite os números dos comandos separados por espaço (ex: 2 4 5):"
            echo "  2) setup-quality-tools"
            echo "  3) setup-laravel-boost"
            echo "  4) setup-laravel-packages"
            echo "  5) setup-filament"
            echo "  6) setup-ci"
            echo ""
            read -p "Comandos: " selections
            echo ""

            for num in $selections; do
                case $num in
                    2) download_command "setup-quality-tools.md" "$target_dir" ;;
                    3) download_command "setup-laravel-boost.md" "$target_dir" ;;
                    4) download_command "setup-laravel-packages.md" "$target_dir" ;;
                    5) download_command "setup-filament.md" "$target_dir" ;;
                    6) download_command "setup-ci.md" "$target_dir" ;;
                    *) echo "⚠️  Opção $num inválida, ignorando..." ;;
                esac
            done
            ;;
        *)
            print_error "Opção inválida!"
            ;;
    esac
}

main() {
    print_header

    echo "Onde deseja instalar os comandos?"
    echo ""
    echo "  1) LOCAL  - Apenas neste projeto (.claude/commands)"
    echo "  2) GLOBAL - Sistema todo (~/.claude/commands)"
    echo ""
    read -p "Opção (1-2): " install_type
    echo ""

    case $install_type in
        1)
            install_local
            ;;
        2)
            install_global
            ;;
        *)
            print_error "Opção inválida!"
            ;;
    esac

    echo ""
    print_success "Instalação concluída!"
    echo ""
    echo "Para atualizar os comandos, execute novamente:"
    echo "  bash <(curl -fsSL https://raw.githubusercontent.com/$REPO/$BRANCH/install.sh)"
    echo ""
}

main
