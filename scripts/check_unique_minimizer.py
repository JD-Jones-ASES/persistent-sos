"""Exact algebraic replay for the unique-minimizer companion and written families.

Run ``python3 scripts/check_unique_minimizer.py`` (also valid under ``-O``).
Only the Python standard library and the repository's exact polynomial/moment
helpers are used. All checks use rational arithmetic and explicit exceptions;
there is no floating-point sampling or optimization-dependent validation.

This authenticates algebraic identities, moments, and symbolic derivatives.
The original verified sphere bound, moment positivity, and SOS degree bridge
are inputs. The explicit rational companion has dedicated UniqueGeometry, UniqueMoments
and UniqueDerivatives Lean modules; their build and exact-revision verification
are separate from this script. UniqueMinimizer.md also supplies
the written general tau-family and selection principle; RadialConsequences.md
supplies the written radial extensions. This script checks exact algebra,
not the analytic or formal verification of those written extensions.
"""

from collections import defaultdict
from fractions import Fraction as F
from hashlib import sha256
import json

from check_certificate import (
    CERTIFICATE,
    DENOMINATOR,
    N,
    VALUE,
    add,
    cubic,
    functional,
    load_certificate,
    multiply,
    require,
    scale,
)


EXPECTED_CERTIFICATE_SHA256 = (
    "2417f05c4651a380467d1c6ca7d10efcf7119790d5d3c86af939e35a5843779b"
)
EXPECTED_FIRST_MOMENT = F(423308963, 1000000000)
EXPECTED_GAP = F(132860603, 143000000000)
EXPECTED_TAU_ENDPOINT = F(753357629, 288345518500)

# Coordinate 0 becomes the formal radius r after restriction to the axis.
# These extra polynomial variables represent parameters, not moment coordinates.
SIGMA, A, B, TAU = 14, 15, 16, 17
S, KAPPA, H = 18, 19, 20


def variable(index):
    return {(index,): F(1)}


def expected_modified_cubic():
    """Literal modified coefficients, independent of the original q-map builder."""
    result = {(0, 0, 0): F(1)}
    result.update({(0, j, j): F(1501, 1001) for j in range(1, 5)})
    result.update({(0, j, j): F(-2999, 1001) for j in range(5, 14)})
    result.update({
        (1, 1, 5): F(2590, 1001),
        (2, 2, 6): F(2590, 1001),
        (3, 3, 7): F(2590, 1001),
        (1, 2, 8): F(2590, 1001),
        (3, 4, 8): F(2590, 1001),
        (1, 3, 9): F(2590, 1001),
        (2, 4, 9): F(2590, 1001),
        (2, 3, 10): F(2590, 1001),
        (1, 4, 11): F(3626, 1001),
        (2, 4, 12): F(2590, 1001),
        (3, 4, 13): F(2590, 1001),
    })
    return result


def derivative(polynomial, index):
    result = defaultdict(F)
    for monomial, coefficient in polynomial.items():
        power = monomial.count(index)
        if power:
            factors = list(monomial)
            factors.remove(index)
            result[tuple(factors)] += coefficient * power
    return {m: c for m, c in result.items() if c}


def on_axis(polynomial):
    """Set coordinates 1,...,13 to zero; keep t=r and parameter variables."""
    return {m: c for m, c in polynomial.items()
            if not any(1 <= index < N for index in m)}


def radius_equation(polynomial):
    """Replace every factor sigma*r^2 by 3*b*r+a, as an exact polynomial rule."""
    result = {}
    pending = dict(polynomial)
    replacement = {(0, B): F(3), (A,): F(1)}
    while pending:
        next_pending = {}
        for monomial, coefficient in pending.items():
            if SIGMA in monomial and monomial.count(0) >= 2:
                factors = list(monomial)
                factors.remove(SIGMA)
                factors.remove(0)
                factors.remove(0)
                expanded = multiply({tuple(factors): coefficient}, replacement)
                next_pending = add(next_pending, expanded)
            else:
                result = add(result, {monomial: coefficient})
        pending = next_pending
    return result


