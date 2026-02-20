# Documentation Optimizer Plugin

A Claude Code plugin that optimizes documentation directories for AI agent navigation efficiency.

## What It Does

This plugin helps you restructure documentation so that AI agents can find relevant information quickly. It measures success by **tool calls** (how many Read/Grep/Glob operations), not by whether the docs "help users."

Key insight: If an agent finds "we don't support X" in 2 tool calls, that's a success - even if the user wanted X.

## Installation

Copy this plugin directory to your Claude Code plugins location:

```bash
cp -r docs-optimizer-plugin ~/.claude/plugins/
```

Or clone directly:

```bash
git clone git@github.com:Defiect/docs-optimizer-plugin.git ~/.claude/plugins/docs-optimizer-plugin
```

## Usage

The skill auto-activates when you mention documentation optimization. Try:

- "Optimize this documentation for AI navigation"
- "Improve these docs for AI agents"
- "Review the documentation structure"

### Workflow

1. **Context gathering** - Claude asks about the docs location and any additional context
2. **First impressions audit** - Examines structure, naming, entry points
3. **Structural changes** - Creates/improves README, fixes names, adds cross-links
4. **Git commit** - Commits changes for safety
5. **Parallel navigation review** - Spawns Haiku and Sonnet reviewers with 10 test questions
6. **Synthesis** - Aggregates navigation scores and suggestions
7. **Conciseness review** (Round 2+) - Spawns conciseness reviewers with the git diff of the latest edit
8. **Decision** - Presents navigation + conciseness scores; if < 8, another round; if >= 8, optional finishing touches

Test questions are persisted to `.claude/docs-optimizer.local.md` so scores are directly comparable across rounds.

### Scoring

| Score | Meaning |
|-------|---------|
| 9-10 | Excellent - 1-2 tool calls per question |
| 7-8 | Good - 3-4 tool calls, minor detours |
| 5-6 | Acceptable - 5+ tool calls, some confusion |
| 3-4 | Poor - many wrong paths |
| 1-2 | Failing - cannot navigate reliably |

## Plugin Structure

```
docs-optimizer-plugin/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── skills/
│   └── docs-optimizer/
│       ├── SKILL.md          # Main skill (orchestrates workflow)
│       └── references/
│           ├── north-star.md     # Core principle
│           ├── playbook.md       # 4-phase methodology
│           └── scoring-rubric.md # Scoring criteria
├── agents/
│   ├── haiku-reviewer.md              # Fast navigation reviewer
│   ├── sonnet-reviewer.md             # Thorough navigation reviewer
│   ├── haiku-conciseness-reviewer.md  # Fast conciseness reviewer
│   └── sonnet-conciseness-reviewer.md # Thorough conciseness reviewer
├── hooks/
│   ├── hooks.json            # PreToolUse/PostToolUse hook config
│   ├── pre-subagent.sh       # Archives reviews before subagent spawn
│   └── post-subagent.sh      # Restores reviews after subagent completes
└── README.md
```

## Core Principle

**Optimize for AI navigation efficiency, NOT user satisfaction.**

This is counterintuitive but critical. We measure:
- Tool calls to find relevant file
- Wrong paths taken
- README effectiveness
- Scope recognition speed
- Conciseness (redundancy, duplication, fluff)

We do NOT measure:
- Whether docs fully answer user's problem
- Whether docs cover external topics
- User satisfaction

## Changelog

### v1.2.0 (2026-02-20)
- Test questions persisted to `.claude/docs-optimizer.local.md` for cross-round score comparability
- Added PreToolUse/PostToolUse hooks to isolate reviewer subagents from prior review files
- Added file access scope restrictions to reviewer agents
- Added Phase 5b conciseness review with dedicated haiku/sonnet conciseness reviewers
- Expanded test questions from 5-6 to 10 with broader category ranges
- Synthesis now presents round numbers and conciseness scores alongside navigation scores

### v1.1.0 (2026-01-10)
- Updated to Claude Code 2.1.x frontmatter format
- Converted `tools` to `allowed-tools` YAML array format
- Added `disallowedTools` to reviewer agents (prevents editing source docs)
- Added explicit `allowed-tools` to main skill for clarity

### v1.0.0
- Initial release with Haiku/Sonnet parallel review system
- Optimization workflow with iterative review rounds
- Dynamic test question generation

## Credits

Methodology developed through iterative testing on real documentation sets, measuring actual AI agent navigation patterns with Haiku and Sonnet reviewers.
