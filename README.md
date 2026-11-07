# AI: Agent Skills

[![Version](https://img.shields.io/badge/release-v2.0.0-blue.svg)](skills.json)
[![Skills](https://img.shields.io/badge/skills-29%20modular%20skills-brightgreen.svg)](#skill-catalog)
[![Architecture](https://img.shields.io/badge/architecture-Two--Load%20%26%20Progressive%20Disclosure-indigo.svg)](#architecture)
[![Compatibility](https://img.shields.io/badge/compatibility-Antigravity%20%7C%20Claude%20Code%20%7C%20Codex%20%7C%20Cursor-orange.svg)](#installation)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)

A collection of 29 modular `SKILL.md` definitions for coding agents in Antigravity, Claude Code, Codex, and Cursor. It provides structured workflows for requirement shaping, specification writing, vertical ticket slicing, test-driven implementation, two-axis diff review, and Git commit verification.

---

## Architecture

### 1. Invocation Split (`User-Invoked` vs. `Model-Invoked`)

Skills are divided by who can invoke them to limit unnecessary context window usage:

- **User-Invoked Skills (`disable-model-invocation: true`)**: Workflow entry points triggered only when the user types `/skill-name` (such as `/shape-grill`, `/shape-spec`, `/shape-tickets`, `/dev-implement`, `/dev-parallel`, `/arch-survey`, and `/router-skills`). Because the model does not auto-discover them, their descriptions are excluded from the permanent context window.
- **Model-Invoked Skills (Default)**: Reusable procedures (`shape-grilling`, `shape-domain`, `dev-tdd`, `review-diff`, `arch-design`, `debug-loop`, `git-safety-guard`) with trigger conditions in their YAML `description`. They can be called automatically by the model or invoked by a user-invoked skill.

### 2. Progressive Disclosure (`<150 Lines` Per Root `SKILL.md`)

Each root `SKILL.md` is kept under 90 lines (with a hard repository limit of 150 lines). The root file holds ordered execution steps and completion criteria, while templates, JSON schemas, code smell checklists, HTML report layouts, and shell scripts are stored in `references/`, `assets/`, and `scripts/` and loaded only when needed.

### 3. Main Flow and 5-Stage Git Pipeline

Requirement shaping runs in a single context window (`shape-grill` -> `shape-spec` -> `shape-tickets`). Once tickets are written to the issue tracker or `.scratch/`, each ticket is implemented in an isolated context window:

```text
[1. /setup-workspace] ──► Configures docs/agents/*, GLOSSARY.md, and docs/adr/
          │
          ▼
[2. /shape-grill]     ──► Runs shape-grilling + shape-domain (updates GLOSSARY.md & ADRs)
          │
          ▼
[3. /shape-spec]      ──► Writes path-free spec and confirms public test seams
          │
          ▼
[4. /shape-tickets]   ──► Creates vertical slice tickets (or Expand-Contract batches)
          │
          ╠══► Single Ticket: /dev-implement
          ║      ├─ Stage 1: git-branch-lifecycle (syncs base & creates task branch)
          ║      ├─ Stage 2: dev-tdd (red -> green vertical slices at public seams)
          ║      ├─ Stage 3: review-diff (parallel Standards + Spec subagent review)
          ║      ├─ Stage 4: git-commit-stager (explicit pathspec staging & commit manifest)
          ║      └─ Stage 5: git-safety-guard (secret scan, stash-isolated tests, git commit)
          ║
          ╚══► Multi-Ticket DAG: /dev-parallel (parallel git worktree subagents)
```

---

## Skill Catalog

All 29 skills use functional prefix naming (`router-*`, `setup-*`, `shape-*`, `research-*`, `dev-*`, `review-*`, `arch-*`, `debug-*`, `env-*`, `plan-*`, `refine-*`, `gen-*`, `git-*`):

| Skill Slug | Invocation / Command | Category | Core Purpose & Workflow Role |
| :--- | :--- | :--- | :--- |
| [`router-skills`](skills/router-skills/SKILL.md) | User (`/router-skills`) | `routing` | Maps a task description to the appropriate skill workflow and phase boundary rule. |
| [`setup-workspace`](skills/setup-workspace/SKILL.md) | User (`/setup-workspace`) | `setup` | Creates `docs/agents/issue-tracker.md`, `GLOSSARY.md`, `docs/adr/`, and steering file pointers. |
| [`shape-grill`](skills/shape-grill/SKILL.md) | User (`/shape-grill`) | `shaping` | Runs `shape-grilling` and `shape-domain` to clarify requirements and update domain docs. |
| [`shape-grilling`](skills/shape-grilling/SKILL.md) | Model *(Internal)* | `shaping` | Walks a decision tree in rounds (`❓ Q1` / `➡️ Recommended`) and uses subagents for codebase lookups. |
| [`shape-domain`](skills/shape-domain/SKILL.md) | Model *(Internal)* | `shaping` | Resolves ambiguous domain terms, updates `GLOSSARY.md` inline, and writes ADRs in `docs/adr/`. |
| [`shape-spec`](skills/shape-spec/SKILL.md) | User (`/shape-spec`) | `shaping` | Synthesizes conversation decisions into a specification document with agreed public test seams. |
| [`shape-tickets`](skills/shape-tickets/SKILL.md) | User (`/shape-tickets`) | `shaping` | Splits a specification into vertical slice tickets with explicit blocking dependencies. |
| [`shape-wayfinder`](skills/shape-wayfinder/SKILL.md) | User (`/shape-wayfinder`) | `shaping` | Tracks multi-session planning efforts as a `wayfinder:map` issue with child decision tickets. |
| [`shape-prototype`](skills/shape-prototype/SKILL.md) | Model *(Auto)* | `shaping` | Builds throwaway single-file HTML state simulators (`logic.md`) or multi-variant UI routes (`ui.md`). |
| [`research-topic`](skills/research-topic/SKILL.md) | Model *(Auto)* | `navigation` | Runs a fresh-context background subagent to check primary sources and write a cited Markdown note. |
| [`dev-implement`](skills/dev-implement/SKILL.md) | User (`/dev-implement`) | `execution` | Implements a single ticket through the 5-stage Git, TDD, and diff review pipeline. |
| [`dev-parallel`](skills/dev-parallel/SKILL.md) | User (`/dev-parallel`) | `execution` | Implements a multi-ticket spec on an integration branch using parallel git worktree subagents. |
| [`dev-tdd`](skills/dev-tdd/SKILL.md) | Model *(Internal)* | `execution` | Runs red-green vertical slice loops at public module seams and avoids implementation-coupled tests. |
| [`review-diff`](skills/review-diff/SKILL.md) | Model *(Auto)* | `review` | Runs two parallel subagents to review diffs against repo **Standards** (plus Fowler code smells) and the **Spec**. |
| [`arch-design`](skills/arch-design/SKILL.md) | Model *(Internal)* | `architecture` | Defines module design terms (*Module*, *Interface*, *Depth*, *Seam*, *Adapter*, *Leverage*, *Locality*) and the Design-It-Twice pattern. |
| [`arch-survey`](skills/arch-survey/SKILL.md) | User (`/arch-survey`) | `architecture` | Scans high-churn files for shallow modules, writes an HTML report to `$TMPDIR`, and interviews on candidates. |
| [`debug-loop`](skills/debug-loop/SKILL.md) | Model *(Auto)* | `debugging` | Guides bug diagnosis through a 6-phase loop starting with an automated red reproduction command. |
| [`env-retro`](skills/env-retro/SKILL.md) | User (`/env-retro`) | `environment` | Reviews a completed session across 7 categories to update pointers, linter checks, and `CODING_STANDARDS.md`. |
| [`env-handoff`](skills/env-handoff/SKILL.md) | User (`/env-handoff`) | `environment` | Writes session context pointers to `$TMPDIR` for continuing work in another directory or tool. |
| [`plan-agents`](skills/plan-agents/SKILL.md) | User (`/plan-agents`) | `planning` | Designs multi-agent workflows with bounded iteration limits ($N \le 5$) and per-role tool allowlists. |
| [`plan-hooks`](skills/plan-hooks/SKILL.md) | User (`/plan-hooks`) | `planning` | Specifies pre-step checks, mid-execution telemetry, post-step verifiers, and loop termination gates. |
| [`plan-instruction`](skills/plan-instruction/SKILL.md) | User (`/plan-instruction`) | `planning` | Generates a concise, pointer-based `GEMINI.md` or `AGENTS.md` file from repository conventions. |
| [`refine-prompt`](skills/refine-prompt/SKILL.md) | Model *(Auto)* | `refinement` | Restructures draft prompts into delimited Markdown instructions or Pydantic structured-output code. |
| [`refine-skill`](skills/refine-skill/SKILL.md) | User (`/refine-skill`) | `refinement` | Audits and prunes `SKILL.md` files using unified diffs. |
| [`refine-text`](skills/refine-text/SKILL.md) | Model *(Auto)* | `refinement` | Edits prose for direct phrasing, active verbs, and standard punctuation. |
| [`gen-skill`](skills/gen-skill/SKILL.md) | User (`/gen-skill`) | `refinement` | Scaffolds new `SKILL.md` packages under 150 lines with supporting `references/` files. |
| [`git-branch-lifecycle`](skills/git-branch-lifecycle/SKILL.md) | Model *(Internal)* | `git` | Stage 1 Git skill: checks working tree state, fast-forwards the base branch, and creates a task branch. |
| [`git-commit-stager`](skills/git-commit-stager/SKILL.md) | Model *(Internal)* | `git` | Stage 4 Git skill: stages modified files by explicit pathspec and writes `.agent/commit-staging-manifest.json`. |
| [`git-safety-guard`](skills/git-safety-guard/SKILL.md) | Model *(Internal)* | `git` | Stage 5 Git skill: checks staged diffs for secrets and binaries, runs tests in an isolated stash, and runs `git commit`. |

---

## Installation

### Option 1: Global Copy Install

Copy all 29 skills into `~/.gemini/config/skills/`:

```bash
curl -fsSL https://raw.githubusercontent.com/luishrmc/ai/main/install.sh | bash
```

### Option 2: Clone and Symlink

Clone the repository and create symlinks so `git pull` updates apply immediately:

```bash
git clone https://github.com/luishrmc/ai.git ~/me/ai
cd ~/me/ai
./install.sh --symlink
```

### Option 3: Compatibility and Target Flags

Use `./install.sh` or `Makefile` targets to install into specific directories:

| Environment | Target Path | Installer Command | Makefile Target |
| :--- | :--- | :--- | :--- |
| **Antigravity / Gemini CLI (`agy`)** | `~/.gemini/config/skills/` | `./install.sh --global-gemini --symlink` | `make link-global` |
| **Claude Code** | `~/.claude/skills/` | `./install.sh --global-claude --symlink` | `make link-claude` |
| **Project Directory (`.agents/skills/`)** | `<repo>/.agents/skills/` | `./install.sh --project-agents` | `make install-project` |
| **Selected Skills Only** | Custom or default | `./install.sh router-skills shape-grill dev-implement` | - |

---

## License

MIT © [Luis Henrique](https://github.com/luishrmc)
