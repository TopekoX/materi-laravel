# Code Examples

Every block has a copy button (top right). Content tabs link, so choosing a
language in one group selects it everywhere on the page.

=== "Java"

    ```java title="Hello.java" linenums="1"
    --8<-- "programming/Hello.java"
    ```

=== "C"

    ```c title="hello.c" linenums="1"
    --8<-- "programming/hello.c"
    ```

=== "C++"

    ```cpp title="hello.cpp" linenums="1"
    --8<-- "programming/hello.cpp"
    ```

=== "Python"

    ```python title="hello.py" linenums="1"
    --8<-- "programming/hello.py"
    ```

=== "JavaScript"

    ```javascript title="hello.js" linenums="1"
    --8<-- "programming/hello.js"
    ```

=== "SQL"

    ```sql title="students.sql"
    --8<-- "programming/students.sql"
    ```

=== "Bash"

    ```bash title="hello.sh"
    --8<-- "programming/hello.sh"
    ```

Expected output (all but SQL):

```text
Hello, 1
Hello, 2
Hello, 3
```

## Highlighting and annotations

```python hl_lines="2" title="Highlighted line"
total = 0
total += 5  # (1)!
print(total)
```

1. Annotations explain a line without cluttering the code.

## Other formats

```yaml
site_name: Example
nav:
  - Home: index.md
```

```json
{ "name": "example", "version": 1 }
```

```typescript
const add = (a: number, b: number): number => a + b;
```

Inline code with a language: `#!python print("hi")`.

## Troubleshooting pattern

!!! failure "Error"
    ```text
    SyntaxError: invalid syntax
    ```

    Check for a missing colon or unmatched bracket on the line above.
