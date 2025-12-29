# Documentation Navigation Scoring Rubric

## Overall Score Interpretation

### Good Score (8-10)
- **Tool calls:** 1-3 per question average
- **README:** Routes correctly to relevant files
- **Scope:** Out-of-scope questions recognized in 1-2 calls
- **Wrong paths:** Minimal or none
- **Boundaries:** Clear scope signaling

### Medium Score (5-7)
- **Tool calls:** 4-6 per question average
- **README:** Some gaps in routing
- **Scope:** Occasional confusion about boundaries
- **Wrong paths:** Some detours
- **Boundaries:** Somewhat unclear

### Poor Score (1-4)
- **Tool calls:** 7+ per question average
- **README:** No clear entry point or unhelpful
- **Scope:** Agent cannot determine what's in/out of scope
- **Wrong paths:** Many dead ends
- **Boundaries:** Unclear or missing

---

## Per-Question Scoring

| Tool Calls to Find Info | Score Component |
|------------------------|-----------------|
| 1-2 | Excellent |
| 3-4 | Good |
| 5-6 | Acceptable |
| 7+ | Poor |

---

## What Constitutes "Found Relevant Info"

### SUCCESS - Mark as "Found"
- Documentation states "X doesn't do Y" and question was about Y
- Documentation has a section addressing the topic (even if incomplete)
- Agent recognizes out-of-scope quickly and can articulate why
- Documentation points to external resource for topic

### FAILURE - Mark as "Not Found"
- Agent cannot locate ANY relevant information
- Agent searches exhaustively without finding topic mentioned
- No clear scope boundary to recognize out-of-scope

---

## Metrics Per Question

For each test question, report:

| Metric | Description |
|--------|-------------|
| **Tool calls** | Count of Read/Grep/Glob before reaching relevant file |
| **Wrong paths** | Files opened that turned out to be irrelevant |
| **README helpful** | Yes / No / Partially |
| **Confusion points** | Moments of uncertainty about which file to check |
| **Found info** | Yes / No |

---

## Scoring Decision Tree

```
Did agent find relevant information?
├── YES
│   └── How many tool calls?
│       ├── 1-2: Score 9-10
│       ├── 3-4: Score 7-8
│       ├── 5-6: Score 5-6
│       └── 7+:  Score 3-4
└── NO
    └── Was topic out-of-scope?
        ├── YES, recognized quickly: Score 7-8
        ├── YES, took many calls: Score 4-5
        └── NO, should have been found: Score 1-3
```

---

## Interpreting Results for Next Round

### Score >= 8: Consider Complete
- Ask user if they want finishing touches
- Minor improvements may not justify another full round
- Focus on specific suggestions from reviewers

### Score 5-7: Another Round Recommended
- Review confusion points from both agents
- Prioritize fixes that reduce tool calls
- Focus on README improvements and cross-links

### Score < 5: Significant Work Needed
- Start with entry point (README.md)
- Fix filename issues
- Add scope signaling (FAQ, comparisons)
- May need multiple rounds
