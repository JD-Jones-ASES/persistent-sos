/-
Copyright (c) 2026 JD Jones. All rights reserved.
Released under the MIT license as described in the file LICENSE.
-/
module

public import PersistentSOS.Definitions
public import PersistentSOS.SOSDegree
public import Mathlib.Algebra.MvPolynomial.PDeriv

@[expose] public section

namespace PersistentSOS
open MvPolynomial
open scoped BigOperators

/-- Substitution of a common real scale in every polynomial variable. -/
noncomputable def scalePoly (r : ℝ) : Poly →ₐ[ℝ] Poly :=
  MvPolynomial.aeval (fun i => MvPolynomial.C r * MvPolynomial.X i)

@[simp] theorem scalePoly_C (r c : ℝ) : scalePoly r (MvPolynomial.C c) = MvPolynomial.C c := by
  simp [scalePoly]

@[simp] theorem scalePoly_X (r : ℝ) (i : Fin 14) :
    scalePoly r (MvPolynomial.X i) = MvPolynomial.C r * MvPolynomial.X i := by
  simp [scalePoly]

/-- Common scaling cannot increase total degree. -/
theorem totalDegree_scalePoly_le (r : ℝ) (p : Poly) :
    (scalePoly r p).totalDegree ≤ p.totalDegree := by
  classical
  nth_rw 1 [p.as_sum]
  rw [map_sum]
  apply totalDegree_finsetSum_le
  intro d hd
  apply le_trans ?_ (le_totalDegree hd)
  rw [scalePoly, aeval_monomial]
  apply (totalDegree_mul _ _).trans
  simp only [algebraMap_eq, totalDegree_C, zero_add, Finsupp.prod, Finsupp.sum]
  apply (totalDegree_finsetProd _ _).trans
  apply Finset.sum_le_sum
  intro i hi
  apply (totalDegree_pow _ _).trans
  have h := totalDegree_mul (MvPolynomial.C r : Poly) (MvPolynomial.X i)
  simp only [totalDegree_C, totalDegree_X, zero_add] at h
  simpa using Nat.mul_le_mul_left (d i) h

@[simp] theorem scalePoly_qPoly (r : ℝ) :
    scalePoly r qPoly = MvPolynomial.C (r ^ 2) * qPoly := by
  simp [qPoly, map_sum, mul_pow, Finset.mul_sum]

@[simp] theorem scalePoly_cubicPoly (r : ℝ) :
    scalePoly r cubicPoly = MvPolynomial.C (r ^ 3) * cubicPoly := by
  simp only [cubicPoly, map_add, map_sub, map_mul, map_pow, map_ofNat, scalePoly_X,
    scalePoly_C]
  ring

/-- The quartic, quadratic, and cubic terms scale with their literal degrees. -/
theorem scalePoly_quarticPoly (r σ a b : ℝ) :
    scalePoly r (quarticPoly σ a b) =
      MvPolynomial.C (σ / 4 * r ^ 4) * qPoly ^ 2 -
      MvPolynomial.C (a / 2 * r ^ 2) * qPoly -
      MvPolynomial.C (b * r ^ 3) * cubicPoly := by
  simp only [quarticPoly, map_sub, map_mul, map_pow, scalePoly_C,
    scalePoly_qPoly, scalePoly_cubicPoly]
  ring

/-- Degree of the squared Euclidean norm polynomial. -/
theorem totalDegree_qPoly_le : qPoly.totalDegree ≤ 2 := by
  apply totalDegree_finsetSum_le
  intro i hi
  simp

set_option maxHeartbeats 2000000 in
/-- The displayed 25-term cubic has total degree at most three. -/
theorem totalDegree_cubicPoly_le : cubicPoly.totalDegree ≤ 3 := by
  have hcX (k : Poly) (hk : k.totalDegree = 0) (i : Fin 14) :
      (k * X i).totalDegree ≤ 1 := by
    simpa [hk] using totalDegree_mul k (X i)
  have hcXX (k : Poly) (hk : k.totalDegree = 0) (i j : Fin 14) :
      (k * X i * X j).totalDegree ≤ 2 := by
    have hm := totalDegree_mul (k * X i) (X j)
    have hx := hcX k hk i
    simp only [totalDegree_X] at hm
    omega
  have hcXsq (k : Poly) (hk : k.totalDegree = 0) (i j : Fin 14) :
      (k * X i * X j ^ 2).totalDegree ≤ 3 := by
    have hm := totalDegree_mul (k * X i) (X j ^ 2)
    have hx := hcX k hk i
    simp only [totalDegree_X_pow] at hm
    omega
  have hcXXX (k : Poly) (hk : k.totalDegree = 0) (i j l : Fin 14) :
      (k * X i * X j * X l).totalDegree ≤ 3 := by
    have hm := totalDegree_mul (k * X i * X j) (X l)
    have hx := hcXX k hk i j
    simp only [totalDegree_X] at hm
    omega
  have hnum : (3 : Poly).totalDegree = 0 := by
    rw [← map_ofNat MvPolynomial.C 3, totalDegree_C]
  unfold cubicPoly
  repeat' first
    | apply (totalDegree_add _ _).trans; apply max_le
    | apply (totalDegree_sub _ _).trans; apply max_le
  all_goals first
    | simp
    | exact hcXsq _ (totalDegree_C _) _ _
    | exact hcXsq _ hnum _ _
    | exact hcXXX _ (totalDegree_C _) _ _ _


/-- The objective is a quartic polynomial for all parameter values. -/
theorem totalDegree_quarticPoly_le (σ a b : ℝ) : (quarticPoly σ a b).totalDegree ≤ 4 := by
  unfold quarticPoly
  apply (totalDegree_sub _ _).trans
  apply max_le
  · apply (totalDegree_sub _ _).trans
    apply max_le
    · apply (totalDegree_mul _ _).trans
      simp only [totalDegree_C, zero_add]
      exact (totalDegree_pow _ _).trans (by have := totalDegree_qPoly_le; omega)
    · apply (totalDegree_mul _ _).trans
      simp only [totalDegree_C, zero_add]
      exact totalDegree_qPoly_le.trans (by decide)
  · apply (totalDegree_mul _ _).trans
    simp only [totalDegree_C, zero_add]
    exact totalDegree_cubicPoly_le.trans (by decide)


/-- Subtracting a real lower bound preserves the quartic degree bound. -/
theorem totalDegree_shiftedQuartic_le (σ a b γ : ℝ) :
    (quarticPoly σ a b - MvPolynomial.C γ).totalDegree ≤ 4 := by
  exact (totalDegree_sub _ _).trans (max_le (totalDegree_quarticPoly_le σ a b) (by simp))

end PersistentSOS
