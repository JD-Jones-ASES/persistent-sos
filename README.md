# Persistent failure of quartic SOS exactness

An explicit rational cubic in 14 variables has sphere maximum one but a
strictly larger degree-four moment value. The resulting quartically
regularized polynomial fails sum-of-squares exactness for **every positive
regularization parameter**, with its quadratic and cubic data fixed.

For the 25-term cubic $`C`$ specified in [Proof.md](Proof.md), set

```math
P_{\sigma,a,b}(z)=\frac{\sigma}{4}\|z\|^4-\frac a2\|z\|^2-bC(z),
\qquad \sigma,a,b>0.
```

With

```math
r=\frac{3b+\sqrt{9b^2+4a\sigma}}{2\sigma},
\qquad \mu=-\frac{br^3+ar^2}{4},
\qquad \delta=\frac{753357629}{500000000000},
```

the actual global minimum is $`\mu`$, attained at $`(r,0,\ldots,0)`$.
The polynomial $`P_{\sigma,a,b}-\mu`$ is nonnegative and is not a sum of
squares of real polynomials. Every SOS lower bound $`\gamma`$ satisfies

```math
\gamma\le\mu-b\delta r^3<\mu.
```

At the origin the gradient vanishes and the Hessian is $`-aI_{14}`$.
The complete minimizer set is also classified: an isolated axis point and an
eight-dimensional sphere. The specialization $`a=b=1`$ answers the stationary, non-PSD-Hessian
question in Cartis–Zhu, Remark 2.3, for the Euclidean quartic regularizer.

## A unique nondegenerate minimizer

A second fixed cubic, still with 25 monomials in 14 variables, is

```math
\widehat C(z)=\frac{1000C(z)+z_0\|z\|^2}{1001}.
```

Replacing $`C`$ by $`\widehat C`$ preserves the same radius $`r`$ and
minimum $`\mu`$. The unique global minimizer is $`(r,0,\ldots,0)`$,
and its Hessian is positive definite, with diagonal blocks

```math
2a+3br,\qquad \frac{br}{1001}I_4,\qquad
\frac{9001br}{1001}I_9.
```

Nevertheless, the exact minimum shift is not SOS for any positive
regularization parameter. Every SOS lower bound obeys

```math
\gamma\le\mu-b\widehat\delta r^3<\mu,
\qquad \widehat\delta=\frac{132860603}{143000000000}.
```

The [companion proof](UniqueMinimizer.md) reuses the same rational moment
certificate. Positive curvature here is at the minimizer; the Hessian at
the stationary origin remains $`-aI_{14}`$.

## Reading

- [Note.md](Note.md): mathematical overview and significance.
- [Proof.md](Proof.md): explicit construction and complete written proof.
- [Applications.md](Applications.md): parameter scaling, minimizers and robustness.
- [UniqueMinimizer.md](UniqueMinimizer.md): the unique nondegenerate minimizer theorem and a general selection principle.
- [RadialConsequences.md](RadialConsequences.md): written optimized-scale bounds and flat- and positive-Hessian consequences.
- [Sources.md](Sources.md): primary sources and exact attribution.
- [Disclosure.md](Disclosure.md): production and review account.
- [VERIFICATION.md](VERIFICATION.md): formal scope, checks and exact revisions.

The independent statement interface is
[PersistentSOSChallenge.lean](PersistentSOSChallenge.lean); the proof entry
is [PersistentSOSSolution.lean](PersistentSOSSolution.lean).

## Reproduction

```sh
lake build
python3 scripts/check_certificate.py
python3 scripts/independent_certificate_check.py --negative-controls
python3 scripts/check_unique_minimizer.py
python3 scripts/check_sources.py
python3 scripts/audit_axioms.py
```

The formal statements, verification commands and exact-commit evidence are
recorded in [VERIFICATION.md](VERIFICATION.md). Submission and registration
are separate steps. No optimal SOS value, smallest possible
dimension, worldwide priority, or human specialist review is claimed.

MIT license, copyright 2026 JD Jones.
