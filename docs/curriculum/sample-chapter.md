# Sample Chapter: Loops

## Learning objectives

By the end of this chapter you can:

- [x] Explain what a counting loop does.
- [x] Write one in several languages.
- [x] Relate loop cost to a summation.

## Concept

A loop repeats a block of code. A counting loop runs once for each value of an
index from a start to an end.

## Syntax and example

=== "Python"

    ```python title="hello.py"
    --8<-- "programming/hello.py"
    ```

=== "Java"

    ```java title="Hello.java"
    --8<-- "programming/Hello.java"
    ```

=== "C"

    ```c title="hello.c"
    --8<-- "programming/hello.c"
    ```

=== "C++"

    ```cpp title="hello.cpp"
    --8<-- "programming/hello.cpp"
    ```

Expected output:

```text
Hello, 1
Hello, 2
Hello, 3
```

## Cost of a loop

Summing the work done by a loop that runs \(n\) times with cost \(i\) at step \(i\):

$$
T(n) = \sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

## Step-by-step

1. Choose the start, end, and step.
2. Write the loop header.
3. Put the repeated work in the body.
4. Run it and compare with the expected output.

## Common mistakes

!!! warning "Off-by-one errors"
    `range(1, 3)` in Python stops at 2. Use `range(1, 4)` to include 3.

??? question "Why does my loop never end?"
    The loop variable is never updated, or the condition can never become false.

## Exercises

1. Print the numbers 10 down to 1.
2. Print the sum of the first 100 integers and check it against \(\frac{n(n+1)}{2}\).

## Summary

A counting loop repeats work for each index; its total cost is often a sum.
