module

public import Mathlib

/-!
# Persistent failure of Euclidean quartic SOS exactness

The cubic below is explicit. All polynomials have real coefficients, and SOS
means an unrestricted finite sum of polynomial squares. The minimizing radius
and exact minimum are literal formulas. The principal theorem quantifies over
all positive real regularization, quadratic and cubic parameters.
-/

@[expose] public section
namespace PersistentSOS
open MvPolynomial


/-- Ordinary real multivariate polynomials in fourteen variables. -/
abbrev Poly := MvPolynomial (Fin 14) ℝ

/-- The squared Euclidean norm polynomial, the sum of all coordinate squares. -/
noncomputable def qPoly : Poly := ∑ i, MvPolynomial.X i ^ 2

/-- The fixed sparse rational cubic, in coordinate order `(t,x₁,…,x₄,y₁,…,y₉)`. -/
noncomputable def cubicPoly : Poly :=
  MvPolynomial.X 0 ^ 3
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 5 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 6 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 7 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 8 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 9 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 10 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 11 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 12 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 13 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 1 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 2 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 3 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 4 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 5 * MvPolynomial.X 1 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 6 * MvPolynomial.X 2 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 7 * MvPolynomial.X 3 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 8 * MvPolynomial.X 1 * MvPolynomial.X 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 8 * MvPolynomial.X 3 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 9 * MvPolynomial.X 1 * MvPolynomial.X 3
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 9 * MvPolynomial.X 2 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 10 * MvPolynomial.X 2 * MvPolynomial.X 3
  + MvPolynomial.C (1813 / 500) * MvPolynomial.X 11 * MvPolynomial.X 1 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 12 * MvPolynomial.X 2 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 13 * MvPolynomial.X 3 * MvPolynomial.X 4

/-- Evaluation of the squared Euclidean norm polynomial at a real vector. -/
noncomputable def Q (z : Fin 14 → ℝ) : ℝ := MvPolynomial.eval z qPoly
/-- Evaluation of the fixed cubic polynomial at a real vector. -/
noncomputable def C (z : Fin 14 → ℝ) : ℝ := MvPolynomial.eval z cubicPoly
/-- Euclidean radius, written as the square root of the sum of coordinate squares. -/
noncomputable def radius (z : Fin 14 → ℝ) : ℝ := Real.sqrt (Q z)

/-- Ordinary SOS: a finite sum of squares of arbitrary real polynomials. -/
def IsSOS (p : Poly) : Prop :=
  ∃ (m : ℕ) (f : Fin m → Poly), p = ∑ i, (f i) ^ 2

/-- Euclidean quartic regularization with quadratic coefficient -a/2 and cubic -bC. -/
noncomputable def quarticPoly (σ a b : ℝ) : Poly :=
  MvPolynomial.C (σ / 4) * qPoly ^ 2 - MvPolynomial.C (a / 2) * qPoly
    - MvPolynomial.C b * cubicPoly

/-- The real-valued function obtained by evaluating the quartic polynomial. -/
noncomputable def objective (σ a b : ℝ) (z : Fin 14 → ℝ) : ℝ :=
  MvPolynomial.eval z (quarticPoly σ a b)

/-- The point on the distinguished coordinate axis with first coordinate `r`. -/
def axis (r : ℝ) : Fin 14 → ℝ := fun i => if i = 0 then r else 0


/-- Positive minimizing radius for quartic regularization with negative quadratic
strength `a` and positive cubic strength `b`. -/
noncomputable def minimizingRadius (σ a b : ℝ) : ℝ :=
  (3 * b + Real.sqrt (9 * b ^ 2 + 4 * a * σ)) / (2 * σ)

/-- Exact minimum, once the cubic has sphere maximum one. -/
noncomputable def minimumValue (σ a b : ℝ) : ℝ :=
  -(b * minimizingRadius σ a b ^ 3 + a * minimizingRadius σ a b ^ 2) / 4


/-- A second literal rational cubic selecting the positive first coordinate axis. -/
noncomputable def uniqueCubicPoly : Poly :=
  MvPolynomial.C (1 / 1001) * (1000 * cubicPoly + MvPolynomial.X 0 * qPoly)

/-- Evaluation of the cubic with a unique sphere maximizer. -/
noncomputable def uniqueCubic (z : Fin 14 → ℝ) : ℝ := MvPolynomial.eval z uniqueCubicPoly

/-- Quartic regularization using the cubic with a unique sphere maximizer. -/
noncomputable def uniqueQuarticPoly (σ a b : ℝ) : Poly :=
  MvPolynomial.C (σ / 4) * qPoly ^ 2 - MvPolynomial.C (a / 2) * qPoly
    - MvPolynomial.C b * uniqueCubicPoly

/-- Evaluation of the quartic with a unique global minimizer. -/
noncomputable def uniqueObjective (σ a b : ℝ) (z : Fin 14 → ℝ) : ℝ :=
  MvPolynomial.eval z (uniqueQuarticPoly σ a b)

/-- The strict rational moment separation for the selected cubic. -/
noncomputable def uniqueSeparation : ℝ := 132860603 / 143000000000