def evaluate_moment(polynomial, moment):
    return sum((coefficient * F(moment(monomial), DENOMINATOR)
                for monomial, coefficient in polynomial.items()), F(0))


def derivative_checks(modified, norm):
    radial = add(
        multiply({(SIGMA,): F(1, 4)}, multiply(norm, norm)),
        multiply({(A,): F(-1, 2)}, norm),
    )
    objective = add(radial, multiply({(B,): F(-1)}, modified))
    cubic_diagonal = (F(6),) + (F(3002, 1001),) * 4 + (F(-5998, 1001),) * 9
    reduced_diagonal = (
        {(A,): F(2), (0, B): F(3)},
        *({(0, B): F(1, 1001)} for _ in range(4)),
        *({(0, B): F(9001, 1001)} for _ in range(9)),
    )
    for i in range(N):
        first = on_axis(derivative(objective, i))
        require(radius_equation(first) == {}, f"axis stationarity at coordinate {i}")
        for j in range(N):
            actual_cubic = on_axis(derivative(derivative(modified, i), j))
            expected_cubic = {(0,): cubic_diagonal[i]} if i == j else {}
            require(actual_cubic == expected_cubic,
                    f"modified cubic axis second partial ({i},{j})")
            actual = on_axis(derivative(derivative(objective, i), j))
            if i == j:
                expected = {
                    (0, 0, SIGMA): F(3 if i == 0 else 1),
                    (A,): F(-1),
                    (0, B): -cubic_diagonal[i],
                }
            else:
                expected = {}
            require(actual == expected, f"raw objective axis second partial ({i},{j})")
            require(radius_equation(actual) == (reduced_diagonal[i] if i == j else {}),
                    f"radius-reduced objective second partial ({i},{j})")

    # The axis value and radial minimum agree modulo the same radius equation.
    minimum = {(0, 0, 0, B): F(-1, 4), (0, 0, A): F(-1, 4)}
    require(radius_equation(add(on_axis(objective), scale(minimum, -1))) == {},
            "attained axis value versus exact minimum")
    require(all(coefficient > 0 for polynomial in reduced_diagonal
                for coefficient in polynomial.values()),
            "positive coefficients of all reduced Hessian eigenvalues")
    return radial


def family_checks(original, norm, radial, first_moment):
    """Clear 1+tau, then verify the whole family symbolically, not by sampling."""
    one_plus_tau = {(): F(1), (TAU,): F(1)}
    family_cubic_numerator = add(original, multiply({(TAU,): F(1)},
                                                 multiply(variable(0), norm)))
    family_objective_numerator = add(
        multiply(one_plus_tau, radial),
        multiply({(B,): F(-1)}, family_cubic_numerator),
    )
    diagonal = (
        multiply(one_plus_tau, {(A,): F(2), (0, B): F(3)}),
        *({(0, B, TAU): F(1)} for _ in range(4)),
        *({(0, B): F(9), (0, B, TAU): F(1)} for _ in range(9)),
    )
    for i in range(N):
        for j in range(N):
            actual = on_axis(derivative(derivative(family_objective_numerator, i), j))
            require(radius_equation(actual) == (diagonal[i] if i == j else {}),
                    f"general tau-family Hessian numerator ({i},{j})")

    delta = VALUE - 1
    slope = 1 - first_moment
    endpoint = delta / slope
    require(delta > 0 and slope > 0, "positive family interval constants")
    require(endpoint == EXPECTED_TAU_ENDPOINT, "general tau-family endpoint")
    require(delta - endpoint * slope == 0, "gap numerator at interval endpoint")
    require(F(0) < F(1, 1000) < endpoint, "rational tilt lies in the open interval")
    require((delta - F(1, 1000) * slope) / (1 + F(1, 1000)) == EXPECTED_GAP,
            "general family specializes to exact modified gap")
    require(delta - 2 * endpoint * slope < 0,
            "strict interval cannot be extended past its stated endpoint")
    return endpoint



