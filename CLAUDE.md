# Laravel Learning Hub — Project Instructions

## Project
Create beginner-friendly Laravel learning materials using the existing customized MkDocs template.

## Source of Truth
- `PROJECT_AUDIT.md`: verified repository structure and constraints.
- `PRD.md`: project requirements.
- `CURRICULUM.md`: learning sequence and chapter scope.
- `CONTENT_STANDARDS.md`: writing and code-example rules.

Read only the document relevant to the current task.

## Language and Audience
- Explain concepts in Indonesian.
- Preserve official Laravel, PHP, and programming terminology.
- Assume beginners unless the chapter explicitly requires prior knowledge.
- Introduce prerequisites before using advanced concepts.

## Content Rules
For every chapter:
1. State learning objectives and prerequisites.
2. Explain the problem before introducing a solution.
3. Explain each important code line or block.
4. Specify the actual file path for application code.
5. Explain how to execute and verify the example.
6. Show expected output or behavior.
7. Include common errors and debugging guidance.
8. Add practical exercises and official references.

Use complete, runnable examples when multiple snippets depend on one another.

## Technical Accuracy
- Follow the Laravel version selected in `PRD.md`.
- Verify version-sensitive APIs against official documentation.
- Never invent command output or claim unverified code passed tests.
- Explain security implications where relevant.
- Do not expose secrets or recommend committing `.env` credentials.

## Repository Safety
- Follow the existing MkDocs configuration and directory conventions.
- Preserve the customized theme, navigation behavior, scripts, and deployment workflow.
- Do not replace or regenerate the template.
- Do not modify unrelated files.
- Avoid adding dependencies unless required and approved.

## Token Efficiency
- Work on one chapter or one bounded task at a time.
- Read only relevant files and referenced instructions.
- Avoid rereading or printing entire documents.
- Prefer targeted diffs and concise completion reports.
- Do not regenerate unchanged content.
- Ask before expanding the approved scope.

## Completion
Before finishing:
- Check the changed files and diff.
- Verify internal links and navigation when relevant.
- Run the repository's documented MkDocs build command when applicable.
- Report changed files, checks performed, failures, and remaining work.

## Curriculum Rules
IMPORTANT:
- CURRICULUM.md is the single source of truth
  for the Laravel learning curriculum.
- Always read CURRICULUM.md before creating
  or modifying learning materials.
- Follow the curriculum's level and chapter order.
- Never invent, remove, rename, or reorder chapters
  without explicit approval.
- Do not skip any chapter.
- Maintain chapter completion status.
- Do not generate all chapters at once.
- Work on one chapter per task.