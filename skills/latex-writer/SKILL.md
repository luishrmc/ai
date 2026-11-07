---
name: latex-writer
description: Draft and refine mathematically rigorous academic prose, theorems, and LaTeX manuscript sections. Use when editing .tex files, authoring paper sections (abstract, introduction, methodology, proofs, evaluation), or typesetting formal mathematical arguments.
---

# Academic LaTeX Writer

Author dense, mathematically rigorous academic prose and drop-in `.tex` manuscript blocks compatible with standard conference and journal preambles (`amsmath`, `amssymb`, `amsthm`, `booktabs`, `cleveref`, `microtype`).

## 4-Phase Authoring Pipeline

### Phase 1: Rhetorical Structure Assessment

1. Define the paragraph or subsection claim hierarchy: primary thesis, causal mechanism, mathematical formalization, and empirical or theoretical support.
2. Identify cross-reference targets: equations (`\eqref{eq:...}`), figures (`\ref{fig:...}`), tables (`\ref{tab:...}`), and bibliography keys (`\cite{...}`, `\citet{...}`, `\citep{...}`).

### Phase 2: Mathematical & Syntactic Framing

1. Enforce consistent mathematical notation:
   - Sets and spaces: blackboard bold ($\mathbb{R}$, $\mathbb{Z}$) or calligraphic ($\mathcal{S}$, $\mathcal{D}$).
   - Vectors and matrices: bold lowercase ($\mathbf{x}$) and bold uppercase ($\mathbf{A}$).
   - Multi-letter operators: standard macros (`\arg\max`, `\det`, `\sup`) or `\operatorname{...}`.
2. Integrate every inline and display equation as a grammatical clause of its host sentence, terminating display equations with a comma or period.
3. Open every sentence with a capitalized English word rather than a bare math symbol (`"The vector $x$..."` rather than `"$x$ is..."`).

### Phase 3: Cohesive Narrative Assembly

1. Construct self-contained drop-in `.tex` section blocks (assuming `\documentclass` and package declarations live in the root manuscript file).
2. Write continuous narrative paragraphs (4 to 8 sentences each) connected by logical implication. Reserve `itemize` and `enumerate` environments for formal axiom lists or step-by-step algorithms.
3. Express technical significance through formal bounds, invariants, and empirical measurements. Use standard commas, parentheses, or separate sentences rather than em-dashes, en-dashes, or semicolons.

### Phase 4: Typographical Verification Checklist

Confirm every emitted `.tex` block satisfies these invariants before handoff to `latex-build`:

- [ ] Emits drop-in body blocks only (root preamble tags remain in the main file).
- [ ] Every display equation carries grammatical terminal punctuation (`,` or `.`).
- [ ] Every figure, table, and equation uses symbolic LaTeX cross-references (`\eqref`, `\ref`, `\Cref`).
- [ ] Quotation marks use TeX directional pairs (``word'').
- [ ] Zero em-dashes (`---`), parenthetical en-dashes (`--`), or semicolons appear in prose.
