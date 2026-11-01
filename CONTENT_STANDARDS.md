# Laravel Learning Hub — Content Standards

## 1. General Writing Principles

All learning materials must follow these principles:

- Use Indonesian as the primary language.
- Keep technical terms in their original English terminology.
- Write for beginners who have little or no Laravel experience.
- Explain concepts progressively, from basic to advanced.
- Use clear, structured, and educational language.
- Avoid unexplained technical jargon.
- Never assume readers understand concepts that have not been introduced.
- Explain why a feature is needed before explaining how to use it.
- Use practical examples related to real-world application development.

## 2. Learning Approach

Every topic must follow this learning sequence:

1. Understand the concept.
2. Understand why the concept is important.
3. Understand how the concept works.
4. Follow a practical example.
5. Understand the code implementation.
6. Execute the example.
7. Observe and verify the result.
8. Complete a practical exercise.

Use simple analogies when they help beginners understand abstract concepts.

## 3. Standard Chapter Structure

Every chapter must use the following structure when applicable:

1. Chapter Title
2. Learning Objectives
3. Prerequisites
4. Introduction
5. Concept Explanation
6. How It Works
7. Practical Example
8. Code Explanation
9. Step-by-Step Implementation
10. Execution and Verification
11. Expected Results
12. Common Errors and Troubleshooting
13. Practical Exercises
14. Knowledge Check
15. Chapter Summary
16. Official References

Do not force sections that are irrelevant to a particular topic. However, essential learning and verification sections must not be omitted.

## 4. Concept Explanation Standards

For every important concept:

- Define the concept clearly.
- Explain its purpose.
- Explain why it is used in Laravel.
- Explain how it works internally when relevant.
- Provide a simple analogy when useful.
- Explain its relationship with previously learned concepts.
- Provide practical use cases.
- Mention limitations or alternatives when relevant.

Avoid explanations that only provide definitions without practical context.

## 5. Code Example Standards

Every code example must follow these requirements.

### 5.1 Code Completeness

- Use valid syntax compatible with the selected Laravel version.
- Provide complete examples whenever multiple snippets depend on one another.
- Include necessary imports, class definitions, and relevant configuration.
- Avoid unexplained placeholders.
- Never present pseudocode as executable code without labeling it.

### 5.2 File Location

Every application code example must specify its actual file location.

Example:

File: `routes/web.php`

### 5.3 Code Explanation

For every important code block:

- Explain the purpose of the code.
- Explain important lines individually or in logical groups.
- Explain functions, methods, parameters, and return values.
- Explain the relationship between the code components.
- Explain what happens when the code executes.
- Explain why a particular implementation is used.

For long code examples, divide the explanation into smaller sections.

Do not explain every punctuation character or trivial syntax unless necessary for beginners.

### 5.4 Code Execution

Every practical example must include:

- Required prerequisites.
- Commands to execute.
- The correct working directory.
- Required environment or configuration.
- Expected application behavior.
- Verification instructions.

Never claim that code has been tested unless it has actually been executed.

## 6. Code Example Presentation

Use appropriate Markdown code fences and language identifiers.

Examples:

```php
<?php

Route::get('/hello', function () {
    return 'Hello Laravel';
});
```

Terminal commands:

```bash
php artisan serve
```

SQL examples:

```sql
SELECT * FROM users;
```

JSON examples:

```json
{
    "message": "Success"
}
```

Use short code examples first, then gradually introduce more complex implementations.

## 7. Practical Learning Standards

Every chapter should contain practical activities appropriate to its difficulty.

Exercises should include:

- Beginner exercises for basic understanding.
- Implementation exercises for practical skills.
- Challenge exercises for independent problem-solving.

Each exercise should specify:
- Problem description.
- Requirements.
- Expected behavior.
- Learning objectives.

Provide hints or solutions where appropriate. Do not reveal complete solutions immediately when the exercise is intended for independent practice.

## 8. Progressive Difficulty

Organize topics according to the learning sequence in CURRICULUM.md.

Rules:

