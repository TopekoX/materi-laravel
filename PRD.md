# PRD — Reusable MkDocs Documentation Template

Status: Draft for approval · Date: 2026-10-17

## 0. Phase 1 Audit Summary

| Item | Finding |
|---|---|
| Repository | `D:\Workspace\blog\mkdocs-template`, Git initialised on `main`, **no commits, no remote** |
| Existing content | Only `PROMPT_MKDOCS_TEMPLATE.md` (the task spec). No `mkdocs.yml`, `docs/`, CSS, JS, requirements, or deploy scripts |
| Existing work to preserve | `PROMPT_MKDOCS_TEMPLATE.md` (left untouched). No deployment scripts or safeguards exist |
| GitHub Pages | Not currently used: no remote, no `gh-pages` branch, no workflow |
| Global Python | 3.14.8 (the only interpreter listed by `py -0`); the spec targets 3.12 compatibility |
| Globally installed | mkdocs 1.6.1, mkdocs-material 9.7.7, mkdocs-material-extensions 1.3.1, pymdown-extensions 12.1, Markdown 3.10.3, Pygments 2.21.0 |
| Node | v24.10.0 (available for optional browser-based checks; not a runtime dependency) |

**Conclusion:** greenfield implementation. Nothing needs migrating or overwriting.

**Compatibility issues and risks found**

1. Python 3.14 is installed, not 3.12. The template must be developed in an isolated venv and its dependencies pinned with ranges known to work on 3.12 as well. A 3.12 interpreter is not installed, so 3.12 can be claimed only as "compatible by constraint", not as tested.
2. Material for MkDocs 9.7.x is in maintenance mode and emits a notice about MkDocs 2.0 at build time. The template must cap `mkdocs<2` and must verify that the notice does not fail `--strict`.
3. Global packages are polluted with unrelated tools. The venv must be created fresh so `requirements.txt` reflects what the template actually needs.
4. No browser-automation tooling has been verified. Visual/UI checks may be limited to what can be exercised (see §11).
5. The repo has no `.gitignore`; `site/` and `.venv/` must be excluded.

## 1. Product Overview and Vision

A copy-and-go MkDocs + Material template for long-form educational and technical documentation. One shared, consistent look and feel; each subject (Java, C, C++, Python, JS, ML, Data Science, …) lives in its own repository cloned from this template, changing only metadata, navigation, content, and branding.

## 2. Problem Statement

Separate course sites drift apart in configuration, styling, math support, and deployment. Setting up light/dark mode, MathJax, code highlighting, and GitHub Pages deployment correctly each time is repetitive and error-prone.

## 3. Target Users and Use Cases

- **Author/maintainer** (primary): creates a new subject site from the template in minutes, writes Markdown only.
- **Learner/reader**: reads on desktop, tablet, or phone; searches; switches theme; copies code; reads equations.
- Use cases: programming tutorials, math-heavy ML notes, exercise sets, reference guides.

## 4. Goals and Non-Goals

**Goals:** reuse, consistency, minimal custom code, verified builds, GitHub Pages compatibility.

**Non-goals:** code execution engine; custom frontend framework; template engine or multi-repo framework; full course curricula; custom domain assumptions; external fonts/third-party services; performing any deployment or commit.

## 5. Functional Requirements

