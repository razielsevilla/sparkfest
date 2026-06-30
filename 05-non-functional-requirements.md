# 5. Non-Functional Requirements

| Category | Requirement | Rationale |
|---|---|---|
| Usability | All senior-facing screens must use font size ≥18sp, high-contrast colors, and icon-first navigation | Low digital literacy; 38% are "basic" digital users |
| Performance | Check-in submission and scam check must return a result in <5 seconds on a mid-range Android device | Demo reliability; rural connectivity is often slow |
| Localization | All senior-facing UI text in Filipino by default; Gemini prompts must produce Filipino/Taglish output | Target users are predominantly Filipino-first speakers |
| Reliability | Core check-in and alert features must work even with degraded connectivity (basic local caching) | Provincial/barangay connectivity is inconsistent |
| Security & Privacy | Scam-checked message content encrypted in transit and at rest; auto-purge after 30 days | Sensitive personal/financial data passes through the scam checker |
| Accessibility | Support for voice input on check-in as an alternative to typing | Many seniors have limited literacy or fine motor difficulty typing |
| Maintainability | Codebase organized by feature module (see [6. System Architecture](./06-system-architecture.md)) to allow parallel development by multiple team members | 4-day build with a small team requires clean parallelization |

---

**Previous:** [4. Functional Requirements](./04-functional-requirements.md) · **Next:** [6. System Architecture](./06-system-architecture.md)