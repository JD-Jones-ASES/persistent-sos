# Explicit persistent failure of Euclidean quartic SOS exactness

## Statement

Use coordinates $`z=(t,x_1,x_2,x_3,x_4,y_1,\ldots,y_9)\in\mathbb R^{14}`$.
Write $`X=\|x\|`$, $`Y=\|y\|`$, and $`Q=t^2+X^2+Y^2=\|z\|^2`$. Define

```math
q(x)=\left(x_1^2,x_2^2,x_3^2,
 x_1x_2+x_3x_4,x_1x_3+x_2x_4,x_2x_3,
 \frac75x_1x_4,x_2x_4,x_3x_4\right)
```

and the rational homogeneous cubic

```math
C(z)=t^3-3tY^2+\frac32tX^2+\frac{259}{100}\,y\cdot q(x).
```

It has 25 monomials. For every $`\sigma,a,b>0`$, put

```math
P_{\sigma,a,b}(z)=\frac\sigma4Q(z)^2-\frac a2Q(z)-bC(z),
\qquad r=\frac{3b+\sqrt{9b^2+4a\sigma}}{2\sigma},
\qquad \mu=-\frac{br^3+ar^2}{4}.
```

**Theorem.** The global minimum of $`P_{\sigma,a,b}`$ is $`\mu`$, attained at
$`(r,0,\ldots,0)`$. Its minimum shift is nonnegative but is not a sum of
squares of real polynomials. More quantitatively, if $`P_{\sigma,a,b}-\gamma`$
is SOS, then

```math
\gamma\le\mu-b\delta r^3<\mu,
\qquad \delta=\frac{753357629}{500000000000}>0.
```

At the origin the gradient vanishes and the Hessian is $`-aI_{14}`$.
The parameters $`a,b`$ may be fixed independently of $`\sigma`$.

## Quadratic-map contraction

The classical Choi–Lam quartic is

```math
F(x)=x_1^2x_2^2+x_1^2x_3^2+x_2^2x_3^2+x_4^4-4x_1x_2x_3x_4.
```

The arithmetic-geometric mean inequality applied to its first four terms
shows $`F(x)\ge0`$: their product is $`(x_1x_2x_3x_4)^4`$.
Direct expansion gives

```math
X^4-\|q(x)\|^2=F(x)+\frac1{25}x_1^2x_4^2\ge0.
```

Consequently $`\|q(x)\|\le X^2`$. The known non-SOS property of $`F`$ is
not needed in this argument or in the certificate below.

## Sharp sphere bound

Suppose $`Q(z)=1`$. Cauchy–Schwarz and the contraction bound give

```math
C(z)\le t^3-3tY^2+\frac32tX^2+\frac{259}{100}YX^2
\le t^3-3tY^2+\frac32(t+\sqrt3Y)(1-t^2-Y^2).
```

The second inequality uses
$`(259/100)^2=67081/10000<27/4`$. Set $`v=(t+\sqrt3Y)/2`$.
Cauchy–Schwarz implies $`|v|\le1`$, and expansion identifies the final
expression with $`3v-4v^3`$. Hence

```math
1-(3v-4v^3)=(v+1)(2v-1)^2\ge0.
```

Thus $`C\le1`$ on the sphere. Oddness gives $`C\ge-1`$ there, and
$`C(1,0,\ldots,0)=1`$ proves attainment. Homogeneity now gives

```math
|C(z)|\le\|z\|^3\qquad(z\in\mathbb R^{14}).
```

This proof allows any quadratic map with $`\|q(x)\|\le\|x\|^2`$ and
any cross coefficient in $`[0,3\sqrt3/2]`$. The strict moment gap below is
specific to the displayed rational cubic and rational witness.

## Exact rational moment witness

The [certificate](certificates/sphere-moments.json) specifies 450 free
moments with denominator $`10^9`$. It defines a real linear functional $`L`$
on polynomials through degree four. Moments of a monomial are assigned
once, so equal products have equal values. The coordinate sign characters
are

```math
(0,1,2,4,7,0,0,0,3,5,6,6,5,3).
```

The character of a monomial is the bitwise exclusive-or of its factor
characters; nonzero-character moments vanish. The sphere relation

```math
t^2=1-\sum_{i=1}^4x_i^2-\sum_{j=1}^9y_j^2
```

reduces all remaining moments, including products of this relation with
every monomial of degree at most two. These are identities of a truncated
functional; no representing probability measure is asserted.

The complete moment matrix is indexed by the 120 monomials of degree at
most two. Its one forced null direction is $`Q-1`$. On the quotient, the
sign characters split it into eight rational positive-definite blocks with
sizes $`27,11,11,11,11,16,16,16`$. Exact elimination proves positivity.
The full matrix is the congruence lift from that quotient. The verified
finite identities yield

```math
L(1)=L(Q)=L(Q^2)=1,\qquad
L(h^2)\ge0\quad(\deg h\le2),\qquad
L(C)=\frac{500753357629}{500000000000}=1+\delta.
```

[VERIFICATION.md](VERIFICATION.md) describes the kernel certificate, the
two independent exact replays and negative controls. Floating-point
eigenvalues and numerical optimizer status establish none of these claims.

## The exact minimum

For $`s=\|z\|`$, the sphere bound gives

```math
P_{\sigma,a,b}(z)\ge f(s):=\frac\sigma4s^4-bs^3-\frac a2s^2.
```

The displayed radius is positive and satisfies $`\sigma r^2=3br+a`$.
In particular $`f(r)=\mu`$. An exact factorization gives, for every $`s\ge0`$,

```math
f(s)-\mu=\frac{(s-r)^2}{4}
 \left(\sigma s^2+(2\sigma r-4b)s+br+a\right)\ge0.
```

All coefficients inside the parentheses are positive:
$`\sigma r=3b+a/r>3b`$. Equality holds only at $`s=r`$.
The axis point $`(r,0,\ldots,0)`$ has $`C=r^3`$, and therefore attains
$`P=\mu`$. This proves the minimum without an optimization oracle or
parameter sampling.

## Ordinary polynomial SOS exclusion

If a real polynomial of total degree at most four is a finite sum
$`\sum_j h_j^2`$, then every $`h_j`$ has degree at most two. For example,
order monomials by a graded lexicographic order. In each nonzero square,
the leading coefficient is the square of a nonzero real number and is
strictly positive. The largest leading monomial among the squares therefore
cannot cancel in their sum. Its total degree is twice the largest summand
degree. This also handles zero summands.

Define the scaled functional $`L_r(p)=L(p(rz))`$. Scaling preserves the
degree of a quadratic, so $`L_r`$ is nonnegative on every quadratic square.
Using the exact radial moments and the cubic moment,

```math
L_r(P_{\sigma,a,b}-\gamma)
 =\frac\sigma4r^4-\frac a2r^2-b(1+\delta)r^3-\gamma
 =\mu-b\delta r^3-\gamma.
```

If the shifted quartic is SOS, the degree bridge forces this expression
to be nonnegative, proving the quantitative upper bound on $`\gamma`$.
At $`\gamma=\mu`$ it equals $`-b\delta r^3<0`$, a contradiction.
The terms of degree two, three and four also give the asserted first and
second derivatives at the origin directly.

## Scope

The proof supplies a fixed explicit rational example, its exact minimum,
and a strict quantitative SOS gap for all positive real parameters. It
does not determine the optimal SOS lower bound or the smallest dimension
of such an example. [Sources.md](Sources.md) credits the classical inputs
and distinguishes published background from the present deduction.
Formalized statements and written supplements are distinguished in
[VERIFICATION.md](VERIFICATION.md).
