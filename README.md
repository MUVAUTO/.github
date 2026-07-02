# MUVAUTO — Shared Infrastructure

Repositório central de infraestrutura compartilhada do ecossistema MuvAuto.

## Conteúdo

### `.github/workflows/` — Workflows Reutilizáveis

| Workflow | Descrição | Como usar |
|----------|-----------|-----------|
| `flutter-ci.yml` | Analyze + test com SSH para repos privados | `uses: MUVAUTO/.github/.github/workflows/flutter-ci.yml@main` |
| `doc-sync.yml` | Atualiza docs automaticamente via Claude após merge | `uses: MUVAUTO/.github/.github/workflows/doc-sync.yml@main` |

### `hooks/` — Git Hooks Locais

| Hook | Quando | O que faz |
|------|--------|-----------|
| `pre-commit` | Antes de todo commit | `dart analyze` / `flutter analyze` |
| `commit-msg` | Ao commitar | Valida formato Conventional Commits |
| `pre-push` | Antes de todo push | `flutter test` |

### `scripts/` — Scripts Utilitários

| Script | Descrição |
|--------|-----------|
| `setup-hooks.sh` | Instala os hooks acima no repo atual |

---

## Secrets Necessários (org-level)

Configure em **github.com/organizations/MUVAUTO/settings/secrets/actions**:

| Secret | Descrição |
|--------|-----------|
| `MUVAUTO_SSH_PRIVATE_KEY` | Chave SSH com acesso de leitura aos repos privados |
| `ANTHROPIC_API_KEY` | API key Anthropic para o workflow `doc-sync` |
| `MUVAUTO_DOCS_PAT` | PAT com `repo` scope para abrir PRs em `MUVAUTO/docs` |

---

## Setup Rápido (novo dev)

```bash
# 1. Clone o ecossistema
mkdir -p ~/projects/auto && cd ~/projects/auto
for repo in muv-auto-core muv-auto-kuksa muv-auto-obd-scan dashboard ma-obd-scan automind-app automind-api docs; do
  git clone git@github.com:MUVAUTO/$repo.git
done

# 2. Instale os hooks em cada repo
for dir in muv-auto-core muv-auto-kuksa muv-auto-obd-scan dashboard ma-obd-scan automind-app; do
  cd ~/projects/auto/$dir
  curl -fsSL https://raw.githubusercontent.com/MUVAUTO/.github/main/scripts/setup-hooks.sh | bash
done
```

---

## Usar um Workflow Reutilizável

Em qualquer app do ecossistema, crie `.github/workflows/ci.yml`:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  ci:
    uses: MUVAUTO/.github/.github/workflows/flutter-ci.yml@main
    secrets: inherit

  doc-sync:
    uses: MUVAUTO/.github/.github/workflows/doc-sync.yml@main
    secrets: inherit
    with:
      repo_name: dashboard   # troque pelo nome do seu repo
```
