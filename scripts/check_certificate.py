"""Authenticate the exact rational sphere moments and algebraic inputs.

No SDP solver, floating point, numerical sampling, or assertions are used.
The written proof supplies AM-GM, Cauchy-Schwarz, the scalar sphere bound,
and the all-sigma radial transfer. See VERIFICATION.md for the exact boundary.
"""

from collections import defaultdict
from fractions import Fraction as F
from functools import cache
from hashlib import sha256
from itertools import combinations_with_replacement
from pathlib import Path
from time import perf_counter
import json


N = 14
CHARS = (0, 1, 2, 4, 7, 0, 0, 0, 3, 5, 6, 6, 5, 3)
DENOMINATOR = 10**9
VALUE = F(500753357629, 500000000000)
CERTIFICATE = Path(__file__).resolve().parents[1] / "certificates/sphere-moments.json"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def rejected(callback, label):
    try:
        callback()
    except ValueError:
        return label
    raise ValueError("negative control accepted: " + label)


def monomials(degree):
    return combinations_with_replacement(range(N), degree)


def character(monomial):
    out = 0
    for i in monomial:
        out ^= CHARS[i]
    return out


def product(left, right):
    return tuple(sorted(left + right))


def add(*polynomials):
    out = defaultdict(F)
    for polynomial in polynomials:
        for m, c in polynomial.items():
            out[m] += c
    return {m: c for m, c in out.items() if c}


def scale(polynomial, coefficient):
    return {m: c * coefficient for m, c in polynomial.items() if c * coefficient}


def multiply(left, right):
    out = defaultdict(F)
    for m, a in left.items():
        for k, b in right.items():
            out[product(m, k)] += a * b
    return {m: c for m, c in out.items() if c}


def quadratic_map():
    return (
        {(1, 1): F(1)}, {(2, 2): F(1)}, {(3, 3): F(1)},
        {(1, 2): F(1), (3, 4): F(1)},
        {(1, 3): F(1), (2, 4): F(1)},
        {(2, 3): F(1)}, {(1, 4): F(7, 5)},
        {(2, 4): F(1)}, {(3, 4): F(1)},
    )


def cubic():
    out = {(0, 0, 0): F(1)}
    out.update({(0, j, j): F(3, 2) for j in range(1, 5)})
    out.update({(0, j, j): F(-3) for j in range(5, N)})
    for j, component in enumerate(quadratic_map(), start=5):
        out = add(out, multiply({(j,): F(259, 100)}, component))
    require(len(out) == 25, "cubic monomial count")
    require(all(len(m) == 3 and character(m) == 0 for m in out),
            "cubic degree or symmetry")
    return out


def algebra_checks():
    norm_x = {(i, i): F(1) for i in range(1, 5)}
    contraction = add(multiply(norm_x, norm_x),
                      *[scale(multiply(q, q), -1) for q in quadratic_map()])
    choi_lam = {(1, 1, 2, 2): F(1), (1, 1, 3, 3): F(1),
                (2, 2, 3, 3): F(1), (4, 4, 4, 4): F(1),
                (1, 2, 3, 4): F(-4)}
    require(contraction == add(choi_lam, {(1, 1, 4, 4): F(1, 25)}),
            "quadratic contraction identity")
    require(F(259, 100) > 0 and F(259, 100)**2 < F(27, 4),
            "cross coefficient enclosure")
    # 1-(3v-4v^3)=(v+1)(2v-1)^2, written with variable index 0.
    factor = multiply({(): F(1), (0,): F(1)},
                      {(0, 0): F(4), (0,): F(-4), (): F(1)})
    require(factor == {(): F(1), (0,): F(-3), (0, 0, 0): F(4)},
            "Chebyshev factorization")
    require(cubic()[(0, 0, 0)] == 1, "sharp sphere witness t=1")
    return {"cubic_monomials": 25, "q_components": 9,
            "cross_square_margin": str(F(27, 4) - F(259, 100)**2)}


def load_certificate(path=CERTIFICATE):
    data = json.loads(path.read_text())
    require(data.get("schema") == "persistent-sos-sphere-moments-v1", "certificate schema")
    require(data.get("dimension") == N and tuple(data.get("characters", ())) == CHARS,
            "dimension or character action")
    require(data.get("denominator") == DENOMINATOR, "certificate denominator")
    require(data.get("eliminate_square_variable") == 0, "sphere elimination variable")
    require(data.get("objective") == str(VALUE), "recorded objective")
    rows = data.get("moments", [])
    free = {}
    for row in rows:
        require(isinstance(row, list) and len(row) == 2, "moment row format")
        m, numerator = row
        require(isinstance(m, list) and all(type(i) is int and 0 <= i < N for i in m),
                "moment variable index")
        m = tuple(m)
        require(m == tuple(sorted(m)) and len(m) <= 4 and m.count(0) <= 1,
                "noncanonical or unreduced monomial")
        require(character(m) == 0 and type(numerator) is int, "moment character or numerator")
        require(m not in free, "duplicate moment")
        free[m] = numerator
    expected = {m for d in range(5) for m in monomials(d)
                if character(m) == 0 and m.count(0) <= 1}
    require(set(free) == expected and len(free) == 450, "moment coverage")
    return free


def functional(free):
    """Integer numerator of L; use t^2=1-sum_{j=1}^{13}z_j^2."""
    require(free.get(()) == DENOMINATOR, "L(1) must equal one")

    @cache
    def moment(m):
        require(len(m) <= 4 and m == tuple(sorted(m)), "moment degree/order")
        if character(m):
            return 0
        if m.count(0) < 2:
            return free[m]
        rest = list(m)
        rest.remove(0)
        rest.remove(0)
        rest = tuple(rest)
        return moment(rest) - sum(moment(product(rest, (j, j))) for j in range(1, N))

    return moment


