# mon-arsenal

Plugin Claude Code regroupant mes skills, sous-agents et hooks personnels (issus du `.claude/` de `ma-todo`).

## Contenu

| Type   | Éléments                                                                                     |
| ------ | -------------------------------------------------------------------------------------------- |
| Skills | `audit-security`, `scaffold-api`, `scaffold-component`, `create-migration`, `deploy-stage`   |
| Agents | `code-reviewer`, `security-auditor`, `test-writer`, `accessibility-checker`, `Explore`       |
| Hooks  | pré-commit (TODO/FIXME), blocage d'écriture dans `.env`, juge `Stop`, notification, Prettier |

Les skills du plugin sont appelés sous la forme `/mon-arsenal:<skill>` (ex. `/mon-arsenal:audit-security`).

## Installation

Test ou usage local, le temps d'une session :

```bash
claude --plugin-dir /chemin/vers/ma-todo/mon-arsenal
```

Installation durable : `mon-arsenal/` contient sa propre marketplace `mes-plugins`
(`.claude-plugin/marketplace.json`, un seul plugin, source `./`). En local :

```
/plugin marketplace add /chemin/vers/ma-todo/mon-arsenal
/plugin install mon-arsenal@mes-plugins
```

Pour l'installer depuis GitHub, publie le contenu de `mon-arsenal/` comme racine d'un dépôt, puis
`/plugin marketplace add <utilisateur>/<depot>`.

Vérification de la structure : `claude plugin validate /chemin/vers/mon-arsenal`.

## Prérequis

- **`jq`** : utilisé par les hooks `Write|Edit` (blocage `.env`, Prettier) pour lire le chemin du fichier. Sans `jq`,
  le hook de blocage `.env` ne protège plus rien.
  Installation : `brew install jq` (macOS), `apt install jq` (Debian/Ubuntu).
- **Prettier local** : le hook de formatage exécute `./node_modules/.bin/prettier` du projet courant
  (`npm install --save-dev prettier`). S'il est absent, il affiche seulement un message `[INFO]` et ne formate rien.
- `bash` et `grep` (BSD ou GNU) pour les scripts de `audit-security`.

## Permissions à configurer dans chaque projet

Un plugin ne peut pas livrer de permissions. À ajouter dans le `.claude/settings.json` de chaque projet :

```json
{
  "permissions": {
    "ask": ["Bash(npm install *)"],
    "deny": ["Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)"]
  }
}
```

## MCP à reconnecter séparément

Le plugin n'embarque aucun serveur MCP ; chaque projet ou poste doit les reconnecter :

- **`postgres`** : requis par `create-migration` (outil `mcp__postgres__search_objects`). Sans lui, le skill s'arrête.
- **GitHub** (MCP `github` ou CLI `gh`) : utile à `deploy-stage` pour lire le résultat de la CI.

## Portabilité des recettes

- `audit-security` : les scripts sont référencés via `${CLAUDE_SKILL_DIR}`, donc indépendants de l'emplacement
  d'installation. Ils s'exécutent avec `bash` (pas de bit exécutable requis) et s'appuient sur `grep -E` / `--include` /
  `--exclude-dir`, présents en BSD et GNU. Ils scannent le répertoire courant : à lancer depuis la racine du projet.
- `scaffold-api`, `scaffold-component` : aucune dépendance de chemin ; elles lisent `CLAUDE.md`/`package.json` du projet
  courant. `scaffold-component` écrit dans `components/` (convention de `ma-todo`).
- `create-migration` : dépend du MCP `postgres` (voir ci-dessus) et écrit dans `migrations/`. `date +%Y%m%d%H%M%S` est portable.
- `deploy-stage` : suppose git, un remote `origin`, Docker et un fichier `deploy.staging.json` à la racine (sinon dry-run).
- Hook de notification : `osascript` n'est exécuté que sur macOS (`uname -s` = `Darwin`) ; ailleurs, le hook émet
  un `systemMessage` affiché dans le terminal de Claude Code.
- Hooks `jq` / Prettier : POSIX shell uniquement ; sous Windows natif (sans Git Bash ou WSL), ils ne fonctionneront pas.
- Hook pré-commit (hook `command`, git requis) : `git grep --no-index --exclude-standard` cherche TODO/FIXME dans les
  fichiers `.js`, `.jsx`, `.ts`, `.tsx` et `.sql` que le `.gitignore` n'exclut pas, hors `.claude` et `mon-arsenal`,
  dépôt Git ou pas ; il ne refuse le commit (exit 2) que s'il trouve un marqueur.

## `mon-arsenal:Explore` : agent namespacé

L'agent `Explore.md` est exposé sous le nom **`mon-arsenal:Explore`**, distinct de l'agent intégré `Explore`.
Il faut l'**appeler explicitement** (par exemple « utilise l'agent `mon-arsenal:Explore` pour… »). Rien ne garantit
qu'il remplace l'Explore intégré : Claude peut continuer à déléguer à l'Explore natif.
Il est limité à `Read`, `Grep`, `Glob` et tourne sur Haiku.
