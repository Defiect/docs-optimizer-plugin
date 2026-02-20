---
name: docs-optimizer
description: Optimizes documentation directories for AI agent navigation efficiency. Use when the user asks to "optimize documentation", "improve docs for AI", "make docs more navigable", "optimize docs navigation", "review documentation structure", mentions "documentation efficiency" or "AI navigation", or discusses improving how AI agents find information in documentation directories.
version: 1.2.0
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
  - Task
---

# Documentation Optimizer

This skill optimizes documentation directories so AI agents can navigate them efficiently.

## CRITICAL: North Star Principle

**You are optimizing for AI NAVIGATION EFFICIENCY, not user satisfaction.**

The goal: Given a user query, how quickly can an AI agent locate the relevant file and section?

### What You ARE Optimizing
- **Entry point clarity** - Is README.md immediately obvious as the starting point?
- **File discoverability** - How many tool calls to find the relevant file?
- **Navigation friction** - How many wrong turns, dead ends, wasted calls?
- **Cross-linking** - Do internal links help agents traverse topics?
- **Scope recognition** - How fast can an agent recognize "this isn't covered here"?

### What You Are NOT Optimizing
- Whether docs fully answer the user's underlying problem
- Whether docs cover external/adjacent topics
- User satisfaction with answers

**If an agent finds "we don't support X" in 2 tool calls, that's SUCCESS - even if the user wanted X.**

For detailed explanation, see [references/north-star.md](./references/north-star.md).

---

## Workflow Overview

### Phase 0: Context Gathering

Before starting optimization, ask the user:

1. **Documentation location**: Where are the docs? (current directory, subdirectory, etc.)
2. **Additional context sources**:
   - Source code to reference for understanding the tool?
   - URLs or web resources to consult?
   - Specific pain points or areas of concern?
3. **Scope**: What does this tool/project do? What does it NOT do?

Read the documentation directory thoroughly before proceeding.

### Phase 1: First Impressions Audit

Approach the directory as a fresh agent would:

1. Run `tree` or `ls` to see the structure
2. Check for README.md (universal "start here" signal)
3. Record pain points:
   - "Where do I start?"
   - "Which file has X?"
   - "These files sound similar..."

Evaluate:
- **Entry point clarity**: Is there one clear starting point?
- **Structure legibility**: Can you infer content from filenames?
- **Naming consistency**: Case style, special characters, prefixes?
- **Overlap detection**: Multiple similar-sounding files?

### Phase 2: Structural Changes

Make improvements following the playbook:

1. **Create/improve README.md** with:
   - One-line description
   - "Where to Start" table (goal -> file)
   - Categorized index with descriptions
   - Quick Lookup table for common queries

2. **Fix filenames**:
   - Remove special characters (& -> and)
   - Fix Unicode issues (em-dash -> hyphen)
   - Make names descriptive

3. **Reduce redundancy**:
   - Merge ToC/Index into README
   - Delete wiki export artifacts (_Sidebar.md, _Footer.md)

4. **Add cross-links**:
   - "See Also" sections
   - Inline links where topics are mentioned

5. **Add scope signaling**:
   - FAQ: What this tool does NOT do
   - Comparisons with alternatives
   - Platform requirements in Troubleshooting

For detailed guidance, see [references/playbook.md](./references/playbook.md).

### Phase 3: Git Commit

Before making edits:
- Ensure a commit exists (create initial commit if needed)
- Never edit uncommitted work

After making structural changes:
- Commit with descriptive message
- Provide summary of changes to user

### Phase 4: Spawn Reviewer Subagents

Launch TWO reviewer subagents **IN PARALLEL**:

1. **Haiku reviewer** (fast, cost-effective)
   - Output: `.claude/reviews/haiku-review.md`

2. **Sonnet reviewer** (thorough analysis)
   - Output: `.claude/reviews/sonnet-review.md`

Both receive the same dynamically generated test questions.

Create the `.claude/reviews/` directory if it doesn't exist.

### Phase 5: Synthesize Results

After both reviewers complete:

1. Read both review files
2. Extract scores and metrics
3. Calculate average score
4. Identify common issues flagged by both
5. Note differences in findings (Sonnet often catches more nuance)
6. Note the round number (from `.claude/docs-optimizer.local.md`) when presenting results, making clear that scores across rounds are directly comparable since the same test questions are used

Present to user:
- Round number
- Individual scores (Haiku: X/10, Sonnet: X/10)
- Average score
- Key findings from both reviewers
- Specific improvement suggestions

### Phase 5b: Conciseness Review

Skip this phase on the initial round (before any review-driven Opus edits).
Run this phase starting from Round 2 (after the first Opus edit based on
reviewer feedback).

1. Generate the git diff of the most recent Opus edit commit:
   `git diff HEAD~1 -- [docs-directory]`
   Store the diff output as a string to pass to reviewers.

2. Spawn TWO conciseness reviewer subagents IN PARALLEL:
   - Haiku conciseness reviewer -> .claude/reviews/haiku-conciseness.md
   - Sonnet conciseness reviewer -> .claude/reviews/sonnet-conciseness.md

