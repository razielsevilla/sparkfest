# 12. Testing Strategy

## 12.1 Test Scenarios — Scam Checker

Critical: test the scam checker against realistic Filipino scam message samples before the demo, since this feature is judged most heavily on "Technology Implementation" (25 points) and "Problem Understanding."

| Test Input (sample) | Expected Result |
|---|---|
| "Congratulations! Nanalo ka ng P50,000 sa GCash raffle. I-claim mo agad, i-reply ang OTP mo." | `riskLevel: Mataas` (OTP request + prize scam pattern) |
| "Lola, ito si Apo, nawalan ako ng wallet, pakipadala ng pera sa number na ito agad." | `riskLevel: Mataas` (grandparent/apo impersonation pattern) |
| "Your PhilHealth contribution is due. Please pay before the deadline at your local office." | `riskLevel: Mababa` (legitimate-style reminder, no red flags, but should note it cannot verify official sources) |
| "Invest now sa crypto, guaranteed 30% return sa isang linggo lang!" | `riskLevel: Mataas` (investment scam pattern, unrealistic returns) |
| "Hi Mama, send mo na lang sa akin yung listahan ng gamot mo bukas." | `riskLevel: Mababa` (ordinary family message, no scam indicators) |

## 12.2 Functional Test Checklist

- [ ] Senior profile can be created with all required fields
- [ ] Trusted Circle member can be added and receives a test push notification
- [ ] Check-in submission saves correctly and updates `lastCheckInDate`
- [ ] Duplicate check-in on the same day overwrites rather than duplicates
- [ ] Scam checker returns a result within 5 seconds for a typical message length
- [ ] High-risk scam result triggers an alert visible to all Trusted Circle members
- [ ] Missed check-in alert fires after 2 days of no check-in (test with manipulated date or manual trigger)
- [ ] Weekly summary generates correctly with at least 1, and with 0, check-ins in the week (edge case)
- [ ] App functions on a mid-range Android device (not just emulator) before demo day
- [ ] All senior-facing text is in Filipino and renders correctly (no encoding issues with ñ, special characters)

## 12.3 Non-Functional / Usability Testing

- Conduct at least one walkthrough with a non-technical person simulating a senior user — observe where they hesitate or get confused
- Test app on a throttled/slow network connection to simulate rural connectivity
- Verify font sizes and tap targets meet the [Section 9.2](./09-ui-ux-guidelines.md#92-color--typography) specifications on an actual device screen, not just in code

---

**Previous:** [11. Sprint Plan](./11-sprint-plan.md) · **Next:** [13. Submission Checklist](./13-submission-checklist.md)
