# 7. Data Model

All collections live in Firestore (NoSQL document store). Below are the core collections, their fields, and relationships.

## 7.1 Entity Relationship Overview

```
SeniorProfile (1) ──< (many) TrustedCircleMember
SeniorProfile (1) ──< (many) CheckIn
SeniorProfile (1) ──< (many) ScamCheck
SeniorProfile (1) ──< (many) WeeklySummary
SeniorProfile (1) ──< (many) Alert
TrustedCircleMember (1) ──< (many) Alert  [recipient]
```

## 7.2 Collection: `seniorProfiles`

| Field | Type | Description | Notes |
|---|---|---|---|
| id | string | Document ID | Auto-generated |
| fullName | string | Senior's full name | Required |
| age | number | Senior's age | Required |
| photoUrl | string? | Profile photo | Optional, Firebase Storage URL |
| barangay | string | Barangay/city of residence | Required, used for OSCA matching |
| primaryContactPhone | string | Main contact's phone | Required |
| pinCode | string? | Optional simplified PIN for senior access | 4-digit, optional |
| createdAt | timestamp | Record creation time | Auto |
| lastCheckInDate | timestamp? | Most recent check-in | Used for missed check-in alert logic |

## 7.3 Collection: `trustedCircleMembers`

| Field | Type | Description | Notes |
|---|---|---|---|
| id | string | Document ID | Auto-generated |
| seniorProfileId | string | Reference to seniorProfiles | Foreign key |
| name | string | Member's name | Required |
| relationship | string | e.g. Anak, Apo, Volunteer | Required |
| phoneNumber | string | Used for Firebase Auth + FCM | Required |
| fcmToken | string? | Push notification device token | Set on login |
| role | string | "family" or "volunteer" | Used for UI labeling only in V1 |

## 7.4 Collection: `checkIns`

| Field | Type | Description | Notes |
|---|---|---|---|
| id | string | Document ID | Auto-generated |
| seniorProfileId | string | Reference to seniorProfiles | Foreign key |
| date | string | YYYY-MM-DD | One check-in per date per senior |
| mood | string | Masaya / Okay lang / Malungkot | Enum, required |
| activities | array<string> | Selected activity tags | Optional, multi-select |
| note | string? | Free text or transcribed voice note | Optional, max 280 chars |
| voiceNoteUrl | string? | Audio file URL | Optional, Firebase Storage |
| createdAt | timestamp | Submission time | Auto |

## 7.5 Collection: `scamChecks`

| Field | Type | Description | Notes |
|---|---|---|---|
| id | string | Document ID | Auto-generated |
| seniorProfileId | string | Reference to seniorProfiles | Foreign key |
| submittedBy | string | trustedCircleMemberId or "self" | Who submitted the check |
| rawMessageText | string | Message content checked | Encrypted at rest; purge after 30 days |
| senderNumber | string? | Phone number/sender if available | Optional |
| riskLevel | string | Mataas / Katamtaman / Mababa | Gemini-generated |
| reasoning | string | Plain-language explanation | Gemini-generated |
| recommendedAction | string | What the user should do next | Gemini-generated |
| createdAt | timestamp | Check time | Auto |

## 7.6 Collection: `weeklySummaries`

| Field | Type | Description | Notes |
|---|---|---|---|
| id | string | Document ID | Auto-generated |
| seniorProfileId | string | Reference to seniorProfiles | Foreign key |
| weekStartDate | string | YYYY-MM-DD (Monday) | Used to fetch correct check-in range |
| summaryText | string | Gemini-generated summary | Filipino/Taglish, 3–4 sentences |
| moodTrend | string | Improving / Stable / Declining | Derived from check-in moods |
| generatedAt | timestamp | Generation time | Auto, via Cloud Function |

## 7.7 Collection: `alerts`

| Field | Type | Description | Notes |
|---|---|---|---|
| id | string | Document ID | Auto-generated |
| seniorProfileId | string | Reference to seniorProfiles | Foreign key |
| type | string | scam_detected / missed_checkin / mood_decline | Enum |
| message | string | Notification body text | Filipino, human-readable |
| recipientIds | array<string> | trustedCircleMember IDs notified | All active circle members by default |
| relatedDocId | string? | scamCheckId or checkInId if applicable | Links alert to source data |
| createdAt | timestamp | Alert creation time | Auto |
| resolved | boolean | Whether a circle member acknowledged it | Default false |

---

**Previous:** [6. System Architecture](./06-system-architecture.md) · **Next:** [8. API & Service Specifications](./08-api-specifications.md)