def moment_checks(original, modified, tilt, moment):
    """Check exact scalar values separately so altered moment data are rejected."""
    first_moment = evaluate_moment(variable(0), moment)
    tilted_moment = evaluate_moment(tilt, moment)
    require(first_moment == EXPECTED_FIRST_MOMENT, "exact first moment L(t)")
    require(tilted_moment == first_moment, "sphere localizer L(tQ)=L(t)")
    require(evaluate_moment(original, moment) == VALUE, "original cubic moment")
    new_value = evaluate_moment(modified, moment)
    require(new_value == F(143132860603, 143000000000), "modified cubic moment")
    require(new_value - 1 == EXPECTED_GAP > 0, "strict modified moment gap")
    require(EXPECTED_GAP == F(930024221, 1001000000000), "unreduced gap fraction")
    return first_moment, tilted_moment, new_value


def polynomial_power(polynomial, exponent):
    result = {(): F(1)}
    for _ in range(exponent):
        result = multiply(result, polynomial)
    return result


def radial_identity_checks():
    """Check symbolic radial identities, without sampling any parameter values.

    In the first identity B denotes an arbitrary cubic strength, including
    b*kappa for the optimized witness. Denominators in the last two identities
    are cleared symbolically; their sign/uniqueness uses the written hypotheses.
    """
    r, s = variable(0), variable(S)
    sigma, a, b = variable(SIGMA), variable(A), variable(B)
    kappa, h = variable(KAPPA), variable(H)
    f = add(scale(multiply(sigma, polynomial_power(s, 4)), F(1, 4)),
            scale(multiply(b, polynomial_power(s, 3)), -1),
            scale(multiply(a, polynomial_power(s, 2)), F(-1, 2)))
    minimum = scale(add(multiply(b, polynomial_power(r, 3)),
                        multiply(a, polynomial_power(r, 2))), F(-1, 4))
    bracket = add(multiply(sigma, polynomial_power(s, 2)),
                  multiply(add(scale(multiply(sigma, r), 2), scale(b, -4)), s),
                  multiply(b, r), a)
    factorized = scale(multiply(polynomial_power(add(s, scale(r, -1)), 2), bracket), F(1, 4))
    require(radius_equation(add(f, scale(minimum, -1), scale(factorized, -1))) == {},
            "generic radial factorization at stationary positive radius")

    positive_radial = multiply(polynomial_power(s, 2),
        add(scale(multiply(sigma, polynomial_power(s, 2)), F(1, 4)),
            scale(multiply(b, s), -1), scale(h, F(1, 2))))
    cleared_square = multiply(polynomial_power(s, 2),
        add(polynomial_power(add(multiply(sigma, s), scale(b, -2)), 2),
            scale(multiply(h, sigma), 2), scale(polynomial_power(b, 2), -4)))
    require(scale(multiply(sigma, positive_radial), 4) == cleared_square,
            "positive-Hessian radial completion of square")

    # s0=2*b*kappa/sigma: these expressions are sigma^3 times the evaluation.
    numerator = scale(multiply(b, kappa), 2)
    cleared_value = add(scale(polynomial_power(numerator, 4), F(1, 4)),
        scale(multiply(multiply(b, kappa), polynomial_power(numerator, 3)), -1),
        scale(multiply(multiply(h, sigma), polynomial_power(numerator, 2)), F(1, 2)))
    cleared_expected = multiply(polynomial_power(numerator, 2),
        add(scale(multiply(h, sigma), F(1, 2)),
            scale(polynomial_power(multiply(b, kappa), 2), -1)))
    require(cleared_value == cleared_expected,
            "positive-Hessian finite-band functional evaluation")

    relative = VALUE ** 4 - 1
    require(F(604049, 100000000) < relative < F(604051, 100000000),
            "flat-Hessian relative separation decimal enclosure")
    return {"radial_factorization": True, "positive_hessian_square_completion": True,
            "finite_band_scaled_evaluation": True,
            "flat_hessian_relative_separation": str(relative)}


