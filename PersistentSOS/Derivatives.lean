module

public import PersistentSOS.Definitions
public import Mathlib.Algebra.MvPolynomial.PDeriv

@[expose] public section
namespace PersistentSOS
open MvPolynomial

theorem cubic_first_at_zero (i : Fin 14) : eval (0 : Fin 14 → ℝ) (pderiv i cubicPoly) = 0 := by
  simp [cubicPoly]

theorem cubic_second_at_zero (i j : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv j (pderiv i cubicPoly)) = 0 := by
  simp [cubicPoly]

theorem q_first (i : Fin 14) : pderiv i qPoly = 2 * X i := by
  simp [qPoly, Pi.single_apply, mul_ite]

theorem stationary_origin (σ a b : ℝ) (i : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv i (quarticPoly σ a b)) = 0 := by
  have hc : constantCoeff (pderiv i cubicPoly) = 0 := by simpa using cubic_first_at_zero i
  have hq : constantCoeff qPoly = 0 := by simp [qPoly]
  simp [quarticPoly, q_first, hc, hq]

theorem hessian_origin (σ a b : ℝ) (i j : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv j (pderiv i (quarticPoly σ a b))) =
      if i = j then -a else 0 := by
  have hc : constantCoeff (pderiv j (pderiv i cubicPoly)) = 0 := by
    simpa using cubic_second_at_zero i j
  have hq : constantCoeff qPoly = 0 := by simp [qPoly]
  have htwo : constantCoeff (2 : Poly) = 2 := by
    rw [← map_ofNat MvPolynomial.C 2]
    simp
  simp [quarticPoly, q_first, hc, hq, Pi.single_apply, htwo]
  split_ifs <;> simp_all

end PersistentSOS
