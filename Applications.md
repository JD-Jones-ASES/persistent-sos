# Consequences of the explicit gap

## Fixed data at every parameter

The theorem permits any fixed $`a,b\gt 0`$ in

```math
P_{\sigma,a,b}=\frac\sigma4\|z\|^4-\frac a2\|z\|^2-bC(z).
```

Its stationary Hessian is always $`-aI_{14}`$ and its cubic is always $`-bC`$.
The strict gap holds for every $`\sigma\gt 0`$. Thus scaling either fixed
component cannot remove the obstruction by sufficiently large Euclidean
quartic regularization.

In the third-order model notation of Cartis–Zhu, take $`g=0`$,
$`H=-aI_{14}`$ and the symmetric cubic tensor with diagonal evaluation
$`T[z,z,z]=-6bC(z)`$. This fits exactly the stationary non-PSD-Hessian
case in Remark 2.3. The positive-definite-Hessian and nonzero-gradient
sufficient conditions have different hypotheses.

## Geometry of the minimizers

There is an isolated axis minimizer and a sphere of additional minimizers.
The full unit-sphere maximizing set of $`C`$ is

```math
\{(1,0,0)\}\ \cup\
\{(-1/2,0,y):\|y\|^2=3/4\}.
```

Indeed, equality in the sharp sphere-bound proof forces $`YX^2=0`$,
because $`259/100\lt 3\sqrt3/2`$. If $`Y=0`$, then
$`C=(3t-t^3)/2`$ with $`-1\le t\le1`$; equality at one forces $`t=1`$.
If $`X=0`$, then $`C=4t^3-3t`$ and

```math
1-C=(1-t)(2t+1)^2.
```

Equality therefore requires $`t=1`$ or $`t=-1/2`$. The stated points
attain equality directly. The strictly positive factor in the radial
factorization forces every global minimizer to have radius $`r`$.
Consequently the full minimizing set is the displayed set multiplied by $`r`$.

## An open family of cubic obstructions — written supplement

The failure survives small perturbations of every cubic coefficient.
Write $`E(z)=\sum_{|\alpha|=3}e_\alpha z^\alpha`$ and
$`\varepsilon=\sum_\alpha|e_\alpha|`$. If

```math
\varepsilon<\frac\delta2
=\frac{753357629}{1000000000000},
```

then $`D=C+E`$ also supplies persistent failure with every fixed negative
isotropic Hessian.

Here is a direct proof, with no numerical continuity argument. On the unit
sphere each monomial has absolute value at most one, so
$`D\le B:=1+\varepsilon`$. The exact moment functional also satisfies
$`|L(z_i z_j z_k)|\le1`$. To see this, positivity and $`L(Q)=1`$ give
$`0\le L(z_i^2)\le1`$; positivity and $`L(Q^2)=1`$ give
$`0\le L(z_j^2z_k^2)\le1`$. Cauchy–Schwarz for the positive semidefinite
moment form, applied to $`z_i`$ and $`z_jz_k`$, proves the assertion, including
repeated indices. Hence $`|L(E)|\le\varepsilon`$, and

```math
L(D)-B\ge\delta-2\varepsilon>0.
```

For fixed $`a\gt 0`$ and every $`\sigma\gt 0`$, define

```math
r_B=\frac{3B+\sqrt{9B^2+4a\sigma}}{2\sigma},
\qquad \ell_B=-\frac{Br_B^3+ar_B^2}{4}.
```

The same radial argument gives
$`\sigma Q^2/4-aQ/2-D\ge\ell_B`$ everywhere. The scaled moment
functional evaluates this nonnegative shift to at most
$`-(\delta-2\varepsilon)r_B^3\lt 0`$, so it is not SOS. Coercivity ensures
an attained actual minimum $`m\ge\ell_B`$; shifting by $`m`$ only decreases
the separating functional, and that shift is also not SOS.

This establishes an open neighborhood in the space of cubic coefficients.
It is stronger than testing a finite set of perturbed examples. The original
sparse cubic remains the formal package's literal principal example.

## Large-parameter size of the separation — written supplement

For fixed $`a,b\gt 0`$, the explicit radius satisfies
$`r\sim\sqrt{a/\sigma}`$. Therefore the certified gap has asymptotics

```math
b\delta r^3\sim b\delta a^{3/2}\sigma^{-3/2},
\qquad
\mu\sim-\frac{a^2}{4\sigma}.
```

Persistence does not assert a uniform positive absolute or relative gap.
These expressions describe the certified lower bound on the SOS gap, not
an exact formula for the optimal SOS value.