- Do not introduce advanced concepts before their prerequisites.
- Explain prerequisite concepts before using them.
- Reuse previously learned concepts in later chapters.
- Increase code complexity gradually.
- Avoid introducing multiple new concepts in one beginner example.
- Clearly distinguish basic, intermediate, and advanced material.

## 9. Laravel Technical Standards

- Follow the Laravel version specified in PRD.md.
- Use official Laravel documentation as the primary technical reference.
- Use appropriate Laravel conventions and recommended practices.
- Use Artisan commands where appropriate.
- Explain the MVC architecture when relevant.
- Explain the purpose of Laravel directories when introducing them.
- Avoid deprecated APIs unless teaching version compatibility.
- Clearly identify version-specific differences.
- Never invent framework features or Artisan commands.

## 10. Security Standards

When a topic involves security:

- Explain the relevant security risks.
- Demonstrate safe implementation practices.
- Explain authentication and authorization differences.
- Include validation and sanitization where relevant.
- Explain CSRF and XSS protection when applicable.
- Avoid exposing credentials, tokens, and sensitive environment variables.
- Never recommend committing `.env` files containing secrets.
- Explain common vulnerabilities and prevention techniques.

## 11. Visual Learning

Use visual explanations when they improve understanding.

Preferred formats:

- Mermaid diagrams for workflows.
- Flowcharts for application processes.
- Sequence diagrams for request lifecycles.
- Tables for comparing concepts.
- Directory trees for project structures.
- Screenshots only when they provide meaningful learning value.

All diagrams must be technically accurate and consistent with the explanation.

## 12. Markdown and MkDocs Standards

- Use Markdown compatible with the existing MkDocs configuration.
- Use `#` for the main page title.
- Use `##` for main sections.
- Use `###` for subsections.
- Maintain consistent heading hierarchy.
- Use descriptive file names.
- Use relative links for internal documentation.
- Use fenced code blocks with language identifiers.
- Use tables only when they improve readability.
- Avoid unnecessary HTML.
- Follow the repository's existing theme and navigation conventions.

## 13. References and Sources

- Prioritize official Laravel documentation.
- Reference official PHP documentation when discussing PHP fundamentals.
- Include relevant documentation links at the end of each chapter.
- Use sources that match the selected framework version.
- Never fabricate references or URLs.
- Distinguish official documentation from supplementary learning resources.

## 14. Common Errors and Troubleshooting

When relevant, explain:

- Error message or symptom.
- Why the error happens.
- How to identify the problem.
- Step-by-step troubleshooting.
- Correct implementation.
- How to prevent the issue.

Prefer realistic errors that beginners commonly encounter.

## 15. Content Quality Checklist

Before marking a chapter as complete, verify:

- [ ] The chapter follows CURRICULUM.md.
- [ ] The learning objectives are clear.
- [ ] The explanation is beginner-friendly.
- [ ] Important technical terms are explained.
- [ ] Code examples specify their file locations.
- [ ] Important code lines are explained.
- [ ] Commands and execution steps are provided.
- [ ] Expected results are described.
- [ ] Common errors are discussed where relevant.
- [ ] Exercises are included.
- [ ] References are valid and relevant.
- [ ] Markdown structure is consistent.
- [ ] Internal links are correct.
- [ ] Technical details match the selected Laravel version.

## 16. Content Completion Status

Use the following status definitions:

- NOT_STARTED: Content has not been written.
- DRAFT: Initial content has been created.
- IN_REVIEW: Content is being reviewed.
- NEEDS_REVISION: Content requires corrections.
- VERIFIED: Content has passed technical and editorial checks.
- PUBLISHED: Content has been approved and published.

A chapter must not be marked VERIFIED unless its technical accuracy and learning requirements have been checked.

## 17. Final Quality Principle

The objective is not simply to document Laravel features.

The objective is to teach readers how to understand, implement, execute, troubleshoot, and apply Laravel concepts independently.

Every chapter must prioritize learning quality, technical accuracy, practical implementation, and beginner comprehension.