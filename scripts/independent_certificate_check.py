"""Independent rational audit of the persistent-SOS moment witness.

Run ``python3 scripts/independent_certificate_check.py``. This audit uses exponent
vectors and rational Schur complements, independently of the primary replay's
monomial tuples and fraction-free elimination. It checks a supplied witness;
it does not run an SDP or certify that its objective is optimal.
"""
from __future__ import annotations

import argparse
from copy import deepcopy
from fractions import Fraction as F
from functools import lru_cache
from itertools import combinations_with_replacement
import json
from pathlib import Path

N = 14
CHARS = (0, 1, 2, 4, 7, 0, 0, 0, 3, 5, 6, 6, 5, 3)
CERTIFICATE = Path(__file__).resolve().parents[1] / "certificates/sphere-moments.json"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def exponent(monomial: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(monomial.count(i) for i in range(N))


def monomials(max_degree: int):
    for degree in range(max_degree + 1):
        yield from combinations_with_replacement(range(N), degree)


def add(a, b):
    return tuple(x + y for x, y in zip(a, b))


def character(a):
    result = 0
    for i, power in enumerate(a):
        if power % 2:
            result ^= CHARS[i]
    return result


def quadratic_map():
    return [
        {(1, 1): F(1)},
        {(2, 2): F(1)},
        {(3, 3): F(1)},
        {(1, 2): F(1), (3, 4): F(1)},
        {(1, 3): F(1), (2, 4): F(1)},
        {(2, 3): F(1)},
        {(1, 4): F(7, 5)},
        {(2, 4): F(1)},
        {(3, 4): F(1)},
    ]


def cubic():
    result = {(0, 0, 0): F(1)}
    result.update({(0, j, j): F(3, 2) for j in range(1, 5)})
    result.update({(0, j, j): F(-3) for j in range(5, N)})
    for j, component in enumerate(quadratic_map()):
        for monomial, coefficient in component.items():
            result[tuple(sorted((5 + j,) + monomial))] = F(259, 100) * coefficient
    return result


def check_contraction_identity():
    """Expand X^2-|q|^2 and check it equals Choi--Lam plus a square.

    The analytic nonnegativity of Choi--Lam is the four-term AM--GM argument
    in Proof.md. This check authenticates the exact polynomial to which that
    argument applies; it is not itself a numerical nonnegativity test.
    """
    result = {}

    def put(monomial, coefficient):
        monomial = tuple(sorted(monomial))
        result[monomial] = result.get(monomial, F(0)) + coefficient

    for i in range(1, 5):
        for j in range(1, 5):
            put((i, i, j, j), F(1))
    for component in quadratic_map():
        for m, c in component.items():
            for k, d in component.items():
                put(m + k, -c * d)
    result = {m: c for m, c in result.items() if c}
    expected = {
        (1, 1, 2, 2): F(1), (1, 1, 3, 3): F(1),
        (2, 2, 3, 3): F(1), (4, 4, 4, 4): F(1),
        (1, 2, 3, 4): F(-4), (1, 1, 4, 4): F(1, 25),
    }
    require(result == expected, "quadratic-map contraction identity fails")
    require(F(259, 100) > 0 and F(259, 100) ** 2 < F(27, 4),
            "suspension coefficient order fails")


def rational_schur_pd(matrix):
    """Check positive definiteness by successive exact Schur complements."""
    a = [row[:] for row in matrix]
    for k in range(len(a)):
        pivot = a[k][k]
        require(pivot > 0, f"nonpositive rational Schur pivot at index {k}")
        for i in range(k + 1, len(a)):
            for j in range(i, len(a)):
                a[i][j] -= a[i][k] * a[k][j] / pivot
                a[j][i] = a[i][j]


def verify(data):
    require(data["dimension"] == N, "dimension mismatch")
    require(data["schema"] == "persistent-sos-sphere-moments-v1", "schema mismatch")
    require(tuple(data["characters"]) == CHARS, "character mismatch")
    require(data["eliminate_square_variable"] == 0, "elimination mismatch")
    denominator = data["denominator"]
    require(isinstance(denominator, int) and denominator > 0, "bad denominator")
    free = {}
    for raw_monomial, numerator in data["moments"]:
        m = tuple(raw_monomial)
        require(len(m) <= 4 and all(isinstance(i, int) and 0 <= i < N for i in m),
                "invalid free monomial")
        require(m == tuple(sorted(m)), "unsorted free monomial")
        a = exponent(m)
        require(a not in free, "duplicate free moment")
        require(isinstance(numerator, int), "noninteger numerator")
        free[a] = F(numerator, denominator)
    expected = {exponent(m) for m in monomials(4)
                if m.count(0) <= 1 and character(exponent(m)) == 0}
    require(set(free) == expected, "free-moment coverage mismatch")

    @lru_cache(None)
    def moment(a):
        if character(a):
            return F(0)
        if a[0] <= 1:
            return free[a]
        base = list(a)
        base[0] -= 2
        result = moment(tuple(base))
        for j in range(1, N):
            other = base.copy()
            other[j] += 2
            result -= moment(tuple(other))
        return result

    basis = [exponent(m) for m in monomials(2)]
    for a in basis:
        total = F(0)
        for j in range(N):
            b = list(a)
            b[j] += 2
            total += moment(tuple(b))
        require(total == moment(a), "truncated sphere identity fails")
    zero = (0,) * N
    require(moment(zero) == 1, "normalization fails")

    # Verify the actual full moment matrix is R C R^T. The quotient basis
    # omits only t^2; its row in R is 1 - sum_{j=1}^{13} z_j^2. Thus PSD on
    # the quotient certifies every quadratic polynomial, not just selected
    # quadratic monomials. The checks below cover all 120^2 Gram entries.
    def reduction(a):
        if a[0] < 2:
            return {a: 1}
        require(a[0] == 2 and sum(a) == 2, "unexpected basis reduction")
        out = {zero: 1}
        for j in range(1, N):
            b = [0] * N
            b[j] = 2
            out[tuple(b)] = -1
        return out

    reductions = {a: reduction(a) for a in basis}
    for a in basis:
        for b in basis:
            reconstructed = sum(c * d * moment(add(u, v))
                                for u, c in reductions[a].items()
                                for v, d in reductions[b].items())
            require(moment(add(a, b)) == reconstructed,
                    "full-matrix quotient congruence fails")

    blocks = {}
    for a in basis:
        if a[0] < 2:
            blocks.setdefault(character(a), []).append(a)
    for sign, block in blocks.items():
        matrix = [[moment(add(a, b)) for b in block] for a in block]
        rational_schur_pd(matrix)
        for other_sign, other_block in blocks.items():
            if other_sign != sign:
                require(all(moment(add(a, b)) == 0 for a in block for b in other_block),
                        "nonzero cross-character Gram entry")

    polynomial = cubic()
    value = sum(c * moment(exponent(m)) for m, c in polynomial.items())
    require(value > 1, "strict gap fails")
    require(str(value) == data["objective"], "objective metadata mismatch")
    check_contraction_identity()
    return {
        "dimension": N, "cubic_terms": len(polynomial),
        "sphere_identities": len(basis), "congruence_entries": len(basis) ** 2,
        "quotient_basis": sum(map(len, blocks.values())),
        "pd_block_dimensions": sorted(map(len, blocks.values())),
        "free_moments": len(free), "objective": str(value),
        "gap": str(value - 1), "contraction_identity": True,
    }


def negative_controls(data):
    bad_normalization = deepcopy(data)
    bad_normalization["moments"][0][1] += 1
    bad_psd = deepcopy(data)
    target = next(entry for entry in bad_psd["moments"]
                  if entry[0] == [0, 1, 1])
    target[1] *= 10
    bad_objective = deepcopy(data)
    bad_objective["objective"] = "1"
    results = []
    for label, bad, expected_reason in [
        ("normalization", bad_normalization, "normalization"),
        ("psd", bad_psd, "Schur pivot"),
        ("objective", bad_objective, "objective metadata"),
    ]:
        try:
            verify(bad)
        except ValueError as error:
            require(expected_reason in str(error), f"wrong control failure for {label}")
            results.append({"control": label, "rejected": str(error)})
        else:
            raise ValueError(f"negative control accepted: {label}")
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--certificate", type=Path, default=CERTIFICATE)
    parser.add_argument("--negative-controls", action="store_true")
    args = parser.parse_args()
    data = json.loads(args.certificate.read_text())
    result = verify(data)
    if args.negative_controls:
        result["negative_controls"] = negative_controls(data)
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