### Mandatory
| ID | Requirement |
|---|---|
| F1 | `mkdocs.yml` identifies site name, description, site URL, repo URL/edit links, palette, extensions, nav, extra CSS/JS, deployment-relevant settings, each with comments |
| F2 | Material theme with sidebar hierarchical nav, search, breadcrumbs (path), previous/next footer navigation |
| F3 | Palette with three preferences: System, Light, Dark, using Material's native `palette` toggle (three entries with `media` schemes) |
| F4 | MathJax: inline `$…$` / `\(…\)` and display `$$…$$` / `\[…\]`; fractions, scripts, sums, integrals, matrices, Greek, `aligned`; works inside admonitions and tabs; re-typesets on instant navigation if enabled |
| F5 | Code blocks with highlighting for Java, C, C++, Python, JS/TS, SQL, Bash, YAML, JSON; copy button; optional line numbers/titles/annotations |
| F6 | Admonitions, collapsible details, content tabs, tables, task lists, footnotes, abbreviations, definition lists |
| F7 | Mermaid diagrams via Material's native `pymdownx.superfences` custom fence. Mermaid JS is **vendored and pinned** (11.17.2, MIT) under `docs/assets/vendor/mermaid/`, not loaded from a CDN. Supported: flowchart, sequence, class, state, ER, Gantt, pie, Git graph, mindmap. Follows Light/Dark palette; `securityLevel: strict`; a malformed diagram must not break the page. Demo page `docs/examples/mermaid.md` |
| F8 | Sample content: landing page, getting started, sample curriculum page, programming example, inline + display LaTeX, admonition, table, tabs |
| F9 | Authoring patterns documented and demonstrated: learning objectives, concept, syntax, expected output, tutorial steps, exercises, common mistakes, summary |
| F10 | `README.md` covering install, local dev, customization, new-project creation, deployment |
| F11 | Validation report (`VALIDATION_REPORT.md`) listing tests actually run, results, and unverified items |
| F12 | `requirements.txt` with documented, bounded version ranges (`mkdocs>=1.6,<2`, `mkdocs-material>=9.5,<10`, `pymdown-extensions`) |
| F13 | `.gitignore` excluding `site/`, `.venv/`, caches |

### Optional enhancements (only if native and low cost)
- `navigation.instant`, `navigation.tracking`, `navigation.top`, `content.tabs.link`.
- GitHub Actions workflow template for Pages (provided as documentation/example only, not enabled).
- `examples/` directory of standalone source files outside `docs_dir`, optionally included via `pymdownx.snippets`.
- Social cards, blog plugin, versioning (`mike`) — explicitly deferred.

## 6. Non-Functional Requirements

- Maintainability: custom CSS ≲ 150 lines, custom JS limited to the MathJax config (+ one re-typeset hook).
- No unnecessary dependency upgrades; no `mkdocs>=2`.
- No external fonts: use system font stack (`theme.font: false`) to avoid Google Fonts requests; MathJax loaded from a pinned CDN URL (documented trade-off, see §13) unless vendoring is chosen in the technical design.
- Privacy: no analytics enabled by default.
- Build is reproducible and `mkdocs build --strict` is clean.

## 7. UI/UX Requirements

Per the task spec: responsive layouts; readable typography (line-height ~1.7, content width bounded); hierarchical nav; search; breadcrumbs and prev/next; clear heading hierarchy; wide tables scroll horizontally; styled code blocks with copy; visible focus indicators; sufficient contrast in both schemes; consistent admonition/tab/diagram styling; no clipped or overlapping content. Custom colours only via Material CSS variables (`--md-*`) or `[data-md-color-scheme]` selectors.

## 8. Technical Stack and Architectural Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Generator | MkDocs 1.6.x | Required baseline; installed 1.6.1 |
| Theme | Material for MkDocs 9.x (installed 9.7.7) | Native palette, search, copy, tabs |
| Extensions | `pymdownx.*` (arithmatex generic, superfences, tabbed, highlight, details, snippets, tasklist) + `admonition`, `attr_list`, `md_in_html`, `tables`, `footnotes`, `toc` | Native Material features |
| Math | MathJax 3 via `pymdownx.arithmatex` `generic: true` | Avoids Markdown mangling backslashes |
| Highlighting | Pygments via `pymdownx.highlight` | Build-time, no JS |
| Python | Venv; constraints compatible with 3.12 | Spec baseline |
| Separation | Shared look in `mkdocs.yml` + `docs/stylesheets` + `docs/javascripts`; subject content in `docs/` | Reuse by copy |

## 9. Proposed Directory Structure

