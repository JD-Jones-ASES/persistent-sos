module

public import PersistentSOS.Localizers
public import PersistentSOS.Geometry
public import PersistentSOS.Derivatives

@[expose] public section
namespace PersistentSOS

/-- Every ordinary polynomial SOS lower bound satisfies the displayed quantitative bound. -/
theorem quantitative_sos_gap {σ a b γ : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hsos : IsSOS (quarticPoly σ a b - MvPolynomial.C γ)) :
    γ ≤ minimumValue σ a b - b * separation * minimizingRadius σ a b ^ 3 := by
  apply moment_quantitative_transfer sphereFunctional moment_one moment_q moment_q_sq
    ?_ moment_square_nonneg hσ ha hsos
  rw [moment_cubic]
  norm_num [separation]

/-- A strict gap holds for every positive regularization parameter and every
positive fixed quadratic and cubic strength. -/
theorem quantitative_sos_strict {σ a b γ : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hb : 0 < b) (hsos : IsSOS (quarticPoly σ a b - MvPolynomial.C γ)) :
    γ < minimumValue σ a b := by
  have h := quantitative_sos_gap hσ ha hsos
  have hr := minimizingRadius_pos hσ ha hb
  have hd := separation_pos
  have hp : 0 < b * separation * minimizingRadius σ a b ^ 3 := by positivity
  linarith

/-- The exact minimum shift is not a finite sum of squares of real polynomials. -/
theorem minimum_shift_not_sos {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) (hb : 0 < b) :
    ¬ IsSOS (quarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by
  intro h
  exact (lt_irrefl _) (quantitative_sos_strict hσ ha hb h)

/-- The exact minimum shift is globally nonnegative. -/
theorem minimum_shift_nonnegative {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hb : 0 < b) (z : Fin 14 → ℝ) :
    0 ≤ MvPolynomial.eval z
      (quarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by
  simpa only [map_sub, MvPolynomial.eval_C, sub_nonneg, objective]
    using objective_global_lower_bound hσ ha hb z

/-- Explicit persistent failure, including actual global optimality and attainment. -/
theorem persistent_failure {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) (hb : 0 < b) :
    (∀ z : Fin 14 → ℝ, minimumValue σ a b ≤ objective σ a b z) ∧
    objective σ a b (axis (minimizingRadius σ a b)) = minimumValue σ a b ∧
    ¬ IsSOS (quarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) :=
  ⟨objective_global_lower_bound hσ ha hb, objective_axis_attainment hσ ha,
    minimum_shift_not_sos hσ ha hb⟩

/-- The finite certificate is a functional on ordinary real polynomials, positive
on every quadratic square, with normalized radial moments and a strict cubic gap. -/
theorem sphere_moment_gap : ∃ L : Poly →ₗ[ℝ] ℝ,
    L 1 = 1 ∧ L qPoly = 1 ∧ L (qPoly^2) = 1 ∧
    (∀ h : Poly, h.totalDegree ≤ 2 → 0 ≤ L (h^2)) ∧
    (∀ h : Poly, h.totalDegree ≤ 2 → L ((qPoly-1)*h) = 0) ∧
    L cubicPoly = 500753357629 / 500000000000 :=
  ⟨sphereFunctional, moment_one, moment_q, moment_q_sq, moment_square_nonneg, moment_sphere_localizer, moment_cubic⟩

end PersistentSOS
