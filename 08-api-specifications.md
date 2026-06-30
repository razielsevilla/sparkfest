# 8. API & Service Specifications

Since the backend is Firebase, most "API calls" are direct Firestore SDK reads/writes from Flutter rather than REST endpoints. Cloud Functions are used only where server-side logic (scheduling, Gemini calls) is required. This section documents both.

## 8.1 Cloud Function: `checkScamMessage`

| Field | Detail |
|---|---|
| Trigger | HTTPS callable function, invoked from Flutter when user submits the scam checker form |
| Input | `{ seniorProfileId: string, messageText: string, senderNumber?: string, submittedBy: string }` |
| Process | 1) Validate input. 2) Call Gemini API with scam-detection prompt (see 8.4). 3) Parse structured response. 4) Write to `scamChecks` collection. 5) If `riskLevel == "Mataas"`, create an alert document and trigger FCM push. |
| Output | `{ riskLevel: string, reasoning: string, recommendedAction: string, scamCheckId: string }` |
| Error handling | If Gemini API fails or times out (>8s), return `riskLevel: "Katamtaman"` with a generic caution message as a safe fallback — never fail silently on a potential scam check |

## 8.2 Cloud Function: `generateWeeklySummary`

| Field | Detail |
|---|---|
| Trigger | Scheduled function, runs every Sunday at 18:00 Asia/Manila time, iterates over all active `seniorProfiles` |
| Process | 1) Query `checkIns` for the senior for the past 7 days. 2) Build structured prompt with mood/activity/note data. 3) Call Gemini API (see 8.4). 4) Write result to `weeklySummaries`. 5) Send FCM notification to all Trusted Circle members. |
| Output | Writes a `weeklySummaries` document; no direct return value (background job) |
| Edge case | If senior had zero check-ins that week, generate a gentle "we haven't heard much this week" summary rather than skipping — this itself is a meaningful signal to family |

## 8.3 Cloud Function: `checkMissedCheckIns`

| Field | Detail |
|---|---|
| Trigger | Scheduled function, runs daily at 20:00 Asia/Manila time |
| Process | 1) Query all `seniorProfiles`. 2) For each, compare `lastCheckInDate` to today. 3) If gap ≥ 2 days, create an alert (type: `missed_checkin`) and push to Trusted Circle. 4) Avoid duplicate alerts — only fire once per missed-checkin streak, not daily. |
| Output | Writes alert documents as needed; background job |

## 8.4 Gemini API Prompt Specifications

These prompt templates are the core "logic" of the AI features. Treat them as living documents — refine wording during testing based on actual output quality, but preserve the structure (system instruction + structured output format) so responses remain parseable.

### 8.4.1 Scam Detection Prompt

```
SYSTEM INSTRUCTION:
You are a scam-detection assistant for a Filipino senior citizen safety app
called Gabay Sr. You analyze SMS messages, social media messages, or call
transcripts to determine if they are likely scams targeting Filipino seniors.

Common scam patterns to check for:
- Requests for OTP, PIN, or bank account details
- "Apo" / grandchild-in-distress impersonation scams
- Fake NCSC/DSWD pension or benefit announcements
- Investment schemes promising high guaranteed returns
- Romance scams with requests for money
- Urgency and fear tactics ("your account will be locked")
- Prizes/lottery winnings requiring an upfront fee
- Fake delivery/courier notifications with suspicious links

Respond ONLY in this exact JSON format, no other text:
{
  "riskLevel": "Mataas" | "Katamtaman" | "Mababa",
  "reasoning": "<1-2 sentence explanation in simple Filipino/Taglish>",
  "recommendedAction": "<1 short, clear instruction in Filipino>"
}

USER INPUT:
Message: "{{messageText}}"
Sender number (if available): "{{senderNumber}}"
```

### 8.4.2 Weekly Companionship Summary Prompt

```
SYSTEM INSTRUCTION:
You are a warm, caring assistant generating a weekly summary of a Filipino
senior citizen's wellbeing for their family members, who may live far away
(including overseas/OFW family). Write in a warm, conversational Filipino
or Taglish tone, as if a caring friend is giving the family an update.

Guidelines:
- 3 to 4 sentences only
- Highlight positive moments first
- Gently mention any days with low mood or missed check-ins, without alarm
- Do not use clinical or robotic language
- If there were zero check-ins this week, say so gently and suggest the
  family reach out directly

Respond ONLY in this exact JSON format, no other text:
{
  "summaryText": "<3-4 sentence warm summary in Filipino/Taglish>",
  "moodTrend": "Improving" | "Stable" | "Declining"
}

USER INPUT:
Senior's name: {{fullName}}
This week's check-ins (date, mood, activities, note):
{{checkInDataAsList}}
```

### 8.4.3 Implementation Notes for Developers

- Use the Gemini API's structured/JSON output mode if available in the SDK version used, to avoid manual parsing of free-text responses
- Always wrap Gemini calls in a try/catch; never let a failed AI call block the check-in or scam-check flow entirely — fall back to a safe default response
- Log raw Gemini responses during development to a debug collection to quickly catch formatting drift before the demo
- Keep API keys out of the Flutter client — all Gemini calls must go through Cloud Functions, never called directly from the mobile app

---

**Previous:** [7. Data Model](./07-data-model.md) · **Next:** [9. UI/UX Design Guidelines](./09-ui-ux-guidelines.md)