# Encounter Document Format Specification

> **Version:** 1.0.0
> **Last Updated:** 2026-03-03

## Purpose

An **encounter document** is a comprehensive session log produced by an AI agent at the request of its operator. It captures the full arc of a working session: what was asked, what was done, what went wrong, what was learned, and what should be done differently next time.

Encounter documents serve multiple consumers:

- **Humans** reviewing work for blog posts, retrospectives, or portfolio content
- **AI agents** receiving the document as context to continue or reference prior work
- **Parsers and static site generators** extracting metadata for indexing, tagging, and rendering

## Filename Convention

```
yyyy-mm-dd.HH-MM-SS.<platform-slug>.<slugified-title>.md
```

| Segment | Description | Example |
|---------|-------------|---------|
| `yyyy-mm-dd` | Date of file generation | `2026-03-03` |
| `HH-MM-SS` | Time of file generation (24h, local) | `14-32-07` |
| `<platform-slug>` | Agent runtime that produced the file | `github-copilot`, `claude-code`, `cursor`, `claude-ai` |
| `<slugified-title>` | Kebab-case title, max 80 chars | `turborepo-monorepo-migration-and-the-webpack-betrayal` |

**Example:** `2026-03-03.14-32-07.github-copilot.turborepo-monorepo-migration-and-the-webpack-betrayal.md`

## Document Structure

### YAML Front Matter

Front matter is **mandatory**. It provides machine-readable metadata for static site generators, search indexing, and agent context injection. All fields use standard YAML syntax.

```yaml
---
title: "Turborepo Monorepo Migration and the Webpack Betrayal"
date: "2026-03-03T14:32:07-06:00"       # ISO 8601 with CST/CDT offset
platform: github-copilot                  # Runtime that generated this file
models:                                    # All models used during the session
  - gpt-4o
  - claude-sonnet-4-20250514
tags:                                      # Slugified, lowercase, kebab-case
  - turborepo
  - monorepo
  - webpack
  - migration
  - build-tooling
  - dx-friction
summary: >
  Migrated five framework projects into a Turborepo monorepo. Webpack config
  conflicts in the Angular workspace required three separate debugging passes
  and an unexpected downgrade to resolve.
context_compactions: 2                     # Times the agent's context was compacted/truncated
status: complete                           # complete | partial | continuation
session_duration_minutes: 187              # Approximate wall-clock session length
related_encounters: []                     # Filenames of related encounter docs
continuation_of: ""                        # Filename if this continues a prior encounter
operator: "Kat"                            # Who prompted the session
format_version: "1.0.0"                    # Spec version
---
```

**Field reference:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | yes | Human-readable title, suitable for a blog post headline |
| `date` | ISO 8601 | yes | Timestamp with UTC offset for CST (-06:00) or CDT (-05:00) |
| `platform` | string | yes | Agent runtime slug |
| `models` | string[] | yes | Every model invoked during the session |
| `tags` | string[] | yes | Slugified taxonomy terms, comprehensive |
| `summary` | string | yes | 1–3 sentence overview |
| `context_compactions` | integer | yes | Number of context window compactions |
| `status` | enum | yes | `complete`, `partial`, or `continuation` |
| `session_duration_minutes` | integer | no | Approximate wall-clock duration |
| `related_encounters` | string[] | no | Filenames of thematically related encounters |
| `continuation_of` | string | no | Filename of the encounter this continues |
| `operator` | string | no | Who prompted the work |
| `format_version` | string | yes | Spec version this document conforms to |

### Body Sections

The body uses Markdown heading levels for structure. Every H2 section listed below should be present; sections with nothing to report should include a brief note explaining why (e.g., "No mandate shifts occurred during this session.").

---

#### `## Abstract`

A 150–300 word narrative summary suitable for use as a blog post introduction or conference abstract. Should convey the session's purpose, key outcomes, and most interesting finding or friction point. Written in past tense.

---

#### `## Mission Brief`

The original mandate as understood by the agent at session start. Include:

- The initial prompt or task description (paraphrased or quoted)
- The agent's interpretation of the goals
- Implicit assumptions made
- Scope boundaries as understood

---

#### `## Mandate Shifts`

Chronological log of changes to the original mission. Each entry should note:

- **When** the shift occurred (approximate timestamp or sequence marker)
- **What** changed (new directive, scope expansion/contraction, pivot)
- **Why** it changed (operator instruction, discovered blocker, emergent requirement)
- **How the agent responded** (accepted, pushed back, proposed alternative)

If no shifts occurred, state that explicitly.

---

#### `## Execution Log`

Narrative account of what was actually done, in roughly chronological order. This is the core "what happened" section. Favor concrete actions over vague summaries:

