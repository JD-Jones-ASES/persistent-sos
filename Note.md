# A fixed obstruction at every regularization strength

Large quartic regularization can make a cubic optimization model coercive
without making its exact minimum shift a sum of squares. This package gives
a concrete instance: one rational cubic with 25 monomials in 14 real
variables works at every positive regularization strength.

The construction has two independently checkable ingredients. First, an
analytic contraction identity proves that the cubic has maximum one on the
unit sphere, attained on a specified coordinate axis. Second, 450 rational
moments define a linear functional that is nonnegative on the square of every
quadratic polynomial and assigns the cubic the value

```math
1+\frac{753357629}{500000000000}.
```

The moments satisfy the sphere relation through degree four. They are a
positive truncated functional, not the moments of a probability measure on
the sphere. Positivity is certified by exact finite matrix identities.

Scaling this single functional to the explicit minimizing radius separates
the regularized polynomial from every sum of squares. An independent degree
argument shows that a quartic SOS representation can use only quadratic
summands. Thus the conclusion concerns ordinary real polynomial sums of
squares, without an artificial restriction in the definition.

The theorem allows any fixed positive strengths for the negative isotropic
quadratic and for the cubic. It supplies an exact attained minimum and a
strict quantitative gap at every positive parameter. The gap can approach
zero as regularization grows; persistence means that it never vanishes at a
finite positive parameter.

This is a negative answer to the stationary case with non-PSD Hessian raised
in Cartis–Zhu, Remark 2.3. It does not conflict with sufficient conditions
requiring a nonzero gradient or positive definite Hessian. The Choi–Lam
quartic and the antecedent cubic normal form are credited in
[Sources.md](Sources.md). The package claims the explicit example and its
proved consequences, without asserting priority for the underlying forms
or a smallest dimension.