/-- Exact strict gap between the moment value and sphere maximum. -/
noncomputable def separation : ℝ := 753357629 / 500000000000

theorem radius_eq_norm (z : Fin 14 → ℝ) :
    radius z = ‖(WithLp.toLp 2 z : EuclideanSpace ℝ (Fin 14))‖ := by sorry

theorem cubic_abs_le (z : Fin 14 → ℝ) : |C z| ≤ radius z ^ 3 := by sorry

theorem unit_sphere_attainment : Q (axis 1) = 1 ∧ C (axis 1) = 1 := by sorry

theorem cubic_unit_maximizers_coordinates (z : Fin 14 → ℝ) (hQ : Q z = 1) :
    C z = 1 ↔ (z 1 = 0 ∧ z 2 = 0 ∧ z 3 = 0 ∧ z 4 = 0) ∧
      (z 0 = 1 ∨ z 0 = -1 / 2) := by sorry

theorem objective_all_minimizers {σ a b : ℝ} (hσ : 0 < σ)
    (ha : 0 < a) (hb : 0 < b) (z : Fin 14 → ℝ) :
    objective σ a b z = minimumValue σ a b ↔
      Q z = minimizingRadius σ a b ^ 2 ∧
      (z 1 = 0 ∧ z 2 = 0 ∧ z 3 = 0 ∧ z 4 = 0) ∧
      (z 0 = minimizingRadius σ a b ∨ z 0 = -minimizingRadius σ a b / 2) := by sorry

