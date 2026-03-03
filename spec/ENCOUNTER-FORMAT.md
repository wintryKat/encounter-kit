# Encounter Document Format Specification

> **Version:** 1.1.0
> **Last Updated:** 2026-03-03

## Purpose

An **encounter document** is a comprehensive session log produced by an AI agent at the request of its operator. It captures the full arc of a working session: what was asked, what was done, what went wrong, what was learned, and what should be done differently next time.

Encounter documents serve multiple consumers:

- **Humans** reviewing work for blog posts, retrospectives, or portfolio content
- **AI agents** receiving the document as context to continue or reference prior work
- **Parsers and static site generators** extracting metadata for indexing, tagging, and rendering

## Session Scope

**The "session" is the entire chat history from the very first message to the moment the brain dump is invoked.** This is not limited to recent messages, the last N turns, or the portion of the conversation that remains after context compaction. The agent must make every effort to reconstruct the full session, including:

- Early messages that may have been compacted or summarized
- Context that can be inferred from file changes, git history, or artifacts even if the original conversation is no longer visible
- The operator's initial framing and constraints, which often appear only in the first few messages

If portions of the session have been lost to compaction, the agent must explicitly flag which sections of the encounter document are based on incomplete information and use available tools (git log, filesystem, terminal history) to fill gaps.

## Experiential Detail Standard

Encounter documents must capture the **texture of the experience**, not just the outcomes. This means:

- **Iteration counts**: "Fixed the webpack config" is insufficient. "Attempted 4 different webpack configurations over 25 minutes before discovering the Angular CLI was silently overriding the custom config" is the expected level of detail.
- **Failed approaches that were abandoned**: Dead ends are often the most valuable content for blog posts and future sessions. Document what was tried, why it seemed promising, and what specifically killed it.
- **Agent behavior**: How did the AI agent perform? Where did it excel, hallucinate, go in circles, or need redirection? How many times did the operator need to correct course? This is critical for posts about AI-assisted development.
- **Key error messages**: Not full stack traces, but the specific error strings or output lines that shaped decisions. These are what readers identify with.
- **Emotional arc**: Was there a point where the approach seemed doomed? When did the breakthrough happen? What was the most frustrating moment? This is what makes blog posts compelling rather than sterile.
- **Time spent vs. value gained**: For each major block of work, was the time investment worth it? Would the operator do it again?

The bar for "blog-ready" is: could a writer produce a 10-paragraph opinionated essay about the experience using only this document as source material? If the answer is no, the document lacks sufficient experiential detail.

## Filename Convention

```
yyyy-mm-dd.HH-MM-SS.<platform-slug>.<slugified-title>.md
```

| Segment | Description | Example |
|---------|-------------|---------|
| `yyyy-mm-dd` | Date of file generation | `2026-03-03` |
| `HH-MM-SS` | Time of file generation (24h, local) | `14-32-07` |
| `<platform-slug>` | Agent runtime that produced the file | `github-copilot`, `claude-code`, `cursor`, `claude-ai`, `aider`, `cline`, `windsurf` |
| `<slugified-title>` | Kebab-case title, max 80 chars | `turborepo-monorepo-migration-and-the-webpack-betrayal` |

## Document Structure

### YAML Front Matter

Front matter is **mandatory**. All fields use standard YAML syntax.

```yaml
---
title: "Turborepo Monorepo Migration and the Webpack Betrayal"
date: "2026-03-03T14:32:07-06:00"
platform: github-copilot
models:
  - gpt-4o
  - claude-sonnet-4-20250514
tags:
  - turborepo
  - monorepo
  - webpack
  - migration
summary: >
  Migrated five framework projects into a Turborepo monorepo. Webpack config
  conflicts in the Angular workspace required three separate debugging passes.
context_compactions: 2
status: complete
session_duration_minutes: 187
related_encounters: []
continuation_of: ""
operator: "Kat"
format_version: "1.1.0"
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
| `summary` | string | yes | 1-3 sentence overview |
| `context_compactions` | integer | yes | Number of context window compactions |
| `status` | enum | yes | `complete`, `partial`, or `continuation` |
| `format_version` | string | yes | Spec version this document conforms to |
| `session_duration_minutes` | integer | no | Approximate wall-clock duration |
| `related_encounters` | string[] | no | Filenames of thematically related encounters |
| `continuation_of` | string | no | Filename of the encounter this continues |
| `operator` | string | no | Who prompted the work |

### Body Sections

Every H2 section listed below **must** be present. Sections with nothing to report should include a brief note explaining why.

---

#### `## Abstract`

A 150-300 word narrative summary suitable for use as a blog post introduction. Should convey the session's purpose, key outcomes, the most interesting friction point, and the emotional arc. Written in past tense. This is the section that must make a reader want to keep reading.

---

#### `## Mission Brief`

The original mandate as understood by the agent at session start. Include:

- The initial prompt or task description (paraphrased or quoted)
- The agent's interpretation of the goals
- Implicit assumptions made
- Scope boundaries as understood
- Constraints the operator established (budget, tooling, style, etc.)

---

#### `## Mandate Shifts`

Chronological log of changes to the original mission. Each entry should note:

- **When** the shift occurred (approximate timestamp or sequence marker)
- **What** changed (new directive, scope expansion/contraction, pivot)
- **Why** it changed (operator instruction, discovered blocker, emergent requirement)
- **How the agent responded** (accepted, pushed back, proposed alternative, misunderstood)

