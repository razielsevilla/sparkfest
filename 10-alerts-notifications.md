# 10. Alert & Notification Logic

This section consolidates the trigger conditions and message templates for all push notifications, so backend and frontend teams stay in sync.

| Alert Type | Trigger Condition | Notification Message Template (Filipino) |
|---|---|---|
| `scam_detected` | Scam checker returns `riskLevel = Mataas` | "⚠️ Mataas na panganib! May mensaheng natanggap si [Name] na posibleng scam. I-tap para makita ang detalye." |
| `missed_checkin` | No check-in for 2+ consecutive days | "Walang check-in mula kay [Name] sa nakaraang 2 araw. Maaari mo siyang tawagan para malaman kung ayos lang siya." |
| `mood_decline` | 3+ consecutive "Malungkot" check-ins | "Si [Name] ay parang malungkot nitong huling mga araw. Maaaring makatulong kung dadalawin o tatawagan mo siya." |
| `weekly_summary` | Scheduled, every Sunday | "Na-update na ang weekly summary ni [Name]. I-tap para basahin." |

> **Note on tone:** All notification copy should read as if from a caring assistant, never alarmist or clinical, even for high-risk alerts — the goal is urgency without panic.

---

**Previous:** [9. UI/UX Design Guidelines](./09-ui-ux-guidelines.md) · **Next:** [11. Sprint Plan](./11-sprint-plan.md)