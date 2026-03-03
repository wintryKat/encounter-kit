# Changelog

All notable changes to encounter-kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-03-03

### Added

- **Session Scope** section in format spec: the session is the entire chat from first message, not just post-compaction context
- **Experiential Detail Standard** in format spec: iteration counts, failed approaches, agent behavior, key error messages, emotional arc, time-vs-value assessments
- **Agent Behavior** as third required subsection under Challenges & Friction
- **Timeline minimum granularity**: ~5 entries per hour, failed attempts as separate rows
- Aider agent definition (`brain-dump.md`)
- Cline agent definition (`brain-dump.md`)
- Windsurf agent definition (`brain-dump.md`)
- Platform slugs for `aider`, `cline`, `windsurf` in filename convention

### Changed

- All agent definitions now carry Critical: Session Scope and Critical: Experiential Detail sections before other instructions
- Abstract section guidance now requires friction and arc, not just outcomes
- Execution Log guidance now explicitly requires failed attempts and iteration counts
- Technical Exposition guidance now includes Key Errors subsection
- Operator name standardized to "Kat" across all agents
- GitHub Copilot agent file renamed from `brain-dump.chatagent` to `brain-dump.prompt.md`
- Format version bumped to 1.1.0 across all files

## [1.0.0] - 2026-03-03

### Added

- Encounter Document Format Specification v1.0.0
- GitHub Copilot agent definition (`brain-dump.chatagent`)
- Claude Code custom slash command (`brain-dump.md`)
- Cursor rules file (`brain-dump.mdc`)
- Claude.ai project instructions (`brain-dump.md`)
- Install script with copy and symlink modes
- Sample encounter document demonstrating the format