- Files created, modified, or deleted
- Commands run and their outcomes
- Decisions made and their rationale
- Branches taken at decision points

---

#### `## Technical Exposition`

Detailed breakdown of the technical work. Subsections as appropriate:

- **Code:** Key code written or modified, with brief explanation of purpose and approach. Use fenced code blocks with language identifiers.
- **Algorithms & Heuristics:** Any non-trivial logic, search strategies, optimization approaches, or decision heuristics employed.
- **Architecture:** Structural decisions, dependency choices, integration patterns.

This section should contain enough detail to write a technical blog post without needing to re-derive anything.

---

#### `## Skills & Tools`

Inventory of capabilities employed:

- Agent-specific skills or plugins invoked
- External tools (linters, build tools, CLIs, APIs)
- Search queries made and their usefulness
- File operations and their purpose

---

#### `## Emergent Work`

Work that became necessary only after initial investigation or execution began. For each item:

- What was discovered
- Why it wasn't anticipated
- How it was addressed
- Impact on the overall timeline or scope

---

#### `## Challenges & Friction`

Two subsections:

### Unexpected Challenges

Technical or environmental obstacles that contradicted expectations. Include what was expected versus what actually happened.

### Prompt Friction

Specific instances where the prompts or instructions caused confusion, contradictions, ambiguity, or wasted effort. This section exists to help the operator improve future prompting. Be direct but constructive.

---

#### `## Models & Context`

- Table or list of all models used, when, and for what purpose
- Context compaction events: when they occurred and what was likely lost
- Token budget observations if relevant

---

#### `## Lessons Learned`

Concrete, actionable takeaways. Each lesson should follow the pattern:

> **Observation:** [What happened]
> **Implication:** [Why it matters]
> **Action:** [What to do differently]

---

#### `## Recommendations`

Advice directed at the operator for achieving their goals more effectively. Categories:

- **Prompting improvements:** How to structure future requests
- **Tooling suggestions:** Tools, configs, or workflows that would help
- **Architecture guidance:** Structural changes worth considering
- **Process changes:** Workflow or sequencing improvements

Include links to relevant documentation where possible.

---

#### `## References`

Bulleted list of links to documentation, articles, issues, PRs, or other resources referenced or discovered during the session. Each entry should include a brief annotation explaining relevance.

---

#### `## Timeline`

Chronological event log for productivity and attribution analysis. Use a compact format:

```markdown
| Time (CST) | Event | Category | Effort |
|------------|-------|----------|--------|
| 14:32 | Session started. Operator requested monorepo migration. | kickoff | — |
| 14:35 | Read existing project configs across 5 framework dirs. | investigation | low |
| 14:41 | Created root turbo.json and configured pipeline. | implementation | medium |
| 14:58 | Angular webpack config conflict discovered. | blocker | — |
| 15:03 | First debugging pass: attempted config merge. | debugging | high |
| 15:22 | Operator redirected: "just make Angular work standalone." | mandate-shift | — |
| ... | ... | ... | ... |
```

**Category values:** `kickoff`, `investigation`, `implementation`, `debugging`, `mandate-shift`, `documentation`, `testing`, `review`, `idle`, `compaction`, `wrap-up`

**Effort values:** `low`, `medium`, `high`, `—` (not applicable)

---

## Implantation Protocol

When this document is provided to a new agent session (via paste, file attachment, or system injection), the receiving agent should:

1. Parse the YAML front matter to understand metadata and status
2. Read the **Abstract** and **Mission Brief** for high-level context
3. Consult **Lessons Learned** and **Recommendations** before beginning new work
4. Reference the **Timeline** to understand sequencing and effort distribution
5. Check `status` and `continuation_of` to understand if this is a completed or ongoing effort
6. Treat **Prompt Friction** as a calibration guide for interpreting the current operator's style

The document is designed to be self-contained. A receiving agent should be able to understand the full context of the prior session without additional explanation from the operator.

---

## Multi-File Encounters

Most sessions should produce a single file. Split into multiple files **only** when:

- The session spans multiple days with distinct work arcs
- The technical domains are so different that a single document would exceed ~3000 words in the Technical Exposition section alone
- There is a clear narrative break (e.g., a complete pivot to unrelated work)

When splitting, use a shared prefix in filenames and link files via `related_encounters` in front matter. Designate one file as the **index** by appending `-index` to its slug.

```
2026-03-03.14-32-07.github-copilot.monorepo-migration-index.md
2026-03-03.14-32-07.github-copilot.monorepo-migration-angular-webpack.md
2026-03-03.14-32-07.github-copilot.monorepo-migration-turborepo-config.md
```
