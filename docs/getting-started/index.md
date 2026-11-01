# Getting Started

## Learning objectives

- Create a virtual environment and install dependencies.
- Preview the site locally.
- Build it with strict link checking.

## Steps

=== "Windows (PowerShell)"

    ```powershell
    python -m venv .venv
    .venv\Scripts\Activate.ps1
    pip install -r requirements.txt
    mkdocs serve
    ```

=== "macOS / Linux"

    ```bash
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    mkdocs serve
    ```

Open <http://127.0.0.1:8000>. Pages reload as you save.

!!! note "Network access"
    Equations are rendered by MathJax loaded from a CDN, so a network
    connection is needed for math to display.

## Build

```bash
mkdocs build --strict
```

The output goes to `site/`. `--strict` turns broken links and warnings into errors.

## Summary

Install, `mkdocs serve` to preview, `mkdocs build --strict` to verify.
