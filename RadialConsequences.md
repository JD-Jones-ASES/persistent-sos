# Further radial consequences — written supplement

These deductions use the exact moment witness already proved in the repository.
They are written mathematical supplements, not additional Lean comparison
claims. In particular, the principal Lean persistent-failure theorem retains
its hypothesis $`a\gt 0`$; the flat-Hessian and positive-Hessian cases below are
proved here in prose.

Let $`D`$ be either the original cubic $`C`$ or the unique-maximizer variant
$`\widehat C=(1000C+tQ)/1001`$. Both satisfy
$`|D(z)|\le\|z\|^3`$ and $`D(e_0)=1`$, where
$`e_0=(1,0,\ldots,0)`$. The fixed functional $`L`$ is nonnegative on squares
of quadratic polynomials, and

```math
L(1)=L(Q)=L(Q^2)=1,\qquad L(D)=\kappa>1.
```

The two exact constants are

```math
\kappa_C=1+\frac{753357629}{500000000000},\qquad
\kappa_{\widehat C}=1+\frac{930024221}{1001000000000}.
```

For every $`s\ge0`$, the scaled functional $`L_s(p)=L(p(sz))`$ remains
nonnegative on quadratic squares. An ordinary polynomial SOS of degree at
most four has only quadratic-or-lower summands, by the degree bridge in
[Proof.md](Proof.md). Thus $`L_s`$ is nonnegative on every quartic SOS.

## 1. Best bound from common scaling of this witness

Fix $`\sigma,b\gt 0`$ and $`a\ge0`$, and write

```math
P_D=\frac\sigma4Q^2-\frac a2Q-bD,\qquad
f_c(s)=\frac\sigma4s^4-cs^3-\frac a2s^2.
```

The true minimum is $`\mu=f_b(r)`$, where

```math
r=\frac{3b+\sqrt{9b^2+4a\sigma}}{2\sigma},\qquad
\mu=-\frac{br^3+ar^2}{4}.
```

Indeed, $`P_D(z)\ge f_b(\|z\|)`$, with equality on the positive
$`e_0`$ axis. The radial factorization in [Proof.md](Proof.md) remains valid
for $`a=0`$: its bracket is strictly positive because $`b,r\gt 0`$.

If $`P_D-\gamma`$ is SOS, applying $`L_s`$ for every $`s\ge0`$ gives
$`\gamma\le f_{b\kappa}(s)`$. Consequently

```math
\gamma\le U_\kappa:=-\frac{b\kappa R^3+aR^2}{4},\qquad
R=\frac{3b\kappa+\sqrt{9b^2\kappa^2+4a\sigma}}{2\sigma}.
```

To verify minimization without an optimizer, use
$`\sigma R^2=3b\kappa R+a`$ to obtain

```math
f_{b\kappa}(s)-U_\kappa
=\frac{(s-R)^2}{4}
 \left(\sigma s^2+(2\sigma R-4b\kappa)s+b\kappa R+a\right).
```

The bracket is positive for $`s\ge0`$: $`\sigma R\ge3b\kappa`$ and
$`b\kappa R+a\gt 0`$. Hence $`R`$ is the unique minimizing radius. Since
$`\kappa\gt 1`$ implies $`R\gt r`$, this strictly improves evaluation at the
true radius:

```math
U_\kappa<f_{b\kappa}(r)
=\mu-b(\kappa-1)r^3<\mu.
```

This is the optimal bound obtained by common coordinate scaling of this
fixed witness. It does **not** identify the optimal SOS lower bound among
all possible separating functionals.

## 2. Flat Hessian: a scale-independent relative separation

Set $`a=0`$. The gradient and Hessian at the origin both vanish, yet for
every $`\sigma,b\gt 0`$ the exact minimum is

```math
r=\frac{3b}{\sigma},\qquad
\mu=-\frac{27b^4}{4\sigma^3}.
```

Section 1 gives $`R=\kappa r`$ and

```math
\gamma\le\kappa^4\mu<\mu
\quad\text{whenever }P_D-\gamma\text{ is SOS}.
```

Thus the actual minimum shift is nonnegative and non-SOS for every
regularization parameter. Every SOS lower bound has relative separation

```math
\frac{\mu-\gamma}{|\mu|}\ge\kappa^4-1>0.
```

For the original witness this constant is approximately $`0.00604050`$.
It describes a certified lower bound on the relative SOS gap, not its
exact value. The absolute certified separation still tends to zero as
$`\sigma\to\infty`$, at rate $`\sigma^{-3}`$.

## 3. A finite failure band with positive definite Hessian

Fix $`h,b\gt 0`$ and consider

```math
P_D^+=\frac\sigma4Q^2+\frac h2Q-bD.
```

Its Hessian at the stationary origin is $`hI_{14}`$. With
$`s=\|z\|`$, the sphere bound and completion of the square give

```math
P_D^+(z)\ge s^2\left(\frac\sigma4s^2-bs+\frac h2\right)
=s^2\left[\frac\sigma4\left(s-\frac{2b}{\sigma}\right)^2
 +\frac h2-\frac{b^2}{\sigma}\right].
```

Therefore the exact minimum is zero whenever $`\sigma\ge2b^2/h`$,
attained at the origin. If $`\sigma\gt 2b^2/h`$, the bracket is positive,
so the origin is the unique global minimizer.

Nevertheless, take $`s_0=2b\kappa/\sigma\gt 0`$. The same exact moment
witness evaluates this polynomial to

```math
L_{s_0}(P_D^+)
=s_0^2\left(\frac h2-\frac{b^2\kappa^2}{\sigma}\right)<0
\quad\text{if }\sigma<\frac{2b^2\kappa^2}{h}.
```

Hence throughout the explicit band

```math
\boxed{\frac{2b^2}{h}\le\sigma<\frac{2b^2\kappa^2}{h}},
```

$`P_D^+`$ is globally nonnegative, has actual minimum zero, and is not
SOS. On the strict interior of this band the minimizer is uniquely the
origin, with positive-definite Hessian $`hI_{14}`$.

At the lower endpoint, the positive axis point
$`(2b/\sigma)e_0`$ is an additional minimizer. At and beyond the upper
endpoint, this particular argument no longer proves a gap; it does not
certify SOS exactness there. The band is finite for fixed $`h,b`$, so it
does not conflict with the eventual SOS exactness for positive-definite
$`H`$ in Cartis–Zhu, Remark 2.3 and §2.3.1; see
[Sources.md](Sources.md).
