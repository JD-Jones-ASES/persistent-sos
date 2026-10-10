# Verification contract

The complete formal package contains **35 compared contracts** and **272
supporting declarations** in the transitive-axiom inventory. The independent
Challenge imports only Mathlib; deliberate statement holes occur there alone.
The Solution and implementation contain no proof holes or added axioms.

The [exact-commit workflow](https://github.com/JD-Jones-ASES/persistent-sos/actions/workflows/verify.yml)
records each candidate SHA and both Linux job outcomes. The annotated tag
`verified/2026-10-10-unique-minimizer` is created only after both jobs pass; its annotation
records the exact source revision and successful run URL. Match the selected
revision to that evidence. A verification tag does not imply submission.

The principal contract uses the literal 25-term polynomial in
ordinary real multivariate polynomials. It includes the global sphere bound,
attained global minimum, unrestricted polynomial SOS exclusion, strict
quantitative SOS separation, and the stationary negative-definite Hessian and complete minimizer locus.
Every positive real regularization parameter is covered. The explicit
companion cubic $`\widehat C=(1000C+tQ)/1001`$ has a unique sphere maximizer,
and its regularized quartic has a unique global minimizer with a
positive-definite Hessian there. The Hessian contract computes the actual
second polynomial partial derivatives and proves ordinary `Matrix.PosDef`.
Its stationary origin retains the Hessian $`-aI`$.

## Exact witness

[The rational certificate](certificates/sphere-moments.json) contains 450 free
moments with denominator $`10^9`$. Its SHA-256 is
`2417f05c4651a380467d1c6ca7d10efcf7119790d5d3c86af939e35a5843779b`.

The full degree-two monomial matrix has 120 rows. Reduction by the sphere
relation removes one forced null direction, leaving eight positive-definite
blocks of dimensions $`27,11,11,11,11,16,16,16`$. Both exact Python checkers
verify all 120 sphere localizer identities and all 14,400 entries of the
full-matrix congruence. They agree on the exact cubic value
$`500753357629/500000000000`$.

Lean checks the actual full matrix directly: its character-zero block has
28 rows, 27 strictly positive Schur pivots and one exact zero terminal block.
The remaining blocks have 11 or 16 rows and strictly positive pivots. There
are 119 positive pivots in total. Every within-block and cross-block identity
is checked on the same exponent-indexed moment function. A generic polynomial
expansion proves positivity on **every** quadratic square. Positivity and
$`L((Q-1)^2)=0`$ additionally prove $`L((Q-1)h)=0`$ for every quadratic $`h`$.
No probability-measure assumption or floating-point tolerance is used.

The same functional has $`L(tQ)=L(t)=423308963/1000000000`$ and
$`L(\widehat C)=143132860603/143000000000`$. The companion moment contract
supplies both original and modified cubic values for one common normalized
positive functional. Its separation is exactly
$`132860603/143000000000`$. No moment or PSD certificate data changed.

The primary checker uses monomial tuples and fraction-free elimination;
the independent checker uses exponent vectors and rational Schur complements.
Controls reject altered normalization, nonpositive matrices, inconsistent
sphere relations, altered objectives, and unsupported separation bounds.
Run both ordinarily and with `python3 -O`. The generator authenticates the
certificate hash and compares every generated Lean file without modifying it.
A separate Lean negative-control script compiles an unchanged block, then
requires rejection of an altered moment entry and a negative terminal pivot
at the arithmetic proof steps; process or import failures do not count.

`scripts/check_unique_minimizer.py` independently specifies all 25 modified
coefficients and verifies all 196 Hessian entries by exact rational symbolic
differentiation. It checks the radial identities and rejects changed
curvature, a nonzero mixed Hessian entry and an altered first moment.
It runs both ordinarily and under Python optimization. These checks support
the evidence; the explicit companion theorem is proved separately in Lean.

## Pinned environment and final gate

- Lean: `leanprover/lean4:v4.35.0-rc3`.
- Mathlib: `a98628e16c11f5167f16124105ddce53efa9bfe5`.
- All transitive dependencies: committed `lake-manifest.json`.
- Permitted axioms: `propext`, `Classical.choice`, `Quot.sound`.

The final verification gate builds all project modules, audits the selected
and supporting declarations, compares the Mathlib-only Challenge against the
Solution, and replays the proof closure through Lean, NanoDa and con-ron.
A separate fresh Linux runner builds the same exact commit. Source and
certificate checks run on both relevant verification paths.

The source contract follows PalomarPolicy
`96b034cc31a72a63d4f4041911dce337a85c9a04`; the kernel procedure follows
PalomarSubmission `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44`, checked on
2026-10-10. Repository verification is separate from public release,
submission, registry acceptance, priority and human review.

## Compared declarations

| Contract | Content |
|---|---|
| `radius_eq_norm` | The radius is the ordinary Euclidean norm. |
| `cubic_abs_le` | Global sharp homogeneous cubic bound. |
| `unit_sphere_attainment` | An explicit point attains sphere value one. |
| `cubic_unit_maximizers_coordinates` | Complete sphere maximizer classification. |
| `objective_all_minimizers` | Complete quartic minimizer locus for all positive parameters. |
| `persistent_failure` | Actual attained global minimum and unrestricted SOS exclusion. |
| `minimum_shift_nonnegative` | Ordinary polynomial minimum shift is nonnegative everywhere. |
| `quantitative_sos_gap` | Every SOS lower bound obeys the explicit separation bound. |
| `sphere_moment_gap` | A positive truncated polynomial functional with all sphere localizers and strict cubic value. |
| `stationary_origin` | Every first polynomial partial derivative vanishes at zero. |
| `hessian_origin` | Every second partial derivative equals the corresponding entry of $`-aI`$. |
| `unique_cubic_abs_le` | Sharp global bound for the companion cubic. |
| `unique_cubic_unit_maximizer` | Its unit-sphere maximum occurs only at the first coordinate unit vector. |
| `unique_objective_minimizer` | Complete unique global minimizer statement for all positive parameters. |
| `unique_persistent_failure` | Actual unique global minimum, positive-definite Hessian, and ordinary SOS exclusion. |
| `unique_minimum_shift_nonnegative` | The companion polynomial's exact minimum shift is nonnegative everywhere. |
| `unique_quantitative_sos_gap` | Exact rational separation for every companion SOS lower bound. |
| `unique_sphere_moment_gap` | One normalized positive functional certifies both cubics and all sphere localizers. |
| `unique_stationary_origin` | Every first polynomial partial derivative still vanishes at zero. |
| `unique_hessian_origin` | The companion Hessian at zero remains $`-aI`$. |
| `unique_hessian_minimizer` | All entries of the actual Hessian equal the explicit diagonal formula. |
| `unique_hessian_posDef` | Ordinary matrix positive definiteness at the unique minimizer. |

Thirteen definition contracts fix the literal cubics, Euclidean norm polynomial,
ordinary SOS predicate, objective polynomial, evaluation, minimizing radius,
minimum and rational separations. The quantitative bounds are valid even for
arbitrary real cubic strength; the strict failure and full minimizer statements
assume positive cubic strength.

## Local verification

The complete package builds all 32 Lean source modules. The exact certificate replay,
independent replay and generator comparison pass ordinarily and under Python
optimization. Both Lean rejection controls pass. Independent agents checked
the written proof, all monomial values and matrix identities, ordinary SOS
semantics, parameter quantifiers, complete minimizer locus, and literal
Challenge/Solution definitions and statements. The current official metadata
and provenance validator passes.

These checks are distinct from the exact-commit Linux gate. The workflow runs
a complete build and axiom audits, the reproducible rational checks and Lean
negative controls, sandboxed Comparator and Lean/NanoDa/con-ron replay. A
separate fresh runner builds every project module at the same revision.

Coefficient-neighborhood robustness and large-parameter asymptotics in
[Applications.md](Applications.md) remain written supplements. All minimizer
geometry is included in the formal contract, together with the explicit
unique nondegenerate minimizer theorem. The continuous selection family,
general selection principle and the further deductions in
[RadialConsequences.md](RadialConsequences.md) remain written supplements.
No optimal SOS value, minimal-dimension theorem, higher-order hierarchy
result, submission, registration or human specialist review is implied.
