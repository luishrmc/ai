# AI — Universal Agent Skills Suite

[![Version](https://img.shields.io/badge/release-v2.0.0-blue.svg)](skills.json)
[![Skills](https://img.shields.io/badge/skills-29%20modular%20skills-brightgreen.svg)](#-master-skill-catalog)
[![Architecture](https://img.shields.io/badge/architecture-Two--Load%20%26%20Progressive%20Disclosure-indigo.svg)](#-architectural-pillars)
[![Compatibility](https://img.shields.io/badge/compatibility-Antigravity%20%7C%20Claude%20Code%20%7C%20Codex%20%7C%20Cursor-orange.svg)](#-quickstart--installation)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)

A production-grade suite of **29 composable Agent Skills** implementing an end-to-end software engineering workflow (`Idea -> Domain Model -> Spec -> Tracer-Bullet Tickets -> Seam TDD -> Two-Axis Review -> Verified Commit`), deep module architecture analysis, disciplined bug diagnosis, multi-agent planning, and prompt engineering.

---

## 🏛️ Architectural Pillars

### 1. The Two-Load Economy (`User-Invoked` vs. `Model-Invoked`)

Every skill in this repository is partitioned along a strict invocation boundary to protect the agent's context window:

- **User-Invoked Orchestrators (`disable-model-invocation: true`)**: Workflow entry points reachable only when the developer types `/skill-name` (e.g., `/shape-grill`, `/shape-spec`, `/shape-tickets`, `/dev-implement`, `/dev-parallel`, `/arch-survey`, `/router-skills`). They impose **zero permanent context load** on the model; human cognitive load is handled by the `/router-skills` router.
- **Model-Invoked Disciplines (Default)**: Reusable engineering capabilities (`shape-grilling`, `shape-domain`, `dev-tdd`, `review-diff`, `arch-design`, `debug-loop`, `git-safety-guard`) with front-loaded trigger pointers in their YAML `description`. They can be reached autonomously by the agent or composed by user-invoked orchestrators.

### 2. Progressive Disclosure (`<150 Lines` Per Root `SKILL.md`)

Every root `SKILL.md` in this repository is strictly under **90 lines** (enforcing a hard ceiling of `<150 lines`). Ordered execution steps and completion criteria sit at the top of `SKILL.md`, while templates, JSON schemas, Fowler code smell baselines, HTML report scaffolds, and non-interactive bash utilities live behind context pointers in `references/`, `assets/`, and `scripts/`.

### 3. The Main Flow & 5-Stage Git/TDD Pipeline

Conversational shaping stays inside a single unbroken context window (within the ~150k token smart zone), then transitions across a clean phase boundary into isolated per-ticket execution:

```text
[1. /setup-workspace] ──► Configures docs/agents/*, GLOSSARY.md, and docs/adr/
          │
          ▼
[2. /shape-grill]     ──► Composes shape-grilling + shape-domain (inline GLOSSARY.md & ADRs)
          │
          ▼
[3. /shape-spec]      ──► Synthesizes path-free spec and confirms public test seams
          │
          ▼
[4. /shape-tickets]   ──► Slices tracer-bullet vertical tickets (or Expand-Contract batches)
          │
          ╠══► Single Ticket: /dev-implement
          ║      ├─ Stage 1: git-branch-lifecycle (sync base & create collision-free branch)
          ║      ├─ Stage 2: dev-tdd (red -> green vertical slices at confirmed public seams)
          ║      ├─ Stage 3: review-diff (parallel Standards + Spec fresh-context subagents)
          ║      ├─ Stage 4: git-commit-stager (explicit pathspec staging & Conventional Commit)
          ║      └─ Stage 5: git-safety-guard (secret scan, stash-isolated tests, git commit)
          ║
          ╚══► Multi-Ticket DAG: /dev-parallel (parallel git worktree implementer subagents)
```

---

## 📦 Master Skill Catalog

All **29 skills** follow strict functional prefix naming (`router-*`, `setup-*`, `shape-*`, `research-*`, `dev-*`, `review-*`, `arch-*`, `debug-*`, `env-*`, `plan-*`, `refine-*`, `gen-*`, `git-*`):

| Skill Slug | Invocation / Command | Category | Core Purpose & Workflow Role |
| :--- | :--- | :--- | :--- |
| [`router-skills`](skills/router-skills/SKILL.md) | User (`/router-skills`) | `routing` | Cognitive-load router mapping developer goals to the right flow and phase boundary rule. |
| [`setup-workspace`](skills/setup-workspace/SKILL.md) | User (`/setup-workspace`) | `setup` | Scaffolds `docs/agents/issue-tracker.md`, `GLOSSARY.md`, `docs/adr/`, and steering pointers. |
| [`shape-grill`](skills/shape-grill/SKILL.md) | User (`/shape-grill`) | `shaping` | Stateful design interrogation composing `shape-grilling` and `shape-domain` inline. |
| [`shape-grilling`](skills/shape-grilling/SKILL.md) | Model *(Internal)* | `shaping` | Walks the design tree frontier in rounds (`❓ Q1` / `➡️ Recommended`) and dispatches subagents for codebase facts. |
| [`shape-domain`](skills/shape-domain/SKILL.md) | Model *(Internal)* | `shaping` | Challenges overloaded terms, updates `GLOSSARY.md` inline, and gates ADRs by 3 criteria. |
| [`shape-spec`](skills/shape-spec/SKILL.md) | User (`/shape-spec`) | `shaping` | Zero-interview synthesis of agreed thread into a path-free spec with confirmed public test seams. |
| [`shape-tickets`](skills/shape-tickets/SKILL.md) | User (`/shape-tickets`) | `shaping` | Decomposes specs into context-window-sized tracer-bullet vertical slices with blocking DAG edges. |
| [`shape-wayfinder`](skills/shape-wayfinder/SKILL.md) | User (`/shape-wayfinder`) | `shaping` | Charts multi-session epics across the fog of war as a `wayfinder:map` of decision tickets. |
| [`shape-prototype`](skills/shape-prototype/SKILL.md) | Model *(Auto)* | `shaping` | Builds throwaway single-file HTML state simulators (`logic.md`) or multi-variant UI routes (`ui.md`). |
| [`research-topic`](skills/research-topic/SKILL.md) | Model *(Auto)* | `navigation` | Dispatches a fresh-context background subagent to verify claims against primary sources and write cited Markdown. |
| [`dev-implement`](skills/dev-implement/SKILL.md) | User (`/dev-implement`) | `execution` | Executes a single ticket end-to-end through the 5-stage Git, seam TDD, and two-axis review pipeline. |
| [`dev-parallel`](skills/dev-parallel/SKILL.md) | User (`/dev-parallel`) | `execution` | Implements a multi-ticket spec on an integration branch using parallel worktree subagents across the DAG frontier. |
| [`dev-tdd`](skills/dev-tdd/SKILL.md) | Model *(Internal)* | `execution` | Enforces test-first red-green vertical slices at public seams; rejects implementation-coupled and tautological tests. |
| [`review-diff`](skills/review-diff/SKILL.md) | Model *(Auto)* | `review` | Spawns two parallel fresh-context subagents to audit diffs across **Standards** (repo rules + 12 Fowler smells) and **Spec** axes. |
| [`arch-design`](skills/arch-design/SKILL.md) | Model *(Internal)* | `architecture` | Canonical deep-module vocabulary (*Module*, *Interface*, *Depth*, *Seam*, *Adapter*, *Leverage*, *Locality*) and Design-It-Twice pattern. |
| [`arch-survey`](skills/arch-survey/SKILL.md) | User (`/arch-survey`) | `architecture` | Scans high-churn modules with the deletion test, renders a Tailwind/Mermaid HTML report in `$TMPDIR`, and grills on candidates. |
| [`debug-loop`](skills/debug-loop/SKILL.md) | Model *(Auto)* | `debugging` | Enforces a gated 6-phase bug diagnosis discipline built on a 10-tier reproducible red feedback loop. |
| [`env-retro`](skills/env-retro/SKILL.md) | User (`/env-retro`) | `environment` | Audits completed sessions across 7 environment categories to upgrade pointers, checks, and `CODING_STANDARDS.md`. |
| [`env-handoff`](skills/env-handoff/SKILL.md) | User (`/env-handoff`) | `environment` | Serializes active session context pointers into `$TMPDIR` for cross-harness or cross-directory continuation. |
| [`plan-agents`](skills/plan-agents/SKILL.md) | User (`/plan-agents`) | `planning` | Synthesizes bounded ($N \le 5$) multi-agent topologies with least-privilege tool isolation. |
| [`plan-hooks`](skills/plan-hooks/SKILL.md) | User (`/plan-hooks`) | `planning` | Designs pre-step interceptors, mid-execution telemetry, post-step verifiers, and loop convergence gates. |
| [`plan-instruction`](skills/plan-instruction/SKILL.md) | User (`/plan-instruction`) | `planning` | Compiles repository conventions and planning outputs into a concise, pointer-driven `GEMINI.md` / `AGENTS.md`. |
| [`refine-prompt`](skills/refine-prompt/SKILL.md) | Model *(Auto)* | `refinement` | Dual-mode prompt optimizer producing interactive Markdown prompts or type-safe Pydantic application code. |
| [`refine-skill`](skills/refine-skill/SKILL.md) | User (`/refine-skill`) | `refinement` | Audits, prunes, and calibrates `SKILL.md` specifications using unified diffs and writing-for-agents mechanics. |
| [`refine-text`](skills/refine-text/SKILL.md) | Model *(Auto)* | `refinement` | Enforces clear, direct, and hype-free prose grounded in concrete mechanisms and standard punctuation. |
| [`gen-skill`](skills/gen-skill/SKILL.md) | User (`/gen-skill`) | `refinement` | Architects and generates new modular `SKILL.md` packages under 150 lines with disclosed references. |
| [`git-branch-lifecycle`](skills/git-branch-lifecycle/SKILL.md) | Model *(Internal)* | `git` | Stage 1 Git skill: verifies clean tree, fast-forwards canonical base branch, and creates collision-free task branches. |
| [`git-commit-stager`](skills/git-commit-stager/SKILL.md) | Model *(Internal)* | `git` | Stage 4 Git skill: stages modified files strictly by explicit pathspec and drafts Conventional Commit manifests. |
| [`git-safety-guard`](skills/git-safety-guard/SKILL.md) | Model *(Internal)* | `git` | Stage 5 Git gatekeeper: scans staged diffs for secrets/binaries, runs stash-isolated tests, and executes `git commit`. |

---

## ⚡ Quickstart & Installation

### Option 1: One-Line Global Install (Copy Mode)

Install all 29 skills into your global Antigravity / Gemini CLI environment (`~/.gemini/config/skills/`):

```bash
curl -fsSL https://raw.githubusercontent.com/luishrmc/ai/main/install.sh | bash
```

### Option 2: Clone & Symlink (Recommended for Active Development)

Clone the repository and symlink all skills globally so `git pull` updates reflect immediately across every workspace:

```bash
git clone https://github.com/luishrmc/ai.git ~/me/ai
cd ~/me/ai
./install.sh --symlink
```

### Option 3: Target-Specific & Project-Level Installation

Use `./install.sh` or `Makefile` presets for any agent harness:

| Agent Harness | Target Path | Installer Command | Makefile Shortcut |
| :--- | :--- | :--- | :--- |
| **Antigravity / Gemini CLI (`agy`)** | `~/.gemini/config/skills/` | `./install.sh --global-gemini --symlink` | `make link-global` |
| **Claude Code** | `~/.claude/skills/` | `./install.sh --global-claude --symlink` | `make link-claude` |
| **Project Workspace (`.agents/skills/`)** | `<repo>/.agents/skills/` | `./install.sh --project-agents` | `make install-project` |
| **Selective Skill Install** | Custom or default | `./install.sh router-skills shape-grill dev-implement` | - |

---

## 📄 License

MIT © [Luis Henrique](https://github.com/luishrmc)
