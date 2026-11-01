# Mermaid Diagrams

Write a fenced block with the `mermaid` language. Diagrams follow the active
Light/Dark theme automatically.

## Flowchart

```mermaid
flowchart TD
    A[Start] --> B[Input Data]
    B --> C[Preprocessing]
    C --> D[Machine Learning]
    D --> E[Prediction]
```

## Sequence diagram

```mermaid
sequenceDiagram
    participant U as Learner
    participant S as Site
    U->>S: Open chapter
    S-->>U: Page with code and math
    U->>S: Search "sigmoid"
    S-->>U: Matching sections
```

## Class diagram

```mermaid
classDiagram
    class Animal {
        +String name
        +speak() void
    }
    class Dog {
        +fetch() void
    }
    Animal <|-- Dog
```

## State diagram

```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review: submit
    Review --> Draft: changes requested
    Review --> Published: approve
    Published --> [*]
```

## Entity relationship diagram

```mermaid
erDiagram
    STUDENT ||--o{ ENROLLMENT : has
    COURSE ||--o{ ENROLLMENT : includes
    STUDENT {
        int id
        string name
    }
    COURSE {
        int id
        string title
    }
```

## Gantt chart

```mermaid
gantt
    title Course schedule
    dateFormat YYYY-MM-DD
    section Basics
    Variables      :a1, 2026-01-05, 7d
    Control flow   :after a1, 7d
    section Advanced
    Data structures :2026-01-19, 10d
```

## Pie chart

```mermaid
pie title Time spent per topic
    "Reading" : 40
    "Exercises" : 45
    "Projects" : 15
```

## Git graph

```mermaid
gitGraph
    commit
    branch feature
    checkout feature
    commit
    commit
    checkout main
    merge feature
    commit
```

## Mindmap

```mermaid
mindmap
  root((Programming))
    Languages
      Java
      C
      Python
    Concepts
      Loops
      Functions
```

## Malformed diagram

An invalid diagram shows an error in its own block; the rest of the page is unaffected.

```mermaid
flowchart TD
    A[Start --> ???
```

## Notes

- Mermaid is vendored at `docs/assets/vendor/mermaid/` (pinned version, MIT) and
  needs no network access.
- Mermaid runs with its default `strict` security level.
- Diagram source is plain text in the generated HTML until JavaScript renders it.
