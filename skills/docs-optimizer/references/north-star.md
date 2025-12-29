# North Star: What We're Actually Optimizing

## The Core Goal

> "...so that if I were to ask a different AI agent, they would instantly see where to go to get what they're looking for 99% of the time."

This optimization targets **AI agent navigation efficiency**, not end-user satisfaction with answers.

## What We ARE Optimizing

**AI agent navigation efficiency.** Specifically:

1. **Entry point clarity** - When an agent lands in the directory, is it immediately obvious where to start?
2. **File discoverability** - Given a user query, how quickly can the agent identify which file(s) contain relevant information?
3. **Navigation friction** - How many wrong turns, dead ends, or wasted tool calls does the agent make?
4. **Cross-linking effectiveness** - Do internal links help the agent traverse related topics, or do they get lost?
5. **Information density** - Once in the correct file, is the relevant section easy to locate?

## What We Are NOT Optimizing

**End-user documentation quality.** Specifically, we do NOT care about:

- Whether the documentation provides a complete answer to the user's underlying problem
- Whether the documentation covers all possible use cases
- Whether the documentation explains external tools or adjacent topics
- Whether the answer is "helpful" from a user satisfaction standpoint

## Correct Evaluation Criteria

For any test question, the agent should report:

| Metric | What It Measures |
|--------|------------------|
| **Tool calls to locate relevant file** | How many Read/Grep/Glob operations before finding the right file |
| **Wrong paths taken** | Files opened that turned out to be irrelevant |
| **Entry point effectiveness** | Did README.md guide them correctly, or did they have to guess? |
| **Cross-link usefulness** | Did links within files help, or were they noise? |
| **Time to relevant section** | Once in the right file, how easy was it to find the specific info? |

## Example: Correct vs Incorrect Evaluation

**User question:** "how do i set up automatic scheduling for my tasks"

### INCORRECT Evaluation (measures user satisfaction)
> "The documentation doesn't explain how to integrate with cron or Task Scheduler. This is a significant gap. Score: 5/10"

This evaluates the **content completeness for the end user**, which is NOT our goal.

### CORRECT Evaluation (measures navigation efficiency)
> "Navigation path: README.md -> searched for 'schedule' -> FAQ.md mentioned external schedulers. Found relevant info in 2 tool calls. The FAQ clearly states the tool doesn't do scheduling. Agent successfully located the relevant information. Score: 9/10"

The fact that the docs don't *teach external schedulers* is irrelevant. The agent found information that answers "does this tool do scheduling?" efficiently. Mission accomplished.

## The One Question That Matters

For each test question, the evaluating agent should ask:

> "How efficiently could I (the AI agent) navigate to the file and section containing information relevant to this query?"

NOT:

> "Does this documentation fully solve the user's problem?"

## Key Insight: Scope Recognition is Success

If documentation clearly establishes scope boundaries and the agent quickly recognizes "this topic isn't covered here," that's a **SUCCESS**, not a failure. Well-scoped docs should make boundaries obvious.
