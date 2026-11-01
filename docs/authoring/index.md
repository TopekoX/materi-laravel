# Authoring Guide

Reference pages that double as template validation:

- [Code Examples](code.md): seven languages, titles, line numbers, highlights, output.
- [Mathematics](math.md): the supported LaTeX syntax and limitations.
- [Components](components.md): admonitions, tabs, tables, diagrams.

## Conventions

- One `#` heading per page; file names in kebab-case (`01-variables.md`).
- Folders have an `index.md` and appear in `nav` in `mkdocs.yml`.
- Put reusable source files in `examples/` and include them with
  `--8<-- "programming/hello.py"`.
