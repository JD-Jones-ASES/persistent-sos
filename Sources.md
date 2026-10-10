# Sources and attribution

Source check: 2026-10-10. This is a bounded primary-source comparison;
worldwide priority and human specialist review are not established.

## The regularization question

Coralia Cartis and Wenqi Zhu, *Sufficiently Regularized Nonnegative Quartic
Polynomials are Sum-of-Squares*, [arXiv:2601.20418v2](https://arxiv.org/abs/2601.20418v2),
revised April 2, 2026. The relevant statement is the third bullet of
[Remark 2.3](https://arxiv.org/html/2601.20418v2#S2.SS3).

That question concerns zero gradient, a Hessian that is not positive
semidefinite, and a general cubic tensor. The regularizer is
$`\sigma\|z\|^4/4`$, and exactness means SOS after subtracting the actual
global minimum. The present example takes the allowed special case
$`H=-aI`$, $`a\gt 0`$, and fixed cubic $`-bC`$, $`b\gt 0`$. It is distinct from separable
quartic regularization. It does not contradict sufficient conditions under
nonzero gradient or positive definite Hessian.

## Classical quartic input

Man-Duen Choi and Tsit-Yuen Lam, *Extremal Positive Semidefinite Forms*,
Mathematische Annalen **231** (1977), 1–18.
[Publisher DOI](https://doi.org/10.1007/BF01360024),
[original journal scan](https://www.digizeitschriften.de/download/pdf/235181684_0231/log8.pdf).

The form
$`x_1^2x_2^2+x_1^2x_3^2+x_2^2x_3^2+x_4^4-4x_1x_2x_3x_4`$
is the classical Choi–Lam quartic. Its nonnegativity is reproved here by
an elementary four-term inequality. Its published non-SOS theorem is not
used to establish the moment certificate or the main theorem.

## Antecedent cubic normal form

Vladimir G. Tkachev, *A generalization of Cartan's theorem on isoparametric
cubics*, Proceedings of the American Mathematical Society **138** (2010),
2889–2895. [Published author copy](https://users.mai.liu.se/vlatk48/papers/eiconal_ams.pdf),
[arXiv:1001.2387v2](https://arxiv.org/abs/1001.2387v2),
[publisher DOI](https://doi.org/10.1090/S0002-9939-10-10385-2).

Section 3, equations (3.1), (3.5) and (3.6), gives the normal form
$`t^3+(3/2)t\|x\|^2-3t\|y\|^2+3\sum_i y_iQ_i(x)`$.
Equations (3.7)–(3.8) impose a quadratic-map identity and additional gradient
identities. Rescaling $`Q_i=(\sqrt3/2)q_i`$ gives the coefficient
$`3\sqrt3/2`$ in the present cubic layout. Here only the weaker contraction
$`\|q(x)\|\le\|x\|^2`$ is needed, and the coefficient is the smaller rational
$`259/100`$. No eiconal identity is claimed for this cubic. The normal form
is established background and is not claimed as new.

## Broader sphere-gap background

Samuel B. Hopkins, Jonathan Shi and David Steurer, *Tensor principal component
analysis via sum-of-square proofs*, COLT 2015, PMLR **40**, 956–1006.
[Publisher entry](https://proceedings.mlr.press/v40/Hopkins15.html),
[published paper](https://proceedings.mlr.press/v40/Hopkins15.pdf).

Appendix B, particularly Theorem 32 and the proof of Theorem 30 in B.2.1,
constructs degree-four sphere pseudodistributions for Gaussian cubic tensors
whose objective exceeds the genuine sphere norm in sufficiently large
dimension. This is probabilistic and asymptotic background. It supplies no
small explicit rational cubic or the finite witness used here, and it is
not a premise of the formal proof.

Jun-Ting Hsieh, Pravesh K. Kothari, Lucas Pesenti and Luca Trevisan,
*New SDP Roundings and Certifiable Approximation for Cubic Optimization*,
SODA 2024. [arXiv:2310.00393](https://arxiv.org/abs/2310.00393),
[publisher DOI](https://epubs.siam.org/doi/10.1137/1.9781611977912.83).
This is related context for cubic sphere relaxations; no result from it is
used in the proof.

## Contribution and limits

The contribution presented here is the explicit 14-variable, 25-monomial
rational cubic, its sharp analytic sphere bound, the exact rational moment
witness, and the resulting all-positive-parameter failure of Euclidean
quartic SOS exactness. The parameter extension, minimizer geometry and
coefficient-neighborhood argument are derived in this repository.

The source check did not identify this precise example. That observation
is not evidence of worldwide priority. Optimal SOS value, smallest possible
dimension and higher-order SOS hierarchy behavior are not determined.
