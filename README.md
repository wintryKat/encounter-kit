# encounter-kit

Multi-platform agent definitions for generating comprehensive AI session
encounter documents. Capture what was asked, what was done, what went wrong,
what was learned, and what should be done differently -- formatted for blog
content, cross-session context injection, and productivity analysis.

## What is an encounter document?

An encounter document is a structured Markdown file that an AI agent produces
to capture the full arc of a working session. It includes the original mandate,
every mandate shift with timing, a detailed execution log, technical exposition
with code snippets, challenges (both technical and prompt-related), lessons
learned in Observation / Implication / Action format, recommendations for the
operator, and a granular timeline for productivity analysis.

The format uses YAML front matter for machine-readable metadata and 13 required
body sections for narrative depth. Each document is self-contained enough to be
injected into a new agent session as context.

## Supported platforms

| Platform | File | Invocation |
|----------|------|------------|
| GitHub Copilot | `.github/agents/brain-dump.chatagent` | `@brain-dump <title>` |
| Claude Code | `.claude/commands/brain-dump.md` | `/brain-dump <title>` |
| Cursor | `.cursor/rules/brain-dump.mdc` | `@brain-dump` or natural language |
| Claude.ai | Project instructions (manual) | Ask for a brain dump |

All four produce files following the same canonical format spec.

## Quick start

```bash
git clone <this-repo> encounter-kit
cd encounter-kit

# Install into a target repository
./scripts/install.sh /path/to/your/repo

# Or use symlinks for live updates during development
./scripts/install.sh --symlink /path/to/your/repo
```

The Claude.ai agent must be installed manually: copy the contents of
`agents/claude-ai/brain-dump.md` into your Claude Project custom instructions.

## Repository structure

```
encounter-kit/
  README.md
  LICENSE
  CHANGELOG.md
  spec/
    ENCOUNTER-FORMAT.md          # Canonical format specification (v1.0.0)
  agents/
    github-copilot/
      brain-dump.chatagent       # GitHub Copilot agent definition
    claude-code/
      brain-dump.md              # Claude Code custom slash command
    cursor/
      brain-dump.mdc             # Cursor rules file
    claude-ai/
      brain-dump.md              # Claude.ai project instructions
  examples/
    *.md                         # Sample encounter documents
  scripts/
    install.sh                   # Installer (copy or symlink mode)
```

## Output format

Each encounter document is a single Markdown file placed in `docs/encounters/`:

```
yyyy-mm-dd.HH-MM-SS.<platform>.<slugified-title>.md
```

YAML front matter provides machine-readable metadata (title, date, platform,
models, tags, summary, compaction count, status, format version). The body
contains 13 required sections from Abstract through Timeline.

See `spec/ENCOUNTER-FORMAT.md` for the full specification.

## Using encounters for blog content

Encounter documents are designed with blog generation in mind. The Abstract
works as a post introduction, Tags map to blog categories, Technical Exposition
has standalone-post depth, and Lessons Learned provides natural blog narratives.

For the guest-writers model (AI-authored posts with transparent attribution),
the `platform` and `models` fields identify the AI, and the `operator` field
identifies who prompted the work.

## Injecting encounters into new sessions

Three injection methods: paste as context, attach as file, or include via
system/project instructions. Documents are self-contained -- the receiving
agent should parse front matter for metadata, read Abstract and Mission Brief
for context, and consult Lessons Learned before starting new work.

## Customization

The `operator` field defaults to `"Kat"`. Change it in each platform file.
To add a new platform, create a directory under `agents/`, copy the closest
existing definition, adapt the platform-specific guidance, and update
`scripts/install.sh`.

## Versioning

The format spec is versioned independently (currently v1.0.0). Agent definitions
declare which spec version they target via `format_version`. When updating the
spec, bump the version and update all agents to match.
