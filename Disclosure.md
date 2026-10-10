# Production and review

OpenAI Codex assisted with the mathematical construction, proof development,
exact rational certificate generation, Lean formalization, source review and
documentation. Numerical semidefinite optimization guided discovery of the
moment witness. Its numerical output is not a proof premise.

The retained witness consists of rational data. Two independent Python
implementations replay its moment identities and positivity by different
exact-arithmetic methods. Lean verifies the algebraic certificate and the
analytic argument; its proof does not trust a Python exit status.

Separate Codex agents review the ordinary-polynomial semantics, analytic
bounds, finite certificate and formal interfaces. These are automated internal
reviews. No human specialist review is asserted. JD Jones is the responsible
human maintainer. Exact source, toolchain and independent-kernel verification
records belong in [VERIFICATION.md](VERIFICATION.md).