3. Provide each with:
   - Documentation directory path
   - The git diff output (inline in the prompt)
   - Output file path

4. After both complete, read their reviews and include conciseness
   scores in the Phase 6 synthesis.

### Phase 6: Decision Point

Based on average score:

**Score >= 8**: Ask user:
- "Documentation scores well. Would you like to stop here, or should I apply finishing touches based on reviewer suggestions?"
- If finishing touches: Make targeted improvements, commit, but do NOT run another full review round

**Score 5-7**: Recommend another round:
- "Reviewers identified room for improvement. I recommend another optimization round focusing on: [specific issues]"
- Proceed to Phase 2 with focused improvements

**Score < 5**: Significant work needed:
- "Documentation needs substantial improvements. Starting with fundamentals: entry point, naming, scope signaling."
- Proceed to Phase 2 with comprehensive changes

Present to user:
- Navigation scores (Haiku: X/10, Sonnet: X/10, avg)
- Conciseness scores (Haiku: X/10, Sonnet: X/10, avg) — if Phase 5b ran
- Diff impact: Did the review-driven edit improve, degrade, or not affect conciseness? — if Phase 5b ran
- Combined improvement suggestions

---

## Dynamic Test Question Generation

Generate **10** project-specific test questions based on documentation content.

### Question Persistence

Before generating questions, check if `.claude/docs-optimizer.local.md` exists
and contains a `test_questions` key in its YAML frontmatter.
- If yes: Use those exact questions. Do not modify or regenerate them.
- If no: Generate questions per the categories below, then write them to
  `.claude/docs-optimizer.local.md` with YAML frontmatter:
  ```
  ---
  test_questions:
    - "How do I configure X?"
    - "Why is Y happening?"
    - ...
  docs_directory: "/path/to/docs"
  round: 1
  ---
  ```

Increment the `round` counter in `.claude/docs-optimizer.local.md` each time
reviewers are spawned.

### Question Categories

**Easy (2-3 questions)**: Direct lookups with obvious keywords
- Pattern: "How do I [common task visible in doc titles]?"
- Look at: File names, README sections, feature lists

**Medium (2-3 questions)**: Require some inference
- Pattern: "Why is [problem] happening with [context]?"
- Look at: Troubleshooting sections, error messages, platform issues

**Hard/Chaotic (1-2 questions)**: Poor grammar, typos, missing context
- Pattern: Simulate distressed user
- Take a medium question and add: typos, remove context, fragment sentences

**XY Problem (1-2 questions)**: User asks about feature the tool doesn't have
- Pattern: Request for something the tool explicitly doesn't do
- Look at: FAQ "what we don't do", comparison docs, scope boundaries

**Out-of-scope (1 question)**: Completely unrelated topic
- Pattern: Something entirely outside the tool's domain
- Purpose: Test how quickly scope boundaries are recognized

### Question Generation Process

1. Read documentation structure and README
2. Identify main features (from headings, file names)
3. Identify what tool does NOT do (FAQ, comparisons)
4. Generate questions covering all categories
5. **Present questions RAW** - no hints about difficulty or expected answers

### Example Questions (adapt to actual project)

```
Q1: "How do I configure [obvious feature from doc titles]?"
Q2: "Why am I getting [error from troubleshooting] on [platform]?"
Q3: "[same as Q2 but with typos, fragments, panic tone]"
Q4: "how do i [thing the tool explicitly doesn't do]"
Q5: "[completely unrelated topic like 'kubernetes scaling' for a desktop app]"
```

---

## Invoking Reviewer Agents

When spawning reviewers, provide:

```
Documentation directory: [PATH]

Test questions (answer these by navigating the docs):
1. [Q1]
2. [Q2]
3. [Q3]
4. [Q4]
5. [Q5]

Write your review to: [OUTPUT PATH]
```

Spawn both agents in the same message to run in parallel.

---

## Scoring Reference

| Score | Tool Calls/Question | Navigation Quality |
|-------|--------------------|--------------------|
| 9-10 | 1-2 | Perfect - README guides directly |
| 7-8 | 3-4 | Good - minor detours |
| 5-6 | 5-6 | Acceptable - some confusion |
| 3-4 | 7+ | Poor - many wrong paths |
| 1-2 | Many | Failing - cannot navigate |

For detailed scoring criteria, see [references/scoring-rubric.md](./references/scoring-rubric.md).

---

## Common Pitfalls to Avoid

1. **Measuring user satisfaction** - Subagents will naturally evaluate "does this help the user?" unless explicitly told not to. The reviewer agents are already configured correctly.

2. **Giving hints in questions** - Don't label questions "(hard)" or "(wrong tool)". Present raw.

3. **Treating "not covered" as failure** - If docs establish scope and agent recognizes it quickly, that's SUCCESS.

4. **Optimizing content, not structure** - You're optimizing ARRANGEMENT. Don't add new explanatory content - reorganize, rename, cross-link.
