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

echo ""
echo "🔄 Atualizando comandos Claude..."
echo ""

update_directory() {
    local dir=$1
    local updated=0

    if [ ! -d "$dir" ]; then
        echo "⚠️  Diretório $dir não encontrado"
        return 1
    fi

    for cmd in "${COMMANDS[@]}"; do
        if [ -f "$dir/$cmd" ]; then
            echo "📥 Atualizando $cmd..."
            if curl -fsSL "$BASE_URL/$cmd" -o "$dir/$cmd" 2>/dev/null; then
                ((updated++))
            else
                echo "❌ Falha ao atualizar $cmd"
            fi
        fi
    done

    if [ $updated -gt 0 ]; then
        echo ""
        echo "✅ $updated comando(s) atualizado(s) em $dir/"
    else
        echo "⚠️  Nenhum comando encontrado em $dir/"
    fi
}

LOCAL_DIR=".claude/commands"
GLOBAL_DIR="$HOME/.claude/commands"

if [ -d "$LOCAL_DIR" ] && ls "$LOCAL_DIR"/*.md >/dev/null 2>&1; then
    echo "📂 Comandos locais encontrados"
    update_directory "$LOCAL_DIR"
fi

if [ -d "$GLOBAL_DIR" ] && ls "$GLOBAL_DIR"/*.md >/dev/null 2>&1; then
    echo ""
    echo "🌍 Comandos globais encontrados"
    update_directory "$GLOBAL_DIR"
fi

echo ""
echo "✅ Atualização concluída!"
echo ""
