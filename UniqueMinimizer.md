# Persistent failure with a unique nondegenerate global minimizer

The explicit theorem below extends the cubic and moment functional of
[Proof.md](Proof.md). Its literal polynomial, unique minimum, moment gap
and positive-definite Hessian are included in the Lean contract. The final
two sections, covering a continuous parameter family and a general selection
principle, are written supplements. No new numerical moment search or
additional positivity certificate is required.

## Statement

Retain the coordinates
$`z=(t,x_1,x_2,x_3,x_4,y_1,\ldots,y_9)\in\mathbb R^{14}`$, the squared
Euclidean norm $`Q=t^2+X^2+Y^2`$, and the quadratic map $`q`$ of
[Proof.md](Proof.md). Define a second fixed rational cubic by

```math
\widehat C(z)=\frac{1000C(z)+tQ(z)}{1001}
 =t^3-\frac{2999}{1001}tY^2
   +\frac{1501}{1001}tX^2
   +\frac{2590}{1001}\,y\cdot q(x).
```

This changes coefficients of the original cubic without adding any
monomials: $`\widehat C`$ still has 25 nonzero monomials. Its maximum on
the unit sphere is one, attained **only** at $`e_0=(1,0,\ldots,0)`$.

For every $`\sigma,a,b\gt 0`$, put

```math
\widehat P_{\sigma,a,b}(z)
 =\frac\sigma4Q(z)^2-\frac a2Q(z)-b\widehat C(z),
\qquad
r=\frac{3b+\sqrt{9b^2+4a\sigma}}{2\sigma},
\qquad
\mu=-\frac{br^3+ar^2}{4}.
```

**Theorem.** The unique global minimizer of
$`\widehat P_{\sigma,a,b}`$ is $`re_0`$, and its minimum is $`\mu`$.
The Hessian at this minimizer is positive definite. Nevertheless, every
ordinary polynomial SOS lower bound satisfies

```math
\widehat P_{\sigma,a,b}-\gamma\ \text{SOS}
\quad\Longrightarrow\quad
\gamma\le\mu-b\widehat\delta r^3<\mu,
\qquad
\widehat\delta
 =\frac{930024221}{1001000000000}
 =\frac{132860603}{143000000000}>0.
```

In particular, the exact minimum shift is nonnegative and is not SOS.
The gradient at the origin is zero and the Hessian there remains
$`-aI_{14}`$. Both the quadratic and cubic data can be fixed independently
of $`\sigma`$.

Thus persistent failure also occurs with a unique global minimizer having
strictly positive quadratic curvature in every direction.

## Unique sphere maximizer

On $`Q=1`$, the original sphere bound and $`t\le1`$ give

```math
\widehat C(z)=\frac{1000C(z)+t}{1001}\le1.
```

If equality holds, then

```math
1000\bigl(1-C(z)\bigr)+(1-t)=0.
```

Both summands are nonnegative, so $`t=1`$. The sphere equation then forces
all other coordinates to vanish. Conversely, $`\widehat C(e_0)=1`$.
Oddness also gives $`|\widehat C|\le1`$ on the unit sphere.

By homogeneity, if $`s=\|z\|`$, then

```math
\widehat C(z)\le s^3.
```

For $`s\gt 0`$, equality holds precisely when $`z=se_0`$. At $`s=0`$ the
vector is zero. Equivalently, the deficit has the useful decomposition

```math
s^3-\widehat C(z)
 =\frac{1000\bigl(s^3-C(z)\bigr)+s^2(s-t)}{1001},
```

whose two terms are nonnegative. For a nonzero vector, vanishing of the
second term forces $`t=s`$, which again forces every other coordinate to
vanish.

## Exact minimum and uniqueness

The radial envelope is unchanged:

```math
\widehat P_{\sigma,a,b}(z)
 \ge f(s):=\frac\sigma4s^4-bs^3-\frac a2s^2.
```

The radius $`r\gt 0`$ satisfies $`\sigma r^2=3br+a`$, and the exact
factorization from [Proof.md](Proof.md) gives

```math
f(s)-\mu
 =\frac{(s-r)^2}{4}
  \left(\sigma s^2+(2\sigma r-4b)s+br+a\right).
```

