#!/usr/bin/env bash
# test-all.sh — roda o gate de testes de todo o ecossistema MuvAuto (backend + mobile).
# Uso: ./test-all.sh   (do repo muvauto-github, ou de qualquer lugar)
# Workspace = pasta que contém automind-api e automind-app (default: 2 níveis acima deste script,
# ou defina MUVAUTO_WORKSPACE).
set -uo pipefail

WORKSPACE="${MUVAUTO_WORKSPACE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
API="$WORKSPACE/automind-api"
APP="$WORKSPACE/automind-app"
fail=0

hr() { printf '─%.0s' {1..60}; echo; }

hr; echo "▶ Backend (automind-api) — ./gradlew test"; hr
if [ -d "$API" ]; then
  # CI_EXCLUDE_SMOKE espelha o CI: exclui o smoke test @SpringBootTest até a MUV-61.
  ( cd "$API" && CI_EXCLUDE_SMOKE=true ./gradlew test ) || { echo "❌ backend falhou"; fail=1; }
else
  echo "  (automind-api não encontrado em $API — pulando)"
fi

hr; echo "▶ Mobile (automind-app) — flutter analyze + test"; hr
if [ -d "$APP" ]; then
  # Analisa só o código-fonte (lib test) — evita varrer artefatos de build (ios/build/**).
  # Local o dev tem o firebase_options.dart gerado; se faltar, gere com flutterfire.
  ( cd "$APP" && flutter analyze lib test && flutter test ) || { echo "❌ mobile falhou"; fail=1; }
else
  echo "  (automind-app não encontrado em $APP — pulando)"
fi

hr
if [ "$fail" -eq 0 ]; then echo "✅ Tudo verde"; else echo "❌ Há falhas — veja acima"; fi
exit "$fail"
