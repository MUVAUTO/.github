#!/usr/bin/env bash
# Instala os git hooks MuvAuto no repositório atual.
# Execute uma vez após clonar qualquer repo do ecossistema:
#
#   curl -fsSL https://raw.githubusercontent.com/MUVAUTO/.github/main/scripts/setup-hooks.sh | bash
#
# Ou se já tiver o repo clonado:
#
#   bash /path/to/muvauto-github/scripts/setup-hooks.sh

set -e

HOOKS_SOURCE_URL="https://raw.githubusercontent.com/MUVAUTO/.github/main/hooks"
HOOKS_DIR=".git/hooks"

if [ ! -d ".git" ]; then
  echo "❌ Execute este script na raiz de um repositório git."
  exit 1
fi

echo "🔧 Instalando git hooks MuvAuto em $(pwd)..."

for hook in pre-commit commit-msg pre-push; do
  TARGET="$HOOKS_DIR/$hook"

  # Baixar do repo central
  if curl -fsSL "$HOOKS_SOURCE_URL/$hook" -o "$TARGET" 2>/dev/null; then
    chmod +x "$TARGET"
    echo "   ✅ $hook instalado"
  else
    echo "   ⚠ Não foi possível baixar $hook (sem internet?)"
    echo "   → Copie manualmente de: muvauto-github/hooks/$hook"
  fi
done

echo ""
echo "✅ Hooks instalados. Serão executados automaticamente nos próximos commits e pushes."
echo "   Para desinstalar: rm .git/hooks/{pre-commit,commit-msg,pre-push}"
