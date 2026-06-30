# 11. Development Sprint Plan (June 28 – July 2)

This plan assumes a small team (3–5 members) working in parallel tracks. Adjust assignments based on actual headcount, but preserve the sequencing — later days depend on earlier foundational work being done first.

## 11.1 Day-by-Day Plan

| Day | Focus | Key Deliverables |
|---|---|---|
| Day 0 (Jun 28) | Setup & Kick-off | Firebase project created; Flutter project scaffolded with folder structure ([Sec 6.3](./06-system-architecture.md#63-flutter-project-structure)); Gemini API key provisioned; team roles assigned; Figma/wireframe pass on core screens |
| Day 1 (Jun 29) | Foundation | Firebase Auth (phone OTP) working; `seniorProfiles` + `trustedCircleMembers` CRUD; onboarding flow ([Sec 9.3.1](./09-ui-ux-guidelines.md#931-onboarding-flow-familyvolunteer-mode)) functional end-to-end |
| Day 2 (Jun 30) | Core Features Pt. 1 | Daily check-in flow ([Sec 9.3.2](./09-ui-ux-guidelines.md#932-daily-check-in-flow-senior-mode)) fully functional and writing to Firestore; `checkScamMessage` Cloud Function deployed and tested with sample messages |
| Day 3 (Jul 1) | Core Features Pt. 2 + Alerts | Scam checker UI ([Sec 9.3.3](./09-ui-ux-guidelines.md#933-scam-checker-flow-either-mode)) connected to function; alert system (missed check-in, scam detected) working with FCM push; family dashboard ([Sec 9.3.4](./09-ui-ux-guidelines.md#934-family-dashboard-familyvolunteer-mode)) showing live data |
| Day 4 AM (Jul 2) | Weekly Summary + Polish | `generateWeeklySummary` function tested (trigger manually for demo data); UI polish pass on senior mode screens for accessibility; bug fixes |
| Day 4 PM (Jul 2) | Submission Prep | Record 3-minute video; finalize one-page project document; clean up GitHub README; submit before deadline |

## 11.2 Suggested Team Role Split

| Role | Responsibilities |
|---|---|
| Flutter Lead (Senior Mode) | Onboarding UI, check-in flow, scam checker UI — all senior-facing accessible screens |
| Flutter Lead (Family Mode) | Family dashboard, Trusted Circle management, alert/notification center UI |
| Backend/Firebase Lead | Firestore schema setup, Cloud Functions (scam check, weekly summary, missed check-in), FCM integration |
| AI/Prompt Engineer | Gemini prompt tuning ([Sec 8.4](./08-api-specifications.md#84-gemini-api-prompt-specifications)), testing scam detection accuracy against sample PH scam messages, summary tone refinement |
| Documentation & Pitch Lead | One-pager, video script/recording, README, judge Q&A prep, SDG/theme alignment narrative |

> For teams smaller than 5, the AI/Prompt Engineer and Documentation roles can be merged, and the Backend Lead can absorb Family Mode UI if needed.

---

**Previous:** [10. Alerts & Notifications](./10-alerts-notifications.md) · **Next:** [12. Testing Strategy](./12-testing-strategy.md)
