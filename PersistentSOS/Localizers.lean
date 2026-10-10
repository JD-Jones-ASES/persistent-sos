/-
Copyright (c) 2026 JD Jones. All rights reserved.
Released under the MIT license as described in the file LICENSE.
-/
module

public import PersistentSOS.Moments
public import PersistentSOS.Polynomial

/-! # The full truncated sphere relation

The sphere relation annihilates every polynomial of degree at most two.
This follows from positivity and its zero square, without enumerating
individual localizer equations.
-/

@[expose] public section
namespace PersistentSOS
open MvPolynomial

/-- A null square of a positive truncated functional is orthogonal to
every other polynomial in its domain of quadratic-square positivity. -/
theorem mul_eq_zero_of_square_eq_zero (L : Poly →ₗ[ℝ] ℝ)
    (hL : ∀ p : Poly, p.totalDegree ≤ 2 → 0 ≤ L (p ^ 2))
    (h k : Poly) (hh : h.totalDegree ≤ 2) (hk : k.totalDegree ≤ 2)
    (hk0 : L (k ^ 2) = 0) : L (k * h) = 0 := by
  have hscale (c : ℝ) (p : Poly) : L (MvPolynomial.C c * p) = c * L p := by
    rw [← MvPolynomial.smul_eq_C_mul, map_smul, smul_eq_mul]
  have hpos (t : ℝ) : 0 ≤ L (h ^ 2) + 2 * t * L (k * h) := by
    have hd : (h + MvPolynomial.C t * k).totalDegree ≤ 2 := by
      apply (totalDegree_add _ _).trans
      apply max_le hh
      apply (totalDegree_mul _ _).trans
      simpa only [totalDegree_C, zero_add] using hk
    have he : (h + MvPolynomial.C t * k) ^ 2 =
        h ^ 2 + MvPolynomial.C (2 * t) * (k * h) + MvPolynomial.C (t ^ 2) * k ^ 2 := by
      simp only [map_mul, map_pow, map_ofNat]
      ring
    have hp := hL _ hd
    rw [he] at hp
    simpa only [map_add, hscale, hk0, mul_zero, add_zero] using hp
  by_contra hn
  have hv : L (h ^ 2) + 2 * (-(L (h ^ 2) + 1) / (2 * L (k * h))) * L (k * h) = -1 := by
    field_simp
    ring
  have hp := hpos (-(L (h ^ 2) + 1) / (2 * L (k * h)))
  rw [hv] at hp
  norm_num at hp

/-- The sphere relation has zero square under the exact moment functional. -/
theorem moment_sphere_relation_square : sphereFunctional ((qPoly - 1) ^ 2) = 0 := by
  have he : (qPoly - 1) ^ 2 = qPoly ^ 2 - (2 : ℝ) • qPoly + 1 := by
    rw [MvPolynomial.smul_eq_C_mul]
    simp only [map_ofNat]
    ring
  rw [he]
  simp only [map_add, map_sub, map_smul, smul_eq_mul, moment_q_sq, moment_q, moment_one]
  norm_num

/-- All sphere localizer identities through degree four, for arbitrary
quadratic multipliers. -/
theorem moment_sphere_localizer (h : Poly) (hh : h.totalDegree ≤ 2) :
    sphereFunctional ((qPoly - 1) * h) = 0 := by
  apply mul_eq_zero_of_square_eq_zero sphereFunctional moment_square_nonneg h (qPoly - 1)
    hh _ moment_sphere_relation_square
  exact (totalDegree_sub _ _).trans (max_le totalDegree_qPoly_le (by simp))

end PersistentSOS
