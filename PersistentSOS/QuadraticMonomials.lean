/-
Copyright (c) 2026 JD Jones. All rights reserved.
Released under the MIT license as described in the file LICENSE.
-/
module

public import Mathlib.Data.Finsupp.Multiset
public import Mathlib.Tactic

public section
namespace PersistentSOS

/-- Every monomial of total degree at most two is constant, a variable,
or a product of two variables (allowing a repeated variable). -/
theorem exponent_degree_le_two {σ : Type*} (d : σ →₀ ℕ)
    (h : d.sum (fun _ n => n) ≤ 2) :
    d = 0 ∨ (∃ i, d = Finsupp.single i 1) ∨
      (∃ i j, d = Finsupp.single i 1 + Finsupp.single j 1) := by
  classical
  have hc : d.toMultiset.card ≤ 2 := by simpa only [Finsupp.card_toMultiset, Function.id_def] using h
  interval_cases hcard : d.toMultiset.card
  · left
    have hm : d.toMultiset = 0 := Multiset.card_eq_zero.mp hcard
    have := congrArg Multiset.toFinsupp hm
    simpa using this
  · right; left
    obtain ⟨i, hi⟩ := Multiset.card_eq_one.mp hcard
    refine ⟨i, ?_⟩
    have := congrArg Multiset.toFinsupp hi
    simpa using this
  · right; right
    obtain ⟨i, j, hij⟩ := Multiset.card_eq_two.mp hcard
    refine ⟨i, j, ?_⟩
    have := congrArg Multiset.toFinsupp hij
    simpa [← Multiset.singleton_add, map_add] using this

end PersistentSOS