```
mkdocs-template/
├── mkdocs.yml
├── requirements.txt
├── README.md
├── PRD.md
├── TECHNICAL_DESIGN.md
├── VALIDATION_REPORT.md
├── .gitignore
├── PROMPT_MKDOCS_TEMPLATE.md      (existing, untouched)
├── docs/
│   ├── index.md
│   ├── getting-started/index.md
│   ├── curriculum/index.md
│   ├── authoring/                 (patterns: code, math, admonitions/tabs/tables)
│   ├── stylesheets/extra.css
│   ├── javascripts/mathjax.js
│   ├── javascripts/mermaid-config.js
│   ├── examples/mermaid.md
│   └── assets/vendor/mermaid/    (pinned Mermaid + LICENSE + VERSION.txt)
└── examples/
    ├── programming/
    └── mathematics/
```

`examples/` sits outside `docs_dir` so it is not published unless snippet-included. No `overrides/` directory unless a feature truly requires it.

## 10. Accessibility and Responsive Requirements

- Keyboard navigable (Material default) with visible `:focus-visible` outlines in both schemes.
- Colour contrast ≥ WCAG AA (4.5:1 body text) in light and dark for custom colours.
- Layout verified at ~1280, ~768, ~375 px widths.
- Tables in `overflow-x: auto` containers; code blocks scroll horizontally; no page-level horizontal scroll.
- Respect `prefers-reduced-motion`; no decorative animation added.
- Images require alt text; equations remain readable by MathJax's assistive MathML.

## 11. Testing and Acceptance Criteria

| Area | Criterion | Method |
|---|---|---|
| Build | deps install in fresh venv; `mkdocs build --strict` exit 0, no warnings | CLI |
| Links | no broken internal links/anchors | strict build (`validation` config) |
| Output | `site/` contains pages, CSS, JS, search index | script/inspection |
| Math | delimiters survive in built HTML (`arithmatex` spans, no mangled `\\`) | HTML grep + browser if available |
| Math rendering | inline/display/aligned/matrix, inside admonition and tab | browser check |
| Theme | System/Light/Dark switching, contrast | browser check |
| Layout | desktop/tablet/mobile overflow check | browser at three widths |
| Interaction | search, copy button, tables | browser check |

If no browser automation is available, only the CLI/HTML checks are reported as passed; the rest are listed as **unverified** in `VALIDATION_REPORT.md`. No test is claimed without evidence.

## 12. Deployment Requirements

- Compatible with `mkdocs gh-deploy` (documented; **not executed**).
- README explains: create repo, set `site_url` and `repo_url`, `gh-deploy`, Settings → Pages → source `gh-pages` branch; project site URL form `https://<user>.github.io/<repo>/`.
- All asset paths relative so the site works under a sub-path; no custom domain (`CNAME`) assumed.
- No commit, push, or deploy is performed during this task.

## 13. Risks, Assumptions, Constraints

- **Mermaid (added later):** the vendored `mermaid.min.js` is ~3.5 MB and is only needed on pages with diagrams (Material mounts it lazily, but `extra_javascript` still downloads it on every page; accepted trade-off, cached after first load). Upgrading Mermaid is a manual file replacement. Known limitations: Gantt/sequence text is small on phone widths; Git-graph branch label colours are fixed for branches 0 and 1 only; Mermaid renders inside a closed shadow root, so page CSS cannot style diagrams (only CSS variables inherit).
- **GitHub API call:** when `repo_url` is set, Material fetches repository facts from `api.github.com` in the browser. Remove `repo_url` to avoid it.

- **Python 3.12 untested** (only 3.14 present) — mitigated by version ranges; stated in validation report.
- **MkDocs 2.0 notice / maintenance-mode Material** — cap `<2`; check strict build.
- **MathJax CDN** is a third-party load. Spec forbids unjustified third-party services; justification: MathJax is explicitly required and Material's documented approach. Alternative (vendoring into `docs/assets`) to be decided in the technical design; default is a pinned jsDelivr URL, documented, with offline vendoring instructions.
- Browser-based verification availability is unknown.
- Assumption: approval of this PRD is implied by the instruction to proceed to technical design; implementation will follow once both documents exist.
