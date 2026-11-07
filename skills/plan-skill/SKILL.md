---
name: plan-skill
description: "Audit workspace dependencies and project scope to recommend a prioritized, loop-aligned suite of modular agent skills."
disable-model-invocation: true
---

# Workspace Skill Recommender

Analyze repository manifests, existing configurations, and project requirements to recommend a prioritized suite of modular agent skills mapped across the software delivery loop.

## Discovery Pipeline

### Stage 1: Workspace Context Ingestion

1. Parse dependency and build manifests (`package.json`, `tsconfig.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Makefile`, `.github/workflows/`) to identify languages, frameworks, test runners, and linters.
2. Inspect `GEMINI.md`, `AGENTS.md`, `CLAUDE.md`, `skills.json`, and `.agents/skills/` to catalog already-installed skills (`setup-workspace`, `shape-*`, `dev-*`, `review-diff`, `git-*`, `refine-*`, `latex-*`).

### Stage 2: Functional Gap Identification

Compare project workflows against installed skills across four operational vectors:

1. **Shaping & Domain Grounding**: Interactive requirement clarification (`shape-grill`), spec synthesis (`shape-spec`), and vertical ticket slicing (`shape-tickets`).
2. **Domain-Specific Execution**: Specialized framework, ORM, UI, or scientific authoring (`dev-tdd`, `latex-writer`).
3. **Verification & Review Gates**: Two-axis diff review (`review-diff`), compilation/test runners (`latex-build`), and secret/artifact commit gates (`git-safety-guard`).
4. **Orchestration & Meta-Maintenance**: Worktree DAG execution (`dev-parallel`), skill authoring (`gen-skill`), and skill pruning (`refine-skill`).

### Stage 3: Invocation Classification

Classify each recommended new skill along the **Two-Load Economy**:

- **User-Invoked (`disable-model-invocation: true`)**: Workflow orchestrators triggered explicitly by human slash command (zero permanent context load).
- **Model-Invoked (Default)**: Reusable domain disciplines or safety gates that the agent or parent skills invoke automatically via context pointers.

## Standardized Output Schema

### 1. Workspace & Stack Diagnostics

- **Runtime & Tooling**: Detected languages, frameworks, test runners, and linters.
- **Installed Skills**: Summary of active workspace skills.

### 2. Recommended Skills Matrix

| Skill Slug | Loop Phase (`Shape` / `Execute` / `Verify` / `Meta`) | Invocation (`User` / `Model`) | Capability & Gap Resolved | Priority (`Critical` / `Recommended` / `Optional`) |
| :--- | :--- | :--- | :--- | :--- |
| `[prefix-slug]` | `Shape` / `Execute` / `Verify` / `Meta` | `User` / `Model` | `[Concise operational role]` | `Critical` / `Recommended` / `Optional` |

### 3. Handoff & Loop Integration

1. Trace how `Shape` outputs (specs and tracer-bullet tickets) feed into `Execute` skills.
2. Trace how `Execute` artifacts pass through `Verify` gates (`review-diff`, `git-safety-guard`) with bounded remediation loops ($N \le 5$).
3. Provide a numbered implementation order for authoring any missing custom skills via `/gen-skill`.
