# Mathematics

Math uses MathJax through `pymdownx.arithmatex`. Use `$...$` or `\(...\)` for
inline math and `$$...$$` or `\[...\]` for display math.

## Inline

Included from `examples/mathematics/sigmoid.md`:

--8<-- "mathematics/sigmoid.md"

The sigmoid function is $\sigma(x) = \frac{1}{1+e^{-x}}$. Variables such as
$x_i$, $w^{(l)}_{jk}$, and $e^{-x^2}$ use subscripts and superscripts.
Greek letters: $\alpha, \beta, \gamma, \theta, \lambda, \mu, \sigma, \Sigma, \Omega$.

## Display

$$
f(x) = \frac{1}{\sqrt{2\pi}}e^{-x^2/2}
$$

Summation and integral:

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}, \qquad
\int_{0}^{\infty} e^{-x}\,dx = 1
$$

## Matrices and vectors

$$
\mathbf{y} = W\mathbf{x} + \mathbf{b}, \quad
W = \begin{bmatrix} w_{11} & w_{12} \\ w_{21} & w_{22} \end{bmatrix}, \quad
\mathbf{x} = \begin{pmatrix} x_1 \\ x_2 \end{pmatrix}
$$

## Aligned equations

$$
\begin{aligned}
\mathcal{L}(\theta) &= -\frac{1}{N}\sum_{i=1}^{N}\left[y_i\log \hat{y}_i + (1-y_i)\log(1-\hat{y}_i)\right] \\
\frac{\partial \mathcal{L}}{\partial \theta_j} &= \frac{1}{N}\sum_{i=1}^{N}(\hat{y}_i - y_i)\,x_{ij} \\
\theta_j &\leftarrow \theta_j - \eta\,\frac{\partial \mathcal{L}}{\partial \theta_j}
\end{aligned}
$$

Softmax:

$$
\operatorname{softmax}(z)_k = \frac{e^{z_k}}{\sum_{j=1}^{K} e^{z_j}}
$$

## Inside other components

!!! example "Bayes' rule"
    $$
    P(A \mid B) = \frac{P(B \mid A)\,P(A)}{P(B)}
    $$

    Inline works too: the posterior \(P(A \mid B)\) is proportional to the likelihood.

=== "Variance"

    $\operatorname{Var}(X) = \mathbb{E}[X^2] - (\mathbb{E}[X])^2$

=== "Gradient"

    $\nabla f = \left(\frac{\partial f}{\partial x_1}, \dots, \frac{\partial f}{\partial x_n}\right)$

## Limitations

- MathJax loads from a CDN, so math needs network access.
- A literal dollar sign must be written `\$`.
- Prefer one equation block per `$$` pair; keep blank lines out of display math.
- Each `\\` line break needs an environment such as `aligned` or `cases`.
