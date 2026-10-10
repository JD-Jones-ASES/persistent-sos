/-
Copyright (c) 2026 JD Jones. All rights reserved.
Released under the MIT license as described in the file LICENSE.
-/
module

public import PersistentSOS.UniqueGeometry
public import PersistentSOS.UniqueMoments
public import PersistentSOS.UniqueDerivatives

@[expose] public section
namespace PersistentSOS

/-- The selected quartic's exact minimum shift is globally nonnegative. -/
theorem unique_minimum_shift_nonnegative {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hb : 0 < b) (z : Fin 14 → ℝ) :
    0 ≤ MvPolynomial.eval z
      (uniqueQuarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by
  simpa only [map_sub, MvPolynomial.eval_C, sub_nonneg, uniqueObjective]
    using unique_objective_global_lower_bound hσ ha hb z

/-- Persistent ordinary-SOS failure with a unique global minimizer and
positive-definite Hessian there, for every positive real parameter. -/
theorem unique_persistent_failure {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) (hb : 0 < b) :
    (∀ z : Fin 14 → ℝ, minimumValue σ a b ≤ uniqueObjective σ a b z) ∧
    (∀ z : Fin 14 → ℝ, uniqueObjective σ a b z = minimumValue σ a b ↔
      z = axis (minimizingRadius σ a b)) ∧
    Matrix.PosDef (fun i j : Fin 14 =>
      MvPolynomial.eval (axis (minimizingRadius σ a b))
        (MvPolynomial.pderiv j (MvPolynomial.pderiv i (uniqueQuarticPoly σ a b)))) ∧
    ¬ IsSOS (uniqueQuarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) :=
  ⟨unique_objective_global_lower_bound hσ ha hb,
    unique_objective_minimizer hσ ha hb, unique_hessian_posDef hσ ha hb,
    unique_minimum_shift_not_sos hσ ha hb⟩

end PersistentSOS
