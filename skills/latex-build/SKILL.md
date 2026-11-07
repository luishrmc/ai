---
name: latex-build
description: Execute non-interactive LaTeX builds via latexmk into out/, parse compilation logs for fatal errors and undefined references, and emit remediation patches. Use after editing .tex or .bib files, upon /build or compile requests, or during latex-writer verification loops.
---

# LaTeX Build Validator

Compile LaTeX manuscripts non-interactively, isolate build artifacts inside `out/`, parse `.log` streams across three severity tiers, and feed structured remediation patches back to `latex-writer`.

## 5-Phase Verification Pipeline

### Phase 1: Root Discovery & Output Isolation

1. Identify the root `.tex` file from the caller argument, defaulting to `main.tex` or the file containing `\documentclass`.
2. Create the isolated artifact directory `out/` (`mkdir -p out`) so `.aux`, `.bbl`, `.fls`, `.fdb_latexmk`, and `.synctex.gz` files stay out of the repository root.

### Phase 2: Non-Interactive Compilation

Execute `latexmk` with strict non-interactive flags and capture exit code and logs:

```bash
latexmk -pdf -file-line-error -interaction=nonstopmode -synctex=1 -outdir=out <root_file>.tex
```

### Phase 3: Three-Tier Log Parsing

Inspect `out/<root_file>.log` across three severity tiers:

1. **Fatal Errors (Blocking)**: Lines matching `<filepath>:<line>: <error>` or `! <TeX Error>` (`Undefined control sequence`, `Missing $ inserted`, `Emergency stop`, `File not found`).
2. **Semantic Warnings (Blocking)**: Undefined cross-references (`LaTeX Warning: Reference '<key>' ... undefined`) and undefined citations (`LaTeX Warning: Citation '<key>' ... undefined`).
3. **Layout Metrics (Non-Blocking)**: Aggregate counts of `Overfull \hbox`, `Underfull \hbox`, and `Overfull \vbox` for informational reporting.

### Phase 4: Patch Synthesis

For each fatal error or semantic warning:

1. Read the offending source file around the reported line number ($\pm 5$ lines).
2. Pinpoint the exact cause (missing macro/package, unclosed delimiter, mismatched environment, or missing `.bib` key).
3. Formulate a concrete drop-in patch for the `.tex` or `.bib` file.

### Phase 5: Bounded Remediation Loop ($N \le 3$)

1. Track the current build-and-fix iteration index ($1 \dots 3$).
2. **Done when**: `latexmk` exits `0` with `0` fatal errors and `0` undefined references/citations (`Status: SUCCESS`).
3. If blocking errors remain and the iteration count is `< 3`, apply the synthesized patch via `latex-writer` and re-run Phase 2.
4. If errors persist after 3 attempts, halt and present the diagnostic triage report to the user (`Status: ESCALATED`).
