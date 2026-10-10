module

public import PersistentSOS.Definitions
public import PersistentSOS.Radial
public import PersistentSOS.SOSDegree
public import PersistentSOS.Polynomial
public import PersistentSOS.Sphere

@[expose] public section

namespace PersistentSOS

/-- The strict rational separation of the fixed cubic from its sphere bound. -/
noncomputable def separation : ℝ := 753357629 / 500000000000

theorem separation_pos : 0 < separation := by norm_num [separation]

/-- An abstract linear-separation calculation, used with a separately verified
ordinary moment functional. The public explicit theorem supplies that witness. -/
theorem functional_separation (L : Poly →ₗ[ℝ] ℝ)
    (h1 : L 1 = 1) (hQ : L qPoly = 1) (hQQ : L (qPoly ^ 2) = 1)
    (hC : L cubicPoly = 1 + separation) (σ a b r γ : ℝ) :
    L (MvPolynomial.C (σ / 4 * r^4) * qPoly^2 -
       MvPolynomial.C (a / 2 * r^2) * qPoly -
       MvPolynomial.C (b*r^3) * cubicPoly - MvPolynomial.C γ) =
      radialValue σ a b r - b * separation * r^3 - γ := by
  have hscale (c : ℝ) (p : Poly) : L (MvPolynomial.C c * p) = c * L p := by
    rw [← MvPolynomial.smul_eq_C_mul, map_smul, smul_eq_mul]
  have hconst (c : ℝ) : L (MvPolynomial.C c) = c := by
    simpa [h1] using hscale c 1
  simp only [map_sub, hscale, hconst, hQ, hQQ, hC]
  unfold radialValue
  ring

/-- Positivity for an ordinary quartic SOS, after any common coordinate scaling. -/
theorem scaled_sos_nonneg (L : Poly →ₗ[ℝ] ℝ)
    (hL : ∀ h : Poly, h.totalDegree ≤ 2 → 0 ≤ L (h^2))
    {p : Poly} (hp : p.totalDegree ≤ 4) (hsos : IsSOS p) (r : ℝ) :
    0 ≤ L (scalePoly r p) := by
  rcases hsos with ⟨m,f,hf⟩
  rw [hf, map_sum, map_sum]
  apply Finset.sum_nonneg
  intro i hi
  rw [map_pow]
  exact hL _ ((totalDegree_scalePoly_le r (f i)).trans
    (quartic_sos_summand_degree hp hf i))

/-- Exact global lower bound for every positive parameter. -/
theorem objective_global_lower_bound {σ a b : ℝ} (hσ : 0 < σ)
    (ha : 0 < a) (hb : 0 < b) (z : Fin 14 → ℝ) :
    minimumValue σ a b ≤ objective σ a b z := by
  have hc := (le_abs_self (C z)).trans (cubic_abs_le z)
  have hscaled := mul_le_mul_of_nonneg_left hc (le_of_lt hb)
  have hrad := radial_global_minimum hσ ha hb (radius_nonneg z)
  rw [objective_eq]
  rw [← radius_sq z]
  unfold radialValue at hrad
  nlinarith

/-- The distinguished axis point attains the exact global minimum. -/
theorem objective_axis_attainment {σ a b : ℝ} (hσ : 0 < σ) (ha : 0 < a) :
    objective σ a b (axis (minimizingRadius σ a b)) = minimumValue σ a b := by
  rw [objective_eq, Q_axis, C_axis]
  convert radial_at_minimizingRadius (b := b) hσ ha using 1
  unfold radialValue
  ring

/-- The abstract moment-to-SOS transfer. The explicit theorem below instantiates
all witness hypotheses by exact certificate proofs. -/
theorem moment_quantitative_transfer (L : Poly →ₗ[ℝ] ℝ)
    (h1 : L 1 = 1) (hQ : L qPoly = 1) (hQQ : L (qPoly^2) = 1)
    (hC : L cubicPoly = 1 + separation)
    (hL : ∀ h : Poly, h.totalDegree ≤ 2 → 0 ≤ L (h^2))
    {σ a b γ : ℝ} (hσ : 0 < σ) (ha : 0 < a)
    (hsos : IsSOS (quarticPoly σ a b - MvPolynomial.C γ)) :
    γ ≤ minimumValue σ a b - b * separation * minimizingRadius σ a b ^ 3 := by
  have hn := scaled_sos_nonneg L hL (totalDegree_shiftedQuartic_le σ a b γ)
    hsos (minimizingRadius σ a b)
  rw [map_sub, scalePoly_C, scalePoly_quarticPoly] at hn
  rw [functional_separation L h1 hQ hQQ hC, radial_at_minimizingRadius hσ ha] at hn
  linarith

end PersistentSOS