The factor in parentheses is strictly positive for every $`s\ge0`$.
Therefore $`f(s)=\mu`$ if and only if $`s=r`$. Moreover,

```math
\widehat P_{\sigma,a,b}(z)-\mu
 =f(s)-\mu+b\bigl(s^3-\widehat C(z)\bigr).
```

Equality holds if and only if $`s=r`$ and
$`\widehat C(z)=s^3`$. The preceding equality classification gives
$`z=re_0`$, which attains the displayed minimum directly.

## The same rational moment certificate separates the new cubic

Let $`L`$ be the exact degree-four moment functional established in
[Proof.md](Proof.md). Besides

```math
L(1)=L(Q)=L(Q^2)=1,
\qquad L(C)=1+\delta,
\qquad \delta=\frac{753357629}{500000000000},
```

the [same certificate](certificates/sphere-moments.json) specifies

```math
L(t)=\frac{423308963}{1000000000}.
```

The certified sphere localizer identity, applied to the degree-one
polynomial $`t`$, gives $`L((Q-1)t)=0`$. Hence $`L(tQ)=L(t)`$, and

```math
\begin{aligned}
L(\widehat C)-1
 &=\frac{1000\delta+L(t)-1}{1001}\\
 &=\frac{930024221}{1001000000000}
 =\widehat\delta>0.
\end{aligned}
```

This uses the existing exponent-indexed functional and its existing
positive semidefinite moment matrix. The rational certificate is unchanged.

Define $`L_r(p)=L(p(rz))`$. Positivity on quadratic squares is preserved
under this common scaling. By the ordinary SOS degree bridge from
[Proof.md](Proof.md), every summand in any SOS representation of a quartic
has degree at most two. Consequently an SOS shift must satisfy

```math
\begin{aligned}
0&\le L_r(\widehat P_{\sigma,a,b}-\gamma)\\
 &=\frac\sigma4r^4-\frac a2r^2
   -b(1+\widehat\delta)r^3-\gamma\\
 &=\mu-b\widehat\delta r^3-\gamma.
\end{aligned}
```

This proves the stated quantitative gap. At $`\gamma=\mu`$ the
functional is strictly negative, proving that the nonnegative minimum
shift is not SOS.

## Positive-definite Hessian at the unique minimizer

At $`re_0`$, all mixed second partial derivatives of
$`\widehat C`$ vanish. Its diagonal second derivatives, grouped into the
$`t`$, four $`x`$, and nine $`y`$ coordinates, are

```math
\nabla^2\widehat C(re_0)
 =\mathrm{diag}\!\left(
  6r,\ \frac{3002r}{1001}I_4,
  -\frac{5998r}{1001}I_9\right).
```

The interaction term $`y\cdot q(x)`$ contributes no second derivatives
at this point because $`x=y=0`$. Also,

```math
\nabla^2\left(\frac\sigma4Q^2-\frac a2Q\right)(re_0)
 =\mathrm{diag}\left(3\sigma r^2-a,
                          (\sigma r^2-a)I_{13}\right).
```

Using $`\sigma r^2=3br+a`$ therefore gives

```math
\nabla^2\widehat P_{\sigma,a,b}(re_0)
 =\mathrm{diag}\!\left(
   2a+3br,\ \frac{br}{1001}I_4,
   \frac{9001br}{1001}I_9\right).
```

All fourteen eigenvalues are strictly positive. The smallest eigenvalue
is exactly $`br/1001`$, with multiplicity four. The minimum is therefore
nondegenerate for every positive choice of the three parameters. This
positive curvature is asserted at the global minimizer; the stationary
origin still has the prescribed negative-definite Hessian $`-aI_{14}`$.
For fixed $`a,b\gt 0`$, the smallest eigenvalue tends to zero as
$`\sigma\to\infty`$. The assertion is nondegeneracy at each finite
positive parameter, without a uniform positive curvature bound.

## A continuous family of such examples

The rational choice above is one member of a simple family. For
$`\tau\gt 0`$, define

```math
C_\tau=\frac{C+\tau tQ}{1+\tau}.
```

Every such cubic has sphere maximum one uniquely at $`e_0`$. The same
moment functional gives the exact separation

```math
L(C_\tau)-1
 =\frac{\delta-\tau\bigl(1-L(t)\bigr)}{1+\tau}.
```