def rejected(callback, label, expected_reason):
    try:
        callback()
    except ValueError as error:
        require(expected_reason in str(error), f"wrong failure for {label}: {error}")
        return {"control": label, "rejected": str(error)}
    raise ValueError("negative control accepted: " + label)


def negative_controls(original, modified, norm, tilt, free):
    changed_curvature = dict(modified)
    changed_curvature[(0, 1, 1)] += F(1, 1001)
    mixed_hessian = add(modified, {(0, 1, 2): F(1, 1001)})
    changed_first_moment = dict(free)
    changed_first_moment[(0,)] += 1
    return [
        rejected(lambda: derivative_checks(changed_curvature, norm),
                 "changed curvature coefficient", "modified cubic axis second partial (1,1)"),
        rejected(lambda: derivative_checks(mixed_hessian, norm),
                 "nonzero mixed Hessian term", "modified cubic axis second partial (1,2)"),
        rejected(lambda: moment_checks(original, modified, tilt, functional(changed_first_moment)),
                 "altered first moment", "exact first moment L(t)"),
    ]

def main():
    require(N == 14 and DENOMINATOR == 1000000000, "original witness dimensions")
    digest = sha256(CERTIFICATE.read_bytes()).hexdigest()
    require(digest == EXPECTED_CERTIFICATE_SHA256, "original certificate SHA256 changed")
    free = load_certificate()
    moment = functional(free)
    norm = {(i, i): F(1) for i in range(N)}
    original = cubic()
    tilt = multiply(variable(0), norm)
    modified = expected_modified_cubic()

    require(modified == scale(add(scale(original, 1000), tilt), F(1, 1001)),
            "independently specified modified coefficients versus normalized tilt")
    require(len(modified) == 25 and set(modified) == set(original),
            "modified cubic has exactly the original 25 monomials")
    require(all(len(m) == 3 and m == tuple(sorted(m)) for m in modified),
            "modified polynomial is a homogeneous cubic")
    require(on_axis(modified) == {(0, 0, 0): F(1)}, "axis cubic normalization")

    first_moment, tilted_moment, new_value = moment_checks(original, modified, tilt, moment)

    radial = derivative_checks(modified, norm)
    endpoint = family_checks(original, norm, radial, first_moment)
    radial_report = radial_identity_checks()
    controls = negative_controls(original, modified, norm, tilt, free)
    report = {
        "status": "EXACT_ALGEBRAIC_CHECKS_PASS",
        "certificate_sha256": digest,
        "cubic_monomials": len(modified),
        "first_moment_L_t": str(first_moment),
        "sphere_localizer_L_tQ": str(tilted_moment),
        "modified_cubic_moment": str(new_value),
        "strict_gap": str(EXPECTED_GAP),
        "raw_axis_second_partials_checked": N * N,
        "radius_reduced_second_partials_checked": N * N,
        "general_tau_second_partials_checked": N * N,
        "raw_hessian_diagonal": [
            "3*sigma*r^2-a-6*b*r (multiplicity 1)",
            "sigma*r^2-a-3002*b*r/1001 (multiplicity 4)",
            "sigma*r^2-a+5998*b*r/1001 (multiplicity 9)",
        ],
        "reduced_hessian_diagonal": [
            "2*a+3*b*r (multiplicity 1)",
            "b*r/1001 (multiplicity 4)",
            "9001*b*r/1001 (multiplicity 9)",
        ],
        "tau_interval": "0 < tau < " + str(endpoint),
        "radial_identities": radial_report,
        "negative_controls": controls,
        "scope": (
            "exact algebraic replay of the unchanged witness, normalized tilt, "
            "moments and symbolic Hessians; the explicit rational companion has "
            "dedicated UniqueGeometry, UniqueMoments and UniqueDerivatives Lean "
            "modules whose verification is separate from this script; "
            "the general tau-family, selection principle and further radial "
            "extensions remain written results in UniqueMinimizer.md and "
            "RadialConsequences.md; these algebra checks do not formalize them"
        ),
    }
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