def check_sphere(moment):
    count = 0
    for d in range(3):
        for m in monomials(d):
            require(moment(m) == sum(moment(product(m, (j, j))) for j in range(N)),
                    "sphere localizer failed at " + str(m))
            count += 1
    require(moment(()) == DENOMINATOR, "normalization")
    return count


def positive_integer_matrix(matrix):
    """Sylvester criterion, with exact division via fraction-free elimination.

    At step k the pivot is the leading (k+1)-minor of the original integer
    matrix. Positive pivots prove positive definiteness. No pivoting or
    tolerance is used; every division is checked for zero remainder.
    """
    size = len(matrix)
    require(size > 0 and all(len(row) == size for row in matrix), "matrix shape")
    require(all(matrix[i][j] == matrix[j][i] for i in range(size) for j in range(size)),
            "matrix symmetry")
    work = [list(row) for row in matrix]
    previous = 1
    pivots = []
    for k in range(size):
        pivot = work[k][k]
        require(pivot > 0, f"nonpositive leading minor at {k}")
        pivots.append(pivot)
        for i in range(k + 1, size):
            for j in range(i, size):
                numerator = work[i][j] * pivot - work[i][k] * work[k][j]
                entry, remainder = divmod(numerator, previous)
                require(remainder == 0, "nonexact fraction-free division")
                work[i][j] = work[j][i] = entry
        previous = pivot
    return pivots


def moment_matrices(moment):
    full_basis = tuple(m for d in range(3) for m in monomials(d))
    basis = tuple(m for m in full_basis if m != (0, 0))
    indices = {m: i for i, m in enumerate(basis)}
    reduced = [[moment(product(u, v)) for v in basis] for u in basis]
    full = [[moment(product(u, v)) for v in full_basis] for u in full_basis]
    rows = []
    for m in full_basis:
        if m == (0, 0):
            rows.append({indices[()]: 1, **{indices[(j, j)]: -1 for j in range(1, N)}})
        else:
            rows.append({indices[m]: 1})
    # Check every entry of M_full=T M_quotient T^T, not merely a submatrix.
    for i, row_i in enumerate(rows):
        for j, row_j in enumerate(rows):
            value = sum(a * b * reduced[k][ell]
                        for k, a in row_i.items() for ell, b in row_j.items())
            require(full[i][j] == value, "full/quotient congruence")
    blocks = defaultdict(list)
    for i, m in enumerate(basis):
        blocks[character(m)].append(i)
    for i, u in enumerate(basis):
        for j, v in enumerate(basis):
            if character(u) != character(v):
                require(reduced[i][j] == 0, "nonzero cross-character block")
    reports = []
    for ch, indices_in_block in blocks.items():
        matrix = [[reduced[i][j] for j in indices_in_block] for i in indices_in_block]
        pivots = positive_integer_matrix(matrix)
        reports.append({"character": ch, "size": len(matrix),
                        "positive_leading_minors": len(pivots),
                        "determinant_decimal_digits": len(str(pivots[-1]))})
    require(sum(r["size"] for r in reports) == 119 and len(full_basis) == 120,
            "moment matrix dimensions")
    return reports


def objective(moment):
    return sum((c * F(moment(m), DENOMINATOR) for m, c in cubic().items()), F(0))


def check_gap(value, bound=F(1)):
    require(value > bound, "functional does not exceed asserted sphere bound")


def negative_controls(free, moment):
    bad_moment = dict(free)
    bad_moment[(1, 1)] = -DENOMINATOR
    bad_normalization = dict(free)
    bad_normalization[()] += 1
    return [
        rejected(lambda: positive_integer_matrix([[1, 2], [2, 1]]),
                 "indefinite matrix with positive diagonal"),
        rejected(lambda: moment_matrices(functional(bad_moment)),
                 "negative second moment"),
        rejected(lambda: functional(bad_normalization), "wrong normalization"),
        rejected(lambda: check_sphere(lambda m: moment(m) + (1 if m == (0, 0) else 0)),
                 "perturbed sphere relation"),
        rejected(lambda: check_gap(objective(moment), F(501, 500)),
                 "unsupported separation at larger bound 501/500"),
        rejected(lambda: check_gap(-objective(moment)), "reversed cubic objective"),
    ]


def main():
    start = perf_counter()
    free = load_certificate()
    moment = functional(free)
    algebra = algebra_checks()
    localizers = check_sphere(moment)
    blocks = moment_matrices(moment)
    value = objective(moment)
    require(value == VALUE, "exact objective value")
    check_gap(value)
    controls = negative_controls(free, moment)
    report = {
        "status": "EXACT_CHECKS_PASS", "dimension": N,
        "certificate_sha256": sha256(CERTIFICATE.read_bytes()).hexdigest(),
        "free_moments": len(free), "sphere_localizers": localizers,
        "full_matrix_size": 120, "quotient_matrix_size": 119,
        "positive_definite_blocks": blocks, "algebra": algebra,
        "sphere_bound": "1", "moment_value": str(value), "strict_gap": str(value - 1),
        "negative_controls": controls,
        "elapsed_seconds": round(perf_counter() - start, 4),
        "scope": "locked rational certificate authenticated exactly; analytic proof supplies sphere and all-sigma transfers",
    }
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
