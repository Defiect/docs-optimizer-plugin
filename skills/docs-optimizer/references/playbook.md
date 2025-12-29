# AI-Optimized Documentation Playbook

A methodology for optimizing documentation directories for AI agent navigation.

---

## Core Principle

**You are optimizing for AI NAVIGATION EFFICIENCY, not user satisfaction.**

The goal is: given a user query, how quickly can an AI agent locate the relevant file and section? The quality of the answer for the human user is irrelevant to this optimization.

---

## Phase 1: First Impressions Audit

Approach the directory as a fresh agent would. Run `tree` or `ls` and record:

### Entry Point Clarity
- Is there a README.md? (Universal "start here" signal)
- Are there multiple candidates? (Home.md, Overview.md, Index.md = confusion)
- How many seconds until you know where to start?

### Structure Legibility
- Flat vs nested? (Flat is often better for <30 files)
- Are categories visible from filenames alone?
- Can you infer content from filename without opening?

### Naming Consistency
- Case style consistent? (kebab-case, snake_case, PascalCase)
- Special characters? (& in filenames causes shell issues)
- Unicode gotchas? (em-dashes vs hyphens)
- Prefixes consistent?

### Overlap Detection
- Multiple files that sound similar? (Overview vs Home vs Introduction)
- Navigation files? (ToC.md vs _Sidebar.md vs Index.md)

---

## Phase 2: Structural Changes

### Create Clear Entry Point
README.md should contain:
1. One-line description of what this documentation covers
2. "Where to Start" table mapping goals to files
3. Categorized index with brief descriptions
4. Quick Lookup table for common queries

### Fix Filenames
- Remove special characters (& -> and)
- Fix Unicode (em-dash -> hyphen)
- Make names descriptive (Overview.md -> UI-Tour.md if it's actually a UI tour)

### Reduce Redundancy
- One authoritative navigation point (merge ToC into README)
- Delete sidebar/footer files from wiki exports

### Add Cross-Links
- Architecture docs should link to detailed feature docs
- "See Also" sections at end of files
- Inline links where topics are mentioned

### Scope Signaling
- FAQ should clarify what the tool does NOT do
- Comparisons with alternatives help establish boundaries
- Platform requirements prominent in Troubleshooting

---

## Phase 3: Testing with Subagents

### Critical Instruction Framing

**WRONG** (measures user satisfaction):
> "Evaluate if the documentation answers the user's question well"

**RIGHT** (measures navigation efficiency):
> "Track how many tool calls it takes YOU to find relevant information. The quality of the answer for the user is IRRELEVANT."

### Test Question Design

**Easy questions:** Direct lookups with obvious keywords
- "How do I configure log rotation?"

**Medium questions:** Require some inference
- "Why is my build crashing on ARM with sqlite3 errors?"

**Hard questions (chaotic user):** Poor grammar, typos, missing context
- "m service dies after like 10min, logs empt y, java app"

**XY Problem questions:** User asks wrong thing entirely
- "how do i set schedule for 2am" (when tool doesn't do scheduling)

**Out-of-scope questions:** Test scope recognition speed
- "how do i auto-scale on AWS" (completely unrelated to tool's purpose)

### Metrics That Matter

| Metric | What It Measures |
|--------|------------------|
| Tool calls to relevant file | Navigation efficiency |
| Wrong paths taken | Misleading structure/naming |
| README helpfulness | Entry point quality |
| Scope recognition speed | How fast agent realizes "not here" |

### Metrics That DON'T Matter

- Whether docs fully answer user's underlying problem
- Whether docs cover external/adjacent topics
- User satisfaction with the answer

---

## Phase 4: Interpreting Results

### Good Score (8-10)
- 1-3 tool calls per question
- README routes correctly
- Out-of-scope recognized in 1-2 calls
- Minimal wrong paths

### Medium Score (5-7)
- 4-6 tool calls per question
- Some README gaps
- Occasional wrong paths
- Scope boundaries unclear

### Poor Score (1-4)
- 7+ tool calls per question
- No clear entry point
- Many dead ends
- Agent can't determine what's in/out of scope

---

## Common Pitfalls

### Pitfall 1: Measuring User Satisfaction
The biggest mistake. Subagents will naturally evaluate "does this help the user?" unless explicitly told not to. Hammer home that they're measuring THEIR OWN navigation experience.

### Pitfall 2: Giving Hints in Questions
Don't label questions "(hard - wrong tool)" - that tells the agent the answer. Present questions raw.

### Pitfall 3: Treating "Not Covered" as Failure
If docs clearly establish scope and agent quickly recognizes "this isn't covered here," that's a SUCCESS. Well-scoped docs should make boundaries obvious.

### Pitfall 4: Substance vs Structure Conflation
You're optimizing ARRANGEMENT, not content. Don't add new explanatory content - reorganize, rename, cross-link, clarify navigation.

---

## Quick Reference: Subagent Prompt Template

```
You are evaluating a documentation directory's NAVIGABILITY FOR AI AGENTS.

CRITICAL: You are NOT evaluating whether the documentation provides good answers
for end users. You are evaluating how efficiently YOU (the AI agent) can navigate
to find relevant information.

The directory is: [PATH]

FOR EACH QUESTION, REPORT:
- Tool calls to find relevant file (count)
- Wrong paths taken
- Did README point you correctly? (Yes/No/Partially)
- Confusion points
- Did you find relevant information? (Yes/No)

WHAT "FOUND RELEVANT INFO" MEANS:
If docs say "X doesn't do Y" and user asked about Y, you FOUND relevant info.

SCOPE RECOGNITION:
For out-of-scope questions, report how quickly you recognized it and what
signaled the boundaries.

QUESTIONS:
[List questions here - no hints about difficulty or expected answers]

Write report to: [OUTPUT PATH]

SCORING (1-10):
- 9-10: 1-2 tool calls per question, clear scope
- 7-8: 3-4 tool calls, minor detours
- 5-6: 5+ tool calls, some confusion
- 3-4: Many wrong paths, unclear scope
- 1-2: Cannot reliably navigate
```

---

## Files to Create/Modify

| File | Purpose |
|------|---------|
| README.md | Entry point with Quick Lookup table |
| (fix filenames) | Remove &, fix unicode, descriptive names |
| (add cross-links) | Architecture -> feature docs, See Also sections |
| FAQ.md | Include "what this tool does NOT do" |
| Troubleshooting.md | Platform requirements at top |