It is positive throughout the explicit interval

```math
0<\tau<\frac{\delta}{1-L(t)}
 =\frac{753357629}{288345518500}.
```

For every $`\tau`$ in this interval, replacing $`C`$ by $`C_\tau`$
retains the same formulas for $`r`$ and $`\mu`$, gives a unique global
minimizer, and yields Hessian eigenvalues

```math
2a+3br\quad(1\text{ time}),\qquad
\frac{b\tau r}{1+\tau}\quad(4\text{ times}),\qquad
\frac{b(9+\tau)r}{1+\tau}\quad(9\text{ times}).
```

The displayed 25-term rational example is $`\tau=1/1000`$. These
formulas describe an explicit family with a certified SOS gap; they do
not identify the optimal SOS value or a smallest possible dimension.

## A general principle for selecting a unique maximizer

The same construction applies beyond this particular certificate. Let
$`C`$ be any real homogeneous cubic on $`\mathbb R^n`$ with maximum one
on the unit sphere, attained at a unit vector $`v`$. Write
$`Q(z)=\|z\|^2`$ and $`\ell(z)=v\cdot z`$. Suppose a real linear
functional through degree four satisfies

```math
L(1)=L(Q)=L(Q^2)=1,\qquad
L(h^2)\ge0\quad(\deg h\le2),\qquad
L(C)=1+\delta>1.
```

Then every $`0\lt \tau\lt \delta/2`$ produces a cubic

```math
C_\tau=\frac{C+\tau\ell Q}{1+\tau}
```

with sphere maximum one uniquely at $`v`$ and a strict moment gap.
For every $`\sigma,a,b\gt 0`$, the corresponding quartic has unique
global minimizer $`rv`$, the same radial minimum formula as above, a
positive-definite Hessian there, and a non-SOS exact minimum shift.

To prove the moment assertion, positivity and the radial moments give
$`L((Q-1)^2)=0`$. Null-square orthogonality, applied to the positive
form $`(p,q)\mapsto L(pq)`$ on degree-two polynomials, implies
$`L((Q-1)\ell)=0`$. Also,

```math
Q-\ell^2=\sum_{i=1}^n(z_i-v_i\ell)^2.
```

It follows that $`0\le L(\ell^2)\le1`$. Cauchy-Schwarz applied to
$`1`$ and $`\ell`$ gives $`|L(\ell)|\le1`$. Therefore

```math
L(C_\tau)-1
=\frac{\delta-\tau(1-L(\ell))}{1+\tau}
\ge\frac{\delta-2\tau}{1+\tau}>0.
```

On the unit sphere, $`C\le1`$ and $`\ell\le1`$; equality in the
convex combination requires $`\ell=1`$, hence $`z=v`$. The radial
argument proves uniqueness of $`rv`$ and transfers the moment gap.

For the Hessian, let $`H_S(C,v)`$ denote the Hessian of the restriction
of $`C`$ to the unit sphere at $`v`$, acting on $`v^\perp`$. Since
$`v`$ is a maximum, $`H_S(C,v)\preceq0`$. At $`v`$, the sphere
Hessian of $`\ell Q`$ equals $`-I_{v^\perp}`$, so

```math
H_S(C_\tau,v)
=\frac{H_S(C,v)-\tau I_{v^\perp}}{1+\tau}
\preceq-\frac{\tau}{1+\tau}I_{v^\perp}.
```

Homogeneity and constrained stationarity give
$`\nabla C_\tau(v)=3v`$ and
$`\nabla^2C_\tau(v)v=6v`$. Consequently the radial and tangential
blocks of the quartic Hessian at $`rv`$ have zero cross terms. Its
radial eigenvalue is $`2a+3br`$, and its tangential block is

```math
-br\,H_S(C_\tau,v)
\succeq\frac{br\tau}{1+\tau}I_{v^\perp}\succ0.
```

Thus any such cubic sphere gap admits a perturbation selecting a unique
nondegenerate global minimum while retaining persistent SOS failure.
The resulting coefficients are rational when $`C`$, $`v`$ and
$`\tau`$ are rational. Using the actual value of $`L(\ell)`$ gives
the larger allowable interval in the explicit fourteen-variable example;
$`\delta/2`$ is only a general sufficient bound.
