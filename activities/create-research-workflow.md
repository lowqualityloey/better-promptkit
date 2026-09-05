# Activity: Build Your Research Workflow

## Overview
Create a structured workflow that guides your AI assistant to conduct thorough, well-cited research on technical topics. You'll design the file structure, citation practices, and validation steps that ensure your research is accurate, traceable, and useful for future learning.

## Why This Matters
As you progress through bootcamp, and on into industry, you'll regularly need to research new technologies, frameworks, patterns, and concepts. A well-designed research workflow ensures:
- **Reliable information** you can trust when building projects
- **Traceable sources** so you can verify claims and dive deeper
- **Reusable notes** that serve as foundations for tutorials, projects, or study sessions
- **Consistent structure** across all your research, making it easier to find what you need

## Your Mission
Design and test your own `research.md` workflow file that lives in `.promptkit/workflows/`. This workflow will guide your AI assistant through structured research sessions, producing high-quality notes you can use for learning and building.

## Key Design Decisions

### 1. Storage & Structure
**Think about:**
- Where should research notes be saved? (Inside `./docs/spikes/`? In a dedicated folder per topic? Alongside the project using the research?)
- What file naming convention makes sense? (`YYYY-MM-DD-topic.md`? `websockets-research.md`? Something else?)
- How should folders be organized? (By date? By technology category? By project?)
- Should there be a master index file that links to all research sessions?

**Design goals:**
- Make it easy to find past research months later
- Avoid filename conflicts as you research similar topics
- Allow your research to live near the code that uses it (if appropriate)

### 2. Citation Management
**Think about:**
- How should your AI record sources as it researches? (Inline footnotes? Reference section at the end? Both?)
- What information should each citation include? (URL, title, author, date accessed, specific section?)
- How can you connect claims in the research notes to their sources? (Numbered citations like [1]? Inline links? Hover-text style annotations?)
- Should there be a "Sources" section with full details, separate from inline references?

**Design goals:**
- Every significant claim should be traceable to a source
- You can quickly verify any fact by following its citation
- Citations are consistent and complete enough to revisit later

### 3. Validation & Fact-Checking
**Think about:**
- How should your AI validate its own research? (Re-check sources? Cross-reference multiple sources? Flag uncertain claims?)
- Should the workflow include a dedicated validation step where the AI reviews its notes and verifies citations?
- What should the AI do if it finds conflicting information across sources? (Flag it? Present both views? Prioritize official docs?)
- How can you instruct the AI to avoid hallucinating sources or facts?

**Design goals:**
- Research notes are accurate and honest about uncertainty
- The AI doesn't cite sources it didn't actually consult
- Conflicting information is surfaced rather than hidden
- You can trust the research enough to build on it

### 4. Output Format
**Think about:**
- What sections should every research note include? (Summary? Deep dive? Key takeaways? Questions for follow-up?)
- How detailed should the notes be? (High-level overview? Code examples? Both?)
- Should there be a TL;DR or executive summary at the top?
- How should code snippets, diagrams, or examples be formatted?

**Design goals:**
- Notes are scannable—you can quickly find what you need
- Enough detail to understand the concept without re-researching
- Clear structure that works whether you read top-to-bottom or jump to sections

## Getting Started

### Step 1: Draft Your Workflow
Create `.promptkit/workflows/research.md` with these sections:
- **Mission** — What the AI should accomplish during a research session
- **Preconditions** — What the student needs before starting (topic, research question, etc.)
- **Workflow Steps** — Detailed instructions for gathering, organizing, citing, and validating research
- **Completion Criteria** — How to know the research session succeeded

Refer to `.promptkit/workflows/tutor.md` and `.promptkit/workflows/reflect.md` for examples of workflow structure and AI-facing instructions.

### Step 2: Test Your Workflow
Activate your research workflow with a real topic:
```
activate the research workflow on [topic]
```

Good starter topics:
- "WebSockets for real-time communication"
- "React Server Components vs. Client Components"
- "JWT authentication best practices"
- "CSS Grid vs. Flexbox layout patterns"

### Step 3: Review the Output
After your AI completes a research session, critically evaluate:
- ✅ Are sources clearly cited for each claim?
- ✅ Can you easily trace facts back to their origins?
- ✅ Is the file structure logical and easy to navigate?
- ✅ Did the AI validate its research or flag uncertainties?
- ✅ Would you trust this research enough to build a project on it?

### Step 4: Refine & Iterate
Based on your review:
- Adjust citation formats if they're too verbose or too sparse
- Clarify storage instructions if files ended up in confusing locations
- Strengthen validation steps if you found unchecked claims or missing sources
- Modify the output structure if sections were unclear or hard to navigate

Run another research session on a new topic and see if your improvements worked.

### Step 5: Extend Your Workflow (Optional Stretch)
Once you have a solid research workflow, consider adding:
- **Curriculum generation** — Use research notes to create personalized tutorials
  ```
  read my research on WebSockets and my learning-plan.md, then draft a tutorial
  that teaches me WebSockets at my current level
  ```
- **Comparison research** — Instruct the AI to research multiple competing technologies and produce a comparison table with trade-offs
- **Progressive research** — Create a workflow that builds on previous research sessions, connecting new findings to past notes
- **Research summaries** — Generate weekly digests of all research conducted, highlighting key themes and open questions

## Success Criteria
You'll know your research workflow is ready when:
- You can activate it with any technical topic and get well-structured, cited notes
- Every claim in your research is traceable to a source you can verify
- You trust the research enough to use it as a foundation for coding projects
- Your notes are organized in a way that makes sense weeks or months later
- The AI validates its own work and flags uncertainty rather than guessing

## Reflection Prompts
After completing this activity, use `workflow reflect` to capture:
- What was hardest about designing citation practices?
- How did validation steps improve (or complicate) the research process?
- What file structure emerged, and does it feel sustainable long-term?
- How might you use this workflow in upcoming projects or study sessions?

## Next Steps
- Add your new research workflow to `notes/learning-plan.md` under "Projects & Practice"
- Test the workflow on a technology you'll need for your next challenge
- Consider building a curriculum generation workflow that reads your research notes and creates custom learning materials
- Share your research workflow approach with peers—different students may have clever citation or validation strategies worth adopting