theorem persistent_failure {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) (hb : 0 < b) :
    (∀ z : Fin 14 → ℝ, minimumValue σ a b ≤ objective σ a b z) ∧
    objective σ a b (axis (minimizingRadius σ a b)) = minimumValue σ a b ∧
    ¬ IsSOS (quarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by sorry

theorem minimum_shift_nonnegative {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hb : 0 < b) (z : Fin 14 → ℝ) :
    0 ≤ MvPolynomial.eval z
      (quarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by sorry

theorem quantitative_sos_gap {σ a b γ : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hsos : IsSOS (quarticPoly σ a b - MvPolynomial.C γ)) :
    γ ≤ minimumValue σ a b - b * separation * minimizingRadius σ a b ^ 3 := by sorry

theorem sphere_moment_gap : ∃ L : Poly →ₗ[ℝ] ℝ,
    L 1 = 1 ∧ L qPoly = 1 ∧ L (qPoly^2) = 1 ∧
    (∀ h : Poly, h.totalDegree ≤ 2 → 0 ≤ L (h^2)) ∧
    (∀ h : Poly, h.totalDegree ≤ 2 → L ((qPoly-1)*h) = 0) ∧
    L cubicPoly = 500753357629 / 500000000000 := by sorry

theorem stationary_origin (σ a b : ℝ) (i : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv i (quarticPoly σ a b)) = 0 := by sorry

theorem hessian_origin (σ a b : ℝ) (i j : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv j (pderiv i (quarticPoly σ a b))) =
      if i = j then -a else 0 := by sorry

theorem qPoly_definition : qPoly = ∑ i : Fin 14, MvPolynomial.X i ^ 2 := by sorry

theorem cubicPoly_definition : cubicPoly =
  MvPolynomial.X 0 ^ 3
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 5 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 6 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 7 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 8 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 9 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 10 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 11 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 12 ^ 2
  - 3 * MvPolynomial.X 0 * MvPolynomial.X 13 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 1 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 2 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 3 ^ 2
  + MvPolynomial.C (3 / 2) * MvPolynomial.X 0 * MvPolynomial.X 4 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 5 * MvPolynomial.X 1 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 6 * MvPolynomial.X 2 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 7 * MvPolynomial.X 3 ^ 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 8 * MvPolynomial.X 1 * MvPolynomial.X 2
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 8 * MvPolynomial.X 3 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 9 * MvPolynomial.X 1 * MvPolynomial.X 3
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 9 * MvPolynomial.X 2 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 10 * MvPolynomial.X 2 * MvPolynomial.X 3
  + MvPolynomial.C (1813 / 500) * MvPolynomial.X 11 * MvPolynomial.X 1 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 12 * MvPolynomial.X 2 * MvPolynomial.X 4
  + MvPolynomial.C (259 / 100) * MvPolynomial.X 13 * MvPolynomial.X 3 * MvPolynomial.X 4 := by sorry

theorem sos_definition (p : Poly) : IsSOS p ↔
    ∃ (m : ℕ) (f : Fin m → Poly), p = ∑ i, (f i)^2 := by sorry

theorem quarticPoly_definition (σ a b : ℝ) : quarticPoly σ a b =
    MvPolynomial.C (σ/4)*qPoly^2 - MvPolynomial.C (a/2)*qPoly -
      MvPolynomial.C b*cubicPoly := by sorry

theorem objective_definition (σ a b : ℝ) (z : Fin 14 → ℝ) :
    objective σ a b z = MvPolynomial.eval z (quarticPoly σ a b) := by sorry

theorem minimizingRadius_definition (σ a b : ℝ) : minimizingRadius σ a b =
    (3*b + Real.sqrt (9*b^2+4*a*σ))/(2*σ) := by sorry

theorem minimumValue_definition (σ a b : ℝ) : minimumValue σ a b =
    -(b*minimizingRadius σ a b^3+a*minimizingRadius σ a b^2)/4 := by sorry

theorem separation_definition : separation = 753357629 / 500000000000 := by sorry

theorem unique_cubic_abs_le (z : Fin 14 → ℝ) : |uniqueCubic z| ≤ radius z ^ 3 := by sorry

theorem unique_cubic_unit_maximizer (z : Fin 14 → ℝ) (hQ : Q z = 1) :
    uniqueCubic z = 1 ↔ z = axis 1 := by sorry

theorem unique_objective_minimizer {σ a b : ℝ} (hσ : 0 < σ)
    (ha : 0 < a) (hb : 0 < b) (z : Fin 14 → ℝ) :
    uniqueObjective σ a b z = minimumValue σ a b ↔
      z = axis (minimizingRadius σ a b) := by sorry

theorem unique_persistent_failure {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) (hb : 0 < b) :
    (∀ z : Fin 14 → ℝ, minimumValue σ a b ≤ uniqueObjective σ a b z) ∧
    (∀ z : Fin 14 → ℝ, uniqueObjective σ a b z = minimumValue σ a b ↔
      z = axis (minimizingRadius σ a b)) ∧
    Matrix.PosDef (fun i j : Fin 14 =>
      MvPolynomial.eval (axis (minimizingRadius σ a b))
        (MvPolynomial.pderiv j (MvPolynomial.pderiv i (uniqueQuarticPoly σ a b)))) ∧
    ¬ IsSOS (uniqueQuarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by sorry

theorem unique_minimum_shift_nonnegative {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hb : 0 < b) (z : Fin 14 → ℝ) :
    0 ≤ MvPolynomial.eval z
      (uniqueQuarticPoly σ a b - MvPolynomial.C (minimumValue σ a b)) := by sorry

theorem unique_quantitative_sos_gap {σ a b γ : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hsos : IsSOS (uniqueQuarticPoly σ a b - MvPolynomial.C γ)) :
    γ ≤ minimumValue σ a b - b * uniqueSeparation * minimizingRadius σ a b ^ 3 := by sorry

theorem unique_sphere_moment_gap : ∃ L : Poly →ₗ[ℝ] ℝ,
    L 1 = 1 ∧ L qPoly = 1 ∧ L (qPoly ^ 2) = 1 ∧
    (∀ h : Poly, h.totalDegree ≤ 2 → 0 ≤ L (h ^ 2)) ∧
    (∀ h : Poly, h.totalDegree ≤ 2 → L ((qPoly - 1) * h) = 0) ∧
    L cubicPoly = 500753357629 / 500000000000 ∧
    L (X 0) = 423308963 / 1000000000 ∧
    L uniqueCubicPoly = 143132860603 / 143000000000 := by sorry

theorem unique_stationary_origin (σ a b : ℝ) (i : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv i (uniqueQuarticPoly σ a b)) = 0 := by sorry

theorem unique_hessian_origin (σ a b : ℝ) (i j : Fin 14) :
    eval (0 : Fin 14 → ℝ) (pderiv j (pderiv i (uniqueQuarticPoly σ a b))) =
      if i = j then -a else 0 := by sorry

theorem unique_hessian_minimizer {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (i j : Fin 14) :
    eval (axis (minimizingRadius σ a b))
      (pderiv j (pderiv i (uniqueQuarticPoly σ a b))) =
      if i = j then
        (if i = 0 then 2 * a + 3 * b * minimizingRadius σ a b
         else if i.val ≤ 4 then b * minimizingRadius σ a b / 1001
         else 9001 * b * minimizingRadius σ a b / 1001)
      else 0 := by sorry

theorem unique_hessian_posDef {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) (hb : 0 < b) :
    Matrix.PosDef (fun i j : Fin 14 =>
      eval (axis (minimizingRadius σ a b))
        (pderiv j (pderiv i (uniqueQuarticPoly σ a b)))) := by sorry

theorem uniqueCubicPoly_definition : uniqueCubicPoly =
    MvPolynomial.C (1 / 1001) * (1000 * cubicPoly + MvPolynomial.X 0 * qPoly) := by sorry

theorem uniqueCubic_definition (z : Fin 14 → ℝ) :
    uniqueCubic z = MvPolynomial.eval z uniqueCubicPoly := by sorry

theorem uniqueQuarticPoly_definition (σ a b : ℝ) : uniqueQuarticPoly σ a b =
    MvPolynomial.C (σ / 4) * qPoly ^ 2 - MvPolynomial.C (a / 2) * qPoly
      - MvPolynomial.C b * uniqueCubicPoly := by sorry

theorem uniqueObjective_definition (σ a b : ℝ) (z : Fin 14 → ℝ) :
    uniqueObjective σ a b z = MvPolynomial.eval z (uniqueQuarticPoly σ a b) := by sorry

theorem uniqueSeparation_definition : uniqueSeparation = 132860603 / 143000000000 := by sorry

end PersistentSOS