If no shifts occurred, state that explicitly.

---

#### `## Execution Log`

Narrative account of what was actually done, in roughly chronological order. This is the core "what happened" section. Requirements:

- Favor concrete actions over vague summaries
- **Include failed attempts and abandoned approaches**, not just successes
- Note iteration counts: how many times was something attempted before it worked?
- Document the operator's redirections and corrections to the agent
- Capture decision points where multiple paths were considered

---

#### `## Technical Exposition`

Detailed breakdown of the technical work. Subsections as appropriate:

- **Code:** Key code written or modified, with brief explanation. Use fenced code blocks.
- **Algorithms & Heuristics:** Non-trivial logic, search strategies, decision heuristics.
- **Architecture:** Structural decisions, dependency choices, integration patterns.
- **Key Errors:** Specific error messages or output that shaped decisions. Not full stack traces, but the diagnostic lines that mattered.

This section should contain enough detail to write a technical blog post without re-deriving anything.

---

#### `## Skills & Tools`

Inventory of capabilities employed:

- Agent-specific skills or plugins invoked
- External tools (linters, build tools, CLIs, APIs)
- Search queries made and their usefulness
- File operations and their purpose

---

#### `## Emergent Work`

Work that became necessary only after initial investigation began. For each item:

- What was discovered
- Why it was not anticipated
- How it was addressed
- Impact on timeline or scope

---

#### `## Challenges & Friction`

Three subsections:

### Unexpected Challenges

Technical or environmental obstacles that contradicted expectations. For each:
- What was expected vs. what actually happened
- How many attempts were made before resolution
- What the resolution was (or if it remains unresolved)
- Time spent on this challenge

### Prompt Friction

Specific instances where the prompts or instructions caused confusion, contradictions, ambiguity, or wasted effort. Be direct but constructive.

### Agent Behavior

How the AI agent itself performed during the session:
- Where it excelled or saved significant time
- Where it hallucinated, went in circles, or produced incorrect output
- How many times the operator had to redirect or correct it
- Specific behaviors that were frustrating or surprising
- Whether the agent maintained context coherence across the session

---

#### `## Models & Context`

- Table or list of all models used, when, and for what purpose
- Context compaction events: when they occurred, what was likely lost, and how it affected subsequent work
- Token budget observations if relevant
- Whether the agent appeared to "forget" earlier context

---

#### `## Lessons Learned`

Concrete, actionable takeaways. Each lesson should follow the pattern:

> **Observation:** [What happened]
> **Implication:** [Why it matters]
> **Action:** [What to do differently]

---

#### `## Recommendations`

Advice directed at the operator for achieving their goals more effectively:

- **Prompting improvements:** How to structure future requests
- **Tooling suggestions:** Tools, configs, or workflows that would help
- **Architecture guidance:** Structural changes worth considering
- **Process changes:** Workflow or sequencing improvements

Include links to relevant documentation where possible.

---

#### `## References`

Bulleted list of links to documentation, articles, issues, PRs, or other resources. Each entry should include a brief annotation.

---

#### `## Timeline`

Chronological event log for productivity and attribution analysis.

**Minimum granularity: ~5 entries per hour of session time.** A 3-hour session should have at least 15 timeline entries. If the agent cannot recall enough detail for this density, it must flag the gap and use available tools to reconstruct.

```markdown
| Time (CST) | Event | Category | Effort |
|------------|-------|----------|--------|
| 14:32 | Session started. Operator requested monorepo migration. | kickoff | --- |
| 14:35 | Read existing project configs across 5 framework dirs. | investigation | low |
| 14:41 | Created root turbo.json and configured pipeline. | implementation | medium |
| 14:52 | First webpack config attempt: merged Angular CLI config. Failed. | debugging | high |
| 14:58 | Second attempt: ejected Angular CLI config entirely. Still failed. | debugging | high |
| 15:06 | Discovered Angular CLI silently overwrites custom webpack. | investigation | medium |
| 15:10 | Third attempt: downgraded Angular CLI to v15. Success. | implementation | medium |
| 15:22 | Operator redirected: "just make Angular work standalone." | mandate-shift | --- |
```

**Category values:** `kickoff`, `investigation`, `implementation`, `debugging`, `mandate-shift`, `documentation`, `testing`, `review`, `idle`, `compaction`, `wrap-up`

**Effort values:** `low`, `medium`, `high`, `---` (not applicable)

Note: Failed attempts and debugging iterations MUST appear as separate timeline entries. Do not collapse "tried 4 things" into a single row.

---

## Implantation Protocol

When this document is provided to a new agent session (via paste, file attachment, or system injection), the receiving agent should:

1. Parse the YAML front matter to understand metadata and status
2. Read the **Abstract** and **Mission Brief** for high-level context
3. Consult **Lessons Learned** and **Recommendations** before beginning new work
4. Reference the **Timeline** to understand sequencing and effort distribution
5. Check `status` and `continuation_of` to understand completion state
6. Treat **Prompt Friction** and **Agent Behavior** as calibration guides for the operator's style and expectations

---

## Multi-File Encounters

Most sessions should produce a single file. Split into multiple files **only** when:

- The session spans multiple days with distinct work arcs
- Technical Exposition exceeds ~3000 words across genuinely distinct domains
- There is a clear narrative break

When splitting, use a shared prefix and link via `related_encounters`. Designate one file as the **index** with `-index` suffix.